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

#endregion

#region | Install NuGet | Set PSGallery as Trusted | Install 'TUN.CredentialManager' |
#. powershell.exe -NoProfile -File "$PSScriptRoot\Start\NuGet-PSGallery-Windows PowerShell Module Install.ps1"
#endregion

#region | Write sensitive strings providing access to online Bitwarden Vault into local Windows Credential Manager |
#. powershell.exe -NoProfile -File "$PSScriptRoot\Start\Write sensitive strings providing access to online Bitwarden Vault into local Windows Credential Manager.ps1"
#endregion

#region | Collect and export to .clixml the unique identifiers of removable external storage media |
#. powershell.exe -NoProfile -File "$PSScriptRoot\Start\Collect and export to .clixml the unique identifiers of removable external storage media.ps1"
#endregion

#region | Generate Windows PowerShell-compatible profile.ps1 file for Instant-ADCS |
<#
  $HT = @{
    'NetBIOS Name of Root Domain in AD Forest' = ${NetBIOS Name of Root Domain in AD Forest}
    'DNS Name of Root Domain in AD Forest'     = ${DNS Name of Root Domain in AD Forest}
  }
  & "$PSScriptRoot\Start\Construct profile.ps1 for Windows PowerShell.ps1" @HT
#>
#endregion

#region | Install machine-scope PowerShell 7 and register Event Logging Manifest |
#. powershell.exe -NoProfile -File "$PSScriptRoot\Start\Install machine-scope PowerShell 7 and register Event Logging Manifest.ps1"
#endregion

#region | Install Bitwarden CLI, log into Bitwarden CLI, and Build SAT module |
# . "$env:ProgramFiles\PowerShell\7\pwsh.exe" -NoProfile -File "$PSScriptRoot\Start\Build Secure-Automations-Toolset Module.ps1"
#endregion

#region | Variable Setup in Windows PowerShell and Export to CliXml |
# . powershell.exe -NoProfile -File "$PSScriptRoot\Start\Variable Setup in Windows PowerShell and Export to CliXml.ps1"
#endregion

#region | Generate secure strings in online Bitwarden Vault and synchronize down to local Windows Credential Manager | WARNING: This will take over 60 minutes! |
<#
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
    $Job | Format-Table -AutoSize
  }
#>
#endregion

#region | Download Windows Server .ISO file | Download Windows 11 Enterprise .ISO file |
$path = "$PSScriptRoot\..\.CommonItems\usb0\$FolderFQN\Microsoft\OS\Server 25\Original"
$folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}

$FolderFQN = Import-CliXml -Path "$PSScriptRoot\..\.CommonItems\FolderFQN.clixml"
${SHA256 of Windows Server 2025 ISO File} = Import-CliXml -Path "$PSScriptRoot\..\.CommonItems\SHA256 of Windows Server 2025 ISO File.clixml"
$hash = ${SHA256 of Windows Server 2025 ISO File}
${Windows Server 2025 ISO File} = Get-ChildItem -Path "$folder" -File | Where-Object -PipelineVariable 'file' -FilterScript {$_.Extension -eq '.iso'} | ForEach-Object -Process {Get-FileHash -Path $file.FullName -Algorithm 'SHA256' | Where-Object -PipelineVariable 'AlgoHashPath' -FilterScript {$_.Hash -eq $hash} | ForEach-Object -Process {Get-Item -Path $AlgoHashPath.Path}} | Sort-Object -Property 'LastWriteTime' -Descending | Select-Object -First 1
if (${Windows Server 2025 ISO File} -eq $null) {
  $JobName = 'Download Windows Server 2025 ISO File'
  $RunningJob = Get-Job | Where-Object -FilterScript {
    $_.Name  -eq $JobName  -and `
    $_.State -eq 'Running'
  }
  if ($RunningJob -eq $null) {
    $ArgumentList = @(
      'https://go.microsoft.com/fwlink/?linkid=2293312&clcid=0x409&culture=en-us&country=us'
      "$folder\Windows Server 2025.iso"
      $ProgressPreference
    )

    $Job = Start-Job -Name $JobName -ArgumentList $ArgumentList -ScriptBlock {
      $WebPath                        = $args[0]
      $FilePath                       = $args[1]
      $OriginalProgressPreference     = $args[2]

      $ProgressPreference = 'SilentlyContinue'
      Invoke-WebRequest -Uri $WebPath -OutFile $FilePath
      $ProgressPreference = $OriginalProgressPreference
    }
    $Job | Format-Table -AutoSize
  }
}
#endregion

#region | Download, but do not install, the setup file for the Windows ADK and the Windows PE Add-on |
#region | Download the Windows ADK installer EXE File |
$path = "$PSScriptRoot\..\.CommonItems\usb0\$FolderFQN\cfg\installs\ADK + WinPE (2026-09)\Windows ADK 2026-09 Installer"
$folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}

$FolderFQN = Import-CliXml -Path "$PSScriptRoot\..\.CommonItems\FolderFQN.clixml"
${SHA256 of Windows ADK 2026-09 EXE File} = Import-CliXml -Path "$PSScriptRoot\..\.CommonItems\SHA256 of Windows ADK 2026-09 EXE File.clixml"
$hash = ${SHA256 of Windows ADK 2026-09 EXE File}
${Windows ADK 2026-09 EXE File} = Get-ChildItem -Path "$folder" -File | Where-Object -PipelineVariable 'file' -FilterScript {$_.Extension -eq '.exe'} | ForEach-Object -Process {Get-FileHash -Path $file.FullName -Algorithm 'SHA256' | Where-Object -PipelineVariable 'AlgoHashPath' -FilterScript {$_.Hash -eq $hash} | ForEach-Object -Process {Get-Item -Path $AlgoHashPath.Path}} | Sort-Object -Property 'LastWriteTime' -Descending | Select-Object -First 1
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
    $Job | Format-Table -AutoSize
  }
}
#endregion
#region | Download the WinPE installer EXE File |
$path = "$PSScriptRoot\..\.CommonItems\usb0\$FolderFQN\cfg\installs\ADK + WinPE (2026-09)\WinPE 2026-09 Installer"
$folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}

$FolderFQN = Import-CliXml -Path "$PSScriptRoot\..\.CommonItems\FolderFQN.clixml"
${SHA256 of WinPE 2026-09 EXE File} = Import-CliXml -Path "$PSScriptRoot\..\.CommonItems\SHA256 of WinPE 2026-09 EXE File.clixml"
$hash = ${SHA256 of WinPE 2026-09 EXE File}
$path = "$PSScriptRoot\..\.CommonItems\usb0\$FolderFQN\cfg\installs\ADK + WinPE (2026-09)\WinPE 2026-09 Installer"
$folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
${WinPE 2026-09 EXE File} = Get-ChildItem -Path "$folder" -File | Where-Object -PipelineVariable 'file' -FilterScript {$_.Extension -eq '.exe'} | ForEach-Object -Process {Get-FileHash -Path $file.FullName -Algorithm 'SHA256' | Where-Object -PipelineVariable 'AlgoHashPath' -FilterScript {$_.Hash -eq $hash} | ForEach-Object -Process {Get-Item -Path $AlgoHashPath.Path}} | Sort-Object -Property 'LastWriteTime' -Descending | Select-Object -First 1
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
    $Job | Format-Table -AutoSize
  }
}
#endregion
#endregion

#region | Download-Install-Compress ADK + WinPE |
${ADK + WinPE Script Folder Path} = "$PSScriptRoot\Start\ADK + WinPE"
$ArgumentList = @(${ADK + WinPE Script Folder Path})

$JobName0 = 'Download Windows ADK 2026-09 EXE File'
$RunningJob0 = Get-Job | Where-Object -FilterScript {
  $_.Name  -eq $JobName0  -and `
  $_.State -eq 'Running'
}
if ($null -ne $RunningJob0) {
  Get-Job -Name $JobName0 | Wait-Job | Format-Table -AutoSize
}
Write-Host -Object "  `$RunningJob0.Name = $($RunningJob0.Name)"

${ADK + WinPE Script Folder Path} = "$PSScriptRoot\Start\ADK + WinPE"
$HT = @{AppName = 'Windows ADK 2026-09'}

$FolderFQN = Import-CliXml -Path "$PSScriptRoot\..\.CommonItems\FolderFQN.clixml"
$InstallsPath = "$PSScriptRoot\..\.CommonItems\usb0\$FolderFQN\cfg\installs"
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
Write-host -object "  `${Bring ADK + WinPE Offline Installation Files into a %UserProfile% Container Script Path} = ${Bring ADK + WinPE Offline Installation Files into a %UserProfile% Container Script Path}"
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

#region | Groundwork Variables |
$FolderFQN = Import-CliXml -Path "$PSScriptRoot\..\.CommonItems\FolderFQN.clixml"
$InstallsPath = "$PSScriptRoot\..\.CommonItems\usb0\$FolderFQN\cfg\installs"
$path = "$InstallsPath\ADK + WinPE (2026-09)"
$AppFolder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
#endregion
#region | Main Logic |
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



#region | Download-Install-Compress WinPE |
<#
  $JobName = 'Download WinPE 2026-09 EXE File'
  $RunningJob = Get-Job | Where-Object -FilterScript {
    $_.Name  -eq $JobName  -and `
    $_.State -eq 'Running'
  }
  if ($null -ne $RunningJob) {
    Get-Job -Name $JobName | Wait-Job
  }

  $JobName = 'Download-Install-Compress WinPE 2026-09'
  $Job = Start-Job -Name $JobName -ArgumentList $ArgumentList -ScriptBlock {
    ${ADK + WinPE Script Folder Path} = $args[0]
    $HT = @{
      AppName = 'WinPE 2026-09'
    }
    #& "$PSScriptRoot\Start\ADK + WinPE\WinPE Download-Install-Compress.ps1" @HT
    & "${ADK + WinPE Script Folder Path}\WinPE Download-Install-Compress.ps1" @HT
  }
  Get-Job -Name $JobName | Wait-Job
#>
#endregion

#region | Default WinPE ISO File |
<#
  $HT = @{
    DefaultImageFolderName = 'Trial-00'
  }
  & "$PSScriptRoot\Start\ADK + WinPE\Default WinPE ISO File.ps1" @HT
#>
#endregion

<# Windows ADK Patches |
  None currently published for Windows ADK 2026-09 but check back periodically. 
  'https://learn.microsoft.com/en-us/windows-hardware/get-started/adk-servicing'
#>



#region | Download, but do not install, DSC Resource Modules |

#endregion

#region | Download, but do not install, Windows PowerShell Modules |
#endregion

#region | Resume authoring the custom InstantAdcsRev5 DSC Resource module | Write build script upon completion. |
#endregion

#region | Windows Assessment and Deployment Kit | Phase 2 |
<#
  
#>
#endregion
