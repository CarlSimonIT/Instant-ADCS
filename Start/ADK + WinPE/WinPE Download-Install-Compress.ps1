#Requires -Version 5.1
#Requires -PSEdition Desktop

param (
  $AppName
)

<#
  start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/winpe-create-usb-bootable-drive?view=windows-11'
  # Boot To WinPE
  start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/boot-to-winpe?view=windows-11'
  # Deployment Tools Reference for WinPE
  start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/winpe-intro?view=windows-11'
  # Create bootable WinPE Media
  start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/winpe-create-usb-bootable-drive?view=windows-11'

  start msedge.exe ''
#>

$FolderFQN = Import-CliXml -Path "$PSScriptRoot\..\..\..\.CommonItems\FolderFQN.clixml"
$InstallsPath = Import-CliXml -Path "$PSScriptRoot\..\..\..\.CommonItems\usb0\$FolderFQN\cfg\installs"


<#
  $FolderFQN = Import-CliXml -Path "$env:UserProfile\GitHub\CarlSimonIT\.CommonItems\FolderFQN.clixml"
  $path = "$env:UserProfile\GitHub\CarlSimonIT\$FolderFQN\Start\WinPE Scripting Dev.ps1"
  $file = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'File' -Force}
  code $file.FullName
#>

$IsZipPresent = Test-Path -Path "$InstallsPath\$AppName.zip"
if (-not $IsZipPresent) {
  #region | Download but do not install WinPE Installation Files |
  $WorkingDirectory = "$InstallsPath\$AppName Installer"
  $layout = "$InstallsPath\$AppName Extracted"
  Start-Process -ArgumentList @(
    '/quiet'
    '/ceip on'
    '/forcerestart'
    "/layout $([System.Char]34)$layout$([System.Char]34)"
  ) -FilePath '.\adkwinpesetup.exe' -WorkingDirectory $WorkingDirectory -Verb 'RunAs' -Wait
  #endregion
  #region | Compress Installation Files to .zip Flie |
  ${Command Here-String} = $(
    "& {`n"
    "  `$layout = $([System.Char]34)$InstallsPath\$AppName Extracted$([System.Char]34)`n"
    "  `$ZipFilePath = $([System.Char]34)$InstallsPath\$AppName.zip$([System.Char]34)`n"
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

$IsInstalled = Test-Path -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{f567a246-97ac-4217-a1ba-020ced2a8187}"
if (-not $IsInstalled) {
  #region | Install the WinPE Add-ons |
  <# WinPE Add-on Installation Options |
    OptionId.WindowsPreinstallationEnvironment
  #>
  $WorkingDirectory = "$InstallsPath\$AppName Extracted"
  Start-Process -ArgumentList @(
    '/quiet'
    '/ceip on'
    "/installpath $([System.Char]34)${env:ProgramFiles(x86)}\Windows Kits\10$([System.Char]34)"
    '/features OptionId.WindowsPreinstallationEnvironment'
  ) -FilePath '.\adkwinpesetup.exe' -WorkingDirectory $WorkingDirectory -Verb 'RunAs' -Wait
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
