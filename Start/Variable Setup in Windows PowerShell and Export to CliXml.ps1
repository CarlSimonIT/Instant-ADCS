#Requires -Version 5.1
#Requires -PSEdition Desktop

$FolderFQN = Import-CliXml -Path "$PSScriptRoot\..\..\.CommonItems\FolderFQN.clixml"

. "$PSScriptRoot\..\output\$FolderFQN\usb1\$FolderFQN\Base\5.1\Lightweight Functions.ps1"
$TimeDate = Call-ISO8601TimeDate

$HT = [System.Collections.Hashtable]::New()

. "$PSScriptRoot\..\output\$FolderFQN\usb1\$FolderFQN\Base\5.1\AD Forest and Domain Naming.ps1"

$HT.Add('NetBIOS Name of Root Domain in AD Forest',${NetBIOS Name of Root Domain in AD Forest})
$HT.Add('DNS Name of Root Domain in AD Forest',${DNS Name of Root Domain in AD Forest})

. "$PSScriptRoot\..\output\$FolderFQN\usb1\$FolderFQN\Base\5.1\Node Mgmt NetIPInterface CNAMEs.ps1"
$HT.Add('DSC Authoring Station Mgmt Cname',${DSC Authoring Station Mgmt Cname})
$HT.Add('DSC WebServer Mgmt Cname',${DSC WebServer Mgmt Cname})
$HT.Add('AD Forest Creator Mgmt Cname',${AD Forest Creator Mgmt Cname})
$HT.Add('Replica DC 00 Mgmt Cname',${Replica DC 00 Mgmt Cname})
$HT.Add('Replica DC 01 Mgmt Cname',${Replica DC 01 Mgmt Cname})
$HT.Add('Read-Only DC 00 Mgmt Cname',${Read-Only DC 00 Mgmt Cname})
$HT.Add('Read-Only DC 01 Mgmt Cname',${Read-Only DC 01 Mgmt Cname})
$HT.Add('DHCP Server 00 Mgmt Cname',${DHCP Server 00 Mgmt Cname})
$HT.Add('DHCP Server 01 Mgmt Cname',${DHCP Server 01 Mgmt Cname})
$HT.Add('Root CA Server Mgmt Cname',${Root CA Server Mgmt Cname})
$HT.Add('Policy CA1 Server Mgmt Cname',${Policy CA1 Server Mgmt Cname})
$HT.Add('Leaf CA1 Server Mgmt Cname',${Leaf CA1 Server Mgmt Cname})
$HT.Add('Leaf CA2 Server Mgmt Cname',${Leaf CA2 Server Mgmt Cname})
$HT.Add('Leaf CA3 Server Mgmt Cname',${Leaf CA3 Server Mgmt Cname})
$HT.Add('Policy CA2 Server Mgmt Cname',${Policy CA2 Server Mgmt Cname})
$HT.Add('End-Entity CA1 Server Mgmt Cname',${End-Entity CA1 Server Mgmt Cname})
$HT.Add('End-Entity CA2 Server Mgmt Cname',${End-Entity CA2 Server Mgmt Cname})
$HT.Add('Web PKI Support Mgmt Cname',${Web PKI Support Mgmt Cname})
$HT.Add('Web PKI CRLDP Server Mgmt Cname',${Web PKI CRLDP Server Mgmt Cname})
$HT.Add('Web PKI OSCP Server Mgmt Cname',${Web PKI OSCP Server Mgmt Cname})
$HT.Add('Web PKI CAWE Server Mgmt Cname',${Web PKI CAWE Server Mgmt Cname})
$HT.Add('Web PKI NDES Server Mgmt Cname',${Web PKI NDES Server Mgmt Cname})

. "$PSScriptRoot\..\output\$FolderFQN\usb1\$FolderFQN\Base\5.1\Labels for Active Directory Security Tiers.ps1"
$HT.Add('Upn Suffix Gamma',${Upn Suffix Gamma})
$HT.Add('LabelGamma',$LabelGamma)
$HT.Add('Upn Suffix Theta',${Upn Suffix Theta})
$HT.Add('LabelTheta',$LabelTheta)
$HT.Add('Upn Suffix Kappa',${Upn Suffix Kappa})
$HT.Add('LabelKappa',$LabelKappa)
$HT.Add('Upn Suffix Omega',${Upn Suffix Omega})
$HT.Add('LabelOmega',$LabelOmega)

. "$PSScriptRoot\..\output\$FolderFQN\usb1\$FolderFQN\Base\5.1\Certification Authority CommonNames.ps1"
$HT.Add('Root CA Name',${Root CA Name})
$HT.Add('Policy CA1 Name',${Policy CA1 Name})
$HT.Add('Leaf CA1 Name',${Leaf CA1 Name})
$HT.Add('Leaf CA2 Name',${Leaf CA2 Name})
$HT.Add('Leaf CA3 Name',${Leaf CA3 Name})
$HT.Add('Policy CA2 Name',${Policy CA2 Name})
$HT.Add('End-Entity CA1 Name',${End-Entity CA1 Name})
$HT.Add('End-Entity CA2 Name',${End-Entity CA2 Name})

. "$PSScriptRoot\..\output\$FolderFQN\usb1\$FolderFQN\Base\5.1\RelativeID and CanonicalName Sets.ps1"
$HT.Add('CanonicalName Set Of Focus',${CanonicalName Set A})
$HT.Add('Primary Group ID Set Of Focus',${Relative ID Set A})
$HT.Add('Primary Group ID Set Selection',${Relative ID Set B})

. "$PSScriptRoot\..\output\$FolderFQN\usb1\$FolderFQN\Base\5.1\Type Accelerator Instance.ps1"
. "$PSScriptRoot\..\output\$FolderFQN\usb1\$FolderFQN\Base\5.1\Class Definitions\Quick Management Cname Conversions.ps1"

${Early Local Admin UserNames for OS Deploy} = foreach ($CanonicalName in ${CanonicalName Set A}) {
  [QuickMgmtCnameConversion]::Un($CanonicalName)
}
$HT.Add('Early Local Admin UserNames for OS Deploy',${Early Local Admin UserNames for OS Deploy})

$path = "$PSScriptRoot\..\..\.CommonItems\Variables $TimeDate.clixml"
$file = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'File' -Force}      
Export-CliXml -Path $path -InputObject ($HT)
