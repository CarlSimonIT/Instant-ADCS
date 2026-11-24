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
  ${Bitwarden Account Email Address},

  [Parameter(
    Mandatory = $true, 
    HelpMessage = "Naming constraints: 'https://learn.microsoft.com/en-us/troubleshoot/windows-server/active-directory/naming-conventions-for-computer-domain-site-ou#netbios-domain-names'"
  )]
  [ValidateScript(
    {$_ -match "^(?!(anonymous|batch|builtin|dialup|domain|enterprise|interactive|internet|local|network|null|proxy|restricted|self|server|service|system|users|world|\d{1,15})$)[^,~:!@#$([System.Char]36)%^$([System.Char]39)\.\(\{\)\}_\s\\/]{1,15}$([System.Char]36)"}
  )]
  [System.String]
  ${NetBIOS Name of Root Domain in AD Forest},

  [Parameter(
    Mandatory = $true
  )]
  [ValidatePattern(
    '(^[-a-z0-9]$)|(^[-a-z0-9](a|b|c|d|e|f|g|h|i|j|k|l|m|n|o|p|q|r|s|t|u|v|w|x|y|z|(\.(?=[-a-z0-9]))|0|1|2|3|4|5|6|7|8|9|-){0,50}[-a-z0-9]$)'
  )]
  [System.String]
  ${Substring from DNS Namespace of Root Domain in AD Forest},

  [Parameter(
    Mandatory = $false,
    HelpMessage = "The SHA256 hash you download might not match the default value in the Start.ps1 script. `r`nSome websites for reference on hash verification of an iso:`r`n  'https://woshub.com/check-file-hash-windows/'`r`n  'https://files.rg-adguard.net/?dark=1'`r`n  'https://my.visualstudio.com/Downloads' "
  )]
  [ValidatePattern(
    '^[0-9a-f]{64}$'
  )]
  [System.String]
  ${SHA256 of Windows Server 2025 ISO File} = 'D0EF4502E350E3C6C53C15B1B3020D38A5DED011BF04998E950720AC8579B23D',

  [Parameter(
    Mandatory = $false,
    HelpMessage = "Download link: 'https://go.microsoft.com/fwlink/?linkid=2289981'"
  )]
  [ValidatePattern(
    '^[0-9a-f]{64}$'
  )]
  [System.String]
  ${SHA256 of WinPE 2026-09 EXE File} = 'D4DE67ACC83DE253CCC941DD0590808D83726BDD8EA768A374A7BEAFF7949D6A',

  [Parameter(
    Mandatory = $false,
    HelpMessage = "Download link: 'https://downloads.dell.com/FOLDER15124725M/1/WinPE11.0-Drivers-A11-KHF4P.cab'"
  )]
  [ValidatePattern(
    '^[0-9a-f]{64}$'
  )]
  [System.String]
  ${SHA256 of Dell WinPE Driver Pack A11} = '39665D324E4B090F4BCFC7DB434B0D9B3924C554694E1BCD7C55675984576830',

  [Parameter(
    Mandatory = $false,
    HelpMessage = "Download link: 'https://go.microsoft.com/fwlink/?linkid=2289980'"
  )]
  [ValidatePattern(
    '^[0-9a-f]{64}$'
  )]
  [System.String]
  ${SHA256 of Windows ADK 2026-09 EXE File} = 'AC6A930FDB5C2980BA5FEFE606D47EDAAFCF5F647B4337411500D158EA77300F',

  [Parameter(
    Mandatory = $false
  )]
  [System.String]
  $CloningRepoPath = $(Get-Location | Select-Object -ExpandProperty 'Path'),

  [Parameter(
    Mandatory = $false
  )]
  [System.String]
  $__DirectoryForDscConfigs = '_Zeta',

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
  $FolderFQN = 'Instant-ADCS'
)

<#
  $CloningRepoPath = "$env:UserProfile\GitHub\CarlSimonIT"; $CloningRepoFolder = try {Get-Item -Path $CloningRepoPath -ErrorAction 'Stop'} catch {New-Item -Path $CloningRepoPath -ItemType 'Directory' -Force}; Set-Location -Path "$CloningRepoFolder"
  Set-ExecutionPolicy -ExecutionPolicy 'RemoteSigned' -Scope 'Process' -Force; 
  ipmo "$env:UserProfile\GitHub\CarlSimonIT\Instant-ADCS\A0\HereStringConversionModule.psm1"
  $HT = @{'Bitwarden Account Email Address' = 'pwdsec3@gmail.com'; 'Folder Fully Qualified Name' = 'Instant-ADCS'; BadPassword = 'BadPassword!'; 'NetBIOS Name of Root Domain in AD Forest' = 'NET-W0RK'; 'Substring from DNS Namespace of Root Domain in AD Forest' = -join ((0..24) | %{ '-.'}) + '-'}; & '.\Instant-ADCS\Start.ps1' @HT; Set-Location -Path 'C:\'; (Get-Job).Where({$_.State -ne 'Running'}) | Remove-Job; Get-Job | Format-Table -AutoSize; 
  Set-ExecutionPolicy -ExecutionPolicy 'RemoteSigned' -Scope 'Process' -Force; $CloningRepoPath = "$env:UserProfile\GitHub\CarlSimonIT"; $CloningRepoFolder = try {Get-Item -Path $CloningRepoPath -ErrorAction 'Stop'} catch {New-Item -Path $CloningRepoPath -ItemType 'Directory' -Force}; Set-Location -Path "$CloningRepoFolder"; $HT = @{'Bitwarden Account Email Address' = 'pwdsec3@gmail.com'; 'Folder Fully Qualified Name' = 'Instant-ADCS'; BadPassword = 'BadPassword!'; 'NetBIOS Name of Root Domain in AD Forest' = 'NET-W0RK'; 'Substring from DNS Namespace of Root Domain in AD Forest' = -join ((0..24) | %{ '-.'}) + '-'}; & '.\Instant-ADCS\Start.ps1' @HT; Set-Location -Path 'C:\'; (Get-Job).Where({$_.State -ne 'Running'}) | Remove-Job; Get-Job | Format-Table -AutoSize; 
  (Get-Job).Where({$_.State -ne 'Running'}) | Remove-Job; Get-Job | Format-Table -AutoSize; 
  Clear-Host
  # see 'https://www.hurryupandwait.io/blog/certificate-password-less-based-authentication-in-winrm'
#>

#region | Set latest Strict Mode | Exit '.\Start.ps1' script if launched in a powershell.exe process instance running at Integrity Level-High |
Set-StrictMode -Version 'Latest'; 

${powershell.exe owner Identity} = [Security.Principal.WindowsIdentity]::GetCurrent()
${powershell.exe owner Access} = [Security.Principal.WindowsPrincipal]${powershell.exe owner Identity}
${Current powershell.exe process is running at Integrity Level-High} = (${powershell.exe owner Access}).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (${Current powershell.exe process is running at Integrity Level-High}) {
  Write-Error -Message "`n`n`tExiting Start.ps1 script.`n`n`tRe-launch Windows PowerShell WITHOUT selecting Run As Administrator!`n`n"
  pause
  Get-Process -Id $PID | Stop-Process -Force
}
#endregion
#region | Export non-senstive strings to .clixml for later import by other applications |
$InputHT = @{
  'SHA256 of Windows Server 2025 ISO File' = ${SHA256 of Windows Server 2025 ISO File}
  'SHA256 of WinPE 2026-09 EXE File'       = ${SHA256 of WinPE 2026-09 EXE File}
  'SHA256 of Dell WinPE Driver Pack A11'   = ${SHA256 of Dell WinPE Driver Pack A11}
  'SHA256 of Windows ADK 2026-09 EXE File' = ${SHA256 of Windows ADK 2026-09 EXE File}
  'Bitwarden Account Email Address'        = ${Bitwarden Account Email Address}
  BadPassword                              = $BadPassword
  FolderFQN                                = $FolderFQN
  __DirectoryForDscConfigs                 = $__DirectoryForDscConfigs
}
& "$PSScriptRoot\Start\Export non-senstive strings to .clixml for later import by other applications.ps1" @InputHT
[System.Environment]::SetEnvironmentVariable('.CommonItems',"$CloningRepoPath\.CommonItems")
$FolderFQN = Import-CliXml -Path "$PSScriptRoot\..\.CommonItems\FolderFQN.clixml"
#endregion
#region | Define new folder structures. Same code is re-executed later in Start.ps1 when applicable |
$InputHT = @{
  'Offline WU-Original Server 2025 Folder Path' = "$PSScriptRoot\..\.CommonItems\Offline WU\Server 25\Original"
  'Offline WU-Patched Server 2025 Folder Path'  = "$PSScriptRoot\..\.CommonItems\Offline WU\Server 25\Patched"
  'WinPE Installs Path'                         = "$PSScriptRoot\..\.CommonItems\WinPE"
}
$OutputHT = & "$PSScriptRoot\Start\New directory set via script with returned objects.ps1" @InputHT

# $path = "$PSScriptRoot\..\.CommonItems\Offline WU\Server 25\Original"
# ${Offline WU-Original Server 2025 Folder} = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
# $path = "$PSScriptRoot\..\.CommonItems\Offline WU\Server 25\Patched"
# ${Offline WU-Patched Server 2025 Folder} = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}

# $InstallsPath = "$PSScriptRoot\..\.CommonItems\WinPE"
# $path = "$InstallsPath\ADK + WinPE (2026-09)"
# $AppFolder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}

${Offline WU-Original Server 2025 Folder} = $OutputHT['Offline WU-Original Server 2025 Folder']
${Offline WU-Patched Server 2025 Folder} = $OutputHT['Offline WU-Patched Server 2025 Folder']
#$AppFolder = $OutputHT['Apps for OS Image Prep Folder']
${Apps for OS Image Prep Folder} = $OutputHT['Apps for OS Image Prep Folder']
#endregion
#region | Install NuGet | Set PSGallery as Trusted | Update PowerShellGet module | Install 'CredentialManager' module |
& "$PSScriptRoot\Start\NuGet Install, Trust PSGallery, Update PowerShellGet, Install Windows PowerShell Modules.ps1"
#endregion
#region | Write sensitive strings providing access to online Bitwarden Vault into local Windows Credential Manager |
$PSModuleInfo = Import-Module 'CredentialManager' -Force -PassThru
${1 or more sensitive strings providing access to online Bitwarden Vault need to be written into local Windows Credential Manager} = (
  ((Get-StoredCredential -Target "!BW_CLIENTID $FolderFQN")                 -eq $null) -or `
  ((Get-StoredCredential -Target "!BW_CLIENTSECRET $FolderFQN")             -eq $null) -or `
  ((Get-StoredCredential -Target "!Bitwarden Account Password-DELETE THIS") -eq $null)
)
if (${1 or more sensitive strings providing access to online Bitwarden Vault need to be written into local Windows Credential Manager}) {
  . powershell.exe -NoProfile -File "$PSScriptRoot\Start\Bitwarden Online + Local Credential Manager\00 Write into local Windows Credential Manager the sensitive strings providing access to online Bitwarden Vault.ps1"
}
#endregion
#region | Ensure target 'output' directory is present in project root |
. powershell.exe -NoProfile -File "$PSScriptRoot\Start\Ensure target output directory is present in project root.ps1"
#endregion
#region | Calculate Patch Tuesday date for this month |
${SHA256 of Get-XDayOfMonth.ps1 File} = '3601BA876957FBCF3B6E0A9A448B5177A952954F951D1441AF8F5720F9D6A820'
$InputHT = @{
  'Target Get-XDayOfMonth.ps1 File Path' = "$PSScriptRoot\output\$FolderFQN\usb1\$FolderFQN\Base\5.1\Get-XDayOfMonth.ps1"
  'SHA256 of Get-XDayOfMonth.ps1 File'   = ${SHA256 of Get-XDayOfMonth.ps1 File}
}
$OutputHT = & "$PSScriptRoot\Start\Calculate Patch Tuesday date for this month.ps1" @InputHT

# ${Target Get-XDayOfMonth.ps1 File} = [System.IO.FileInfo]"$PSScriptRoot\output\$FolderFQN\usb1\$FolderFQN\Base\5.1\Get-XDayOfMonth.ps1"
# #
# $hash = ${SHA256 of Get-XDayOfMonth.ps1 File}
# ${Local Get-XDayOfMonth.ps1 File} = Get-ChildItem -Path "$PSScriptRoot\output" -Recurse -File `
# | Where-Object -PipelineVariable 'file' -FilterScript {$_.Name -eq 'Get-XDayOfMonth.ps1'} `
# | ForEach-Object -Process {Get-FileHash -Path $file.FullName -Algorithm 'SHA256' `
# | Where-Object -PipelineVariable 'AlgoHashPath' -FilterScript {$_.Hash -eq $hash} `
# | ForEach-Object -Process {Get-Item -Path $AlgoHashPath.Path}} `
# | Sort-Object -Property 'LastWriteTime' -Descending `
# | Select-Object -First 1
# #
# if ($null -ne ${Local Get-XDayOfMonth.ps1 File}) {
#   Copy-Item -Path ${Local Get-XDayOfMonth.ps1 File}.FullName -Destination ${Target Get-XDayOfMonth.ps1 File}.DirectoryName
# } else {
#   $Uri = 'https://gist.githubusercontent.com/andyzib/22c4732627ae9a1d3f1776374980ec9c/raw/6442a572cbf096b62004c30097cd1aac1e99d18a/Get-XDayOfMonth.ps1'
#   do {
#     Invoke-WebRequest -Uri $Uri -OutFile ${Target Get-XDayOfMonth.ps1 File}.FullName
#     Start-Sleep 5
#   } until ({
#     $IsPresent = Test-Path -Path ${Target Get-XDayOfMonth.ps1 File}.FullName
#     return $IsPresent
#   })
# }
# . ${Target Get-XDayOfMonth.ps1 File}
# $HT = @{
#   Find    = 'Second'
#   Weekday = 'Tuesday'
#   Month   = $([System.String]::Format('{0:MM}',[System.DateTime]::Now))
#   Year    = $([System.String]::Format('{0:yyyy}',[System.DateTime]::Now))
# }
# ${Patch Tuesday Of This Month} = Get-XDayOfMonth @HT
${Patch Tuesday Of This Month} = $OutputHT['Patch Tuesday Of This Month']
#endregion

#region | Unique Identifiers of Removable (both Storage & Bootable) External Media |
# If all of the .clixml files containing unique identifiers of external removable 
# media have been defined, then don't display the instructions to 
# collect those unique identifiers. 
if (
  -not (
    (Test-Path -Path "$PSScriptRoot\..\.CommonItems\usb0 FriendlyName.clixml") -and `
    (Test-Path -Path "$PSScriptRoot\..\.CommonItems\usb0 UniqueId Raw.clixml") -and `
    (Test-Path -Path "$PSScriptRoot\..\.CommonItems\usb0 SerialNumber.clixml") -and `
    (Test-Path -Path "$PSScriptRoot\..\.CommonItems\usb1 FriendlyName.clixml") -and `
    (Test-Path -Path "$PSScriptRoot\..\.CommonItems\usb1 UniqueId Raw.clixml") -and `
    (Test-Path -Path "$PSScriptRoot\..\.CommonItems\usb1 SerialNumber.clixml")
  )
) { # Collect and export to .clixml the unique identifiers of removable external storage media |
  . powershell.exe -NoProfile -File "$PSScriptRoot\Start\Enumerate the unique identifiers of removable external storage media.ps1"
}
. powershell.exe -NoProfile -File "$PSScriptRoot\Start\Export to .clixml the unique identifiers of removable external storage media.ps1"

if (
  -not (
    (Test-Path -Path "$PSScriptRoot\..\.CommonItems\OSDeploy FriendlyName.clixml") -and `
    (Test-Path -Path "$PSScriptRoot\..\.CommonItems\OSDeploy UniqueId Raw.clixml") -and `
    (Test-Path -Path "$PSScriptRoot\..\.CommonItems\OSDeploy SerialNumber.clixml")
  )
) { # Collect and export to .clixml the unique identifiers of bootable media |
  . powershell.exe -NoProfile -File "$PSScriptRoot\Start\Enumerate the unique identifiers of bootable media.ps1"
}
. powershell.exe -NoProfile -File "$PSScriptRoot\Start\Export to .clixml the unique identifiers of bootable media.ps1"
#endregion
#region | Generate Windows PowerShell-compatible profile.ps1 file for Instant-ADCS |
$HT = @{
  'NetBIOS Name of Root Domain in AD Forest' = ${NetBIOS Name of Root Domain in AD Forest}
  'Substring from DNS Namespace of Root Domain in AD Forest'     = ${Substring from DNS Namespace of Root Domain in AD Forest}
}
& "$PSScriptRoot\Start\Construct profile.ps1 for Windows PowerShell.ps1" @HT

# Import '.\Lightweight Functions.ps1' for later use
. "$PSScriptRoot\output\$FolderFQN\usb1\$FolderFQN\Base\5.1\Lightweight Functions.ps1"
# Import '.\Regular Expression Patterns.ps1' for later use
. "$PSScriptRoot\output\$FolderFQN\usb1\$FolderFQN\Base\5.1\Regular Expression Patterns.ps1"
#endregion
#region | Install machine-scope PowerShell 7 and register Event Logging Manifest |
<#
  ${Win32_Product Name} = Get-CimInstance -ClassName 'Win32_Product' `
  | Where-Object -FilterScript {$_.Name -eq 'PowerShell 7-x64'} `
  | Select-Object -ExpandProperty 'Name'
#>

${Win32_Product Name} = Get-ChildItem -Path 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall' `
| Where-Object -PipelineVariable 'Candidate Registry Key' -FilterScript {$_.Name -match "\{${regex literal GUID (Anchorless)}\}$([System.Char]36)"} `
| ForEach-Object -Process {
  Get-ItemPropertyValue -Path ${Candidate Registry Key}.PSPath -Name 'DisplayName' | Where-Object -FilterScript {$_ -eq 'PowerShell 7-x64'}
}

if (${Win32_Product Name} -eq $null) {
  . powershell.exe -NoProfile -File "$PSScriptRoot\Start\Install machine-scope PowerShell 7 and register Event Logging Manifest.ps1"
}
# Enumerate the list of Cultures defined on this machine with PowerShell 7. Windows PowerShell does not support the -ListAvailable parameter of Get-Culture
$IsPresent = Test-Path -Path "$PSScriptRoot\..\.CommonItems\Cultures Defined.clixml"
if (-not $IsPresent) {
  . "$env:ProgramFiles\PowerShell\7\pwsh.exe" -NoProfile -File "$PSScriptRoot\Start\Cultures Defined.ps1"
}
#endregion

#region | Install Bitwarden CLI, log into Bitwarden CLI, and Build SAT module |
#   'https://stackoverflow.com/questions/29103238/accessing-windows-credential-manager-from-powershell';
# 'https://github.com/echalone/PowerShell_Credential_Manager'
# 'https://www.powershellgallery.com/packages/CredentialManager/2.0'
$JobName = 'Generate secure strings in online Bitwarden Vault'
$RunningJob = Get-Job | Where-Object -FilterScript {
  $_.Name  -eq $JobName  -and `
  $_.State -eq 'Running'
}
if ($RunningJob -eq $null) {
  . "$env:ProgramFiles\PowerShell\7\pwsh.exe" -NoProfile -File "$PSScriptRoot\Start\Bitwarden Online + Local Credential Manager\04 Build Secure-Automations-Toolset Module.ps1"
}
#endregion
#region | Variable Setup in Windows PowerShell and Export to CliXml |
. powershell.exe -NoProfile -File "$PSScriptRoot\Start\Variable Setup in Windows PowerShell and Export to CliXml.ps1"
#endregion

#region | Generate secure strings in online Bitwarden Vault and synchronize down to local Windows Credential Manager |
$JobName = 'Generate secure strings in online Bitwarden Vault'
$RunningJob = Get-Job | Where-Object -FilterScript {
  $_.Name  -eq $JobName  -and `
  $_.State -eq 'Running'
}
if ($RunningJob -eq $null) {
  $ArgumentList = @(
    "$PSScriptRoot\Start\Bitwarden Online + Local Credential Manager"
  )
  Start-Job -Name $JobName -ArgumentList $ArgumentList -ScriptBlock {
    $BitwardenFolder = $args[0]
    #. "$env:ProgramFiles\PowerShell\7\pwsh.exe" -NoProfile -File "$BitwardenFolder\08 Call pwsh.exe to Generate and Save Credentials into Bitwarden Vault.ps1"
    . "$env:ProgramFiles\PowerShell\7\pwsh.exe" -NoProfile -File "$BitwardenFolder\08 New Passwords that Protect the Private Key Associated with Certs not CA-Signed.ps1"
    . "$env:ProgramFiles\PowerShell\7\pwsh.exe" -NoProfile -File "$BitwardenFolder\09 Passwords that Protect .PFX Files of Certification Authority certs.ps1"
    . "$env:ProgramFiles\PowerShell\7\pwsh.exe" -NoProfile -File "$BitwardenFolder\10 UNSECURE Passwords for Local Accounts not intended for use outside of initial early build phase.ps1"
    . "$env:ProgramFiles\PowerShell\7\pwsh.exe" -NoProfile -File "$BitwardenFolder\11 Passwords for Local Accounts (Windows).ps1"
    . "$env:ProgramFiles\PowerShell\7\pwsh.exe" -NoProfile -File "$BitwardenFolder\12 Passwords for Accounts that begin life as non-domain local acct on soon-to-be Promoted instance of Server 25.ps1"
    . "$env:ProgramFiles\PowerShell\7\pwsh.exe" -NoProfile -File "$BitwardenFolder\13 Passwords for Domain Accounts assigned to Security Tier Gamma.ps1"
    . "$env:ProgramFiles\PowerShell\7\pwsh.exe" -NoProfile -File "$BitwardenFolder\14 Passwords for Domain Accounts assigned to Security Tier Theta.ps1"
    . "$env:ProgramFiles\PowerShell\7\pwsh.exe" -NoProfile -File "$BitwardenFolder\15 Passwords for Domain Accounts assigned to Security Tier Kappa.ps1"
    . "$env:ProgramFiles\PowerShell\7\pwsh.exe" -NoProfile -File "$BitwardenFolder\16 Passwords for Domain Accounts assigned to Security Tier Omega.ps1"
    #. "$env:ProgramFiles\PowerShell\7\pwsh.exe" -NoProfile -File "$BitwardenFolder\17 DSC Registration Keys.ps1"
    . "$env:ProgramFiles\PowerShell\7\pwsh.exe" -NoProfile -File "$BitwardenFolder\18 Non-Windows Passwords.ps1"
    . "$env:ProgramFiles\PowerShell\7\pwsh.exe" -NoProfile -File "$BitwardenFolder\20 Compile the Quick Lookup Table.csv File with PowerShell 7.ps1"
    . "$env:ProgramFiles\PowerShell\7\pwsh.exe" -NoProfile -File "$BitwardenFolder\24 Update Logon Password for bare-metal unclustered Hyper-V Host.ps1"
    . "$env:ProgramFiles\PowerShell\7\pwsh.exe" -NoProfile -File "$BitwardenFolder\28 Read creds from local pwsh.exe-based Secrets Vault and write into local Windows Credential Manager.ps1"
  } | Out-Null
}
#endregion

# You can re-do this by warning the user that Microsoft Edge will launch and download...
# but then again some people might not be using Edge...? 

#region | Download Windows Server .ISO file | Download Windows 11 Enterprise .ISO file |
${explorer.exe Owner} = Import-CliXml -Path "$PSScriptRoot\..\.CommonItems\explorer.exe Owner.clixml"
#region | Ensure the 'Original' and 'Patched' Folders have been created |
$path = "$PSScriptRoot\..\.CommonItems\Offline WU\Server 25\Original"
${Offline WU-Original Server 2025 Folder} = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
$path = "$PSScriptRoot\..\.CommonItems\Offline WU\Server 25\Patched"
${Offline WU-Patched Server 2025 Folder} = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
#endregion
${Is ISO Already Relocated and Renamed} = Test-Path -Path "${Offline WU-Original Server 2025 Folder}\Windows Server 2025.iso"
if (-not ${Is ISO Already Relocated and Renamed}) {
  ${SHA256 of Windows Server 2025 ISO File} = Import-CliXml -Path "$PSScriptRoot\..\.CommonItems\SHA256 of Windows Server 2025 ISO File.clixml"
  $hash = ${SHA256 of Windows Server 2025 ISO File}
  ${Windows Server 2025 ISO Original File} = Get-ChildItem -Path ${env:.CommonItems} -Recurse -File -ErrorAction 'SilentlyContinue' `
  | Where-Object -PipelineVariable 'file' -FilterScript {$_.Extension -eq '.iso'} `
  | ForEach-Object -Process {Get-FileHash -Path $file.FullName -Algorithm 'SHA256' `
  | Where-Object -PipelineVariable 'AlgoHashPath' -FilterScript {$_.Hash -eq $hash} `
  | ForEach-Object -Process {Get-Item -Path $AlgoHashPath.Path}} `
  | Sort-Object -Property 'LastWriteTime' -Descending `
  | Select-Object -First 1


  if (${Windows Server 2025 ISO Original File} -eq $null) { # Download the unpatched ISO file for Server 2025 if not detected anywhere within ${env:.CommonItems} |
    $JobName = 'Download Windows Server 2025 ISO File'
    $RunningJob = Get-Job | Where-Object -FilterScript {
      $_.Name  -eq $JobName  -and `
      $_.State -eq 'Running'
    }
    if ($RunningJob -eq $null) {
      $ArgumentList = @(
        'https://go.microsoft.com/fwlink/?linkid=2293312&clcid=0x409&culture=en-us&country=us'
        "${Offline WU-Original Server 2025 Folder}\Windows Server 2025.iso"
        $ProgressPreference
      )

      Start-Job -Name $JobName -ArgumentList $ArgumentList -ScriptBlock {
        $WebPath                    = $args[0]
        $FilePath                   = $args[1]
        $OriginalProgressPreference = $args[2]

        $ProgressPreference = 'SilentlyContinue'
        Invoke-WebRequest -Uri $WebPath -OutFile $FilePath
        $ProgressPreference = $OriginalProgressPreference
      } | Out-Null
    }

    <# Using Invoke-WebRequest is good enough. No need to preserve file name when downloading through web browser |
      if ($false) {
        $ArgumentList = @(
          'https://go.microsoft.com/fwlink/?linkid=2293312&clcid=0x409&culture=en-us&country=us'
          ${explorer.exe Owner}
        )
        Start-Job -Name $JobName -ArgumentList $ArgumentList -ScriptBlock {
          ${Windows Server 2025 Download Url} = $args[0]
          ${explorer.exe Owner} = $args[1]
          Start-Process -FilePath 'msedge.exe' -ArgumentList @(${Windows Server 2025 Download Url}) -Wait
        } | Out-Null
      }
    #>
  } 
  else { # If an unpatched ISO file for Server 2025 is confirmed to be inside ${env:.CommonItems}, ensure that file has been transplanted and appropriately renamed |
    ${Is ISO Already Relocated and Renamed} = Test-Path -Path "${Offline WU-Original Server 2025 Folder}\Windows Server 2025.iso"
    if (-not ${Is ISO Already Relocated and Renamed}) {
      Move-Item -Path ${Windows Server 2025 ISO Original File}.FullName -Destination "${Offline WU-Original Server 2025 Folder}\Windows Server 2025.iso"
      #Copy-Item -Path ${Windows Server 2025 ISO Original File}.FullName -Destination "${Offline WU-Original Server 2025 Folder}"
      #Get-Item -Path "${Offline WU-Original Server 2025 Folder}\$(${Windows Server 2025 ISO Original File}.Name)" | Rename-Item -NewName 'Windows Server 2025.iso'
    }
  }
} else {${Windows Server 2025 ISO Original File} = [System.IO.FileInfo]"${Offline WU-Original Server 2025 Folder}\Windows Server 2025.iso"}
#endregion

#region | Download, but do not install, the setup file for the Windows ADK and the Windows PE Add-on |
#region | Download the Windows ADK installer EXE File |
$path = "$PSScriptRoot\..\.CommonItems\WinPE\ADK + WinPE (2026-09)\Windows ADK 2026-09 Installer"
$folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}

${SHA256 of Windows ADK 2026-09 EXE File} = Import-CliXml -Path "$PSScriptRoot\..\.CommonItems\SHA256 of Windows ADK 2026-09 EXE File.clixml"
$hash = ${SHA256 of Windows ADK 2026-09 EXE File}
${Windows ADK 2026-09 EXE File} = Get-ChildItem -Path "$folder" -File `
| Where-Object -PipelineVariable 'file' -FilterScript {$_.Extension -eq '.exe'} `
| ForEach-Object -Process {Get-FileHash -Path $file.FullName -Algorithm 'SHA256' `
| Where-Object -PipelineVariable 'AlgoHashPath' -FilterScript {$_.Hash -eq $hash} `
| ForEach-Object -Process {Get-Item -Path $AlgoHashPath.Path}} `
| Sort-Object -Property 'LastWriteTime' -Descending `
| Select-Object -First 1

if (${Windows ADK 2026-09 EXE File} -eq $null) {
  $JobName = 'Download Windows ADK 2026-09 EXE File'
  $RunningJob = Get-Job | Where-Object -FilterScript {
    $_.Name  -eq $JobName  -and `
    $_.State -eq 'Running'
  }
  if ($RunningJob -eq $null) {
    $ArgumentList = @(
      'https://go.microsoft.com/fwlink/?linkid=2289980'
      "$folder\adksetup.exe"
      $ProgressPreference
    )

    Start-Job -Name $JobName -ArgumentList $ArgumentList -ScriptBlock {
      $WebPath                    = $args[0]
      $FilePath                   = $args[1]
      $OriginalProgressPreference = $args[2]

      $ProgressPreference = 'SilentlyContinue'
      Invoke-WebRequest -Uri $WebPath -OutFile $FilePath
      $ProgressPreference = $OriginalProgressPreference
    } | Out-Null
  }
}
#endregion
#region | Download the WinPE installer EXE File |
$path = "$PSScriptRoot\..\.CommonItems\WinPE\ADK + WinPE (2026-09)\WinPE 2026-09 Installer"
$folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}

${SHA256 of WinPE 2026-09 EXE File} = Import-CliXml -Path "$PSScriptRoot\..\.CommonItems\SHA256 of WinPE 2026-09 EXE File.clixml"
$hash = ${SHA256 of WinPE 2026-09 EXE File}
${WinPE 2026-09 EXE File} = Get-ChildItem -Path "$folder" -File `
| Where-Object -PipelineVariable 'file' -FilterScript {$_.Extension -eq '.exe'} `
| ForEach-Object -Process {Get-FileHash -Path $file.FullName -Algorithm 'SHA256' `
| Where-Object -PipelineVariable 'AlgoHashPath' -FilterScript {$_.Hash -eq $hash} `
| ForEach-Object -Process {Get-Item -Path $AlgoHashPath.Path}} `
| Sort-Object -Property 'LastWriteTime' -Descending `
| Select-Object -First 1

if (${WinPE 2026-09 EXE File} -eq $null) {
  $JobName = 'Download WinPE 2026-09 EXE File'
  $RunningJob = Get-Job | Where-Object -FilterScript {
    $_.Name  -eq $JobName  -and `
    $_.State -eq 'Running'
  }
  if ($RunningJob -eq $null) {
    $ArgumentList = @(
      'https://go.microsoft.com/fwlink/?linkid=2289981'
      "$folder\adkwinpesetup.exe"
      $ProgressPreference
    )

    Start-Job -Name $JobName -ArgumentList $ArgumentList -ScriptBlock {
      $WebPath                    = $args[0]
      $FilePath                   = $args[1]
      $OriginalProgressPreference = $args[2]

      $ProgressPreference = 'SilentlyContinue'
      Invoke-WebRequest -Uri $WebPath -OutFile $FilePath
      $ProgressPreference = $OriginalProgressPreference
    } | Out-Null
  }
}
#endregion
#endregion

#region | Download-Install-Compress ADK + WinPE |
#region | Wait for job 'Download Windows ADK 2026-09 EXE File' to complete if already running |
## Windows ADK Patches
#  None currently published for Windows ADK 2026-09 but check back periodically. 
#  'https://learn.microsoft.com/en-us/windows-hardware/get-started/adk-servicing'
$Job_Name = 'Download Windows ADK 2026-09 EXE File'
$Running_Job = Get-Job | Where-Object -FilterScript {
  $_.Name  -eq $Job_Name  -and `
  $_.State -eq 'Running'
}
if ($null -ne $Running_Job) {
  Write-Host -Object "  `$Running_Job.Name = $($Running_Job.Name)"
  Get-Job -Name $Job_Name | Wait-Job | Format-Table -AutoSize
}
#endregion
#region | Bring ADK + WinPE Offline Installation Files into a %UserProfile% Container |
$InputHT = @{
  'Offline WU-Original Server 2025 Folder Path' = "$PSScriptRoot\..\.CommonItems\Offline WU\Server 25\Original"
  'Offline WU-Patched Server 2025 Folder Path'  = "$PSScriptRoot\..\.CommonItems\Offline WU\Server 25\Patched"
  'WinPE Installs Path'                         = "$PSScriptRoot\..\.CommonItems\WinPE"
}
$OutputHT = & "$PSScriptRoot\Start\New directory set via script with returned objects.ps1" @InputHT
${Apps for OS Image Prep Folder} = $OutputHT['Apps for OS Image Prep Folder']

#$InstallsPath = "$PSScriptRoot\..\.CommonItems\WinPE"
#$path = "$InstallsPath\ADK + WinPE (2026-09)"
#$AppFolder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}

${Windows ADK 2026-09 Installer Folder Name} = 'Windows ADK 2026-09 Installer'
#${Windows ADK 2026-09 Installer Folder Path} = "$AppFolder\${Windows ADK 2026-09 Installer Folder Name}"
${Windows ADK 2026-09 Installer Folder Path} = "${Apps for OS Image Prep Folder}\${Windows ADK 2026-09 Installer Folder Name}"

${WinPE 2026-09 Installer Folder Name} = 'WinPE 2026-09 Installer'
#${WinPE 2026-09 Installer Folder Path} = "$AppFolder\${WinPE 2026-09 Installer Folder Name}"
${WinPE 2026-09 Installer Folder Path} = "${Apps for OS Image Prep Folder}\${WinPE 2026-09 Installer Folder Name}"

${Bring ADK + WinPE Offline Installation Files into a %UserProfile% Container Here-String} = $(
  #region | usings | #requirements | Strict Mode | Variables |
  "#Requires -Version 5.1`n"
  "#Requires -PSEdition Desktop`n"
  "#Requires -RunAsAdministrator`n"
  "Set-StrictMode -Version $([System.Char]39)Latest$([System.Char]39)`n"
  "`n"
  "`n"
  #endregion
  #########################################-BOUNDARY-#########################################
  #region |  |


  #region |  |
  "`n"
  "& {`n"
  "  #region | Bring ADK + WinPE Offline Installation Files into a %UserProfile% Container |`n"
  "  `$path1 = $([System.Char]34)`$env:ProgramData\ADK + WinPE\`$env:UserName$([System.Char]34)`n"
  "  `$folder1 = try {Get-Item -Path `$path1 -ErrorAction $([System.Char]39)Stop$([System.Char]39)} catch {New-Item -Path `$path1 -ItemType $([System.Char]39)Directory$([System.Char]39) -Force}`n"
  "  `$path = $([System.Char]34)`$env:ProgramData\ADK + WinPE$([System.Char]34)`n"
  "  `$folder = try {Get-Item -Path `$path -ErrorAction $([System.Char]39)Stop$([System.Char]39)} catch {New-Item -Path `$path -ItemType $([System.Char]39)Directory$([System.Char]39) -Force}`n"
  "  `$IsPresent = Test-Path -Path $([System.Char]34)`$folder\${Windows ADK 2026-09 Installer Folder Name}\adksetup.exe$([System.Char]34)`n"
  "  if (-not `$IsPresent) {`n"
  "    Copy-Item -Path $([System.Char]34)${Windows ADK 2026-09 Installer Folder Path}$([System.Char]34) -Destination `$folder -Recurse`n"
  "  }`n"
  "  `$IsPresent = Test-Path -Path $([System.Char]34)`$folder\${WinPE 2026-09 Installer Folder Name}\adkwinpesetup.exe$([System.Char]34)`n"
  "  if (-not `$IsPresent) {`n"
  "    Copy-Item -Path $([System.Char]34)${WinPE 2026-09 Installer Folder Path}$([System.Char]34) -Destination `$folder -Recurse`n"
  "  }`n"
  "  #endregion`n"
  "  #region | Download but do not install the Windows ADK Installation Files |`n"
  "  `$AppName = $([System.Char]39)Windows ADK 2026-09$([System.Char]39)`n"
  "  `$TargetLayout = $([System.Char]34)`$env:ProgramData\ADK + WinPE\`$AppName Extracted$([System.Char]34)`n"
  "  `$IsPresent = Test-Path -Path `$TargetLayout`n"
  "  if (-not `$IsPresent) {`n"
  "    `$DownloadArgumentList = @(`n"
  "      $([System.Char]39)/quiet$([System.Char]39)`n"
  "      $([System.Char]39)/ceip on$([System.Char]39)`n"
  "      $([System.Char]39)/forcerestart$([System.Char]39)`n"
  "      $([System.Char]34)/layout `$env:ProgramData$([System.Char]34)`n"
  "    )`n"
  "    `$WorkingDirectory = $([System.Char]34)`$env:ProgramData\ADK + WinPE\`$AppName Installer$([System.Char]34)`n"
  "    Start-Process -FilePath $([System.Char]39).\adksetup.exe$([System.Char]39) -WorkingDirectory `$WorkingDirectory -ArgumentList `$DownloadArgumentList -Wait -Verb $([System.Char]39)RunAs$([System.Char]39)`n"
  "    `$TargetLayoutFolder = try {Get-Item -Path `$TargetLayout -ErrorAction $([System.Char]39)Stop$([System.Char]39)} catch {New-Item -Path `$TargetLayout -ItemType $([System.Char]39)Directory$([System.Char]39) -Force}`n"
  "    Move-Item -Path $([System.Char]34)`$env:ProgramData\UserExperienceManifest.xml$([System.Char]34) -Destination $([System.Char]34)`$TargetLayoutFolder$([System.Char]34)`n"
  "    Move-Item -Path $([System.Char]34)`$env:ProgramData\adksetup.exe$([System.Char]34) -Destination $([System.Char]34)`$TargetLayoutFolder$([System.Char]34)`n"
  "    Move-Item -Path $([System.Char]34)`$env:ProgramData\Installers$([System.Char]34) -Destination $([System.Char]34)`$TargetLayoutFolder$([System.Char]34) -Force`n"
  "  }`n"
  "  #endregion`n"
  "  #region | Compress the Windows ADK Installation Files |`n"
  "  `$ZipFilePath = $([System.Char]34)`$env:ProgramData\ADK + WinPE\`$AppName.zip$([System.Char]34)`n"
  "  `$IsPresent = Test-Path -Path `$ZipFilePath`n"
  "  if (-not `$IsPresent) {`n"
  "    Compress-Archive -Path `$TargetLayout -DestinationPath `$ZipFilePath`n"
  "  }`n"
  "  #endregion`n"
  "  #region | Extract the .zip file of Windows ADK Installation Files into the %UserProfile% |`n"
  "  `$IsPresent = Test-Path -Path $([System.Char]34)${Apps for OS Image Prep Folder}\`$AppName Extracted$([System.Char]34)`n"
  "  if (-not `$IsPresent) {`n"
  "    Expand-Archive -Path `$ZipFilePath -DestinationPath $([System.Char]34)${Apps for OS Image Prep Folder}$([System.Char]34)`n"
  "  }`n"
  "  #endregion`n"
  "  #region | Download but do not install the Windows PE Installation Files |`n"
  "  `$AppName = $([System.Char]39)WinPE 2026-09$([System.Char]39)`n"
  "  `$TargetLayout = $([System.Char]34)`$env:ProgramData\ADK + WinPE\`$AppName Extracted$([System.Char]34)`n"
  "  `$IsPresent = Test-Path -Path `$TargetLayout`n"
  "  if (-not `$IsPresent) {`n"
  "    `$DownloadArgumentList = @(`n"
  "      $([System.Char]39)/quiet$([System.Char]39)`n"
  "      $([System.Char]39)/ceip on$([System.Char]39)`n"
  "      $([System.Char]39)/forcerestart$([System.Char]39)`n"
  "      $([System.Char]34)/layout `$env:ProgramData$([System.Char]34)`n"
  "    )`n"
  "    `$WorkingDirectory = $([System.Char]34)`$env:ProgramData\ADK + WinPE\`$AppName Installer$([System.Char]34)`n"
  "    Start-Process -FilePath $([System.Char]39).\adkwinpesetup.exe$([System.Char]39) -WorkingDirectory `$WorkingDirectory -ArgumentList `$DownloadArgumentList -Wait -Verb $([System.Char]39)RunAs$([System.Char]39)`n"
  "    `$TargetLayoutFolder = try {Get-Item -Path `$TargetLayout -ErrorAction $([System.Char]39)Stop$([System.Char]39)} catch {New-Item -Path `$TargetLayout -ItemType $([System.Char]39)Directory$([System.Char]39) -Force}`n"
  "    Move-Item -Path $([System.Char]34)`$env:ProgramData\UserExperienceManifest.xml$([System.Char]34) -Destination $([System.Char]34)`$TargetLayoutFolder$([System.Char]34)`n"
  "    Move-Item -Path $([System.Char]34)`$env:ProgramData\adkwinpesetup.exe$([System.Char]34) -Destination $([System.Char]34)`$TargetLayoutFolder$([System.Char]34)`n"
  "    Move-Item -Path $([System.Char]34)`$env:ProgramData\Installers$([System.Char]34) -Destination $([System.Char]34)`$TargetLayoutFolder$([System.Char]34) -Force`n"
  "  }`n"
  "  #endregion`n"
  "  #region | Compress the WinPE Installation Files |`n"
  "  `$ZipFilePath = $([System.Char]34)`$env:ProgramData\ADK + WinPE\`$AppName.zip$([System.Char]34)`n"
  "  `$IsPresent = Test-Path -Path `$ZipFilePath`n"
  "  if (-not `$IsPresent) {`n"
  "    Compress-Archive -Path `$TargetLayout -DestinationPath `$ZipFilePath`n"
  "  }`n"
  "  #endregion`n"
  "  #region | Extract the .zip file of WinPE Installation Files into the %UserProfile% |`n"
  "  `$IsPresent = Test-Path -Path $([System.Char]34)${Apps for OS Image Prep Folder}\`$AppName Extracted$([System.Char]34)`n"
  "  if (-not `$IsPresent) {`n"
  "    Expand-Archive -Path `$ZipFilePath -DestinationPath $([System.Char]34)${Apps for OS Image Prep Folder}$([System.Char]34)`n"
  "  }`n"
  "  #endregion`n"
  "}`n"
  "`t`t"
  #endregion


  #endregion
  { # Created with ConvertTo-HereStringPrecursor |
    & {
      #region | Bring ADK + WinPE Offline Installation Files into a %UserProfile% Container |
      $path1 = "$env:ProgramData\ADK + WinPE\$env:UserName"
      $folder1 = try {Get-Item -Path $path1 -ErrorAction 'Stop'} catch {New-Item -Path $path1 -ItemType 'Directory' -Force}
      $path = "$env:ProgramData\ADK + WinPE"
      $folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
      $IsPresent = Test-Path -Path "$folder\${Windows ADK 2026-09 Installer Folder Name}\adksetup.exe"
      if (-not $IsPresent) {
        Copy-Item -Path "${Windows ADK 2026-09 Installer Folder Path}" -Destination $folder -Recurse
      }
      $IsPresent = Test-Path -Path "$folder\${WinPE 2026-09 Installer Folder Name}\adkwinpesetup.exe"
      if (-not $IsPresent) {
        Copy-Item -Path "${WinPE 2026-09 Installer Folder Path}" -Destination $folder -Recurse
      }
      #endregion
      #region | Download but do not install the Windows ADK Installation Files |
      $AppName = 'Windows ADK 2026-09'
      $TargetLayout = "$env:ProgramData\ADK + WinPE\$AppName Extracted"
      $IsPresent = Test-Path -Path $TargetLayout
      if (-not $IsPresent) {
        $DownloadArgumentList = @(
          '/quiet'
          '/ceip on'
          '/forcerestart'
          "/layout $env:ProgramData"
        )
        $WorkingDirectory = "$env:ProgramData\ADK + WinPE\$AppName Installer"
        Start-Process -FilePath '.\adksetup.exe' -WorkingDirectory $WorkingDirectory -ArgumentList $DownloadArgumentList -Wait -Verb 'RunAs'
        $TargetLayoutFolder = try {Get-Item -Path $TargetLayout -ErrorAction 'Stop'} catch {New-Item -Path $TargetLayout -ItemType 'Directory' -Force}
        Move-Item -Path "$env:ProgramData\UserExperienceManifest.xml" -Destination "$TargetLayoutFolder"
        Move-Item -Path "$env:ProgramData\adksetup.exe" -Destination "$TargetLayoutFolder"
        Move-Item -Path "$env:ProgramData\Installers" -Destination "$TargetLayoutFolder" -Force
      }
      #endregion
      #region | Compress the Windows ADK Installation Files |
      $ZipFilePath = "$env:ProgramData\ADK + WinPE\$AppName.zip"
      $IsPresent = Test-Path -Path $ZipFilePath
      if (-not $IsPresent) {
        Compress-Archive -Path $TargetLayout -DestinationPath $ZipFilePath
      }
      #endregion
      #region | Extract the .zip file of Windows ADK Installation Files into the %UserProfile% |
      $IsPresent = Test-Path -Path "${Apps for OS Image Prep Folder}\$AppName Extracted"
      if (-not $IsPresent) {
        Expand-Archive -Path $ZipFilePath -DestinationPath "${Apps for OS Image Prep Folder}"
      }
      #endregion
      #region | Download but do not install the Windows PE Installation Files |
      $AppName = 'WinPE 2026-09'
      $TargetLayout = "$env:ProgramData\ADK + WinPE\$AppName Extracted"
      $IsPresent = Test-Path -Path $TargetLayout
      if (-not $IsPresent) {
        $DownloadArgumentList = @(
          '/quiet'
          '/ceip on'
          '/forcerestart'
          "/layout $env:ProgramData"
        )
        $WorkingDirectory = "$env:ProgramData\ADK + WinPE\$AppName Installer"
        Start-Process -FilePath '.\adkwinpesetup.exe' -WorkingDirectory $WorkingDirectory -ArgumentList $DownloadArgumentList -Wait -Verb 'RunAs'
        $TargetLayoutFolder = try {Get-Item -Path $TargetLayout -ErrorAction 'Stop'} catch {New-Item -Path $TargetLayout -ItemType 'Directory' -Force}
        Move-Item -Path "$env:ProgramData\UserExperienceManifest.xml" -Destination "$TargetLayoutFolder"
        Move-Item -Path "$env:ProgramData\adkwinpesetup.exe" -Destination "$TargetLayoutFolder"
        Move-Item -Path "$env:ProgramData\Installers" -Destination "$TargetLayoutFolder" -Force
      }
      #endregion
      #region | Compress the WinPE Installation Files |
      $ZipFilePath = "$env:ProgramData\ADK + WinPE\$AppName.zip"
      $IsPresent = Test-Path -Path $ZipFilePath
      if (-not $IsPresent) {
        Compress-Archive -Path $TargetLayout -DestinationPath $ZipFilePath
      }
      #endregion
      #region | Extract the .zip file of WinPE Installation Files into the %UserProfile% |
      $IsPresent = Test-Path -Path "${Apps for OS Image Prep Folder}\$AppName Extracted"
      if (-not $IsPresent) {
        Expand-Archive -Path $ZipFilePath -DestinationPath "${Apps for OS Image Prep Folder}"
      }
      #endregion
    }
  } | Out-Null
  #########################################-BOUNDARY-#########################################

) -join ''

${Bring ADK + WinPE Offline Installation Files into a %UserProfile% Container Script Path} = "${Apps for OS Image Prep Folder}\${WinPE 2026-09 Installer Folder Name}\Bring ADK + WinPE Offline Installation Files into a %UserProfile% Container Script.ps1"
Set-Content -Path ${Bring ADK + WinPE Offline Installation Files into a %UserProfile% Container Script Path} -Value (${Bring ADK + WinPE Offline Installation Files into a %UserProfile% Container Here-String})
$ArgumentList = @(
  "`${Here-String} = Get-Item -Path '${Bring ADK + WinPE Offline Installation Files into a %UserProfile% Container Script Path}' | Get-Content -Raw; `$ScriptBlock = [ScriptBlock]::Create(`${Here-String}); `$ScriptBlock | Invoke-Expression -Verbose"
)

${Windows ADK 2026-09 Extracted Folder Name} = 'Windows ADK 2026-09 Extracted'
${Windows ADK 2026-09 Extracted Folder Path} = "${Apps for OS Image Prep Folder}\${Windows ADK 2026-09 Extracted Folder Name}"

${WinPE 2026-09 Extracted Folder Name} = 'WinPE 2026-09 Extracted'
${WinPE 2026-09 Extracted Folder Path} = "${Apps for OS Image Prep Folder}\${WinPE 2026-09 Extracted Folder Name}"

if (
  -not (
    (Test-Path -Path "$env:ProgramData\ADK + WinPE\Windows ADK 2026-09.zip") -and `
    (Test-Path -Path "$env:ProgramData\ADK + WinPE\WinPE 2026-09.zip")       -and `
    (Test-Path -Path ${Windows ADK 2026-09 Extracted Folder Path})           -and `
    (Test-Path -Path ${WinPE 2026-09 Extracted Folder Path})
  )
) {Start-Process -ArgumentList $ArgumentList -FilePath powershell.exe -Wait -Verb 'RunAs'}
#endregion
#region | Groundwork Variables for offline install of ADK + WinPE |
$InputHT = @{
  'Offline WU-Original Server 2025 Folder Path' = "$PSScriptRoot\..\.CommonItems\Offline WU\Server 25\Original"
  'Offline WU-Patched Server 2025 Folder Path'  = "$PSScriptRoot\..\.CommonItems\Offline WU\Server 25\Patched"
  'WinPE Installs Path'                         = "$PSScriptRoot\..\.CommonItems\WinPE"
}
$OutputHT = & "$PSScriptRoot\Start\New directory set via script with returned objects.ps1" @InputHT
${Apps for OS Image Prep Folder} = $OutputHT['Apps for OS Image Prep Folder']

#$InstallsPath = "$PSScriptRoot\..\.CommonItems\WinPE"
#$path = "$InstallsPath\ADK + WinPE (2026-09)"
#$AppFolder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}

. "$PSScriptRoot\output\$FolderFQN\usb1\$FolderFQN\Base\5.1\Variables of Importance.ps1"
#endregion
#region | Main logic for offline install of ADK + WinPE |
$AppName = 'Windows ADK 2026-09'
$UninstallGuid = ${Windows ADK 2026-09 ProductId}
$InstallerArgumentList = @(
  '/quiet'
  '/ceip on'
  '/features OptionId.DeploymentTools'
)

#$IsZipPresent = Test-Path -Path "$AppFolder\$AppName.zip"
$IsZipPresent = Test-Path -Path "${Apps for OS Image Prep Folder}\$AppName.zip"
$IsInstalled = Test-Path -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{$UninstallGuid}"
switch ($true) {
  { # Zip is NOT present + App is NOT installed --->  Install + Compress. |
    (-not $IsZipPresent) -and (-not $IsInstalled)
  } {
    Write-Verbose -Message "    Zip is NOT present + App is NOT installed --->  Install + Compress."
    #region | Install Windows ADK or WinPE from offline files |
    #$WorkingDirectory = "$AppFolder\$AppName Extracted"
    $WorkingDirectory = "${Apps for OS Image Prep Folder}\$AppName Extracted"
    Start-Process -FilePath '.\adksetup.exe' -WorkingDirectory $WorkingDirectory -ArgumentList $InstallerArgumentList -Wait -Verb 'RunAs'
    #endregion
    #region | Compress Installation Files to .zip Flie |
    #Compress-Archive -Path "$AppFolder\$AppName Extracted" -DestinationPath "$AppFolder\$AppName.zip"
    Compress-Archive -Path "${Apps for OS Image Prep Folder}\$AppName Extracted" -DestinationPath "${Apps for OS Image Prep Folder}\$AppName.zip"
    #endregion
    break
  }
  { # Zip IS present + App is NOT installed     --->  Install. |
    ($IsZipPresent) -and (-not $IsInstalled)
  } {
    Write-Verbose -Message "    Zip IS present + App is NOT installed     --->  Install."
    #region | Install Windows ADK or WinPE from offline files |
    #$WorkingDirectory = "$AppFolder\$AppName Extracted"
    $WorkingDirectory = "${Apps for OS Image Prep Folder}\$AppName Extracted"
    Start-Process -FilePath '.\adksetup.exe' -WorkingDirectory $WorkingDirectory -ArgumentList $InstallerArgumentList -Wait -Verb 'RunAs'
    #endregion
    break
  }
  { # Zip is NOT present + App IS installed     --->  Shouldn't happen. Compress. |
    (-not $IsZipPresent) -and ($IsInstalled)
  } {
    Write-Verbose -Message "    Zip is NOT present + App IS installed     --->  Shouldn't happen. Compress."
    #region | Compress Installation Files to .zip Flie |
    #Compress-Archive -Path "$AppFolder\$AppName Extracted" -DestinationPath "$AppFolder\$AppName.zip"
    Compress-Archive -Path "${Apps for OS Image Prep Folder}\$AppName Extracted" -DestinationPath "${Apps for OS Image Prep Folder}\$AppName.zip"
    #endregion
    break
  }
  { # Zip IS present + App IS installed         --->  Do Nothing. |
    ($IsZipPresent) -and ($IsInstalled)
  } {
    Write-Verbose -Message "    Zip IS present + App IS installed         --->  Do Nothing."
    break
  }
}

$AppName = 'WinPE 2026-09'
$UninstallGuid = ${WinPE 2026-09 ProductId}
$InstallerArgumentList = @(
  '/quiet'
  '/ceip on'
  '/features OptionId.WindowsPreinstallationEnvironment'
)

#$IsZipPresent = Test-Path -Path "$AppFolder\$AppName.zip"
$IsZipPresent = Test-Path -Path "${Apps for OS Image Prep Folder}\$AppName.zip"
$IsInstalled = Test-Path -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{$UninstallGuid}"
switch ($true) {
  { # Zip is NOT present + App is NOT installed --->  Install + Compress. |
    (-not $IsZipPresent) -and (-not $IsInstalled)
  } {
    Write-Verbose -Message "    Zip is NOT present + App is NOT installed --->  Install + Compress."
    #region | Install Windows ADK or WinPE from offline files |
    #$WorkingDirectory = "$AppFolder\$AppName Extracted"
    $WorkingDirectory = "${Apps for OS Image Prep Folder}\$AppName Extracted"
    Start-Process -FilePath '.\adkwinpesetup.exe' -WorkingDirectory $WorkingDirectory -ArgumentList $InstallerArgumentList -Wait -Verb 'RunAs'
    #endregion
    #region | Compress Installation Files to .zip Flie |
    #Compress-Archive -Path "$AppFolder\$AppName Extracted" -DestinationPath "$AppFolder\$AppName.zip"
    Compress-Archive -Path "${Apps for OS Image Prep Folder}\$AppName Extracted" -DestinationPath "${Apps for OS Image Prep Folder}\$AppName.zip"
    #endregion
    break
  }
  { # Zip IS present + App is NOT installed     --->  Install. |
    ($IsZipPresent) -and (-not $IsInstalled)
  } {
    Write-Verbose -Message "    Zip IS present + App is NOT installed     --->  Install."
    #region | Install Windows ADK or WinPE from offline files |
    #$WorkingDirectory = "$AppFolder\$AppName Extracted"
    $WorkingDirectory = "${Apps for OS Image Prep Folder}\$AppName Extracted"
    Start-Process -FilePath '.\adkwinpesetup.exe' -WorkingDirectory $WorkingDirectory -ArgumentList $InstallerArgumentList -Wait -Verb 'RunAs'
    #endregion
    break
  }
  { # Zip is NOT present + App IS installed     --->  Shouldn't happen. Compress. |
    (-not $IsZipPresent) -and ($IsInstalled)
  } {
    Write-Verbose -Message "    Zip is NOT present + App IS installed     --->  Shouldn't happen. Compress."
    #region | Compress Installation Files to .zip Flie |
    #Compress-Archive -Path "$AppFolder\$AppName Extracted" -DestinationPath "$AppFolder\$AppName.zip"
    Compress-Archive -Path "${Apps for OS Image Prep Folder}\$AppName Extracted" -DestinationPath "${Apps for OS Image Prep Folder}\$AppName.zip"
    #endregion
    break
  }
  { # Zip IS present + App IS installed         --->  Do Nothing. |
    ($IsZipPresent) -and ($IsInstalled)
  } {
    Write-Verbose -Message "    Zip IS present + App IS installed         --->  Do Nothing."
    break
  }
}
#endregion
#endregion

#region | Download WinPE Driver Pack from Dell or HP |
$path = "$PSScriptRoot\..\.CommonItems\WinPE\ADK + WinPE (2026-09)\WinPE Driver Packs"
$folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}

${SHA256 of Dell WinPE Driver Pack A11} = Import-CliXml -Path "$PSScriptRoot\..\.CommonItems\SHA256 of Dell WinPE Driver Pack A11.clixml"
$hash = ${SHA256 of Dell WinPE Driver Pack A11}
${Dell WinPE Driver Pack A11 File} = Get-ChildItem -Path "$folder" -File `
| Where-Object -PipelineVariable 'file' -FilterScript {$_.Extension -eq '.cab'} `
| ForEach-Object -Process {Get-FileHash -Path $file.FullName -Algorithm 'SHA256' `
| Where-Object -PipelineVariable 'AlgoHashPath' -FilterScript {$_.Hash -eq $hash} `
| ForEach-Object -Process {Get-Item -Path $AlgoHashPath.Path}} `
| Sort-Object -Property 'LastWriteTime' -Descending `
| Select-Object -First 1

if (${Dell WinPE Driver Pack A11 File} -eq $null) {
  $JobName = 'Download Dell WinPE Driver Pack A11 File'
  $RunningJob = Get-Job | Where-Object -FilterScript {
    $_.Name  -eq $JobName  -and `
    $_.State -eq 'Running'
  }
  if ($RunningJob -eq $null) {
    $ArgumentList = @(
      'https://downloads.dell.com/FOLDER15124725M/1/WinPE11.0-Drivers-A11-KHF4P.cab'
      "$folder\WinPE11.0-Drivers-A11-KHF4P.cab"
      $ProgressPreference
      "$PSScriptRoot\A0\Extract-MSUAndCAB.ps1"
    )

    Start-Job -Name $JobName -ArgumentList $ArgumentList -ScriptBlock {
      $WebPath                           = $args[0]
      $FilePath                          = $args[1]
      $OriginalProgressPreference        = $args[2]
      ${Extract-MSUAndCAB.ps1 File Path} = $args[3]

      $ProgressPreference = 'SilentlyContinue'
      Invoke-WebRequest -Uri $WebPath -OutFile $FilePath
      $ProgressPreference = $OriginalProgressPreference

      $ParentFolder = [System.IO.FileInfo]$FilePath | Select-Object -ExpandProperty 'DirectoryName'
      $path = "$ParentFolder\Dell A11"; 
      ${Extracted WinPE Driver Pack Dell A11 folder} = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
      
      $InputHT = @{
        FilePath        = $FilePath
        DestinationPath = "${Extracted WinPE Driver Pack Dell A11 folder}"
      }
      . ${Extract-MSUAndCAB.ps1 File Path}
      Extract-MSUAndCAB @InputHT
    } | Out-Null
  }
}
#endregion

#region | External Removable Bootable Media > Clear Disk > EFS (EFI System Partition) |
. "$PSScriptRoot\output\$FolderFQN\usb1\$FolderFQN\Base\5.1\External Bootable Media Drive Letters.ps1"
#endregion

<#
  # [ ] Implementation Complete
  # Notes on running Windows Setup in Windows PE: 
  start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/winpe-intro?view=windows-11#notes-on-running-windows-setup-in-windows-pe'
  # Configuration Passes Explained:
  start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/windows-setup-configuration-passes?view=windows-11'

  Pure gold: 
  start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/get-started/adk-install#download-the-adk-101280001-november-2025'
  start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/download-winpe--windows-pe?view=windows-11'
  start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/deploy-a-custom-image?view=windows-11'
  start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/winpe-intro?view=windows-11'
  start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/winpe-mount-and-customize?view=windows-11'

  # Unmount the WinPE image and create media
  start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/winpe-mount-and-customize?view=windows-11#unmount-the-windows-pe-image-and-create-media'
  
  # CLI Options for the MakeWinPeMedia.cmd batch file
  start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/makewinpemedia-command-line-options?view=windows-11&source=recommendations#makewinpemedia-parameters'

  # DISM in PowerShell
  start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/use-dism-in-windows-powershell-s14?view=windows-11'

  # Windows 11 Image Creation for OEMs (professional-level)
  start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/system-builder-deployment?view=windows-11'

  # Install Windows from a Flash Drive
  start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/install-windows-from-a-usb-flash-drive?view=windows-11'

  On GPT drives the System partition is the "EFI System Partition", or the ESP. 
  Stored on primary hard drive, which means the hard drive that contains an OS for the end-user? 
  A device boots to the ESP:   start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/configure-uefigpt-based-hard-drive-partitions?view=windows-11#system-partition'

  start msedge.exe 'https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/set-id'
  start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/configure-uefigpt-based-hard-drive-partitions?view=windows-11'

  # WinPE Startup Scripts: 
  start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/wpeinit-and-startnetcmd-using-winpe-startup-scripts?view=windows-11'

  # Apply Windows images on a newly created partition: 
  start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/capture-and-apply-windows-system-and-recovery-partitions?view=windows-11'

  # Windows Factory OS for OEMs. Windows Factory OS is targeted at two use cases: factory floor and driver development. 
  start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/factoryos/?view=windows-11'

  # Install Windows from a Flash Drive
  'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/install-windows-from-a-usb-flash-drive?view=windows-11'

  # Deployment Lab Sample Scripts
  start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/oem-deployment-of-windows-desktop-editions-sample-scripts?view=windows-11&preserve-view=true#-createpartitions-uefitxt'
  
  # GPT Type
  start msedge.exe 'https://learn.microsoft.com/en-us/powershell/module/storage/new-partition?view=windowsserver2025-ps#-gpttype'

  Deployment Tools Reference for WinPE. 
  start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/winpe-intro?view=windows-11'

  All changes to the running instance of a WinPE OS are lost when WinPE reboots, including drivers, drive letters, and the WinPE Registry. 
  You'll want a customized WinPE image to work with:  
  start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/winpe-mount-and-customize?view=windows-11'

  Create bootable WinPE Media
  start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/winpe-create-usb-bootable-drive?view=windows-11'

  Boot To WinPE:
  start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/boot-to-winpe?view=windows-11'
  
  # Add Windows PowerShell support to the WinPE OS
  start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/winpe-adding-powershell-support-to-windows-pe?view=windows-11'


  Installation of the RSATs on an offline mounted image of Windows 11 Enterprise | I'm starting to accept that this isn't possible! |
  start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/features-on-demand-non-language-fod?view=windows-11#remote-server-administration-tools-rsat'
  start msedge.exe 'https://github.com/IrrevocableNoob/RSAT-FOD-Offline-Install'
  start msedge.exe 'https://learn.microsoft.com/en-us/azure/virtual-desktop/windows-11-language-packs'
  start msedge.exe 'https://learn.microsoft.com/en-us/azure/virtual-desktop/windows-11-language-packs#prerequisites'
  start msedge.exe 'https://software-static.download.prss.microsoft.com/dbazure/888969d5-f34g-4e03-ac9d-1f9786c66749/26100.6584.250904-1728.ge_release_svc_prod1_amd64fre_InboxApps.iso'

  # Add Windows Capabilities: 
  DISM.exe /Image:"$ns\reimages\m0unted_w1m" /Add-Capability /CapabilityName:"Rsat.ServerManager.Tools~~~~0.0.1.0" /Source:"$usb0\"


  On GPT drives the System partition is the "EFI System Partition", or the ESP. 
  Stored on primary hard drive, which means the hard drive that contains an OS for the end-user? 
  A device boots to the ESP. 

  start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/configure-uefigpt-based-hard-drive-partitions?view=windows-11#system-partition'

  # Capture and apply a Windows image using a single .WIM file
  start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/capture-and-apply-windows-using-a-single-wim?view=windows-11'

  # [x] Implementation Complete
  # Use newer version of DISM in WinPE: 
  # Step 1: start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/copy-dism-to-another-computer?view=windows-11'
  # Step 2: start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/copy-dism-to-another-computer?view=windows-11#use-the-new-version-of-dism'
#>

<#
  # Windows Setup Technical Reference. Install Windows OS from a USB:
  start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/windows-setup-technical-reference?view=windows-11'
#>

#region | XML Files |
$path = "$PSScriptRoot\..\.CommonItems\usb0"
$usb0folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
& "$PSScriptRoot\Start\ADK + WinPE\XML Answer File Writer.ps1"
#endregion

#region | PowerShell-enabled Removable External Bootable Media for WinPE Deployment |
if ($null -ne ${OSDeploy Disk CIM Instance}) { # If the USB isn't detected/connected, then don't attempt work on that USB!
  ${WinPE Workspace Folder Name} = 'PowerShell-Infused'
  $InputHT = @{
    'WinPE Workspace Folder Name' = ${WinPE Workspace Folder Name}
  }
  $OutputHT = & "$PSScriptRoot\Start\ADK + WinPE\Bootable USB with PowerShell-enabled WinPE.ps1" @InputHT
  ${Bootable USB with PowerShell-enabled WinPE Script Path} = $OutputHT['Bootable USB with PowerShell-enabled WinPE Script Path']
  $WorkingDirectory = $OutputHT['WorkingDirectory']
  ${WinPE Image Creation Parent Folder} = $OutputHT['WinPE Image Creation Parent Folder']
  $path = "${WinPE Image Creation Parent Folder}\${WinPE Workspace Folder Name}"
  $IsPresent = Test-Path -Path $path
  if (-not $IsPresent) {
    $ArgumentList2 = @(
      $WorkingDirectory
      ${Bootable USB with PowerShell-enabled WinPE Script Path}
    )

    $WpeJobName = 'Bootable USB with PowerShell-enabled WinPE'
    $WpeRunningJob = Get-Job | Where-Object -FilterScript {
      $_.Name  -eq $WpeJobName  -and `
      $_.State -eq 'Running'
    }
    if ($WpeRunningJob -eq $null) {
      Start-Job -Name $WpeJobName -ArgumentList $ArgumentList2 -ScriptBlock {
        $WorkingDirectory = $args[0]
        ${Bootable USB with PowerShell-enabled WinPE Script Path} = $args[1]
        $ArgumentList = @(
          "/c $([System.Char]34)$WorkingDirectory\DandISetEnv.bat$([System.Char]34) && powershell.exe -NoProfile -ExecutionPolicy 'RemoteSigned'; Invoke-Expression -Command (Get-Content -Raw -Path '${Bootable USB with PowerShell-enabled WinPE Script Path}');"
        )
        Start-Process -FilePath cmd.exe -ArgumentList $ArgumentList -Verb 'RunAs' -WorkingDirectory $WorkingDirectory -WindowStyle 'Hidden' -Wait  #  -NoNewWindow
      } | Out-Null
    }
  }
}
#endregion

#region | Patch offline Windows Server 2025 .iso file |
#region | Re-confirm that 'Windows Server 2025.iso' has downloaded to the 'Original' directory |
#region | Ensure the 'Original' and 'Patched' Folders have been created |
$path = "$PSScriptRoot\..\.CommonItems\Offline WU\Server 25\Original"
${Offline WU-Original Server 2025 Folder} = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
$path = "$PSScriptRoot\..\.CommonItems\Offline WU\Server 25\Patched"
${Offline WU-Patched Server 2025 Folder} = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
#endregion
${Is ISO Already Relocated and Renamed} = Test-Path -Path "${Offline WU-Original Server 2025 Folder}\Windows Server 2025.iso"
if (-not ${Is ISO Already Relocated and Renamed}) {
  ${SHA256 of Windows Server 2025 ISO File} = Import-CliXml -Path "$PSScriptRoot\..\.CommonItems\SHA256 of Windows Server 2025 ISO File.clixml"
  $hash = ${SHA256 of Windows Server 2025 ISO File}
  ${Windows Server 2025 ISO Original File} = Get-ChildItem -Path ${env:.CommonItems} -Recurse -File -ErrorAction 'SilentlyContinue' `
  | Where-Object -PipelineVariable 'file' -FilterScript {$_.Extension -eq '.iso'} `
  | ForEach-Object -Process {Get-FileHash -Path $file.FullName -Algorithm 'SHA256' `
  | Where-Object -PipelineVariable 'AlgoHashPath' -FilterScript {$_.Hash -eq $hash} `
  | ForEach-Object -Process {Get-Item -Path $AlgoHashPath.Path}} `
  | Sort-Object -Property 'LastWriteTime' -Descending `
  | Select-Object -First 1

  if (${Windows Server 2025 ISO Original File} -eq $null) { # Download the unpatched ISO file for Server 2025 if not detected anywhere within ${env:.CommonItems} |
    $JobName = 'Download Windows Server 2025 ISO File'
    $RunningJob = Get-Job | Where-Object -FilterScript {
      $_.Name  -eq $JobName  -and `
      $_.State -eq 'Running'
    }
    if ($RunningJob -eq $null) {
      $ArgumentList = @(
        'https://go.microsoft.com/fwlink/?linkid=2293312&clcid=0x409&culture=en-us&country=us'
        "${Offline WU-Original Server 2025 Folder}\Windows Server 2025.iso"
        $ProgressPreference
      )

      Start-Job -Name $JobName -ArgumentList $ArgumentList -ScriptBlock {
        $WebPath                    = $args[0]
        $FilePath                   = $args[1]
        $OriginalProgressPreference = $args[2]

        $ProgressPreference = 'SilentlyContinue'
        Invoke-WebRequest -Uri $WebPath -OutFile $FilePath
        $ProgressPreference = $OriginalProgressPreference
      } | Out-Null
    }
  } 
  else { # If an unpatched ISO file for Server 2025 is confirmed to be inside ${env:.CommonItems}, ensure that file has been transplanted and appropriately renamed |
    ${Is ISO Already Relocated and Renamed} = Test-Path -Path "${Offline WU-Original Server 2025 Folder}\Windows Server 2025.iso"
    if (-not ${Is ISO Already Relocated and Renamed}) {
      Move-Item -Path ${Windows Server 2025 ISO Original File}.FullName -Destination "${Offline WU-Original Server 2025 Folder}\Windows Server 2025.iso"
    }
  }
} else {${Windows Server 2025 ISO Original File} = [System.IO.FileInfo]"${Offline WU-Original Server 2025 Folder}\Windows Server 2025.iso"}
#endregion
#region | Deploy new directory for downloading latest Windows Updates |
Write-Host "`n`tPatch Tuesday Of This Month:`n"
${Patch Tuesday Of This Month}
${Patch Tuesday Of This Month Has Already Arrived} = [System.DateTime]::Now -gt ${Patch Tuesday Of This Month}
Write-Host "`n`tHas Patch Tuesday Of This Month Already Arrived?`n`n`t`${Patch Tuesday Of This Month Has Already Arrived} = ${Patch Tuesday Of This Month Has Already Arrived}`n"

if (${Patch Tuesday Of This Month Has Already Arrived}) {
  ${Windows Updates Directory BaseName} = [System.String]::Format('{0:yyyy}-{0:MM}',[System.DateTime]::Now)
} else {
  ${Windows Updates Directory BaseName} = [System.String]::Format('{0:yyyy}-{0:MM}',([System.DateTime]::Now).AddMonths(-1))
}

$path = "$PSScriptRoot\..\.CommonItems\Offline WU\Microsoft Update\${Windows Updates Directory BaseName}"
$folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
#endregion
#region | Drivers |
$path = "$PSScriptRoot\..\.CommonItems\Offline WU\Drivers"
$folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
Write-Host -Object "`n  Prepare your Drivers folder. Press Enter when ready to proceed.`n" -ForegroundColor $(rFc)
<#
  $drivers128 = 'J:'
  $destination = "$env:UserProfile\GitHub\CarlSimonIT\.CommonItems\Offline WU\Drivers"

  $HT = @{
    Path        = "$drivers128\drivers\realtek\RTL8168E\Install_PCIE_WinServer2025"
    Destination = $destination
    Recurse     = $true
    Force       = $true
  }
  Copy-Item @HT

  $HT = @{
    Path        = "$drivers128\drivers\dell\Dell Precision 3460\Intel Graphics Driver (2026-08-10)\ext"
    Destination = "$destination"
    Recurse     = $true
    Force       = $true
  }
  Copy-Item @HT
  Get-Item -Path "$destination\ext" | Rename-Item -NewName 'Intel Graphics Driver (2026-08-10)'

  $HT = @{
    Path        = "$drivers128\drivers\dell\Dell Precision 3460\Intel HID Event Filter Driver (2026-02-05)\ext"
    Destination = "$destination"
    Recurse     = $true
    Force       = $true
  }
  Copy-Item @HT
  Get-Item -Path "$destination\ext" | Rename-Item -NewName 'Intel HID Event Filter Driver (2026-02-05)'

  ## Temporary Halt
  # $HT = @{
  #   Path        = "$drivers128\drivers\dell\Dell Precision 3460\Intel Innovation Platform Framework and Provider Package Driver (2026-07-26)\ext"
  #   Destination = "$destination"
  #   Recurse     = $true
  #   Force       = $true
  # }
  # Copy-Item @HT
  # Get-Item -Path "$destination\ext" | Rename-Item -NewName 'Intel Innovation Platform Framework and Provider Package Driver (2026-07-26)'

  $HT = @{
    Path        = "$drivers128\drivers\dell\Dell Precision 3460\Intel ME Components Installer"
    Destination = "$destination"
    Recurse     = $true
    Force       = $true
  }
  Copy-Item @HT

  $HT = @{
    Path        = "$drivers128\drivers\dell\Dell Precision 3460\Intel PCIe Ethernet Controller Driver (2026-06-03)\ext"
    Destination = "$destination"
    Recurse     = $true
    Force       = $true
  }
  Copy-Item @HT
  Get-Item -Path "$destination\ext" | Rename-Item -NewName 'Intel PCIe Ethernet Controller Driver (2026-06-03)'

  $HT = @{
    Path        = "$drivers128\drivers\dell\Dell Precision 3460\Intel RST"
    Destination = "$destination"
    Recurse     = $true
    Force       = $true
  }
  Copy-Item @HT
  
  $HT = @{
    Path        = "$drivers128\drivers\dell\Dell Precision 3460\Intel Serial IO Driver (2026-02-12)\ext"
    Destination = "$destination"
    Recurse     = $true
    Force       = $true
  }
  Copy-Item @HT
  Get-Item -Path "$destination\ext" | Rename-Item -NewName 'Intel Serial IO Driver (2026-02-12)'
#>
pause
Write-Host -Object "`n  Are you sure you've got all the drivers you want installed into the offline image sitting within '.\..\.CommonItems\Offline WU\Drivers' and extracted? This is your last chance.`n" -ForegroundColor $(rFc)
pause
#endregion
#region | Download Latest Windows Updates for Server 2025 |
${Windows Updates Directory FullName} = Resolve-Path -Path "$PSScriptRoot\..\.CommonItems\Offline WU\Microsoft Update\${Windows Updates Directory BaseName}" | Select-Object -ExpandProperty 'Path'
${Download Latest Windows Updates for Server 2025-Note to User} = @"
  MANDATORY: Obtain the latest Cumulative Updates for Windows Server 2025
  > Visit the Windows Server Update History page: 'https://support.microsoft.com/en-us/servicing/os/windows-server/2024/10/windows-server-2025-update-history'
    > Select the latest release 
      > Choose the 'Catalog' tab 
        > Scroll down to the 'x64 installation instructions' dropdown 
          > Note the 'Required checkpoint cumulative update' and the 'Target cumulative update' 
            > Download those two .msu files from the Microsoft Update web portal: 'https://www.catalog.update.microsoft.com'

  OPTIONAL: Find the latest .NET Framework update
  > Search the Microsoft Update web portal for the string below: 
    ${Windows Updates Directory BaseName} Cumulative Update for .NET Framework 3.5 and 4.8.1 for Microsoft server operating system version 24H2 for x64
    > Download the latest .NET Framework update. 

  Relocate the three .msu files to the following directory: 
  `t$([System.Char]39)${Windows Updates Directory FullName}$([System.Char]39)`n
"@
Write-Host -Object ${Download Latest Windows Updates for Server 2025-Note to User} -ForegroundColor $(rFc)
pause
Write-Host -Object "`n  Open a web browser and perform the above instructions.   `n" -ForegroundColor $(rFc)
pause
Write-Host -Object "`n  Do you have the three files? If so, hit Enter.   `n" -ForegroundColor $(rFc)
pause
#endregion
#region | Apply Windows Updates patches to an offline Windows Server 2025 image |
Write-Host -Object "`n  Apply Windows Updates patches to an offline Windows Server 2025 image.   `n" -ForegroundColor ([System.ConsoleColor]::DarkMagenta)
${Executed Command} = @'
'@
Write-Host -Object "  Literal text representation of command being executed is:`n" -ForegroundColor ([System.ConsoleColor]::DarkMagenta)
Write-Host -Object ${Executed Command} -ForegroundColor ([System.ConsoleColor]::DarkYellow)
Write-Host -Object "`n  Supply admin credentials when the UAC prompt appears:`n  " -ForegroundColor ([System.ConsoleColor]::DarkMagenta)
pause

$path = "$PSScriptRoot\..\.CommonItems\Offline WU\Microsoft Update\Packages"
$PackagesFolder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}

Get-ChildItem -Path ${Windows Updates Directory FullName} -File | ForEach-Object -Process {
  $IsPresent = Test-Path -Path "$PackagesFolder\$($_.Name)"
  if (-not $IsPresent) {
    Copy-Item -Path $_.FullName -Destination "$PackagesFolder"
  }
}

#region | These variables are referenced elsewhere in '.\Start.ps1' so they must be defined unconditionally |
${Extracted ISO Folder Path} = "$PSScriptRoot\..\.CommonItems\Offline WU\Server 25\Extracted ISO"
${mounted_wim Folder Path} = "$PSScriptRoot\..\.CommonItems\Offline WU\Server 25\mounted_wim"
#endregion

if ($null -ne "${Offline WU-Original Server 2025 Folder}\Windows Server 2025.iso") {
  $path = "$PSScriptRoot\..\.CommonItems\Offline WU\Server 25\Patched"
  ${Offline WU-Patched Server 2025 Folder} = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
  ${Windows Server 2025 ISO Patched File} = [System.IO.FileInfo]"${Offline WU-Patched Server 2025 Folder}\Windows Server 2025.iso"
  ${Is the Downloaded .ISO of Windows Server 2025 Patched and Available?} = Test-Path -Path ${Windows Server 2025 ISO Patched File}.FullName
  if (-not ${Is the Downloaded .ISO of Windows Server 2025 Patched and Available?}) {
    #region | Patching Mounted Server 2025 .iso File-Part 1 |
    $InputHT = @{
      'Windows Server 2025 ISO Original File Path' = ${Windows Server 2025 ISO Original File}.FullName
      'Windows Server 2025 ISO Patched File Path'  = ${Windows Server 2025 ISO Patched File}.FullName
    }
    $OutputHT = & "$PSScriptRoot\Start\ADK + WinPE\WU s25 Part 01-Mount Original Windows Server ISO File at IL-High.ps1" @InputHT
    ${WU s25 Part 01-Mount Original Windows Server ISO File at IL-High Script Path} = $OutputHT['WU s25 Part 01-Mount Original Windows Server ISO File at IL-High Script Path']
    $ArgumentList = @(
      "Invoke-Expression -Command (Get-Content -Raw -Path '${WU s25 Part 01-Mount Original Windows Server ISO File at IL-High Script Path}')"
    )
    #$JobName = "WU s25 Part 03-Dismount ISO, Apply Updates, Package into Patched ISO at IL-High"
    ${Windows Updates on Offline Server 2025 Images-Part 03 Job Name} = 'WU s25 Part 03-Dismount ISO, Apply Updates, Package into Patched ISO at IL-High'
    ${Running Job} = Get-Job | Where-Object -FilterScript {
      $_.Name  -eq ${Windows Updates on Offline Server 2025 Images-Part 03 Job Name} -and `
      $_.State -eq 'Running'
    }
    if (${Running Job} -eq $null) {
      Start-Process -FilePath powershell.exe -ArgumentList $ArgumentList -Verb 'RunAs' -WindowStyle 'Hidden' -Wait
    }
    #endregion

    #region | Patching Mounted Server 2025 .iso File-Part 2 |
    $InputHT = @{
      'Extracted ISO Folder Path' = ${Extracted ISO Folder Path}
    }
    $OutputHT = & "$PSScriptRoot\Start\ADK + WinPE\WU s25 Part 02-Copy Mounted Contents at IL-Medium.ps1" @InputHT
    ${WU s25 Part 02-Copy Mounted Contents at IL-Medium Script Path} = $OutputHT['WU s25 Part 02-Copy Mounted Contents at IL-Medium Script Path']
    #Write-Host -Object "`${WU s25 Part 02-Copy Mounted Contents at IL-Medium Script Path} = ${WU s25 Part 02-Copy Mounted Contents at IL-Medium Script Path}"
    $ArgumentList = @(
      "Invoke-Expression -Command (Get-Content -Raw -Path '${WU s25 Part 02-Copy Mounted Contents at IL-Medium Script Path}')"
    )
    ${Windows Updates on Offline Server 2025 Images-Part 03 Job Name} = 'WU s25 Part 03-Dismount ISO, Apply Updates, Package into Patched ISO at IL-High'
    ${Running Job} = Get-Job | Where-Object -FilterScript {
      $_.Name  -eq ${Windows Updates on Offline Server 2025 Images-Part 03 Job Name} -and `
      $_.State -eq 'Running'
    }
    if (${Running Job} -eq $null) {
      Start-Process -FilePath powershell.exe -ArgumentList $ArgumentList -Wait -WindowStyle 'Normal' # 'Hidden'
    }

    Start-Sleep 10
    #endregion

    #region | Patching Mounted Server 2025 .iso File-Part 3 |
    #region | Define the 'Windows Server Image Index Set' variable |
    # Import custom class to enumerate the Windows Server Image Index collection
    . "$PSScriptRoot\output\$FolderFQN\usb1\$FolderFQN\Base\5.1\Class Definitions\Windows Server Image Index.ps1"
    # Comment/Un-comment your desired images. 
    # VMs use both the Desktop Experience and Server Core versions of Windows Server Standard. 
    # Bare-metal deployments implement Windows Server Datacenter with Desktop Experience
    # I usually don't use Server Core version of Windows Server Datacenter edition. 
    ${Windows Server Image Index Set} = [System.UInt32[]]@(
      [System.UInt32][WindowsServerImageIndex]::StandardServerCore
      [System.UInt32][WindowsServerImageIndex]::StandardDesktopExperience
      [System.UInt32][WindowsServerImageIndex]::DatacenterServerCore
      [System.UInt32][WindowsServerImageIndex]::DatacenterDesktopExperience
    )
    #endregion

    ${install.wim File Path} = "${env:.CommonItems}\Offline WU\Server 25\Extracted ISO\sources\install.wim"
    $InputHT = @{
      'Windows Server Image Index Set'            = ${Windows Server Image Index Set}
      'install.wim File Path'                     = ${install.wim File Path}
      'mounted_wim Folder Path'                   = ${mounted_wim Folder Path}
      'Package Directory Path'                    = "$PackagesFolder"
      'Windows Server 2025 ISO Patched File Path' = ${Windows Server 2025 ISO Patched File}.FullName
    }
    $OutputHT = & "$PSScriptRoot\Start\ADK + WinPE\WU s25 Part 03-Dismount ISO, Apply Updates, Package into Patched ISO at IL-High.ps1" @InputHT

    ${WU s25 Part 03-Dismount ISO, Apply Updates, Package into Patched ISO at IL-High Script Path} = $OutputHT['WU s25 Part 03-Dismount ISO, Apply Updates, Package into Patched ISO at IL-High Script Path']
    $ArgumentListProcess = @(
      "Invoke-Expression -Command (Get-Content -Raw -Path '${WU s25 Part 03-Dismount ISO, Apply Updates, Package into Patched ISO at IL-High Script Path}')"
    )

    ${Windows Updates on Offline Server 2025 Images-Part 03 Job Name} = 'WU s25 Part 03-Dismount ISO, Apply Updates, Package into Patched ISO at IL-High'
    ${Running Job} = Get-Job | Where-Object -FilterScript {
      $_.Name  -eq ${Windows Updates on Offline Server 2025 Images-Part 03 Job Name} -and `
      $_.State -eq 'Running'
    }
    if (${Running Job} -eq $null) {
      $ArgumentListJob = @(
        $ArgumentListProcess
      )
      
      # Perform this check once again to be extremely sure that the patched .iso file is not present: 
      ${Is the Downloaded .ISO of Windows Server 2025 Patched and Available?} = Test-Path -Path "$PSScriptRoot\..\.CommonItems\Offline WU\Server 25\Patched\Windows Server 2025.iso"
      if (-not ${Is the Downloaded .ISO of Windows Server 2025 Patched and Available?}) {
        Write-Host -Object "`n  Patching the ($(${Windows Server Image Index Set}.Count)) images of Windows Server 2025 will take quite some time.`n" -ForegroundColor $(rFc)
        pause
        Write-Host -Object "`n  Press Enter when ready to proceed.`n" -ForegroundColor $(rFc)
        pause
        Start-Job -Name ${Windows Updates on Offline Server 2025 Images-Part 03 Job Name} -ArgumentList $ArgumentListJob -ScriptBlock {
          $ArgumentListProcess = $args[0]
          Start-Process -FilePath powershell.exe -ArgumentList $ArgumentListProcess -Verb 'RunAs' -WindowStyle 'Maximized' -Wait
        } | Out-Null
      }
    }
    #endregion
  }
}
#endregion
#endregion

#region | Write install.swm files to OSDeploy |
$path = "$PSScriptRoot\..\.CommonItems\Offline WU\Server 25\Split"
${Offline WU-Split Wim Server 2025 Folder} = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
${Windows Server 2025 Split Wim File} = [System.IO.FileInfo]"${Offline WU-Split Wim Server 2025 Folder}\install.swm"
$IsPresent = Test-Path -Path ${Windows Server 2025 Split Wim File}
if ($IsPresent) { # If the .swm is present, then format the other 80% of the $OSDeploy USB drive |
  # Check if the  |
  $JobName = "WU s25 Part 03-Dismount ISO, Apply Updates, Package into Patched ISO at IL-High"
  $RunningJob = Get-Job | Where-Object -FilterScript {
    $_.Name  -eq $JobName  -and `
    $_.State -eq 'Running'
  }
  if ($null -ne $RunningJob) {
    Get-Job -Name $RunningJob | Wait-Job    
  }

  # Format the other 80% of the $OSDeploy USB drive. It's a simple Robocopy. 
  # Oh fuck, but then how would the goddamn autounattend.xml work!? 
  # the .swm is compatible with  autounattend.xml. 

  <#
    #region | Detect Removable External Storage Media |
    #region | Patterns |
    #${Pattern UniqueId Raw-OLD} = '^(?<Unique_ID>.+)\:(?<Computer_Name>(?!(\d{1,15}|ANONYMOUS|BATCH|BUILTIN|DIALUP|DOMAIN|ENTERPRISE|INTERACTIVE|INTERNET|LOCAL|NETWORK|NULL|PROXY|RESTRICTED|SELF|SERVER|SERVICE|SYSTEM|USERS|WORLD)$)[a-z0-9][a-z0-9-]{1,13}[a-z0-9])$'
    #${Pattern UniqueId Raw} = '^(?<Unique_ID>.+)(\:)?$'
    #${Pattern UniqueId Raw} = '^(?<Unique_ID>.+)(\:.*)?$'
    #${Pattern UniqueId Raw} = '^(?<Unique_ID>.+)((?<Discarded>\:.*))?$'
    #${Pattern UniqueId Raw} = '^(?<Unique_ID>.+)(?<Discarded>\:.*)?$'
    ${Pattern UniqueId Raw} = '^(?<Unique_ID>[^:]+)(?<Discarded>\:.*)?$'
    #endregion
    #region | Save to variable the volume letter of the external bootable media |
    ${OSDeploy FriendlyName} = 'Samsung Flash Drive'
    ${OSDeploy UniqueId Raw} = 'USBSTOR\DISK&VEN_SAMSUNG&PROD_FLASH_DRIVE&REV_1100\0373515120000331&0:DESKTOP-6OM9723'
    ${OSDeploy UniqueId Raw} -match ${Pattern UniqueId Raw} | Out-Null
    ${OSDeploy UniqueId} = $Matches['Unique_ID']
    ${OSDeploy SerialNumber} = 'AA00000000000489'

    $disk = Get-Disk | Where-Object -FilterScript {
      $_.FriendlyName -eq    ${OSDeploy FriendlyName}                                             -and `
      $_.UniqueId     -match [System.Text.RegularExpressions.Regex]::Escape(${OSDeploy UniqueId}) -and `
      $_.SerialNumber -eq    ${OSDeploy SerialNumber}
    }
    if ($null -ne $disk) {
      #$partition = Get-Partition -DiskNumber $disk.Number | Select-Object -First 1
      ${Volume DriveLetters Precursor} = Get-Partition -DiskNumber $disk.Number | Get-Volume | Select-Object -ExpandProperty 'DriveLetter'
      #$OSDeploy = [System.String]$partition.DriveLetter + ":"
      foreach (${Volume DriveLetter Precursor} in ${Volume DriveLetters Precursor}) {
        ${Volume DriveLetter} = [System.String]${Volume DriveLetter Precursor} + ':'
        $IsWindowsOS = Test-Path -Path "${Volume DriveLetter}\setup.exe"
        if ($IsWindowsOS) {
          $OSDeploy = ${Volume DriveLetter}
        }
      }
    }
    #endregion
    #endregion



  #>
}
#endregion

#region | Download tasks |
#region | Download, but do not install, DSC Resource modules |
$path = "$PSScriptRoot\..\.CommonItems\usb0\$FolderFQN\cfg\DSC Resources\PowerShell Gallery"
#            $path = 'C:\Users\lowpr\GitHub\CarlSimonIT\.CommonItems\usb0\Instant-ADCS\cfg\DSC Resources\PowerShell Gallery'
$folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
${DSC Resource module Save Path} = "$folder"
Export-CliXml -Path "$PSScriptRoot\..\.CommonItems\DSC Resource module Save Path.clixml" -InputObject (${DSC Resource module Save Path})

#$ArrayList = [System.Collections.ArrayList]::New()

${DSC Resource Module Names} = @(
  'ActiveDirectoryCSDsc'
  'ActiveDirectoryDsc'
  'AuditPolicyDsc'
  'cDhcpServerDynamicUpdate'
  'CertificateDsc'
  'cHyper-V'
  'ComputerManagementDsc'
  'DhcpServerDsc'
  'DnsServerDsc'
  'GroupPolicyDsc'
  'HyperVDsc'
  #'JeaDsc'
  'NetworkingDsc'
  'SecurityPolicyDsc'
  'StorageDsc'
  'UpdateServicesDsc'
  'WebAdministrationDsc'
  'WmiNamespaceSecurity'
  'WSManDsc'
  'xCIMSecurity'
  'xComputerManagement'
  'xPendingReboot'
  'xPSDesiredStateConfiguration'
)
Export-CliXml -Path "$PSScriptRoot\..\.CommonItems\DSC Resource Module Names.clixml" -InputObject (${DSC Resource Module Names})

$_Var_Name = 'DetectionSet'
try {Clear-Variable -Name $_Var_Name -ErrorAction 'Stop'} catch {New-Variable -Name $_Var_Name -Value $null}
Set-Variable -Name $_Var_Name -Value (& {
  foreach (${DSC Resource Module Name} in ${DSC Resource Module Names}) {
    $IsZipAbsent = -not (Test-Path -Path "${DSC Resource module Save Path}\${DSC Resource Module Name}.zip")
    $DetectionSet += [System.Int32]$IsZipAbsent
  }
  return $DetectionSet
})

if ($DetectionSet -gt 0) {
  . powershell.exe -NoProfile -File "$PSScriptRoot\Start\Download Jobs\DSC Resource Module Downloads from PSGallery.ps1"
}

$path = "$PSScriptRoot\..\.CommonItems\usb0\$FolderFQN\cfg\DSC Resources\Authored for $FolderFQN"
$folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
#endregion
#region | Download, but do not install, Windows PowerShell Modules |
$path = "$PSScriptRoot\..\.CommonItems\usb0\$FolderFQN\cfg\installs\Modules\5.1"
$folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
${Windows PowerShell module Save Path} = "$folder"
Export-CliXml -Path "$PSScriptRoot\..\.CommonItems\Windows PowerShell module Save Path.clixml" -InputObject (${Windows PowerShell module Save Path})

${Windows PowerShell Module Names} = @(
  'xDscDiagnostics'
  'TUN.CredentialManager'
  'Indented.Net.IP'
  'PSPKI'
  'MSCatalog'
)
Export-CliXml -Path "$PSScriptRoot\..\.CommonItems\Windows PowerShell Module Names.clixml" -InputObject (${Windows PowerShell Module Names})

$_Var_Name = 'DetectionSet'
try {Clear-Variable -Name $_Var_Name -ErrorAction 'Stop'} catch {New-Variable -Name $_Var_Name -Value $null}
Set-Variable -Name $_Var_Name -Value (& {
  foreach (${Windows PowerShell Module Name} in ${Windows PowerShell Module Names}) {
    $IsZipAbsent = -not (Test-Path -Path "${Windows PowerShell module Save Path}\${Windows PowerShell Module Name}.zip")
    $DetectionSet += [System.Int32]$IsZipAbsent
  }
  return $DetectionSet
})

if ($DetectionSet -gt 0) {
  . powershell.exe -NoProfile -File "$PSScriptRoot\Start\Download Jobs\Windows PowerShell Module (non-DSC) Downloads from PSGallery.ps1"
}
#endregion
#region | Download, but do not install, PowerShell 7 .msi files |
#region | End-of-Support announcements | Versioning Explained |
#     End-of-Support latest announcements:
#     start msedge.exe 'https://learn.microsoft.com/en-us/powershell/scripting/install/powershell-support-lifecycle'
#     Releases:
#     start msedge.exe 'https://github.com/powershell/powershell/releases'
#     
#     # Versioning
#     $PSVersionTable
#     ($PSVersionTable).GetType().Name
#     $PSVersionTable['PSVersion']
#     $PSVersionTable['PSVersion'].Major
#     $PSVersionTable['PSVersion'].Minor
#     $PSVersionTable['PSVersion'].Patch
#endregion
#region | PowerShell 7.4 |
$Minor = 4
$Patch = 22

$path = "$PSScriptRoot\..\.CommonItems\usb0\$FolderFQN\cfg\installs\PowerShell 7\7.$Minor"
$WebPath = "https://github.com/PowerShell/PowerShell/releases/download/v7.$Minor.$Patch/PowerShell-7.$Minor.$Patch-win-x64.msi"
$folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
$FilePath = "$folder\PowerShell-7.$Minor.$Patch-win-x64.msi"
$IsPresent = Test-Path -Path $FilePath
if (-not $IsPresent) {
  $JobName = "Download PowerShell 7.$Minor.$Patch 64-bit .msi"
  $RunningJob = Get-Job | Where-Object -FilterScript {
    $_.Name  -eq $JobName  -and `
    $_.State -eq 'Running'
  }

  if ($RunningJob -eq $null) {
    $ArgumentList = @(
      $WebPath
      $FilePath
      $ProgressPreference
    )

    Start-Job -Name $JobName -ArgumentList $ArgumentList -ScriptBlock {
      $WebPath                    = $args[0]
      $FilePath                   = $args[1]
      $OriginalProgressPreference = $args[2]

      $ProgressPreference = 'SilentlyContinue'
      Invoke-WebRequest -Uri $WebPath -OutFile $FilePath
      $ProgressPreference = $OriginalProgressPreference
    } | Out-Null
  }
}
#endregion
#region | PowerShell 7.5 |
$Minor = 5
$Patch = 13

$path = "$PSScriptRoot\..\.CommonItems\usb0\$FolderFQN\cfg\installs\PowerShell 7\7.$Minor"
$WebPath = "https://github.com/PowerShell/PowerShell/releases/download/v7.$Minor.$Patch/PowerShell-7.$Minor.$Patch-win-x64.msi"
$folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
$FilePath = "$folder\PowerShell-7.$Minor.$Patch-win-x64.msi"
$IsPresent = Test-Path -Path $FilePath
if (-not $IsPresent) {
  $JobName = "Download PowerShell 7.$Minor.$Patch 64-bit .msi"
  $RunningJob = Get-Job | Where-Object -FilterScript {
    $_.Name  -eq $JobName  -and `
    $_.State -eq 'Running'
  }

  if ($RunningJob -eq $null) {
    $ArgumentList = @(
      $WebPath
      $FilePath
      $ProgressPreference
    )

    Start-Job -Name $JobName -ArgumentList $ArgumentList -ScriptBlock {
      $WebPath                    = $args[0]
      $FilePath                   = $args[1]
      $OriginalProgressPreference = $args[2]

      $ProgressPreference = 'SilentlyContinue'
      Invoke-WebRequest -Uri $WebPath -OutFile $FilePath
      $ProgressPreference = $OriginalProgressPreference
    } | Out-Null
  }
}
#endregion
#region | PowerShell 7.6 |
$Minor = 6
$Patch = 10

$path = "$PSScriptRoot\..\.CommonItems\usb0\$FolderFQN\cfg\installs\PowerShell 7\7.$Minor"
$WebPath = "https://github.com/PowerShell/PowerShell/releases/download/v7.$Minor.$Patch/PowerShell-7.$Minor.$Patch-win-x64.msi"
$folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
$FilePath = "$folder\PowerShell-7.$Minor.$Patch-win-x64.msi"
$IsPresent = Test-Path -Path $FilePath
if (-not $IsPresent) {
  $JobName = "Download PowerShell 7.$Minor.$Patch 64-bit .msi"
  $RunningJob = Get-Job | Where-Object -FilterScript {
    $_.Name  -eq $JobName  -and `
    $_.State -eq 'Running'
  }

  if ($RunningJob -eq $null) {
    $ArgumentList = @(
      $WebPath
      $FilePath
      $ProgressPreference
    )

    Start-Job -Name $JobName -ArgumentList $ArgumentList -ScriptBlock {
      $WebPath                    = $args[0]
      $FilePath                   = $args[1]
      $OriginalProgressPreference = $args[2]

      $ProgressPreference = 'SilentlyContinue'
      Invoke-WebRequest -Uri $WebPath -OutFile $FilePath
      $ProgressPreference = $OriginalProgressPreference
    } | Out-Null
  }
}
#endregion
#region | PowerShell 7.7 |
$Minor = 7
$Patch = 0

$path = "$PSScriptRoot\..\.CommonItems\usb0\$FolderFQN\cfg\installs\PowerShell 7\7.$Minor"
$WebPath = "https://github.com/PowerShell/PowerShell/releases/download/v7.$Minor.$Patch/PowerShell-7.$Minor.$Patch-win-x64.msi"
$folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
$FilePath = "$folder\PowerShell-7.$Minor.$Patch-win-x64.msi"
$IsPresent = Test-Path -Path $FilePath
if (-not $IsPresent) {
  $JobName = "Download PowerShell 7.$Minor.$Patch 64-bit .msi"
  $RunningJob = Get-Job | Where-Object -FilterScript {
    $_.Name  -eq $JobName  -and `
    $_.State -eq 'Running'
  }

  if ($RunningJob -eq $null) {
    $ArgumentList = @(
      $WebPath
      $FilePath
      $ProgressPreference
    )

    Start-Job -Name $JobName -ArgumentList $ArgumentList -ScriptBlock {
      $WebPath                    = $args[0]
      $FilePath                   = $args[1]
      $OriginalProgressPreference = $args[2]

      $ProgressPreference = 'SilentlyContinue'
      Invoke-WebRequest -Uri $WebPath -OutFile $FilePath
      $ProgressPreference = $OriginalProgressPreference
    } | Out-Null
  }
}
#endregion
#endregion
#region | Download, but do not install, PowerShell 7 modules |
$path = "$PSScriptRoot\..\.CommonItems\usb0\$FolderFQN\cfg\installs\Modules\7"
$folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
${PowerShell 7 module Save Path} = "$folder"
Export-CliXml -Path "$PSScriptRoot\..\.CommonItems\PowerShell 7 module Save Path.clixml" -InputObject (${PowerShell 7 module Save Path})

${PowerShell 7 Module Names} = @(
  'SecretManagement.Warden'
  'TUN.CredentialManager'
  'Microsoft.PowerShell.SecretManagement'
)
Export-CliXml -Path "$PSScriptRoot\..\.CommonItems\PowerShell 7 Module Names.clixml" -InputObject (${PowerShell 7 Module Names})

$_Var_Name = 'DetectionSet'
try {Clear-Variable -Name $_Var_Name -ErrorAction 'Stop'} catch {New-Variable -Name $_Var_Name -Value $null}
Set-Variable -Name $_Var_Name -Value (& {
  foreach (${PowerShell 7 Module Name} in ${PowerShell 7 Module Names}) {
    $IsZipAbsent = -not (Test-Path -Path "${PowerShell 7 module Save Path}\${PowerShell 7 Module Name}.zip")
    $DetectionSet += [System.Int32]$IsZipAbsent
  }
  return $DetectionSet
})

if ($DetectionSet -gt 0) {
  . "$env:ProgramFiles\PowerShell\7\pwsh.exe" -NoProfile -File "$PSScriptRoot\Start\Download Jobs\PowerShell 7 Module Downloads from PSGallery.ps1"
}

<#
  $ArrayList = [System.Collections.ArrayList]::New()
  [System.Void]$ArrayList.Add()
  [System.Void]$ArrayList.Add()
  [System.Void]$ArrayList.Add()

  foreach ($Element in $ArrayList) {
    $IsZipPresent = Test-Path -Path "$ModuleSavePath\$Element.zip"
    if (-not $IsZipPresent) {
      Write-Verbose -Message "Downloading installation files for the '$Element' PowerShell 7 module."
      Save-Module -Name $Element -Path $ModuleSavePath -Repository 'PSGallery' -AllowPrerelease
      Start-Sleep 5
      Write-Verbose -Message "Compressing installation files for the '$Element' PowerShell 7 module to .zip"
      Compress-Archive -Path "$ModuleSavePath\$Element" -DestinationPath "$ModuleSavePath\$Element.zip"
      Start-Sleep 5
      Write-Verbose -Message "Removinging downloaded & uncompressed '$Element' installation files"
      Remove-Item -Path "$ModuleSavePath\$Element" -Recurse -Force
    }
  }
#>
#endregion
#region | Download latest version of Visual Studio Code | Download OneDriveSetup.exe |
$path = "$PSScriptRoot\..\.CommonItems\usb0\$FolderFQN\cfg\installs\Visual Studio Code\##"
$folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
<# Download Latest Version of Visual Studio Code |
  start msedge.exe 'https://code.visualstudio.com/sha/download?build=stable&os=win32-x64'
#>

$FilesInFolder = Get-ChildItem -Path "$folder" -Filter "VSCodeSetup-x64-*.exe" -Recurse
if ($FilesInFolder -eq $null) {
  Write-Host -Object "`nNo system installation file for Visual Studio Code detected in directory`n" -ForegroundColor $(rFc)
  Write-Host -Object "`n  '$folder'`n" -ForegroundColor $(rFc)
  pause
  Write-Host -Object "`nMicrosoft Edge will now launch and download the latest version of Visual Studio Code from:`n" -ForegroundColor $(rFc)
  Write-Host -Object "`n  'https://code.visualstudio.com/sha/download?build=stable&os=win32-x64'`n" -ForegroundColor $(rFc)
  pause
  Write-Host -Object "`n  Press Enter to proceed with the download of Visual Studio Code`n  " -ForegroundColor $(rFc)
  pause
  Start-Process -FilePath 'msedge.exe' -ArgumentList @('https://code.visualstudio.com/sha/download?build=stable&os=win32-x64')
  Start-Sleep 10
  
  Get-ChildItem -Path "$env:SystemDrive\Users\${explorer.exe Owner}\Downloads" -Filter "VSCodeSetup-x64-*.exe" -Recurse `
  | Sort-Object -Property 'LastWriteTime' `
  | Select-Object -Last 1 `
  | Copy-Item -Destination "$folder"
}


$path = "$PSScriptRoot\..\.CommonItems\usb0\$FolderFQN\cfg\installs\OneDrive\##"
$folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
<# Download Latest Version of OneDrive |
  start msedge.exe 'https://go.microsoft.com/fwlink/p/?LinkID=2182910&clcid=0x409&culture=en-us&country=us'
#>
$FilesInFolder = Get-ChildItem -Path "$folder" -Filter "OneDriveSetup*.exe" -Recurse
if ($FilesInFolder -eq $null) {
  Write-Host -Object "`nNo system installation file for OneDrive detected in directory`n" -ForegroundColor $(rFc)
  Write-Host -Object "`n  '$folder'`n" -ForegroundColor $(rFc)
  pause
  Write-Host -Object "`nMicrosoft Edge will now launch and download the latest version of OneDrive from:`n" -ForegroundColor $(rFc)
  Write-Host -Object "`n  'https://go.microsoft.com/fwlink/p/?LinkID=2182910&clcid=0x409&culture=en-us&country=us'`n" -ForegroundColor $(rFc)
  pause
  Write-Host -Object "`n  Press Enter to proceed with the download of OneDrive`n  " -ForegroundColor $(rFc)
  pause
  Start-Process -FilePath 'msedge.exe' -ArgumentList @('https://go.microsoft.com/fwlink/p/?LinkID=2182910&clcid=0x409&culture=en-us&country=us')
  Start-Sleep 10
  
  Get-ChildItem -Path "$env:SystemDrive\Users\${explorer.exe Owner}\Downloads" -Filter "OneDriveSetup*.exe" -Recurse `
  | Sort-Object -Property 'LastWriteTime' `
  | Select-Object -Last 1 `
  | Copy-Item -Destination "$folder"
}

#endregion
#region | Download latest version of the Windows Sysinternals Suite |
$ZipFileBaseName = 'SysinternalsSuite'
$path = "$PSScriptRoot\..\.CommonItems\usb0\$FolderFQN\cfg\installs\$ZipFileBaseName"
$folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
$IsPresent = Test-Path -Path "$folder\$ZipFileBaseName.zip"
if (-not $IsPresent) {
  $JobName = "Download $ZipFileBaseName zip File"
  $RunningJob = Get-Job | Where-Object -FilterScript {
    $_.Name  -eq $JobName  -and `
    $_.State -eq 'Running'
  }
  if ($RunningJob -eq $null) {
    $ArgumentList = @(
      "https://download.sysinternals.com/files/$ZipFileBaseName.zip"
      "$folder\$ZipFileBaseName.zip"
      $ProgressPreference
    )

    Start-Job -Name $JobName -ArgumentList $ArgumentList -ScriptBlock {
      $WebPath                    = $args[0]
      $FilePath                   = $args[1]
      $OriginalProgressPreference = $args[2]

      $ProgressPreference = 'SilentlyContinue'
      Invoke-WebRequest -Uri $WebPath -OutFile $FilePath
      $ProgressPreference = $OriginalProgressPreference
    } | Out-Null
  }
}



$ZipFileBaseName = 'SysinternalsSuite-Nano'
$path = "$PSScriptRoot\..\.CommonItems\usb0\$FolderFQN\cfg\installs\$ZipFileBaseName"
$folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
$IsPresent = Test-Path -Path "$folder\$ZipFileBaseName.zip"
if (-not $IsPresent) {
  $JobName = "Download $ZipFileBaseName zip File"
  $RunningJob = Get-Job | Where-Object -FilterScript {
    $_.Name  -eq $JobName  -and `
    $_.State -eq 'Running'
  }
  if ($RunningJob -eq $null) {
    $ArgumentList = @(
      "https://download.sysinternals.com/files/$ZipFileBaseName.zip"
      "$folder\$ZipFileBaseName.zip"
      $ProgressPreference
    )

    Start-Job -Name $JobName -ArgumentList $ArgumentList -ScriptBlock {
      $WebPath                    = $args[0]
      $FilePath                   = $args[1]
      $OriginalProgressPreference = $args[2]

      $ProgressPreference = 'SilentlyContinue'
      Invoke-WebRequest -Uri $WebPath -OutFile $FilePath
      $ProgressPreference = $OriginalProgressPreference
    } | Out-Null
  }
}






#endregion
#endregion
#region | Misc. |
#region | lockscreen.png |
$IsPresent = Test-Path -Path "$PSScriptRoot\Start\lockscreen.png"
$IsPresent = Test-Path -Path "$PSScriptRoot\..\.CommonItems\usb0\lockscreen.png"
if (-not $IsPresent) {
  Copy-Item -Path "$PSScriptRoot\Start\lockscreen.png" -Destination "$PSScriptRoot\..\.CommonItems\usb0"
}
#endregion
#endregion
#region | Resume authoring the custom AdHocInstantAdcsDsc DSC Resource module | Write build script upon completion |
$path = "$PSScriptRoot\..\.CommonItems\Authored"; 
$folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}

$path = "$PSScriptRoot\..\.CommonItems\Authored\AdHocInstantAdcsDsc"
$folder = [System.IO.DirectoryInfo]$path
$IsPresent = Test-Path -Path $folder.FullName
if ($IsPresent) {
  Get-Item -Path $folder | Rename-Item -NewName "$($folder.BaseName)-$(Call-DateVar)"
  New-Item -Path $path -ItemType 'Directory' | Out-Null
} else {New-Item -Path $path -ItemType 'Directory' | Out-Null}


# This is not going to be easy. 
# . powershell.exe -NoProfile -File "$PSScriptRoot\Start\AdHocInstantAdcsDsc\build.ps1"
# Best if rewritten on the Unclustered Hyper-V host. 
$InputHT = @{
  'PSPKI Module Version' = '4.4.1'
}
& "$PSScriptRoot\Start\AdHocInstantAdcsDsc\build.ps1" @InputHT
#endregion
#region |  |
. "$PSScriptRoot\output\$FolderFQN\usb1\$FolderFQN\Base\5.1\External Bootable Media Drive Letters.ps1"
${OSDeploy Disk CIM Instance} = Get-Disk | Where-Object -FilterScript {
  $_.FriendlyName -eq    ${OSDeploy FriendlyName}                                             -and `
  $_.UniqueId     -match [System.Text.RegularExpressions.Regex]::Escape(${OSDeploy UniqueId}) -and `
  $_.SerialNumber -eq    ${OSDeploy SerialNumber}
}
${Server25 Volume} = ${OSDeploy Disk CIM Instance} | Get-Partition | Where-Object -FilterScript {$_.Type -eq 'IFS'} | Get-Volume

${Is Volume holding Server25 defined}    = $null -ne ${Server25 Volume}
${Is setup.exe present in Extracted ISO} = Test-Path -Path "${Extracted ISO Folder Path}\setup.exe"
${Is mounted_wim folder deleted}         = -not (Test-Path -Path ${mounted_wim Folder Path})

${Is Extracted ISO ready for copy to UFD} = (
  ${Is Volume holding Server25 defined}    -eq $true -and `
  ${Is setup.exe present in Extracted ISO} -eq $true -and `
  ${Is mounted_wim folder deleted}         -eq $true
)

if (${Is Extracted ISO ready for copy to UFD}) {
  ${Server25 Volume Root} = [System.String]${Server25 Volume}.DriveLetter + ':'

  ${Is Copy of Extracted ISO to UFD Complete} = Test-Path -Path "${Server25 Volume Root}\support"
  if (-not ${Is Copy of Extracted ISO to UFD Complete}) {
    $JobName = "WU s25 Part 03-Dismount ISO, Apply Updates, Package into Patched ISO at IL-High"
    $RunningJob = Get-Job | Where-Object -FilterScript {
      $_.Name  -eq $JobName  -and `
      $_.State -eq 'Running'
    }
    if ($null -ne $RunningJob) {
      Write-Host -Object "Waiting for the '$JobName' job to complete..."
      Get-Job -Name $RunningJob.Name | Wait-Job
    }

    $JobName = 'Copy of Extracted ISO to UFD'
    $RunningJob = Get-Job | Where-Object -FilterScript {
      $_.Name  -eq $JobName  -and `
      $_.State -eq 'Running'
    }
    if ($RunningJob -eq $null) {
      $ArgumentList = @(
        ${Extracted ISO Folder Path}
        ${Server25 Volume Root}
      )
      Start-Job -Name $JobName -ArgumentList $ArgumentList -ScriptBlock {
        ${Extracted ISO Folder Path} = $args[0]
        ${Server25 Volume Root}      = $args[1]

        #robocopy.exe /e ${Extracted ISO Folder Path} ${Server25 Volume Root} *
        #robocopy.exe ${Extracted ISO Folder Path} ${Server25 Volume Root} /E
        robocopy.exe ${Extracted ISO Folder Path} ${Server25 Volume Root} /E /J # /LEV:2
      } | Out-Null
    }
  }
}
#endregion
#region | Copy clixml files into usb1 directory |
Write-Host -Object "Copy clixml files into usb1 directory-START" -ForegroundColor $(rFc)
$path = "$PSScriptRoot\output\$FolderFQN\usb1\$FolderFQN\clixmls"; 
$folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
Get-ChildItem -Path "$PSScriptRoot\..\.CommonItems" -Filter '*.clixml' | ForEach-Object -Process {
  Copy-Item -Path $_.FullName -Destination "$folder"
}
Write-Host -Object "Copy clixml files into usb1 directory-FINISH" -ForegroundColor $(rFc)
pause
#endregion
#region | Copy DSC files into usb1 directory |
$path = "$PSScriptRoot\output\$FolderFQN\usb1\$FolderFQN"; 
$folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}

Get-ChildItem -Path "$PSScriptRoot\DSC\Dot-Sourced Structural Data" -recurse
pause
Copy-Item -Path "$PSScriptRoot\DSC\Dot-Sourced Structural Data" -Destination "$folder" -Recurse

Get-ChildItem -Path "$PSScriptRoot\DSC" -Filter '*.ps1' | ForEach-Object -Process {
  Copy-Item -Path $_.FullName -Destination "$folder"
}
#endregion
#region | Copy usb1 directory into $usb1 |
#Write-Host -Object "Copy usb1 directory into `$usb1-START" -ForegroundColor $(rFc)
. "$PSScriptRoot\output\$FolderFQN\usb1\$FolderFQN\Base\5.1\External Storage Media Drive Letters.ps1"
if ($null -ne $usb1) {
  $IsPresent = Test-Path -Path "$usb1\$FolderFQN"
  if (-not $IsPresent) {
    Copy-Item -Path "$PSScriptRoot\output\$FolderFQN\usb1\$FolderFQN" -Destination "$usb1" -Recurse
  } else {
    Get-Item -Path "$usb1\$FolderFQN" | Rename-Item -NewName "$FolderFQN-$(Call-DateVAr)"
    $JobName = "Copy usb1 directory into `$usb1"
    $RunningJob = Get-Job | Where-Object -FilterScript {
      $_.Name  -eq $JobName  -and `
      $_.State -eq 'Running'
    }
    if ($RunningJob -eq $null) {
      $ArgumentList = @(
        "$PSScriptRoot\output\$FolderFQN\usb1\$FolderFQN"
        "$usb1"
      )
      Start-Job -Name $JobName -ArgumentList $ArgumentList -ScriptBlock {
        $path = $args[0]
        $Destination = $args[1]
        Copy-Item -Path $path -Destination $Destination -Recurse
      } | Out-Null
    }
  }
}
#Write-Host -Object "Copy usb1 directory into `$usb1-FINISH" -ForegroundColor $(rFc)
#endregion

#region | Ensure presence of installation files within $usb0 | IDEA: Provide the option of comparing file size or calculated SHA-256 hash for verification. |
if ($null -ne $usb0) {
  #region | Original ISO File |
  ${Is Original ISO File Present on Fixed Disk} = Test-Path -Path "${Offline WU-Original Server 2025 Folder}\Windows Server 2025.iso"
  if (${Is Original ISO File Present on Fixed Disk}) {
    $path = "$usb0\$FolderFQN\Microsoft\OS\Server 25\Original"; 
    $folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
    ${Is Original ISO File Present on External Media} = Test-Path -Path "$folder\Windows Server 2025.iso"
    if (-not ${Is Original ISO File Present on External Media}) {
      Copy-Item -Path "${Offline WU-Original Server 2025 Folder}\Windows Server 2025.iso" -Destination "$folder"
    } else {
      ${Size of Original ISO File on Fixed Disk} = Get-Item -Path "${Offline WU-Original Server 2025 Folder}\Windows Server 2025.iso" | Select-Object -ExpandProperty 'Length'
      ${Size of Original ISO File on External Media} = Get-Item -Path "$folder\Windows Server 2025.iso" | Select-Object -ExpandProperty 'Length'
      Write-Host -Object "`nComparing sizes of Original 'Windows Server 2025.iso' in local fixed disk vs `$usb0 external media:" -ForegroundColor $(rFc)
      Write-Host -Object "  `${Size of Original ISO File on Fixed Disk}     = ${Size of Original ISO File on Fixed Disk}" -ForegroundColor $(rFc)
      Write-Host -Object "  `${Size of Original ISO File on External Media} = ${Size of Original ISO File on External Media}" -ForegroundColor $(rFc)
      if (${Size of Original ISO File on Fixed Disk} -ne ${Size of Original ISO File on External Media}) {
        Remove-Item -Path "$folder\Windows Server 2025.iso"
        Write-Host -Object "`nCopying Original ISO file into `$usb0 external media...`n" -ForegroundColor $(rFc)
        Copy-Item -Path "${Offline WU-Original Server 2025 Folder}\Windows Server 2025.iso" -Destination "$folder"
      }
    }
  }
  #endregion
  #region | Patched ISO File |
  ${Is Patched ISO File Present on Fixed Disk} = Test-Path -Path "${Offline WU-Patched Server 2025 Folder}\Windows Server 2025.iso"
  if (${Is Patched ISO File Present on Fixed Disk}) {
    $path = "$usb0\$FolderFQN\Microsoft\OS\Server 25\Patched"; 
    $folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
    ${Is Patched ISO File Present on External Media} = Test-Path -Path "$folder\Windows Server 2025.iso"
    if (-not ${Is Patched ISO File Present on External Media}) {
      Copy-Item -Path "${Offline WU-Patched Server 2025 Folder}\Windows Server 2025.iso" -Destination "$folder"
    } else {
      ${Size of Patched ISO File on Fixed Disk} = Get-Item -Path "${Offline WU-Patched Server 2025 Folder}\Windows Server 2025.iso" | Select-Object -ExpandProperty 'Length'
      ${Size of Patched ISO File on External Media} = Get-Item -Path "$folder\Windows Server 2025.iso" | Select-Object -ExpandProperty 'Length'
      Write-Host -Object "`nComparing sizes of Patched 'Windows Server 2025.iso' in local fixed disk vs `$usb0 external media:" -ForegroundColor $(rFc)
      Write-Host -Object "  `${Size of Patched ISO File on Fixed Disk}     = ${Size of Patched ISO File on Fixed Disk}" -ForegroundColor $(rFc)
      Write-Host -Object "  `${Size of Patched ISO File on External Media} = ${Size of Patched ISO File on External Media}" -ForegroundColor $(rFc)
      if (${Size of Patched ISO File on Fixed Disk} -ne ${Size of Patched ISO File on External Media}) {
        Remove-Item -Path "$folder\Windows Server 2025.iso"
        Write-Host -Object "`nCopying Patched ISO file into `$usb0 external media...`n" -ForegroundColor $(rFc)
        Copy-Item -Path "${Offline WU-Patched Server 2025 Folder}\Windows Server 2025.iso" -Destination "$folder"
      }
    }
  }
  #endregion

  #region | Windows ADK + WinPE offline installation components |
  $ZipFileBaseName = 'Windows ADK 2026-09'
  ${Job-Name} = "Copy of '$ZipFileBaseName' .zip file from Local Fixed Disk to External Removable Media"
  ${Running-Job} = Get-Job | Where-Object -FilterScript {
    $_.Name  -eq ${Job-Name}  -and `
    $_.State -eq 'Running'
  }
  if (${Running-Job} -eq $null) {
    $path = "$usb0\$FolderFQN\cfg\installs\$ZipFileBaseName"
    $folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
    ${Windows ADK 2026-09 Extracted Folder Parent Path} = Resolve-Path -Path "${Windows ADK 2026-09 Extracted Folder Path}\.." | Select-Object -ExpandProperty 'Path'

    $IsPresent = Test-Path -Path "$folder\$ZipFileBaseName.zip"
    if (-not $IsPresent) {
      $IsReady = Test-Path -Path "${Windows ADK 2026-09 Extracted Folder Parent Path}\$ZipFileBaseName.zip"
      if ($IsReady) {
        $ArgumentList = @(
          ${Windows ADK 2026-09 Extracted Folder Parent Path}
          $ZipFileBaseName
          "$folder"
        )
        Start-Job -Name ${Job-Name} -ArgumentList $ArgumentList -ScriptBlock {
          ${Windows ADK 2026-09 Extracted Folder Parent Path} = $args[0]
          $ZipFileBaseName = $args[1]
          ${Folder Path} = $args[2]
          Copy-Item -Path "${Windows ADK 2026-09 Extracted Folder Parent Path}\$ZipFileBaseName.zip" -Destination ${Folder Path}
        } | Out-Null
      }
    } else {
      ${Size of ADK .zip on Fixed Disk} = (Get-Item -Path "${Windows ADK 2026-09 Extracted Folder Parent Path}\$ZipFileBaseName.zip").Length
      ${Size in ADK .zip on External Media} = (Get-Item -Path "$folder\$ZipFileBaseName.zip").Length
      Write-Host -Object "`nComparing sizes of ADK .zip file in local fixed disk vs `$usb0 external media:" -ForegroundColor $(rFc)
      Write-Host -Object "  `${Size of ADK .zip on Fixed Disk}     = ${Size of ADK .zip on Fixed Disk}" -ForegroundColor $(rFc)
      Write-Host -Object "  `${Size in ADK .zip on External Media} = ${Size in ADK .zip on External Media}" -ForegroundColor $(rFc)

      if (${Size of ADK .zip on Fixed Disk} -ne ${Size in ADK .zip on External Media}) {
        Remove-Item -Path "$folder\$ZipFileBaseName.zip"
        Write-Host -Object "`nCopying ADK .zip file into `$usb0 external media...`n" -ForegroundColor $(rFc)
        $ArgumentList = @(
          ${Windows ADK 2026-09 Extracted Folder Parent Path}
          $ZipFileBaseName
          "$folder"
        )
        Start-Job -Name ${Job-Name} -ArgumentList $ArgumentList -ScriptBlock {
          ${Windows ADK 2026-09 Extracted Folder Parent Path} = $args[0]
          $ZipFileBaseName = $args[1]
          ${Folder Path} = $args[2]
          Copy-Item -Path "${Windows ADK 2026-09 Extracted Folder Parent Path}\$ZipFileBaseName.zip" -Destination ${Folder Path}
        } | Out-Null
      }
    }
  }

  $ZipFileBaseName = 'WinPE 2026-09'
  ${Job\Name} = "Copy of '$ZipFileBaseName' .zip file from Local Fixed Disk to External Removable Media"
  ${Running\Job} = Get-Job | Where-Object -FilterScript {
    $_.Name  -eq ${Job\Name}  -and `
    $_.State -eq 'Running'
  }
  if (${Job\Name} -eq $null) {
    $path = "$usb0\$FolderFQN\cfg\installs\$ZipFileBaseName"
    $folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
    ${WinPE 2026-09 Extracted Folder Parent Path} = Resolve-Path -Path "${WinPE 2026-09 Extracted Folder Path}\.." | Select-Object -ExpandProperty 'Path'
    $IsPresent = Test-Path -Path "$folder\$ZipFileBaseName.zip"
    if (-not $IsPresent) {
      $IsReady = Test-Path -Path "${WinPE 2026-09 Extracted Folder Parent Path}\$ZipFileBaseName.zip"
      if ($IsReady) {
        $ArgumentList = @(
          ${WinPE 2026-09 Extracted Folder Parent Path}
          $ZipFileBaseName
          "$folder"
        )
        Start-Job -Name ${Job-Name} -ArgumentList $ArgumentList -ScriptBlock {
          ${WinPE 2026-09 Extracted Folder Parent Path} = $args[0]
          $ZipFileBaseName = $args[1]
          ${Folder Path} = $args[2]
          Copy-Item -Path "${WinPE 2026-09 Extracted Folder Parent Path}\$ZipFileBaseName.zip" -Destination ${Folder Path}
        } | Out-Null
      }
    } else {
      ${Size of WinPE .zip on Fixed Disk} = (Get-Item -Path "${WinPE 2026-09 Extracted Folder Parent Path}\$ZipFileBaseName.zip").Length
      ${Size in WinPE .zip on External Media} = (Get-Item -Path "$folder\$ZipFileBaseName.zip").Length
      Write-Host -Object "`nComparing sizes of WinPE .zip file in local fixed disk vs `$usb0 external media:" -ForegroundColor $(rFc)
      Write-Host -Object "  `${Size of WinPE .zip on Fixed Disk}     = ${Size of WinPE .zip on Fixed Disk}" -ForegroundColor $(rFc)
      Write-Host -Object "  `${Size in WinPE .zip on External Media} = ${Size in WinPE .zip on External Media}" -ForegroundColor $(rFc)

      if (${Size of WinPE .zip on Fixed Disk} -ne ${Size in WinPE .zip on External Media}) {
        Remove-Item -Path "$folder\$ZipFileBaseName.zip"
        Write-Host -Object "`nCopying WinPE .zip file into `$usb0 external media...`n" -ForegroundColor $(rFc)
        $ArgumentList = @(
          ${WinPE 2026-09 Extracted Folder Parent Path}
          $ZipFileBaseName
          "$folder"
        )
        Start-Job -Name ${Job-Name} -ArgumentList $ArgumentList -ScriptBlock {
          ${WinPE 2026-09 Extracted Folder Parent Path} = $args[0]
          $ZipFileBaseName = $args[1]
          ${Folder Path} = $args[2]
          Copy-Item -Path "${WinPE 2026-09 Extracted Folder Parent Path}\$ZipFileBaseName.zip" -Destination ${Folder Path}
        } | Out-Null
      }
    }
  }
  #endregion

  #region | Visual Studio Code |
  #endregion
  #region | OneDrive |
  #endregion
  #region | MikroTik WinBox |
  #endregion
}
<#
  Write-Host -Object "`nComparing two SHA256 hashes:`n" -ForegroundColor $(rFc)
  ${Hash in usb0 Directory} = (Get-FileHash -Path "$path\Windows Server 2025.iso" -Algorithm 'SHA256').Hash
  Write-Host -Object "`nComparing sizes of 'Windows Server 2025.iso' in usb0 directory vs Offline WU folder:`n" -ForegroundColor $(rFc)
  ${Size in usb0 Directory} = (Get-Item -Path "$path\Windows Server 2025.iso").Length

  if (Test-Path -Path "${Offline WU-Patched Server 2025 Folder}\Windows Server 2025.iso") {
    ${Size in Offline WU} = (Get-Item -Path "${Offline WU-Patched Server 2025 Folder}\Windows Server 2025.iso").Length
    Write-Host -Object "  `${Size in usb0 Directory} = ${Size in usb0 Directory}" -ForegroundColor $(rFc)
    Write-Host -Object "  `${Size in Offline WU}     = ${Size in Offline WU}" -ForegroundColor $(rFc)

    if (${Size in usb0 Directory} -ne ${Size in Offline WU}) {
      Remove-Item -Path "$path\Windows Server 2025.iso"
      Write-Host -Object "`nCopy Patched ISO file into usb0 directory`n" -ForegroundColor $(rFc)
      Copy-Item -Path "${Offline WU-Patched Server 2025 Folder}\Windows Server 2025.iso" -Destination "$folder"
    }

    #${Hash in Offline WU} = (Get-FileHash -Path "${Offline WU-Patched Server 2025 Folder}\Windows Server 2025.iso" -Algorithm 'SHA256').Hash
    #Write-Host -Object "  `${Hash in usb0 Directory} = ${Hash in usb0 Directory}" -ForegroundColor $(rFc)
    #Write-Host -Object "  `${Hash in Offline WU}     = ${Hash in Offline WU}" -ForegroundColor $(rFc)

    Write-Host -Object "`nComparing two SHA256 hashes:`n" -ForegroundColor $(rFc)
    ${Hash in usb0 Directory} = (Get-FileHash -Path "$path\$ZipFileBaseName.zip" -Algorithm 'SHA256').Hash
    ${Hash in ADK + WinPE} = (Get-FileHash -Path "${Windows ADK 2026-09 Extracted Folder Parent Path}\$ZipFileBaseName.zip" -Algorithm 'SHA256').Hash
    Write-Host -Object "  `${Hash in usb0 Directory} = ${Hash in usb0 Directory}" -ForegroundColor $(rFc)
    Write-Host -Object "  `${Hash in ADK + WinPE}    = ${Hash in ADK + WinPE}" -ForegroundColor $(rFc)

    Write-Host -Object "`nComparing two SHA256 hashes:`n" -ForegroundColor $(rFc)
    ${Hash in usb0 Directory} = (Get-FileHash -Path "$path\$ZipFileBaseName.zip" -Algorithm 'SHA256').Hash
    ${Hash in ADK + WinPE} = (Get-FileHash -Path "${WinPE 2026-09 Extracted Folder Parent Path}\$ZipFileBaseName.zip" -Algorithm 'SHA256').Hash
    Write-Host -Object "  `${Hash in usb0 Directory} = ${Hash in usb0 Directory}" -ForegroundColor $(rFc)
    Write-Host -Object "  `${Hash in ADK + WinPE}    = ${Hash in ADK + WinPE}" -ForegroundColor $(rFc)
  }
#>
#endregion

