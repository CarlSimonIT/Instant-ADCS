#Requires -Version 5.1
#Requires -PSEdition Desktop

param (
  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  ${Extracted ISO Folder Path}
)

Set-StrictMode -Version 'Latest'
${.CommonItems} = Resolve-Path -Path "$PSScriptRoot\..\..\..\.CommonItems" | Select-Object -ExpandProperty 'Path'
[System.Environment]::SetEnvironmentVariable('.CommonItems',${.CommonItems})
$FolderFQN = Import-CliXml -Path "${env:.CommonItems}\FolderFQN.clixml"
${WU Server25 Scripts Parent Folder Path} = "${env:.CommonItems}\Offline WU\Server 25" 

<#
  Set-ExecutionPolicy -ExecutionPolicy 'RemoteSigned' -Scope 'Process' -Force; 
  . "C:\Users\lowpr\GitHub\CarlSimonIT\Instant-ADCS\A0\ConvertTo-NoTabsHereStringCompatible.ps1"
#>

${WU s25 Part 02-Copy Mounted Contents at IL-Medium Command Here-String Precursor} = $(
  #region | usings | #requirements | Strict Mode | Variables |
  "#Requires -Version 5.1`n"
  "#Requires -PSEdition Desktop`n"
  "Set-StrictMode -Version $([System.Char]39)Latest$([System.Char]39)`n"
  "`n"
  #########################################-BOUNDARY-#########################################
  #endregion
  #region | Copy Mounted Files to Extracted ISO Folder Path |





  "`n"
  "#region | exit powershell.exe if executing at Integrity Level-High |`n"
  "`${powershell.exe owner Identity} = [Security.Principal.WindowsIdentity]::GetCurrent()`n"
  "`${powershell.exe owner Access} = [Security.Principal.WindowsPrincipal]`${powershell.exe owner Identity}`n"
  "`${Current powershell.exe process is running at Integrity Level-High} = (`${powershell.exe owner Access}).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)`n"
  "`n"
  "if (`${Current powershell.exe process is running at Integrity Level-High}) {`n"
  "  Write-Error -Message $([System.Char]34)`n`n`tExiting Start.ps1 script.`n`n`tRe-launch Windows PowerShell WITHOUT selecting Run As Administrator!`n`n$([System.Char]34)`n"
  "  pause`n"
  "  Get-Process -Id `$PID | Stop-Process -Force`n"
  "}`n"
  "#endregion`n"
  "`n"
  "`${.CommonItems} = $([System.Char]39)%_.CommonItems_%$([System.Char]39)`n"
  "[System.Environment]::SetEnvironmentVariable($([System.Char]39).CommonItems$([System.Char]39),$([System.Char]39)%_.CommonItems_%$([System.Char]39))`n"
  "`${WU Server25 Scripts Parent Folder Path} = $([System.Char]39)%_WU Server25 Scripts Parent Folder Path_%$([System.Char]39)`n"
  "`${Extracted ISO Folder Path} = $([System.Char]39)%_Extracted ISO Folder Path_%$([System.Char]39)`n"
  "`${Mounted ISO Drive Letter} = Import-CliXml -Path $([System.Char]34)`${env:.CommonItems}\Mounted ISO Drive Letter.clixml$([System.Char]34)`n"
  "`n"
  "& {`n"
  "  `$path = `${Extracted ISO Folder Path}; `n"
  "  `${Extracted ISO Folder} = try {Get-Item -Path `$path -ErrorAction $([System.Char]39)Stop$([System.Char]39)} catch {New-Item -Path `$path -ItemType $([System.Char]39)Directory$([System.Char]39) -Force}`n"
  "  Get-ChildItem -Path `${Mounted ISO Drive Letter} -Directory | ForEach-Object -Process {`n"
  "    Copy-Item -Path `$_.FullName -Destination $([System.Char]34)`${Extracted ISO Folder Path}$([System.Char]34) -Recurse`n"
  "  }`n"
  "  Get-ChildItem -Path `${Mounted ISO Drive Letter} -File | ForEach-Object -Process {`n"
  "    Copy-Item -Path `$_.FullName -Destination $([System.Char]34)`${Extracted ISO Folder Path}$([System.Char]34)`n"
  "  }`n"
  "}`n"
  "`t`t"







  #endregion
  #########################################-BOUNDARY-#########################################
  { # Created with '.\ConvertTo-NoTabsHereStringCompatible.ps1' |
    #region | exit powershell.exe if executing at Integrity Level-High |
    ${powershell.exe owner Identity} = [Security.Principal.WindowsIdentity]::GetCurrent()
    ${powershell.exe owner Access} = [Security.Principal.WindowsPrincipal]${powershell.exe owner Identity}
    ${Current powershell.exe process is running at Integrity Level-High} = (${powershell.exe owner Access}).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

    if (${Current powershell.exe process is running at Integrity Level-High}) {
      Write-Error -Message "`n`n`tExiting Start.ps1 script.`n`n`tRe-launch Windows PowerShell WITHOUT selecting Run As Administrator!`n`n"
      pause
      Get-Process -Id $PID | Stop-Process -Force
    }
    #endregion

    ${.CommonItems} = '%_.CommonItems_%'
    [System.Environment]::SetEnvironmentVariable('.CommonItems','%_.CommonItems_%')
    ${WU Server25 Scripts Parent Folder Path} = '%_WU Server25 Scripts Parent Folder Path_%'
    ${Extracted ISO Folder Path} = '%_Extracted ISO Folder Path_%'
    ${Mounted ISO Drive Letter} = Import-CliXml -Path "${env:.CommonItems}\Mounted ISO Drive Letter.clixml"

    & {
      $path = ${Extracted ISO Folder Path}; 
      ${Extracted ISO Folder} = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
      Get-ChildItem -Path ${Mounted ISO Drive Letter} -Directory | ForEach-Object -Process {
        Copy-Item -Path $_.FullName -Destination "${Extracted ISO Folder Path}" -Recurse
      }
      Get-ChildItem -Path ${Mounted ISO Drive Letter} -File | ForEach-Object -Process {
        Copy-Item -Path $_.FullName -Destination "${Extracted ISO Folder Path}"
      }
    }
  } | Out-Null
  #########################################-BOUNDARY-#########################################
) -join ''

${WU s25 Part 02-Copy Mounted Contents at IL-Medium Command Here-String} = ${WU s25 Part 02-Copy Mounted Contents at IL-Medium Command Here-String Precursor} `
  -replace '%_\.CommonItems_%',${env:.CommonItems} `
  -replace '%_WU Server25 Scripts Parent Folder Path_%',${WU Server25 Scripts Parent Folder Path} `
  -replace '%_Extracted ISO Folder Path_%',${Extracted ISO Folder Path}
${WU s25 Part 02-Copy Mounted Contents at IL-Medium Script Path} = "${WU Server25 Scripts Parent Folder Path}\WU s25 Part 02-Copy Mounted Contents at IL-Medium Script.ps1"
Set-Content -Path ${WU s25 Part 02-Copy Mounted Contents at IL-Medium Script Path} -Value (${WU s25 Part 02-Copy Mounted Contents at IL-Medium Command Here-String})

return @{
  'WU s25 Part 02-Copy Mounted Contents at IL-Medium Script Path' = ${WU s25 Part 02-Copy Mounted Contents at IL-Medium Script Path}
}

