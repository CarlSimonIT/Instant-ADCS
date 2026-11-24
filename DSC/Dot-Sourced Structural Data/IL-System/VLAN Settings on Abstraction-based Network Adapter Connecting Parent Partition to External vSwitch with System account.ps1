${VLAN Settings on Abstraction-based Network Adapter Connecting Parent Partition to External vSwitch} = $Node.'VLAN Settings on Abstraction-based Network Adapter Connecting Parent Partition to External vSwitch'
if (
  $null -ne ${VLAN Settings on Abstraction-based Network Adapter Connecting Parent Partition to External vSwitch}
) {
  if (
    $null -ne ${VLAN Settings on Abstraction-based Network Adapter Connecting Parent Partition to External vSwitch}.Id     -and `
    $null -ne ${VLAN Settings on Abstraction-based Network Adapter Connecting Parent Partition to External vSwitch}.Name   -and `
    $null -ne ${VLAN Settings on Abstraction-based Network Adapter Connecting Parent Partition to External vSwitch}.VMName
  ) {
    <#
      start msedge.exe 'https://github.com/rchaganti/DSCResources/tree/master/cHyper-V'
      Get-DscResourceProperty.ps1 -ModuleName 'cHyper-V' -ResourceName 'cVMNetworkAdapterVlan' | clip.exe
      Get-DscResource -Name 'cVMNetworkAdapterVlan' -Module 'cHyper-V'

      Name                 IsKey Mandatory TypeConstraint  Values
      ----                 ----- --------- --------------  ------
      Id                    True      True String          {}
      Name                 False      True String          {}
      VMName               False      True String          {}

      AdapterMode          False     False String          {Access | Communnity | Isolated | Promiscuous | Trunk | Untagged}
      AllowedVlanIdList    False     False String          {}
      NativeVlanId         False     False UInt32          {}
      PrimaryVlanId        False     False UInt32          {}
      SecondaryVlanId      False     False UInt32          {}
      SecondaryVlanIdList  False     False String          {}
      VlanId               False     False UInt32          {}

      PsDscRunAsCredentia1 False     False MSFT_Credential {}
      DependsOn            False     False StringArray     {}
    #>

    cVMNetworkAdapterVlan ${VLAN Settings on Abstraction-based Network Adapter Connecting Parent Partition to External vSwitch}.Resource_Title {
      Id                          =      [System.String]${VLAN Settings on Abstraction-based Network Adapter Connecting Parent Partition to External vSwitch}.Id
      Name                        =      [System.String]${VLAN Settings on Abstraction-based Network Adapter Connecting Parent Partition to External vSwitch}.Name
      VMName                      =      [System.String]${VLAN Settings on Abstraction-based Network Adapter Connecting Parent Partition to External vSwitch}.VMName
      AdapterMode                 =      [System.String]${VLAN Settings on Abstraction-based Network Adapter Connecting Parent Partition to External vSwitch}.AdapterMode
      #AllowedVlanIdList          =      [System.String]${VLAN Settings on Abstraction-based Network Adapter Connecting Parent Partition to External vSwitch}.AllowedVlanIdList
      #NativeVlanId               =      [System.UInt32]${VLAN Settings on Abstraction-based Network Adapter Connecting Parent Partition to External vSwitch}.NativeVlanId
      #PrimaryVlanId              =      [System.UInt32]${VLAN Settings on Abstraction-based Network Adapter Connecting Parent Partition to External vSwitch}.PrimaryVlanId
      #SecondaryVlanId            =      [System.UInt32]${VLAN Settings on Abstraction-based Network Adapter Connecting Parent Partition to External vSwitch}.SecondaryVlanId
      #SecondaryVlanIdList        =      [System.String]${VLAN Settings on Abstraction-based Network Adapter Connecting Parent Partition to External vSwitch}.SecondaryVlanIdList
      VlanId                      =      [System.UInt32]${VLAN Settings on Abstraction-based Network Adapter Connecting Parent Partition to External vSwitch}.VlanId
      #PsDscRunAsCredential       =      [PSCredential]${VLAN Settings on Abstraction-based Network Adapter Connecting Parent Partition to External vSwitch}.PsDscRunAsCredential
      DependsOn                   =      ${Dependencys Virtual Switch Clade 00 Members}
    }

    ${Dependency VLAN Settings on Abstraction-based Network Adapter Connecting Parent Partition to External vSwitch} = [System.String[]]@(
      "[cVMNetworkAdapterVlan]$(${VLAN Settings on Abstraction-based Network Adapter Connecting Parent Partition to External vSwitch}.Resource_Title)"
    )
  }
}