#Requires -Version 5.1
#Requires -PSEdition Desktop

[CmdletBinding()]
param (
  #region | External Storage Media |
  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  ${usb0 FriendlyName},

  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  ${usb0 UniqueId Raw},

  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  ${usb0 SerialNumber},

  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  ${usb1 FriendlyName},

  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  ${usb1 UniqueId Raw},

  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  ${usb1 SerialNumber},

  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  ${OSDeploy FriendlyName},

  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  ${OSDeploy UniqueId Raw},

  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  ${OSDeploy SerialNumber},
  #endregion

  #region | PATH Environment Variable | Updated user-scope %path% variable |
  [Parameter(
    Mandatory = $false
  )]
  [System.String[]]
  $ScriptStoragePaths = $(
    "$env:Build_X\Base\5.1"
    $(Resolve-Path -Path "$PSScriptRoot\..\..\A0" | Select-Object -ExpandProperty 'Path')
  ),
  #endregion

  #region | AD Forest and Domain Naming |
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
  ${DNS Name of Root Domain in AD Forest},

  [Parameter(
    Mandatory = $true
  )]
  [ValidatePattern(
    '^[a-z0-9_-]{1,256}$'
  )]
  [System.String]
  ${AD Site Name},

  [Parameter(
    Mandatory = $true
  )]
  [ValidatePattern(
    '^[a-z0-9_-]{1,256}$'
  )]
  [System.String]
  ${AD Site Name A},
  #endregion

  #region | Labels for Active Directory Security Tiers |
  [Parameter(
    Mandatory = $false
  )]
  [ValidatePattern(
    '^Tier [0-9A-F]$'
  )]
  [System.String]
  $LabelGamma = 'Tier 0',

  [Parameter(
    Mandatory = $true
  )]
  [ValidatePattern(
    '^[0-9a-z-\.]{2,63}$'
  )]
  [System.String]
  ${Upn Suffix Gamma},

  [Parameter(
    Mandatory = $false
  )]
  [ValidatePattern(
    '^Tier [0-9A-F]$'
  )]
  [System.String]
  $LabelTheta = 'Tier 3',

  [Parameter(
    Mandatory = $true
  )]
  [ValidatePattern(
    '^[0-9a-z-\.]{2,63}$'
  )]
  [System.String]
  ${Upn Suffix Theta},

  [Parameter(
    Mandatory = $false
  )]
  [ValidatePattern(
    '^Tier [0-9A-F]$'
  )]
  [System.String]
  $LabelKappa = 'Tier 6',

  [Parameter(
    Mandatory = $true
  )]
  [ValidatePattern(
    '^[0-9a-z-\.]{2,63}$'
  )]
  [System.String]
  ${Upn Suffix Kappa},


  [Parameter(
    Mandatory = $false
  )]
  [ValidatePattern(
    '^Tier [0-9A-F]$'
  )]
  [System.String]
  $LabelOmega = 'Tier 9',

  [Parameter(
    Mandatory = $true
  )]
  [ValidatePattern(
    '^[0-9a-z-\.]{2,63}$'
  )]
  [System.String]
  ${Upn Suffix Omega},
  #endregion

  #region | Constants for Organization Naming that are not directly related to IT operations |
  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  ${Registered Owner},

  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  ${Organization Name},

  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  ${Organization Legal Name},

  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  ${Registered Organization},
  #endregion
  
  #region | Node Mgmt NetIPInterface CNAMEs |
  [Parameter(
    Mandatory = $true
  )]
  [ValidatePattern(
    '^[a-z0-9_-]{1,40}$'
  )]
  [System.String]
  ${DSC Authoring Station Mgmt Cname},

  [Parameter(
    Mandatory = $true
  )]
  [ValidatePattern(
    '^[a-z0-9_-]{1,40}$'
  )]
  [System.String]
  ${DSC WebServer Mgmt Cname},

  [Parameter(
    Mandatory = $true
  )]
  [ValidatePattern(
    '^[a-z0-9_-]{1,40}$'
  )]
  [System.String]
  ${AD Forest Creator Mgmt Cname},

  [Parameter(
    Mandatory = $true
  )]
  [ValidatePattern(
    '^[a-z0-9_-]{1,40}$'
  )]
  [System.String]
  ${Replica DC 00 Mgmt Cname},

  [Parameter(
    Mandatory = $true
  )]
  [ValidatePattern(
    '^[a-z0-9_-]{1,40}$'
  )]
  [System.String]
  ${Replica DC 01 Mgmt Cname},

  [Parameter(
    Mandatory = $true
  )]
  [ValidatePattern(
    '^[a-z0-9_-]{1,40}$'
  )]
  [System.String]
  ${Read-Only DC 00 Mgmt Cname},

  [Parameter(
    Mandatory = $true
  )]
  [ValidatePattern(
    '^[a-z0-9_-]{1,40}$'
  )]
  [System.String]
  ${Read-Only DC 01 Mgmt Cname},

  [Parameter(
    Mandatory = $true
  )]
  [ValidatePattern(
    '^[a-z0-9_-]{1,40}$'
  )]
  [System.String]
  ${DHCP Server 00 Mgmt Cname},

  [Parameter(
    Mandatory = $true
  )]
  [ValidatePattern(
    '^[a-z0-9_-]{1,40}$'
  )]
  [System.String]
  ${DHCP Server 01 Mgmt Cname},

  [Parameter(
    Mandatory = $true
  )]
  [ValidatePattern(
    '^[a-z0-9_-]{1,40}$'
  )]
  [System.String]
  ${Root CA Server Mgmt Cname},

  [Parameter(
    Mandatory = $true
  )]
  [ValidatePattern(
    '^[a-z0-9_-]{1,40}$'
  )]
  [System.String]
  ${Policy CA1 Server Mgmt Cname},

  [Parameter(
    Mandatory = $true
  )]
  [ValidatePattern(
    '^[a-z0-9_-]{1,40}$'
  )]
  [System.String]
  ${Leaf CA1 Server Mgmt Cname},

  [Parameter(
    Mandatory = $true
  )]
  [ValidatePattern(
    '^[a-z0-9_-]{1,40}$'
  )]
  [System.String]
  ${Leaf CA2 Server Mgmt Cname},

  [Parameter(
    Mandatory = $true
  )]
  [ValidatePattern(
    '^[a-z0-9_-]{1,40}$'
  )]
  [System.String]
  ${Leaf CA3 Server Mgmt Cname},

  [Parameter(
    Mandatory = $true
  )]
  [ValidatePattern(
    '^[a-z0-9_-]{1,40}$'
  )]
  [System.String]
  ${Policy CA2 Server Mgmt Cname},

  [Parameter(
    Mandatory = $true
  )]
  [ValidatePattern(
    '^[a-z0-9_-]{1,40}$'
  )]
  [System.String]
  ${End-Entity CA1 Server Mgmt Cname},

  [Parameter(
    Mandatory = $true
  )]
  [ValidatePattern(
    '^[a-z0-9_-]{1,40}$'
  )]
  [System.String]
  ${End-Entity CA2 Server Mgmt Cname},

  [Parameter(
    Mandatory = $true
  )]
  [ValidatePattern(
    '^[a-z0-9_-]{1,40}$'
  )]
  [System.String]
  ${Web PKI Support Mgmt Cname},

  [Parameter(
    Mandatory = $true
  )]
  [ValidatePattern(
    '^[a-z0-9_-]{1,40}$'
  )]
  [System.String]
  ${Web PKI CRLDP Server Mgmt Cname},

  [Parameter(
    Mandatory = $true
  )]
  [ValidatePattern(
    '^[a-z0-9_-]{1,40}$'
  )]
  [System.String]
  ${Web PKI OSCP Server Mgmt Cname},

  [Parameter(
    Mandatory = $true
  )]
  [ValidatePattern(
    '^[a-z0-9_-]{1,40}$'
  )]
  [System.String]
  ${Web PKI CAWE Server Mgmt Cname},

  [Parameter(
    Mandatory = $true
  )]
  [ValidatePattern(
    '^[a-z0-9_-]{1,40}$'
  )]
  [System.String]
  ${Web PKI NDES Server Mgmt Cname},
  #[Parameter(Mandatory = $true)][ValidatePattern('^[a-z0-9_-]{1,40}$')][System.String]${},
  #endregion

  #region | Volume Letters on VM Instances |
  [Parameter(
    Mandatory = $false
  )]
  [ValidatePattern(
    '^[A-Z]\:$'
  )]
  [System.String]
  $adVol = 'I:',

  [Parameter(
    Mandatory = $false
  )]
  [ValidatePattern(
    '^[A-Z]\:$'
  )]
  [System.String]
  $pkiVol = 'M:',
  #endregion

  #region | Storage Resiliency Reference |
  [Parameter(
    Mandatory = $false
  )]
  [System.Int64]
  ${Physical Disk Size-Helium} = 256GB,

  [Parameter(
    Mandatory = $false
  )]
  [System.Int64]
  ${Physical Disk Size-Neon} = 1024GB,

  [Parameter(
    Mandatory = $false
  )]
  [System.Int64]
  ${Physical Disk Size-Argon} = 512GB,

  [Parameter(
    Mandatory = $false
  )]
  [System.Int64]
  ${Physical Disk Size-Krypton} = 512GB,

  [Parameter(
    Mandatory = $false
  )]
  [System.Int64]
  ${Physical Disk Size-Xenon} = 512GB,

  [Parameter(
    Mandatory = $false
  )]
  [System.Int64]
  ${Physical Disk Size-Radon} = 512GB,

  [Parameter(
    Mandatory = $false
  )]
  [System.Int64]
  ${Physical Disk Size-Oganesson} = 512GB,
  #endregion

  #region | Certification Authority CommonNames |
  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  ${Root CA Name},

  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  ${Policy CA1 Name},

  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  ${Leaf CA1 Name},

  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  ${Leaf CA2 Name},

  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  ${Leaf CA3 Name},

  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  ${Policy CA2 Name},

  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  ${End-Entity CA1 Name},

  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  ${End-Entity CA2 Name},
  #endregion

  #region | Location for output content inside '.\output' directory of project root |
  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  ${New Windows PowerShell Base Folder PARTIAL Path}
  #endregion
)

#region | Instances from generalized precursors |
#region | External Storage + Bootable Media Drive Letters |
${External Storage + Bootable Media Drive Letters Precursor} = Get-Content -Path "$PSScriptRoot\Precursors\External Storage + Bootable Media Drive Letters Precursor.ps1"
${External Storage + Bootable Media Drive Letters} = ${External Storage + Bootable Media Drive Letters Precursor} `
  -replace '%_usb0 FriendlyName_%',${usb0 FriendlyName} `
  -replace '%_usb0 UniqueId Raw_%',${usb0 UniqueId Raw} `
  -replace '%_usb0 SerialNumber_%',${usb0 SerialNumber} `
  -replace '%_usb1 FriendlyName_%',${usb1 FriendlyName} `
  -replace '%_usb1 UniqueId Raw_%',${usb1 UniqueId Raw} `
  -replace '%_usb1 SerialNumber_%',${usb1 SerialNumber} `
  -replace '%_OSDeploy FriendlyName_%',${OSDeploy FriendlyName} `
  -replace '%_OSDeploy UniqueId Raw_%',${OSDeploy UniqueId Raw} `
  -replace '%_OSDeploy SerialNumber_%',${OSDeploy SerialNumber}
Set-Content -Path "$PSScriptRoot\..\..\${New Windows PowerShell Base Folder PARTIAL Path}\External Storage + Bootable Media Drive Letters.ps1" -Value (${External Storage + Bootable Media Drive Letters})
#endregion

#region | PATH Environment Variable | Updated user-scope %path% variable |
${ScriptStoragePaths Single String Raw} = $ScriptStoragePaths | Out-String
${PATH Environment Variable Precursor} = Get-Content -Path "$PSScriptRoot\Precursors\PATH Environment Variable Precursor.ps1"
${PATH Environment Variable} = ${PATH Environment Variable Precursor} `
  -replace '%_ScriptStoragePaths Single String Raw_%',${ScriptStoragePaths Single String Raw}
Set-Content -Path "$PSScriptRoot\..\..\${New Windows PowerShell Base Folder PARTIAL Path}\PATH Environment Variable.ps1" -Value (${PATH Environment Variable})
#endregion

#region | AD Forest and Domain Naming |
${AD Forest and Domain Naming Precursor} = Get-Content -Path "$PSScriptRoot\Precursors\AD Forest and Domain Naming Precursor.ps1"
${AD Forest and Domain Naming} = ${AD Forest and Domain Naming Precursor} `
  -replace '%_NetBIOS Name of Root Domain in AD Forest_%',${NetBIOS Name of Root Domain in AD Forest} `
  -replace '%_DNS Name of Root Domain in AD Forest_%',${DNS Name of Root Domain in AD Forest} `
  -replace '%_AD Site Name_%',${AD Site Name} `
  -replace '%_AD Site Name A_%',${AD Site Name A}
Set-Content -Path "$PSScriptRoot\..\..\${New Windows PowerShell Base Folder PARTIAL Path}\AD Forest and Domain Naming.ps1" -Value (${AD Forest and Domain Naming})
#endregion

#region | Labels for Active Directory Security Tiers |
${Labels for Active Directory Security Tiers Precursor} = Get-Content -Path "$PSScriptRoot\Precursors\Labels for Active Directory Security Tiers Precursor.ps1"
${Labels for Active Directory Security Tiers} = ${Labels for Active Directory Security Tiers Precursor} `
  -replace '%_Upn Suffix Gamma_%',${Upn Suffix Gamma} `
  -replace '%_Upn Suffix Theta_%',${Upn Suffix Theta} `
  -replace '%_Upn Suffix Kappa_%',${Upn Suffix Kappa} `
  -replace '%_Upn Suffix Omega_%',${Upn Suffix Omega} `
  -replace '%_LabelGamma_%',$LabelGamma `
  -replace '%_LabelTheta_%',$LabelTheta `
  -replace '%_LabelKappa_%',$LabelKappa `
  -replace '%_LabelOmega_%',$LabelOmega
Set-Content -Path "$PSScriptRoot\..\..\${New Windows PowerShell Base Folder PARTIAL Path}\Labels for Active Directory Security Tiers.ps1" -Value (${Labels for Active Directory Security Tiers})

#endregion

#region | Constants for Organization Naming that are not directly related to IT operations |
${Constants for Organization Naming that are not directly related to IT operations Precursor} = Get-Content -Path "$PSScriptRoot\Precursors\Constants for Organization Naming that are not directly related to IT operations Precursor.ps1"
${Constants for Organization Naming that are not directly related to IT operations} = ${Constants for Organization Naming that are not directly related to IT operations Precursor} `
  -replace '%_Registered Owner_%',${Registered Owner} `
  -replace '%_Organization Name_%',${Organization Name} `
  -replace '%_Organization Legal Name_%',${Organization Legal Name} `
  -replace '%_Registered Organization_%',${Registered Organization}
Set-Content -Path "$PSScriptRoot\..\..\${New Windows PowerShell Base Folder PARTIAL Path}\Constants for Organization Naming that are not directly related to IT operations.ps1" -Value (${Constants for Organization Naming that are not directly related to IT operations})
#endregion

#region | Node Mgmt NetIPInterface CNAMEs |
${Node Mgmt NetIPInterface CNAMEs Precursor} = Get-Content -Path "$PSScriptRoot\Precursors\Node Mgmt NetIPInterface CNAMEs Precursor.ps1"
${Node Mgmt NetIPInterface CNAMEs} = ${Node Mgmt NetIPInterface CNAMEs Precursor} `
  -replace '%_DSC Authoring Station Mgmt Cname_%',${DSC Authoring Station Mgmt Cname} `
  -replace '%_DSC WebServer Mgmt Cname_%',${DSC WebServer Mgmt Cname} `
  -replace '%_AD Forest Creator Mgmt Cname_%',${AD Forest Creator Mgmt Cname} `
  -replace '%_Replica DC 00 Mgmt Cname_%',${Replica DC 00 Mgmt Cname} `
  -replace '%_Replica DC 01 Mgmt Cname_%',${Replica DC 01 Mgmt Cname} `
  -replace '%_Read-Only DC 00 Mgmt Cname_%',${Read-Only DC 00 Mgmt Cname} `
  -replace '%_Read-Only DC 01 Mgmt Cname_%',${Read-Only DC 01 Mgmt Cname} `
  -replace '%_DHCP Server 00 Mgmt Cname_%',${DHCP Server 00 Mgmt Cname} `
  -replace '%_DHCP Server 01 Mgmt Cname_%',${DHCP Server 01 Mgmt Cname} `
  -replace '%_Root CA Server Mgmt Cname_%',${Root CA Server Mgmt Cname} `
  -replace '%_Policy CA1 Server Mgmt Cname_%',${Policy CA1 Server Mgmt Cname} `
  -replace '%_Leaf CA1 Server Mgmt Cname_%',${Leaf CA1 Server Mgmt Cname} `
  -replace '%_Leaf CA2 Server Mgmt Cname_%',${Leaf CA2 Server Mgmt Cname} `
  -replace '%_Leaf CA3 Server Mgmt Cname_%',${Leaf CA3 Server Mgmt Cname} `
  -replace '%_Policy CA2 Server Mgmt Cname_%',${Policy CA2 Server Mgmt Cname} `
  -replace '%_End-Entity CA1 Server Mgmt Cname_%',${End-Entity CA1 Server Mgmt Cname} `
  -replace '%_End-Entity CA2 Server Mgmt Cname_%',${End-Entity CA2 Server Mgmt Cname} `
  -replace '%_Web PKI Support Mgmt Cname_%',${Web PKI Support Mgmt Cname} `
  -replace '%_Web PKI CRLDP Server Mgmt Cname_%',${Web PKI CRLDP Server Mgmt Cname} `
  -replace '%_Web PKI OSCP Server Mgmt Cname_%',${Web PKI OSCP Server Mgmt Cname} `
  -replace '%_Web PKI CAWE Server Mgmt Cname_%',${Web PKI CAWE Server Mgmt Cname} `
  -replace '%_Web PKI NDES Server Mgmt Cname_%',${Web PKI NDES Server Mgmt Cname}
Set-Content -Path "$PSScriptRoot\..\..\${New Windows PowerShell Base Folder PARTIAL Path}\Node Mgmt NetIPInterface CNAMEs.ps1" -Value (${Node Mgmt NetIPInterface CNAMEs})
#endregion

#region | Volume Letters on VM Instances |
${Volume Letters on VM Instances Precursor} = Get-Content -Path "$PSScriptRoot\Precursors\Volume Letters on VM Instances Precursor.ps1"
${Volume Letters on VM Instances} = ${Volume Letters on VM Instances Precursor} `
  -replace '%_adVol_%',$adVol `
  -replace '%_pkiVol_%',$pkiVol
Set-Content -Path "$PSScriptRoot\..\..\${New Windows PowerShell Base Folder PARTIAL Path}\Volume Letters on VM Instances.ps1" -Value (${Volume Letters on VM Instances})
#endregion

#region | Storage Resiliency Reference |
${Storage Resiliency Reference Precursor} = Get-Content -Path "$PSScriptRoot\Precursors\Storage Resiliency Reference Precursor.ps1"
${Storage Resiliency Reference} = ${Storage Resiliency Reference Precursor} `
  -replace '%_Physical Disk Size-Helium_%',${Physical Disk Size-Helium} `
  -replace '%_Physical Disk Size-Neon_%',${Physical Disk Size-Neon} `
  -replace '%_Physical Disk Size-Argon_%',${Physical Disk Size-Argon} `
  -replace '%_Physical Disk Size-Krypton_%',${Physical Disk Size-Krypton} `
  -replace '%_Physical Disk Size-Xenon_%',${Physical Disk Size-Xenon} `
  -replace '%_Physical Disk Size-Radon_%',${Physical Disk Size-Radon} `
  -replace '%_Physical Disk Size-Oganesson_%',${Physical Disk Size-Oganesson}
Set-Content -Path "$PSScriptRoot\..\..\${New Windows PowerShell Base Folder PARTIAL Path}\Storage Resiliency Reference.ps1" -Value (${Storage Resiliency Reference})
#endregion

#region | Certification Authority CommonNames |
${Certification Authority CommonNames Precursor} = Get-Content -Path "$PSScriptRoot\Precursors\Certification Authority CommonNames Precursor.ps1"
${Certification Authority CommonNames} = ${Certification Authority CommonNames Precursor} `
  -replace '%_Root CA Name_%',${Root CA Name} `
  -replace '%_Policy CA1 Name_%',${Policy CA1 Name} `
  -replace '%_Leaf CA1 Name_%',${Leaf CA1 Name} `
  -replace '%_Leaf CA2 Name_%',${Leaf CA2 Name} `
  -replace '%_Leaf CA3 Name_%',${Leaf CA3 Name} `
  -replace '%_Policy CA2 Name_%',${Policy CA2 Name} `
  -replace '%_End-Entity CA1 Name_%',${End-Entity CA1 Name} `
  -replace '%_End-Entity CA1 Name_%',${End-Entity CA1 Name}
Set-Content -Path "$PSScriptRoot\..\..\${New Windows PowerShell Base Folder PARTIAL Path}\Certification Authority CommonNames.ps1" -Value (${Certification Authority CommonNames})
#endregion

#endregion

${Constructed Profile} = -join $(
  Get-Content -Raw -Path "$PSScriptRoot\Static\requires and StrictMode.ps1"
  Get-Content -Raw -Path "$PSScriptRoot\..\..\${New Windows PowerShell Base Folder PARTIAL Path}\External Storage + Bootable Media Drive Letters.ps1"
  Get-Content -Raw -Path "$PSScriptRoot\Static\Computer Info Lite.ps1"
  Get-Content -Raw -Path "$PSScriptRoot\Static\Define explorer.exe Owner variable.ps1"
  Get-Content -Raw -Path "$PSScriptRoot\..\..\${New Windows PowerShell Base Folder PARTIAL Path}\PATH Environment Variable.ps1"
  Get-Content -Raw -Path "$PSScriptRoot\Static\Other Env Vars not defined by DSC.ps1"
  Get-Content -Raw -Path "$PSScriptRoot\..\..\${New Windows PowerShell Base Folder PARTIAL Path}\AD Forest and Domain Naming.ps1"
  Get-Content -Raw -Path "$PSScriptRoot\..\..\${New Windows PowerShell Base Folder PARTIAL Path}\Labels for Active Directory Security Tiers.ps1"
  Get-Content -Raw -Path "$PSScriptRoot\..\..\${New Windows PowerShell Base Folder PARTIAL Path}\Constants for Organization Naming that are not directly related to IT operations.ps1"
  Get-Content -Raw -Path "$PSScriptRoot\..\..\${New Windows PowerShell Base Folder PARTIAL Path}\Node Mgmt NetIPInterface CNAMEs.ps1"
  Get-Content -Raw -Path "$PSScriptRoot\..\..\${New Windows PowerShell Base Folder PARTIAL Path}\Volume Letters on VM Instances.ps1"
  Get-Content -Raw -Path "$PSScriptRoot\Static\Type Accelerator Instance.ps1"
  Get-Content -Raw -Path "$PSScriptRoot\Class Definitions\Storage Spaces-Pooled Storage and Virtual Physical Disks.ps1"
  Get-Content -Raw -Path "$PSScriptRoot\..\..\${New Windows PowerShell Base Folder PARTIAL Path}\Storage Resiliency Reference.ps1"
  Get-Content -Raw -Path "$PSScriptRoot\Static\Windows ADK (Assessment and Deployment Kit) Versions and ProductIDs.ps1"
  Get-Content -Raw -Path "$PSScriptRoot\Static\Lightweight Functions.ps1"
  Get-Content -Raw -Path "$PSScriptRoot\Static\Important Variables.ps1"
  Get-Content -Raw -Path "$PSScriptRoot\Class Definitions\Virtual Local Area Network Titles and VLAN ID Map.ps1"
  Get-Content -Raw -Path "$PSScriptRoot\Class Definitions\Quick Management Cname Conversions.ps1"
  Get-Content -Raw -Path "$PSScriptRoot\Class Definitions\User Principal Name-to-SAM Account Name.ps1"
  Get-Content -Raw -Path "$PSScriptRoot\Class Definitions\Adapter Hardware Type.ps1"
  Get-Content -Raw -Path "$PSScriptRoot\Static\Regular Expression Patterns.ps1"
  Get-Content -Raw -Path "$PSScriptRoot\Static\Windows PowerShell in Action (3rd Ed.) Selections.ps1"
  Get-Content -Raw -Path "$PSScriptRoot\Static\Unimportant Variables.ps1"
  Get-Content -Raw -Path "$PSScriptRoot\Class Definitions\Windows Server Image Index.ps1"
  Get-Content -Raw -Path "$PSScriptRoot\Static\Registry Provider Paths.ps1"
  Get-Content -Raw -Path "$PSScriptRoot\..\..\${New Windows PowerShell Base Folder PARTIAL Path}\Certification Authority CommonNames.ps1"
  Get-Content -Raw -Path "$PSScriptRoot\Static\Location - Culture - Geography.ps1"
  Get-Content -Raw -Path "$PSScriptRoot\Static\RelativeID and CanonicalName Sets.ps1"

  Get-Content -Raw -Path "$PSScriptRoot\Static\Exercise Control Over Command Resolution.ps1"
  Get-Content -Raw -Path "$PSScriptRoot\Static\PowerShell Cookbook (4th Ed.) Selections.ps1"
  Get-Content -Raw -Path "$PSScriptRoot\Static\prompt(s).ps1"
  Get-Content -Raw -Path "$PSScriptRoot\Static\Final Set-Location.ps1"
)

#region | Copy supporting scripts into Base directory of usb1 prep directory for Windows PowerShell |
Copy-Item -Path "$PSScriptRoot\Class Definitions" -Destination "$PSScriptRoot\..\..\${New Windows PowerShell Base Folder PARTIAL Path}" -Recurse
Get-ChildItem -Path "$PSScriptRoot\Static" -File | ForEach-Object -Process {Copy-Item -Path $_.FullName -Destination "$PSScriptRoot\..\..\${New Windows PowerShell Base Folder PARTIAL Path}"}
#endregion

#region | Generate finished profile.ps1 file in Base directory of usb1 prep directory for Windows PowerShell |
${Constructed profile.ps1 File Path} = Join-Path -Path "$PSScriptRoot\..\..\${New Windows PowerShell Base Folder PARTIAL Path}" -ChildPath 'profile.ps1'
Set-Content -Path ${Constructed profile.ps1 File Path} -Value (${Constructed Profile})
#endregion