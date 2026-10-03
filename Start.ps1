#Requires -Version 5.1
#Requires -PSEdition Desktop

param (
  [Parameter(
    Mandatory = $true,
    HelpMessage = "Regular expression sourced from 'https://www.regular-expressions.info/email.html'"
  )]
  [ValidatePattern(
    '^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$'
  )]
  [System.String]
  [Alias(
    'email'
  )]
  $EmailAddressOfBitwardenAccount,

  [Parameter(
    Mandatory = $false
  )]
  [System.String]
  $BadPassword = 'BadPassword!',

  [Parameter(
    Mandatory = $false
  )]
  [Alias('Folder Fully Qualified Name')]
  [System.String]
  $FolderFQN = 'Instant-ADCS',

  [Parameter(
    Mandatory = $true
  )]
  [ValidatePattern(
    '^(?!(\d{1,15}|ANONYMOUS|BATCH|BUILTIN|DIALUP|DOMAIN|ENTERPRISE|INTERACTIVE|INTERNET|LOCAL|NETWORK|NULL|PROXY|RESTRICTED|SELF|SERVER|SERVICE|SYSTEM|USERS|WORLD)$)[a-z0-9][a-z0-9-]{1,13}[a-z0-9]$'
  )]
  [System.String]
  ${NetBIOS Name of Root Domain in AD Forest},

  [Parameter(
    Mandatory = $true
  )]
  [ValidatePattern(
    '^ad\.[0-9a-z-]{1,256}\.INTERNAL$'
  )]
  [System.String]
  ${DNS Name of Root Domain in AD Forest}
)


#region | Export non-senstive strings to .clixml for later import by other applications |
. powershell.exe -NoProfile -File "$PSScriptRoot\Start\Export non-senstive strings to .clixml for later import by other applications.ps1"
#endregion

#region | Install NuGet | Set PSGallery as Trusted | Install 'TUN.CredentialManager' |
. powershell.exe -NoProfile -File "$PSScriptRoot\Start\NuGet-PSGallery-Windows PowerShell Module Install.ps1"
#endregion

""
${API Key for Bitwarden CLI Here-String} = @'
  1. Visit 'https://vault.bitwarden.com/#/login' to create a free personal Bitwarden Account. 

  2. Authenticate into your Bitwarden Vault > 
    select 'Bitwarden Password Manager' in lower-left corner > 
      select 'Settings' blade > 
        select 'Security' blade > 
          select 'Keys' tab > 
            in 'API Key' section hit 'View API Key' button.

  3. Input the password of your personal Bitwarden Account. 
    
  4. Collect your Bitwarden Client ID + Generate new Bitwarden Client Secret. 

  5. Press Enter once those values are available. PowerShell will save 
     these sensitive strings to the local Windows Credential Manager. 

'@
""
Write-Host -Object ${API Key for Bitwarden CLI Here-String} -ForegroundColor ([System.ConsoleColor]::Green)
pause 

#region | Securely write into local Windows Credential Manager: (1) Bitwarden Client ID |
# Title of Bitwarden Client ID
${Bitwarden Client ID Title} = "!BW_CLIENTID $FolderFQN"

# Verify whether the Bitwarden Client ID is already present in the local Windows Credential Manager
$StoredCred = Get-StoredCredential -Target ${Bitwarden Client ID Title}
if ($StoredCred -eq $null) {
  # Value of Bitwarden Client ID, symmetrically encrypted with the Windows Data Protection API (DPAPI)
  ${Bitwarden Client ID Value-SECURED} = Read-Host -Prompt 'Bitwarden Client ID Value' -AsSecureString
  $HT = @{
    Target         = ${Bitwarden Client ID Title}
    UserName       = ${Bitwarden Client ID Title}
    SecurePassword = ${Bitwarden Client ID Value-SECURED}
    Comment        = "Bitwarden Client ID"
    Type           = "Generic"
    Persist        = 'LocalMachine'
    Verbose        = $true
  }
  # Write the Bitwarden Client ID into the local Windows Credential Manager. 
  New-StoredCredential @HT

  # Destroy the in-memory representation of the Bitwarden Client ID
  Remove-Variable -Name 'Bitwarden Client ID Value-SECURED'
} else {
  Write-Host -Object "`n  [x] Object titled '${Bitwarden Client ID Title}' already present in local Windows Credential Manager" -ForegroundColor ([System.ConsoleColor]::DarkGreen)
}
#endregion

#region | Securely write into local Windows Credential Manager: (2) Bitwarden Client Secret |
# Title of Bitwarden Client ID
${Bitwarden Client Secret Title} = "!BW_CLIENTSECRET $FolderFQN"

# Verify whether the Bitwarden Client Secret is already present in the local Windows Credential Manager
$StoredCred = Get-StoredCredential -Target ${Bitwarden Client Secret Title}
if ($StoredCred -eq $null) {
  # Value of Bitwarden Client Secret, symmetrically encrypted with the Windows Data Protection API (DPAPI)
  ${Bitwarden Client Secret Value-SECURED} = Read-Host -Prompt 'Bitwarden Client Secret Value' -AsSecureString
  $HT = @{
    Target         = ${Bitwarden Client Secret Title}
    UserName       = ${Bitwarden Client Secret Title}
    SecurePassword = ${Bitwarden Client Secret Value-SECURED}
    Comment        = "No comment"
    Type           = "Generic"
    Persist        = 'LocalMachine'
    Verbose        = $true
  }
  # Write the Bitwarden Client Secret into the local Windows Credential Manager. 
  New-StoredCredential @HT

  # Destroy the in-memory representation of the Bitwarden Client Secret
  Remove-Variable -Name 'Bitwarden Client Secret Value-SECURED'
} else {
  Write-Host -Object "`n  [x] Object titled '${Bitwarden Client Secret Title}' already present in local Windows Credential Manager" -ForegroundColor ([System.ConsoleColor]::DarkGreen)
}
#endregion

#region | Securely write into local Windows Credential Manager: (3) Bitwarden Vault password |
<# IMPORTANT |
  DELETE this entry in the Credential Manager before exporting to .crd file!
#>
# Title of Bitwarden Account password
${Bitwarden Account Password Title} = "!Bitwarden Account Password-DELETE THIS"

# Verify whether the Bitwarden Account password is already present in the local Windows Credential Manager
$StoredCred = Get-StoredCredential -Target ${Bitwarden Account Password Title}
if ($StoredCred -eq $null) {
  # Value of Bitwarden Account password, symmetrically encrypted with the Windows Data Protection API (DPAPI)
  ${Bitwarden Account Password-SECURED} = Read-Host -Prompt "Supply the password to authenticate into 'https://vault.bitwarden.com/#/login'" -AsSecureString
  $HT = @{
    Target         = ${Bitwarden Account Password Title}
    UserName       = ${Bitwarden Account Password Title}
    SecurePassword = ${Bitwarden Account Password-SECURED}
    Comment        = "Delete this credential BEFORE exporting to .crd file"
    Type           = "Generic"
    Persist        = 'LocalMachine'
    Verbose        = $true
  }

  # Write the Bitwarden Account password into the local Windows Credential Manager. 
  New-StoredCredential @HT

  # Destroy the in-memory representation of the Bitwarden Account password
  Remove-Variable -Name 'Bitwarden Account Password-SECURED'
} else {
  Write-Host -Object "`n  [x] Object titled '${Bitwarden Account Password Title}' already present in local Windows Credential Manager and will be deleted shortly." -ForegroundColor ([System.ConsoleColor]::DarkGreen)
}
#endregion

#region | Set variable values and construct profile.ps1 for Windows PowerShell |
""
${External Storage Media Here-String} = @'
  Read all subsequent steps before pressing Enter to continue: 

  1. Insert removable external storage media. 
  2. Launch another instance of Windows PowerShell. 
  3. Execute the code below in that newly created session to view 
     details of removable external storage drives that are not also
     bootable media: 

       Get-Disk `
       | Where-Object -PipelineVariable 'Disk' -FilterScript {
         $_.BusType           -eq 'USB'     -and `
         $_.OperationalStatus -eq 'Online'  -and `
         $_.HealthStatus      -eq 'Healthy'
       } `
       | ForEach-Object -Process {
         Get-Partition -DiskNumber $Disk.Number `
         | Where-Object -PipelineVariable 'Partition' -FilterScript {
           $_.Type              -match 'Basic|IFS'   -and `
           $_.OperationalStatus -eq    'Online'      -and `
           $null                -ne    'DriveLetter'
         } `
         | ForEach-Object -Process {
           Get-Volume -Partition ($Partition) `
           | Where-Object -PipelineVariable 'Volume' -FilterScript {
             $_.FileSystemType -eq 'NTFS'
           } `
           | ForEach-Object -Process {
             if (-not (Test-Path -Path "$($Volume.DriveLetter):\setup.exe")) {
               Write-Host -Object "DriveLetter = $($Volume.DriveLetter)"
               Write-Host -Object "  Disk FriendlyName = '$($Disk.FriendlyName)'"
               Write-Host -Object "  Disk UniqueId Raw = '$($Disk.UniqueId)'"
               Write-Host -Object "  Disk SerialNumber = '$($Disk.SerialNumber)'`n"
             }
           }
         }
       }

  4. Copy & paste the results into Notepad. 
  5. Return to this original instance of Windows PowerShell and hit Enter.

'@
""
Write-Host -Object ${External Storage Media Here-String} -ForegroundColor ([System.ConsoleColor]::Blue)
pause

${External Storage Media Note Preamble Here-String} = -join $(
  "`n"
  "  * usb0 will hold application installation files + OS images in .iso format.`n"
  "  * usb1 will hold DSC data and Windows PowerShell scripts.`n"
  "`n"
  "  Decide which external removable non-bootable storage drive will be 'usb0' and which`n"
  "  will be 'usb1' before pressing Enter to continue.`n"
  "`n"
)
Write-Host -Object ${External Storage Media Note Preamble Here-String} -ForegroundColor ([System.ConsoleColor]::Cyan)
pause

${External Storage Media Note Here-String} = -join $(
  "`n"
  "  Copy + paste the corresponding strings written into Notepad. `n"
  "  Be sure to include the entire displayed value, including single quotes and space characters. `n"
  "  For example: `n"
  "    PS> usb0 FriendlyName: $([System.Char]39)WD My Passport 259F$([System.Char]39)`n"
  "    PS> usb0 SerialNumber: $([System.Char]39)WXV1E651JMYD    $([System.Char]39)`n"
  "    PS> usb1 UniqueId Raw: $([System.Char]39) USB$([System.Char]39)`n"
  "`n"
)
Write-Host -Object ${External Storage Media Note Here-String} -ForegroundColor ([System.ConsoleColor]::Cyan)

#region | Generate Windows PowerShell-compatible profile.ps1 file for Instant-ADCS |
#. powershell.exe -NoProfile -File "$PSScriptRoot\Start\Construct profile.ps1 for Windows PowerShell.ps1"
$HT = @{
  'NetBIOS Name of Root Domain in AD Forest' = ${NetBIOS Name of Root Domain in AD Forest}
  'DNS Name of Root Domain in AD Forest'     = ${DNS Name of Root Domain in AD Forest}
}
& "$PSScriptRoot\Start\Construct profile.ps1 for Windows PowerShell.ps1" @HT
#endregion
#endregion

#region | Install machine-scope PowerShell 7 and register Event Logging Manifest |
#TEMPORARY#. powershell.exe -NoProfile -File "$PSScriptRoot\Start\Install machine-scope PowerShell 7 and register Event Logging Manifest.ps1"
#endregion

#region | Install Bitwarden CLI, log into Bitwarden CLI, and Build SAT module |
#TEMPORARY#. "$env:ProgramFiles\PowerShell\7\pwsh.exe" -NoProfile -File "$PSScriptRoot\Start\Build Secure-Automations-Toolset Module.ps1"
#endregion
#region | Variable Setup in Windows PowerShell and Export to CliXml |
#         & "$PSScriptRoot\Start\Variable Setup in Windows PowerShell and Export to CliXml.ps1"
#TEMPORARY#. powershell.exe -NoProfile -File "$PSScriptRoot\Start\Variable Setup in Windows PowerShell and Export to CliXml.ps1"
#endregion


#region | Persistent Secrets in Bitwarden Vault | WARNING: This will take over 60 minutes! |
<#
  For this reason, the code should run in a PowerShell Job!! 
#>
#region | Generate secure strings in online Bitwarden Vault |
<# Temporary Halt |
  . "$env:ProgramFiles\PowerShell\7\pwsh.exe" -NoProfile -File "$PSScriptRoot\Start\Generate and Save Credentials into Bitwarden Vault.ps1"
#>
#endregion

#region | Install 'TUN.CredentialManager' module for Windows PowerShell |
<# I think we can delete this because the module has already been established much earlier |
  Write-Host -Object "`n  Installing 'TUN.CredentialManager' module for Windows PowerShell...`n" -ForegroundColor ([System.ConsoleColor]::DarkYellow)
  $InstallModuleHT = @{
    Scope      = 'CurrentUser'
    Repository = 'PSGallery'
    Verbose    = $true
  }
  $ModuleName = 'TUN.CredentialManager'
  try {
    Get-InstalledModule -Name $ModuleName -ErrorAction 'Stop' | Format-Table -AutoSize
  } 
  catch {
    Install-Module -Name $ModuleName @InstallModuleHT | Format-Table -AutoSize
  }
#>
#endregion

#region | Synchronize in-cloud Bitwarden Items down to local Windows Credential Manager |
#. powershell.exe -NoProfile -File "$PSScriptRoot\Start\Synchronize in-cloud Bitwarden Items down to local Windows Credential Manager.ps1"
<# I think we can delete. 
  #   Exporting $FolderFQN to CliXml happens early 
  #   in .\Start.ps1 and exporting $FolderId to CliXml happens during 
  #   'Generate and Save Credentials into Bitwarden Vault.ps1'

  . "$env:ProgramFiles\PowerShell\7\pwsh.exe" -NoProfile -File "$PSScriptRoot\Start\Export FolderId and FolderFQN to CliXml.ps1"
#>
#region | Import FolderId  GUID and`$FolderFQN from .clixml file into separate in-memory variables |
<# Can we delete? I think this was not necessary |
  Write-Verbose -Message "Import `$FolderId and `$FolderFQN from .clixml file into separate in-memory variables"

  $CliXmlFile = Get-ChildItem -Path "$PSScriptRoot\..\.CommonItems\FolderId and FolderFQN *.clixml" `
  | Sort-Object `
  | Select-Object -Last 1

  $CliXmlHT = Import-CliXml -Path $CliXmlFile.FullName

  foreach ($Ea in ($CliXmlHT.GetEnumerator() | Write-Output)) {
    $_Var_Name = $Ea.Name
    try {Clear-Variable -Name $_Var_Name -ErrorAction 'Stop'} catch {New-Variable -Name $_Var_Name -Value $null}
    Set-Variable -Name $_Var_Name -Value ($Ea.Value)
  }
  Write-Verbose -Message "`$FolderFQN = $FolderFQN"
  Write-Verbose -Message "`$FolderId = $FolderId"
#>
#endregion
#region | Compile Quick Lookup Table.csv File |
#TEMPORARY#. "$env:ProgramFiles\PowerShell\7\pwsh.exe" -NoProfile -File "$PSScriptRoot\Start\Compile Quick Lookup Table.csv File.ps1"
#endregion
#region | Update Password for Logging into Bare-metal Server (aka DSC Authoring Station, aka Unclustered Hyper-V Host) to a value you know |
#TEMPORARY#. "$env:ProgramFiles\PowerShell\7\pwsh.exe" -NoProfile -File "$PSScriptRoot\Start\Update Password for Logging into Bare-metal Unclustered Hyper-V Host.ps1"
#endregion
#region | Write password from local Secrets Vault into local Windows Credential Manager |
#TEMPORARY#. "$env:ProgramFiles\PowerShell\7\pwsh.exe" -NoProfile -File "$PSScriptRoot\Start\Write password from local Secrets Vault into local Windows Credential Manager.ps1"
#endregion
#endregion

#endregion


#region | Download Windows Server .ISO file | Download Windows 11 Enterprise .ISO file |
#endregion

#region | Download, but do not install, DSC Resource Modules |
#endregion

#region | Download, but do not install, Windows PowerShell Modules |
#endregion

#region | Resume authoring the custom InstantAdcsRev5 DSC Resource module | Write build script upon completion. |
#endregion







#region | Windows Assessment and Deployment Kit | Phase 1 |
<#
  
#>
#endregion









#region | Windows Assessment and Deployment Kit | Phase 2 |
<#
  
#>
#endregion









