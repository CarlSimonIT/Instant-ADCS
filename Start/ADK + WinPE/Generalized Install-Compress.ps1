#Requires -Version 5.1
#Requires -PSEdition Desktop
#Requires -RunAsAdministrator

param (
  $AppName = 'Windows ADK 2026-09'
)

#region | Groundwork Variables |
<#
  $FolderFQN = Import-CliXml -Path "$PSScriptRoot\..\..\..\.CommonItems\FolderFQN.clixml"
  Write-Verbose -Message "  `$FolderFQN = $FolderFQN"
  $InstallsPath = "$PSScriptRoot\..\..\..\.CommonItems\usb0\$FolderFQN\cfg\installs"
  Write-Verbose -Message "  `$InstallsPath = $InstallsPath"
  $path = "$InstallsPath\ADK + WinPE (2026-09)"
  Write-Verbose -Message "  `$path = $path"
  $folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
  Write-Verbose -Message "  `$folder = $folder"

  $IsZipPresent = Test-Path -Path "$folder\$AppName.zip"
  Write-Verbose -Message "  `$IsZipPresent = $IsZipPresent"
  $IsInstalled = Test-Path -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{4f4f4626-ccb4-41ba-9c62-7ec9b0e113f3}"
  Write-Verbose -Message "  `$IsInstalled = $IsInstalled"

  $layout = "$folder\$AppName Extracted"
  $DownloadArgumentList = @(
    '/quiet'
    '/ceip on'
    '/forcerestart'
    "/layout $([System.Char]39)$layout$([System.Char]39)"
  )

  $InstallerArgumentList = @(
    '/quiet'
    '/ceip on'
    "/installpath $([System.Char]39)${env:ProgramFiles(x86)}\Windows Kits\10$([System.Char]39)"
    '/features OptionId.DeploymentTools'
  )
#>
#endregion

$FolderFQN = Import-CliXml -Path "$PSScriptRoot\..\..\..\.CommonItems\FolderFQN.clixml"
$InstallsPath = "$PSScriptRoot\..\..\..\.CommonItems\usb0\$FolderFQN\cfg\installs"
$path = "$InstallsPath\ADK + WinPE (2026-09)"
$folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
$IsZipPresent = Test-Path -Path "$folder\$AppName.zip"
$IsInstalled = Test-Path -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{4f4f4626-ccb4-41ba-9c62-7ec9b0e113f3}"
$layout = "$folder\$AppName Extracted"
$DownloadArgumentList = @('/quiet','/ceip on','/forcerestart',"/layout '$layout'")
$InstallerArgumentList = @('/quiet','/ceip on',"/installpath '${env:ProgramFiles(x86)}\Windows Kits\10'",'/features OptionId.DeploymentTools')

#region | Zip is NOT present + App is NOT installed --->  Download. Install. Compress. Ensure that uncompressed is deleted. |
<#
  & {
    $WorkingDirectory = "$folder\$AppName Installer"
    Push-Location -Path $WorkingDirectory
    .\adksetup.exe /quiet /ceip on /forcerestart /layout '$layout'
    Pop-Location

    $WorkingDirectory = "$folder\$AppName Extracted"
    Push-Location -Path $WorkingDirectory
    .\adksetup.exe /quiet /ceip on /installpath '${env:ProgramFiles(x86)}\Windows Kits\10' /features 'OptionId.DeploymentTools'
    Pop-Location
  }
#>

${Zip Not Present App Not Installed Here-String} = $(
  "`n"
  "`t`t`t& {`n"
  "`t`t`t  `$WorkingDirectory = $([System.Char]34)$folder\$AppName Installer$([System.Char]34)`n"
  "`t`t`t  Push-Location -Path `$WorkingDirectory`n"
  "`t`t`t  .\adksetup.exe /quiet /ceip on /forcerestart /layout $([System.Char]39)$layout$([System.Char]39)`n"
  "`t`t`t  Pop-Location`n"
  "`t`t`t`n"
  "`t`t`t  `$WorkingDirectory = $([System.Char]34)$folder\$AppName Extracted$([System.Char]34)`n"
  "`t`t`t  Push-Location -Path `$WorkingDirectory`n"
  "`t`t`t  .\adksetup.exe /quiet /ceip on /installpath $([System.Char]39)${env:ProgramFiles(x86)}\Windows Kits\10$([System.Char]39) /features $([System.Char]39)OptionId.DeploymentTools$([System.Char]39)`n"
  "`t`t`t  Pop-Location`n"
  "`t`t`t}`n"
  "`t`t"
) -join ''
${Zip Not Present App Not Installed Script Path} = "$folder\Zip Not Present App Not Installed Script.ps1"
Set-Content -Path ${Zip Not Present App Not Installed Script Path} -Value (${Zip Not Present App Not Installed Here-String})

$ArgumentList = @(
  "Get-Item -Path '${Zip Not Present App Not Installed Script Path}' | Get-Content -Raw | Invoke-Expression"
)
Start-Process -ArgumentList $ArgumentList -FilePath powershell.exe -Wait -Verb 'RunAs'
#endregion


switch ($true) {
  { # Zip is NOT present + App is NOT installed --->  Download. Install. Compress. Ensure that uncompressed is deleted.  |
    (-not $IsZipPresent) -and (-not $IsInstalled)
  } {
    Write-Verbose -Message "    Zip is NOT present + App is NOT installed --->  Download. Install. Compress. Ensure that uncompressed is deleted."
    #region | Download but do not install Windows ADK Installation Files |
    # $WorkingDirectory = "$folder\$AppName Installer"
    # Start-Process -FilePath '.\adksetup.exe' -WorkingDirectory $WorkingDirectory -ArgumentList $DownloadArgumentList -Wait -Verb 'RunAs'
    #endregion
    #region | Install the Windows Assessment and Deployment Kit |
    # $WorkingDirectory = "$folder\$AppName Extracted"
    # Start-Process -FilePath '.\adksetup.exe' -WorkingDirectory $WorkingDirectory -ArgumentList $InstallerArgumentList -Wait -Verb 'RunAs'
    #endregion
    #region | Compress Installation Files to .zip Flie |
    <#
      ${Command Here-String} = $(
        "& {`n"
        "  `$layout = $([System.Char]34)$folder\$AppName Extracted$([System.Char]34)`n"
        "  `$ZipFilePath = $([System.Char]34)$folder\$AppName.zip$([System.Char]34)`n"
        "  Compress-Archive -Path `$layout -DestinationPath `$ZipFilePath`n"
        "}`n"
      ) -join ''
      ${Compression Script Path} = "$folder\$AppName Compress.ps1"
      Set-Content -Path ${Compression Script Path} -Value ${Command Here-String}
      $ArgumentList = @(
        "Get-Item -Path '${Compression Script Path}' | Get-Content -Raw | Invoke-Expression"
      )
      $CompressionJob = Start-Job -JobName "Compression" -ArgumentList $ArgumentList -ScriptBlock {
        $ArgumentList = $args
        Start-Process -ArgumentList $ArgumentList -FilePath powershell.exe -Wait -Verb 'RunAs'
      }
      Get-Job -Name $CompressionJob.Name | Wait-Job
    #>
    #endregion
    #region | Ensure that uncompressed is deleted |
    <#
      $IsExtractedPresent = Test-Path -Path "$folder\$AppName Extracted"
      if ($IsExtractedPresent) {
        ${Command Here-String} = $(
          "& {`n"
          "  `$IsExtractedPresent = Test-Path -Path $([System.Char]34)$folder\$AppName Extracted$([System.Char]34)`n"
          "  if (`$IsExtractedPresent) {`n"
          "    Get-Item -Path $([System.Char]34)$folder\$AppName Extracted$([System.Char]34) | Remove-Item -Force -Recurse`n"
          "  }`n"
          "}`n"
        ) -join ''
        ${Delete Extraction Directory Script Path} = "$folder\$AppName Delete Extraction Directory.ps1"
        Set-Content -Path ${Delete Extraction Directory Script Path} -Value ${Command Here-String}

        Start-Process -ArgumentList @(
          "Get-Item -Path '${Delete Extraction Directory Script Path}' | Get-Content -Raw | Invoke-Expression"
        ) -FilePath powershell.exe -Verb 'RunAs'
      }
    #>
    #endregion
    break
  }
  { # Zip IS present + App is NOT installed     --->  Extract. Install. Ensure that uncompressed is deleted.  |
    ($IsZipPresent) -and (-not $IsInstalled)
  } {
    Write-Verbose -Message "    Zip IS present + App is NOT installed     --->  Extract. Install. Ensure that uncompressed is deleted."
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
    ) -FilePath powershell.exe -Wait -Verb 'RunAs'
    #endregion
    #region | Install the Windows Assessment and Deployment Kit |
    $WorkingDirectory = "$folder\$AppName Extracted"
    Start-Process -FilePath '.\adksetup.exe' -WorkingDirectory $WorkingDirectory -ArgumentList $InstallerArgumentList -Wait -Verb 'RunAs'
    #endregion
    #region | Ensure that uncompressed is deleted |
    $IsExtractedPresent = Test-Path -Path "$folder\$AppName Extracted"
    if ($IsExtractedPresent) {
      ${Command Here-String} = $(
        "& {`n"
        "  `$IsExtractedPresent = Test-Path -Path $([System.Char]34)$folder\$AppName Extracted$([System.Char]34)`n"
        "  if (`$IsExtractedPresent) {`n"
        "    Get-Item -Path $([System.Char]34)$folder\$AppName Extracted$([System.Char]34) | Remove-Item -Force -Recurse`n"
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
    break
  }
  { # Zip is NOT present + App IS installed     --->  Shouldn't happen. Download. Compress. Ensure that uncompressed is deleted.  |
    (-not $IsZipPresent) -and ($IsInstalled)
  } {
    Write-Verbose -Message "    Zip is NOT present + App IS installed     --->  Shouldn't happen. Download. Compress. Ensure that uncompressed is deleted."
    #region | Download but do not install Windows ADK Installation Files |
    $WorkingDirectory = "$folder\$AppName Installer"
    Start-Process -FilePath '.\adksetup.exe' -WorkingDirectory $WorkingDirectory -ArgumentList $DownloadArgumentList -Wait -Verb 'RunAs'
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
    $ArgumentList = @(
      "Get-Item -Path '${Compression Script Path}' | Get-Content -Raw | Invoke-Expression"
    )
    $CompressionJob = Start-Job -JobName "Compression" -ArgumentList $ArgumentList -ScriptBlock {
      $ArgumentList = $args
      Start-Process -ArgumentList $ArgumentList -FilePath powershell.exe -Wait -Verb 'RunAs'
    }
    Get-Job -Name $CompressionJob.Name | Wait-Job
    #endregion
    #region | Ensure that uncompressed is deleted |
    $IsExtractedPresent = Test-Path -Path "$folder\$AppName Extracted"
    if ($IsExtractedPresent) {
      ${Command Here-String} = $(
        "& {`n"
        "  `$IsExtractedPresent = Test-Path -Path $([System.Char]34)$folder\$AppName Extracted$([System.Char]34)`n"
        "  if (`$IsExtractedPresent) {`n"
        "    Get-Item -Path $([System.Char]34)$folder\$AppName Extracted$([System.Char]34) | Remove-Item -Force -Recurse`n"
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
    break
  }
  { # Zip IS present + App IS installed         --->  Ensure that uncompressed is deleted.  |
    ($IsZipPresent) -and ($IsInstalled)
  } {
    Write-Verbose -Message "    Zip IS present + App IS installed         --->  Ensure that uncompressed is deleted."
    #region | Ensure that uncompressed is deleted |
    $IsExtractedPresent = Test-Path -Path "$folder\$AppName Extracted"
    if ($IsExtractedPresent) {
      ${Command Here-String} = $(
        "& {`n"
        "  `$IsExtractedPresent = Test-Path -Path $([System.Char]34)$folder\$AppName Extracted$([System.Char]34)`n"
        "  if (`$IsExtractedPresent) {`n"
        "    Get-Item -Path $([System.Char]34)$folder\$AppName Extracted$([System.Char]34) | Remove-Item -Force -Recurse`n"
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
    break
  }
}

<#
  if (-not $IsZipPresent) {
    #region | Download but do not install Windows ADK Installation Files |
    $WorkingDirectory = "$folder\$AppName Installer"
    Start-Process -FilePath '.\adksetup.exe' -WorkingDirectory $WorkingDirectory -ArgumentList $DownloadArgumentList -Wait -Verb 'RunAs'
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
    ) -FilePath powershell.exe -Wait -Verb 'RunAs'
    #endregion
    #region | Delete the recently-downloaded files |
    #    ${Command Here-String} = $(
    #      "& {`n"
    #      "  Get-Item -Path $([System.Char]34)$folder\$AppName Extracted$([System.Char]34) | Remove-Item -Force -Recurse`n"
    #      "}`n"
    #    ) -join ''
    #    ${Delete Extraction Directory Script Path} = "$folder\$AppName Delete Extraction Directory.ps1"
    #    Set-Content -Path ${Delete Extraction Directory Script Path} -Value ${Command Here-String}
    #
    #    Start-Process -ArgumentList @(
    #      "Get-Item -Path '${Delete Extraction Directory Script Path}' | Get-Content -Raw | Invoke-Expression"
    #    ) -FilePath powershell.exe -Wait -Verb 'RunAs'
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
      ) -FilePath powershell.exe -Wait -Verb 'RunAs'
      #endregion
  }

  if (-not $IsInstalled) {
      #region | Install the Windows Assessment and Deployment Kit |
      $WorkingDirectory = "$folder\$AppName Extracted"
      $ArgumentList = @(
        '/quiet'
        '/ceip on'
        "/installpath $([System.Char]34)${env:ProgramFiles(x86)}\Windows Kits\10$([System.Char]34)"
        '/features OptionId.DeploymentTools'
      )
      Start-Process -ArgumentList $ArgumentList -FilePath '.\adksetup.exe' -WorkingDirectory $WorkingDirectory -Wait -Verb 'RunAs'
      #endregion
  }
#>




<#
  start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/get-started/adk-install#install-the-adk'
  start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/get-started/adk-offline-install'
  start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/get-started/adk-offline-install#using-the-command-line'

  adksetup.exe cli syntax: 
  start msedge.exe 'https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-8.1-and-8/dn621910(v=win.10)'
#>


<# Windows ADK Installation Options |
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

