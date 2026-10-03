#region | Computer Info Lite |
#~t~# $time_end = [System.DateTime]::Now; $time_begin = [System.DateTime]::Now;
$ImmutableTitle          = Get-ItemProperty -Path "HKLM:\HARDWARE\DESCRIPTION\System\BIOS" | Select-Object -ExpandProperty 'SystemProductName'
$BiosSerialNumber        = Get-CimInstance -ClassName 'Win32_BIOS' | Select-Object -ExpandProperty 'SerialNumber'
$ProductName             = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" | Select-Object -ExpandProperty 'ProductName'
(Get-CimInstance -ClassName 'Win32_OperatingSystem').Name -match '^(?<OSName>[ a-zA-Z0-9]+)|.*$' > $null
$OSName                  = $Matches['OSName']
$SystemBiosVersion       = -join $(Get-ItemProperty -Path "HKLM:\HARDWARE\DESCRIPTION\System" | Select-Object -ExpandProperty 'SystemBiosVersion')
$BiosVersion             = Get-ItemProperty -Path "HKLM:\HARDWARE\DESCRIPTION\System\BIOS" -Name 'BiosVersion' | Select-Object -ExpandProperty 'BiosVersion'
$BiosVendor              = Get-ItemProperty -Path "HKLM:\HARDWARE\DESCRIPTION\System\BIOS" -Name 'BiosVendor' | Select-Object -ExpandProperty 'BiosVendor'
$BiosReleaseDate         = Get-ItemProperty -Path "HKLM:\HARDWARE\DESCRIPTION\System\BIOS" -Name 'BiosReleaseDate' | Select-Object -ExpandProperty 'BiosReleaseDate'
$CsProcessors            = Get-ItemProperty -Path "HKLM:\HARDWARE\DESCRIPTION\System\CentralProcessor\0" -Name 'ProcessorNameString' | Select-Object -ExpandProperty 'ProcessorNameString'
$CpuIdentifier           = Get-ItemProperty -Path "HKLM:\HARDWARE\DESCRIPTION\System\CentralProcessor\0" -Name 'Identifier' | Select-Object -ExpandProperty 'Identifier'
$VendorIdentifier        = Get-ItemProperty -Path "HKLM:\HARDWARE\DESCRIPTION\System\CentralProcessor\0" -Name 'VendorIdentifier' | Select-Object -ExpandProperty 'VendorIdentifier'
$LogiProcCount           = $env:NUMBER_OF_PROCESSORS
$WindowsInstallationType = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name 'InstallationType' | Select-Object -ExpandProperty 'InstallationType'
$CompositionEditionID    = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name 'CompositionEditionID' | Select-Object -ExpandProperty 'CompositionEditionID'
$EditionID               = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name 'EditionID' | Select-Object -ExpandProperty 'EditionID'
$IsDomainController      = $null -ne (Get-CimInstance -Query "select * from Win32_OperatingSystem where ProductType='2'")
$PowerShellInstancePID   = [System.Diagnostics.Process]::GetCurrentProcess().Id
$RAM                     = [System.Int64](Get-CimInstance -ClassName 'Win32_PhysicalMemory' | Select-Object -ExpandProperty 'Capacity' | Measure-Object -Sum | Select-Object -ExpandProperty 'Sum')
$PartOfDomain            = Get-CimInstance -ClassName 'Win32_ComputerSystem' | Select-Object -ExpandProperty 'PartOfDomain'
$DomainRoleHT            = @{'0' = "Standalone Workstation"; '1' = "Member Workstation"; '2' = "Standalone Server"; '3' = "Member Server"; '4' = "Backup Domain Controller"; '5' = "Primary Domain Controller"}
$DomainRoleIndex         = Get-CimInstance -ClassName 'Win32_ComputerSystem' | Select-Object -ExpandProperty 'DomainRole'
$DomainRole              = $DomainRoleHT[$DomainRoleIndex]
Remove-Variable -Name 'DomainRoleHT','DomainRoleIndex'
$LanguageMode            = $ExecutionContext.SessionState.LanguageMode
$OperatingSystemSKU      = Get-CimInstance -ClassName 'Win32_OperatingSystem' | Select-Object -ExpandProperty 'OperatingSystemSKU'
$ChassisType             = Get-CimInstance -ClassName 'Win32_ComputerSystem' | Select-Object -ExpandProperty 'PCSystemType'
$IsLaptop                = if ($ChassisType -eq 2) {$true} else {$false}
Remove-Variable -Name 'ChassisType'
$Win32_OpSys_ProductType = Get-CimInstance -ClassName 'Win32_OperatingSystem' | Select-Object -ExpandProperty 'ProductType'
$IsWindowsClient         = if ($Win32_OpSys_ProductType -eq 1) {$true} else {$false}
Remove-Variable -Name 'Win32_OpSys_ProductType'

${Computer Info Lite} = @{
  ImmutableTitle          = $ImmutableTitle
  BiosSerialNumber        = $BiosSerialNumber
  ProductName             = $ProductName
  OSName                  = $OSName
  SystemBiosVersion       = $SystemBiosVersion
  BiosVersion             = $BiosVersion
  BiosVendor              = $BiosVendor
  BiosReleaseDate         = $BiosReleaseDate
  CsProcessors            = $CsProcessors
  CpuIdentifier           = $CpuIdentifier
  VendorIdentifier        = $VendorIdentifier
  LogiProcCount           = $LogiProcCount
  WindowsInstallationType = $WindowsInstallationType
  CompositionEditionID    = $CompositionEditionID
  EditionID               = $EditionID
  IsDomainController      = $IsDomainController       # Work Station (1) Domain Controller (2) Server (3)
  PowerShellInstancePID   = $PowerShellInstancePID
  RAM                     = $RAM
  PartOfDomain            = $PartOfDomain
  DomainRole              = $DomainRole
  LanguageMode            = $LanguageMode
  OperatingSystemSKU      = $OperatingSystemSKU
  IsLaptop                = $IsLaptop
  IsWindowsClient         = $IsWindowsClient
}
#endregion

