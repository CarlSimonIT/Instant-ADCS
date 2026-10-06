#Requires -Version 5.1
#Requires -PSEdition Desktop

param (
  $AppName
)

$FolderFQN = Import-CliXml -Path "$PSScriptRoot\..\..\..\.CommonItems\FolderFQN.clixml"
$InstallsPath = "$PSScriptRoot\..\..\..\.CommonItems\usb0\$FolderFQN\cfg\installs"

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
  <#
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
  #>
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

<# WinPE Add-on Installation Options |
  OptionId.WindowsPreinstallationEnvironment
#>

$IsInstalled = Test-Path -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{f567a246-97ac-4217-a1ba-020ced2a8187}"
if (-not $IsInstalled) {
  #region | Install the WinPE Add-ons |
  $WorkingDirectory = "$InstallsPath\$AppName Extracted"
  Start-Process -ArgumentList @(
    '/quiet'
    '/ceip on'
    "/installpath $([System.Char]34)${env:ProgramFiles(x86)}\Windows Kits\10$([System.Char]34)"
    '/features OptionId.WindowsPreinstallationEnvironment'
  ) -FilePath '.\adkwinpesetup.exe' -WorkingDirectory $WorkingDirectory -Verb 'RunAs' -Wait
  #endregion
}

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
