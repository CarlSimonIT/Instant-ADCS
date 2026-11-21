${Hyper-V Host Phase I} = $Node.'Hyper-V Host Phase I'
if ($null -ne ${Hyper-V Host Phase I}) {
  if (
    $null -ne ${Hyper-V Host Phase I}.IsSingleInstance
  ) {
    <#
      Get-DscResourceProperty -ModuleName 'HyperVDsc' -ResourceName 'VMHost' | clip.exe

      Name                                      IsKey Mandatory TypeConstraint  Values
      ----                                      ----- --------- --------------  ------
      IsSingleInstance                           True      True String          {Yes}

      EnableEnhancedSessionMode                 False     False Boolean         {}
      MacAddressMaximum                         False     False String          {}
      MacAddressMinimum                         False     False String          {}
      MaximumStorageMigrations                  False     False UInt32          {}
      MaximumVirtualMachineMigrations           False     False UInt32          {}
      NumaSpanningEnabled                       False     False Boolean         {}
      ResourceMeteringSaveIntervalMinute        False     False UInt32          {}
      UseAnyNetworkForMigration                 False     False Boolean         {}
      VirtualHardDiskPath                       False     False String          {}
      VirtualMachineMigrationAuthenticationType False     False String          {CredSSP | Kerberos}
      VirtualMachineMigrationEnabled            False     False Boolean         {}
      VirtualMachineMigrationPerformanceOption  False     False String          {TCPIP | Compression | SMB}
      VirtualMachinePath                        False     False String          {}

      FibreChannelWwnn                          False     False String          {}
      FibreChannelWwpnMaximum                   False     False String          {}
      FibreChannelWwpnMinimum                   False     False String          {}

      PsDscRunAsCredentia1                      False     False MSFT_Credential {}
      DependsOn                                 False     False StringArray     {}
    #>

    VMHost ${Hyper-V Host Phase I}.Resource_Title {
      IsSingleInstance                =       [System.String]${Hyper-V Host Phase I}.IsSingleInstance
      EnableEnhancedSessionMode       =       [System.Boolean]${Hyper-V Host Phase I}.EnableEnhancedSessionMode
      #MacAddressMaximum               =       [System.String]${Hyper-V Host Phase I}.MacAddressMaximum
      #MacAddressMinimum               =       [System.String]${Hyper-V Host Phase I}.MacAddressMinimum
      VirtualMachinePath              =       [System.String]${Hyper-V Host Phase I}.VirtualMachinePath
      VirtualHardDiskPath             =       [System.String]${Hyper-V Host Phase I}.VirtualHardDiskPath
      NumaSpanningEnabled             =       [System.Boolean]${Hyper-V Host Phase I}.NumaSpanningEnabled
      #PsDscRunAsCredential           =       [PSCredential]${Hyper-V Host Phase I}.PsDscRunAsCredential
      DependsOn                       =       ${Dependencys Event Log Channel Status}
    }

    ${Dependency Primordial Unclustered Hyper-V Host} = [System.String[]]@(
      "[VMHost]$(${Hyper-V Host Phase I}.Resource_Title)"
    )
  }
}