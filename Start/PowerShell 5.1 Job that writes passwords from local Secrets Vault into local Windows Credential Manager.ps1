#Requires -Version 7.4
#Requires -PSEdition Core

Unlock-BwCli -Verbose
$FolderFQN = Import-CliXml -Path "$PSScriptRoot\..\..\.CommonItems\FolderFQN.clixml"

$QltFile = Get-ChildItem -Path "$PSScriptRoot\..\..\.CommonItems\Quick Lookup Table for $FolderFQN *.csv" `
| Sort-Object `
| Select-Object -Last 1
${Quick Lookup Table} = Import-Csv -Path $QltFile.FullName

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