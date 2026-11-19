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

#region | Accounts that begin life as non-domain local accounts on an unpromoted instance of Windows Server that eventually creates the AD forest |
<# NOTE |
  These Tier 0 accounts will eventually become DomainLocal accounts in AD once the OS is promoted to a DC. 
#>
#region | <READ ME> | Password for default built-in domain Administrator account | <READ ME> |
#region | Account exempt from Admin Approval Mode + holding membership in BUILTIN\Administrators/Domain Admins/Enterprise Admins | 500 544 512 519 |
<# HIGHEST IMPORTANCE |
  Code immediately below generates a password for 
  the default built-in domain Administrator account
  in the root domain of the soon-to-be created 
  Active Directory forest. 

  Without exaggeration, the motivation for every 
  single conceivable security measure implemented in 
  AD traces back to protecting this credential. 
  
  Whenever you have the opportunity to avoid authenticating
  against Active Directory with this username/password pair, 
  take it. 
#>

$HT = @{
  #UserPrincipalName = "${NetBIOS Name of Root Domain in AD Forest} 500@${DNS Name of Root Domain in AD Forest}"
  UserPrincipalName = "${NetBIOS Name of Root Domain in AD Forest > upn-compatible} 500@${DNS Name of Root Domain in AD Forest}"
  FolderId          = $FolderId
  PasswordLength    = 126
  Check             = $true
}
New-ADUserAccountPassword @HT
#endregion
#endregion
#region | Password for accounts holding membership in '.\Administrators' on an instance of Windows Server that eventually creates the AD Forest |
foreach ($PrimaryGroupID in (${Primary Group ID Set Selection} + '220')) {
  #$BitwardenUsername = "${NetBIOS Name of Root Domain in AD Forest} $PrimaryGroupID"
  $BitwardenUsername = "${NetBIOS Name of Root Domain in AD Forest > upn-compatible} $PrimaryGroupID"
  New-LocalUserAccountPassword -BitwardenUsername $BitwardenUsername -FolderId $FolderId -PasswordLength 80 -Verbose:$true
}
#region | Password for an additional member of 'BUILTIN\Administrators' once the AD Forest has been created |
$BitwardenUsername = 'DC_LocalAdmin'
New-LocalUserAccountPassword -BitwardenUsername $BitwardenUsername -FolderId $FolderId -Verbose:$true -vv $true -PasswordLength 80
#endregion
#endregion
#endregion
