#Requires -Version 5.1
#Requires -PSEdition Desktop

param (
  [Parameter(
    Mandatory = $true
  )]
  [ValidatePattern(
    '^(?!(\d{1,15}|ANONYMOUS|BATCH|BUILTIN|DIALUP|DOMAIN|ENTERPRISE|INTERACTIVE|INTERNET|LOCAL|NETWORK|NULL|PROXY|RESTRICTED|SELF|SERVER|SERVICE|SYSTEM|USERS|WORLD)$)[a-z0-9][a-z0-9-]{1,13}[a-z0-9]$'
  )]
  [System.String]
  ${NetBIOS Name of Root Domain in AD Forest},

  [Parameter(
    Mandatory = $true
  )]
  [ValidatePattern(
    '^ad\.[0-9a-z-]{1,256}\.INTERNAL$'
  )]
  [System.String]
  ${DNS Name of Root Domain in AD Forest}
)

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

#region | Set variable values and construct profile.ps1 for Windows PowerShell |
#region | Constants for Organization Naming that are not directly related to IT operations |
${Registered Owner}        = "Registered Owner"
${Organization Name}       = "Organization Name"
${Organization Legal Name} = "Organization Legal Name, LLC"
${Registered Organization} = "registered-organization.info"
#endregion

# Set-ExecutionPolicy -ExecutionPolicy 'Unrestricted' -Scope 'CurrentUser'
# Set-Location -Path "$env:UserProfile\GitHub\CarlSimonIT\Instant-ADCS"

#region | Generate Windows PowerShell-compatible profile.ps1 file for Instant-ADCS | Copy supporting scripts into prep directory for usb1 |
#region | Import strings for uniquely identifying external media and prompt user if corresponding .clixml hasn't yet been generated |
$BaseNames = @(
  'usb0 FriendlyName'
  'usb0 UniqueId Raw'
  'usb0 SerialNumber'
  'usb1 FriendlyName'
  'usb1 UniqueId Raw'
  'usb1 SerialNumber'
)
foreach ($BaseName in $BaseNames) {
  $IsPresent = Test-Path -Path "$PSScriptRoot\..\..\.CommonItems\$BaseName.clixml"
  if (-not $IsPresent) {
    . powershell.exe -NoProfile -File "$PSScriptRoot\..\A0\Single Use\Obtain $BaseName.ps1"
  }

  $_Var_Name = $BaseName
  try {Clear-Variable -Name $_Var_Name -ErrorAction 'Stop'} catch {New-Variable -Name $_Var_Name -Value $null}
  Set-Variable -Name $_Var_Name -Value (
    Import-CliXml -Path "$PSScriptRoot\..\..\.CommonItems\$BaseName.clixml"
  )

}
#endregion

# Sanitize the user's input by eliminating single & double quotation marks. 
${usb0 FriendlyName} = ${usb0 FriendlyName} -replace $([System.Char]39),'' -replace $([System.Char]34),''
${usb0 UniqueId Raw} = ${usb0 UniqueId Raw} -replace $([System.Char]39),'' -replace $([System.Char]34),''
${usb0 SerialNumber} = ${usb0 SerialNumber} -replace $([System.Char]39),'' -replace $([System.Char]34),''
${usb1 FriendlyName} = ${usb1 FriendlyName} -replace $([System.Char]39),'' -replace $([System.Char]34),''
${usb1 UniqueId Raw} = ${usb1 UniqueId Raw} -replace $([System.Char]39),'' -replace $([System.Char]34),''
${usb1 SerialNumber} = ${usb1 SerialNumber} -replace $([System.Char]39),'' -replace $([System.Char]34),''

$HT = @{
  #region | External Storage Media |
  'usb0 FriendlyName' = ${usb0 FriendlyName}
  'usb0 UniqueId Raw' = ${usb0 UniqueId Raw}
  'usb0 SerialNumber' = ${usb0 SerialNumber}
  'usb1 FriendlyName' = ${usb1 FriendlyName}
  'usb1 UniqueId Raw' = ${usb1 UniqueId Raw}
  'usb1 SerialNumber' = ${usb1 SerialNumber}
  #endregion

  #region | Updated user-scope %path% variable |
  <#
    ScriptStoragePaths = $(
      "$env:Build_X\Base\5.1"
      $(Resolve-Path -Path "$env:Build_X\..\A0" | Select-Object -ExpandProperty 'Path')
    )
  #>
  #endregion

  #region | AD Forest and Domain Naming |
  'NetBIOS Name of Root Domain in AD Forest' = ${NetBIOS Name of Root Domain in AD Forest}
  'DNS Name of Root Domain in AD Forest'     = ${DNS Name of Root Domain in AD Forest}
  'AD Site Name'                             = '-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-'
  'AD Site Name A'                           = 'us-il-chicago-devlab-03'
  #endregion

  #region | Labels for Active Directory Security Tiers |
  'Upn Suffix Gamma' = 'architect-core.INTERNAL'
  LabelGamma         = 'Tier 0'
  'Upn Suffix Theta' = 'servers-mgmt.INTERNAL'
  LabelTheta         = 'Tier 3'
  'Upn Suffix Kappa' = 'support-staff.INTERNAL'
  LabelKappa         = 'Tier 6'
  'Upn Suffix Omega' = $((${Organization Name} -replace '[^a-z0-9-]','-').ToLower() + '.INTERNAL')
  LabelOmega         = 'Tier 9'
  #endregion

  #region | Constants for Organization Naming that are not directly related to IT operations |
  'Registered Owner'        = ${Registered Owner}
  'Organization Name'       = ${Organization Name}
  'Organization Legal Name' = ${Organization Legal Name}
  'Registered Organization' = ${Registered Organization}
  #endregion

  #region | Node Mgmt NetIPInterface CNAMEs |
  <# IMPORTANT |
    The Key for each Key-Value pair in this 'Node Mgmt NetIPInterface CNAMEs' 
    section MUST end in ' Mgmt Cname'. Other areas in Instant-ADCS rely on that pattern. 
  #>

  #region | DSC WebServer (aka the pull server) + DSC Authoring Station (aka the push server) |
  'DSC Authoring Station Mgmt Cname' = 'unclu-Hyper-V-Host-mgmt-apple'
  'DSC WebServer Mgmt Cname'         = 'configs-mgmt-bagel'
  #endregion

  #region | Domain Controllers |
  'AD Forest Creator Mgmt Cname' = 'dcZero-mgmt-avocado'
  'Replica DC 00 Mgmt Cname'     = 'read-write-DC-mgmt-crouton'
  'Replica DC 01 Mgmt Cname'     = 'Replica-DomainCtrl-mgmt-donut'
  'Read-Only DC 00 Mgmt Cname'   = 'RODC-mgmt-eggroll'
  'Read-Only DC 01 Mgmt Cname'   = 'read-only-DC-mgmt-fries'
  #endregion

  #region | DHCP Servers |
  'DHCP Server 00 Mgmt Cname' = 'mgmt-dhcp-banana'
  'DHCP Server 01 Mgmt Cname' = 'dhcp-chowder-mgmt'
  #endregion

  #region | Public Key Infrastructure |
  'Root CA Server Mgmt Cname' = 'pkiZero-mgmt'
  #region | Policy CA1 and associated subordinate CAs |
  'Policy CA1 Server Mgmt Cname' = 'pki-Gold-mgmt'
  'Leaf CA1 Server Mgmt Cname'   = 'Human-ID-mgmt'
  'Leaf CA2 Server Mgmt Cname'   = 'Endpoint-Computers-mgmt'
  'Leaf CA3 Server Mgmt Cname'   = 'Network-Devices-pki-mgmt'
  #endregion
  #region | Policy CA2 and associated subordinate CAs |
  'Policy CA2 Server Mgmt Cname'     = 'pki-Silver-mgmt'
  'End-Entity CA1 Server Mgmt Cname' = 'pki-User-Account-Validator'
  'End-Entity CA2 Server Mgmt Cname' = 'pki-Machine-Restriction-Enforcement'
  #endregion
  #region | Web Servers providing support services to the PKI |
  'Web PKI Support Mgmt Cname'      = 'pki-support-mgmt'
  'Web PKI CRLDP Server Mgmt Cname' = 'pki-support-CDP-mgmt'
  'Web PKI OSCP Server Mgmt Cname'  = 'pki-support-OSCP-mgmt'
  'Web PKI CAWE Server Mgmt Cname'  = 'pki-support-CAWE-mgmt'
  'Web PKI NDES Server Mgmt Cname'  = 'pki-support-NDES-mgmt'
  #endregion
  #endregion
  #endregion

  #region | Volume Letters on VM Instances |
  <#
    $adVol  = 'I:'
    $pkiVol = 'M:'
  #>
  #endregion

  #region | Storage Resiliency Reference |
  <#
    ${Physical Disk Size-Helium}    = '%_Physical Disk Size-Helium_%'
    ${Physical Disk Size-Neon}      = '%_Physical Disk Size-Neon_%'
    ${Physical Disk Size-Argon}     = '%_Physical Disk Size-Argon_%'
    ${Physical Disk Size-Krypton}   = '%_Physical Disk Size-Krypton_%'
    ${Physical Disk Size-Xenon}     = '%_Physical Disk Size-Xenon_%'
    ${Physical Disk Size-Radon}     = '%_Physical Disk Size-Radon_%'
    ${Physical Disk Size-Oganesson} = '%_Physical Disk Size-Oganesson_%'
  #>
  #endregion

  #region | Certification Authority CommonNames |
  'Root CA Name'        = 'axi0m'
  'Policy CA1 Name'     = 'Phobos Assurance S01'
  'Leaf CA1 Name'       = 'Users Validator G1'
  'Leaf CA2 Name'       = 'Devices Validator G1'
  'Leaf CA3 Name'       = 'Network Validator G1'
  'Policy CA2 Name'     = 'Deimos Trust S01'
  'End-Entity CA1 Name' = 'Sagittarius A* Global Edition Generation 1 Version 00'
  'End-Entity CA2 Name' = "Ascii$([System.Char]92) $([System.Char]47)utf7$([System.Char]58)-$([System.Char]42)ANSI$([System.Char]63) z$([System.Char]34)$([System.Char]60)$([System.Char]62)$([System.Char]124) Truncation$([System.Char]63)"
  #endregion

  #region | Location for output content inside '.\output' directory of project root |
  'New Windows PowerShell Base Folder PARTIAL Path' = ${New Windows PowerShell Base Folder PARTIAL Path}  
  #endregion
}

Push-Location -Path "$PSScriptRoot\..\Base\5.1"
.\Construct-WindowsPowerShellProfileDotPs1FileForAllUsersAllHosts.ps1 @HT
Pop-Location
#endregion

#endregion
