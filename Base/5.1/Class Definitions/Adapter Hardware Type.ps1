#region | Adapter Hardware Type |
<# IMPORTANT |
  Terminology is a major obstacle.
  The phrase "virtual network adapter" can mean multiple things. 
  For this reason, Instant-ADCS will describe network adapters differently. 
  Assume that ALL network adapters are physical network adapters. 
  There is no such thing as a Virtual Network Adapter, a vNIC, etc. 

  Network adapters in Instant-ADCS are either Motherboard-connected or 
  Abstraction-based, and conceptualized from the perspective of the operating
  system to which that network adapter is connected. 
  Whether the OS is running on bare-metal or as a guest in a VM is immaterial.
#>

class AdapterHardwareType {
  static [System.String] $Mc = 'Motherboard-connected'
  static [System.String] $Ab = 'Abstraction-based'
}
$accelerators::Add('aht','AdapterHardwareType')
#endregion

