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

#region | Domain Accounts > Accounts assigned to Active Directory security tier "$LabelTheta" |
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

<#
#>
#endregion
