#Requires -Version 7.4
#Requires -PSEdition Core

#region | Unlock Bitwarden CLI and confirm that FolderID is a GUI |
Unlock-BwCLI -Verbose
$FolderFQN = Import-CliXml -Path "$PSScriptRoot\..\..\..\.CommonItems\FolderFQN.clixml"
Write-Verbose -Message "Attempting to execute bw.exe sync"
bw.exe sync
Write-Verbose -Message "Executed bw.exe sync"

Write-Verbose -Message "Attempting to execute '`$FolderId = New-BitwardenVaultFolder -Verbose:`$true -Name `$FolderFQN -Check'"
$FolderId = New-BitwardenVaultFolder -Verbose:$true -Name $FolderFQN -Check
Write-Verbose -Message "Execution of '`$FolderId = New-BitwardenVaultFolder -Verbose:`$true -Name `$FolderFQN -Check' complete"
Write-Verbose -Message "`$FolderId = $FolderId"
Export-CliXml -Path "$PSScriptRoot\..\..\..\.CommonItems\FolderId.clixml" -InputObject ($FolderId)
#endregion
#region | Confirm that current value of FolderId.clixml is indeed a GUID |
# Import regular expression patterns
. "$PSScriptRoot\..\..\output\$FolderFQN\usb1\$FolderFQN\Base\5.1\Regular Expression Patterns.ps1"

$FolderIdImportedFromFile = Import-CliXml -Path "$PSScriptRoot\..\..\..\.CommonItems\FolderId.clixml"
${Is FolderId a GUID} = $FolderIdImportedFromFile -match ${regex literal GUID}
if (-not ${Is FolderId a GUID}) {
  Write-Host -Object "`$FolderId was NOT a guid. Deleting 'FolderId.clixml' file and exiting"
  Remove-Item -Path "$PSScriptRoot\..\..\..\.CommonItems\FolderId.clixml"
  break
}
#endregion
#region | Import variables into PowerShell 7 session via .clixml file |
$CliXmlFile = Get-ChildItem -Path "$PSScriptRoot\..\..\..\.CommonItems\Variables *.clixml" | Sort-Object | Select-Object -Last 1
$VariableHT = Import-CliXml -Path $CliXmlFile.FullName
foreach ($Ea in ($VariableHT.GetEnumerator() | Write-Output)) {
  $_Var_Name = $Ea.Name
  try {Clear-Variable -Name $_Var_Name -ErrorAction 'Stop'} catch {New-Variable -Name $_Var_Name -Value $null}
  Set-Variable -Name $_Var_Name -Value ($Ea.Value)
}
${Non-AD Forest creator Cnames} = ${CanonicalName Set Of Focus} | Where-Object -FilterScript {
  $_ -ne ${AD Forest Creator Mgmt Cname}
}
${Cname of AD Forest Originator} = ${CanonicalName Set Of Focus} | Where-Object -FilterScript {
  $_ -eq ${AD Forest Creator Mgmt Cname}
}
#endregion
#region | Replace characters incompatible across different types of objects |
${NetBIOS Name of Root Domain in AD Forest > upn-compatible} = ${NetBIOS Name of Root Domain in AD Forest} -replace '[\/\\\[\]\:\;\|\=\,\+\*\?\<\>\@\"]','-'

#endregion

#region | Local accounts with secure passwords that are never exposed in clear-text |
foreach ($cname in ${Non-AD Forest creator Cnames}) {
  foreach ($PrimaryGroupID in ${Primary Group ID Set Of Focus}) {
    $BitwardenUsername = "$cname $PrimaryGroupID"
    New-LocalUserAccountPassword -BitwardenUsername $BitwardenUsername -FolderId $FolderId -PasswordLength 80 -Verbose:$true
  }
}

# An additional account that can update the password for "$NodeMgmtCname 544" and vice-versa: 
foreach ($cname in ${Non-AD Forest creator Cnames}) {
  $BitwardenUsername = "$cname 220"
  New-LocalUserAccountPassword -BitwardenUsername $BitwardenUsername -FolderId $FolderId -PasswordLength 80 -Verbose:$true
}
#endregion
