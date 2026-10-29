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
  $CloningRepoPath = "$env:UserProfile\GitHub\e4\m5\CarlSimonIT"; $CloningRepoFolder = try {Get-Item -Path $CloningRepoPath -ErrorAction 'Stop'} catch {New-Item -Path $CloningRepoPath -ItemType 'Directory' -Force}; Set-Location -Path "$CloningRepoFolder"
  Set-ExecutionPolicy -ExecutionPolicy 'RemoteSigned' -Scope 'Process' -Force; 
  ipmo "$env:UserProfile\GitHub\e4\m5\CarlSimonIT\Instant-ADCS\A0\HereStringConversionModule.psm1"
  $HT = @{EmailAddressOfBitwardenAccount = 'pwdsec3@gmail.com'; 'Folder Fully Qualified Name' = 'Instant-ADCS'; BadPassword = 'BadPassword!'; 'NetBIOS Name of Root Domain in AD Forest' = 'BeefBurito'; 'DNS Name of Root Domain in AD Forest' = 'ad.Chicken-Salad.INTERNAL'}; & '.\Instant-ADCS\Start.ps1' @HT; Set-Location -Path 'C:\'; 
  (Get-Job).Where({$_.State -ne 'Running'}) | Remove-Job; Get-Job | Format-Table -AutoSize
  Set-ExecutionPolicy -ExecutionPolicy 'RemoteSigned' -Scope 'Process' -Force; $CloningRepoPath = "$env:UserProfile\GitHub\e4\m5\CarlSimonIT"; $CloningRepoFolder = try {Get-Item -Path $CloningRepoPath -ErrorAction 'Stop'} catch {New-Item -Path $CloningRepoPath -ItemType 'Directory' -Force}; Set-Location -Path "$CloningRepoFolder"; Set-ExecutionPolicy -ExecutionPolicy 'RemoteSigned' -Scope 'Process' -Force; $HT = @{EmailAddressOfBitwardenAccount = 'pwdsec3@gmail.com'; 'Folder Fully Qualified Name' = 'Instant-ADCS'; BadPassword = 'BadPassword!'; 'NetBIOS Name of Root Domain in AD Forest' = 'BeefBurito'; 'DNS Name of Root Domain in AD Forest' = 'ad.Chicken-Salad.INTERNAL'}; & '.\Instant-ADCS\Start.ps1' @HT; Set-Location -Path 'C:\'; (Get-Job).Where({$_.State -ne 'Running'}) | Remove-Job; Get-Job | Format-Table -AutoSize; 
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
