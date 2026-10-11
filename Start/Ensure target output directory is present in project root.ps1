
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

