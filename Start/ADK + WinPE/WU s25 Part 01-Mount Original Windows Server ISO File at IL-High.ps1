#Requires -Version 5.1
#Requires -PSEdition Desktop

param (
  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  ${Windows Server 2025 ISO Original File Path}, 

  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  ${Windows Server 2025 ISO Patched File Path}
)

Set-StrictMode -Version 'Latest'
[System.Environment]::SetEnvironmentVariable('.CommonItems',"$PSScriptRoot\..\..\..\.CommonItems")

$FolderFQN = Import-CliXml -Path "${env:.CommonItems}\FolderFQN.clixml"
${WU Server25 Scripts Parent Folder Path} = "${env:.CommonItems}\Offline WU\Server 25" 
${Extracted ISO Folder Path} = "${env:.CommonItems}\Offline WU\Server 25\Extracted ISO"
${mounted_wim Folder Path} = "${env:.CommonItems}\Offline WU\Server 25\mounted_wim"

<#
  Set-ExecutionPolicy -ExecutionPolicy 'RemoteSigned' -Scope 'Process' -Force; 
  . "C:\Users\lowpr\GitHub\CarlSimonIT\Instant-ADCS\A0\ConvertTo-NoTabsHereStringCompatible.ps1"
#>

${WU s25 Part 01-Mount Original Windows Server ISO File at IL-High Command Here-String Precursor} = $(
  #region | usings | #requirements | Strict Mode | Variables |
  "#Requires -Version 5.1`n"
  "#Requires -PSEdition Desktop`n"
  "#Requires -RunAsAdministrator`n"
  "Set-StrictMode -Version $([System.Char]39)Latest$([System.Char]39)`n"
  "`n"
  #########################################-BOUNDARY-#########################################
  { # Created with '.\ConvertTo-NoTabsHereStringCompatible.ps1' |
    #     #     Requires -Version 5.1
    #     #     Requires -PSEdition Desktop
    #     #     Requires -RunAsAdministrator
    #     Set-StrictMode -Version 'Latest'
  } | Out-Null
  #########################################-BOUNDARY-#########################################
  #endregion
  #region | Mount Original Unpatched ISO File |

  "`n"
  "`${.CommonItems} = $([System.Char]39)%_.CommonItems_%$([System.Char]39)`n"
  "[System.Environment]::SetEnvironmentVariable($([System.Char]39).CommonItems$([System.Char]39),$([System.Char]39)%_.CommonItems_%$([System.Char]39))`n"
  "`${Windows Server 2025 ISO Original File Path} = $([System.Char]39)%_Windows Server 2025 ISO Original File Path_%$([System.Char]39)`n"
  "`${Windows Server 2025 ISO Patched File Path} = $([System.Char]39)%_Windows Server 2025 ISO Patched File Path_%$([System.Char]39)`n"
  "`$PSModuleInfo = Import-Module $([System.Char]39)Storage$([System.Char]39) -PassThru -Force`n"
  "`${WU Server25 Scripts Parent Folder Path} = $([System.Char]39)%_WU Server25 Scripts Parent Folder Path_%$([System.Char]39)`n"
  "`${Extracted ISO Folder Path} = $([System.Char]39)%_Extracted ISO Folder Path_%$([System.Char]39)`n"
  "`${mounted_wim Folder Path} = $([System.Char]39)%_mounted_wim Folder Path_%$([System.Char]39)`n"
  "`n"
  "& {`n"
  "  `$path = `${Extracted ISO Folder Path}; `${Extracted ISO Folder} = try {Get-Item -Path `$path -ErrorAction $([System.Char]39)Stop$([System.Char]39)} catch {New-Item -Path `$path -ItemType $([System.Char]39)Directory$([System.Char]39) -Force}`n"
  "  `$path = `${mounted_wim Folder Path}; `${mounted_wim Folder} = try {Get-Item -Path `$path -ErrorAction $([System.Char]39)Stop$([System.Char]39)} catch {New-Item -Path `$path -ItemType $([System.Char]39)Directory$([System.Char]39) -Force}`n"
  "`n"
  "  `$HT = @{`n"
  "    ImagePath     = `${Windows Server 2025 ISO Original File Path}`n"
  "    StorageType   = [Microsoft.PowerShell.Cmdletization.GeneratedTypes.DiskImage.StorageType]::ISO`n"
  "    NoDriveLetter = `$false`n"
  "    PassThru      = `$true`n"
  "  }`n"
  "  `${Mounted ISO CIM Instance} = Mount-DiskImage @HT`n"
  "  Export-CliXml -Path $([System.Char]34)`${env:.CommonItems}\Mounted ISO CIM Instance.clixml$([System.Char]34) -InputObject (`${Mounted ISO CIM Instance})`n"
  "`n"
  "  `${Mounted ISO Drive Letter Precursor} = Get-Volume | Where-Object -FilterScript {`n"
  "    `$_.FileSystemLabel -eq $([System.Char]39)SSS_X64FREE_EN-US_DV9$([System.Char]39) -and $([System.Char]96)`n"
  "    `$_.FileSystem      -eq $([System.Char]39)UDF$([System.Char]39)                   -and $([System.Char]96)`n"
  "    `$_.DriveType       -eq $([System.Char]39)CD-ROM$([System.Char]39)`n"
  "  } | Select-Object -ExpandProperty $([System.Char]39)DriveLetter$([System.Char]39)`n"
  "  # Get-Volume | Where-Object -FilterScript {`$_.FileSystemLabel -eq $([System.Char]39)SSS_X64FREE_EN-US_DV9$([System.Char]39) -and `$_.FileSystem -eq $([System.Char]39)UDF$([System.Char]39) -and `$_.DriveType -eq $([System.Char]39)CD-ROM$([System.Char]39)} | select *`n"
  "  `${Mounted ISO Drive Letter} = [System.String]`${Mounted ISO Drive Letter Precursor} + $([System.Char]39):$([System.Char]39)`n"
  "  Export-CliXml -Path $([System.Char]34)`${env:.CommonItems}\Mounted ISO Drive Letter.clixml$([System.Char]34) -InputObject (`${Mounted ISO Drive Letter})`n"
  "}`n"
  "`t`t"
  #endregion
  #########################################-BOUNDARY-#########################################
  { # Created with '.\ConvertTo-NoTabsHereStringCompatible.ps1' |
    ${.CommonItems} = '%_.CommonItems_%'
    [System.Environment]::SetEnvironmentVariable('.CommonItems','%_.CommonItems_%')
    ${Windows Server 2025 ISO Original File Path} = '%_Windows Server 2025 ISO Original File Path_%'
    ${Windows Server 2025 ISO Patched File Path} = '%_Windows Server 2025 ISO Patched File Path_%'
    $PSModuleInfo = Import-Module 'Storage' -PassThru -Force
    ${WU Server25 Scripts Parent Folder Path} = '%_WU Server25 Scripts Parent Folder Path_%'
    ${Extracted ISO Folder Path} = '%_Extracted ISO Folder Path_%'
    ${mounted_wim Folder Path} = '%_mounted_wim Folder Path_%'

    & {
      $path = ${Extracted ISO Folder Path}; ${Extracted ISO Folder} = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
      $path = ${mounted_wim Folder Path}; ${mounted_wim Folder} = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}

      $HT = @{
        ImagePath     = ${Windows Server 2025 ISO Original File Path}
        StorageType   = [Microsoft.PowerShell.Cmdletization.GeneratedTypes.DiskImage.StorageType]::ISO
        NoDriveLetter = $false
        PassThru      = $true
      }
      ${Mounted ISO CIM Instance} = Mount-DiskImage @HT
      Export-CliXml -Path "${env:.CommonItems}\Mounted ISO CIM Instance.clixml" -InputObject (${Mounted ISO CIM Instance})

      ${Mounted ISO Drive Letter Precursor} = Get-Volume | Where-Object -FilterScript {
        $_.FileSystemLabel -eq 'SSS_X64FREE_EN-US_DV9' -and `
        $_.FileSystem      -eq 'UDF'                   -and `
        $_.DriveType       -eq 'CD-ROM'
      } | Select-Object -ExpandProperty 'DriveLetter'
      # Get-Volume | Where-Object -FilterScript {$_.FileSystemLabel -eq 'SSS_X64FREE_EN-US_DV9' -and $_.FileSystem -eq 'UDF' -and $_.DriveType -eq 'CD-ROM'} | select *
      ${Mounted ISO Drive Letter} = [System.String]${Mounted ISO Drive Letter Precursor} + ':'
      Export-CliXml -Path "${env:.CommonItems}\Mounted ISO Drive Letter.clixml" -InputObject (${Mounted ISO Drive Letter})
    }
  } | Out-Null
  #########################################-BOUNDARY-#########################################
) -join ''

${WU s25 Part 01-Mount Original Windows Server ISO File at IL-High Command Here-String} = ${WU s25 Part 01-Mount Original Windows Server ISO File at IL-High Command Here-String Precursor} `
  -replace '%_\.CommonItems_%',${env:.CommonItems} `
  -replace '%_Windows Server 2025 ISO Original File Path_%',${Windows Server 2025 ISO Original File Path} `
  -replace '%_Windows Server 2025 ISO Patched File Path_%',${Windows Server 2025 ISO Patched File Path} `
  -replace '%_WU Server25 Scripts Parent Folder Path_%',${WU Server25 Scripts Parent Folder Path} `
  -replace '%_Extracted ISO Folder Path_%',${Extracted ISO Folder Path} `
  -replace '%_mounted_wim Folder Path_%',${mounted_wim Folder Path}
${WU s25 Part 01-Mount Original Windows Server ISO File at IL-High Script Path} = "${WU Server25 Scripts Parent Folder Path}\WU s25 Part 01-Mount Original Windows Server ISO File at IL-High Script.ps1"
Set-Content -Path ${WU s25 Part 01-Mount Original Windows Server ISO File at IL-High Script Path} -Value (${WU s25 Part 01-Mount Original Windows Server ISO File at IL-High Command Here-String})

return @{
  'WU s25 Part 01-Mount Original Windows Server ISO File at IL-High Script Path' = ${WU s25 Part 01-Mount Original Windows Server ISO File at IL-High Script Path}
}

