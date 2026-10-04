#Requires -Version 7.4
#Requires -PSEdition Core

Unlock-BwCLI -Verbose
$FolderFQN = Import-CliXml -Path "$PSScriptRoot\..\..\.CommonItems\FolderFQN.clixml"
Write-Verbose -Message "Attempting to execute bw.exe sync"
bw.exe sync
Write-Verbose -Message "Executed bw.exe sync"
Write-Verbose -Message "Attempting to execute '`$FolderId = New-BitwardenVaultFolder -Verbose:`$true -Name `$FolderFQN -Check'"
$FolderId = New-BitwardenVaultFolder -Verbose:$true -Name $FolderFQN -Check
Write-Verbose -Message "Execution of '`$FolderId = New-BitwardenVaultFolder -Verbose:`$true -Name `$FolderFQN -Check' complete"
Write-Verbose -Message "`$FolderId = $FolderId"
Export-CliXml -Path "$PSScriptRoot\..\..\.CommonItems\FolderId.clixml" -InputObject ($FolderId)




#region | Import variables into PowerShell 7 session via .clixml file |
$CliXmlFile = Get-ChildItem -Path "$PSScriptRoot\..\..\.CommonItems\Variables *.clixml" | Sort-Object | Select-Object -Last 1
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



#region | Passwords that protect certs not signed by a Certification Authority |
#region | Passwords to protect .pfx files of the cert signing cert, the code signing cert, and the DSC Pull Server cert |
<#
  Prior to creating the PKI, all certs not signed by an in-house CA are signed by the Global Cert Signer. 
  As such, only a single self-signed certificate is present in our environment: the Global Cert Signer. 
  All other pre-PKI certificates are signed by the Global Cert Signer. 
#>
$ObjectTitle = "Global Cert Signer"
New-PasswordForNonAccounts -ObjectTitle $ObjectTitle -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 96 -CheckAuthenticationStatus

$ObjectTitle = "Global Code Signer"
New-PasswordForNonAccounts -ObjectTitle $ObjectTitle -FolderId $FolderId -Verbose:$true -vv $true

$ObjectTitle = "${DSC WebServer Mgmt Cname} DSC WebServer"
New-PasswordForNonAccounts -ObjectTitle $ObjectTitle -FolderId $FolderId -Verbose:$true -vv $true
#endregion
#region | Passwords to protect .pfx files associated with certificates where EKU = 'Document Encryption' |
foreach ($cname in ${CanonicalName Set Of Focus}) {
  # Passwords for the protection of certificates that are specifically for the purpose of encrypting the .MOF file. 
  # For reference, see 'https://learn.microsoft.com/en-us/powershell/dsc/pull-server/securemof?view=dsc-1.1#creating-the-certificate-on-the-authoring-node'
  $ObjectTitle = "PFX Protection;EKU=Document Encryption;LCM Host=$([System.Char]39)$cname$([System.Char]39)"
  New-PasswordForNonAccounts -ObjectTitle $ObjectTitle -FolderId $FolderId -Verbose:$true -vv $true
}
#endregion
#region | Passwords to protect .pfx files associated with certificates where EKU = 'Server Authentication' |
foreach ($cname in ${CanonicalName Set Of Focus}) {
  $ObjectTitle = "PFX Protection;EKU=Server Authentication;Target Machine=$([System.Char]39)$cname$([System.Char]39)"
  New-PasswordForNonAccounts -ObjectTitle $ObjectTitle -FolderId $FolderId -Verbose:$true -vv $true
}
#endregion
#region | Passwords to protect .pfx files associated with certificates where EKU = 'Client Authentication' |
foreach ($cname in ${Non-AD Forest creator Cnames}) {
  <#
    '544' is the three right-most digits of the RID for the 'Administrators' group:
    (Get-LocalGroup -Name 'Administrators').SID
    More than one local admin should be present on a system to update the password of the other local admin. 
    For this reason the UserName of the 2nd local admin on a machine will end in '220'
    because '544' in hexadecimal is 0x220. 
  #>
  foreach ($PrimaryGroupID in (${Primary Group ID Set Selection} + '220')) {
    $ObjectTitle = "PFX Protection;EKU=Client Authentication;Local Account=$([System.Char]39)$cname $PrimaryGroupID$([System.Char]39)"
    New-PasswordForNonAccounts -ObjectTitle $ObjectTitle -FolderId $FolderId -Verbose:$true -vv $true
  }
}
foreach ($cname in ${Cname of AD Forest Originator}) {
  foreach ($PrimaryGroupID in (${Primary Group ID Set Selection} + '220')) {
    $ObjectTitle = "PFX Protection;EKU=Client Authentication;Local Account=$([System.Char]39)${NetBIOS Name of Root Domain in AD Forest} $PrimaryGroupID$([System.Char]39)"
    New-PasswordForNonAccounts -ObjectTitle $ObjectTitle -FolderId $FolderId -Verbose:$true -vv $true
  }
}
#endregion
#endregion

#region | Passwords that protect .pfx files of Certification Authority certs |
$ObjectTitle = "PFX file password for ${Root CA Name} CA Certificate"
New-PasswordForNonAccounts -ObjectTitle $ObjectTitle -FolderId $FolderId -Verbose:$true -vv $true

$ObjectTitle = "PFX file password for ${Policy CA1 Name} CA Certificate"
New-PasswordForNonAccounts -ObjectTitle $ObjectTitle -FolderId $FolderId -Verbose:$true -vv $true

$ObjectTitle = "PFX file password for ${Policy CA2 Name} CA Certificate"
New-PasswordForNonAccounts -ObjectTitle $ObjectTitle -FolderId $FolderId -Verbose:$true -vv $true

$ObjectTitle = "PFX file password for ${Leaf CA1 Name} CA Certificate"
New-PasswordForNonAccounts -ObjectTitle $ObjectTitle -FolderId $FolderId -Verbose:$true -vv $true

$ObjectTitle = "PFX file password for ${Leaf CA2 Name} CA Certificate"
New-PasswordForNonAccounts -ObjectTitle $ObjectTitle -FolderId $FolderId -Verbose:$true -vv $true
#endregion









#region | Local accounts with unsecure passwords that are not intended for use outside of the initial early build phase |
<#
  IDEA: For the passwords directly above that are associated with a bare-metal instance, use a USB Rubber Ducky purchased from shop.hak5.org.
#>
foreach ($BitwardenUsername in ${Early Local Admin UserNames for OS Deploy}) {
  $HT = @{
    BitwardenUsername   = $BitwardenUsername
    FolderId            = $FolderId
    Verbose             = $true
    VerboseVerification = $true
    PasswordLength      = 80
  }
  New-LocalUserAccountPassword @HT
  #New-LocalUserAccountPassword -BitwardenUsername $BitwardenUsername -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 16
}
#endregion





#region | Local accounts with secure passwords that are never exposed in clear-text |
foreach ($cname in ${Non-AD Forest creator Cnames}) {
  foreach ($PrimaryGroupID in ${Primary Group ID Set Of Focus}) { # Yes, we do want the set 'Of Focus' |
    $BitwardenUsername = "$cname $PrimaryGroupID"
    New-LocalUserAccountPassword -BitwardenUsername $BitwardenUsername -FolderId $FolderId -PasswordLength 80 -Verbose:$true
  }
}

# An additional account that can update the password for "$NodeMgmtCname 544" and vice-versa.
foreach ($cname in ${Non-AD Forest creator Cnames}) {
  $BitwardenUsername = "$cname 220"
  New-LocalUserAccountPassword -BitwardenUsername $BitwardenUsername -FolderId $FolderId -PasswordLength 80 -Verbose:$true
}
#endregion

#region | Accounts that begin life as non-domain local accounts on an unpromoted instance of Windows Server that eventually creates the AD forest |
<#
  These Tier 0 accounts will eventually become DomainLocal accounts in AD once the OS is promoted to a DC. 
#>
#region | <READ ME> | Password for default built-in domain Administrator account | <READ ME> |
<# HIGHEST IMPORTANCE |
  The motivation for every single security measure 
  implemented in Active Directory traces back to 
  protecting this credential. 
  
  Whenever you have the opportunity to avoid authenticating
  against Active Directory with this username/password pair, 
  take it. 
#>
#region | Account exempt from Admin Approval Mode + holding membership in BUILTIN\Administrators/Domain Admins/Enterprise Admins | 500 544 512 519 |
$upn = "${NetBIOS Name of Root Domain in AD Forest} 500@${DNS Name of Root Domain in AD Forest}"
New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -PasswordLength 126 -CheckAuthenticationStatus
#endregion
#endregion
#region | Password for accounts holding membership in '.\Administrators' on an instance of Windows Server that eventually creates the AD Forest |
foreach ($PrimaryGroupID in (${Primary Group ID Set Selection} + '220')) { # Yes, we do want the set 'Selection' |
  $BitwardenUsername = "${NetBIOS Name of Root Domain in AD Forest} $PrimaryGroupID"
  New-LocalUserAccountPassword -BitwardenUsername $BitwardenUsername -FolderId $FolderId -PasswordLength 80 -Verbose:$true
}

#region | Password for an additional member of 'BUILTIN\Administrators' once the AD Forest has been created |
$BitwardenUsername = 'DC_LocalAdmin'
New-LocalUserAccountPassword -BitwardenUsername $BitwardenUsername -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
#endregion
#endregion
#endregion

#region | Domain Accounts > Accounts assigned to Active Directory security tier "$LabelGamma" |
$UpnSuffix = ${Upn Suffix Gamma}
#region | Accounts in the Active Directory database holding membership in a security group with a well-known SID/RID |
#region | Accounts holding membership in 'BUILTIN\Administrators', 'Domain Admins', and 'Enterprise Admins' | 544 512 519 |
$upn = "Emergency Administrator 0@$UpnSuffix"
New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80 -Notes "Break-glass Emergency Administrator 0"

$upn = "Emergency Administrator 1@$UpnSuffix"
New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80 -Notes "Break-glass Emergency Administrator 1"
#endregion
#region | Accounts only holding membership in 'BUILTIN\Administrators' | 544 |
$upn = "Domain Controller Local Admin 0@$UpnSuffix"
New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80

$upn = "Domain Controller Local Admin 1@$UpnSuffix"
New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
#endregion
#region | Accounts only holding membership in 'Enterprise Admins' | 519 |
$upn = "Enterprise Admin 0@$UpnSuffix"
New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80

$upn = "Enterprise Admin 1@$UpnSuffix"
New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
#endregion
#region | Accounts only holding membership in 'Domain Admins' | 512 |
$upn = "Domain Admin 0@$UpnSuffix"
New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80

$upn = "Domain Admin 1@$UpnSuffix"
New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
#endregion
#region | Accounts only holding membership in Account Operators | 548 |
$upn = "Account Operator 0@$UpnSuffix"
New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80

$upn = "Account Operator 1@$UpnSuffix"
New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
#endregion
#region | Accounts only holding membership in Schema Admins | 572 |
$upn = "Schema Admin 0@$UpnSuffix"
New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80

$upn = "Schema Admin 1@$UpnSuffix"
New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
#endregion
#region | Accounts only holding membership in Server Operators | 549 |
$upn = "Server Operator 0@$UpnSuffix"
New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80

$upn = "Server Operator 1@$UpnSuffix"
New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
#endregion
#region | Accounts only holding membership in Print Operators | 550 |
$upn = "Print Operator 0@$UpnSuffix"
New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80

$upn = "Print Operator 1@$UpnSuffix"
New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
#endregion
#region | Accounts only holding membership in Enterprise Key Admins | 527 |
$upn = "Enterprise Key Admin 0@$UpnSuffix"
New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80

$upn = "Enterprise Key Admin 1@$UpnSuffix"
New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
#endregion
#region | Accounts only holding membership in Key Admins | 526 |
$upn = "Key Admin 0@$UpnSuffix"
New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80

$upn = "Key Admin 1@$UpnSuffix"
New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
#endregion


#endregion
#region | Domain Accounts in a Restricted Group |
#region | Tier-scope |
#region | Accounts only holding membership in a Restricted Group that provides membership in the local '.\Administrators' group | 544 |
$upn = "Administrator 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
$upn = "Administrator 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
#endregion
#region | Accounts only holding membership in a Restricted Group that provides membership in the local '.\Users' group | 545 |
$upn = "User 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
$upn = "User 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
#endregion
#region | Accounts only holding membership in a Restricted Group that provides membership in the local '.\Guests' group | 546 |
$upn = "Guest 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
$upn = "Guest 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
#endregion
#region | Accounts only holding membership in a Restricted Group that provides membership in the local '.\Power Users' group | 547 |
$upn = "Power User 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
$upn = "Power User 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
#endregion
#region | Accounts only holding membership in a Restricted Group that provides membership in the local '.\Backup Operators' group | 551 |
$upn = "Backup Operator 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
$upn = "Backup Operator 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
#endregion
#region | Accounts only holding membership in a Restricted Group that provides membership in the local '.\Replicator' group | 552 |
$upn = "Replicator 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
$upn = "Replicator 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
#endregion
#region | Accounts only holding membership in a Restricted Group that provides membership in the local '.\Remote Desktop Users' group | 555 |
$upn = "Remote Desktop User 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
$upn = "Remote Desktop User 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
#endregion
#region | Accounts only holding membership in a Restricted Group that provides membership in the local '.\Network Configuration Operators' group | 556 |
$upn = "Network Configuration Operator 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
$upn = "Network Configuration Operator 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
#endregion
#region | Accounts only holding membership in a Restricted Group that provides membership in the local '.\Performance Monitor Users' group | 558 |
$upn = "Performance Monitor User 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
$upn = "Performance Monitor User 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
#endregion
#region | Accounts only holding membership in a Restricted Group that provides membership in the local '.\Performance Log Users' group | 559 |
$upn = "Performance Log User 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
$upn = "Performance Log User 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
#endregion
#region | Accounts only holding membership in a Restricted Group that provides membership in the local '.\Distributed COM Users' group | 562 |
$upn = "Distributed COM User 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
$upn = "Distributed COM User 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
#endregion
#region | Accounts only holding membership in a Restricted Group that provides membership in the local '.\Cryptographic Operators' group | 569 |
$upn = "Cryptographic Operator 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
$upn = "Cryptographic Operator 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
#endregion
#region | Accounts only holding membership in a Restricted Group that provides membership in the local '.\Event Log Readers' group | 573 |
$upn = "Event Log Reader 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
$upn = "Event Log Reader 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
#endregion
#region | Accounts only holding membership in a Restricted Group that provides membership in the local '.\Certificate Service DCOM Access' group | 574 |
$upn = "Certificate Service DCOM Access 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
$upn = "Certificate Service DCOM Access 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
#endregion
#region | Accounts only holding membership in a Restricted Group that provides membership in the local '.\Hyper-V Administrators' group | 578 |
$upn = "Hyper-V Administrator 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
$upn = "Hyper-V Administrator 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
#endregion
#region | Accounts only holding membership in a Restricted Group that provides membership in the local '.\Access Control Assistance Operators' group | 579 |
$upn = "Access Control Assistance Operator 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
$upn = "Access Control Assistance Operator 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
#endregion
#region | Accounts only holding membership in a Restricted Group that provides membership in the local '.\Remote Management Users' group | 580 |
$upn = "Remote Management User 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
$upn = "Remote Management User 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
#endregion
#region | Accounts only holding membership in a Restricted Group that provides membership in the local '.\Storage Replica Administrators' group | 582 |
$upn = "Storage Replica Administrator 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
$upn = "Storage Replica Administrator 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
#endregion
#region | Accounts only holding membership in a Restricted Group that provides membership in the local '.\Device Owners' group | 583 |
$upn = "Device Owner 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
$upn = "Device Owner 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
#endregion
#region | Accounts only holding membership in a Restricted Group that provides membership in the local '.\User Mode Hardware Operators' group | 584 |
$upn = "User Mode Hardware Operator 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
$upn = "User Mode Hardware Operator 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
#endregion
#region | Accounts only holding membership in a Restricted Group that provides membership in the local '.\OpenSSH Users' group | 585 |
$upn = "OpenSSH User 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
$upn = "OpenSSH User 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
#endregion
#endregion
#region | OU-scope |
$upn = "Secure Terminal Administrator 0@$upnSuffix"
New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80

$upn = "Secure Terminal Administrator 1@$upnSuffix"
New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
#endregion
#endregion
#region | Domain Accounts in a Custom Delegated Rights group |
#region | Group Administrator |
$upn = "Group Administrator 0@$upnSuffix"
New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80

$upn = "Group Administrator 1@$upnSuffix"
New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
#endregion
#region | Group Membership Manager |
$upn = "Group Membership Manager 0@$upnSuffix"
New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80

$upn = "Group Membership Manager 1@$upnSuffix"
New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
#endregion
#region | User Account Administrator |
$upn = "User Account Administrator 0@$upnSuffix"
New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80

$upn = "User Account Administrator 1@$upnSuffix"
New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
#endregion
#region | Password Reset Administrator |
$upn = "Password Reset Administrator 0@$upnSuffix"
New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80

$upn = "Password Reset Administrator 1@$upnSuffix"
New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
#endregion
#region | User Account Information Reader |
$upn = "User Account Information Reader 0@$upnSuffix"
New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80

$upn = "User Account Information Reader 1@$upnSuffix"
New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
#endregion
#region | Group Policy Link Administrator |
$upn = "Group Policy Link Administrator 0@$upnSuffix"
New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80

$upn = "Group Policy Link Administrator 1@$upnSuffix"
New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
#endregion
#region | RSOP Planner |
$upn = "RSOP Planner 0@$upnSuffix"
New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80

$upn = "RSOP Planner 1@$upnSuffix"
New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
#endregion
#region | RSOP Logger |
$upn = "RSOP Logger 0@$upnSuffix"
New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80

$upn = "RSOP Logger 1@$upnSuffix"
New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
#endregion
#region | WMI Filter Manager |
$upn = "WMI Filter Manager 0@$upnSuffix"
New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80

$upn = "WMI Filter Manager 1@$upnSuffix"
New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
#endregion
#region | Computer Object Creator |
$upn = "Computer Object Creator 0@$upnSuffix"
New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80

$upn = "Computer Object Creator 1@$upnSuffix"
New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
#endregion
#region | Workstation Joiner |
$upn = "Workstation Joiner 0@$UpnSuffix"
New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80

$upn = "Workstation Joiner 1@$UpnSuffix"
New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
#endregion
#region | Overprivileged Domain Joiner |
$upn = "Overprivileged Domain Joiner 0@$upnSuffix"
New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80

$upn = "Overprivileged Domain Joiner 1@$upnSuffix"
New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
#endregion
#endregion
#endregion

#region | Domain Accounts > Accounts assigned to Active Directory security tier "$LabelTheta" |
<#
  $UpnSuffix = ${Upn Suffix Theta}
  #region | Accounts in the Active Directory database holding membership in a security group with a well-known SID/RID |
  #region | Accounts only holding membership in Group Policy Creator Owners | 520 |
  $upn = "Group Policy Creator Owner 0@$UpnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80

  $upn = "Group Policy Creator Owner 1@$UpnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #region | Accounts only holding membership in Incoming Forest Trust Builders | 557 |
  # Are Incoming Forest Trust Builders classified as Tier 0 assets?
  $upn = "Incoming Forest Trust Builder 0@$UpnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80

  $upn = "Incoming Forest Trust Builder 1@$UpnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #region | Accounts only holding membership in Windows Authorization Access | 560 |
  # Are members of Windows Authorization Access Group classified as Tier 0 assets?
  $upn = "Windows Authorization Access Group Member 0@$UpnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80

  $upn = "Windows Authorization Access Group Member 1@$UpnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #endregion
  #region | Domain Accounts in a Restricted Group |
  #region | Tier-scope |
  #region | Accounts only holding membership in a Restricted Group that provides membership in the local '.\Administrators' group | 544 |
  $upn = "Administrator 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "Administrator 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #region | Accounts only holding membership in a Restricted Group that provides membership in the local '.\Users' group | 545 |
  $upn = "User 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "User 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #region | Accounts only holding membership in a Restricted Group that provides membership in the local '.\Guests' group | 546 |
  $upn = "Guest 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "Guest 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #region | Accounts only holding membership in a Restricted Group that provides membership in the local '.\Power Users' group | 547 |
  $upn = "Power User 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "Power User 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #region | Accounts only holding membership in a Restricted Group that provides membership in the local '.\Backup Operators' group | 551 |
  $upn = "Backup Operator 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "Backup Operator 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #region | Accounts only holding membership in a Restricted Group that provides membership in the local '.\Replicator' group | 552 |
  $upn = "Replicator 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "Replicator 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #region | Accounts only holding membership in a Restricted Group that provides membership in the local '.\Remote Desktop Users' group | 555 |
  $upn = "Remote Desktop User 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "Remote Desktop User 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #region | Accounts only holding membership in a Restricted Group that provides membership in the local '.\Network Configuration Operators' group | 556 |
  $upn = "Network Configuration Operator 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "Network Configuration Operator 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #region | Accounts only holding membership in a Restricted Group that provides membership in the local '.\Performance Monitor Users' group | 558 |
  $upn = "Performance Monitor User 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "Performance Monitor User 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #region | Accounts only holding membership in a Restricted Group that provides membership in the local '.\Performance Log Users' group | 559 |
  $upn = "Performance Log User 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "Performance Log User 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #region | Accounts only holding membership in a Restricted Group that provides membership in the local '.\Distributed COM Users' group | 562 |
  $upn = "Distributed COM User 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "Distributed COM User 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #region | Accounts only holding membership in a Restricted Group that provides membership in the local '.\Cryptographic Operators' group | 569 |
  $upn = "Cryptographic Operator 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "Cryptographic Operator 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #region | Accounts only holding membership in a Restricted Group that provides membership in the local '.\Event Log Readers' group | 573 |
  $upn = "Event Log Reader 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "Event Log Reader 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #region | Accounts only holding membership in a Restricted Group that provides membership in the local '.\Certificate Service DCOM Access' group | 574 |
  $upn = "Certificate Service DCOM Access 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "Certificate Service DCOM Access 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #region | Accounts only holding membership in a Restricted Group that provides membership in the local '.\Hyper-V Administrators' group | 578 |
  $upn = "Hyper-V Administrator 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "Hyper-V Administrator 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #region | Accounts only holding membership in a Restricted Group that provides membership in the local '.\Access Control Assistance Operators' group | 579 |
  $upn = "Access Control Assistance Operator 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "Access Control Assistance Operator 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #region | Accounts only holding membership in a Restricted Group that provides membership in the local '.\Remote Management Users' group | 580 |
  $upn = "Remote Management User 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "Remote Management User 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #region | Accounts only holding membership in a Restricted Group that provides membership in the local '.\Storage Replica Administrators' group | 582 |
  $upn = "Storage Replica Administrator 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "Storage Replica Administrator 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #region | Accounts only holding membership in a Restricted Group that provides membership in the local '.\Device Owners' group | 583 |
  $upn = "Device Owner 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "Device Owner 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #region | Accounts only holding membership in a Restricted Group that provides membership in the local '.\User Mode Hardware Operators' group | 584 |
  $upn = "User Mode Hardware Operator 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "User Mode Hardware Operator 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #region | Accounts only holding membership in a Restricted Group that provides membership in the local '.\OpenSSH Users' group | 585 |
  $upn = "OpenSSH User 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "OpenSSH User 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #endregion
  #region | OU-scope |
  $upn = "Secure Terminal Administrator 0@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80

  $upn = "Secure Terminal Administrator 1@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #endregion
  #region | Domain Accounts in a Custom Delegated Rights group |
  #region | Group Administrator |
  $upn = "Group Administrator 0@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80

  $upn = "Group Administrator 1@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #region | Group Membership Manager |
  $upn = "Group Membership Manager 0@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80

  $upn = "Group Membership Manager 1@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #region | User Account Administrator |
  $upn = "User Account Administrator 0@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80

  $upn = "User Account Administrator 1@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #region | Password Reset Administrator |
  $upn = "Password Reset Administrator 0@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80

  $upn = "Password Reset Administrator 1@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #region | User Account Information Reader |
  $upn = "User Account Information Reader 0@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80

  $upn = "User Account Information Reader 1@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #region | Group Policy Link Administrator |
  $upn = "Group Policy Link Administrator 0@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80

  $upn = "Group Policy Link Administrator 1@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #region | RSOP Planner |
  $upn = "RSOP Planner 0@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80

  $upn = "RSOP Planner 1@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #region | RSOP Logger |
  $upn = "RSOP Logger 0@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80

  $upn = "RSOP Logger 1@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #region | WMI Filter Manager |
  $upn = "WMI Filter Manager 0@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80

  $upn = "WMI Filter Manager 1@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #region | Computer Object Creator |
  $upn = "Computer Object Creator 0@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80

  $upn = "Computer Object Creator 1@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #region | Workstation Joiner |
  $upn = "Workstation Joiner 0@$UpnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80

  $upn = "Workstation Joiner 1@$UpnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #region | Overprivileged Domain Joiner |
  $upn = "Overprivileged Domain Joiner 0@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80

  $upn = "Overprivileged Domain Joiner 1@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #endregion
#>
#endregion

#region | Domain Accounts > Accounts assigned to Active Directory security tier "$LabelKappa" |
<#
  $UpnSuffix = ${Upn Suffix Kappa}
  #region | Accounts in the Active Directory database holding membership in a security group with a well-known SID/RID |
  #endregion
  #region | Domain Accounts in a Restricted Group |
  #region | Tier-scope |
  # Administrators | 544 |
  $upn = "Administrator 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "Administrator 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  # Users | 545 |
  $upn = "User 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "User 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  # Guests | 546 |
  $upn = "Guest 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "Guest 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  # Power Users | 547 |
  $upn = "Power User 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "Power User 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  # Backup Operators | 551 |
  $upn = "Backup Operator 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "Backup Operator 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  # Replicator | 552 |
  $upn = "Replicator 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "Replicator 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  # Remote Desktop Users | 555 |
  $upn = "Remote Desktop User 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "Remote Desktop User 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  # Network Configuration Operators | 556 |
  $upn = "Network Configuration Operator 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "Network Configuration Operator 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  # Performance Monitor Users | 558 |
  $upn = "Performance Monitor User 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "Performance Monitor User 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  # Performance Log Users | 559 |
  $upn = "Performance Log User 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "Performance Log User 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  # Distributed COM Users | 562 |
  $upn = "Distributed COM User 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "Distributed COM User 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  # Cryptographic Operators | 569 |
  $upn = "Cryptographic Operator 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "Cryptographic Operator 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  # Event Log Readers | 573 |
  $upn = "Event Log Reader 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "Event Log Reader 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  # Certificate Service DCOM Access | 574 |
  $upn = "Certificate Service DCOM Access 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "Certificate Service DCOM Access 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  # Hyper-V Administrators | 578 |
  $upn = "Hyper-V Administrator 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "Hyper-V Administrator 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  # Access Control Assistance Operators | 579 |
  $upn = "Access Control Assistance Operator 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "Access Control Assistance Operator 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  # Remote Management Users | 580 |
  $upn = "Remote Management User 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "Remote Management User 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  # Storage Replica Administrators | 582 |
  $upn = "Storage Replica Administrator 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "Storage Replica Administrator 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  # Device Owners | 583 |
  $upn = "Device Owner 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "Device Owner 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  # User Mode Hardware Operators | 584 |
  $upn = "User Mode Hardware Operator 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "User Mode Hardware Operator 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  # OpenSSH Users | 585 |
  $upn = "OpenSSH User 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "OpenSSH User 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #region | OU-scope |
  $upn = "Secure Terminal Administrator 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "Secure Terminal Administrator 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #endregion
  #region | Domain Accounts in a Custom Delegated Rights group |
  #region | Group Administrator |
  $upn = "Group Administrator 0@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80

  $upn = "Group Administrator 1@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #region | Group Membership Manager |
  $upn = "Group Membership Manager 0@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80

  $upn = "Group Membership Manager 1@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #region | User Account Administrator |
  $upn = "User Account Administrator 0@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80

  $upn = "User Account Administrator 1@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #region | Password Reset Administrator |
  $upn = "Password Reset Administrator 0@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80

  $upn = "Password Reset Administrator 1@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #region | User Account Information Reader |
  $upn = "User Account Information Reader 0@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80

  $upn = "User Account Information Reader 1@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #region | Group Policy Link Administrator |
  $upn = "Group Policy Link Administrator 0@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80

  $upn = "Group Policy Link Administrator 1@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #region | RSOP Planner |
  $upn = "RSOP Planner 0@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80

  $upn = "RSOP Planner 1@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #region | RSOP Logger |
  $upn = "RSOP Logger 0@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80

  $upn = "RSOP Logger 1@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #region | WMI Filter Manager |
  $upn = "WMI Filter Manager 0@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80

  $upn = "WMI Filter Manager 1@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #region | Computer Object Creator |
  $upn = "Computer Object Creator 0@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80

  $upn = "Computer Object Creator 1@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #region | Workstation Joiner |
  $upn = "Workstation Joiner 0@$UpnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80

  $upn = "Workstation Joiner 1@$UpnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #region | Overprivileged Domain Joiner |
  $upn = "Overprivileged Domain Joiner 0@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80

  $upn = "Overprivileged Domain Joiner 1@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #endregion
#>
#endregion

#region | Domain Accounts > Accounts assigned to Active Directory security tier "$LabelOmega" |
<#
  $UpnSuffix = ${Upn Suffix Omega}
  #region | Accounts in the Active Directory database holding membership in a security group with a well-known SID/RID |
  # n/a
  #endregion
  #region | Domain Accounts in a Restricted Group |
  #region | Tier-scope |
  # Administrators | 544 |
  $upn = "Administrator 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "Administrator 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  # Users | 545 |
  $upn = "User 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "User 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  # Guests | 546 |
  $upn = "Guest 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "Guest 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  # Power Users | 547 |
  $upn = "Power User 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "Power User 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  # Backup Operators | 551 |
  $upn = "Backup Operator 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "Backup Operator 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  # Replicator | 552 |
  $upn = "Replicator 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "Replicator 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  # Remote Desktop Users | 555 |
  $upn = "Remote Desktop User 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "Remote Desktop User 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  # Network Configuration Operators | 556 |
  $upn = "Network Configuration Operator 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "Network Configuration Operator 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  # Performance Monitor Users | 558 |
  $upn = "Performance Monitor User 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "Performance Monitor User 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  # Performance Log Users | 559 |
  $upn = "Performance Log User 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "Performance Log User 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  # Distributed COM Users | 562 |
  $upn = "Distributed COM User 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "Distributed COM User 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  # Cryptographic Operators | 569 |
  $upn = "Cryptographic Operator 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "Cryptographic Operator 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  # Event Log Readers | 573 |
  $upn = "Event Log Reader 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "Event Log Reader 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  # Certificate Service DCOM Access | 574 |
  $upn = "Certificate Service DCOM Access 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "Certificate Service DCOM Access 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  # Hyper-V Administrators | 578 |
  $upn = "Hyper-V Administrator 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "Hyper-V Administrator 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  # Access Control Assistance Operators | 579 |
  $upn = "Access Control Assistance Operator 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "Access Control Assistance Operator 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  # Remote Management Users | 580 |
  $upn = "Remote Management User 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "Remote Management User 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  # Storage Replica Administrators | 582 |
  $upn = "Storage Replica Administrator 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "Storage Replica Administrator 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  # Device Owners | 583 |
  $upn = "Device Owner 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "Device Owner 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  # User Mode Hardware Operators | 584 |
  $upn = "User Mode Hardware Operator 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "User Mode Hardware Operator 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  # OpenSSH Users | 585 |
  $upn = "OpenSSH User 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "OpenSSH User 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #region | OU-scope |
  $upn = "Secure Terminal Administrator 0@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  $upn = "Secure Terminal Administrator 1@$upnSuffix"; New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #endregion
  #region | Domain Accounts in a Custom Delegated Rights group |
  #region | Group Administrator |
  $upn = "Group Administrator 0@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80

  $upn = "Group Administrator 1@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #region | Group Membership Manager |
  $upn = "Group Membership Manager 0@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80

  $upn = "Group Membership Manager 1@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #region | User Account Administrator |
  $upn = "User Account Administrator 0@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80

  $upn = "User Account Administrator 1@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #region | Password Reset Administrator |
  $upn = "Password Reset Administrator 0@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80

  $upn = "Password Reset Administrator 1@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #region | User Account Information Reader |
  $upn = "User Account Information Reader 0@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80

  $upn = "User Account Information Reader 1@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #region | Group Policy Link Administrator |
  $upn = "Group Policy Link Administrator 0@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80

  $upn = "Group Policy Link Administrator 1@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #region | RSOP Planner |
  $upn = "RSOP Planner 0@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80

  $upn = "RSOP Planner 1@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #region | RSOP Logger |
  $upn = "RSOP Logger 0@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80

  $upn = "RSOP Logger 1@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #region | WMI Filter Manager |
  $upn = "WMI Filter Manager 0@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80

  $upn = "WMI Filter Manager 1@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #region | Computer Object Creator |
  $upn = "Computer Object Creator 0@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80

  $upn = "Computer Object Creator 1@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #region | Workstation Joiner |
  $upn = "Workstation Joiner 0@$UpnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80

  $upn = "Workstation Joiner 1@$UpnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #region | Overprivileged Domain Joiner |
  $upn = "Overprivileged Domain Joiner 0@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80

  $upn = "Overprivileged Domain Joiner 1@$upnSuffix"
  New-ADUserAccountPassword -UserPrincipalName $upn -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
  #endregion
  #endregion
#>
#endregion

#region | DSC Registration Keys |
<#
  New-DscRegistrationKey -Title 'IaC_CaC'
  #    $CredentialTitle = "IaC_CaC"; (cmdkey.exe /list:$CredentialTitle) | % {if ($_ -match '^(?<LeftHandSide>    User: )(?<RightHandSide>.+)$') {$RightHandSide = $Matches['RightHandSide']; $ArgumentList = @("/delete:$RightHandSide"); Start-Process -FilePath "$env:WinDir\System32\cmdkey.exe" -ArgumentList $ArgumentList}}
  New-DscRegistrationKey -Title 'Primordial_DSC_Push_Server'
  #    $CredentialTitle = "Primordial_DSC_Push_Server"; (cmdkey.exe /list:$CredentialTitle) | % {if ($_ -match '^(?<LeftHandSide>    User: )(?<RightHandSide>.+)$') {$RightHandSide = $Matches['RightHandSide']; $ArgumentList = @("/delete:$RightHandSide"); Start-Process -FilePath "$env:WinDir\System32\cmdkey.exe" -ArgumentList $ArgumentList}}
  New-DscRegistrationKey -Title 'New_AD_Forest'
  #    $CredentialTitle = "New_AD_Forest"; (cmdkey.exe /list:$CredentialTitle) | % {if ($_ -match '^(?<LeftHandSide>    User: )(?<RightHandSide>.+)$') {$RightHandSide = $Matches['RightHandSide']; $ArgumentList = @("/delete:$RightHandSide"); Start-Process -FilePath "$env:WinDir\System32\cmdkey.exe" -ArgumentList $ArgumentList}}
  New-DscRegistrationKey -Title 'DHCP_Server'
  #    $CredentialTitle = "DHCP_Server"; (cmdkey.exe /list:$CredentialTitle) | % {if ($_ -match '^(?<LeftHandSide>    User: )(?<RightHandSide>.+)$') {$RightHandSide = $Matches['RightHandSide']; $ArgumentList = @("/delete:$RightHandSide"); Start-Process -FilePath "$env:WinDir\System32\cmdkey.exe" -ArgumentList $ArgumentList}}
  New-DscRegistrationKey -Title 'Root_Certificate_Authority'
  #    $CredentialTitle = "Root_Certificate_Authority"; (cmdkey.exe /list:$CredentialTitle) | % {if ($_ -match '^(?<LeftHandSide>    User: )(?<RightHandSide>.+)$') {$RightHandSide = $Matches['RightHandSide']; $ArgumentList = @("/delete:$RightHandSide"); Start-Process -FilePath "$env:WinDir\System32\cmdkey.exe" -ArgumentList $ArgumentList}}
  New-DscRegistrationKey -Title 'Subordinate_Certificate_Authority'
  #    $CredentialTitle = "Subordinate_Certificate_Authority"; (cmdkey.exe /list:$CredentialTitle) | % {if ($_ -match '^(?<LeftHandSide>    User: )(?<RightHandSide>.+)$') {$RightHandSide = $Matches['RightHandSide']; $ArgumentList = @("/delete:$RightHandSide"); Start-Process -FilePath "$env:WinDir\System32\cmdkey.exe" -ArgumentList $ArgumentList}}
  New-DscRegistrationKey -Title 'Leaf_Certificate_Authority'
  #New-DscRegistrationKey -Title 'DSC_Child_WebServer'
  #New-DscRegistrationKey -Title 'SMB_File_Server'
  #New-DscRegistrationKey -Title 'PKI_Support_AIA_CDP'
  New-DscRegistrationKey -Title "Secure_Terminal_For_$($LabelGamma -replace ' ','_')_Objects"
  #    $CredentialTitle = "Secure_Terminal_For_$($LabelGamma -replace ' ','_')_Objects"; (cmdkey.exe /list:$CredentialTitle) | % {if ($_ -match '^(?<LeftHandSide>    User: )(?<RightHandSide>.+)$') {$RightHandSide = $Matches['RightHandSide']; $ArgumentList = @("/delete:$RightHandSide"); Start-Process -FilePath "$env:WinDir\System32\cmdkey.exe" -ArgumentList $ArgumentList}}
#>
#endregion

#region | Non-Windows Passwords |
#region | Network Devices > MikroTik |
$ObjectTitle = "MikroTik default admin"
New-PasswordForNonAccounts -ObjectTitle $ObjectTitle -FolderId $FolderId -PasswordLength 36

$ObjectTitle = "MikroTik Operator"
New-PasswordForNonAccounts -ObjectTitle $ObjectTitle -FolderId $FolderId -PasswordLength 36
#endregion
#region | Network Devices > Cisco |
#endregion
#endregion


