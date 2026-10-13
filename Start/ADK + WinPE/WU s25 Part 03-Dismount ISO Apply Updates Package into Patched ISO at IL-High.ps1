#Requires -Version 5.1
#Requires -PSEdition Desktop

${.CommonItems} = Resolve-Path -Path "$PSScriptRoot\..\..\..\.CommonItems" | Select-Object -ExpandProperty 'Path'
[System.Environment]::SetEnvironmentVariable('.CommonItems',${.CommonItems})

$FolderFQN = Import-CliXml -Path "${env:.CommonItems}\FolderFQN.clixml"
${WU Server25 Scripts Parent Folder Path} = "${env:.CommonItems}\usb0\$FolderFQN\Microsoft\OS\Server 25" 
${Extracted ISO Folder Path} = "${env:.CommonItems}\usb0\$FolderFQN\Microsoft\OS\Server 25\Extracted ISO"
${mounted_wim Folder Path} = "${env:.CommonItems}\usb0\$FolderFQN\Microsoft\OS\Server 25\mounted_wim"

<#
  Set-ExecutionPolicy -ExecutionPolicy 'RemoteSigned' -Scope 'Process' -Force; 
  . "C:\Users\lowpr\GitHub\CarlSimonIT\Instant-ADCS\A0\ConvertTo-HereStringCompatible.ps1"
#>

${WU s25 Part 03-Dismount ISO Apply Updates Package into Patched ISO at IL-High Command Here-String Precursor} = $(
  #region | usings | #requirements | Strict Mode | Variables |
  "#Requires -Version 5.1`n"
  "#Requires -PSEdition Desktop`n"
  "#Requires -RunAsAdministrator`n"
  "Set-StrictMode -Version $([System.Char]39)Latest$([System.Char]39)`n"
  "`n"
  #########################################-BOUNDARY-#########################################
  #endregion
  #region | Copy Mounted Files to Extracted ISO Folder Path |
  "`n"
  "`${.CommonItems} = $([System.Char]39)%_.CommonItems_%$([System.Char]39)`n"
  "[System.Environment]::SetEnvironmentVariable($([System.Char]39).CommonItems$([System.Char]39),$([System.Char]39)%_.CommonItems_%$([System.Char]39))`n"
  "`$PSModuleInfo = Import-Module $([System.Char]39)Storage$([System.Char]39) -PassThru -Force`n"
  "`${WU Server25 Scripts Parent Folder Path} = $([System.Char]39)%_WU Server25 Scripts Parent Folder Path_%$([System.Char]39)`n"
  "`${Extracted ISO Folder Path} = $([System.Char]39)%_Extracted ISO Folder Path_%$([System.Char]39)`n"
  "`${mounted_wim Folder Path} = $([System.Char]39)%_mounted_wim Folder Path_%$([System.Char]39)`n"
  "`${Mounted ISO CIM Instance} = Import-CliXml -Path $([System.Char]34)`${env:.CommonItems}\Mounted ISO CIM Instance.clixml$([System.Char]34)`n"
  "`n"
  "`n"
  "& {`n"
  "  `${Dismounted ISO CIM Instance} = `${Mounted ISO CIM Instance} | Dismount-DiskImage`n"
  "}`n"
  #endregion
  #########################################-BOUNDARY-#########################################
  { # Created with '.\ConvertTo-HereStringCompatible.ps1' |
    ${.CommonItems} = '%_.CommonItems_%'
    [System.Environment]::SetEnvironmentVariable('.CommonItems','%_.CommonItems_%')
    $PSModuleInfo = Import-Module 'Storage' -PassThru -Force
    ${WU Server25 Scripts Parent Folder Path} = '%_WU Server25 Scripts Parent Folder Path_%'
    ${Extracted ISO Folder Path} = '%_Extracted ISO Folder Path_%'
    ${mounted_wim Folder Path} = '%_mounted_wim Folder Path_%'
    ${Mounted ISO CIM Instance} = Import-CliXml -Path "${env:.CommonItems}\Mounted ISO CIM Instance.clixml"

    & {
      ${Dismounted ISO CIM Instance} = ${Mounted ISO CIM Instance} | Dismount-DiskImage
















    }
  } | Out-Null
  #########################################-BOUNDARY-#########################################
) -join ''

${WU s25 Part 03-Dismount ISO Apply Updates Package into Patched ISO at IL-High Command Here-String} = ${WU s25 Part 03-Dismount ISO Apply Updates Package into Patched ISO at IL-High Command Here-String Precursor} `
  -replace '%_\.CommonItems_%',${env:.CommonItems} `
  -replace '%_Windows Server 2025 ISO Original File Path_%',${Windows Server 2025 ISO Original File Path} `
  -replace '%_Windows Server 2025 ISO Patched File Path_%',${Windows Server 2025 ISO Patched File Path} `
  -replace '%_WU Server25 Scripts Parent Folder Path_%',${WU Server25 Scripts Parent Folder Path} `
  -replace '%_Extracted ISO Folder Path_%',${Extracted ISO Folder Path} `
  -replace '%_mounted_wim Folder Path_%',${mounted_wim Folder Path}
${WU s25 Part 03-Dismount ISO Apply Updates Package into Patched ISO at IL-High Script Path} = "${WU Server25 Scripts Parent Folder Path}\WU s25 Part 03-Dismount ISO Apply Updates Package into Patched ISO at IL-High Script.ps1"
Set-Content -Path ${WU s25 Part 03-Dismount ISO Apply Updates Package into Patched ISO at IL-High Script Path} -Value (${WU s25 Part 03-Dismount ISO Apply Updates Package into Patched ISO at IL-High Command Here-String})

return @{
  'WU s25 Part 03-Dismount ISO Apply Updates Package into Patched ISO at IL-High Script Path' = ${WU s25 Part 03-Dismount ISO Apply Updates Package into Patched ISO at IL-High Script Path}
}

