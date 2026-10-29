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
    Mandatory = $false
  )]
  [System.String]
  $__DirectoryForDscConfigs = '_Zeta',

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
  $CloningRepoPath = "$env:UserProfile\GitHub\InterM3d\mc3\CarlSimonIT"; $CloningRepoFolder = try {Get-Item -Path $CloningRepoPath -ErrorAction 'Stop'} catch {New-Item -Path $CloningRepoPath -ItemType 'Directory' -Force}; Set-Location -Path "$CloningRepoFolder"
  Set-ExecutionPolicy -ExecutionPolicy 'RemoteSigned' -Scope 'Process' -Force; 
  $HT = @{EmailAddressOfBitwardenAccount = 'pwdsec3@gmail.com'; 'Folder Fully Qualified Name' = 'Instant-ADCS'; BadPassword = 'BadPassword!'; 'NetBIOS Name of Root Domain in AD Forest' = 'BeefBurito'; 'DNS Name of Root Domain in AD Forest' = 'ad.Chicken-Salad.INTERNAL'}; & '.\Instant-ADCS\Start.ps1' @HT; Set-Location -Path 'C:\'; 
  (Get-Job).Where({$_.State -ne 'Running'}) | Remove-Job; Get-Job | Format-Table -AutoSize
  Set-ExecutionPolicy -ExecutionPolicy 'RemoteSigned' -Scope 'Process' -Force; $CloningRepoPath = "$env:UserProfile\GitHub\InterM3d\mc3\CarlSimonIT"; $CloningRepoFolder = try {Get-Item -Path $CloningRepoPath -ErrorAction 'Stop'} catch {New-Item -Path $CloningRepoPath -ItemType 'Directory' -Force}; Set-Location -Path "$CloningRepoFolder"; Set-ExecutionPolicy -ExecutionPolicy 'RemoteSigned' -Scope 'Process' -Force; $HT = @{EmailAddressOfBitwardenAccount = 'pwdsec3@gmail.com'; 'Folder Fully Qualified Name' = 'Instant-ADCS'; BadPassword = 'BadPassword!'; 'NetBIOS Name of Root Domain in AD Forest' = 'BeefBurito'; 'DNS Name of Root Domain in AD Forest' = 'ad.Chicken-Salad.INTERNAL'}; & '.\Instant-ADCS\Start.ps1' @HT; Set-Location -Path 'C:\'; (Get-Job).Where({$_.State -ne 'Running'}) | Remove-Job; Get-Job | Format-Table -AutoSize; 
  Clear-Host; 
#>

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
$InputHT = @{
  'SHA256 of Windows Server 2025 ISO File' = ${SHA256 of Windows Server 2025 ISO File}
  'SHA256 of WinPE 2026-09 EXE File'       = ${SHA256 of WinPE 2026-09 EXE File}
  'SHA256 of Dell WinPE Driver Pack A11'   = ${SHA256 of Dell WinPE Driver Pack A11}
  'SHA256 of Windows ADK 2026-09 EXE File' = ${SHA256 of Windows ADK 2026-09 EXE File}
  EmailAddressOfBitwardenAccount           = $EmailAddressOfBitwardenAccount
  BadPassword                              = $BadPassword
  FolderFQN                                = $FolderFQN
  __DirectoryForDscConfigs                 = $__DirectoryForDscConfigs
}
& "$PSScriptRoot\Start\Export non-senstive strings to .clixml for later import by other applications.ps1" @InputHT
[System.Environment]::SetEnvironmentVariable('.CommonItems',"$CloningRepoPath\.CommonItems")
$FolderFQN = Import-CliXml -Path "$PSScriptRoot\..\.CommonItems\FolderFQN.clixml"

#region | Define new folder structures. Same code is re-executed later in Start.ps1 when applicable |
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
  Start-Job -Name $JobName -ArgumentList $ArgumentList -ScriptBlock {
    $StartFolder = $args[0]
    . "$env:ProgramFiles\PowerShell\7\pwsh.exe" -NoProfile -File "$StartFolder\PowerShell 5.1 Job that calls pwsh.exe to Generate and Save Credentials into Bitwarden Vault.ps1"
    . "$env:ProgramFiles\PowerShell\7\pwsh.exe" -NoProfile -File "$StartFolder\PowerShell 5.1 Job that compiles the Quick Lookup Table.csv File.ps1"
    . "$env:ProgramFiles\PowerShell\7\pwsh.exe" -NoProfile -File "$StartFolder\PowerShell 5.1 Job that updates the password for logging into the bare-metal unclustered Hyper-V host.ps1"
    . "$env:ProgramFiles\PowerShell\7\pwsh.exe" -NoProfile -File "$StartFolder\PowerShell 5.1 Job that writes passwords from local Secrets Vault into local Windows Credential Manager.ps1"
  } | Out-Null
}
#endregion
#region | Download Windows Server .ISO file | Download Windows 11 Enterprise .ISO file |
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
      #$Job | Format-Table -AutoSize
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
    } | Out-Nul
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
## I think we can delete ##

#${Disk CIM Instance} = Get-Disk | Where-Object -FilterScript {
#  $_.FriendlyName -eq ${OSDeploy FriendlyName} -and `
#  $_.SerialNumber -eq ${OSDeploy SerialNumber} -and `
#  $_.UniqueId     -eq ${OSDeploy UniqueId Raw}
#}

#$DriveLetter = ${Disk CIM Instance} | Get-Partition | Select-Object -ExpandProperty 'DriveLetter'

# Write-Host -Object "`${OSDeploy Disk CIM Instance}.FriendlyName = $(${OSDeploy Disk CIM Instance}.FriendlyName)"
# pause
#endregion
<#
  # [ ] Implementation Complete
  # Notes on running Windows Setup in Windows PE: 
  start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/winpe-intro?view=windows-11#notes-on-running-windows-setup-in-windows-pe'
  # Configuration Passes Explained
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

  start msedge.exe ''

  Boot To WinPE
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
    Start-Job -Name 'Bootable USB with PowerShell-enabled WinPE' -ArgumentList $ArgumentList2 -ScriptBlock {
      $WorkingDirectory = $args[0]
      ${Bootable USB with PowerShell-enabled WinPE Script Path} = $args[1]
      $ArgumentList = @(
        "/c $([System.Char]34)$WorkingDirectory\DandISetEnv.bat$([System.Char]34) && powershell.exe -NoProfile -ExecutionPolicy 'RemoteSigned'; Invoke-Expression -Command (Get-Content -Raw -Path '${Bootable USB with PowerShell-enabled WinPE Script Path}');"
      )
      Start-Process -FilePath cmd.exe -ArgumentList $ArgumentList -Verb 'RunAs' -WorkingDirectory $WorkingDirectory -WindowStyle 'Hidden' -Wait  #  -NoNewWindow
    } | Out-Null
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
      #Copy-Item -Path ${Windows Server 2025 ISO Original File}.FullName -Destination "${Offline WU-Original Server 2025 Folder}"
      #Get-Item -Path "${Offline WU-Original Server 2025 Folder}\$(${Windows Server 2025 ISO Original File}.Name)" | Rename-Item -NewName 'Windows Server 2025.iso'
    }
  }
} else {${Windows Server 2025 ISO Original File} = [System.IO.FileInfo]"${Offline WU-Original Server 2025 Folder}\Windows Server 2025.iso"}

<# This takes way to long, so don't bother |
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
#>
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

$path = "$PSScriptRoot\..\.CommonItems\Offline WU\Microsoft Update\${Windows Updates Directory BaseName}"
$folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
#endregion
#region | Drivers |
$path = "$PSScriptRoot\..\.CommonItems\Offline WU\Drivers"
$folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
Write-Host -Object "`n  Prepare your Drivers folder. Press Enter when ready to proceed.`n" -ForegroundColor $(rFc)


#         "$drivers128\drivers\realtek\RTL8168E\Install_PCIE_WinServer2025"
#         "$drivers128\drivers\realtek\RTL8168E\Install_Win11"


pause
#endregion
#region | Download Latest Windows Updates for Server 2025 |
${Windows Updates Directory FullName} = Resolve-Path -Path "$PSScriptRoot\..\.CommonItems\Offline WU\Microsoft Update\${Windows Updates Directory BaseName}" | Select-Object -ExpandProperty 'Path'
#Write-host -object "`${Windows Updates Directory FullName} = ${Windows Updates Directory FullName}"

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

# These variables are referenced elsewhere in '.\Start.ps1' so they must be defined unconditionally. 
${Extracted ISO Folder Path} = "$PSScriptRoot\..\.CommonItems\Offline WU\Server 25\Extracted ISO"
${mounted_wim Folder Path} = "$PSScriptRoot\..\.CommonItems\Offline WU\Server 25\mounted_wim"

if (
  #$null -ne ${Windows Server 2025 ISO Original File}
  $null -ne "${Offline WU-Original Server 2025 Folder}\Windows Server 2025.iso"
) { # $false |
  $path = "$PSScriptRoot\..\.CommonItems\Offline WU\Server 25\Patched"
  ${Offline WU-Patched Server 2025 Folder} = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
  ${Windows Server 2025 ISO Patched File} = [System.IO.FileInfo]"${Offline WU-Patched Server 2025 Folder}\Windows Server 2025.iso"
  $IsPresent = Test-Path -Path ${Windows Server 2025 ISO Patched File}.FullName
  if (-not $IsPresent) {
    ## Stop creating these directories before they're needed. Causes conflicts with other subsequent operations
    #$path = "$PSScriptRoot\..\.CommonItems\Offline WU\Server 25\Extracted ISO"
    #${Extracted ISO Folder} = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
    #${Extracted ISO Folder Path} = "$PSScriptRoot\..\.CommonItems\Offline WU\Server 25\Extracted ISO"
    #$path = "$PSScriptRoot\..\.CommonItems\Offline WU\Server 25\mounted_wim"
    #${mounted_wim Folder} = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
    #${mounted_wim Folder Path} = "$PSScriptRoot\..\.CommonItems\Offline WU\Server 25\mounted_wim"

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
      'Extracted ISO Folder Path' = ${Extracted ISO Folder Path}
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
      Set-ExecutionPolicy -ExecutionPolicy 'RemoteSigned' -Scope 'Process' -Force; $CloningRepoPath = "$env:UserProfile\GitHub\InterM3d\mc3\CarlSimonIT"; $CloningRepoFolder = try {Get-Item -Path $CloningRepoPath -ErrorAction 'Stop'} catch {New-Item -Path $CloningRepoPath -ItemType 'Directory' -Force}; Set-Location -Path "$CloningRepoFolder"; Set-ExecutionPolicy -ExecutionPolicy 'RemoteSigned' -Scope 'Process' -Force; $HT = @{EmailAddressOfBitwardenAccount = 'pwdsec3@gmail.com'; 'Folder Fully Qualified Name' = 'Instant-ADCS'; BadPassword = 'BadPassword!'; 'NetBIOS Name of Root Domain in AD Forest' = 'BeefBurito'; 'DNS Name of Root Domain in AD Forest' = 'ad.Chicken-Salad.INTERNAL'}; & '.\Instant-ADCS\Start.ps1' @HT; Set-Location -Path 'C:\'; (Get-Job).Where({$_.State -ne 'Running'}) | Remove-Job; Get-Job | Format-Table -AutoSize; 
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
      'mounted_wim Folder Path'                   = ${mounted_wim Folder Path}
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
          Start-Process -FilePath powershell.exe -ArgumentList $ArgumentListProcess -Verb 'RunAs' -WindowStyle 'Normal' -Wait
        } | Out-Null
      }
    }
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
#region | Download, but do not install, DSC Resource modules |
$path = "$PSScriptRoot\..\.CommonItems\usb0\$FolderFQN\cfg\DSC Resources\PowerShell Gallery"
#            $path = 'C:\Users\lowpr\GitHub\InterM3d\mc3\CarlSimonIT\.CommonItems\usb0\Instant-ADCS\cfg\DSC Resources\PowerShell Gallery'
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
$Patch = 9

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
#region | Download OneDriveSetup.exe | Download latest version of Visual Studio Code |
$path = "$PSScriptRoot\..\.CommonItems\usb0\$FolderFQN\cfg\installs\Visual Studio Code\##"
$folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}


$path = "$PSScriptRoot\..\.CommonItems\usb0\$FolderFQN\cfg\installs\OneDrive\##"
$folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}

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
$path = "$PSScriptRoot\output\$FolderFQN\usb1\$FolderFQN\clixmls"; 
$folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
Get-ChildItem -Path "$PSScriptRoot\..\.CommonItems" -Filter '*.clixml' | ForEach-Object -Process {
  Copy-Item -Path $_.FullName -Destination "$folder"
}
#endregion
#region | Copy usb1 directory into $usb1 |
. "$PSScriptRoot\output\$FolderFQN\usb1\$FolderFQN\Base\5.1\External Storage Media Drive Letters.ps1"
if ($null -ne $usb1) {
  $IsPresent = Test-Path -Path "$usb1\$FolderFQN"
  if (-not $IsPresent) {
    Copy-Item -Path "$PSScriptRoot\output\$FolderFQN\usb1\$FolderFQN" -Destination "$usb1" -Recurse
  } else {
    Get-Item -Path "$usb1\$FolderFQN" | Rename-Item -NewName "$FolderFQN-$(Call-DateVAr)"
    Copy-Item -Path "$PSScriptRoot\output\$FolderFQN\usb1\$FolderFQN" -Destination "$usb1" -Recurse
  }
}
#endregion

