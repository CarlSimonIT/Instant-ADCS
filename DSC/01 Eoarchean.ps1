#Requires -Version 5.1
#Requires -PSEdition Desktop
#Requires -RunAsAdministrator

#region | Classes/Functions/Variables defined before launching a chronological unit |
$ProjectName = Import-Clixml -Path "$env:DSC_CFG_ROOT\CliXmls\FolderFQN.clixml";
#$ProjectName = "Instant-ADCS"
. "$env:DSC_CFG_ROOT\$ProjectName\A0\Set-FileAsWriteReadAndDelete.ps1"
${.s} = "$env:DSC_CFG_ROOT\$ProjectName\Dot-Sourced Structural Data"

. "$PSHOME\Lightweight Functions.ps1"
. "$PSHOME\Important Variables.ps1"
. "$PSHOME\Node Mgmt NetIPInterface CNAMEs.ps1"
. "$PSHOME\Type Accelerator Instance.ps1"
. "$PSHOME\Class Definitions\Windows Server Image Index.ps1"
. "$PSHOME\Class Definitions\Quick Management Cname Conversions.ps1"
. "$PSHOME\Regular Expression Patterns.ps1"
. "$PSHOME\Class Definitions\Virtual Local Area Network Titles and VLAN ID Map.ps1"
. "$PSHOME\PKI Misc.ps1"
. "$PSHOME\Labels for Active Directory Security Tiers.ps1"
. "$PSHOME\Location - Culture - Geography.ps1"
. "$PSHOME\Constants for Organization Naming that are not directly related to IT operations.ps1"
. "$PSHOME\Certification Authority CommonNames.ps1"
. "$PSHOME\Unimportant Variables.ps1"
. "$PSHOME\AD Forest and Domain Naming.ps1"
. "$PSHOME\File-based DNS Naming.ps1"
. "$PSHOME\RelativeID and CanonicalName Sets.ps1"
. "$PSHOME\Class Definitions\Adapter Hardware Type.ps1"
# $ConfigurationData frequently references the 
# 'Microsoft.PowerShell.Cmdletization.GeneratedTypes.NetIPInterface'
# namespace, which is provided by the 'NetTCPIP' module: 
$PSModuleInfo = Import-Module 'NetTCPIP' -PassThru -Force
. "$PSHOME\Class Definitions\Storage Spaces-Pooled Storage and Virtual Physical Disks.ps1"
#$PSModuleInfo = Import-Module 'Indented.Net.IP' -PassThru -Force
. "$PSHOME\Volume Letters on VM Instances.ps1"
. "$PSHOME\Class Definitions\User Principal Name-to-SAM Account Name.ps1"


$Host.PrivateData.DebugForegroundColor = $(rFc)
$Host.PrivateData.VerboseForegroundColor = $(rFc)

#     $error.Clear()
#endregion
#region | Set Dot-Sourced DSC Resource Instance File as Read/Write and Delete |
$Paths = $(
  "${.s}\Local Accounts and Group Membership.ps1"
  "${.s}\Strict PowerShell 5.1 Tracking.ps1"
  "${.s}\Event Logs-Activate Channels of Microsoft-Windows-Dsc Provider.ps1"
  "${.s}\Enable BuiltIn Administrator on instances of Desktop Experience.ps1"
  "${.s}\Environment Variable Definitions.ps1"
  "${.s}\Directory Tree inside DSC_CFG_ROOT.ps1"
  "${.s}\One-time Write of VM Switch UUID.ps1"
  "${.s}\Preboots Directory Set on DSC Authoring Station.ps1"
  
  "${.s}\One-time Selection of Mac Address Space and New Random %ComputerNames%.ps1"
  "${.s}\One-time Selection of Mac Address Space (4 bits) and New Random %ComputerNames%.ps1"
  "${.s}\One-time Selection of Mac Address Space (8 bits) and New Random %ComputerNames%.ps1"

  "${.s}\File-based Predefined non-Random Variables.ps1"
  "${.s}\WinRM Part 1-WS-Man Client Config, WinRM Windows Service, WS-Man Service Settings.ps1"
  "${.s}\NVMe Native Support on Server 2025-Enable.ps1"
  "${.s}\Windows ADK 2026-09-Archive Extraction.ps1"
  "${.s}\Windows ADK 2026-09-Offline Installation.ps1"
  "${.s}\WinPE 2026-09-Archive Extraction.ps1"
  "${.s}\WinPE 2026-09-Offline Installation.ps1"
  
  "${.s}\UAC (User Account Control) on instances of Desktop Experience.ps1"
  "${.s}\Power Plan on instances of Desktop Experience.ps1"
  "${.s}\Time Zone via DSC + System Time via GPO.ps1"
  "${.s}\Execution Policy-Multiple Scopes.ps1"
  "${.s}\Ransomware Deployment Protocol (RDP).ps1"
  "${.s}\IE Enhanced Security Configuration on instances of Desktop Experience.ps1"
  "${.s}\Catalog of pre-PKI X.509v3 Certificates.ps1"

  "${.s}\MAC Address Set v3 on Unclustered Hyper-V Host.ps1"
  "${.s}\One-time Write of VLAN Title and New Random VLAN ID.ps1"
  "${.s}\Immutable IPv4 Reservations.ps1"
  "${.s}\IPv4 Address Space Definitions.ps1"
  "${.s}\Sample Without Replacement Random IPv4 Addresses to Ensure Uniqueness.ps1"
  "${.s}\Formulate Default Gateway Components.ps1"
  
  "${.s}\Firewall-Allow Inbound HTTPS-secured WinRM.ps1"
  "${.s}\Permissions Entries of WMI Namespaces on Remote Machines.ps1"
  "${.s}\Non-System .vhdx File-System Objects.ps1"

  "${.s}\Update ComputerName.ps1"
  "${.s}\Reboot after ComputerName Update.ps1"
  "${.s}\Windows Features, Roles, and Role Services-! Blank DependsOn.ps1"
  "${.s}\WinRM Part 2-HTTPS-Protected PowerShell Remoting.ps1"

  "${.s}\Network Refined v2-Motherboard-connected Network Adapters ONLY.ps1"
  "${.s}\Virtual Switch Clade 00.ps1"
  "${.s}\VLAN Settings on Abstraction-based Network Adapter Connecting Parent Partition to External vSwitch.ps1"
  "${.s}\Network Refined v2-Abstraction-based Network Adapters ONLY.ps1"
  "${.s}\Hypervisor Config without Live Migration on UnClustered Hyper-V Host.ps1"

  "${.s}\Accumulated System VHDX Cascades-Block VHDX 2-Unique.ps1"
  "${.s}\VHDX Excluded from Storage Spaces Virtual Disk participation-DSC Configuration Root.ps1"
)
$Paths | ForEach-Object -Process {if (Test-Path -Path $_) {Set-FileAsWriteReadAndDelete -Path $_}}
#endregion
#region | Trackers |
$InstanceIndex = '01'; $InstanceChrono = 'Eoarchean'; $InstanceDesc = 'Hyper-V Host with VMs'
$InstanceName = 'x_' + $InstanceIndex + '_' + $InstanceChrono + '__' + $($InstanceDesc -replace '[^\w\.-]','_') # $($InstanceDesc -replace '\W','_') 
$InstanceFolderName = $InstanceIndex + ' ' + $InstanceChrono + ' ' + $InstanceDesc
${DSC ReRun ID} = [System.String]::Format('{0:yyyy}-{0:MMdd}-{0:HH}{0:mm}-{0:ss}',[System.DateTime]::Now)
#${DSC ReRun ID} = [System.String]::Format('{0:yyyy}-{0:MMdd}',[System.DateTime]::Now)
#${DSC ReRun ID} = [System.String]::Format('{0:yyyy}-{0:MM}',[System.DateTime]::Now)

$Configuration_Document_Instance_Name = $InstanceName + '.' + ${DSC ReRun ID}
#$Configuration_Document_Instance_Name = $InstanceName
$LCM_InstanceName = 'LCM_' + $InstanceIndex + '_' + $InstanceChrono + '__' + $($InstanceDesc -replace '[^\w\.-]','_') # $($InstanceDesc -replace '\W','_') 
#$LCM_Configuration_Document_Instance_Name = "LCM_" + $Configuration_Document_Instance_Name

$path = "$MOFs\$InstanceFolderName"; 
try {$OutputFolder = Get-Item -Path $path -ErrorAction 'Stop'} catch {$OutputFolder = New-Item -Path $path -ItemType 'Directory' -Force}
#endregion
#region | $ConfigurationData |
Write-Host -Object "Launching `${Define ConfigurationData Variable} scriptblock..." -ForegroundColor $(rFc) # -BackgroundColor $(rBc)
${Begin ConfigurationData Confirmation} = [System.DateTime]::Now
${Begin ConfigurationData Prep} = [System.DateTime]::Now

${Define ConfigurationData Variable Here-String Precursor File Path} = $(
  $parentFolder = [System.IO.DirectoryInfo](Resolve-Path -Path "${.s}\.." | Select-Object -ExpandProperty 'Path')
  "$parentFolder\Define ConfigurationData Variable Here-String File-System Object.ps1"
)
${Define ConfigurationData Variable Here-String Precursor} = Get-Content -Path ${Define ConfigurationData Variable Here-String Precursor File Path} -Raw

${Define ConfigurationData Variable Here-String} = ${Define ConfigurationData Variable Here-String Precursor} -replace '%_Configuration_Document_Instance_Name_%',$Configuration_Document_Instance_Name
${Define ConfigurationData Variable} = [ScriptBlock]::Create(${Define ConfigurationData Variable Here-String})
$Cycle0Start = [System.DateTime]::Now; $ConfigurationData = & ${Define ConfigurationData Variable}; $Cycle0End = [System.DateTime]::Now; Write-Host -Object "c0 $(($Cycle0End - $Cycle0Start).TotalSeconds.ToString('n3'))s" -ForegroundColor $(rFc) # -BackgroundColor $(rBc)
$Cycle1Start = [System.DateTime]::Now; $ConfigurationData = & ${Define ConfigurationData Variable}; $Cycle1End = [System.DateTime]::Now; Write-Host -Object "c1 $(($Cycle1End - $Cycle1Start).TotalSeconds.ToString('n3'))s" -ForegroundColor $(rFc) # -BackgroundColor $(rBc)
$Cycle2Start = [System.DateTime]::Now; $ConfigurationData = & ${Define ConfigurationData Variable}; $Cycle2End = [System.DateTime]::Now; Write-Host -Object "c2 $(($Cycle2End - $Cycle2Start).TotalSeconds.ToString('n3'))s" -ForegroundColor $(rFc) # -BackgroundColor $(rBc)
#$Cycle3Start = [System.DateTime]::Now; $ConfigurationData = & ${Define ConfigurationData Variable}; $Cycle3End = [System.DateTime]::Now; # Write-Host -Object "c3 $(($Cycle3End - $Cycle3Start).TotalSeconds.ToString('n3'))s" -ForegroundColor $(rFc) # -BackgroundColor $(rBc)
#$Cycle4Start = [System.DateTime]::Now; $ConfigurationData = & ${Define ConfigurationData Variable}; $Cycle4End = [System.DateTime]::Now; # Write-Host -Object "c4 $(($Cycle4End - $Cycle4Start).TotalSeconds.ToString('n3'))s" -ForegroundColor $(rFc) # -BackgroundColor $(rBc)
#$Cycle5Start = [System.DateTime]::Now; $ConfigurationData = & ${Define ConfigurationData Variable}; $Cycle5End = [System.DateTime]::Now; # Write-Host -Object "c5 $(($Cycle5End - $Cycle5Start).TotalSeconds.ToString('n3'))s" -ForegroundColor $(rFc) # -BackgroundColor $(rBc)
#$Cycle6Start = [System.DateTime]::Now; $ConfigurationData = & ${Define ConfigurationData Variable}; $Cycle6End = [System.DateTime]::Now; # Write-Host -Object "c6 $(($Cycle6End - $Cycle6Start).TotalSeconds.ToString('n3'))s" -ForegroundColor $(rFc) # -BackgroundColor $(rBc)
#$Cycle7Start = [System.DateTime]::Now; $ConfigurationData = & ${Define ConfigurationData Variable}; $Cycle7End = [System.DateTime]::Now; # Write-Host -Object "c7 $(($Cycle7End - $Cycle7Start).TotalSeconds.ToString('n3'))s" -ForegroundColor $(rFc) # -BackgroundColor $(rBc)
#$Cycle8Start = [System.DateTime]::Now; $ConfigurationData = & ${Define ConfigurationData Variable}; $Cycle8End = [System.DateTime]::Now; # Write-Host -Object "c8 $(($Cycle8End - $Cycle8Start).TotalSeconds.ToString('n3'))s" -ForegroundColor $(rFc) # -BackgroundColor $(rBc)
#$Cycle9Start = [System.DateTime]::Now; $ConfigurationData = & ${Define ConfigurationData Variable}; $Cycle9End = [System.DateTime]::Now; # Write-Host -Object "c9 $(($Cycle9End - $Cycle9Start).TotalSeconds.ToString('n3'))s" -ForegroundColor $(rFc) # -BackgroundColor $(rBc)
${Finish ConfigurationData Prep} = [System.DateTime]::Now
$ts = ${Finish ConfigurationData Prep} - ${Begin ConfigurationData Prep}
#Write-Host -Object "  Time to define `$ConfigurationData = $($ts.Minutes)m$($ts.Seconds)s" -ForegroundColor $(rFc) -BackgroundColor $(rBc)
#Write-Host -Object "        Time to define `$ConfigurationData = $($ts.Minutes)m$($ts.Seconds.ToString('n3'))s" -ForegroundColor $(rFc) # -BackgroundColor $(rBc)
Write-Host -Object "  Time to define `$ConfigurationData ---> $($ts.TotalSeconds.ToString('n3'))s" -ForegroundColor $(rFc) # -BackgroundColor $(rBc)
#endregion
#region | LCM |
${time_begin LCM} = [System.DateTime]::Now
#region | "Local Configuration Manager-Settings MetaResource with System account.ps1" |
$path = "${.s}\IL-System\Local Configuration Manager-Settings MetaResource with System account.ps1"
Set-ItemProperty -Path $path -Name 'IsReadOnly' -Value $true
#endregion
#region | "Local Configuration Manager-SignatureValidation MetaResource with System account.ps1" |
$path = "${.s}\IL-System\Local Configuration Manager-SignatureValidation MetaResource with System account.ps1"
Set-ItemProperty -Path $path -Name 'IsReadOnly' -Value $true
#endregion
#$LCM_InstanceName = 'LCM_01_Eoarchean__HyperV_Host_with_VMs'
[System.Management.Automation.DscLocalConfigurationManagerAttribute()] Configuration $LCM_InstanceName {
  Node $AllNodes.Where({
    $_.Life          -eq $true                -and `
    $_.SuperEmpire   -eq 'Microsoft'          -and `
    $_.Empire        -eq 'PM'                 -and `
    $_.SubEmpire     -eq 'Windows Server'     -and `
    $_.SuperDominion -match '^Yes'            -and `
    $_.Dominion      -eq 'Hyper-V'            -and `
    $_.Kingdom       -eq 'Non-HA'             -and `
    $_.Species       -eq 'Primordial Hyper-V Host'
  }).NodeName {
    . "${.s}\IL-System\Local Configuration Manager-Settings MetaResource with System account.ps1"
    . "${.s}\IL-System\Local Configuration Manager-SignatureValidation MetaResource with System account.ps1"
  }
}
$lcmHT = @{
  InstanceName      = $LCM_InstanceName
  OutputPath        = "$OutputFolder"
  ConfigurationData = $ConfigurationData
  Verbose           = $true
}
Invoke-Expression -Verbose:$true -Command "$LCM_InstanceName @lcmHT"
#LCM_01_Eoarchean__Hyper_V_Host_with_VMs @lcmHT
Set-DscLocalConfigurationManager -ComputerName $env:ComputerName -Path $lcmHT['OutputPath'] -Force
${time_end LCM} = [System.DateTime]::Now
$ts = ${time_end LCM} - ${time_begin LCM}; Write-Host -Object "  LCM $($ts.Minutes)m$($ts.Seconds)s" -ForegroundColor $(rFc) # -BackgroundColor $(rBc)
#endregion
#region | PreConfigurations |
#region | "Local Accounts and Group Membership.ps1" |
${Here-String Precursor} = Get-Content -Path "${.s}\IL-System\Local Accounts and Group Membership with System account.ps1"
${Here-String} = ${Here-String Precursor} `
  -replace '\s#PsDscRunAsCredential',' PsDscRunAsCredential'
$path = "${.s}\Local Accounts and Group Membership.ps1"
Set-Content -Path $path -ErrorAction 'SilentlyContinue' -Value ${Here-String}
Set-ItemProperty -Path $path -Name 'IsReadOnly' -Value $true
Remove-Variable -Name 'Here-String Precursor','Here-String'
#endregion
#region | "Strict PowerShell 5.1 Tracking.ps1" |
${Here-String Precursor} = Get-Content -Path "${.s}\IL-System\Strict PowerShell 5.1 Tracking with System account.ps1"
${Here-String} = ${Here-String Precursor} `
  -replace '\s#PsDscRunAsCredential',' PsDscRunAsCredential'
$path = "${.s}\Strict PowerShell 5.1 Tracking.ps1"
Set-Content -Path $path -ErrorAction 'SilentlyContinue' -Value ${Here-String}
Set-ItemProperty -Path $path -Name 'IsReadOnly' -Value $true
Remove-Variable -Name 'Here-String Precursor','Here-String'
#endregion
#region | "Event Logs-Activate Channels of Microsoft-Windows-Dsc Provider.ps1" |
${Here-String Precursor} = Get-Content -Path "${.s}\IL-System\Event Logs-Activate Channels of Microsoft-Windows-Dsc Provider with System account.ps1"
${Here-String} = ${Here-String Precursor} `
  -replace '\s#PsDscRunAsCredential',' PsDscRunAsCredential'
$path = "${.s}\Event Logs-Activate Channels of Microsoft-Windows-Dsc Provider.ps1"
Set-Content -Path $path -ErrorAction 'SilentlyContinue' -Value ${Here-String}
Set-ItemProperty -Path $path -Name 'IsReadOnly' -Value $true
Remove-Variable -Name 'Here-String Precursor','Here-String'
#endregion
#region | "Enable BuiltIn Administrator on instances of Desktop Experience.ps1" |
${Here-String Precursor} = Get-Content -Path "${.s}\IL-System\Enable BuiltIn Administrator on instances of Desktop Experience with System account.ps1"
${Here-String} = ${Here-String Precursor} `
  -replace '\s#PsDscRunAsCredential',' PsDscRunAsCredential'
$path = "${.s}\Enable BuiltIn Administrator on instances of Desktop Experience.ps1"
Set-Content -Path $path -ErrorAction 'SilentlyContinue' -Value ${Here-String}
Set-ItemProperty -Path $path -Name 'IsReadOnly' -Value $true
Remove-Variable -Name 'Here-String Precursor','Here-String'
#endregion
#region | "Environment Variable Definitions.ps1" |
${Here-String Precursor} = Get-Content -Path "${.s}\IL-System\Environment Variable Definitions with System account.ps1"
${Here-String} = ${Here-String Precursor} `
  -replace '\s#PsDscRunAsCredential',' PsDscRunAsCredential'
$path = "${.s}\Environment Variable Definitions.ps1"
Set-Content -Path $path -ErrorAction 'SilentlyContinue' -Value ${Here-String}
Set-ItemProperty -Path $path -Name 'IsReadOnly' -Value $true
Remove-Variable -Name 'Here-String Precursor','Here-String'
#endregion
#region | "Directory Tree inside DSC_CFG_ROOT.ps1" |
${Here-String Precursor} = Get-Content -Path "${.s}\IL-System\Directory Tree inside DSC_CFG_ROOT with System account.ps1"
${Here-String} = ${Here-String Precursor} `
  -replace '\s#PsDscRunAsCredential',' PsDscRunAsCredential' `
  -replace '\s#Credential',' Credential'
$path = "${.s}\Directory Tree inside DSC_CFG_ROOT.ps1"
Set-Content -Path $path -ErrorAction 'SilentlyContinue' -Value ${Here-String}
Set-ItemProperty -Path $path -Name 'IsReadOnly' -Value $true
Remove-Variable -Name 'Here-String Precursor','Here-String'
#endregion
#region | "Preboots Directory Set on DSC Authoring Station.ps1" |
${Here-String Precursor} = Get-Content -Path "${.s}\IL-System\Preboots Directory Set on DSC Authoring Station with System account.ps1"
${Here-String} = ${Here-String Precursor} `
  -replace '\s#PsDscRunAsCredential',' PsDscRunAsCredential' `
  -replace '\s#Credential',' Credential'
$path = "${.s}\Preboots Directory Set on DSC Authoring Station.ps1"
Set-Content -Path $path -ErrorAction 'SilentlyContinue' -Value ${Here-String}
Set-ItemProperty -Path $path -Name 'IsReadOnly' -Value $true
Remove-Variable -Name 'Here-String Precursor','Here-String'
#endregion
#region | "One-time Write of VM Switch UUID.ps1" |
${Here-String Precursor} = Get-Content -Path "${.s}\IL-System\One-time Write of VM Switch UUID with System account.ps1"
${Here-String} = ${Here-String Precursor} `
  -replace '\s#PsDscRunAsCredential',' PsDscRunAsCredential' `
  -replace '\s#Credential',' Credential'
$path = "${.s}\One-time Write of VM Switch UUID.ps1"
Set-Content -Path $path -ErrorAction 'SilentlyContinue' -Value ${Here-String}
Set-ItemProperty -Path $path -Name 'IsReadOnly' -Value $true
Remove-Variable -Name 'Here-String Precursor','Here-String'
#endregion

#region | "One-time Selection of Mac Address Space and New Random %ComputerNames%.ps1" |
${Here-String Precursor} = Get-Content -Path "${.s}\IL-System\One-time Selection of Mac Address Space and New Random %ComputerNames% with System account.ps1"
${Here-String} = ${Here-String Precursor} `
  -replace '\s#PsDscRunAsCredential',' PsDscRunAsCredential' `
  -replace '\s#Credential',' Credential'
$path = "${.s}\One-time Selection of Mac Address Space and New Random %ComputerNames%.ps1"
Set-Content -Path $path -ErrorAction 'SilentlyContinue' -Value ${Here-String}
Set-ItemProperty -Path $path -Name 'IsReadOnly' -Value $true
Remove-Variable -Name 'Here-String Precursor','Here-String'
#endregion
#region | "One-time Selection of Mac Address Space (4 bits) and New Random %ComputerNames%.ps1" |
${Here-String Precursor} = Get-Content -Path "${.s}\IL-System\One-time Selection of Mac Address Space (4 bits) and New Random %ComputerNames% with System account.ps1"
${Here-String} = ${Here-String Precursor} `
  -replace '\s#PsDscRunAsCredential',' PsDscRunAsCredential' `
  -replace '\s#Credential',' Credential'
$path = "${.s}\One-time Selection of Mac Address Space (4 bits) and New Random %ComputerNames%.ps1"
Set-Content -Path $path -ErrorAction 'SilentlyContinue' -Value ${Here-String}
Set-ItemProperty -Path $path -Name 'IsReadOnly' -Value $true
Remove-Variable -Name 'Here-String Precursor','Here-String'
#endregion
#region | "One-time Selection of Mac Address Space (8 bits) and New Random %ComputerNames%.ps1" |
${Here-String Precursor} = Get-Content -Path "${.s}\IL-System\One-time Selection of Mac Address Space (8 bits) and New Random %ComputerNames% with System account.ps1"
${Here-String} = ${Here-String Precursor} `
  -replace '\s#PsDscRunAsCredential',' PsDscRunAsCredential' `
  -replace '\s#Credential',' Credential'
$path = "${.s}\One-time Selection of Mac Address Space (8 bits) and New Random %ComputerNames%.ps1"
Set-Content -Path $path -ErrorAction 'SilentlyContinue' -Value ${Here-String}
Set-ItemProperty -Path $path -Name 'IsReadOnly' -Value $true
Remove-Variable -Name 'Here-String Precursor','Here-String'
#endregion
#region | "File-based Predefined non-Random Variables.ps1" |
${Here-String Precursor} = Get-Content -Path "${.s}\IL-System\File-based Predefined non-Random Variables with System account.ps1"
${Here-String} = ${Here-String Precursor} `
  -replace '\s#PsDscRunAsCredential',' PsDscRunAsCredential' `
  -replace '\s#Credential',' Credential'
$path = "${.s}\File-based Predefined non-Random Variables.ps1"
Set-Content -Path $path -ErrorAction 'SilentlyContinue' -Value ${Here-String}
Set-ItemProperty -Path $path -Name 'IsReadOnly' -Value $true
Remove-Variable -Name 'Here-String Precursor','Here-String'
#endregion
#region | "WinRM Part 1-WS-Man Client Config, WinRM Windows Service, WS-Man Service Settings.ps1" |
${Here-String Precursor} = Get-Content -Path "${.s}\IL-System\WinRM Part 1-WS-Man Client Config, WinRM Windows Service, WS-Man Service Settings with System account.ps1"
${Here-String} = ${Here-String Precursor} -replace '\s#PsDscRunAsCredential',' PsDscRunAsCredential'
# Don't implement this 'Credential' attribute for the xService resource 
# Incompatible with the 'BuiltInAccount' attribute. 
# ${Here-String} = ${Here-String Precursor} -replace '\s#PsDscRunAsCredential',' PsDscRunAsCredential' -replace '\s#Credential',' Credential'
$path = "${.s}\WinRM Part 1-WS-Man Client Config, WinRM Windows Service, WS-Man Service Settings.ps1"
Set-Content -Path $path -ErrorAction 'SilentlyContinue' -Value ${Here-String}
Set-ItemProperty -Path $path -Name 'IsReadOnly' -Value $true
Remove-Variable -Name 'Here-String Precursor','Here-String'


#endregion
#region | "NVMe Native Support on Server 2025-Enable.ps1" |
${Here-String Precursor} = Get-Content -Path "${.s}\IL-System\NVMe Native Support on Server 2025-Enable with System account.ps1"
${Here-String} = ${Here-String Precursor} `
  -replace '\s#PsDscRunAsCredential',' PsDscRunAsCredential'
$path = "${.s}\NVMe Native Support on Server 2025-Enable.ps1"
Set-Content -Path $path -ErrorAction 'SilentlyContinue' -Value ${Here-String}
Set-ItemProperty -Path $path -Name 'IsReadOnly' -Value $true
Remove-Variable -Name 'Here-String Precursor','Here-String'
#endregion

#region | "Windows ADK 2026-09-Archive Extraction.ps1" |
${Here-String Precursor} = Get-Content -Path "${.s}\IL-System\Windows ADK 2026-09-Archive Extraction with System account.ps1"
${Here-String} = ${Here-String Precursor} `
  -replace '\s#PsDscRunAsCredential',' PsDscRunAsCredential' `
  -replace '\s#Credential',' Credential'
$path = "${.s}\Windows ADK 2026-09-Archive Extraction.ps1"
Set-Content -Path $path -ErrorAction 'SilentlyContinue' -Value ${Here-String}
Set-ItemProperty -Path $path -Name 'IsReadOnly' -Value $true
Remove-Variable -Name 'Here-String Precursor','Here-String'
#endregion
#region | "Windows ADK 2026-09-Offline Installation.ps1" |
${Here-String Precursor} = Get-Content -Path "${.s}\IL-System\Windows ADK 2026-09-Offline Installation with System account.ps1"
${Here-String} = ${Here-String Precursor} `
  -replace '\s#PsDscRunAsCredential',' PsDscRunAsCredential' `
  -replace '\s#Credential',' Credential'
$path = "${.s}\Windows ADK 2026-09-Offline Installation.ps1"
Set-Content -Path $path -ErrorAction 'SilentlyContinue' -Value ${Here-String}
Set-ItemProperty -Path $path -Name 'IsReadOnly' -Value $true
Remove-Variable -Name 'Here-String Precursor','Here-String'
#endregion
#region | "WinPE 2026-09-Archive Extraction.ps1" |
${Here-String Precursor} = Get-Content -Path "${.s}\IL-System\WinPE 2026-09-Archive Extraction with System account.ps1"
${Here-String} = ${Here-String Precursor} `
  -replace '\s#PsDscRunAsCredential',' PsDscRunAsCredential' `
  -replace '\s#Credential',' Credential'
$path = "${.s}\WinPE 2026-09-Archive Extraction.ps1"
Set-Content -Path $path -ErrorAction 'SilentlyContinue' -Value ${Here-String}
Set-ItemProperty -Path $path -Name 'IsReadOnly' -Value $true
Remove-Variable -Name 'Here-String Precursor','Here-String'
#endregion
#region | "WinPE 2026-09-Offline Installation.ps1" |
${Here-String Precursor} = Get-Content -Path "${.s}\IL-System\WinPE 2026-09-Offline Installation with System account.ps1"
${Here-String} = ${Here-String Precursor} `
  -replace '\s#PsDscRunAsCredential',' PsDscRunAsCredential' `
  -replace '\s#Credential',' Credential'
$path = "${.s}\WinPE 2026-09-Offline Installation.ps1"
Set-Content -Path $path -ErrorAction 'SilentlyContinue' -Value ${Here-String}
Set-ItemProperty -Path $path -Name 'IsReadOnly' -Value $true
Remove-Variable -Name 'Here-String Precursor','Here-String'
#endregion

#region | "UAC (User Account Control) on instances of Desktop Experience.ps1" |
${Here-String Precursor} = Get-Content -Path "${.s}\IL-System\UAC (User Account Control) on instances of Desktop Experience with System account.ps1"
${Here-String} = ${Here-String Precursor} `
  -replace '\s#PsDscRunAsCredential',' PsDscRunAsCredential'
$path = "${.s}\UAC (User Account Control) on instances of Desktop Experience.ps1"
Set-Content -Path $path -ErrorAction 'SilentlyContinue' -Value ${Here-String}
Set-ItemProperty -Path $path -Name 'IsReadOnly' -Value $true
Remove-Variable -Name 'Here-String Precursor','Here-String'
#endregion
#region | "Power Plan on instances of Desktop Experience.ps1" |
${Here-String Precursor} = Get-Content -Path "${.s}\IL-System\Power Plan on instances of Desktop Experience with System account.ps1"
${Here-String} = ${Here-String Precursor} `
  -replace '\s#PsDscRunAsCredential',' PsDscRunAsCredential'
$path = "${.s}\Power Plan on instances of Desktop Experience.ps1"
Set-Content -Path $path -ErrorAction 'SilentlyContinue' -Value ${Here-String}
Set-ItemProperty -Path $path -Name 'IsReadOnly' -Value $true
Remove-Variable -Name 'Here-String Precursor','Here-String'
#endregion
#region | "Time Zone via DSC + System Time via GPO.ps1" |
${Here-String Precursor} = Get-Content -Path "${.s}\IL-System\Time Zone via DSC + System Time via GPO with System account.ps1"
${Here-String} = ${Here-String Precursor} `
  -replace '\s#PsDscRunAsCredential',' PsDscRunAsCredential'
$path = "${.s}\Time Zone via DSC + System Time via GPO.ps1"
Set-Content -Path $path -ErrorAction 'SilentlyContinue' -Value ${Here-String}
Set-ItemProperty -Path $path -Name 'IsReadOnly' -Value $true
Remove-Variable -Name 'Here-String Precursor','Here-String'
#endregion
#region | "Execution Policy-Multiple Scopes.ps1" |
${Here-String Precursor} = Get-Content -Path "${.s}\IL-System\Execution Policy-Multiple Scopes with System account.ps1"
${Here-String} = ${Here-String Precursor} `
  -replace '\s#PsDscRunAsCredential',' PsDscRunAsCredential'
$path = "${.s}\Execution Policy-Multiple Scopes.ps1"
Set-Content -Path $path -ErrorAction 'SilentlyContinue' -Value ${Here-String}
Set-ItemProperty -Path $path -Name 'IsReadOnly' -Value $true
Remove-Variable -Name 'Here-String Precursor','Here-String'
#endregion
#region | "Ransomware Deployment Protocol (RDP).ps1" |
${Here-String Precursor} = Get-Content -Path "${.s}\IL-System\Ransomware Deployment Protocol (RDP) with System account.ps1"
${Here-String} = ${Here-String Precursor} `
  -replace '\s#PsDscRunAsCredential',' PsDscRunAsCredential'
$path = "${.s}\Ransomware Deployment Protocol (RDP).ps1"
Set-Content -Path $path -ErrorAction 'SilentlyContinue' -Value ${Here-String}
Set-ItemProperty -Path $path -Name 'IsReadOnly' -Value $true
Remove-Variable -Name 'Here-String Precursor','Here-String'
#endregion
#region | "IE Enhanced Security Configuration on instances of Desktop Experience.ps1" |
${Here-String Precursor} = Get-Content -Path "${.s}\IL-System\IE Enhanced Security Configuration on instances of Desktop Experience with System account.ps1"
${Here-String} = ${Here-String Precursor} `
  -replace '\s#PsDscRunAsCredential',' PsDscRunAsCredential'
$path = "${.s}\IE Enhanced Security Configuration on instances of Desktop Experience.ps1"
Set-Content -Path $path -ErrorAction 'SilentlyContinue' -Value ${Here-String}
Set-ItemProperty -Path $path -Name 'IsReadOnly' -Value $true
Remove-Variable -Name 'Here-String Precursor','Here-String'
#endregion
#region | "Catalog of pre-PKI X.509v3 Certificates.ps1" |
${Here-String Precursor} = Get-Content -Path "${.s}\IL-System\Catalog of pre-PKI X.509v3 Certificates with System account.ps1"
${Here-String} = ${Here-String Precursor} `
  -replace '\s#PsDscRunAsCredential',' PsDscRunAsCredential'
$path = "${.s}\Catalog of pre-PKI X.509v3 Certificates.ps1"
Set-Content -Path $path -ErrorAction 'SilentlyContinue' -Value ${Here-String}
Set-ItemProperty -Path $path -Name 'IsReadOnly' -Value $true
Remove-Variable -Name 'Here-String Precursor','Here-String'
#endregion

#region | "MAC Address Set v3 on Unclustered Hyper-V Host.ps1" |
${Here-String Precursor} = Get-Content -Path "${.s}\IL-System\MAC Address Set v3 on Unclustered Hyper-V Host with System account.ps1"
${Here-String} = ${Here-String Precursor} `
  -replace '\s#PsDscRunAsCredential',' PsDscRunAsCredential' `
  -replace '\s#Credential',' Credential'
$path = "${.s}\MAC Address Set v3 on Unclustered Hyper-V Host.ps1"
Set-Content -Path $path -ErrorAction 'SilentlyContinue' -Value ${Here-String}
Set-ItemProperty -Path $path -Name 'IsReadOnly' -Value $true
Remove-Variable -Name 'Here-String Precursor','Here-String'
#endregion
#region | "One-time Write of VLAN Title and New Random VLAN ID.ps1" |
${Here-String Precursor} = Get-Content -Path "${.s}\IL-System\One-time Write of VLAN Title and New Random VLAN ID with System account.ps1"
${Here-String} = ${Here-String Precursor} `
  -replace '\s#PsDscRunAsCredential',' PsDscRunAsCredential' `
  -replace '\s#Credential',' Credential'
$path = "${.s}\One-time Write of VLAN Title and New Random VLAN ID.ps1"
Set-Content -Path $path -ErrorAction 'SilentlyContinue' -Value ${Here-String}
Set-ItemProperty -Path $path -Name 'IsReadOnly' -Value $true
Remove-Variable -Name 'Here-String Precursor','Here-String'
#endregion
#region | "Immutable IPv4 Reservations.ps1" |
${Here-String Precursor} = Get-Content -Path "${.s}\IL-System\Immutable IPv4 Reservations with System account.ps1"
${Here-String} = ${Here-String Precursor} `
  -replace '\s#PsDscRunAsCredential',' PsDscRunAsCredential' `
  -replace '\s#Credential',' Credential'
$path = "${.s}\Immutable IPv4 Reservations.ps1"
Set-Content -Path $path -ErrorAction 'SilentlyContinue' -Value ${Here-String}
Set-ItemProperty -Path $path -Name 'IsReadOnly' -Value $true
Remove-Variable -Name 'Here-String Precursor','Here-String'
#endregion
#region | "IPv4 Address Space Definitions.ps1" |
${Here-String Precursor} = Get-Content -Path "${.s}\IL-System\IPv4 Address Space Definitions with System account.ps1"
${Here-String} = ${Here-String Precursor} `
  -replace '\s#PsDscRunAsCredential',' PsDscRunAsCredential'
$path = "${.s}\IPv4 Address Space Definitions.ps1"
Set-Content -Path $path -ErrorAction 'SilentlyContinue' -Value ${Here-String}
Set-ItemProperty -Path $path -Name 'IsReadOnly' -Value $true
Remove-Variable -Name 'Here-String Precursor','Here-String'
#endregion
#region | "Sample Without Replacement Random IPv4 Addresses to Ensure Uniqueness.ps1" |
${Here-String Precursor} = Get-Content -Path "${.s}\IL-System\Sample Without Replacement Random IPv4 Addresses to Ensure Uniqueness with System account.ps1"
${Here-String} = ${Here-String Precursor} `
  -replace '\s#PsDscRunAsCredential',' PsDscRunAsCredential' `
  -replace '\s#Credential',' Credential'
$path = "${.s}\Sample Without Replacement Random IPv4 Addresses to Ensure Uniqueness.ps1"
Set-Content -Path $path -ErrorAction 'SilentlyContinue' -Value ${Here-String}
Set-ItemProperty -Path $path -Name 'IsReadOnly' -Value $true
Remove-Variable -Name 'Here-String Precursor','Here-String'
#endregion

#region | "Firewall-Allow Inbound HTTPS-secured WinRM.ps1" |
${Here-String Precursor} = Get-Content -Path "${.s}\IL-System\Firewall-Allow Inbound HTTPS-secured WinRM with System account.ps1"
${Here-String} = ${Here-String Precursor} `
  -replace '\s#PsDscRunAsCredential',' PsDscRunAsCredential'
$path = "${.s}\Firewall-Allow Inbound HTTPS-secured WinRM.ps1"
Set-Content -Path $path -ErrorAction 'SilentlyContinue' -Value ${Here-String}
Set-ItemProperty -Path $path -Name 'IsReadOnly' -Value $true
Remove-Variable -Name 'Here-String Precursor','Here-String'
#endregion
#region | "Permissions Entries of WMI Namespaces on Remote Machines.ps1" |
${Here-String Precursor} = Get-Content -Path "${.s}\IL-System\Permissions Entries of WMI Namespaces on Remote Machines with System account.ps1"
${Here-String} = ${Here-String Precursor} `
  -replace '\s#PsDscRunAsCredential',' PsDscRunAsCredential'
$path = "${.s}\Permissions Entries of WMI Namespaces on Remote Machines.ps1"
Set-Content -Path $path -ErrorAction 'SilentlyContinue' -Value ${Here-String}
Set-ItemProperty -Path $path -Name 'IsReadOnly' -Value $true
Remove-Variable -Name 'Here-String Precursor','Here-String'
#endregion
#region | "Non-System .vhdx File-System Objects.ps1" |
${Here-String Precursor} = Get-Content -Path "${.s}\IL-System\Non-System .vhdx File-System Objects with System account.ps1"
${Here-String} = ${Here-String Precursor} `
  -replace '\s#PsDscRunAsCredential',' PsDscRunAsCredential' `
  -replace '\s#Credential',' Credential'
$path = "${.s}\Non-System .vhdx File-System Objects.ps1"
Set-Content -Path $path -ErrorAction 'SilentlyContinue' -Value ${Here-String}
Set-ItemProperty -Path $path -Name 'IsReadOnly' -Value $true
Remove-Variable -Name 'Here-String Precursor','Here-String'
#endregion

#region | "Update ComputerName.ps1" |
${Here-String Precursor} = Get-Content -Path "${.s}\IL-System\Update ComputerName with System account.ps1"
${Here-String} = ${Here-String Precursor} `
  -replace '\s#PsDscRunAsCredential',' PsDscRunAsCredential' `
  -replace '\s#Credential',' Credential'
$path = "${.s}\Update ComputerName.ps1"
Set-Content -Path $path -ErrorAction 'SilentlyContinue' -Value ${Here-String}
Set-ItemProperty -Path $path -Name 'IsReadOnly' -Value $true
Remove-Variable -Name 'Here-String Precursor','Here-String'
#endregion
#region | "Reboot after ComputerName Update.ps1" |
${Here-String Precursor} = Get-Content -Path "${.s}\IL-System\Reboot after ComputerName Update with System account.ps1"
${Here-String} = ${Here-String Precursor} `
  -replace '\s#PsDscRunAsCredential',' PsDscRunAsCredential'
$path = "${.s}\Reboot after ComputerName Update.ps1"
Set-Content -Path $path -ErrorAction 'SilentlyContinue' -Value ${Here-String}
Set-ItemProperty -Path $path -Name 'IsReadOnly' -Value $true
Remove-Variable -Name 'Here-String Precursor','Here-String'
#endregion
#region | "Windows Features, Roles, and Role Services-! Blank DependsOn.ps1" |
${Here-String Precursor} = Get-Content -Path "${.s}\IL-System\Windows Features, Roles, and Role Services-! Blank DependsOn with System account.ps1"
${Here-String} = ${Here-String Precursor} `
  -replace '\s#PsDscRunAsCredential',' PsDscRunAsCredential' `
  -replace '\s#Credential',' Credential'
$path = "${.s}\Windows Features, Roles, and Role Services-! Blank DependsOn.ps1"
Set-Content -Path $path -ErrorAction 'SilentlyContinue' -Value ${Here-String}
Set-ItemProperty -Path $path -Name 'IsReadOnly' -Value $true
Remove-Variable -Name 'Here-String Precursor','Here-String'
#endregion

#region | "WinRM Part 2-HTTPS-Protected PowerShell Remoting.ps1" |
${Here-String Precursor} = Get-Content -Path "${.s}\IL-System\WinRM Part 2-HTTPS-Protected PowerShell Remoting with System account.ps1"
${Here-String} = ${Here-String Precursor} `
  -replace '\s#PsDscRunAsCredential',' PsDscRunAsCredential'
$path = "${.s}\WinRM Part 2-HTTPS-Protected PowerShell Remoting.ps1"
Set-Content -Path $path -ErrorAction 'SilentlyContinue' -Value ${Here-String}
Set-ItemProperty -Path $path -Name 'IsReadOnly' -Value $true
Remove-Variable -Name 'Here-String Precursor','Here-String'
#endregion

#region | "Network Refined v2-Motherboard-connected Network Adapters ONLY.ps1" |
${Here-String Precursor} = Get-Content -Path "${.s}\IL-System\Network Refined v2 with System account.ps1"
${Here-String} = ${Here-String Precursor} `
  -replace '#%_NO_Unspecified_MediaType_%','' `
  -replace '\s#PsDscRunAsCredential',' PsDscRunAsCredential'
$path = "${.s}\Network Refined v2-Motherboard-connected Network Adapters ONLY.ps1"
Set-Content -Path $path -ErrorAction 'SilentlyContinue' -Value ${Here-String}
Set-ItemProperty -Path $path -Name 'IsReadOnly' -Value $true
Remove-Variable -Name 'Here-String Precursor','Here-String'
#endregion
#region | "Virtual Switch Clade 00.ps1" |
${Here-String Precursor} = Get-Content -Path "${.s}\IL-System\Virtual Switch Clade 00 with System account.ps1"
${Here-String} = ${Here-String Precursor} `
  -replace '\s#PsDscRunAsCredential',' PsDscRunAsCredential'
$path = "${.s}\Virtual Switch Clade 00.ps1"
Set-Content -Path $path -ErrorAction 'SilentlyContinue' -Value ${Here-String}
Set-ItemProperty -Path $path -Name 'IsReadOnly' -Value $true
Remove-Variable -Name 'Here-String Precursor','Here-String'
#endregion
#region | "VLAN Settings on Abstraction-based Network Adapter Connecting Parent Partition to External vSwitch.ps1" |
${Here-String Precursor} = Get-Content -Path "${.s}\IL-System\VLAN Settings on Abstraction-based Network Adapter Connecting Parent Partition to External vSwitch with System account.ps1"
${Here-String} = ${Here-String Precursor} `
  -replace '\s#PsDscRunAsCredential',' PsDscRunAsCredential'
$path = "${.s}\VLAN Settings on Abstraction-based Network Adapter Connecting Parent Partition to External vSwitch.ps1"
Set-Content -Path $path -ErrorAction 'SilentlyContinue' -Value ${Here-String}
Set-ItemProperty -Path $path -Name 'IsReadOnly' -Value $true
Remove-Variable -Name 'Here-String Precursor','Here-String'
#endregion
#region | "Network Refined v2-Abstraction-based Network Adapters ONLY.ps1" |
${Here-String Precursor} = Get-Content -Path "${.s}\IL-System\Network Refined v2 with System account.ps1"
${Here-String} = ${Here-String Precursor} `
  -replace '#%_Unspecified_MediaType_ONLY_%','' `
  -replace "$([System.Char]39)Dns Client Global Setting$([System.Char]39)","$([System.Char]39)_Dns Client Global Setting$([System.Char]39)" `
  -replace "$([System.Char]39)Hosts File Entry Collection$([System.Char]39)","$([System.Char]39)_Hosts File Entry Collection$([System.Char]39)" `
  -replace "$([System.Char]39)Windows Internet Name Service$([System.Char]39)","$([System.Char]39)_Windows Internet Name Service$([System.Char]39)" `
  -replace '\s#PsDscRunAsCredential',' PsDscRunAsCredential'
$path = "${.s}\Network Refined v2-Abstraction-based Network Adapters ONLY.ps1"
Set-Content -Path $path -ErrorAction 'SilentlyContinue' -Value ${Here-String}
Set-ItemProperty -Path $path -Name 'IsReadOnly' -Value $true
Remove-Variable -Name 'Here-String Precursor','Here-String'
#endregion
#region | "Hypervisor Config without Live Migration on UnClustered Hyper-V Host.ps1" |
${Here-String Precursor} = Get-Content -Path "${.s}\IL-System\Hypervisor Config without Live Migration on UnClustered Hyper-V Host with System account.ps1"
${Here-String} = ${Here-String Precursor} `
  -replace '\s#PsDscRunAsCredential',' PsDscRunAsCredential'
$path = "${.s}\Hypervisor Config without Live Migration on UnClustered Hyper-V Host.ps1"
Set-Content -Path $path -ErrorAction 'SilentlyContinue' -Value ${Here-String}
Set-ItemProperty -Path $path -Name 'IsReadOnly' -Value $true
Remove-Variable -Name 'Here-String Precursor','Here-String'
#endregion

#region | "Accumulated System VHDX Cascades-Block VHDX 2-Unique.ps1" |
${Here-String Precursor} = Get-Content -Path "${.s}\IL-System\Accumulated System VHDX Cascades with System account.ps1"
${Here-String} = ${Here-String Precursor} `
  -replace '#%_Delete_To_Block_VHDX_2_Unique%#','' `
  -replace '\s#PsDscRunAsCredential',' PsDscRunAsCredential' `
  -replace '\s#Credential',' Credential'
$path = "${.s}\Accumulated System VHDX Cascades-Block VHDX 2-Unique.ps1"
Set-Content -Path $path -ErrorAction 'SilentlyContinue' -Value ${Here-String}
Set-ItemProperty -Path $path -Name 'IsReadOnly' -Value $true
Remove-Variable -Name 'Here-String Precursor','Here-String'
#endregion
#region | "VHDX Excluded from Storage Spaces Virtual Disk participation-DSC Configuration Root.ps1" |
${Here-String Precursor} = Get-Content -Path "${.s}\IL-System\VHDX Excluded from Storage Spaces Virtual Disk participation-DSC Configuration Root with System account.ps1"
${Here-String} = ${Here-String Precursor} `
  -replace '\s#PsDscRunAsCredential',' PsDscRunAsCredential' `
  -replace '\s#Credential',' Credential'
$path = "${.s}\VHDX Excluded from Storage Spaces Virtual Disk participation-DSC Configuration Root.ps1"
Set-Content -Path $path -ErrorAction 'SilentlyContinue' -Value ${Here-String}
Set-ItemProperty -Path $path -Name 'IsReadOnly' -Value $true
Remove-Variable -Name 'Here-String Precursor','Here-String'
#endregion


#endregion
#region | Configuration |
Configuration $InstanceName {
  #region | Import DSC Resources into the Configuration Document |
  Import-DscResource -ModuleName 'PSDesiredStateConfiguration'  -ModuleVersion 1.1
  Import-DscResource -ModuleName 'xPSDesiredStateConfiguration' -ModuleVersion 9.2.2
  Import-DscResource -ModuleName 'AdHocInstantAdcsDsc'          -ModuleVersion 0.4.0
  Import-DscResource -ModuleName 'ComputerManagementDsc'        -ModuleVersion 10.0.1
  Import-DscResource -ModuleName 'CertificateDsc'               -ModuleVersion 6.1.0
  Import-DscResource -ModuleName 'WSManDsc'                     -ModuleVersion 4.0.0
  Import-DscResource -ModuleName 'NetworkingDsc'                -ModuleVersion 9.1.1
  Import-DscResource -ModuleName 'xCIMSecurity'                 -ModuleVersion 1.0.0.1
  Import-DscResource -ModuleName 'StorageDsc'                   -ModuleVersion 6.1.0
  Import-DscResource -ModuleName 'xComputerManagement'          -ModuleVersion 4.1.0.0
  Import-DscResource -ModuleName 'HyperVDsc'                    -ModuleVersion 4.0.0
  Import-DscResource -ModuleName 'cHyper-V'                     -ModuleVersion 3.0.0.0
  #endregion

  Node $AllNodes.Where({$_.Life -eq $true -and `
    $_.SuperEmpire   -eq 'Microsoft'          -and `
    $_.Empire        -eq 'PM'                 -and `
    $_.SubEmpire     -eq 'Windows Server'     -and `
    $_.SuperDominion -match '^Yes'            -and `
    $_.Dominion      -eq 'Hyper-V'            -and `
    $_.Kingdom       -eq 'Non-HA'             -and `
    $_.Species       -eq 'Primordial Hyper-V Host'
  }).NodeName {
    . "${.s}\IL-System\Local Accounts and Group Membership with System account.ps1"
    . "${.s}\Strict PowerShell 5.1 Tracking.ps1"
    . "${.s}\Event Logs-Activate Channels of Microsoft-Windows-Dsc Provider.ps1"
  }
  Node $AllNodes.Where({$_.Life -eq $true -and `
    $_.SuperEmpire   -eq 'Microsoft'          -and `
    $_.Empire        -eq 'PM'                 -and `
    $_.SubEmpire     -eq 'Windows Server'     -and `
    $_.SuperDominion -match '^Yes'            -and `
    $_.Dominion      -eq 'Hyper-V'            -and `
    $_.Kingdom       -eq 'Non-HA'             -and `
    $_.Species       -eq 'Primordial Hyper-V Host'
  }).NodeName {
    . "${.s}\Enable BuiltIn Administrator on instances of Desktop Experience.ps1"
    . "${.s}\Environment Variable Definitions.ps1"
    . "${.s}\Directory Tree inside DSC_CFG_ROOT.ps1"
    . "${.s}\Preboots Directory Set on DSC Authoring Station.ps1"
    . "${.s}\One-time Write of VM Switch UUID.ps1"
    . "${.s}\One-time Selection of Mac Address Space (8 bits) and New Random %ComputerNames%.ps1"
    . "${.s}\File-based Predefined non-Random Variables.ps1"
    . "${.s}\WinRM Part 1-WS-Man Client Config, WinRM Windows Service, WS-Man Service Settings.ps1"
    . "${.s}\NVMe Native Support on Server 2025-Enable.ps1"
    . "${.s}\UAC (User Account Control) on instances of Desktop Experience.ps1"
    . "${.s}\Power Plan on instances of Desktop Experience.ps1"
    . "${.s}\Time Zone via DSC + System Time via GPO.ps1"
    . "${.s}\Execution Policy-Multiple Scopes.ps1"
    . "${.s}\Ransomware Deployment Protocol (RDP).ps1"
    . "${.s}\IE Enhanced Security Configuration on instances of Desktop Experience.ps1"
    #-\~|~/-#-\~|~/-#-\~|~/-#-\~|~/-#-\~|~/-#-\~|~/-#-\~|~/-#-\~|~/-#-\~|~/-#-\~|~/-#
    . "${.s}\Catalog of pre-PKI X.509v3 Certificates.ps1"
    #-\~|~/-#-\~|~/-#-\~|~/-#-\~|~/-#-\~|~/-#-\~|~/-#-\~|~/-#-\~|~/-#-\~|~/-#-\~|~/-#
  }
  Node $AllNodes.Where({$_.Life -eq $true -and `
    $_.SuperEmpire   -eq 'Microsoft'          -and `
    $_.Empire        -eq 'PM'                 -and `
    $_.SubEmpire     -eq 'Windows Server'     -and `
    $_.SuperDominion -match '^Yes'            -and `
    $_.Dominion      -eq 'Hyper-V'            -and `
    $_.Kingdom       -eq 'Non-HA'             -and `
    $_.Species       -eq 'Primordial Hyper-V Host'
  }).NodeName {
    # #-\~|~/-#-\~|~/-#-\~|~/-#-\~|~/-#-\~|~/-#-\~|~/-#-\~|~/-#-\~|~/-#-\~|~/-#-\~|~/-#
    . "${.s}\One-time Write of VLAN Title and New Random VLAN ID.ps1"
    . "${.s}\MAC Address Set v3 on Unclustered Hyper-V Host.ps1"
    # #-\~|~/-#-\~|~/-#-\~|~/-#-\~|~/-#-\~|~/-#-\~|~/-#-\~|~/-#-\~|~/-#-\~|~/-#-\~|~/-#
    # For static IP cfg? Is this needed? ---> . "${.s}\Immutable IPv4 Reservations.ps1" 
    . "${.s}\IPv4 Address Space Definitions.ps1"
    . "${.s}\Sample Without Replacement Random IPv4 Addresses to Ensure Uniqueness.ps1"
    . "${.s}\Firewall-Allow Inbound HTTPS-secured WinRM.ps1"
    . "${.s}\Permissions Entries of WMI Namespaces on Remote Machines.ps1"
    . "${.s}\Non-System .vhdx File-System Objects.ps1"
    . "${.s}\Update ComputerName.ps1"
    . "${.s}\Reboot after ComputerName Update.ps1"
    . "${.s}\Windows Features, Roles, and Role Services-! Blank DependsOn.ps1"
    . "${.s}\WinRM Part 2-HTTPS-Protected PowerShell Remoting.ps1"
    . "${.s}\Network Refined v2-Motherboard-connected Network Adapters ONLY.ps1"
    . "${.s}\Virtual Switch Clade 00.ps1"
    . "${.s}\VLAN Settings on Abstraction-based Network Adapter Connecting Parent Partition to External vSwitch.ps1"
    . "${.s}\Network Refined v2-Abstraction-based Network Adapters ONLY.ps1"
    . "${.s}\Hypervisor Config without Live Migration on UnClustered Hyper-V Host.ps1"
  }
  Node $AllNodes.Where({$_.Life -eq $true -and `
    $_.SuperEmpire   -eq 'Microsoft'          -and `
    $_.Empire        -eq 'PM'                 -and `
    $_.SubEmpire     -eq 'Windows Server'     -and `
    $_.SuperDominion -match '^Yes'            -and `
    $_.Dominion      -eq 'Hyper-V'            -and `
    $_.Kingdom       -eq 'Non-HA'             -and `
    $_.Species       -eq 'Primordial Hyper-V Host'
  }).NodeName {. "${.s}\Accumulated System VHDX Cascades-Block VHDX 2-Unique.ps1"}
  Node $AllNodes.Where({$_.Life -eq $false -and `
    $_.SuperEmpire   -eq 'Microsoft'          -and `
    $_.Empire        -eq 'PM'                 -and `
    $_.SubEmpire     -eq 'Windows Server'     -and `
    $_.SuperDominion -match '^Yes'            -and `
    $_.Dominion      -eq 'Hyper-V'            -and `
    $_.Kingdom       -eq 'Non-HA'             -and `
    $_.Species       -eq 'Primordial Hyper-V Host'
  }).NodeName {. "${.s}\VHDX Excluded from Storage Spaces Virtual Disk participation-DSC Configuration Root.ps1"}
}
#endregion

#region | Compile-Sign-Publish-Enact |
#region | Compile |
${time_begin Compile-Sign-Publish-Enact} = [System.DateTime]::Now
$HT = @{
  InstanceName      = $InstanceName
  OutputPath        = $lcmHT['OutputPath']
  ConfigurationData = $ConfigurationData
  Verbose           = $true
}
${time_begin Compile} = [System.DateTime]::Now
Invoke-Expression -Verbose:$true -Command "$InstanceName @HT"
${time_end Compile} = [System.DateTime]::Now
$ts = ${time_end Compile} - ${time_begin Compile}; Write-Host -Object "  Compile $($ts.Minutes)m$($ts.Seconds)s" -ForegroundColor $(rFc) # -BackgroundColor $(rBc)
#endregion
#region | Sign |
# Digitally sign the .MOF with the code signing cert | performed on the DSC Authoring Station |
$CodeSigningCert = Get-ChildItem -Path 'Cert:\LocalMachine\My\' -Recurse | Where-Object -FilterScript {
  $_.FriendlyName -eq 'Pre-PKI Global Code Signer'
}
$HT = @{
  Certificate     = $CodeSigningCert
  FilePath        = $(
    $ComputerName = Get-Content -Path "$Statics\CNs\${DSC Authoring Station Mgmt Cname} ComputerName.txt"
    $lcmHT['OutputPath'] + '\' + "$ComputerName.mof"
  )
  IncludeChain    = 'All'
  Confirm         = $false
  HashAlgorithm   = ${Global CNG CHA}
  Verbose         = $false
}
$sig = Set-AuthenticodeSignature @HT
#endregion
#region | Publish (aka, "Stage") |
# Stage the Configuration (i.e., convert the configuration into a Pending status): 
Publish-DscConfiguration -CN $env:ComputerName -Path $lcmHT['OutputPath'] -Force -Verbose:$true
#endregion
#region | Enact the Configuration |
${time_begin Enact} = [System.DateTime]::Now
Start-DscConfiguration -UseExisting -Force -Wait:$true -Verbose:$false
${time_end Enact} = [System.DateTime]::Now
$ts = ${time_end Enact} - ${time_begin Enact}; Write-Host -Object "  Enact $($InstanceName): $($ts.Minutes)m$($ts.Seconds)s" -ForegroundColor $(rFc) # -BackgroundColor $(rBc)
${time_end Compile-Sign-Publish-Enact} = [System.DateTime]::Now
$ts = ${time_end Compile-Sign-Publish-Enact} - ${time_begin Compile-Sign-Publish-Enact}; Write-Host -Object "`tCompile-Sign-Publish-Enact $($ts.Minutes)m$($ts.Seconds)s" -ForegroundColor $(rFc) # -BackgroundColor $(rBc)
#endregion
#endregion

$ts = ${time_end Enact} - ${Begin ConfigurationData Confirmation}; Write-Host -Object "    $($InstanceName): $($ts.Minutes)m$($ts.Seconds)s" -ForegroundColor $(rFc) # -BackgroundColor $(rBc)

Get-Variable -Name 'Define ConfigurationData Variable Here-String Precursor' | Remove-Variable
Get-Variable -Name 'Define ConfigurationData Variable Here-String' | Remove-Variable
Get-Variable -Name 'Define ConfigurationData Variable' | Remove-Variable
Get-Variable -Name 'ConfigurationData' | Remove-Variable
