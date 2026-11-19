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

#region | Passwords that protect certs not signed by a Certification Authority |
#region | Passwords to protect .pfx files of the cert signing cert, the code signing cert, and the DSC Pull Server cert |
<# NOTE |
  Prior to creating the PKI, all certs not signed by an in-house CA are signed by the Global Certificate Signer. 
  As such, only a single self-signed certificate is present in our environment: the Global Certificate Signer. 
  All other pre-PKI certificates are signed by the Global Certificate Signer. 
#>

<#
  $ObjectTitle = "Global Certificate Signer"
  New-PasswordForNonAccounts -ObjectTitle $ObjectTitle -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 96 -CheckAuthenticationStatus

  $ObjectTitle = "Global Code Signer"
  New-PasswordForNonAccounts -ObjectTitle $ObjectTitle -FolderId $FolderId -Verbose:$true -vv $true

  $ObjectTitle = "${DSC WebServer Mgmt Cname} DSC WebServer"
  New-PasswordForNonAccounts -ObjectTitle $ObjectTitle -FolderId $FolderId -Verbose:$true -vv $true
#>

$ObjectTitle = "pre-PKI Global Certificate Signer"
New-PasswordForNonAccounts -ObjectTitle $ObjectTitle -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 96 -CheckAuthenticationStatus

$ObjectTitle = "pre-PKI Global Code Signer"
New-PasswordForNonAccounts -ObjectTitle $ObjectTitle -FolderId $FolderId -Verbose:$true -vv $true

$ObjectTitle = "pre-PKI ${DSC WebServer Mgmt Cname} DSC WebServer"
New-PasswordForNonAccounts -ObjectTitle $ObjectTitle -FolderId $FolderId -Verbose:$true -vv $true

$ObjectTitle = "pre-PKI Event Log Protector"
New-PasswordForNonAccounts -ObjectTitle $ObjectTitle -FolderId $FolderId -Verbose:$true -vv $true
#endregion
#region | Passwords to protect .pfx files associated with certificates where EKU = 'Document Encryption' |
foreach ($cname in ${CanonicalName Set Of Focus}) {
  <# NOTE |
    Passwords for the protection of certificates that are specifically for the purpose of encrypting the .MOF file. 
    For reference, see 'https://learn.microsoft.com/en-us/powershell/dsc/pull-server/securemof?view=dsc-1.1#creating-the-certificate-on-the-authoring-node'
  #>
  $ObjectTitle = "pre-PKI PFX Protection;EKU=Document Encryption;LCM Host=$([System.Char]39)$cname$([System.Char]39)"
  New-PasswordForNonAccounts -ObjectTitle $ObjectTitle -FolderId $FolderId -Verbose:$true -vv $true

  $ObjectTitle = "pre-PKI PFX Protection;EKU=Document Encryption;Event Log Record Origin Point=$([System.Char]39)$cname$([System.Char]39)"
  New-PasswordForNonAccounts -ObjectTitle $ObjectTitle -FolderId $FolderId -Verbose:$true -vv $true
}
#endregion
#region | Passwords to protect .pfx files associated with certificates where EKU = 'Server Authentication' |
foreach ($cname in ${CanonicalName Set Of Focus}) {
  $ObjectTitle = "pre-PKI PFX Protection;EKU=Server Authentication;Target Machine=$([System.Char]39)$cname$([System.Char]39)"
  New-PasswordForNonAccounts -ObjectTitle $ObjectTitle -FolderId $FolderId -Verbose:$true -vv $true
}
#endregion
#region | Passwords to protect .pfx files associated with certificates where EKU = 'Client Authentication' |
foreach ($cname in ${Non-AD Forest creator Cnames}) {
  <# NOTE |
    '544' is the three right-most digits of the RID for the 'Administrators' group:
      (Get-LocalGroup -Name 'Administrators').SID
    More than one local admin should be present on a system to update the password of the other local admin. 
    For this reason the UserName of the 2nd local admin on a machine will end in '220'
    because '544' in hexadecimal is 0x220. 
  #>
  foreach ($PrimaryGroupID in (${Primary Group ID Set Selection} + '220')) {
    $ObjectTitle = "pre-PKI PFX Protection;EKU=Client Authentication;Local Account=$([System.Char]39)$cname $PrimaryGroupID$([System.Char]39)"
    New-PasswordForNonAccounts -ObjectTitle $ObjectTitle -FolderId $FolderId -Verbose:$true -vv $true
  }
}
foreach ($cname in ${Cname of AD Forest Originator}) {
  foreach ($PrimaryGroupID in (${Primary Group ID Set Selection} + '220')) {
    #$ObjectTitle = "pre-PKI PFX Protection;EKU=Client Authentication;Local Account=$([System.Char]39)${NetBIOS Name of Root Domain in AD Forest} $PrimaryGroupID$([System.Char]39)"
    $ObjectTitle = "pre-PKI PFX Protection;EKU=Client Authentication;Local Account=$([System.Char]39)${NetBIOS Name of Root Domain in AD Forest > upn-compatible} $PrimaryGroupID$([System.Char]39)"
    New-PasswordForNonAccounts -ObjectTitle $ObjectTitle -FolderId $FolderId -Verbose:$true -vv $true
  }
}
#endregion
#endregion

