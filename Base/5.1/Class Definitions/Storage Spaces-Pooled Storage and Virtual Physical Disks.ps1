#region | Storage Pool Name, Storage Pool Virtual Disk FriendlyName, and Storage Spaces Resiliencey Reference as class |
class StoragePoolName {
  static [System.String] $NobleGas = 'NobleGas'
}

class StoragePoolVirtualDiskFriendlyName {
  static [System.String] $Helium    = 'Helium'
  static [System.String] $Neon      = 'Neon'
  static [System.String] $Argon     = 'Argon'
  static [System.String] $Krypton   = 'Krypton'
  static [System.String] $Xenon     = 'Xenon'
  static [System.String] $Radon     = 'Radon'
  static [System.String] $Oganesson = 'Oganesson'
}

class StorageResiliencyReference {
  static [System.String] $SSVD = 'Physical Disk for Storage Spaces Virtual Disk'
  static [System.String] $DSC  = 'No SSVD-DSC config root'
}
#endregion

