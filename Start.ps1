#Requires -Version 5.1
#Requires -PSEdition Desktop

param (
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


<#
  $CloningRepoPath = "$env:UserProfile\GitHub\CarlSimonIT"; $CloningRepoFolder = try {Get-Item -Path $CloningRepoPath -ErrorAction 'Stop'} catch {New-Item -Path $CloningRepoPath -ItemType 'Directory' -Force}; Set-Location -Path "$CloningRepoFolder"
  Set-ExecutionPolicy -ExecutionPolicy 'RemoteSigned' -Scope 'Process' -Force; 
  $HT = @{EmailAddressOfBitwardenAccount = 'pwdsec3@gmail.com'; 'Folder Fully Qualified Name' = 'Instant-ADCS'; BadPassword = 'BadPassword!'; 'NetBIOS Name of Root Domain in AD Forest' = 'BlackCoffee'; 'DNS Name of Root Domain in AD Forest' = 'ad.black-coffee-black-coffee-black-coffee-black-coffee.INTERNAL'}; & '.\Instant-ADCS\Start.ps1' @HT; Set-Location -Path 'C:\'; 
  (Get-Job).Where({$_.State -ne 'Running'}) | Remove-Job; Get-Job | Format-Table -AutoSize
#>

#       Set-ExecutionPolicy -ExecutionPolicy 'RemoteSigned' -Scope 'Process' -Force; $CloningRepoPath = "$env:UserProfile\GitHub\CarlSimonIT"; $CloningRepoFolder = try {Get-Item -Path $CloningRepoPath -ErrorAction 'Stop'} catch {New-Item -Path $CloningRepoPath -ItemType 'Directory' -Force}; Set-Location -Path "$CloningRepoFolder"; Set-ExecutionPolicy -ExecutionPolicy 'RemoteSigned' -Scope 'Process' -Force; $HT = @{EmailAddressOfBitwardenAccount = 'pwdsec3@gmail.com'; 'Folder Fully Qualified Name' = 'Instant-ADCS'; BadPassword = 'BadPassword!'; 'NetBIOS Name of Root Domain in AD Forest' = 'BlackCoffee'; 'DNS Name of Root Domain in AD Forest' = 'ad.black-coffee-black-coffee-black-coffee-black-coffee.INTERNAL'}; & '.\Instant-ADCS\Start.ps1' @HT; Set-Location -Path 'C:\'; (Get-Job).Where({$_.State -ne 'Running'}) | Remove-Job; Get-Job | Format-Table -AutoSize; 

#region | Set latest Strict Mode | Exit '.\Start.ps1' script if launched in a powershell.exe process instance running at Integrity Level-High |
Set-StrictMode -Version 'Latest'

${powershell.exe owner Identity} = [Security.Principal.WindowsIdentity]::GetCurrent()
${powershell.exe owner Access} = [Security.Principal.WindowsPrincipal]${powershell.exe owner Identity}
${Current powershell.exe process is running at Integrity Level-High} = (${powershell.exe owner Access}).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

if (${Current powershell.exe process is running at Integrity Level-High}) {
  #throw "`n`n`tExiting Start.ps1 script.`n`n`tRe-launch Windows PowerShell WITHOUT selecting Run As Administrator!`n`n"
  Write-Error -Message "`n`n`tExiting Start.ps1 script.`n`n`tRe-launch Windows PowerShell WITHOUT selecting Run As Administrator!`n`n"
  pause
  Get-Process -Id $PID | Stop-Process -Force
} 
#endregion
#region | Export non-senstive strings to .clixml for later import by other applications |
$HT = @{
  'SHA256 of Windows Server 2025 ISO File' = ${SHA256 of Windows Server 2025 ISO File}
  'SHA256 of WinPE 2026-09 EXE File'       = ${SHA256 of WinPE 2026-09 EXE File}
  'SHA256 of Windows ADK 2026-09 EXE File' = ${SHA256 of Windows ADK 2026-09 EXE File}
  EmailAddressOfBitwardenAccount           = $EmailAddressOfBitwardenAccount
  BadPassword                              = $BadPassword
  FolderFQN                                = $FolderFQN
}
& "$PSScriptRoot\Start\Export non-senstive strings to .clixml for later import by other applications.ps1" @HT
[System.Environment]::SetEnvironmentVariable('.CommonItems',"$CloningRepoPath\.CommonItems")
$FolderFQN = Import-CliXml -Path "$PSScriptRoot\..\.CommonItems\FolderFQN.clixml"


#region | Define new folder structures. Same code is re-executed later in Start.ps1 when applicable |
#$path = "$PSScriptRoot\..\.CommonItems\usb0\$FolderFQN\Microsoft\OS\Server  25\Original"
#$folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}

$path = "$PSScriptRoot\..\.CommonItems\Offline WU\Server 25\Original"
${Offline WU-Original Server 2025 Folder} = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
$path = "$PSScriptRoot\..\.CommonItems\Offline WU\Server 25\Patched"
${Offline WU-Patched Server 2025 Folder} = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}

$InstallsPath = "$PSScriptRoot\..\.CommonItems\WinPE"
$path = "$InstallsPath\ADK + WinPE (2026-09)"
$AppFolder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}


#endregion

#endregion

#region | Install NuGet | Set PSGallery as Trusted | Update PowerShellGet module | Install 'TUN.CredentialManager' module | Install 'MSCatalog' module
& "$PSScriptRoot\Start\NuGet Install, Trust PSGallery, Update PowerShellGet, Install Windows PowerShell Modules.ps1"
# Delete Shortly # & "$PSScriptRoot\Start\NuGet Install, Trust PSGallery, Update PowerShellGet, Install Module for Credential Manager.ps1"
# Delete Shortly # . powershell.exe -NoProfile -File "$PSScriptRoot\Start\NuGet-PSGallery-Windows PowerShell Module Install.ps1"
#endregion
#region | Write sensitive strings providing access to online Bitwarden Vault into local Windows Credential Manager |
$PSModuleInfo = Import-Module 'TUN.CredentialManager' -Force -PassThru

${1 or more sensitive strings providing access to online Bitwarden Vault need to be written into local Windows Credential Manager} = (
  ((Get-StoredCredential -Target "!BW_CLIENTID $FolderFQN")                 -eq $null) -or `
  ((Get-StoredCredential -Target "!BW_CLIENTSECRET $FolderFQN")             -eq $null) -or `
  ((Get-StoredCredential -Target "!Bitwarden Account Password-DELETE THIS") -eq $null)
)

if (${1 or more sensitive strings providing access to online Bitwarden Vault need to be written into local Windows Credential Manager}) {
  . powershell.exe -NoProfile -File "$PSScriptRoot\Start\Write sensitive strings providing access to online Bitwarden Vault into local Windows Credential Manager.ps1"
}
#endregion

#region | Ensure target 'output' directory is present in project root |
. powershell.exe -NoProfile -File "$PSScriptRoot\Start\Ensure target output directory is present in project root.ps1"
#endregion
#region | Calculate date of the Patch Tuesday for this month |
${Target Get-XDayOfMonth.ps1 File} = [System.IO.FileInfo]"$PSScriptRoot\output\$FolderFQN\usb1\$FolderFQN\Base\5.1\Get-XDayOfMonth.ps1"
#Write-Host -Object "`${Target Get-XDayOfMonth.ps1 File}.FullName = $(${Target Get-XDayOfMonth.ps1 File}.FullName)"

${SHA256 of Get-XDayOfMonth.ps1 File} = '3601BA876957FBCF3B6E0A9A448B5177A952954F951D1441AF8F5720F9D6A820'
$hash = ${SHA256 of Get-XDayOfMonth.ps1 File}
${Local Get-XDayOfMonth.ps1 File} = Get-ChildItem -Path "$PSScriptRoot\output" -Recurse -File `
| Where-Object -PipelineVariable 'file' -FilterScript {$_.Name -eq 'Get-XDayOfMonth.ps1'} `
| ForEach-Object -Process {Get-FileHash -Path $file.FullName -Algorithm 'SHA256' `
| Where-Object -PipelineVariable 'AlgoHashPath' -FilterScript {$_.Hash -eq $hash} `
| ForEach-Object -Process {Get-Item -Path $AlgoHashPath.Path}} `
| Sort-Object -Property 'LastWriteTime' -Descending `
| Select-Object -First 1
#Write-Host -Object "`${Local Get-XDayOfMonth.ps1 File}.FullName = $(${Local Get-XDayOfMonth.ps1 File}.FullName)"

if ($null -ne ${Local Get-XDayOfMonth.ps1 File}) {
  Copy-Item -Path ${Local Get-XDayOfMonth.ps1 File}.FullName -Destination ${Target Get-XDayOfMonth.ps1 File}.DirectoryName
} else {
  $Uri = 'https://gist.githubusercontent.com/andyzib/22c4732627ae9a1d3f1776374980ec9c/raw/6442a572cbf096b62004c30097cd1aac1e99d18a/Get-XDayOfMonth.ps1'
  do {
    Invoke-WebRequest -Uri $Uri -OutFile ${Target Get-XDayOfMonth.ps1 File}.FullName
    Start-Sleep 5
  } until ({
    $IsPresent = Test-Path -Path ${Target Get-XDayOfMonth.ps1 File}.FullName
    return $IsPresent
  })
}
. ${Target Get-XDayOfMonth.ps1 File}
$HT = @{
  Find    = 'Second'
  Weekday = 'Tuesday'
  Month   = $([System.String]::Format('{0:MM}',[System.DateTime]::Now))
  Year    = $([System.String]::Format('{0:yyyy}',[System.DateTime]::Now))
}
${Patch Tuesday Of This Month} = Get-XDayOfMonth @HT
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
  'DNS Name of Root Domain in AD Forest'     = ${DNS Name of Root Domain in AD Forest}
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
$JobName = 'Generate secure strings in online Bitwarden Vault'
$RunningJob = Get-Job | Where-Object -FilterScript {
  $_.Name  -eq $JobName  -and `
  $_.State -eq 'Running'
}
if ($RunningJob -eq $null) {
  . "$env:ProgramFiles\PowerShell\7\pwsh.exe" -NoProfile -File "$PSScriptRoot\Start\Build Secure-Automations-Toolset Module.ps1"
}
#endregion
#region | Variable Setup in Windows PowerShell and Export to CliXml |
. powershell.exe -NoProfile -File "$PSScriptRoot\Start\Variable Setup in Windows PowerShell and Export to CliXml.ps1"
#endregion
#region | Generate secure strings in online Bitwarden Vault and synchronize down to local Windows Credential Manager | WARNING: This will take over 60 minutes! |
$JobName = 'Generate secure strings in online Bitwarden Vault'
$RunningJob = Get-Job | Where-Object -FilterScript {
  $_.Name  -eq $JobName  -and `
  $_.State -eq 'Running'
}
if ($RunningJob -eq $null) {
  $ArgumentList = @(
    "$PSScriptRoot\Start"
  )
  $Job = Start-Job -Name $JobName -ArgumentList $ArgumentList -ScriptBlock {
    $StartFolder = $args[0]
    . "$env:ProgramFiles\PowerShell\7\pwsh.exe" -NoProfile -File "$StartFolder\PowerShell 5.1 Job that calls pwsh.exe to Generate and Save Credentials into Bitwarden Vault.ps1"
    . "$env:ProgramFiles\PowerShell\7\pwsh.exe" -NoProfile -File "$StartFolder\PowerShell 5.1 Job that compiles the Quick Lookup Table.csv File.ps1"
    . "$env:ProgramFiles\PowerShell\7\pwsh.exe" -NoProfile -File "$StartFolder\PowerShell 5.1 Job that updates the password for logging into the bare-metal unclustered Hyper-V host.ps1"
    . "$env:ProgramFiles\PowerShell\7\pwsh.exe" -NoProfile -File "$StartFolder\PowerShell 5.1 Job that writes passwords from local Secrets Vault into local Windows Credential Manager.ps1"
  }
}
#endregion

#region | Download Windows Server .ISO file | Download Windows 11 Enterprise .ISO file |
#region | Ensure the 'Original' and 'Patched' Folders have been created |
#$path = "$PSScriptRoot\..\.CommonItems\Offline WU\Server 25\Original"
#${Original Server 2025 IS0 Folder} = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
#$path = "$PSScriptRoot\..\.CommonItems\Offline WU\Server 25\Patched"
#${Patched Server 2025 IS0 Folder} = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}


$path = "$PSScriptRoot\..\.CommonItems\Offline WU\Server 25\Original"
${Offline WU-Original Server 2025 Folder} = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
$path = "$PSScriptRoot\..\.CommonItems\Offline WU\Server 25\Patched"
${Offline WU-Patched Server 2025 Folder} = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}

#endregion
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

    $Job = Start-Job -Name $JobName -ArgumentList $ArgumentList -ScriptBlock {
      $WebPath                    = $args[0]
      $FilePath                   = $args[1]
      $OriginalProgressPreference = $args[2]

      $ProgressPreference = 'SilentlyContinue'
      Invoke-WebRequest -Uri $WebPath -OutFile $FilePath
      $ProgressPreference = $OriginalProgressPreference
    }
    $Job | Format-Table -AutoSize
  }
} 
else { # If an unpatched ISO file for Server 2025 is confirmed to be inside ${env:.CommonItems}, ensure that file has been transplanted and appropriately renamed |
  ${Is ISO Already Relocated and Renamed} = Test-Path -Path "${Offline WU-Original Server 2025 Folder}\Windows Server 2025.iso"
  if (-not ${Is ISO Already Relocated and Renamed}) {
    Move-Item -Path ${Windows Server 2025 ISO Original File}.FullName -Destination "${Offline WU-Original Server 2025 Folder}\Windows Server 2025.iso"
    #Copy-Item -Path ${Windows Server 2025 ISO Original File}.FullName -Destination "${Offline WU-Original Server 2025 Folder}"
    #Get-Item -Path "${Offline WU-Original Server 2025 Folder}\$(${Windows Server 2025 ISO Original File}.Name)" | Rename-Item -NewName 'Windows Server 2025.iso'
  }
}
#endregion
#region | Download, but do not install, the setup file for the Windows ADK and the Windows PE Add-on |
#region | Download the Windows ADK installer EXE File |
#$path = "$PSScriptRoot\..\.CommonItems\usb0\$FolderFQN\cfg\installs\ADK + WinPE (2026-09)\Windows ADK 2026-09 Installer"
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

    $Job = Start-Job -Name $JobName -ArgumentList $ArgumentList -ScriptBlock {
      $WebPath                    = $args[0]
      $FilePath                   = $args[1]
      $OriginalProgressPreference = $args[2]

      $ProgressPreference = 'SilentlyContinue'
      Invoke-WebRequest -Uri $WebPath -OutFile $FilePath
      $ProgressPreference = $OriginalProgressPreference
    }
  }
}
#endregion
#region | Download the WinPE installer EXE File |
#$path = "$PSScriptRoot\..\.CommonItems\usb0\$FolderFQN\cfg\installs\ADK + WinPE (2026-09)\WinPE 2026-09 Installer"
$path = "$PSScriptRoot\..\.CommonItems\WinPE\ADK + WinPE (2026-09)\WinPE 2026-09 Installer"
$folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}

${SHA256 of WinPE 2026-09 EXE File} = Import-CliXml -Path "$PSScriptRoot\..\.CommonItems\SHA256 of WinPE 2026-09 EXE File.clixml"
$hash = ${SHA256 of WinPE 2026-09 EXE File}
#$path = "$PSScriptRoot\..\.CommonItems\usb0\$FolderFQN\cfg\installs\ADK + WinPE (2026-09)\WinPE 2026-09 Installer"
$path = "$PSScriptRoot\..\.CommonItems\WinPE\ADK + WinPE (2026-09)\WinPE 2026-09 Installer"
$folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
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

    $Job = Start-Job -Name $JobName -ArgumentList $ArgumentList -ScriptBlock {
      $WebPath                    = $args[0]
      $FilePath                   = $args[1]
      $OriginalProgressPreference = $args[2]

      $ProgressPreference = 'SilentlyContinue'
      Invoke-WebRequest -Uri $WebPath -OutFile $FilePath
      $ProgressPreference = $OriginalProgressPreference
    }
  }
}
#endregion
#endregion
#region | Download-Install-Compress ADK + WinPE |
## Windows ADK Patches
#  None currently published for Windows ADK 2026-09 but check back periodically. 
#  'https://learn.microsoft.com/en-us/windows-hardware/get-started/adk-servicing'
$JobName0 = 'Download Windows ADK 2026-09 EXE File'
$RunningJob0 = Get-Job | Where-Object -FilterScript {
  $_.Name  -eq $JobName0  -and `
  $_.State -eq 'Running'
}
if ($null -ne $RunningJob0) {
  Write-Host -Object "  `$RunningJob0.Name = $($RunningJob0.Name)"
  Get-Job -Name $JobName0 | Wait-Job | Format-Table -AutoSize
}
#region | Bring ADK + WinPE Offline Installation Files into a %UserProfile% Container |
#$InstallsPath = "$PSScriptRoot\..\.CommonItems\usb0\$FolderFQN\cfg\installs"
$InstallsPath = "$PSScriptRoot\..\.CommonItems\WinPE"
$path = "$InstallsPath\ADK + WinPE (2026-09)"
$AppFolder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}

${Windows ADK 2026-09 Installer Folder Name} = 'Windows ADK 2026-09 Installer'
${Windows ADK 2026-09 Installer Folder Path} = "$AppFolder\${Windows ADK 2026-09 Installer Folder Name}"
${WinPE 2026-09 Installer Folder Name} = 'WinPE 2026-09 Installer'
${WinPE 2026-09 Installer Folder Path} = "$AppFolder\${WinPE 2026-09 Installer Folder Name}"

${Bring ADK + WinPE Offline Installation Files into a %UserProfile% Container Here-String} = $(
  "#Requires -Version 5.1`n"
  "#Requires -PSEdition Desktop`n"
  "#Requires -RunAsAdministrator`n"
  " `n"
  "& {`n"
  #region | Bring ADK + WinPE Offline Installation Files into a %UserProfile% Container |
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
  #endregion
  #region | Download but do not install the Windows ADK Installation Files |
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
  "    Start-Process -FilePath $([System.Char]39).\adksetup.exe$([System.Char]39) -WorkingDirectory `$WorkingDirectory -ArgumentList `$DownloadArgumentList -Wait -Verb 'RunAs'`n"
  "    `$TargetLayoutFolder = try {Get-Item -Path `$TargetLayout -ErrorAction $([System.Char]39)Stop$([System.Char]39)} catch {New-Item -Path `$TargetLayout -ItemType $([System.Char]39)Directory$([System.Char]39) -Force}`n"
  "    Move-Item -Path $([System.Char]34)`$env:ProgramData\UserExperienceManifest.xml$([System.Char]34) -Destination $([System.Char]34)`$TargetLayoutFolder$([System.Char]34)`n"
  "    Move-Item -Path $([System.Char]34)`$env:ProgramData\adksetup.exe$([System.Char]34) -Destination $([System.Char]34)`$TargetLayoutFolder$([System.Char]34)`n"
  "    Move-Item -Path $([System.Char]34)`$env:ProgramData\Installers$([System.Char]34) -Destination $([System.Char]34)`$TargetLayoutFolder$([System.Char]34) -Force`n"
  "  }`n"
  #endregion
  #region | Compress the Windows ADK Installation Files after getting a slice at DiNico's |
  "  `$ZipFilePath = $([System.Char]34)`$env:ProgramData\ADK + WinPE\`$AppName.zip$([System.Char]34)`n"
  "  `$IsPresent = Test-Path -Path `$ZipFilePath`n"
  "  if (-not `$IsPresent) {`n"
  "    Compress-Archive -Path `$TargetLayout -DestinationPath `$ZipFilePath`n"
  "  }`n"
  #endregion
  #region | Extract the .zip file of Windows ADK Installation Files into the %UserProfile% |
  "  `$IsPresent = Test-Path -Path $([System.Char]34)$AppFolder\`$AppName Extracted$([System.Char]34)`n"
  "  if (-not `$IsPresent) {`n"
  "    Expand-Archive -Path `$ZipFilePath -DestinationPath $([System.Char]34)$AppFolder$([System.Char]34)`n"
  "  }`n"
  #endregion

  #region | Download but do not install the Windows PE Installation Files |
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
  "    Start-Process -FilePath $([System.Char]39).\adkwinpesetup.exe$([System.Char]39) -WorkingDirectory `$WorkingDirectory -ArgumentList `$DownloadArgumentList -Wait -Verb 'RunAs'`n"
  "    `$TargetLayoutFolder = try {Get-Item -Path `$TargetLayout -ErrorAction $([System.Char]39)Stop$([System.Char]39)} catch {New-Item -Path `$TargetLayout -ItemType $([System.Char]39)Directory$([System.Char]39) -Force}`n"
  "    Move-Item -Path $([System.Char]34)`$env:ProgramData\UserExperienceManifest.xml$([System.Char]34) -Destination $([System.Char]34)`$TargetLayoutFolder$([System.Char]34)`n"
  "    Move-Item -Path $([System.Char]34)`$env:ProgramData\adkwinpesetup.exe$([System.Char]34) -Destination $([System.Char]34)`$TargetLayoutFolder$([System.Char]34)`n"
  "    Move-Item -Path $([System.Char]34)`$env:ProgramData\Installers$([System.Char]34) -Destination $([System.Char]34)`$TargetLayoutFolder$([System.Char]34) -Force`n"
  "  }`n"
  #endregion
  #region | Compress the WinPE Installation Files |
  "  `$ZipFilePath = $([System.Char]34)`$env:ProgramData\ADK + WinPE\`$AppName.zip$([System.Char]34)`n"
  "  `$IsPresent = Test-Path -Path `$ZipFilePath`n"
  "  if (-not `$IsPresent) {`n"
  "    Compress-Archive -Path `$TargetLayout -DestinationPath `$ZipFilePath`n"
  "  }`n"
  #endregion
  #region | Extract the .zip file of WinPE Installation Files into the %UserProfile% |
  "  `$IsPresent = Test-Path -Path $([System.Char]34)$AppFolder\`$AppName Extracted$([System.Char]34)`n"
  "  if (-not `$IsPresent) {`n"
  "    Expand-Archive -Path `$ZipFilePath -DestinationPath $([System.Char]34)$AppFolder$([System.Char]34)`n"
  "  }`n"
  #endregion
  "}`n"
) -join ''

${Bring ADK + WinPE Offline Installation Files into a %UserProfile% Container Script Path} = "$AppFolder\Bring ADK + WinPE Offline Installation Files into a %UserProfile% Container Script.ps1"
Set-Content -Path ${Bring ADK + WinPE Offline Installation Files into a %UserProfile% Container Script Path} -Value (${Bring ADK + WinPE Offline Installation Files into a %UserProfile% Container Here-String})
#Write-host -object "  `${Bring ADK + WinPE Offline Installation Files into a %UserProfile% Container Script Path} = ${Bring ADK + WinPE Offline Installation Files into a %UserProfile% Container Script Path}"
$ArgumentList = @(
  "`${Here-String} = Get-Item -Path '${Bring ADK + WinPE Offline Installation Files into a %UserProfile% Container Script Path}' | Get-Content -Raw; `$ScriptBlock = [ScriptBlock]::Create(`${Here-String}); `$ScriptBlock | Invoke-Expression"
)

${Windows ADK 2026-09 Extracted Folder Name} = 'Windows ADK 2026-09 Extracted'
${Windows ADK 2026-09 Extracted Folder Path} = "$AppFolder\${Windows ADK 2026-09 Extracted Folder Name}"
${WinPE 2026-09 Extracted Folder Name} = 'WinPE 2026-09 Extracted'
${WinPE 2026-09 Extracted Folder Path} = "$AppFolder\${WinPE 2026-09 Extracted Folder Name}"

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
#$InstallsPath = "$PSScriptRoot\..\.CommonItems\usb0\$FolderFQN\cfg\installs"
$InstallsPath = "$PSScriptRoot\..\.CommonItems\WinPE"
$path = "$InstallsPath\ADK + WinPE (2026-09)"
$AppFolder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
#endregion
#region | Main logic for offline install of ADK + WinPE |
$AppName = 'Windows ADK 2026-09'
$UninstallGuid = '4f4f4626-ccb4-41ba-9c62-7ec9b0e113f3'
$InstallerArgumentList = @(
  '/quiet'
  '/ceip on'
  '/features OptionId.DeploymentTools'
)

$IsZipPresent = Test-Path -Path "$AppFolder\$AppName.zip"
$IsInstalled = Test-Path -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{$UninstallGuid}"
switch ($true) {
  { # Zip is NOT present + App is NOT installed --->  Install + Compress. |
    (-not $IsZipPresent) -and (-not $IsInstalled)
  } {
    Write-Verbose -Message "    Zip is NOT present + App is NOT installed --->  Install + Compress."
    #region | Install Windows ADK or WinPE from offline files |
    $WorkingDirectory = "$AppFolder\$AppName Extracted"
    Start-Process -FilePath '.\adksetup.exe' -WorkingDirectory $WorkingDirectory -ArgumentList $InstallerArgumentList -Wait -Verb 'RunAs'
    #endregion
    #region | Compress Installation Files to .zip Flie |
    Compress-Archive -Path "$AppFolder\$AppName Extracted" -DestinationPath "$AppFolder\$AppName.zip"
    #endregion
    break
  }
  { # Zip IS present + App is NOT installed     --->  Install. |
    ($IsZipPresent) -and (-not $IsInstalled)
  } {
    Write-Verbose -Message "    Zip IS present + App is NOT installed     --->  Install."
    #region | Install Windows ADK or WinPE from offline files |
    $WorkingDirectory = "$AppFolder\$AppName Extracted"
    Start-Process -FilePath '.\adksetup.exe' -WorkingDirectory $WorkingDirectory -ArgumentList $InstallerArgumentList -Wait -Verb 'RunAs'
    #endregion
    break
  }
  { # Zip is NOT present + App IS installed     --->  Shouldn't happen. Compress. |
    (-not $IsZipPresent) -and ($IsInstalled)
  } {
    Write-Verbose -Message "    Zip is NOT present + App IS installed     --->  Shouldn't happen. Compress."
    #region | Compress Installation Files to .zip Flie |
    Compress-Archive -Path "$AppFolder\$AppName Extracted" -DestinationPath "$AppFolder\$AppName.zip"
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
$UninstallGuid = 'f567a246-97ac-4217-a1ba-020ced2a8187'
$InstallerArgumentList = @(
  '/quiet'
  '/ceip on'
  '/features OptionId.WindowsPreinstallationEnvironment'
)

$IsZipPresent = Test-Path -Path "$AppFolder\$AppName.zip"
$IsInstalled = Test-Path -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{$UninstallGuid}"
switch ($true) {
  { # Zip is NOT present + App is NOT installed --->  Install + Compress. |
    (-not $IsZipPresent) -and (-not $IsInstalled)
  } {
    Write-Verbose -Message "    Zip is NOT present + App is NOT installed --->  Install + Compress."
    #region | Install Windows ADK or WinPE from offline files |
    $WorkingDirectory = "$AppFolder\$AppName Extracted"
    Start-Process -FilePath '.\adkwinpesetup.exe' -WorkingDirectory $WorkingDirectory -ArgumentList $InstallerArgumentList -Wait -Verb 'RunAs'
    #endregion
    #region | Compress Installation Files to .zip Flie |
    Compress-Archive -Path "$AppFolder\$AppName Extracted" -DestinationPath "$AppFolder\$AppName.zip"
    #endregion
    break
  }
  { # Zip IS present + App is NOT installed     --->  Install. |
    ($IsZipPresent) -and (-not $IsInstalled)
  } {
    Write-Verbose -Message "    Zip IS present + App is NOT installed     --->  Install."
    #region | Install Windows ADK or WinPE from offline files |
    $WorkingDirectory = "$AppFolder\$AppName Extracted"
    Start-Process -FilePath '.\adkwinpesetup.exe' -WorkingDirectory $WorkingDirectory -ArgumentList $InstallerArgumentList -Wait -Verb 'RunAs'
    #endregion
    break
  }
  { # Zip is NOT present + App IS installed     --->  Shouldn't happen. Compress. |
    (-not $IsZipPresent) -and ($IsInstalled)
  } {
    Write-Verbose -Message "    Zip is NOT present + App IS installed     --->  Shouldn't happen. Compress."
    #region | Compress Installation Files to .zip Flie |
    Compress-Archive -Path "$AppFolder\$AppName Extracted" -DestinationPath "$AppFolder\$AppName.zip"
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
#region | External Removable Bootable Media > Clear Disk > EFS (EFI System Partition) |
. "$PSScriptRoot\output\$FolderFQN\usb1\$FolderFQN\Base\5.1\External Bootable Media Drive Letters.ps1"
${Disk CIM Instance} = Get-Disk | Where-Object -FilterScript {
  $_.FriendlyName -eq ${OSDeploy FriendlyName} -and `
  $_.SerialNumber -eq ${OSDeploy SerialNumber} -and `
  $_.UniqueId     -eq ${OSDeploy UniqueId Raw}
}
$DriveLetter = ${Disk CIM Instance} | Get-Partition | Select-Object -ExpandProperty 'DriveLetter'

#endregion

<# Unmount the WinPE image and create media |
  start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/winpe-mount-and-customize?view=windows-11#unmount-the-windows-pe-image-and-create-media'
#>
<# CLI Options for the MakeWinPeMedia.cmd batch file |
  start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/makewinpemedia-command-line-options?view=windows-11&source=recommendations#makewinpemedia-parameters'
#>


#region | PowerShell-enabled WinPE ISO File |
# [ ] Implementation Complete
# Use newer version of DISM in WinPE: 
# Step 1: start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/copy-dism-to-another-computer?view=windows-11'
# Step 2: start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/copy-dism-to-another-computer?view=windows-11#use-the-new-version-of-dism'
${WinPE Workspace Folder Name} = 'PowerShell-Infused'
$InputHT = @{
  'WinPE Workspace Folder Name' = ${WinPE Workspace Folder Name}
}
#   & "$PSScriptRoot\Start\ADK + WinPE\New PowerShell-enabled WinPE ISO File.ps1" @HT
$OutputHT = & "$PSScriptRoot\Start\ADK + WinPE\Bootable USB with PowerShell-enabled WinPE.ps1" @InputHT
#   ${Command Here-String} = Get-Content -Raw -Path "C:\Users\lowpr\GitHub\CarlSimonIT\.CommonItems\WinPE\Bootable USB with PowerShell-enabled WinPE Script.ps1"; ${Command ScriptBlock} = [ScriptBlock]::Create(${Command Here-String}); & ${Command ScriptBlock}

${Bootable USB with PowerShell-enabled WinPE Script Path} = $OutputHT['Bootable USB with PowerShell-enabled WinPE Script Path']
#Write-Host -Object "`${Bootable USB with PowerShell-enabled WinPE Script Path} = ${Bootable USB with PowerShell-enabled WinPE Script Path}"
$WorkingDirectory = $OutputHT['WorkingDirectory']
#Write-Host -Object "`$WorkingDirectory = $WorkingDirectory"
${WinPE Image Creation Parent Folder} = $OutputHT['WinPE Image Creation Parent Folder']
#Write-Host -Object "`${WinPE Image Creation Parent Folder} = ${WinPE Image Creation Parent Folder}"
# $WorkingDirectory = "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools"
#         ${cmd H-S} = Get-Content -Raw -Path ${Bootable USB with PowerShell-enabled WinPE Script Path}; ${cmd ScBk} = [ScriptBlock]::Create(${cmd H-S}); & ${cmd ScBk}
$path = "${WinPE Image Creation Parent Folder}\${WinPE Workspace Folder Name}\Updated ISO"
#Write-Host -Object "`$path = $path"
$IsPresent = Test-Path -Path $path
#Write-Host -Object "`$IsPresent = $IsPresent"

if (-not $IsPresent) {
  $ArgumentList2 = @(
    $WorkingDirectory
    ${Bootable USB with PowerShell-enabled WinPE Script Path}
  ) 
  Start-Job -Name 'Bootable USB with PowerShell-enabled WinPE' -ArgumentList $ArgumentList2 -ScriptBlock {
    $WorkingDirectory = $args[0]

    ${Bootable USB with PowerShell-enabled WinPE Script Path} = $args[1]

    $ArgumentList = @(
      "/c $([System.Char]34)$WorkingDirectory\DandISetEnv.bat$([System.Char]34) && powershell.exe -NoProfile -ExecutionPolicy 'RemoteSigned'; Invoke-Expression -Command (Get-Content -Raw -Path '${Bootable USB with PowerShell-enabled WinPE Script Path}');"
      #"/c $([System.Char]34)$WorkingDirectory\DandISetEnv.bat$([System.Char]34) && powershell.exe -NoProfile -ExecutionPolicy 'RemoteSigned'; `${cmd H-S} = gc -Raw -Path '${Bootable USB with PowerShell-enabled WinPE Script Path}'; `${cmd ScBk} = [ScriptBlock]::Create(`${cmd H-S}); & `${cmd ScBk}"
      #"/c $([System.Char]34)$WorkingDirectory\DandISetEnv.bat$([System.Char]34) && powershell.exe -NoProfile -ExecutionPolicy 'RemoteSigned'; Start-Job {`${cmd H-S} = gc -Raw -Path '${Bootable USB with PowerShell-enabled WinPE Script Path}'; `${cmd ScBk} = [ScriptBlock]::Create(`${cmd H-S}); & `${cmd ScBk}}"
      #"/c $([System.Char]34)$WorkingDirectory\DandISetEnv.bat$([System.Char]34) && powershell.exe -NoProfile -ExecutionPolicy 'RemoteSigned'; iex -command (Start-Job {`${cmd H-S} = gc -Raw -Path '${Bootable USB with PowerShell-enabled WinPE Script Path}'; `${cmd ScBk} = [ScriptBlock]::Create(`${cmd H-S}); & `${cmd ScBk}})"
      #"/c $([System.Char]34)$WorkingDirectory\DandISetEnv.bat$([System.Char]34) && powershell.exe -NoProfile -ExecutionPolicy 'RemoteSigned'; iex -command (`${cmd H-S} = gc -Raw -Path '${Bootable USB with PowerShell-enabled WinPE Script Path}'; `${cmd ScBk} = [ScriptBlock]::Create(`${cmd H-S}); & `${cmd ScBk})"
      #"/c $([System.Char]34)$WorkingDirectory\DandISetEnv.bat$([System.Char]34) && powershell.exe -NoProfile -ExecutionPolicy 'RemoteSigned'; iex -command (`${cmd ScBk} = [ScriptBlock]::Create((gc -Raw -Path '${Bootable USB with PowerShell-enabled WinPE Script Path}')); & `${cmd ScBk})"
      #"/c $([System.Char]34)$WorkingDirectory\DandISetEnv.bat$([System.Char]34) && powershell.exe -NoProfile -ExecutionPolicy 'RemoteSigned'; iex -command (& ([ScriptBlock]::Create((gc -Raw -Path '${Bootable USB with PowerShell-enabled WinPE Script Path}'))))"
    ) 
    Start-Process -FilePath cmd.exe -ArgumentList $ArgumentList -Verb 'RunAs' -WorkingDirectory $WorkingDirectory -WindowStyle 'Hidden' -Wait  #  -NoNewWindow
  }
}
#endregion

#region | Patch offline Windows Server 2025 .iso file |
#region | Re-confirm that 'Windows Server 2025.iso' has downloaded to the 'Original' directory |
#$path = "$PSScriptRoot\..\.CommonItems\Offline WU\Server 25\Original"
#$folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}

$path = "$PSScriptRoot\..\.CommonItems\Offline WU\Server 25\Original"
${Offline WU-Original Server 2025 Folder} = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
$path = "$PSScriptRoot\..\.CommonItems\Offline WU\Server 25\Patched"
${Offline WU-Patched Server 2025 Folder} = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}

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

    $Job = Start-Job -Name $JobName -ArgumentList $ArgumentList -ScriptBlock {
      $WebPath                    = $args[0]
      $FilePath                   = $args[1]
      $OriginalProgressPreference = $args[2]

      $ProgressPreference = 'SilentlyContinue'
      Invoke-WebRequest -Uri $WebPath -OutFile $FilePath
      $ProgressPreference = $OriginalProgressPreference
    }
    $Job | Format-Table -AutoSize
  }
} 
else { # If an unpatched ISO file for Server 2025 is confirmed to be inside ${env:.CommonItems}, ensure that file has been transplanted and appropriately renamed |
  ${Is ISO Already Relocated and Renamed} = Test-Path -Path "${Offline WU-Original Server 2025 Folder}\Windows Server 2025.iso"
  if (-not ${Is ISO Already Relocated and Renamed}) {
    Move-Item -Path ${Windows Server 2025 ISO Original File}.FullName -Destination "${Offline WU-Original Server 2025 Folder}\Windows Server 2025.iso"
  }
}
#endregion
#region | Deploy new directory for downloading latest Windows Updates |
# Write-Host "`n`tPatch Tuesday Of This Month:`n"
# ${Patch Tuesday Of This Month}
${Patch Tuesday Of This Month Has Already Arrived} = [System.DateTime]::Now -gt ${Patch Tuesday Of This Month}
#Write-Host "`n`t[System.DateTime]::Now`n"
#[System.DateTime]::Now
# Write-Host "`n`tPatch Tuesday Of This Month Has Already Arrived`n"
# ${Patch Tuesday Of This Month Has Already Arrived}
#$_Var_Name = 'Windows Updates Directory BaseName'
#try {Clear-Variable -Name $_Var_Name -ErrorAction 'Stop'} catch {New-Variable -Name $_Var_Name -Value $null}

if (${Patch Tuesday Of This Month Has Already Arrived}) {
  ${Windows Updates Directory BaseName} = [System.String]::Format('{0:yyyy}-{0:MM}',[System.DateTime]::Now)
} else {
  ${Windows Updates Directory BaseName} = [System.String]::Format('{0:yyyy}-{0:MM}',([System.DateTime]::Now).AddMonths(-1))
}

#$path = "$PSScriptRoot\..\.CommonItems\usb0\$FolderFQN\Microsoft\OS\Microsoft Update\${Windows Updates Directory BaseName}"
$path = "$PSScriptRoot\..\.CommonItems\Offline WU\Microsoft Update\${Windows Updates Directory BaseName}"
$folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
#endregion
#region | Download Latest Windows Updates for Server 2025 |
${Windows Updates Directory FullName} = Resolve-Path -Path "$PSScriptRoot\..\.CommonItems\Offline WU\Microsoft Update\${Windows Updates Directory BaseName}" | Select-Object -ExpandProperty 'Path'
Write-host -object "`${Windows Updates Directory FullName} = ${Windows Updates Directory FullName}"

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
  blah blah blah
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

if ($null -ne ${Windows Server 2025 ISO Original File}) { # $false |
  $path = "$PSScriptRoot\..\.CommonItems\Offline WU\Server 25\Patched"
  $folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
  ${Windows Server 2025 ISO Patched File} = [System.IO.FileInfo]"$folder\Windows Server 2025.iso"
  $IsPresent = Test-Path -Path ${Windows Server 2025 ISO Patched File}.FullName
  if (-not $IsPresent) {
    $path = "$PSScriptRoot\..\.CommonItems\Offline WU\Server 25\Extracted ISO"
    ${Extracted ISO Folder} = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}

    $path = "$PSScriptRoot\..\.CommonItems\Offline WU\Server 25\mounted_wim"
    ${mounted_wim Folder} = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}

    <#
      $InputHT = @{
        'Windows Server 2025 ISO Original File Path' = ${Windows Server 2025 ISO Original File}.FullName
        'Windows Server 2025 ISO Patched File Path'  = ${Windows Server 2025 ISO Patched File}.FullName
      }
      #$OutputHT = & "$PSScriptRoot\Start\ADK + WinPE\Mount + Patch s25 ISO File.ps1" @InputHT
      $OutputHT = & "$PSScriptRoot\Start\ADK + WinPE\Patch Windows Server ISO File with Latest Windows Updates.ps1" @InputHT
      ${Patch Windows Server ISO File with Latest Windows Updates Script Path} = $OutputHT['Patch Windows Server ISO File with Latest Windows Updates Script Path']
      $ArgumentList = @(
        "Invoke-Expression -Command (Get-Content -Raw -Path '${Patch Windows Server ISO File with Latest Windows Updates Script Path}')"
      )
      Start-Process -FilePath powershell.exe -ArgumentList $ArgumentList -Verb 'RunAs' -WindowStyle 'Hidden' -Wait
    #>
    <#
      Set-Location -Path "${env:.CommonItems}\..\Instant-ADCS\Start\ADK + WinPE"
      code '.\WU s25 Part 01-Mount Original Windows Server ISO File at IL-High.ps1'
      code '.\WU s25 Part 02-Copy Mounted Contents at IL-Medium.ps1'
      code '.\WU s25 Part 03-Dismount ISO, Apply Updates, Package into Patched ISO at IL-High.ps1'
    #>

    $InputHT = @{
      'Windows Server 2025 ISO Original File Path' = ${Windows Server 2025 ISO Original File}.FullName
      'Windows Server 2025 ISO Patched File Path'  = ${Windows Server 2025 ISO Patched File}.FullName
    }
    $OutputHT = & "$PSScriptRoot\Start\ADK + WinPE\WU s25 Part 01-Mount Original Windows Server ISO File at IL-High.ps1" @InputHT
    ${WU s25 Part 01-Mount Original Windows Server ISO File at IL-High Script Path} = $OutputHT['WU s25 Part 01-Mount Original Windows Server ISO File at IL-High Script Path']
    #Write-Host -Object "`${WU s25 Part 01-Mount Original Windows Server ISO File at IL-High Script Path} = ${WU s25 Part 01-Mount Original Windows Server ISO File at IL-High Script Path}"
    $ArgumentList = @(
      "Invoke-Expression -Command (Get-Content -Raw -Path '${WU s25 Part 01-Mount Original Windows Server ISO File at IL-High Script Path}')"
    )
    $JobName = "WU s25 Part 03-Dismount ISO, Apply Updates, Package into Patched ISO at IL-High"
    $RunningJob = Get-Job | Where-Object -FilterScript {
      $_.Name  -eq $JobName  -and `
      $_.State -eq 'Running'
    }
    if ($RunningJob -eq $null) {
      Start-Process -FilePath powershell.exe -ArgumentList $ArgumentList -Verb 'RunAs' -WindowStyle 'Hidden' -Wait
    }

    

    <#
      ${Key Title 0} = $OutputHT['Key Title 0']
      ${Key Title 1} = $OutputHT['Key Title 1']
      ${Key Title 2} = $OutputHT['Key Title 2']
      $WorkingDirectory = $OutputHT['WorkingDirectory']
      ${WinPE Image Creation Parent Folder} = $OutputHT['WinPE Image Creation Parent Folder']
      $path = "${WinPE Image Creation Parent Folder}\${WinPE Workspace Folder Name}\Updated ISO"
      $IsPresent = Test-Path -Path $path

      if (-not $IsPresent) {
        $ArgumentList2 = @(
          $WorkingDirectory
          ${Bootable USB with PowerShell-enabled WinPE Script Path}
        ) 
        Start-Job -Name 'Bootable USB with PowerShell-enabled WinPE' -ArgumentList $ArgumentList2 -ScriptBlock {
          $WorkingDirectory = $args[0]

          ${Bootable USB with PowerShell-enabled WinPE Script Path} = $args[1]

          $ArgumentList = @(
            "/c $([System.Char]34)$WorkingDirectory\DandISetEnv.bat$([System.Char]34) && powershell.exe -NoProfile -ExecutionPolicy 'RemoteSigned'; Invoke-Expression -Command (Get-Content -Raw -Path '${Bootable USB with PowerShell-enabled WinPE Script Path}');"
          ) 
          Start-Process -FilePath cmd.exe -ArgumentList $ArgumentList -Verb 'RunAs' -WorkingDirectory $WorkingDirectory -WindowStyle 'Hidden' -Wait  #  -NoNewWindow
        }
      }

    #>

    $InputHT = @{
      'Extracted ISO Folder Path' = "${Extracted ISO Folder}"
    }
    $OutputHT = & "$PSScriptRoot\Start\ADK + WinPE\WU s25 Part 02-Copy Mounted Contents at IL-Medium.ps1" @InputHT
    ${WU s25 Part 02-Copy Mounted Contents at IL-Medium Script Path} = $OutputHT['WU s25 Part 02-Copy Mounted Contents at IL-Medium Script Path']
    #Write-Host -Object "`${WU s25 Part 02-Copy Mounted Contents at IL-Medium Script Path} = ${WU s25 Part 02-Copy Mounted Contents at IL-Medium Script Path}"
    $ArgumentList = @(
      "Invoke-Expression -Command (Get-Content -Raw -Path '${WU s25 Part 02-Copy Mounted Contents at IL-Medium Script Path}')"
    )
    $JobName = "WU s25 Part 03-Dismount ISO, Apply Updates, Package into Patched ISO at IL-High"
    $RunningJob = Get-Job | Where-Object -FilterScript {
      $_.Name  -eq $JobName  -and `
      $_.State -eq 'Running'
    }
    if ($RunningJob -eq $null) {
      Start-Process -FilePath powershell.exe -ArgumentList $ArgumentList -WindowStyle 'Hidden' -Wait
    }

  
    Start-Sleep 3

    <#
      Set-ExecutionPolicy -ExecutionPolicy 'RemoteSigned' -Scope 'Process' -Force; $CloningRepoPath = "$env:UserProfile\GitHub\CarlSimonIT"; $CloningRepoFolder = try {Get-Item -Path $CloningRepoPath -ErrorAction 'Stop'} catch {New-Item -Path $CloningRepoPath -ItemType 'Directory' -Force}; Set-Location -Path "$CloningRepoFolder"; Set-ExecutionPolicy -ExecutionPolicy 'RemoteSigned' -Scope 'Process' -Force; $HT = @{EmailAddressOfBitwardenAccount = 'pwdsec3@gmail.com'; 'Folder Fully Qualified Name' = 'Instant-ADCS'; BadPassword = 'BadPassword!'; 'NetBIOS Name of Root Domain in AD Forest' = 'BlackCoffee'; 'DNS Name of Root Domain in AD Forest' = 'ad.black-coffee-black-coffee-black-coffee-black-coffee.INTERNAL'}; & '.\Instant-ADCS\Start.ps1' @HT; Set-Location -Path 'C:\'; (Get-Job).Where({$_.State -ne 'Running'}) | Remove-Job; Get-Job | Format-Table -AutoSize; 
    #>

    # Import custom class to enumerate the Windows Server Image Index collection
    . "$PSScriptRoot\output\$FolderFQN\usb1\$FolderFQN\Base\5.1\Class Definitions\Windows Server Image Index.ps1"

    ${Windows Server Image Index Set} = [System.UInt32[]]@(
      #[System.UInt32][WindowsServerImageIndex]::StandardServerCore
      #[System.UInt32][WindowsServerImageIndex]::StandardDesktopExperience
      #[System.UInt32][WindowsServerImageIndex]::DatacenterServerCore
      [System.UInt32][WindowsServerImageIndex]::DatacenterDesktopExperience
    )

    #${install.wim File Path} = Resolve-Path -Path "$PSScriptRoot\..\.CommonItems\Offline WU\Server 25\Extracted ISO\sources\install.wim" | Select-Object -ExpandProperty 'Path'
    ${install.wim File Path} = "${env:.CommonItems}\Offline WU\Server 25\Extracted ISO\sources\install.wim"

    $InputHT = @{
      'Windows Server Image Index Set'            = ${Windows Server Image Index Set}
      'install.wim File Path'                     = ${install.wim File Path}
      'mounted_wim Folder Path'                   = "${mounted_wim Folder}"
      'Package Directory Path'                    = "$PackagesFolder"
      'Windows Server 2025 ISO Patched File Path' = ${Windows Server 2025 ISO Patched File}.FullName
    }
    
    $OutputHT = & "$PSScriptRoot\Start\ADK + WinPE\WU s25 Part 03-Dismount ISO, Apply Updates, Package into Patched ISO at IL-High.ps1" @InputHT

    ${WU s25 Part 03-Dismount ISO, Apply Updates, Package into Patched ISO at IL-High Script Path} = $OutputHT['WU s25 Part 03-Dismount ISO, Apply Updates, Package into Patched ISO at IL-High Script Path']
    #Write-Host -Object "`${WU s25 Part 03-Dismount ISO, Apply Updates, Package into Patched ISO at IL-High Script Path} = ${WU s25 Part 03-Dismount ISO, Apply Updates, Package into Patched ISO at IL-High Script Path}"
    $ArgumentListProcess = @(
      "Invoke-Expression -Command (Get-Content -Raw -Path '${WU s25 Part 03-Dismount ISO, Apply Updates, Package into Patched ISO at IL-High Script Path}')"
    )

    $JobName = "WU s25 Part 03-Dismount ISO, Apply Updates, Package into Patched ISO at IL-High"
    $RunningJob = Get-Job | Where-Object -FilterScript {
      $_.Name  -eq $JobName  -and `
      $_.State -eq 'Running'
    }
    if ($RunningJob -eq $null) {
      $ArgumentListJob = @(
        $ArgumentListProcess
      )
      $IsPresent = Test-Path -Path "$PSScriptRoot\..\.CommonItems\Offline WU\Server 25\Patched\Windows Server 2025.iso"
      if (-not $IsPresent) {
        Start-Job -Name $JobName -ArgumentList $ArgumentListJob -ScriptBlock {
          $ArgumentListProcess = $args[0]
          Start-Process -FilePath powershell.exe -ArgumentList $ArgumentListProcess -Verb 'RunAs' -WindowStyle 'Hidden' -Wait
        }
      }
    }
  }
}








#endregion
#endregion








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
$Patch = 20

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

    $Job = Start-Job -Name $JobName -ArgumentList $ArgumentList -ScriptBlock {
      $WebPath                    = $args[0]
      $FilePath                   = $args[1]
      $OriginalProgressPreference = $args[2]

      $ProgressPreference = 'SilentlyContinue'
      Invoke-WebRequest -Uri $WebPath -OutFile $FilePath
      $ProgressPreference = $OriginalProgressPreference
    }
    $Job | Format-Table -AutoSize
  }
}
#endregion
#region | PowerShell 7.5 |
$Minor = 5
$Patch = 11

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

    $Job = Start-Job -Name $JobName -ArgumentList $ArgumentList -ScriptBlock {
      $WebPath                    = $args[0]
      $FilePath                   = $args[1]
      $OriginalProgressPreference = $args[2]

      $ProgressPreference = 'SilentlyContinue'
      Invoke-WebRequest -Uri $WebPath -OutFile $FilePath
      $ProgressPreference = $OriginalProgressPreference
    }
    $Job | Format-Table -AutoSize
  }
}
#endregion
#region | PowerShell 7.6 |
$Minor = 6
$Patch = 6

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

    $Job = Start-Job -Name $JobName -ArgumentList $ArgumentList -ScriptBlock {
      $WebPath                    = $args[0]
      $FilePath                   = $args[1]
      $OriginalProgressPreference = $args[2]

      $ProgressPreference = 'SilentlyContinue'
      Invoke-WebRequest -Uri $WebPath -OutFile $FilePath
      $ProgressPreference = $OriginalProgressPreference
    }
    $Job | Format-Table -AutoSize
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
#region | Download OneDriveSetup.exe | Download latest version of Visual Studio Code |
#endregion
#region | Resume authoring the custom AdHocInstantAdcsDsc DSC Resource module | Write build script upon completion |
# This is not going to be easy. 
# . powershell.exe -NoProfile -File "$PSScriptRoot\Start\AdHocInstantAdcsDsc\build.ps1"
# Best if rewritten on the Unclustered Hyper-V host

#endregion
#region | XML Files |
#endregion










