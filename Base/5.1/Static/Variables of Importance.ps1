#region | Variables of Importance |
$MOFs               = "$env:DSC_CFG_ROOT\Managed Object Format Files"
$Statics            = "$env:DSC_CFG_ROOT\Statics"
$ResMod             = "$env:DSC_CFG_ROOT\DSC Resource Modules"
${Pre-PKI CertFSOs} = "$env:DSC_CFG_ROOT\Pre-PKI Certificate File-System Objects"

# Maximum envelope size (?) for WS-Management traffic. 
${WSMan MaxEnvelopeSizeKb} = (8192 * 4)

# for querying a WMI namespace for DSC |
$nsDsc = @{Namespace = 'root/Microsoft/Windows/DesiredStateConfiguration'}

# Common Application Policy OIDs ---> start msedge.exe 'https://www.pkisolutions.com/object-identifiers-oid-in-pki/'
$EKUs = [System.String[]]('Any Purpose','Attestation Identity Key Certificate','Certificate Request Agent','Client Authentication','Code Signing','CTL Usage','Digital Rights','Directory Service Email Replication','Disallowed List','Document Encryption','Document Signing','Domain Name System (DNS) Server Trust','Dynamic Code Generator','Early Launch Antimalware Driver','Embedded Windows System Component Verification','Encrypting File System','Endorsement Key Certificate','File Recovery','HAL Extension','IP security end system','IP security IKE intermediate','IP security tunnel termination','IP security user','KDC Authentication','Kernel Mode Code Signing','Key Recovery','Key Recovery Agent','License Server Verification','Lifetime Signing','Microsoft Publisher','Microsoft Time Stamping','Microsoft Trust List Signing','OCSP Signing','Platform Certificate','Preview Build Signing','Private Key Archival','Protected Process Light Verification','Protected Process Verification','Qualified Subordination','Revoked List Signer','Root List Signer','Secure Email','Server Authentication','Smart Card Logon','SpcEncryptedDigestRetryCount','SpcRelaxedPEMarkerCheck','Time Stamping','Windows Hardware Driver Attested Verification','Windows Hardware Driver Extended Verification','Windows Hardware Driver Verification','Windows Kits Component','Windows RT Verification','Windows Software Extension Verification','Windows Store','Windows System Component Verification','Windows TCB Component','Windows Third Party Application Component','Windows Update')
$EkuSet = [System.String[]]('Any Purpose','Attestation Identity Key Certificate','Certificate Request Agent','Client Authentication','Code Signing','CTL Usage','Digital Rights','Directory Service Email Replication','Disallowed List','Document Encryption','Document Signing','Domain Name System (DNS) Server Trust','Dynamic Code Generator','Early Launch Antimalware Driver','Embedded Windows System Component Verification','Encrypting File System','Endorsement Key Certificate','File Recovery','HAL Extension','IP security end system','IP security IKE intermediate','IP security tunnel termination','IP security user','KDC Authentication','Kernel Mode Code Signing','Key Recovery','Key Recovery Agent','License Server Verification','Lifetime Signing','Microsoft Publisher','Microsoft Time Stamping','Microsoft Trust List Signing','OCSP Signing','Platform Certificate','Preview Build Signing','Private Key Archival','Protected Process Light Verification','Protected Process Verification','Qualified Subordination','Revoked List Signer','Root List Signer','Secure Email','Server Authentication','Smart Card Logon','SpcEncryptedDigestRetryCount','SpcRelaxedPEMarkerCheck','Time Stamping','Windows Hardware Driver Attested Verification','Windows Hardware Driver Extended Verification','Windows Hardware Driver Verification','Windows Kits Component','Windows RT Verification','Windows Software Extension Verification','Windows Store','Windows System Component Verification','Windows TCB Component','Windows Third Party Application Component','Windows Update')

$AuthoredDscResourceModules = @(
  'AdHocInstantAdcsDsc'
)
$AuthoredDscResourceModuleZIPs = foreach ($AuthoredDscResourceModule in $AuthoredDscResourceModules) {
  $AuthoredDscResourceModule + '.zip'
}
$_Var_Name = 'AdHocInstantAdcsDsc Version'
try {Clear-Variable -Name $_Var_Name -ErrorAction 'Stop'} catch {New-Variable -Name $_Var_Name -Value $null -Description "Version of the class-based DSC Resource module titled AdHocInstantAdcsDsc" -ErrorAction 'SilentlyContinue'}
Set-Variable -Name $_Var_Name -Value ('0.4.0')

#region | ProductIds |
#region | Windows ADK | WinPE |
${Windows ADK 2026-09 ProductId} = '4f4f4626-ccb4-41ba-9c62-7ec9b0e113f3'
${WinPE 2026-09 ProductId}       = 'f567a246-97ac-4217-a1ba-020ced2a8187'
#endregion
#region | PowerShell 7 |
#region | 7.4 |
${PowerShell 7.4.22 ProductId} = ''
#endregion
#region | 7.5 |
${PowerShell 7.5.13 ProductId} = ''
#endregion
#region | 7.6 |
${PowerShell 7.6.10 ProductId} = '2E334F2C-291A-46DA-9D05-1697F697E04D'
#endregion
#region | 7.7 |
${PowerShell 7.7.0 ProductId} = ''
#endregion
#endregion
#endregion

#endregion

