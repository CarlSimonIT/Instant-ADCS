#Requires -Version 5.1
#Requires -PSEdition Desktop

<#
  start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/get-started/adk-install#install-the-adk'
  start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/get-started/adk-offline-install'
  start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/get-started/adk-offline-install#using-the-command-line'

  adksetup.exe cli syntax: 
  start msedge.exe 'https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-8.1-and-8/dn621910(v=win.10)'
#>

$AppName = 'Windows ADK 2026-09'
$FolderFQN = Import-CliXml -Path "$env:UserProfile\GitHub\CarlSimonIT\.CommonItems\FolderFQN.clixml"
$InstallsPath = "$env:UserProfile\GitHub\CarlSimonIT\.CommonItems\usb0\$FolderFQN\cfg\installs"

<#
  $FolderFQN = Import-CliXml -Path "$env:UserProfile\GitHub\CarlSimonIT\.CommonItems\FolderFQN.clixml"
  $path = "$env:UserProfile\GitHub\CarlSimonIT\$FolderFQN\Start\Assessment and Deployment Kit Scripting Dev.ps1"
  $file = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'File' -Force}
  code $file.FullName
#>

$IsZipPresent = Test-Path -Path "$InstallsPath\$AppName.zip"
if (-not $IsZipPresent) {
  #region | Download but do not install Windows ADK Installation Files |
  $WorkingDirectory = "$InstallsPath\$AppName Installer"
  $layout = "$InstallsPath\$AppName Extracted"
  $ArgumentList = @(
    '/quiet'
    '/ceip on'
    '/forcerestart'
    "/layout $([System.Char]34)$layout$([System.Char]34)"
  )
  Start-Process -FilePath '.\adksetup.exe' -WorkingDirectory $WorkingDirectory -ArgumentList $ArgumentList -Verb 'RunAs' -Wait
  #endregion
  #region | Compress Installation Files to .zip Flie |
  ${Command Here-String} = $(
    "& {`n"
    "  `$AppName = $([System.Char]39)Windows ADK 2026-09$([System.Char]39)`n"
    "  `$FolderFQN = Import-CliXml -Path $([System.Char]34)`$env:UserProfile\GitHub\CarlSimonIT\.CommonItems\FolderFQN.clixml$([System.Char]34)`n"
    "  `$layout = $([System.Char]34)`$env:UserProfile\GitHub\CarlSimonIT\.CommonItems\usb0\`$FolderFQN\cfg\installs\`$AppName Extracted$([System.Char]34)`n"
    "  `$ZipFilePath = $([System.Char]34)`$env:UserProfile\GitHub\CarlSimonIT\.CommonItems\usb0\`$FolderFQN\cfg\installs\`$AppName.zip$([System.Char]34)`n"
    "  Compress-Archive -Path `$layout -DestinationPath `$ZipFilePath`n"
    "}`n"
  ) -join ''
  ${Compression Script Path} = "$InstallsPath\$AppName Compress.ps1"
  Set-Content -Path ${Compression Script Path} -Value ${Command Here-String}

  Start-Process -ArgumentList @(
    "Get-Item -Path '${Compression Script Path}' | Get-Content -Raw | Invoke-Expression"
  ) -FilePath powershell.exe -Verb 'RunAs' -Wait
  #endregion
  #region | Delete the recently-downloaded files |
  ${Command Here-String} = $(
    "& {`n"
    "  `Get-Item -Path $([System.Char]34)$InstallsPath\$AppName Extracted$([System.Char]34) | Remove-Item -Force -Recurse`n"
    "}`n"
  ) -join ''
  ${Delete Extraction Directory Script Path} = "$InstallsPath\$AppName Delete Extraction Directory.ps1"
  Set-Content -Path ${Delete Extraction Directory Script Path} -Value ${Command Here-String}

  Start-Process -ArgumentList @(
    "Get-Item -Path '${Delete Extraction Directory Script Path}' | Get-Content -Raw | Invoke-Expression"
  ) -FilePath powershell.exe -Verb 'RunAs' -Wait
  #endregion
} else {
  #region | Extract the local .zip file |
  ${Command Here-String} = $(
    "& {`n"
    "  `$ZipFilePath = $([System.Char]34)$InstallsPath\$AppName.zip$([System.Char]34)`n"
    "  `$DestinationPath = ([System.IO.FileInfo]`$ZipFilePath).DirectoryName`n"
    "  Expand-Archive -Path `$ZipFilePath -DestinationPath `$DestinationPath`n"
    "}`n"
  ) -join ''
  ${Expansion Script Path} = "$InstallsPath\$AppName Expand.ps1"
  Set-Content -Path ${Expansion Script Path} -Value ${Command Here-String}

  Start-Process -ArgumentList @(
    "Get-Item -Path '${Expansion Script Path}' | Get-Content -Raw | Invoke-Expression"
  ) -FilePath powershell.exe -Verb 'RunAs' -Wait
  #endregion
}

$IsInstalled = Test-Path -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{4f4f4626-ccb4-41ba-9c62-7ec9b0e113f3}"
if (-not $IsInstalled) {
  #region | Install the Windows Assessment and Deployment Kit |
  <# Installation Options |
    OptionId.ApplicationCompatibilityToolkit
    OptionId.DeploymentTools
    OptionId.ImagingAndConfigurationDesigner
    OptionId.ICDConfigurationDesigner
    OptionId.UserStateMigrationTool
    OptionId.VolumeActivationManagementTool
    OptionId.WindowsPerformanceToolkit
    OptionId.WindowsAssessmentToolkit
    OptionId.UEVTools
    OptionId.AppmanSequencer
    OptionId.AppmanAutoSequencer
    OptionId.MediaeXperienceAnalyzer
    OptionId.SupplyChainTrustTools
  #>
  $ArgumentList = @(
    '/quiet'
    '/ceip on'
    "/installpath $([System.Char]34)${env:ProgramFiles(x86)}\Windows Kits\10$([System.Char]34)"
    '/features OptionId.DeploymentTools'
  )
  $WorkingDirectory = "$InstallsPath\$AppName Extracted"
  Start-Process -ArgumentList @(
    '/quiet'
    '/ceip on'
    "/installpath $([System.Char]34)${env:ProgramFiles(x86)}\Windows Kits\10$([System.Char]34)"
    '/features OptionId.DeploymentTools'
  ) -FilePath '.\adksetup.exe' -WorkingDirectory $WorkingDirectory -Verb 'RunAs' -Wait
  #endregion
  #region | Delete the recently-extracted files |
  ${Command Here-String} = $(
    "& {`n"
    "  `Get-Item -Path $([System.Char]34)$InstallsPath\$AppName Extracted$([System.Char]34) | Remove-Item -Force -Recurse`n"
    "}`n"
  ) -join ''
  ${Delete Extraction Directory Script Path} = "$InstallsPath\$AppName Delete Extraction Directory.ps1"
  Set-Content -Path ${Delete Extraction Directory Script Path} -Value ${Command Here-String}

  Start-Process -ArgumentList @(
    "Get-Item -Path '${Delete Extraction Directory Script Path}' | Get-Content -Raw | Invoke-Expression"
  ) -FilePath powershell.exe -Verb 'RunAs' -Wait
  #endregion
}

 
<#
  . "$env:UserProfile\GitHub\CarlSimonIT\$FolderFQN\output\$FolderFQN\usb1\$FolderFQN\Base\5.1\External Storage Media Drive Letters.ps1"
  "$usb0"
#>
