<# Notes | Reference | Questions |
  See Pro Microsoft Hyper-V 2019, Chapter 8, Figure 8-2 for a dual-Hyper-V Virtual Switch use case!. 
  
  Is an account holding membership in the local Administrators group a strict requirement? Could a 
  member of 'Hyper-V Administrators' also deploy new virtual switches? 
#>

${Dependencys Virtual Switch Clade 00 Members} = [System.Collections.ArrayList]::New()

${Virtual Switch Clade 00---Abstraction-based NetAdapter from Motherboard-connected Intel NIC} = $Node.'Virtual Switch Clade 00---Abstraction-based NetAdapter from Motherboard-connected Intel NIC'
if ($null -ne ${Virtual Switch Clade 00---Abstraction-based NetAdapter from Motherboard-connected Intel NIC}) {
  if (
    $null -ne ${Virtual Switch Clade 00---Abstraction-based NetAdapter from Motherboard-connected Intel NIC}.Name -and `
    $null -ne ${Virtual Switch Clade 00---Abstraction-based NetAdapter from Motherboard-connected Intel NIC}.Type
  ) {
    ${vSwitch UUID .txt File BaseName} = ${Virtual Switch Clade 00---Abstraction-based NetAdapter from Motherboard-connected Intel NIC}.Resource_Title -replace '\\','_'
    ${vSwitch UUID .txt File FullName} = "$Statics\vHW\sw\${vSwitch UUID .txt File BaseName}.txt"
    ${Is vSwitch UUID Already Defined} = Test-Path -Path ${vSwitch UUID .txt File FullName}

    if (${Is vSwitch UUID Already Defined}) {
      <#
        start msedge.exe 'https://github.com/dsccommunity/HyperVDsc/wiki/VMSwitch'
        Get-DscResourceProperty -ModuleName 'HyperVDsc' -ResourceName 'VMSwitch' | clip.exe

        Name                     IsKey Mandatory TypeConstraint  Values
        ----                     ----- --------- --------------  ------
        Name                      True      True String          {}
        Type                      True      True String          {External | Internal | Private}

        NetAdapterName           False     False StringArray     {}
        AllowManagementOS        False     False Boolean         {}
        BandwidthReservationMode False     False String          {Default | Weight | Absolute | None | Weight}
        EnableEmbeddedTeaming    False     False Boolean         {}
        Id                       False     False String          {}
        LoadBalancingAlgorithm   False     False String          {Dynamic | HyperVPort}

        Ensure                   False     False String          {Present | Absent}
        PsDscRunAsCredentia1     False     False MSFT_Credential {}
        DependsOn                False     False StringArray     {}
      #>

      VMSwitch ${Virtual Switch Clade 00---Abstraction-based NetAdapter from Motherboard-connected Intel NIC}.Resource_Title {
        Name                            =        [System.String]${Virtual Switch Clade 00---Abstraction-based NetAdapter from Motherboard-connected Intel NIC}.Name
        Type                            =        [System.String]${Virtual Switch Clade 00---Abstraction-based NetAdapter from Motherboard-connected Intel NIC}.Type
        NetAdapterName                  =        [System.String[]]${Virtual Switch Clade 00---Abstraction-based NetAdapter from Motherboard-connected Intel NIC}.NetAdapterName
        AllowManagementOS               =        [System.Boolean]${Virtual Switch Clade 00---Abstraction-based NetAdapter from Motherboard-connected Intel NIC}.AllowManagementOS
        Id                              =        [System.String]${Virtual Switch Clade 00---Abstraction-based NetAdapter from Motherboard-connected Intel NIC}.Id
        BandwidthReservationMode        =        [System.String]${Virtual Switch Clade 00---Abstraction-based NetAdapter from Motherboard-connected Intel NIC}.BandwidthReservationMode
        EnableEmbeddedTeaming           =        [System.Boolean]${Virtual Switch Clade 00---Abstraction-based NetAdapter from Motherboard-connected Intel NIC}.EnableEmbeddedTeaming
        LoadBalancingAlgorithm          =        [System.String]${Virtual Switch Clade 00---Abstraction-based NetAdapter from Motherboard-connected Intel NIC}.LoadBalancingAlgorithm
        Ensure                          =        [System.String]${Virtual Switch Clade 00---Abstraction-based NetAdapter from Motherboard-connected Intel NIC}.Ensure
        #PsDscRunAsCredential           =        [PSCredential]${Virtual Switch Clade 00---Abstraction-based NetAdapter from Motherboard-connected Intel NIC}.PsDscRunAsCredential
        DependsOn                       =        ${Dependencys Event Log Channel Status}
      }

      ${Dependencys Virtual Switch Clade 00 Members}.Add(
        [System.String]"[VMSwitch]$(${Virtual Switch Clade 00---Abstraction-based NetAdapter from Motherboard-connected Intel NIC}.Resource_Title)"
      ) | Out-Null
    }
  }
}

${Virtual Switch Clade 00---VMs connect out of RealTek NIC 1} = $Node.'Ignore Virtual Switch Clade 00---VMs connect out of RealTek NIC 1'
if ($null -ne ${Virtual Switch Clade 00---VMs connect out of RealTek NIC 1}) {
  if (
    $null -ne ${Virtual Switch Clade 00---VMs connect out of RealTek NIC 1}.Name -and `
    $null -ne ${Virtual Switch Clade 00---VMs connect out of RealTek NIC 1}.Type
  ) {
    ${vSwitch UUID .txt File BaseName} = ${Virtual Switch Clade 00---VMs connect out of RealTek NIC 1}.Resource_Title -replace '\\','_'
    ${vSwitch UUID .txt File FullName} = "$Statics\vHW\sw\${vSwitch UUID .txt File BaseName}.txt"
    ${Is vSwitch UUID Already Defined} = Test-Path -Path ${vSwitch UUID .txt File FullName}

    if (${Is vSwitch UUID Already Defined}) {
      <#
        start msedge.exe 'https://github.com/dsccommunity/HyperVDsc/wiki/VMSwitch'
        Get-DscResourceProperty -ModuleName 'HyperVDsc' -ResourceName 'VMSwitch' | clip.exe

        Name                     IsKey Mandatory TypeConstraint  Values
        ----                     ----- --------- --------------  ------
        Name                      True      True String          {}
        Type                      True      True String          {External | Internal | Private}

        NetAdapterName           False     False StringArray     {}
        AllowManagementOS        False     False Boolean         {}
        BandwidthReservationMode False     False String          {Default | Weight | Absolute | None | Weight}
        EnableEmbeddedTeaming    False     False Boolean         {}
        Id                       False     False String          {}
        LoadBalancingAlgorithm   False     False String          {Dynamic | HyperVPort}

        Ensure                   False     False String          {Present | Absent}
        PsDscRunAsCredentia1     False     False MSFT_Credential {}
        DependsOn                False     False StringArray     {}
      #>

      VMSwitch ${Virtual Switch Clade 00---VMs connect out of RealTek NIC 1}.Resource_Title {
        Name                            =        [System.String]${Virtual Switch Clade 00---VMs connect out of RealTek NIC 1}.Name
        Type                            =        [System.String]${Virtual Switch Clade 00---VMs connect out of RealTek NIC 1}.Type
        NetAdapterName                  =        [System.String[]]${Virtual Switch Clade 00---VMs connect out of RealTek NIC 1}.NetAdapterName
        AllowManagementOS               =        [System.Boolean]${Virtual Switch Clade 00---VMs connect out of RealTek NIC 1}.AllowManagementOS
        Id                              =        [System.String]${Virtual Switch Clade 00---VMs connect out of RealTek NIC 1}.Id
        BandwidthReservationMode        =        [System.String]${Virtual Switch Clade 00---VMs connect out of RealTek NIC 1}.BandwidthReservationMode
        EnableEmbeddedTeaming           =        [System.Boolean]${Virtual Switch Clade 00---VMs connect out of RealTek NIC 1}.EnableEmbeddedTeaming
        LoadBalancingAlgorithm          =        [System.String]${Virtual Switch Clade 00---VMs connect out of RealTek NIC 1}.LoadBalancingAlgorithm
        Ensure                          =        [System.String]${Virtual Switch Clade 00---VMs connect out of RealTek NIC 1}.Ensure
        #PsDscRunAsCredential           =        [PSCredential]${Virtual Switch Clade 00---VMs connect out of RealTek NIC 1}.PsDscRunAsCredential
        DependsOn                       =        ${Dependencys Event Log Channel Status}
      }

      ${Dependencys Virtual Switch Clade 00 Members}.Add(
        [System.String]"[VMSwitch]$(${Virtual Switch Clade 00---VMs connect out of RealTek NIC 1}.Resource_Title)"
      ) | Out-Null
    }
  }
}

${Virtual Switch Clade 00---VMs connect out of RealTek NIC 2} = $Node.'Ignore Virtual Switch Clade 00---VMs connect out of RealTek NIC 2'
if ($null -ne ${Virtual Switch Clade 00---VMs connect out of RealTek NIC 2}) {
  if (
    $null -ne ${Virtual Switch Clade 00---VMs connect out of RealTek NIC 2}.Name -and `
    $null -ne ${Virtual Switch Clade 00---VMs connect out of RealTek NIC 2}.Type
  ) {
    ${vSwitch UUID .txt File BaseName} = ${Virtual Switch Clade 00---VMs connect out of RealTek NIC 2}.Resource_Title -replace '\\','_'
    ${vSwitch UUID .txt File FullName} = "$Statics\vHW\sw\${vSwitch UUID .txt File BaseName}.txt"
    ${Is vSwitch UUID Already Defined} = Test-Path -Path ${vSwitch UUID .txt File FullName}

    if (${Is vSwitch UUID Already Defined}) {
      <#
        start msedge.exe 'https://github.com/dsccommunity/HyperVDsc/wiki/VMSwitch'
        Get-DscResourceProperty -ModuleName 'HyperVDsc' -ResourceName 'VMSwitch' | clip.exe

        Name                     IsKey Mandatory TypeConstraint  Values
        ----                     ----- --------- --------------  ------
        Name                      True      True String          {}
        Type                      True      True String          {External | Internal | Private}

        NetAdapterName           False     False StringArray     {}
        AllowManagementOS        False     False Boolean         {}
        BandwidthReservationMode False     False String          {Default | Weight | Absolute | None | Weight}
        EnableEmbeddedTeaming    False     False Boolean         {}
        Id                       False     False String          {}
        LoadBalancingAlgorithm   False     False String          {Dynamic | HyperVPort}

        Ensure                   False     False String          {Present | Absent}
        PsDscRunAsCredentia1     False     False MSFT_Credential {}
        DependsOn                False     False StringArray     {}
      #>

      VMSwitch ${Virtual Switch Clade 00---VMs connect out of RealTek NIC 2}.Resource_Title {
        Name                            =        [System.String]${Virtual Switch Clade 00---VMs connect out of RealTek NIC 2}.Name
        Type                            =        [System.String]${Virtual Switch Clade 00---VMs connect out of RealTek NIC 2}.Type
        NetAdapterName                  =        [System.String[]]${Virtual Switch Clade 00---VMs connect out of RealTek NIC 2}.NetAdapterName
        AllowManagementOS               =        [System.Boolean]${Virtual Switch Clade 00---VMs connect out of RealTek NIC 2}.AllowManagementOS
        Id                              =        [System.String]${Virtual Switch Clade 00---VMs connect out of RealTek NIC 2}.Id
        BandwidthReservationMode        =        [System.String]${Virtual Switch Clade 00---VMs connect out of RealTek NIC 2}.BandwidthReservationMode
        EnableEmbeddedTeaming           =        [System.Boolean]${Virtual Switch Clade 00---VMs connect out of RealTek NIC 2}.EnableEmbeddedTeaming
        LoadBalancingAlgorithm          =        [System.String]${Virtual Switch Clade 00---VMs connect out of RealTek NIC 2}.LoadBalancingAlgorithm
        Ensure                          =        [System.String]${Virtual Switch Clade 00---VMs connect out of RealTek NIC 2}.Ensure
        #PsDscRunAsCredential           =        [PSCredential]${Virtual Switch Clade 00---VMs connect out of RealTek NIC 2}.PsDscRunAsCredential
        DependsOn                       =        ${Dependencys Event Log Channel Status}
      }

      ${Dependencys Virtual Switch Clade 00 Members}.Add(
        [System.String]"[VMSwitch]$(${Virtual Switch Clade 00---VMs connect out of RealTek NIC 2}.Resource_Title)"
      ) | Out-Null
    }
  }
}