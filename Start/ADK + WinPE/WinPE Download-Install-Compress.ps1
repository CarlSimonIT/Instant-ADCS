#Requires -Version 5.1
#Requires -PSEdition Desktop

param (
  $AppName
)

$FolderFQN = Import-CliXml -Path "$PSScriptRoot\..\..\..\.CommonItems\FolderFQN.clixml"
$InstallsPath = "$PSScriptRoot\..\..\..\.CommonItems\usb0\$FolderFQN\cfg\installs"
$path = "$InstallsPath\ADK + WinPE (2026-09)"
$folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}

$IsZipPresent = Test-Path -Path "$folder\$AppName.zip"
$IsInstalled = Test-Path -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{f567a246-97ac-4217-a1ba-020ced2a8187}"

switch ($true) {
  { # Zip is NOT present + App is NOT installed --->  Download. Install. Ensure that uncompressed is deleted.  |
    (-not $IsZipPresent) -and (-not $IsInstalled)
  } {
    #region | Download but do not install WinPE Installation Files |
    $WorkingDirectory = "$folder\$AppName Installer"
    $layout = "$folder\$AppName Extracted"
    $ArgumentList = @(
      '/quiet'
      '/ceip on'
      '/forcerestart'
      "/layout $([System.Char]34)$layout$([System.Char]34)"
    )
    Start-Process -ArgumentList $ArgumentList -FilePath '.\adkwinpesetup.exe' -WorkingDirectory $WorkingDirectory -Verb 'RunAs' -Wait
    #endregion
    #region | Compress Installation Files to .zip Flie |
    ${Command Here-String} = $(
      "& {`n"
      "  `$layout = $([System.Char]34)$InstallsPath\$AppName Extracted$([System.Char]34)`n"
      "  `$ZipFilePath = $([System.Char]34)$InstallsPath\$AppName.zip$([System.Char]34)`n"
      "  Compress-Archive -Path `$layout -DestinationPath `$ZipFilePath`n"
      "}`n"
    ) -join ''
    ${Compression Script Path} = "$folder\$AppName Compress.ps1"
    Set-Content -Path ${Compression Script Path} -Value ${Command Here-String}

    Start-Process -ArgumentList @(
      "Get-Item -Path '${Compression Script Path}' | Get-Content -Raw | Invoke-Expression"
    ) -FilePath powershell.exe -Verb 'RunAs' -Wait
    #endregion
    #region | Install the WinPE Add-ons to the Windows ADK |
    $WorkingDirectory = "$folder\$AppName Extracted"
    $ArgumentList = @(
      '/quiet'
      '/ceip on'
      "/installpath $([System.Char]34)${env:ProgramFiles(x86)}\Windows Kits\10$([System.Char]34)"
      '/features OptionId.WindowsPreinstallationEnvironment'code 
    )
    Start-Process -ArgumentList $ArgumentList -FilePath '.\adkwinpesetup.exe' -WorkingDirectory $WorkingDirectory -Verb 'RunAs' -Wait
    #endregion
    #region | Ensure that uncompressed is deleted |
    $IsExtractedPresent = Test-Path -Path "$folder\$AppName Extracted"
    if ($IsExtractedPresent) {
      ${Command Here-String} = $(
        "& {`n"
        "  `$IsExtractedPresent = Test-Path -Path $([System.Char]34)`$InstallsPath\`$AppName Extracted$([System.Char]34)`n"
        "  if (`$IsExtractedPresent) {`n"
        "    Get-Item -Path $([System.Char]34)`$InstallsPath\`$AppName Extracted$([System.Char]34) | Remove-Item -Force -Recurse`n"
        "  }`n"
        "}`n"
      ) -join ''
      ${Delete Extraction Directory Script Path} = "$folder\$AppName Delete Extraction Directory.ps1"
      Set-Content -Path ${Delete Extraction Directory Script Path} -Value ${Command Here-String}

      Start-Process -ArgumentList @(
        "Get-Item -Path '${Delete Extraction Directory Script Path}' | Get-Content -Raw | Invoke-Expression"
      ) -FilePath powershell.exe -Verb 'RunAs'
    }
    #endregion
  }
  { # Zip IS present + App is NOT installed     --->  Extract. Install. Ensure that uncompressed is deleted.  |
    ($IsZipPresent) -and (-not $IsInstalled)
  } {
    #region | Extract the local .zip file |
    ${Command Here-String} = $(
      "& {`n"
      "  `$ZipFilePath = $([System.Char]34)$InstallsPath\$AppName.zip$([System.Char]34)`n"
      "  `$DestinationPath = ([System.IO.FileInfo]`$ZipFilePath).DirectoryName`n"
      "  Expand-Archive -Path `$ZipFilePath -DestinationPath `$DestinationPath`n"
      "}`n"
    ) -join ''
    ${Expansion Script Path} = "$folder\$AppName Expand.ps1"
    Set-Content -Path ${Expansion Script Path} -Value ${Command Here-String}

    Start-Process -ArgumentList @(
      "Get-Item -Path '${Expansion Script Path}' | Get-Content -Raw | Invoke-Expression"
    ) -FilePath powershell.exe -Verb 'RunAs' -Wait
    #endregion
    #region | Install the WinPE Add-ons to the Windows ADK |
    $WorkingDirectory = "$folder\$AppName Extracted"
    $ArgumentList = @(
      '/quiet'
      '/ceip on'
      "/installpath $([System.Char]34)${env:ProgramFiles(x86)}\Windows Kits\10$([System.Char]34)"
      '/features OptionId.WindowsPreinstallationEnvironment'
    )
    Start-Process -ArgumentList $ArgumentList -FilePath '.\adkwinpesetup.exe' -WorkingDirectory $WorkingDirectory -Verb 'RunAs' -Wait
    #endregion
    #region | Ensure that uncompressed is deleted |
    $IsExtractedPresent = Test-Path -Path "$folder\$AppName Extracted"
    if ($IsExtractedPresent) {
      ${Command Here-String} = $(
        "& {`n"
        "  `$IsExtractedPresent = Test-Path -Path $([System.Char]34)`$InstallsPath\`$AppName Extracted$([System.Char]34)`n"
        "  if (`$IsExtractedPresent) {`n"
        "    Get-Item -Path $([System.Char]34)`$InstallsPath\`$AppName Extracted$([System.Char]34) | Remove-Item -Force -Recurse`n"
        "  }`n"
        "}`n"
      ) -join ''
      ${Delete Extraction Directory Script Path} = "$folder\$AppName Delete Extraction Directory.ps1"
      Set-Content -Path ${Delete Extraction Directory Script Path} -Value ${Command Here-String}

      Start-Process -ArgumentList @(
        "Get-Item -Path '${Delete Extraction Directory Script Path}' | Get-Content -Raw | Invoke-Expression"
      ) -FilePath powershell.exe -Verb 'RunAs'
    }
    #endregion
  }
  { # Zip is NOT present + App IS installed     --->  Shouldn't happen. Download. Compress. Ensure that uncompressed is deleted.  |
    (-not $IsZipPresent) -and ($IsInstalled)
  } {
    #region | Download but do not install WinPE Installation Files |
    $WorkingDirectory = "$folder\$AppName Installer"
    $layout = "$folder\$AppName Extracted"
    $ArgumentList = @(
      '/quiet'
      '/ceip on'
      '/forcerestart'
      "/layout $([System.Char]34)$layout$([System.Char]34)"
    )
    Start-Process -ArgumentList $ArgumentList -FilePath '.\adkwinpesetup.exe' -WorkingDirectory $WorkingDirectory -Verb 'RunAs' -Wait
    #endregion
    #region | Compress Installation Files to .zip Flie |
    ${Command Here-String} = $(
      "& {`n"
      "  `$layout = $([System.Char]34)$InstallsPath\$AppName Extracted$([System.Char]34)`n"
      "  `$ZipFilePath = $([System.Char]34)$InstallsPath\$AppName.zip$([System.Char]34)`n"
      "  Compress-Archive -Path `$layout -DestinationPath `$ZipFilePath`n"
      "}`n"
    ) -join ''
    ${Compression Script Path} = "$folder\$AppName Compress.ps1"
    Set-Content -Path ${Compression Script Path} -Value ${Command Here-String}

    Start-Process -ArgumentList @(
      "Get-Item -Path '${Compression Script Path}' | Get-Content -Raw | Invoke-Expression"
    ) -FilePath powershell.exe -Verb 'RunAs' -Wait
    #endregion
    #region | Ensure that uncompressed is deleted |
    $IsExtractedPresent = Test-Path -Path "$folder\$AppName Extracted"
    if ($IsExtractedPresent) {
      ${Command Here-String} = $(
        "& {`n"
        "  `$IsExtractedPresent = Test-Path -Path $([System.Char]34)`$InstallsPath\`$AppName Extracted$([System.Char]34)`n"
        "  if (`$IsExtractedPresent) {`n"
        "    Get-Item -Path $([System.Char]34)`$InstallsPath\`$AppName Extracted$([System.Char]34) | Remove-Item -Force -Recurse`n"
        "  }`n"
        "}`n"
      ) -join ''
      ${Delete Extraction Directory Script Path} = "$folder\$AppName Delete Extraction Directory.ps1"
      Set-Content -Path ${Delete Extraction Directory Script Path} -Value ${Command Here-String}

      Start-Process -ArgumentList @(
        "Get-Item -Path '${Delete Extraction Directory Script Path}' | Get-Content -Raw | Invoke-Expression"
      ) -FilePath powershell.exe -Verb 'RunAs'
    }
    #endregion
  }
  { # Zip IS present + App IS installed         --->  Ensure that uncompressed is deleted.  |
    ($IsZipPresent) -and ($IsInstalled)
  } {
    #region | Ensure that uncompressed is deleted |
    $IsExtractedPresent = Test-Path -Path "$folder\$AppName Extracted"
    if ($IsExtractedPresent) {
      ${Command Here-String} = $(
        "& {`n"
        "  `$IsExtractedPresent = Test-Path -Path $([System.Char]34)`$InstallsPath\`$AppName Extracted$([System.Char]34)`n"
        "  if (`$IsExtractedPresent) {`n"
        "    Get-Item -Path $([System.Char]34)`$InstallsPath\`$AppName Extracted$([System.Char]34) | Remove-Item -Force -Recurse`n"
        "  }`n"
        "}`n"
      ) -join ''
      ${Delete Extraction Directory Script Path} = "$folder\$AppName Delete Extraction Directory.ps1"
      Set-Content -Path ${Delete Extraction Directory Script Path} -Value ${Command Here-String}

      Start-Process -ArgumentList @(
        "Get-Item -Path '${Delete Extraction Directory Script Path}' | Get-Content -Raw | Invoke-Expression"
      ) -FilePath powershell.exe -Verb 'RunAs'
    }
    #endregion
  }
}


<#
  if (-not $IsZipPresent) {
    #region | Download but do not install WinPE Installation Files |
    $WorkingDirectory = "$folder\$AppName Installer"
    $layout = "$folder\$AppName Extracted"
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
      "  `$layout = $([System.Char]34)$folder\$AppName Extracted$([System.Char]34)`n"
      "  `$ZipFilePath = $([System.Char]34)$folder\$AppName.zip$([System.Char]34)`n"
      "  Compress-Archive -Path `$layout -DestinationPath `$ZipFilePath`n"
      "}`n"
    ) -join ''
    ${Compression Script Path} = "$folder\$AppName Compress.ps1"
    Set-Content -Path ${Compression Script Path} -Value ${Command Here-String}

    Start-Process -ArgumentList @(
      "Get-Item -Path '${Compression Script Path}' | Get-Content -Raw | Invoke-Expression"
    ) -FilePath powershell.exe -Verb 'RunAs' -Wait
    #endregion
    #region | Delete the recently-downloaded files |
    #    ${Command Here-String} = $(
    #      "& {`n"
    #      "  `Get-Item -Path $([System.Char]34)$folder\$AppName Extracted$([System.Char]34) | Remove-Item -Force -Recurse`n"
    #      "}`n"
    #    ) -join ''
    #    ${Delete Extraction Directory Script Path} = "$folder\$AppName Delete Extraction Directory.ps1"
    #    Set-Content -Path ${Delete Extraction Directory Script Path} -Value ${Command Here-String}
    #
    #    Start-Process -ArgumentList @(
    #      "Get-Item -Path '${Delete Extraction Directory Script Path}' | Get-Content -Raw | Invoke-Expression"
    #    ) -FilePath powershell.exe -Verb 'RunAs' -Wait
    #endregion
  } else {
    #region | Extract the local .zip file |
    ${Command Here-String} = $(
      "& {`n"
      "  `$ZipFilePath = $([System.Char]34)$folder\$AppName.zip$([System.Char]34)`n"
      "  `$DestinationPath = ([System.IO.FileInfo]`$ZipFilePath).DirectoryName`n"
      "  Expand-Archive -Path `$ZipFilePath -DestinationPath `$DestinationPath`n"
      "}`n"
    ) -join ''
    ${Expansion Script Path} = "$folder\$AppName Expand.ps1"
    Set-Content -Path ${Expansion Script Path} -Value ${Command Here-String}

    Start-Process -ArgumentList @(
      "Get-Item -Path '${Expansion Script Path}' | Get-Content -Raw | Invoke-Expression"
    ) -FilePath powershell.exe -Verb 'RunAs' -Wait
    #endregion
  }
#>


<# WinPE Add-on Installation Options |
  OptionId.WindowsPreinstallationEnvironment
#>

<#
  if (-not $IsInstalled) {
    #region | Install the WinPE Add-ons |
    $WorkingDirectory = "$folder\$AppName Extracted"
    $ArgumentList = @(
      '/quiet'
      '/ceip on'
      "/installpath $([System.Char]34)${env:ProgramFiles(x86)}\Windows Kits\10$([System.Char]34)"
      '/features OptionId.WindowsPreinstallationEnvironment'
    )
    Start-Process -ArgumentList $ArgumentList -FilePath '.\adkwinpesetup.exe' -WorkingDirectory $WorkingDirectory -Verb 'RunAs' -Wait
    #endregion
  }

  #region | Delete the recently-extracted files |
  ${Command Here-String} = $(
    "& {`n"
    "  `Get-Item -Path $([System.Char]34)$folder\$AppName Extracted$([System.Char]34) | Remove-Item -Force -Recurse`n"
    "}`n"
  ) -join ''
  ${Delete Extraction Directory Script Path} = "$folder\$AppName Delete Extraction Directory.ps1"
  Set-Content -Path ${Delete Extraction Directory Script Path} -Value ${Command Here-String}

  Start-Process -ArgumentList @(
    "Get-Item -Path '${Delete Extraction Directory Script Path}' | Get-Content -Raw | Invoke-Expression"
  ) -FilePath powershell.exe -Verb 'RunAs' -Wait
  #endregion
#>



#region | Define folder in root of %UserProfile% for preparing the WinPE image that will be booted on bare metal and used to deploy Windows Server |
${explorer.exe Owner} = Import-CliXml -Path "$PSScriptRoot\..\..\..\.CommonItems\explorer.exe Owner.clixml"

${WinPE Image Creation Parent Path} = "$env:SystemDrive\Users\${explorer.exe Owner}\WinPE"
$folder = try {
  Get-Item -Path ${WinPE Image Creation Parent Path} -ErrorAction 'Stop'
} catch {
  New-Item -Path ${WinPE Image Creation Parent Path} -ItemType 'Directory' -Force
}
#endregion