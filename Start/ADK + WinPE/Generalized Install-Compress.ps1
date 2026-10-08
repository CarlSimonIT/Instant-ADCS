#Requires -Version 5.1
#Requires -PSEdition Desktop
#R3quires -RunAsAdministrator

param (
  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  $AppName,

  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  $UninstallGuid,

  [Parameter(
    Mandatory = $true
  )]
  [System.String[]]
  $InstallerArgumentList
)

#region | Groundwork Variables |
$FolderFQN = Import-CliXml -Path "$PSScriptRoot\..\..\..\.CommonItems\FolderFQN.clixml"
$InstallsPath = "$PSScriptRoot\..\..\..\.CommonItems\usb0\$FolderFQN\cfg\installs"
$path = "$InstallsPath\ADK + WinPE (2026-09)"
$AppFolder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}

$IsZipPresent = Test-Path -Path "$AppFolder\$AppName.zip"
$IsInstalled = Test-Path -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\{$UninstallGuid}"
#endregion

#region | Main Logic |
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
#endregion
