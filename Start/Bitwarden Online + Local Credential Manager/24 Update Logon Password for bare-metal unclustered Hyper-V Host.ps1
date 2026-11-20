#Requires -Version 7.4
#Requires -PSEdition Core

Unlock-BwCli -Verbose
$FolderFQN = Import-CliXml -Path "$PSScriptRoot\..\..\..\.CommonItems\FolderFQN.clixml"

. "$PSScriptRoot\..\..\output\$FolderFQN\usb1\$FolderFQN\Base\5.1\Node Mgmt NetIPInterface CNAMEs.ps1"
. "$PSScriptRoot\..\..\output\$FolderFQN\usb1\$FolderFQN\Base\5.1\Type Accelerator Instance.ps1"
. "$PSScriptRoot\..\..\output\$FolderFQN\usb1\$FolderFQN\Base\5.1\Class Definitions\Quick Management Cname Conversions.ps1"

${Bitwarden Vault Item-Login.Username In Clear-Text} = [QuickMgmtCnameConversion]::Un(${DSC Authoring Station Mgmt Cname})
${Bitwarden Vault Item-Login.Password In Clear-Text} = Import-CliXml -Path "$PSScriptRoot\..\..\..\.CommonItems\BadPassword.clixml"
Write-Verbose -Message "`${Bitwarden Vault Item-Login.Username In Clear-Text} = ${Bitwarden Vault Item-Login.Username In Clear-Text}"
Write-Verbose -Message "`${Bitwarden Vault Item-Login.Password In Clear-Text} = ${Bitwarden Vault Item-Login.Password In Clear-Text}"

$QltFile = Get-ChildItem -Path "$PSScriptRoot\..\..\..\.CommonItems\Quick Lookup Table for $FolderFQN *.csv" `
| Sort-Object `
| Select-Object -Last 1

${Quick Lookup Table} = Import-Csv -Path $QltFile.FullName

${Bitwarden Vault Item} = ${Quick Lookup Table} | Where-Object -FilterScript {
  $_.UserName -eq ${Bitwarden Vault Item-Login.Username In Clear-Text}
}
${Bitwarden Vault Item-Id} = ${Bitwarden Vault Item} | Select-Object -ExpandProperty 'id'
${Bitwarden Vault Item-Name} = ${Bitwarden Vault Item} | Select-Object -ExpandProperty 'name'
${Bitwarden Vault Item-Notes} = ${Bitwarden Vault Item} | Select-Object -ExpandProperty 'notes'
Write-Host -Object "`${Bitwarden Vault Item-Id} = ${Bitwarden Vault Item-Id}"

$FolderId = Import-CliXml -Path "$PSScriptRoot\..\..\..\.CommonItems\FolderId.clixml"
# Save to separate variables the properties of the object that will eventually be used to define the edited Item in Bitwarden Password Manager: 
${bw item-id}             = '.id="%Bw_Item_Id%"'                         -replace '%Bw_Item_Id%',             ${Bitwarden Vault Item-Id}
${bw item-name}           = '.name="%Bw_Item_Name%"'                     -replace '%Bw_Item_Name%',           ${Bitwarden Vault Item-Name}
${bw item-login.username} = '.login.username="%Bw_Item_Login_Username%"' -replace '%Bw_Item_Login_Username%', ${Bitwarden Vault Item-Login.Username In Clear-Text}
${bw item-login.password} = '.login.password="%Bw_Item_Login_Password%"' -replace '%Bw_Item_Login_Password%', ${Bitwarden Vault Item-Login.Password In Clear-Text}
${bw item-notes}          = '.notes="%Bw_Item_Notes%"'                   -replace '%Bw_Item_Notes%',          ${Bitwarden Vault Item-Notes}
${bw item-folderId}       = '.folderId="%Item_FolderId%"'                -replace '%Item_FolderId%',          $FolderId

Write-Verbose -Message "With the attributes of the Item now saved to variable, write that Item into the Bitwarden Vault."
# start msedge.exe 'https://bitwarden.com/help/cli/#edit'
bw.exe get item ${Bitwarden Vault Item-Id} | jq.exe ${bw item-name} | jq.exe ${bw item-login.username} | jq.exe ${bw item-login.password} | jq.exe ${bw item-notes} | jq.exe ${bw item-folderId} | bw.exe encode | bw.exe edit item ${Bitwarden Vault Item-Id} > $null
Write-Verbose -Message "Write Operation Complete"
