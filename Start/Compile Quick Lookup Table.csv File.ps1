#Requires -Version 7.4
#Requires -PSEdition Core

#region | Synchronize contents of 'Instant-ADCS' folder in online Bitwarden Vault down to local Secrets Vault |
Unlock-BwCli -Verbose

Write-Host -Object "  Synchronize contents of 'Instant-ADCS' folder in online Bitwarden Vault down to local Secrets Vault.`n  Synchronization to local Windows Credential Manager will take place shortly." -ForegroundColor ([System.ConsoleColor]::DarkCyan)

bw.exe sync
Write-Host -Object ""
#endregion



#region | Quick Lookup Table |
$CliXmlFile = Get-ChildItem -Path "$PSScriptRoot\..\..\.CommonItems\FolderId and FolderFQN *.clixml" `
| Sort-Object `
| Select-Object -Last 1
$CliXmlHT = Import-CliXml -Path $CliXmlFile.FullName
foreach ($Ea in ($CliXmlHT.GetEnumerator() | Write-Output)) {
  $_Var_Name = $Ea.Name
  try {Clear-Variable -Name $_Var_Name -ErrorAction 'Stop'} catch {New-Variable -Name $_Var_Name -Value $null}
  Set-Variable -Name $_Var_Name -Value ($Ea.Value)
}

${Quick Lookup Table Note Here-String} = @"

  Saving the 'username', 'id', 'name', and 'notes' attributes of each 
  Bitwarden object of type 'Item' located within the '$FolderFQN' 
  folder of the online Bitwarden Vault into the 
  'Quick Lookup Table for $FolderFQN.csv' file-system object...

"@
Write-Host -Object ${Quick Lookup Table Note Here-String} -ForegroundColor ([System.ConsoleColor]::Cyan)

$HT0 = @{Name = "username"; Expression = {$_.login.username}}
$HT1 = @{Name = "id"; Expression = {$_.id}}
$HT2 = @{Name = "name"; Expression = {$_.name}}
$HT3 = @{Name = "notes"; Expression = {$_.notes}}

$TimeDate = (Call-ISO8601TimeDateUTC).Replace(':','-')
#$QltFile = [System.IO.FileInfo]"$PSScriptRoot\..\..\.CommonItems\Quick Lookup Table for $FolderFQN.csv"
$QltFile = [System.IO.FileInfo]"$PSScriptRoot\..\..\.CommonItems\Quick Lookup Table for $FolderFQN $TimeDate.csv"

bw.exe list items --folderid $FolderID `
| ConvertFrom-Json `
| Where-Object -FilterScript {
  $_.name -match '^[a-z0-9]{52}$'
} `
| Select-Object id,name,login,notes `
| Select-Object $HT0,$HT1,$HT2,$HT3 `
| Sort-Object 'username' `
| Export-Csv -Path $QltFile.FullName -Force

#endregion


