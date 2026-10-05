#Requires -Version 5.1
#Requires -PSEdition Desktop

<#
  start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/get-started/adk-install#install-the-adk'
  start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/get-started/adk-offline-install'
  start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/get-started/adk-offline-install#using-the-command-line'

  adksetup.exe cli syntax: 
  start msedge.exe 'https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-8.1-and-8/dn621910(v=win.10)'
#>

$FolderFQN = Import-CliXml -Path "$env:UserProfile\GitHub\CarlSimonIT\.CommonItems\FolderFQN.clixml"
$path = "$env:UserProfile\GitHub\CarlSimonIT\$FolderFQN\Start\Assessment and Deployment Kit Scripting Dev.ps1"
<#
  $file = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'File' -Force}
  code $file.FullName
#>


$FolderFQN = Import-CliXml -Path "$env:UserProfile\GitHub\CarlSimonIT\.CommonItems\FolderFQN.clixml"
$WorkingDirectory = "$env:UserProfile\GitHub\CarlSimonIT\.CommonItems\usb0\$FolderFQN\cfg\installs\Windows ADK 2026-09 Installer"
$layout = "$env:UserProfile\GitHub\CarlSimonIT\.CommonItems\usb0\$FolderFQN\cfg\installs\Windows ADK 2026-09 Extracted"
$ArgumentList = @(
  '/quiet'
  '/ceip on'
  '/forcerestart'
  "/layout $([System.Char]34)$layout$([System.Char]34)"
)
Start-Process -FilePath '.\adksetup.exe' -WorkingDirectory $WorkingDirectory -ArgumentList $ArgumentList -Verb 'RunAs'


<# Windows Assessment and Deployment Kit |
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

$FolderFQN = Import-CliXml -Path "$env:UserProfile\GitHub\CarlSimonIT\.CommonItems\FolderFQN.clixml"
$WorkingDirectory = "$env:UserProfile\GitHub\CarlSimonIT\.CommonItems\usb0\$FolderFQN\cfg\installs\Windows ADK 2026-09 Installer"
$ArgumentList = @(
  '/quiet'
  '/ceip on'
  "/installpath $([System.Char]34)$env:ProgramFiles$([System.Char]34)"
  '/features OptionId.DeploymentTools'
)
Start-Process -FilePath '.\adksetup.exe' -WorkingDirectory $WorkingDirectory -ArgumentList $ArgumentList -Verb 'RunAs'





. "$env:UserProfile\GitHub\CarlSimonIT\$FolderFQN\output\$FolderFQN\usb1\$FolderFQN\Base\5.1\External Storage Media Drive Letters.ps1"
"$usb0"

<#
  start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/winpe-create-usb-bootable-drive?view=windows-11'
  # Boot To WinPE
  start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/boot-to-winpe?view=windows-11'
  start msedge.exe ''
  start msedge.exe ''
  start msedge.exe ''
  start msedge.exe ''
  # Deployment Tools Reference for WinPE
  start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/winpe-intro?view=windows-11'
#>


<#


#>


