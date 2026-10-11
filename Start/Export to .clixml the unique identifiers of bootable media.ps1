#Requires -Version 5.1
#Requires -PSEdition Desktop


#region | Ensure target 'output' directory is present in project root |
$FolderFQN = Import-CliXml -Path "$PSScriptRoot\..\..\.CommonItems\FolderFQN.clixml"

$ParentPath = Resolve-Path -Path "$PSScriptRoot\.." | Select-Object -ExpandProperty 'Path'
$NewPath = Join-Path -Path $ParentPath -ChildPath "output\$FolderFQN"
$NewFolderPath = [System.IO.DirectoryInfo]$NewPath

$IsPresent = Test-Path -Path "$NewFolderPath"
if ($IsPresent) {
  . "$PSScriptRoot\..\Base\5.1\Static\Lightweight Functions.ps1"
  $DateVar = Call-DateVar
  Get-Item -Path $NewFolderPath | Rename-Item -NewName "$FolderFQN $DateVar"
}

${New Windows PowerShell Base Folder Path} = Join-Path -Path "$NewFolderPath" -ChildPath "usb1\$FolderFQN\Base\5.1"
${New Windows PowerShell Base Folder PARTIAL Path} = Join-Path -Path "output\$FolderFQN" -ChildPath "usb1\$FolderFQN\Base\5.1"

${New Windows PowerShell Base Folder} = try {
  Get-Item -Path ${New Windows PowerShell Base Folder Path} -ErrorAction 'Stop'
} catch {
  New-Item -Path ${New Windows PowerShell Base Folder Path} -ItemType 'Directory' -Force
}
#endregion

#region | Import strings for uniquely identifying external media and prompt user if corresponding .clixml hasn't yet been generated |
$BaseNames = @(
  'OSDeploy FriendlyName'
  'OSDeploy UniqueId Raw'
  'OSDeploy SerialNumber'
)
foreach ($BaseName in $BaseNames) {
  $IsPresent = Test-Path -Path "$PSScriptRoot\..\..\.CommonItems\$BaseName.clixml"
  if (-not $IsPresent) {
    . powershell.exe -NoProfile -File "$PSScriptRoot\..\A0\Single Use\Obtain $BaseName.ps1"
  }

  $_Var_Name = $BaseName
  try {Clear-Variable -Name $_Var_Name -ErrorAction 'Stop'} catch {New-Variable -Name $_Var_Name -Value $null}
  Set-Variable -Name $_Var_Name -Value (
    Import-CliXml -Path "$PSScriptRoot\..\..\.CommonItems\$BaseName.clixml"
  )
}
#endregion

#region | Sanitize the user's input by eliminating single & double quotation marks |
${OSDeploy FriendlyName} = ${OSDeploy FriendlyName} -replace $([System.Char]39),'' -replace $([System.Char]34),''
${OSDeploy UniqueId Raw} = ${OSDeploy UniqueId Raw} -replace $([System.Char]39),'' -replace $([System.Char]34),''
${OSDeploy SerialNumber} = ${OSDeploy SerialNumber} -replace $([System.Char]39),'' -replace $([System.Char]34),''
#endregion


$HT = @{
  #region | External Storage Media |
  'OSDeploy FriendlyName'                           = ${OSDeploy FriendlyName}
  'OSDeploy UniqueId Raw'                           = ${OSDeploy UniqueId Raw}
  'OSDeploy SerialNumber'                           = ${OSDeploy SerialNumber}
  'New Windows PowerShell Base Folder PARTIAL Path' = ${New Windows PowerShell Base Folder PARTIAL Path}
  #endregion
}

Push-Location -Path "$PSScriptRoot\..\Base\5.1"
.\Construct-ExternalBootableMediaInstancesFromGeneralizedPrecursor.ps1 @HT
Pop-Location


