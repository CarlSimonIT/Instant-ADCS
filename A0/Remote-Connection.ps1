#requires -PSEdition Desktop
#requires -Version 5.1
#requires -Modules @{ModuleName='Hyper-V';ModuleVersion='2.0.0.0'}


[CmdletBinding()]
param (
  [Parameter(
    Mandatory = $true,
    Position = 0,
    HelpMessage = "DNS CNAME of the guest OS within the Hyper-V VM. Must match the pattern `${regex literal DNS CNAME}"
  )]
  [Alias('cname')]
  [ValidatePattern(
    '^[a-z0-9_-]{1,63}$'
  )]
  [System.String]
  $ConfigTargetCname,

  [Parameter(
    Mandatory = $true,
    Position = 1,
    HelpMessage = "Name of entry in the Credential Manager"
  )]
  [Alias('cme')]
  [ValidateScript(
    {
      $HT = @{
        Target      = $_
        Type        = 'Generic'
        Verbose     = $false
        ErrorAction = 'Stop'
      }
      $pw = Get-StoredCredential @HT | Select-Object -ExpandProperty 'Password'
      $null -ne $pw
    }
  )]
  [System.String]
  $CredentialManagerEntry,

  [Parameter(Mandatory = $false, HelpMessage = "Seconds between attempts to connect via PowerShell Direct")][System.UInt32]$RetryIntervalSec = 30,
  [Parameter(Mandatory = $false, HelpMessage = "Total attempts to connect via PowerShell Direct")][System.UInt32]$RetryCount = 10,
  [Parameter(Mandatory = $false, HelpMessage = "Figure out a way to incorporate this into into the command")][System.UInt32]$ThrottleLimit = 32
)


$StartTime = [System.DateTime]::Now
#$Host.PrivateData.VerboseForegroundColor = [System.ConsoleColor]::DarkBlue
$Host.PrivateData.VerboseForegroundColor = $(rFc)
#$Host.PrivateData.VerboseBackgroundColor = $(rBc)
Write-Verbose -Message "Function $($PSCmdlet.MyInvocation.InvocationName) commenced at $($StartTime)."

<#
  $ConfigTargetCname = $DomainCtrl00Cname
  $ConfigTargetCname = $DhcpServer00Cname
  $ConfigTargetCname = $RootCAServerCname
  $ConfigTargetCname = ${Web PKI m0qap5 Cname}
  $ConfigTargetCname = ${Leaf CA1 Server Cname}

  $CredentialManagerEntry = "$ConfigTargetCname 544"
#>


${begin_Profile Load} = [System.DateTime]::Now
${Verbose Preference at Time of Command Invocation} = $VerbosePreference
$VerbosePreference = 'Continue'
$VerboseOutput = (
  . "$env:WinDir\System32\WindowsPowerShell\v1.0\profile.ps1"
) 4>&1
$VerbosePreference = ${Verbose Preference at Time of Command Invocation}
${end_Profile Load} = [System.DateTime]::Now
$ts = ${end_Profile Load} - ${begin_Profile Load}
Write-Verbose -Message "Profile Load Duration: $($ts.Minutes)m$($ts.Seconds)s"


# I realize this is horrible error handling, but i just need to get powershell remoting sessions
# to connect without worrying about whether the target VM exists. 
$_Var_Name = 'Redirected Error'
try {Clear-Variable -Name $_Var_Name -ErrorAction 'Stop'} catch {New-Variable -Name $_Var_Name -Value $null}

${Redirected Error} = $(
  Get-VM -VMName ([qcc]::VM($ConfigTargetCname)) | Out-Null
) 2>&1
<#
  trap [Microsoft.HyperV.PowerShell.VirtualizationException] {
    Write-Host -Object "`tVM with `$VMName = $([qcc]::VM($ConfigTargetCname)) is not defined..."
    continue
  }
#>

if (${Redirected Error} -eq $null) {
  $TargetVmName = [QuickCnameConversions]::VM($ConfigTargetCname)
  $TargetComputerName = [QuickCnameConversions]::CN($ConfigTargetCname)
  Write-Verbose -Message "VMName = $TargetVmName `t `$TargetComputerName = $TargetComputerName"
  #Write-Verbose -Message "VMName = $([QuickCnameConversions]::VM($ConfigTargetCname)) `t `$TargetComputerName = $([QuickCnameConversions]::CN($ConfigTargetCname))"

  $loop0 = 'EstablishConnection'
  $loop1 = 'ConfirmComputerNameUpdated'
  $loop2 = 'Executeprofiledotps1'
  Purge-DownedPowerShellRemotingSessions.ps1 > $null

  :outer while ($true) {
    Purge-DownedPowerShellRemotingSessions.ps1 > $null

    # Condition that terminates the 'EstablishConnection' loop is the 
    # creation of a variable with Name = $SessionName and the corresponding 
    # PowerShell Remoting session object assigned as the Value. 
    Write-Verbose -Message "Launching the '$loop0' loop."
    :EstablishConnection while ($true) {
      Purge-DownedPowerShellRemotingSessions.ps1 > $null

      Write-Verbose -Message "`$CredentialManagerEntry = $CredentialManagerEntry"
      # Uncover the TYPE of the username's account. 
      ${UserName Type} = switch -Regex ($CredentialManagerEntry) {
        ${regex literal non-Domain Windows UserName} {
          Write-Output -InputObject 'Non-Domain Windows UserName'
          break
        }
        "^${regex literal AD Domain NetBIOS Name (Anchorless)}\\${regex literal SamAccountName of User Account in Active Directory (Anchorless)}`$" {
          Write-Output -InputObject 'Pre-2000 Domain Windows UserName'
          break
        }
        "^${regex literal UPN Prefix (Anchorless)}@${regex literal UPN Suffix (Anchorless)}`$" {
          Write-Output -InputObject 'User Principal Name'
          break
        }
        default {
          Write-Output -InputObject 'Non-Domain Windows UserName'
          break
        }
      }
      Write-Verbose -Message "`${UserName Type} = ${UserName Type}"

      # The account's username TYPE is now known.
      # However, there are sub-types to the 'Non-Domain Windows UserName' type.
      # Need to find that specific sub-type in order to calculate $UserName
      # This is as good of a point as any to calculate the appropriate credential needed
      ${Authentication Credential} = switch (${UserName Type}) {
        'Non-Domain Windows UserName' {
          # Which pattern is the Non-Domain Windows UserName? 
          if ( # the right-most 4 positions are \s\d\d\d |
            $CredentialManagerEntry -match '^(?<LHS>[a-z0-9-]+) (?<Three_Digits>\d{3})$'
          ) {
            <# The pattern has been established to be "LHS \d\d\d" |
              However, the sub-type must be calculated. 
              Is the non-domain Windows username local to a non-DC or a DC?
              As a reminder, the OS instance hosting an AD database starts with non-domain accounts 
              whose UserNames follow the pattern "DomainNetBiosName \d\d\d" while other OS instances will 
              contain non-domain accounts whose UserNames follow the pattern "ComputerName \d\d\d". 

              Take advantage of the fact that [qcc]::CN(${d0ma!n}) produces a length-0 string. 

              Also take advantage of the fact that a Credential Manager entry exists for "${d0ma!n} \d{3}" but
              not for "$([qcc]::CN($cname)) \d{3}"? 
            #>

            if ( # [QuickCnameConversions]::CN($Matches['LHS']) is a length-0 string, and therefore $Matches['LHS'] = ${d0ma!n} |
              ([QuickCnameConversions]::CN($Matches['LHS'])).Length -eq 0
            ) {
              $UserName = $Matches['LHS'] + ' ' + $Matches['Three_Digits']
            } 
            else { # [QuickCnameConversions]::CN($Matches['LHS']) has an associated %ComputerName% and is therefore a local account on a non-DC |
              $UserName = [QuickCnameConversions]::CN($Matches['LHS']) + ' ' + $Matches['Three_Digits']
            }

            # Uncover the password for $UserName
            $HT = @{
              Target      = $CredentialManagerEntry
              Type        = 'Generic'
              Verbose     = $false
              ErrorAction = 'Stop'
            }
            $pw = Get-StoredCredential @HT | Select-Object -ExpandProperty 'Password'
            [PSCredential]::New($UserName,$pw)
          } 
          else { # The right-most 4 positions are NOT '\s\d\d\d', and therefore the non-domain account name is for OS deployment, and therefore not secure |
            <#
              In this case for a 'Non-Domain Windows UserName', the $CredentialManagerEntry  equals the $UserName
            #>
            $UserName = $CredentialManagerEntry
            $HT = @{
              Target      = $UserName
              Type        = 'Generic'
              Verbose     = $false
              ErrorAction = 'Stop'
            }
            $pw = Get-StoredCredential @HT | % 'Password'
            [PSCredential]::New($UserName,$pw)
          }
        }
        'Pre-2000 Domain Windows UserName' {
          $CredentialManagerEntry -match '^(?<DomainNetBiosName>(\.|(?!(\d{1,15}|ANONYMOUS|BATCH|BUILTIN|DIALUP|DOMAIN|ENTERPRISE|INTERACTIVE|INTERNET|LOCAL|NETWORK|NULL|PROXY|RESTRICTED|SELF|SERVER|SERVICE|SYSTEM|USERS|WORLD)$)[a-z0-9][a-z0-9-]{1,13}[a-z0-9]))\\(?<UserName>[^/\\\[\]\:;\|=,\+\*\?\<\>@"]{1,20})$' | Out-Null
          $HT = @{
            Target      = $Matches['UserName']
            Type        = 'Generic'
            Verbose     = $false
            ErrorAction = 'Stop'
          }
          $pw = Get-StoredCredential @HT | % 'Password'
          [PSCredential]::New($CredentialManagerEntry,$pw)
        }
        'User Principal Name' {
          $HT = @{
            Target      = $CredentialManagerEntry
            Type        = 'Generic'
            Verbose     = $false
            ErrorAction = 'Stop'
          }
          $pw = Get-StoredCredential @HT | % 'Password'
          [PSCredential]::New($CredentialManagerEntry,$pw)
        }
      }

      # Define the NAME of the PowerShell Remoting session in the variable $SessionName: 
      #$SessionName = "$ConfigTargetCname $CredentialManagerEntry (non-Domain) (vm)"
      #$SessionName = "$CredentialManagerEntry (non-Domain) (vm)"
      $SessionName = "$ConfigTargetCname $UserName (non-Domain) (vm)"
      Write-Verbose -Message "`$SessionName = $SessionName"

      # Initialize a Variable whose value for Name is "$ConfigTargetCname $UserName (non-Domain) (vm)"
      # This variable will eventually hold a PSSession object.
      try {Clear-Variable -Name $SessionName -ErrorAction 'Stop'} catch {New-Variable -Name $SessionName -Value $null}

      # Ensure that the only present PowerShell Remoting sessions are those whose State attribute is 'Opened'
      Purge-DownedPowerShellRemotingSessions.ps1 > $null
      
      try {
        # If the PowerShell Remoting session with Name = "$SessionName" exists (or hasn't been purged)
        # then assign the object of that PowerShell Session to the value of the variable with Name = "$SessionName"
        Set-Variable -Name $SessionName -Value (Get-PSSession -Name $SessionName -ErrorAction 'Stop') -ErrorAction 'Stop'
        #Write-Verbose -Message "This command should resolve to an object instance of type PSSession:`r`n`tGet-Variable -Name `$SessionName | % Value`r`nAnd now control should pass to the '$loop1' loop..."
        Write-Verbose -Message "Break from '$loop0' loop and pass control to the '$loop1' loop."
        break  # If no errors emit, break from the 'EstablishConnection' loop and start the 'ConfirmComputerNameUpdated' loop...
      } 
      catch {
        # If the PowerShell Remoting session with Name = $SessionName does NOT exist, then attempt 
        # to create that PowerShell Remoting session. If that attempt fails, restart the 'EstablishConnection' loop. 
        $HT = @{
          Name              = $SessionName
          VMName            = $TargetVmName
          Credential        = ${Authentication Credential}
          ConfigurationName = 'Microsoft.PowerShell'
          ErrorAction       = 'Stop'
        }
        Set-Variable -Name $SessionName -Value $(
          try {
            Write-Verbose -Message "Attempting to create a new PowerShell Remoting session into $ConfigTargetCname"
            New-PSSession @HT -OutVariable $SessionName | Out-Null
            Write-Verbose -Message "Creation of the PowerShell Remoting session has succeeded. Continuing to loop '$loop1'..."
            break
          } 
          catch {
            Write-Verbose -Message "Failed to create PowerShell Remoting session into $ConfigTargetCname`r`n  Wait 15 seconds and restart loop '$loop0'..."
            Start-Sleep 15 > $null
            continue $loop0
          }
        )
      }
    }

    # Termination condition of the 'ConfirmComputerNameUpdated' loop is a PowerShell Remoting
    # session into a system whose %ComputerName% has been set to our predetermined value. 
    Write-Verbose -Message "Check whether DSC has updated %ComputerName%"
    :ConfirmComputerNameUpdated while ($true) {
      # Desired value of %ComputerName% has already been assigned to the variable $TargetComputerName
      Write-Verbose -Message "Desired value of %ComputerName% is $TargetComputerName"

      # initialize a variable with Name = 'CurrentComputerName' and assign Value to $null
      try {Clear-Variable -Name 'CurrentComputerName' -ErrorAction 'Stop'} catch {New-Variable -Name 'CurrentComputerName' -Value $null}

      # There's the possiblity that the PowerShell Remoting session with Name = $SessionName no longer has State attribute of 'Opened'.
      # Purging all non-Opened sessions will ensure the next try-catch keyword sequence results in the 'outer' loop being restarted. 
      Purge-DownedPowerShellRemotingSessions.ps1 > $null

      try {
        # Save to the $CurrentComputerName variable the value of the remote system's %ComputerName%
        $CurrentComputerName = Invoke-Command -Session $(Get-PSSession -Name $SessionName -ErrorAction 'Stop') -ScriptBlock {$env:ComputerName} -ErrorAction 'Stop'
        Write-Verbose -Message "Current value of %ComputerName% is $CurrentComputerName"
      } 
      catch {
        Purge-DownedPowerShellRemotingSessions.ps1 > $null
        Write-Verbose -Message "PowerShell Remoting session to $ConfigTargetCname has failed. Wait 15 seconds & restart 'outer' loop."
        Start-Sleep 15 > $null
        continue outer
      }

      # Wait for the existence of a PowerShell Remoting session into a system whose %ComputerName% matches the intended value 
      if ($TargetComputerName -notmatch "^$CurrentComputerName`$") {
        Write-Verbose -Message "%ComputerName% hasn't updated. Wait 60 sec. Restart loop '$loop1'. Re-check value of %ComputerName%"
        Start-Sleep 60 > $null
        continue
      } 
      else {
        Write-Verbose -Message "`t`t%ComputerName% confirmed updated. Passing control to the '$loop2' loop"
        break
      }
    }

    :Executeprofiledotps1 while ($true) {
      Purge-DownedPowerShellRemotingSessions.ps1 > $null
      try {
        Write-Verbose -Message "Execute code inside '`$PSHome\profile.ps1' on the target system"
        Invoke-Command -Session $(Get-PSSession -Name $SessionName -ErrorAction 'Stop') -FilePath "$PSHome\profile.ps1" -ErrorAction 'Stop' > $null
        break outer
      } 
      catch {
        Write-Verbose -Message "The attempt to execute commands (defined within the local host's '`$PSHome\profile.ps1' file) on the remote machine resulted in an error.`r`nReturning control to the 'outer' loop..."
        continue outer
      }
    }
  }

  Purge-DownedPowerShellRemotingSessions.ps1 > $null
  $EndTime = [System.DateTime]::Now
  $Duration = $EndTime - $StartTime
  Write-Verbose -Message "Function $($PSCmdlet.MyInvocation.InvocationName) terminated at $($EndTime).`tDuration = $($Duration.Minutes)m$($Duration.Seconds)s"

  return Get-PSSession -Name $SessionName
} else {
  Write-Host -Object "VM with `$VMName $([System.Char]39)$([qcc]::VM($ConfigTargetCname))$([System.Char]39) d.n.e."
}
$Host.PrivateData.VerboseForegroundColor = [System.ConsoleColor]::Yellow
$Host.PrivateData.VerboseBackgroundColor = [System.ConsoleColor]::Black