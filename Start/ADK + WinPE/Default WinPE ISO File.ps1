#Requires -Version 5.1
#Requires -PSEdition Desktop

param (
  ${WinPE Workspace Folder Name}
)

${explorer.exe Owner} = Import-CliXml -Path "$PSScriptRoot\..\..\..\.CommonItems\explorer.exe Owner.clixml"
${WinPE Image Creation Parent Path} = "$env:SystemDrive\Users\${explorer.exe Owner}\WinPE"
$folder = try {Get-Item -Path ${WinPE Image Creation Parent Path} -ErrorAction 'Stop'} catch {New-Item -Path ${WinPE Image Creation Parent Path} -ItemType 'Directory' -Force}

#region | Default WinPE ISO File |
<#
  ${WinPE Workspace Folder Name} = 'Trial-00'
  ${explorer.exe Owner} = Import-CliXml -Path "${env:.CommonItems}\explorer.exe Owner.clixml"
#>

${Duplicate Uncompressed WinPE Files Here-String Precursor} = $(
  "`${WinPE Image Creation Parent Path} = $([System.Char]34)`$env:SystemDrive\Users\%_explorer_owner_%\WinPE$([System.Char]34)`n"
  "`$folder = try {`n"
  "  Get-Item -Path `${WinPE Image Creation Parent Path} -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
  "} catch {`n"
  "  New-Item -Path `${WinPE Image Creation Parent Path} -ItemType $([System.Char]39)Directory$([System.Char]39) -Force`n"
  "}`n"

  "`${WinPE x64 Tools Path} = $([System.Char]34)`${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64$([System.Char]34)`n"
  "`${WinPE Default Image Creation Path} = $([System.Char]34)`${WinPE Image Creation Parent Path}\%_WinPE Workspace Folder Name_%$([System.Char]34)`n"
  "`${WinPE Default ISO Folder Path} = $([System.Char]34)`${WinPE Default Image Creation Path}\.Default ISO$([System.Char]34)`n"
  "copype.cmd .\amd64\ `${WinPE Default ISO Folder Path}`n"
) -join ''
${Duplicate Uncompressed WinPE Files Here-String} = ${Duplicate Uncompressed WinPE Files Here-String Precursor} `
  -replace '%_WinPE Workspace Folder Name_%',${WinPE Workspace Folder Name} `
  -replace '%_explorer_owner_%',${explorer.exe Owner}

Set-Content -Path "${WinPE Image Creation Parent Path}\Duplicate Uncompressed WinPE Files Script.ps1" -Value (${Duplicate Uncompressed WinPE Files Here-String})
$WorkingDirectory = "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools"

$IsPresent = Test-Path -Path "${WinPE Image Creation Parent Path}\${WinPE Workspace Folder Name}\.Default ISO"
if (-not $IsPresent) {
  Start-Process -FilePath cmd.exe -ArgumentList @(
    #"/c $([System.Char]34)$WorkingDirectory\DandISetEnv.bat$([System.Char]34) && powershell.exe -NoProfile -ExecutionPolicy 'RemoteSigned'; Invoke-Expression -Command (Get-Content -Raw -Path '$env:SystemDrive\Users\${explorer.exe Owner}\WinPE\Duplicate Uncompressed WinPE Files Script.ps1')"
    "/c $([System.Char]34)$WorkingDirectory\DandISetEnv.bat$([System.Char]34) && powershell.exe -NoProfile -ExecutionPolicy 'RemoteSigned'; Invoke-Expression -Command (Get-Content -Raw -Path '${WinPE Image Creation Parent Path}\Duplicate Uncompressed WinPE Files Script.ps1')"
  ) -Verb 'RunAs' -Wait
}


<#
  The following folders have now been created:
  ${WinPE Default Image Creation Path}\.Default ISO\bootbins
  ${WinPE Default Image Creation Path}\.Default ISO\media
  ${WinPE Default Image Creation Path}\.Default ISO\mount
#>


${WinPE Default ISO File BaseName} = '_OriginalWinPE'
${Compress Default WinPE Files to ISO Here-String Precursor} = $(
  "`${WinPE Image Creation Parent Path} = $([System.Char]34)`$env:SystemDrive\Users\%_explorer_owner_%\WinPE$([System.Char]34)`n"
  "`$folder = try {`n"
  "  Get-Item -Path `${WinPE Image Creation Parent Path} -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
  "} catch {`n"
  "  New-Item -Path `${WinPE Image Creation Parent Path} -ItemType $([System.Char]39)Directory$([System.Char]39) -Force`n"
  "}`n"

  "`${WinPE x64 Tools Path} = $([System.Char]34)`${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64$([System.Char]34)`n"
  "`${WinPE Default Image Creation Path} = $([System.Char]34)`${WinPE Image Creation Parent Path}\%_WinPE Workspace Folder Name_%$([System.Char]34)`n"
  "`${WinPE Default ISO Folder Path} = $([System.Char]34)`${WinPE Default Image Creation Path}\.Default ISO$([System.Char]34)`n"
  #"MakeWinPeMedia /ISO `${WinPE Default ISO Folder Path} $([System.Char]34)`${WinPE Default ISO Folder Path}\WinPE_amd64.iso$([System.Char]34)`n"
  #"MakeWinPeMedia.cmd /ISO `${WinPE Default ISO Folder Path} $([System.Char]34)`${WinPE Default ISO Folder Path}\WinPE_amd64.iso$([System.Char]34)`n"
  "MakeWinPeMedia.cmd /ISO `${WinPE Default ISO Folder Path} $([System.Char]34)`${WinPE Default ISO Folder Path}\%_WinPE Default ISO File BaseName_%.iso$([System.Char]34)`n"
) -join ''
${Compress Default WinPE Files to ISO Here-String} = ${Compress Default WinPE Files to ISO Here-String Precursor} `
  -replace '%_WinPE Workspace Folder Name_%',${WinPE Workspace Folder Name} `
  -replace '%_explorer_owner_%',${explorer.exe Owner} `
  -replace '%_WinPE Default ISO File BaseName_%',${WinPE Default ISO File BaseName}

# Set-Content -Path "$env:Temp\Make_WinPE_Media_Script.ps1" -Value (${Make WinPE Media Here-String})
Set-Content -Path "${WinPE Image Creation Parent Path}\Compress Default WinPE Files to ISO Script.ps1" -Value (${Compress Default WinPE Files to ISO Here-String})
$WorkingDirectory = "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools"

$IsPresent = Test-Path -Path "${WinPE Image Creation Parent Path}\${WinPE Workspace Folder Name}\.Default ISO\${WinPE Default ISO File BaseName}.iso"
if (-not $IsPresent) {
  Start-Process -FilePath cmd.exe -ArgumentList @(
    #"/c $([System.Char]34)$WorkingDirectory\DandISetEnv.bat$([System.Char]34) && powershell.exe -NoProfile -ExecutionPolicy 'RemoteSigned'; Invoke-Expression -Command (Get-Content -Raw -Path '$env:TEMP\Make_WinPE_Media_Script.ps1')"
    #"/c $([System.Char]34)$WorkingDirectory\DandISetEnv.bat$([System.Char]34) && powershell.exe -NoProfile -ExecutionPolicy 'RemoteSigned'; Invoke-Expression -Command (Get-Content -Raw -Path '$env:SystemDrive\Users\${explorer.exe Owner}\WinPE\Duplicate Uncompressed WinPE Files Script.ps1')"
    "/c $([System.Char]34)$WorkingDirectory\DandISetEnv.bat$([System.Char]34) && powershell.exe -NoProfile -ExecutionPolicy 'RemoteSigned'; Invoke-Expression -Command (Get-Content -Raw -Path '${WinPE Image Creation Parent Path}\Compress Default WinPE Files to ISO Script.ps1')"
  ) -Verb 'RunAs' -wait
}
#endregion


<#
  start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/get-started/adk-install#install-the-adk'
  start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/get-started/adk-offline-install'
  start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/get-started/adk-offline-install#using-the-command-line'

  adksetup.exe cli syntax: 
  start msedge.exe 'https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-8.1-and-8/dn621910(v=win.10)'
#>



${Updated ISO Folder Path} = "${WinPE Image Creation Parent Path}\${WinPE Workspace Folder Name}\Updated ISO"
$IsPresent = Test-Path -Path ${Updated ISO Folder Path}
if (-not $IsPresent) {
  $folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path ${Updated ISO Folder Path} -ItemType 'Directory' -Force}
  $ParentPath = ([System.IO.FileInfo]${Updated ISO Folder Path}).DirectoryName
  Copy-Item -Path "$ParentPath\.Default ISO\bootbins" -Destination "${Updated ISO Folder Path}\bootbins" -Recurse
  Copy-Item -Path "$ParentPath\.Default ISO\media" -Destination "${Updated ISO Folder Path}\media" -Recurse
  Copy-Item -Path "$ParentPath\.Default ISO\mount" -Destination "${Updated ISO Folder Path}\mount" -Recurse
}


# start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/winpe-add-packages--optional-components-reference?view=windows-11'

<##>
${Mount Directory Path} = "${Updated ISO Folder Path}\mount"
${Mount-Adjust-Eject WinPE.wim File Command Here-String Precursor} = $(
  "`${Updated ISO Folder Path} = $([System.Char]34)%_Updated ISO Folder Path_%$([System.Char]34)`n"
  "`${WinPE x64 Tools Path} = $([System.Char]34)`${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64$([System.Char]34)`n"
  "`${Mount Directory Path} = $([System.Char]34)`${Updated ISO Folder Path}\mount$([System.Char]34)`n"
  "`$PackagePath = $([System.Char]34)`${WinPE x64 Tools Path}\WinPE_OCs$([System.Char]34)`n"
  "`$lang = $([System.Char]34)en-us$([System.Char]34)`n"
  "`n"
  "dism.exe /Mount-Image /ImageFile:$([System.Char]34)`${WinPE x64 Tools Path}\`$lang\WinPE.wim$([System.Char]34) /Index:1 /MountDir:$([System.Char]34)`${Mount Directory Path}$([System.Char]34)`n"
  "`n"
  "`n"
  "`n"
  "`n"
  "`n"
  "`n"
  "`n"
  "dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\WinPE-WMI.cab$([System.Char]34)`n"
  "dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\`$lang\WinPE-WMI_`$lang.cab$([System.Char]34)`n"

  "dism.exe /Unmount-Image /MountDir:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /Commit`n"
  "`n"
  "`n"
  "`n"
  "`n"
  "`n"
  "`n"
) -join ''

${Mount-Adjust-Eject WinPE.wim File Command Here-String} = ${Mount-Adjust-Eject WinPE.wim File Command Here-String Precursor} `
  -replace '%_Mount Directory Path_%',${Mount Directory Path} `
  -replace '%_Updated ISO Folder Path_%',${Updated ISO Folder Path}

${Mount-Adjust-Eject WinPE.wim File Script Path} = "${WinPE Image Creation Parent Path}\Mount-Adjust-Eject WinPE.wim File Script.ps1"
Set-Content -Path ${Mount-Adjust-Eject WinPE.wim File Script Path} -Value ${Mount-Adjust-Eject WinPE.wim File Command Here-String}
$WorkingDirectory = "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools"

Start-Process -ArgumentList @(
  #"Get-Item -Path '${Mount-Adjust-Eject WinPE.wim File Script Path}' | Get-Content -Raw | Invoke-Expression"
  "/c $([System.Char]34)$WorkingDirectory\DandISetEnv.bat$([System.Char]34) && powershell.exe -NoProfile -ExecutionPolicy 'RemoteSigned'; Invoke-Expression -Command (Get-Content -Raw -Path '${Mount-Adjust-Eject WinPE.wim File Script Path}')"
) -FilePath powershell.exe -Verb 'RunAs' -WindowStyle 'Normal' -Wait



<#
  ${Command Here-String Precursor} = $(
    "  & {`n"
    "    `${WinPE x64 Tools Path} = $([System.Char]34)`${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64$([System.Char]34)`n"
    "    `${WinPE Default Image Creation Path} = $([System.Char]34)`$env:SystemDrive\Users\%_explorer_owner_%\WinPE\%_WinPE Workspace Folder Name_%$([System.Char]34)`n"
    "    `${WinPE Default ISO Folder Path} = $([System.Char]34)`${WinPE Default Image Creation Path}\.Default ISO$([System.Char]34)`n"
    "    `$WinPeMount = $([System.Char]34)`${WinPE Default Image Creation Path}\mount$([System.Char]34)`n"
    "    `$PackagePath = $([System.Char]34)`${WinPE x64 Tools Path}\WinPE_OCs$([System.Char]34)`n"
    "    `$lang = $([System.Char]34)en-us$([System.Char]34)`n"

    "    `$path = $([System.Char]34)`$WinPeMount$([System.Char]34)`n"
    "    `$folder = try {Get-Item -Path `$path -ErrorAction $([System.Char]39)Stop$([System.Char]39)} catch {New-Item -Path `$path -ItemType $([System.Char]39)Directory$([System.Char]39) -Force}`n"
    "    pause`n"
    "    Set-ItemProperty -Path $([System.Char]34)`${WinPE x64 Tools Path}\`$lang\winpe.wim$([System.Char]34) -Name IsReadOnly -Value `$false`n"
    "    pause`n"
    "    dism.exe /Mount-Image /ImageFile:$([System.Char]34)`${WinPE x64 Tools Path}\`$lang\winpe.wim$([System.Char]34) /Index:1 /MountDir:`$WinPeMount`n"
    "    pause`n"
    "    pause`n"
    #"    dism.exe /Add-Package /Image:`$WinPeMount /PackagePath:$([System.Char]34)`$PackagePath\WinPE-NetFX.cab$([System.Char]34)`n"
    #"    dism.exe /Add-Package /Image:`$WinPeMount /PackagePath:$([System.Char]34)`$PackagePath\`$lang\WinPE-NetFX_`$lang.cab$([System.Char]34)`n"
    #"    dism.exe /Add-Package /Image:`$WinPeMount /PackagePath:$([System.Char]34)`$PackagePath\WinPE-Scripting.cab$([System.Char]34)`n"
    #"    dism.exe /Add-Package /Image:`$WinPeMount /PackagePath:$([System.Char]34)`$PackagePath\`$lang\WinPE-Scripting_`$lang.cab$([System.Char]34)`n"
    #"    dism.exe /Add-Package /Image:`$WinPeMount /PackagePath:$([System.Char]34)`$PackagePath\WinPE-PowerShell.cab$([System.Char]34)`n"
    #"    dism.exe /Add-Package /Image:`$WinPeMount /PackagePath:$([System.Char]34)`$PackagePath\`$lang\WinPE-PowerShell_`$lang.cab$([System.Char]34)`n"
    #"    dism.exe /Add-Package /Image:`$WinPeMount /PackagePath:$([System.Char]34)`$PackagePath\WinPE-StorageWMI.cab$([System.Char]34)`n"
    #"    dism.exe /Add-Package /Image:`$WinPeMount /PackagePath:$([System.Char]34)`$PackagePath\`$lang\WinPE-StorageWMI_`$lang.cab$([System.Char]34)`n"
    #"    dism.exe /Add-Package /Image:`$WinPeMount /PackagePath:$([System.Char]34)`$PackagePath\WinPE-DismCmdlets.cab$([System.Char]34)`n"
    #"    dism.exe /Add-Package /Image:`$WinPeMount /PackagePath:$([System.Char]34)`$PackagePath\`$lang\WinPE-DismCmdlets_`$lang.cab$([System.Char]34)`n"
    #"    dism.exe /Add-Package /Image:`$WinPeMount /PackagePath:$([System.Char]34)`$PackagePath\WinPE-SecureStartup.cab$([System.Char]34)`n"
    #"    dism.exe /Add-Package /Image:`$WinPeMount /PackagePath:$([System.Char]34)`$PackagePath\`$lang\WinPE-SecureStartup_`$lang.cab$([System.Char]34)`n"
    #"    dism.exe /Add-Package /Image:`$WinPeMount /PackagePath:$([System.Char]34)`$PackagePath\WinPE-EnhancedStorage.cab$([System.Char]34)`n"
    #"    dism.exe /Add-Package /Image:`$WinPeMount /PackagePath:$([System.Char]34)`$PackagePath\`$lang\WinPE-EnhancedStorage_`$lang.cab$([System.Char]34)`n"
    #"    dism.exe /Add-Package /Image:`$WinPeMount /PackagePath:$([System.Char]34)`$PackagePath\WinPE-PmemCmdlets.cab$([System.Char]34)`n"
    #"    dism.exe /Add-Package /Image:`$WinPeMount /PackagePath:$([System.Char]34)`$PackagePath\`$lang\WinPE-PmemCmdlets_`$lang.cab$([System.Char]34)`n"
    #"    dism.exe /Add-Package /Image:`$WinPeMount /PackagePath:$([System.Char]34)`$PackagePath\WinPE-PlatformId.cab$([System.Char]34)`n"
    #"    dism.exe /Add-Package /Image:`$WinPeMount /PackagePath:$([System.Char]34)`$PackagePath\WinPE-SecureBootCmdlets.cab$([System.Char]34)`n"
    #"    dism.exe /Add-Package /Image:`$WinPeMount /PackagePath:$([System.Char]34)`$PackagePath\WinPE-HSP-Driver.cab$([System.Char]34)`n"
    "    pause`n"
    "  }`n"
  ) -join ''
#>


<#
  ${Command Here-String} = ${Command Here-String Precursor} `
    -replace '%_WinPE Workspace Folder Name_%',${WinPE Workspace Folder Name} `
    -replace '%_explorer_owner_%',${explorer.exe Owner}

  ${Mount Image Script Path} = "$env:UserProfile\WinPE\Mount Image Script.ps1"
  Set-Content -Path ${Mount Image Script Path} -Value ${Command Here-String}

  Start-Process -ArgumentList @(
    "Get-Item -Path '${Mount Image Script Path}' | Get-Content -Raw | Invoke-Expression"
  ) -FilePath powershell.exe -Verb 'RunAs' -WindowStyle 'Normal' # -Wait
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

