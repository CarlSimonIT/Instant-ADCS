#region | RelativeID and CanonicalName Sets |

#region | Relative ID Sets | Elected Relative ID Sets |
$RelativeID_Set_00 = @(
  '544'     # Administrators
  '580'     # Remote Management Users
)
$RelativeID_Set_01 = @(
  '544'     # Administrators
  '580'     # Remote Management Users
  '551'     # Backup Operators
  '550'     # Print Operators
  '573'     # Event Log Readers
  '559'     # Performance Log Users
  '558'     # Performance Monitor Users
  '545'     # Users
)
$RelativeID_Set_02 = @(
  '544'     # Administrators
  '580'     # Remote Management Users
  '551'     # Backup Operators
  '545'     # Users
)
$RelativeID_Set_03 = @(
  '544'     # Administrators
  '580'     # Remote Management Users
  '551'     # Backup Operators
  '550'     # Print Operators
  '573'     # Event Log Readers
  '559'     # Performance Log Users
  '558'     # Performance Monitor Users
  '569'     # Cryptographic Operators
  '578'     # Hyper-V Administrators
  '556'     # Network Configuration Operators
  '582'     # Storage Replica Administrators
  '555'     # Remote Desktop Users
  '545'     # Users
)
$RelativeID_Set_04 = @(
  '544'     # Administrators
)
$RelativeID_Set_05 = @(
  '544'     # Administrators
  '580'     # Remote Management Users
  '551'     # Backup Operators
  '550'     # Print Operators
  '573'     # Event Log Readers
  '559'     # Performance Log Users
  '558'     # Performance Monitor Users
  '579'     # Access Control Assistance Operators
  '574'     # Certificate Service DCOM Access
  '569'     # Cryptographic Operators
  '583'     # Device Owners
  '562'     # Distributed COM Users
  '578'     # Hyper-V Administrators
  '556'     # Network Configuration Operators
  '585'     # OpenSSH Users
  '552'     # Replicator
  '582'     # Storage Replica Administrators
  '581'     # System Managed Accounts Group
  '584'     # User Mode Hardware Operators
  '547'     # Power Users
  '555'     # Remote Desktop Users
  '568'     # IIS_IUSRS
  '546'     # Guests
  '545'     # Users
)
$RelativeID_Set_06 = @(
  '500'     # Administrator
  '544'     # Administrators
  '580'     # Remote Management Users
)
#$RelativeID_Set_Of_Focus  = $RelativeID_Set_06
#$RelativeID_Set_Selection = $RelativeID_Set_00
${Relative ID Set A} = $RelativeID_Set_06
${Relative ID Set B} = $RelativeID_Set_00
#endregion



#region | Canonical Name Sets | Elected CNAME Sets |
$CnamesOfPhysicalMachines = [System.String[]] @(
  #region | Unclustered Hyper-V Hosts |
  ${DSC Authoring Station Mgmt Cname}
  #endregion
  #region | DSC WebServers that might or might not also act as an unclustered Hyper-V Host. We'll see what the budget allows.  |
  ${DSC WebServer Mgmt Cname}
  #endregion
  #region | Clustered Hyper-V hosts |
  'ServerA0'
  'ServerA1'
  #endregion
  #region | Dont yet know if I'll use these for Hyper-V. Possibly HA iSCSI storage. Either way, they're physical machines. |
  'ServerB0'
  'ServerB1'
  #endregion
) | Sort-Object | Get-Unique
$CnamesOfVirtualMachines  = [System.String[]] @(
  #region | Domain Controllers |
  ${AD Forest Creator Mgmt Cname}
  #endregion
  #region | DSC WebServers |
  'dscJava'
  'dscKFC'
  'dscLobster'
  #endregion
  #region | PKI |
  #region | Standalone Offline Root CA |
  ${Root CA Server Mgmt Cname}
  #endregion
  #region | Standalone Offline Policy CAs & their assocaited Issuing CAs |
  ${Policy CA1 Server Mgmt Cname}
  ${Leaf CA1 Server Mgmt Cname}
  ${Leaf CA2 Server Mgmt Cname}
  ${Leaf CA3 Server Mgmt Cname}

  ${Policy CA2 Server Mgmt Cname}
  ${End-Entity CA1 Server Mgmt Cname}
  ${End-Entity CA2 Server Mgmt Cname}
  #endregion
  #region | PKI Support |
  #$PkiInfoDistServerCname
  'pki0-cdp'
  'pki0-aia'
  #${PKI Support Server Cname}
  #endregion
  #region | Host(s) of Subordinate Certificate Authority 'A'. Probably wont need any 'B', 'C', or 'D' subordinate CAs, but the option is there.  |
  'pkiA-0'
  'pkiA-1'
  'pkiA-2'
  ## NAMING CONVENTION: the '-0' hosts the CA, '-1' hosts the AIA + CDP, and '-2' hosts whatever. 
  # 'pkiB-0','pkiB-1','pkiB-2'
  #endregion
  #region | Hosts of the Leaf CA that issues certificates |
  'pkiA0-0'
  'pkiA0-1'
  'pkiA0-2'
  #endregion
  #endregion
  #region | Unclustered servers configured to provide highly-available DHCP |
  ${DHCP Server 00 Mgmt Cname}
  #$DhcpServer01Cname
  #$DhcpServer02Cname
  #$DhcpServer03Cname
  'dhcpBagel'
  'dhcpChowder'
  'dhcpDill'
  #endregion
  #region | Unclustered File Server |
  'fsEggroll'
  'fsOrange'
  #endregion
  #region | text file-based DNS Servers |
  'dnsXigua'
  'dnsYam'
  'dnsZiti'
  #endregion
  #region | WSUS Root | WSUS Intermediary | WSUS Upload-2-Clients |
  'patchZero'
  'patchA-0'
  'patchA0-0'
  #endregion
  #region | Privileged Access Workstations |
  #$PrivAccWs00Cname
  #$PrivAccWs41Cname
  #$PrivAccWs88Cname
  #endregion
) | Sort-Object | Get-Unique
$CnamesOfClusterNameObjects = [System.String[]]@('fc0','fc1','fc2','fc3','fc4') | Sort-Object | Get-Unique

<#
  $CnamesOfPhysicalAndVirtualMachines = ($CnamesOfPhysicalMachines + $CnamesOfVirtualMachines) | Sort-Object | Get-Unique

  ${Cnames of non-DCs} = $CnamesOfPhysicalAndVirtualMachines | Where-Object -FilterScript {$_ -notmatch '^dc'}
  ${Cnames of non-DCs} = foreach ($Each in ${Cnames of non-DCs}) {
    $Each.SubString(0,[System.Math]::Min(16,$Each.Length))
  }
  ${DC Cnames} = @(
    $CnamesOfPhysicalAndVirtualMachines | Where-Object -FilterScript {$_ -match '^dc'}
  )
  ${DC Cnames and DomainNetBIOS Names} = @($CnamesOfPhysicalAndVirtualMachines | Where-Object -FilterScript {$_ -match '^dc'}) + @(${d0ma!n})
  ${DC Cnames and DomainNetBIOS Names} = foreach ($IndividualElement in ${DC Cnames and DomainNetBIOS Names}) {
    $IndividualElement.SubString(0,[System.Math]::Min(16,$IndividualElement.Length))
  }
#>

$CanonicalName_Set_00 = @(
  ${DSC Authoring Station Mgmt Cname}
  ${DSC WebServer Mgmt Cname}
  ${AD Forest Creator Mgmt Cname}
  ${DHCP Server 00 Mgmt Cname}
  ${Root CA Server Mgmt Cname}
  #$EnterpriseLeafCAServerCname
  #$PkiInfoDistServerCname
  'dscJava'
  'fsEggroll'
)
$CanonicalName_Set_01 = @(
  ${DSC Authoring Station Mgmt Cname}
  ${DSC WebServer Mgmt Cname}
  ${AD Forest Creator Mgmt Cname}
  ${DHCP Server 00 Mgmt Cname}
  ${Root CA Server Mgmt Cname}
  #$EnterpriseLeafCAServerCname
  #$PkiInfoDistServerCname
  #'dscJava'
  #'fsEggroll'
  #$PrivAccWs00Cname
)
$CanonicalName_Set_02 = @(
  ${DSC Authoring Station Mgmt Cname}
  #${DSC WebServer Mgmt Cname}
  ${AD Forest Creator Mgmt Cname}
  ${DHCP Server 00 Mgmt Cname}
  ${Root CA Server Mgmt Cname}
  #$EnterpriseLeafCAServerCname
  #$PkiInfoDistServerCname
  #'dscJava'
  #'fsEggroll'
)
$CanonicalName_Set_03 = @(
  ${DSC Authoring Station Mgmt Cname}
  ${DSC WebServer Mgmt Cname}
  ${AD Forest Creator Mgmt Cname}
  ${DHCP Server 00 Mgmt Cname}
  ${Root CA Server Mgmt Cname}
  #$EnterpriseLeafCAServerCname
  #$PkiInfoDistServerCname
  #'dscJava'
  #'fsEggroll'
  #$PrivAccWs00Cname
)
$CanonicalName_Set_04 = @(
  ${DSC Authoring Station Mgmt Cname}
  ${DSC WebServer Mgmt Cname}
  ${AD Forest Creator Mgmt Cname}
  ${DHCP Server 00 Mgmt Cname}
  ${Root CA Server Mgmt Cname}
  ${Policy CA1 Server Mgmt Cname}
  ${Policy CA2 Server Mgmt Cname}
  ${Leaf CA1 Server Mgmt Cname}
  ${Web PKI Support Mgmt Cname}
)

$CanonicalName_Set_For_NonClientAuth_SelfSignedCert_Ops    = $CanonicalName_Set_00
$CanonicalName_Set_For_ClientAuthSelfSignedCert_Operations = $CanonicalName_Set_01
#$CanonicalName_Set_Of_Focus    = $CanonicalName_Set_04
#$CanonicalName_Set_Of_Interest = $CanonicalName_Set_04
${CanonicalName Set A}  = $CanonicalName_Set_04
${CanonicalName Set B}  = $CanonicalName_Set_04
#endregion



#endregion

