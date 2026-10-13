#Requires -Version 5.1 -PSEdition Desktop

param (
  ${Windows Server 2025 ISO Original File Path},
  ${Windows Server 2025 ISO Patched File Path}
)

[System.Environment]::SetEnvironmentVariable('.CommonItems',"$PSScriptRoot\..\..\..\.CommonItems")

#$FolderFQN = Import-CliXml -Path "$PSScriptRoot\..\..\..\.CommonItems\FolderFQN.clixml"
$FolderFQN = Import-CliXml -Path "${env:.CommonItems}\FolderFQN.clixml"
#${Patch Windows Server ISO File with Latest Windows Updates Script Parent Folder Path} = "$PSScriptRoot\..\..\..\.CommonItems\usb0\$FolderFQN\Microsoft\OS\Server 25" 
${Patch Windows Server ISO File with Latest Windows Updates Script Parent Folder Path} = "${env:.CommonItems}\usb0\$FolderFQN\Microsoft\OS\Server 25" 
#${Extracted ISO Folder Path} = "$PSScriptRoot\..\..\..\.CommonItems\usb0\$FolderFQN\Microsoft\OS\Server 25\Extracted ISO"
${Extracted ISO Folder Path} = "${env:.CommonItems}\usb0\$FolderFQN\Microsoft\OS\Server 25\Extracted ISO"
#${mounted_wim Folder Path} = "$PSScriptRoot\..\..\..\.CommonItems\usb0\$FolderFQN\Microsoft\OS\Server 25\mounted_wim"
${mounted_wim Folder Path} = "${env:.CommonItems}\usb0\$FolderFQN\Microsoft\OS\Server 25\mounted_wim"


<#
  ${Windows Server 2025 ISO Original File Path} = "C:\Users\lowpr\GitHub\CarlSimonIT\.CommonItems\usb0\Instant-ADCS\Microsoft\OS\Server 25\Original\Windows Server 2025.iso"
  ${Windows Server 2025 ISO Patched File Path}  = "C:\Users\lowpr\GitHub\CarlSimonIT\.CommonItems\usb0\Instant-ADCS\Microsoft\OS\Server 25\Patched\Windows Server 2025.iso"
#>
<#
  Set-ExecutionPolicy -ExecutionPolicy 'RemoteSigned' -Scope 'Process' -Force; 
  . "C:\Users\lowpr\GitHub\CarlSimonIT\Instant-ADCS\A0\ConvertTo-HereStringCompatible.ps1"
#>
<#
  code "C:\Users\lowpr\GitHub\CarlSimonIT\Instant-ADCS\Start\ADK + WinPE\WU s25 Part 01-Mount Original Windows Server ISO File at IL-High.ps1"
#>

${Patch Windows Server ISO File with Latest Windows Updates Command Here-String Precursor} = $(
  #region | usings | #requirements | Strict Mode | Variables |
  "#Requires -Version 5.1 -PSEdition Desktop -RunAsAdministrator`n"
  #endregion
  #region | Mount Original Unpatched ISO File |

  "`n"
  "`${.CommonItems} = $([System.Char]39)%_.CommonItems_%$([System.Char]39)`n"
  "[System.Environment]::SetEnvironmentVariable($([System.Char]39).CommonItems$([System.Char]39),$([System.Char]39)%_.CommonItems_%$([System.Char]39))`n"
  "`${Windows Server 2025 ISO Original File Path} = $([System.Char]39)%_Windows Server 2025 ISO Original File Path_%$([System.Char]39)`n"
  "`${Windows Server 2025 ISO Patched File Path} = $([System.Char]39)%_Windows Server 2025 ISO Patched File Path_%$([System.Char]39)`n"
  "`$PSModuleInfo = Import-Module $([System.Char]39)Storage$([System.Char]39) -PassThru -Force`n"
  "`${Patch Windows Server ISO File with Latest Windows Updates Script Parent Folder Path} = $([System.Char]39)%_Patch Windows Server ISO File with Latest Windows Updates Script Parent Folder Path_%$([System.Char]39)`n"
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
  { # Created with '.\ConvertTo-HereStringCompatible.ps1' |
    ${.CommonItems} = '%_.CommonItems_%'
    [System.Environment]::SetEnvironmentVariable('.CommonItems','%_.CommonItems_%')
    ${Windows Server 2025 ISO Original File Path} = '%_Windows Server 2025 ISO Original File Path_%'
    ${Windows Server 2025 ISO Patched File Path} = '%_Windows Server 2025 ISO Patched File Path_%'
    $PSModuleInfo = Import-Module 'Storage' -PassThru -Force
    ${Patch Windows Server ISO File with Latest Windows Updates Script Parent Folder Path} = '%_Patch Windows Server ISO File with Latest Windows Updates Script Parent Folder Path_%'
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
  #########################################-BOUNDARY-#########################################
  { # Created with '.\ConvertTo-HereStringCompatible.ps1' |
    ${.CommonItems} = '%_.CommonItems_%'
    [System.Environment]::SetEnvironmentVariable('.CommonItems','%_.CommonItems_%')
    ${Windows Server 2025 ISO Original File Path} = '%_Windows Server 2025 ISO Original File Path_%'
    ${Windows Server 2025 ISO Patched File Path} = '%_Windows Server 2025 ISO Patched File Path_%'
    $PSModuleInfo = Import-Module 'Storage' -PassThru -Force
    ${Patch Windows Server ISO File with Latest Windows Updates Script Parent Folder Path} = '%_Patch Windows Server ISO File with Latest Windows Updates Script Parent Folder Path_%'
    ${Extracted ISO Folder Path} = '%_Extracted ISO Folder Path_%'
    ${mounted_wim Folder Path} = '%_mounted_wim Folder Path_%'

    & {
      Get-ChildItem -Path ${Mounted ISO Drive Letter} -Directory | ForEach-Object -Process {
        Copy-Item -Path $_.FullName -Destination "${Extracted ISO Folder}" -Recurse
      }
      Get-ChildItem -Path ${Mounted ISO Drive Letter} -File | ForEach-Object -Process {
        Copy-Item -Path $_.FullName -Destination "${Extracted ISO Folder}"
      }
    }
  } | Out-Null
  #########################################-BOUNDARY-#########################################
  #########################################-BOUNDARY-#########################################
  { # Created with '.\ConvertTo-HereStringCompatible.ps1' |
    ${.CommonItems} = '%_.CommonItems_%'
    [System.Environment]::SetEnvironmentVariable('.CommonItems','%_.CommonItems_%')
    ${Windows Server 2025 ISO Original File Path} = '%_Windows Server 2025 ISO Original File Path_%'
    ${Windows Server 2025 ISO Patched File Path} = '%_Windows Server 2025 ISO Patched File Path_%'
    $PSModuleInfo = Import-Module 'Storage' -PassThru -Force
    ${Patch Windows Server ISO File with Latest Windows Updates Script Parent Folder Path} = '%_Patch Windows Server ISO File with Latest Windows Updates Script Parent Folder Path_%'
    ${Extracted ISO Folder Path} = '%_Extracted ISO Folder Path_%'
    ${mounted_wim Folder Path} = '%_mounted_wim Folder Path_%'

    & {
      ${Dismounted ISO CIM Instance} = ${Mounted ISO CIM Instance} | Dismount-DiskImage
    }
  } | Out-Null
  #########################################-BOUNDARY-#########################################

  #########################################-BOUNDARY-#########################################
  {} | Out-Null
  #########################################-BOUNDARY-#########################################
  #region | Dismount Original Unpatched ISO File |
  #endregion
  #########################################-BOUNDARY-#########################################
  { # Created with '.\ConvertTo-HereStringCompatible.ps1' |
    & {
      
    }
  } | Out-Null
  #########################################-BOUNDARY-#########################################
) -join ''

${Patch Windows Server ISO File with Latest Windows Updates Command Here-String} = ${Patch Windows Server ISO File with Latest Windows Updates Command Here-String Precursor} `
  -replace '%_\.CommonItems_%',${env:.CommonItems} `
  -replace '%_Windows Server 2025 ISO Original File Path_%',${Windows Server 2025 ISO Original File Path} `
  -replace '%_Windows Server 2025 ISO Patched File Path_%',${Windows Server 2025 ISO Patched File Path} `
  -replace '%_Patch Windows Server ISO File with Latest Windows Updates Script Parent Folder Path_%',${Patch Windows Server ISO File with Latest Windows Updates Script Parent Folder Path} `
  -replace '%_Extracted ISO Folder Path_%',${Extracted ISO Folder Path} `
  -replace '%_mounted_wim Folder Path_%',${mounted_wim Folder Path}
#${Patch Windows Server ISO File with Latest Windows Updates Command} = [ScriptBlock]::Create(${Patch Windows Server ISO File with Latest Windows Updates Command Here-String})

${Patch Windows Server ISO File with Latest Windows Updates Script Path} = "${Patch Windows Server ISO File with Latest Windows Updates Script Parent Folder Path}\Patch Windows Server ISO File with Latest Windows Updates Script.ps1"
Set-Content -Path ${Patch Windows Server ISO File with Latest Windows Updates Script Path} -Value (${Patch Windows Server ISO File with Latest Windows Updates Command Here-String})
return @{
  'Patch Windows Server ISO File with Latest Windows Updates Script Path' = ${Patch Windows Server ISO File with Latest Windows Updates Script Path}
}

