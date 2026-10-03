#Requires -Version 7.4
#Requires -PSEdition Core


$CliXmlFile = Get-ChildItem -Path "$PSScriptRoot\..\..\.CommonItems\FolderId and FolderFQN *.clixml" `
| Sort-Object `
| Select-Object -Last 1
# $CliXmlFile = Get-ChildItem -Path "C:\Users\pwdse\GitHub\CarlSimonIT\.CommonItems\FolderId and FolderFQN *.clixml" | Sort-Object | Select-Object -Last 1
$CliXmlHT = Import-CliXml -Path $CliXmlFile.FullName
foreach ($Ea in ($CliXmlHT.GetEnumerator() | Write-Output)) {
  $_Var_Name = $Ea.Name
  try {Clear-Variable -Name $_Var_Name -ErrorAction 'Stop'} catch {New-Variable -Name $_Var_Name -Value $null}
  Set-Variable -Name $_Var_Name -Value ($Ea.Value)
}


$QltFile = Get-ChildItem -Path "$PSScriptRoot\..\..\.CommonItems\Quick Lookup Table for $FolderFQN *.csv" `
| Sort-Object `
| Select-Object -Last 1
# $QltFile = Get-ChildItem -Path "C:\Users\pwdse\GitHub\CarlSimonIT\.CommonItems\Quick Lookup Table for $FolderFQN *.csv" | Sort-Object | Select-Object -Last 1
${Quick Lookup Table} = Import-Csv -Path $QltFile.FullName

Unlock-BwCli -Verbose

${Bitwarden Account Password Title} = "!Bitwarden Account Password-DELETE THIS"
$EncryptedObject = Get-StoredCredential -Target ${Bitwarden Account Password Title}
$EncryptedPassword = $EncryptedObject.Password
Unlock-SecretVault -Name $FolderFQN -Password $EncryptedPassword




foreach ($un in ${Quick Lookup Table}.UserName) {
  if (-not (Get-StoredCredential -Target $un)) {
    $HT = @{
      Target         = $un
      UserName       = $un
      SecurePassword = ${Quick Lookup Table}.Where({$_.username -eq $un}).id | Get-Secret -Vault $FolderFQN | Select-Object -ExpandProperty 'password'
      #Comment        = "No comment"
      Comment        = ${Quick Lookup Table}.Where({$_.username -eq $un}).notes
      Type           = "Generic"
      #Persist        = 'LocalMachine'
      Persist        = 'Session'
    }
    New-StoredCredential @HT
  }
}

<#

  foreach ($un in ${Quick Lookup Table}.UserName) {
    $HT = @{
      Target         = $un
      Type           = "Generic"
    }
    Remove-StoredCredential @HT
  }




#>