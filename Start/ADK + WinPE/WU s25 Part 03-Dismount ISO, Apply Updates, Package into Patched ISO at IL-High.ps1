#Requires -Version 5.1
#Requires -PSEdition Desktop

param (
  [Parameter(
    Mandatory = $true
  )]
  [System.UInt32[]]
  ${Windows Server Image Index Set},

  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  ${install.wim File Path},

  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  ${mounted_wim Folder Path},

  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  ${Package Directory Path}, 

  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  ${Windows Server 2025 ISO Patched File Path}
)

Set-StrictMode -Version 'Latest'
${.CommonItems} = Resolve-Path -Path "$PSScriptRoot\..\..\..\.CommonItems" | Select-Object -ExpandProperty 'Path'
[System.Environment]::SetEnvironmentVariable('.CommonItems',${.CommonItems})

$FolderFQN = Import-CliXml -Path "${env:.CommonItems}\FolderFQN.clixml"
${WU Server25 Scripts Parent Folder Path} = "${env:.CommonItems}\Offline WU\Server 25" 
${Extracted ISO Folder Path} = "${env:.CommonItems}\Offline WU\Server 25\Extracted ISO"

$__DirectoryForDscConfigs = Import-CliXml -Path "${env:.CommonItems}\__DirectoryForDscConfigs.clixml"

${WU s25 Part 03-Dismount ISO, Apply Updates, Package into Patched ISO at IL-High Command Here-String Precursor} = $(
  #region | usings | #requirements | Strict Mode | Variables |
  "#Requires -Version 5.1`n"
  "#Requires -PSEdition Desktop`n"
  "#Requires -RunAsAdministrator`n"
  "Set-StrictMode -Version $([System.Char]39)Latest$([System.Char]39)`n"
  "`n"
  "`n"
  #endregion
  #########################################-BOUNDARY-#########################################
  #region | Dismount Original ISO of Windows Server 2025 | Mount .wim file | Patch images & dismount .wim | split .wim | Generate patched .iso file |

  #region |  |
  "`n"
  "& { # Dismount Original ISO of Windows Server 2025 | Mount .wim | Apply packages + drivers to images | dismount .wim | split .wim | Generate patched .iso |`n"
  "  `${.CommonItems} = $([System.Char]39)%_.CommonItems_%$([System.Char]39)`n"
  "  [System.Environment]::SetEnvironmentVariable($([System.Char]39).CommonItems$([System.Char]39),$([System.Char]39)%_.CommonItems_%$([System.Char]39))`n"
  "  `$PSModuleInfo = Import-Module $([System.Char]39)Storage$([System.Char]39) -PassThru -Force`n"
  "  `${Mounted ISO CIM Instance} = Import-CliXml -Path $([System.Char]34)`${env:.CommonItems}\Mounted ISO CIM Instance.clixml$([System.Char]34)`n"
  "`n"
  "  & {`n"
  "    `${Dismounted ISO CIM Instance} = `${Mounted ISO CIM Instance} | Dismount-DiskImage`n"
  "  }`n"
  "`n"
  "  # Disable $([System.Char]39)ReadOnly$([System.Char]39) attribute on install.wim file`n"
  "  `${install.wim File Path} = $([System.Char]39)%_install.wim File Path_%$([System.Char]39)`n"
  "  Set-ItemProperty -Path `${install.wim File Path} -Name $([System.Char]39)IsReadOnly$([System.Char]39) -Value `$false`n"
  "`n"
  "  # Specify Mount + Package directories`n"
  "  `${mounted_wim Folder Path} = $([System.Char]39)%_mounted_wim Folder Path_%$([System.Char]39)`n"
  "  `${Package Directory Path} = $([System.Char]39)%_Package Directory Path_%$([System.Char]39)`n"
  "`n"
  "  # Ensure $([System.Char]39)Windows Server Image Index Set$([System.Char]39) is an array, not a string.`n"
  "  `${Windows Server Image Index Set As String} = $([System.Char]39)%_Windows Server Image Index Set As String_%$([System.Char]39)`n"
  "  `${Windows Server Image Index Set} = `${Windows Server Image Index Set As String} -split $([System.Char]39),$([System.Char]39)`n"
  "`n"
  "  `${Extracted ISO Folder Path} = $([System.Char]39)%_Extracted ISO Folder Path_%$([System.Char]39)`n"
  "  `${Windows Server 2025 ISO Patched File Path} = $([System.Char]39)%_Windows Server 2025 ISO Patched File Path_%$([System.Char]39)`n"
  "  `${WU Server25 Scripts Parent Folder Path} = $([System.Char]39)%_WU Server25 Scripts Parent Folder Path_%$([System.Char]39)`n"
  "`n"
  "  `${Extracted WinPE Driver Pack Dell A11 Folder} = [System.IO.FileInfo]$([System.Char]34)`${.CommonItems}\WinPE\ADK + WinPE (2026-09)\WinPE Driver Packs\Dell A11$([System.Char]34)`n"
  "  `${Extracted Bare-Metal Windows Server 2025 Drivers Folder} = [System.IO.FileInfo]$([System.Char]34)`${WU Server25 Scripts Parent Folder Path}\..\Drivers$([System.Char]34)`n"
  "`n"
  "  `$path = `${mounted_wim Folder Path}`n"
  "  `${mounted_wim Folder} = try {Get-Item -Path `$path -ErrorAction $([System.Char]39)Stop$([System.Char]39)} catch {New-Item -Path `$path -ItemType $([System.Char]39)Directory$([System.Char]39) -Force}`n"
  "`n"
  "  Set-Location -Path $([System.Char]34)`${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\DISM$([System.Char]34)`n"
  "  `${ForEach Loop Start Time} = [DateTime]::Now`n"
  "`n"
  "  foreach (`${Windows Server Image Index} in `${Windows Server Image Index Set}) {`n"
  "    `${Function Start Time} = [DateTime]::Now`n"
  "    `${Mount Start} = [DateTime]::Now`n"
  "    .\dism.exe /Mount-Wim /WimFile:`${install.wim File Path} /Index:`${Windows Server Image Index} /MountDir:`${mounted_wim Folder Path}`n"
  "    `${Mount Finish} = [DateTime]::Now`n"
  "    Write-Verbose -Message $([System.Char]34)  Mount Duration for $([System.Char]39)Windows Server Image Index$([System.Char]39) = `${Windows Server Image Index}`$([System.Char]58) `$((`${Mount Finish} - `${Mount Start}).TotalSeconds.ToString($([System.Char]39)n3$([System.Char]39))) Seconds$([System.Char]34)`n"
  "`n"
  "    ## Apply Update Package(s)`n"
  "    `${Add-Packages Start} = [DateTime]::Now`n"
  "    .\dism.exe /Add-Package /Image:`${mounted_wim Folder Path} /PackagePath:`${Package Directory Path}`n"
  "    `${Add-Packages Finish} = [DateTime]::Now`n"
  "`n"
  "    if ((3,4) -contains `${Windows Server Image Index}) {`n"
  "      # Will WinPE drivers prevent the BSOD? Probably not, but here goes nothing. `n"
  "      #dism.exe /Add-Driver /Image:$([System.Char]34)`${mounted_wim Folder Path}$([System.Char]34) /Driver:$([System.Char]34)`${Extracted WinPE Driver Pack Dell A11 Folder}$([System.Char]34) /Recurse`n"
  "      .\dism.exe /Add-Driver /Image:$([System.Char]34)`${mounted_wim Folder Path}$([System.Char]34) /Driver:$([System.Char]34)`${Extracted Bare-Metal Windows Server 2025 Drivers Folder}$([System.Char]34) /Recurse`n"
  "    }`n"
  "`n"
  "    # Unmount the volume back to install.wim on the local file system`n"
  "    `${Commit Start} = [DateTime]::Now`n"
  "    .\dism.exe /Unmount-Wim /MountDir:`${mounted_wim Folder Path} /Commit`n"
  "    #Dism.exe /Unmount-Wim /MountDir:`${mounted_wim Folder Path} /Discard`n"
  "    `${Commit Finish} = [DateTime]::Now`n"
  "`n"
  "    `${Function End Time} = [DateTime]::Now`n"
  "    `${Function TimeSpan} = `${Function End Time} - `${Function Start Time}`n"
  "    `$min = `${Function TimeSpan}.Minutes`n"
  "    `$sec = `${Function TimeSpan}.Seconds`n"
  "    Write-Verbose -Message $([System.Char]34)  Function total duration on $([System.Char]39)Windows Server Image Index$([System.Char]39) = `${Windows Server Image Index}`$([System.Char]58) `$(`$min)m`$(`$sec)s$([System.Char]34)`n"
  "  }`n"
  "`n"
  "  `${ForEach Loop End Time} = [DateTime]::Now`n"
  "  `${ForEach Loop TimeSpan} = `${ForEach Loop End Time} - `${ForEach Loop Start Time}`n"
  "  `$min = `${ForEach Loop TimeSpan}.Minutes`n"
  "  `$sec = `${ForEach Loop TimeSpan}.Seconds`n"
  "  Write-Verbose -Message $([System.Char]34)  Function total duration on $([System.Char]39)Windows Server Image Index$([System.Char]39) = `${Windows Server Image Index}`$([System.Char]58) `$(`$min)m`$(`$sec)s$([System.Char]34)`n"
  "`n"
  "  `$path = $([System.Char]34)`${Extracted ISO Folder Path}\..\Split$([System.Char]34)`n"
  "  `${Split Folder} = try {Get-Item -Path `$path -ErrorAction $([System.Char]39)Stop$([System.Char]39)} catch {New-Item -Path `$path -ItemType $([System.Char]39)Directory$([System.Char]39) -Force}`n"
  "  .\dism.exe /Split-Image /ImageFile:$([System.Char]34)`${Extracted ISO Folder Path}\sources\install.wim$([System.Char]34) /SWMFile:$([System.Char]34)`${Split Folder}\install.swm$([System.Char]34) /FileSize:4000`n"
  "`n"
  "  Set-Location -Path $([System.Char]34)`${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\Oscdimg$([System.Char]34)`n"
  "  #Copy-Item -Path $([System.Char]34).\efisys.bin$([System.Char]34) -Destination $([System.Char]34)`$ns\reimages\HelpFiles$([System.Char]34) -Force`n"
  "  # start msedge.exe $([System.Char]39)https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/oscdimg-command-line-options?view=windows-11$([System.Char]39)`n"
  "  .\oscdimg.exe -b$([System.Char]34).\efisys.bin$([System.Char]34) -pEF -u1 -udfver102 `${Extracted ISO Folder Path} `${Windows Server 2025 ISO Patched File Path}`n"
  "  #Set-Location $([System.Char]34)`$env:SystemDrive$([System.Char]34)`n"
  "`n"
  "  Start-Sleep 5`n"
  "  #Get-Item -Path `${Extracted ISO Folder Path} | Remove-Item -Recurse -Force`n"
  "  Get-Item -Path `${mounted_wim Folder Path} | Remove-Item -Recurse -Force`n"
  "}`n"
  "`t`t"
  #endregion

  #endregion
  { # Created with ConvertTo-HereStringPrecursor |
    & { # Dismount Original ISO of Windows Server 2025 | Mount .wim | Apply packages + drivers to images | dismount .wim | split .wim | Generate patched .iso |
      ${.CommonItems} = '%_.CommonItems_%'
      [System.Environment]::SetEnvironmentVariable('.CommonItems','%_.CommonItems_%')
      $PSModuleInfo = Import-Module 'Storage' -PassThru -Force
      ${Mounted ISO CIM Instance} = Import-CliXml -Path "${env:.CommonItems}\Mounted ISO CIM Instance.clixml"

      & {
        ${Dismounted ISO CIM Instance} = ${Mounted ISO CIM Instance} | Dismount-DiskImage
      }

      # Disable 'ReadOnly' attribute on install.wim file
      ${install.wim File Path} = '%_install.wim File Path_%'
      Set-ItemProperty -Path ${install.wim File Path} -Name 'IsReadOnly' -Value $false

      # Specify Mount + Package directories
      ${mounted_wim Folder Path} = '%_mounted_wim Folder Path_%'
      ${Package Directory Path} = '%_Package Directory Path_%'

      # Ensure 'Windows Server Image Index Set' is an array, not a string.
      ${Windows Server Image Index Set As String} = '%_Windows Server Image Index Set As String_%'
      ${Windows Server Image Index Set} = ${Windows Server Image Index Set As String} -split ','

      ${Extracted ISO Folder Path} = '%_Extracted ISO Folder Path_%'
      ${Windows Server 2025 ISO Patched File Path} = '%_Windows Server 2025 ISO Patched File Path_%'
      ${WU Server25 Scripts Parent Folder Path} = '%_WU Server25 Scripts Parent Folder Path_%'

      ${Extracted WinPE Driver Pack Dell A11 Folder} = [System.IO.FileInfo]"${.CommonItems}\WinPE\ADK + WinPE (2026-09)\WinPE Driver Packs\Dell A11"
      ${Extracted Bare-Metal Windows Server 2025 Drivers Folder} = [System.IO.FileInfo]"${WU Server25 Scripts Parent Folder Path}\..\Drivers"

      $path = ${mounted_wim Folder Path}
      ${mounted_wim Folder} = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}

      Set-Location -Path "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\DISM"
      ${ForEach Loop Start Time} = [DateTime]::Now

      foreach (${Windows Server Image Index} in ${Windows Server Image Index Set}) {
        ${Function Start Time} = [DateTime]::Now
        ${Mount Start} = [DateTime]::Now
        .\dism.exe /Mount-Wim /WimFile:${install.wim File Path} /Index:${Windows Server Image Index} /MountDir:${mounted_wim Folder Path}
        ${Mount Finish} = [DateTime]::Now
        Write-Verbose -Message "  Mount Duration for 'Windows Server Image Index' = ${Windows Server Image Index}$([System.Char]58) $((${Mount Finish} - ${Mount Start}).TotalSeconds.ToString('n3')) Seconds"

        ## Apply Update Package(s)
        ${Add-Packages Start} = [DateTime]::Now
        .\dism.exe /Add-Package /Image:${mounted_wim Folder Path} /PackagePath:${Package Directory Path}
        ${Add-Packages Finish} = [DateTime]::Now

        if ((3,4) -contains ${Windows Server Image Index}) {
          # Will WinPE drivers prevent the BSOD? Probably not, but here goes nothing. 
          #dism.exe /Add-Driver /Image:"${mounted_wim Folder Path}" /Driver:"${Extracted WinPE Driver Pack Dell A11 Folder}" /Recurse
          # Yes, the computer blue-screened
          .\dism.exe /Add-Driver /Image:"${mounted_wim Folder Path}" /Driver:"${Extracted Bare-Metal Windows Server 2025 Drivers Folder}" /Recurse
        }

        # Unmount the volume back to install.wim on the local file system
        ${Commit Start} = [DateTime]::Now
        .\dism.exe /Unmount-Wim /MountDir:${mounted_wim Folder Path} /Commit
        #Dism.exe /Unmount-Wim /MountDir:${mounted_wim Folder Path} /Discard
        ${Commit Finish} = [DateTime]::Now

        ${Function End Time} = [DateTime]::Now
        ${Function TimeSpan} = ${Function End Time} - ${Function Start Time}
        $min = ${Function TimeSpan}.Minutes
        $sec = ${Function TimeSpan}.Seconds
        Write-Verbose -Message "  Function total duration on 'Windows Server Image Index' = ${Windows Server Image Index}$([System.Char]58) $($min)m$($sec)s"
      }

      ${ForEach Loop End Time} = [DateTime]::Now
      ${ForEach Loop TimeSpan} = ${ForEach Loop End Time} - ${ForEach Loop Start Time}
      $min = ${ForEach Loop TimeSpan}.Minutes
      $sec = ${ForEach Loop TimeSpan}.Seconds
      Write-Verbose -Message "  Function total duration on 'Windows Server Image Index' = ${Windows Server Image Index}$([System.Char]58) $($min)m$($sec)s"

      $path = "${Extracted ISO Folder Path}\..\Split"
      ${Split Folder} = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
      .\dism.exe /Split-Image /ImageFile:"${Extracted ISO Folder Path}\sources\install.wim" /SWMFile:"${Split Folder}\install.swm" /FileSize:4000

      Set-Location -Path "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\Oscdimg"
      # start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/oscdimg-command-line-options?view=windows-11'
      .\oscdimg.exe -b".\efisys.bin" -pEF -u1 -udfver102 ${Extracted ISO Folder Path} ${Windows Server 2025 ISO Patched File Path}

      Start-Sleep 5
      Get-Item -Path ${mounted_wim Folder Path} | Remove-Item -Recurse -Force
    }
  } | Out-Null
  #########################################-BOUNDARY-#########################################
) -join ''

${WU s25 Part 03-Dismount ISO, Apply Updates, Package into Patched ISO at IL-High Command Here-String} = ${WU s25 Part 03-Dismount ISO, Apply Updates, Package into Patched ISO at IL-High Command Here-String Precursor} `
  -replace '%_\.CommonItems_%',${env:.CommonItems} `
  -replace '%_Windows Server 2025 ISO Patched File Path_%',${Windows Server 2025 ISO Patched File Path} `
  -replace '%_WU Server25 Scripts Parent Folder Path_%',${WU Server25 Scripts Parent Folder Path} `
  -replace '%_Extracted ISO Folder Path_%',${Extracted ISO Folder Path} `
  -replace '%_Windows Server Image Index Set As String_%',(${Windows Server Image Index Set} -join ',') `
  -replace '%_install.wim File Path_%',${install.wim File Path} `
  -replace '%_mounted_wim Folder Path_%',${mounted_wim Folder Path} `
  -replace '%_Package Directory Path_%',${Package Directory Path}

${WU s25 Part 03-Dismount ISO, Apply Updates, Package into Patched ISO at IL-High Script Path} = "${WU Server25 Scripts Parent Folder Path}\WU s25 Part 03-Dismount ISO, Apply Updates, Package into Patched ISO at IL-High Script.ps1"
Set-Content -Path ${WU s25 Part 03-Dismount ISO, Apply Updates, Package into Patched ISO at IL-High Script Path} -Value (${WU s25 Part 03-Dismount ISO, Apply Updates, Package into Patched ISO at IL-High Command Here-String})

return @{
  'WU s25 Part 03-Dismount ISO, Apply Updates, Package into Patched ISO at IL-High Script Path' = ${WU s25 Part 03-Dismount ISO, Apply Updates, Package into Patched ISO at IL-High Script Path}
}
