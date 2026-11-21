${Network Refined v2} = $Node.'Network Refined v2'
if ($null -ne ${Network Refined v2}) {
  #region | OS Instance-level Network Items |
  ${OS Instance} = ${Network Refined v2}.'OS Instance'
  #region | Dns Client Global Setting |
  ${Dns Client Global Setting for this OS Instance} = ${OS Instance}.'Dns Client Global Setting'
  if (
    $null -ne ${Dns Client Global Setting for this OS Instance}
  ) {
    if (
      $null -ne ${Dns Client Global Setting for this OS Instance}.IsSingleInstance
    ) {
      <#
        start msedge.exe 'https://github.com/dsccommunity/NetworkingDsc/wiki/DnsClientGlobalSetting'
        Get-DscResourceProperty.ps1 -ModuleName 'NetworkingDsc' -ResourceName 'DnsClientGlobalSetting' | clip.exe

        Name                 IsKey Mandatory TypeConstraint  Values
        ----                 ----- --------- --------------  ------
        IsSingleInstance      True      True String          {Yes}

        DevolutionLevel      False     False UInt32          {}
        SuffixSearchList     False     False StringArray     {}
        UseDevolution        False     False Boolean         {}

        PsDscRunAsCredentia1 False     False MSFT_Credential {}
        DependsOn            False     False StringArray     {}
      #>

      DnsClientGlobalSetting ${Dns Client Global Setting for this OS Instance}.Resource_Title {
        IsSingleInstance          =      [System.String]${Dns Client Global Setting for this OS Instance}.IsSingleInstance
        DevolutionLevel           =      [System.UInt32]${Dns Client Global Setting for this OS Instance}.DevolutionLevel
        SuffixSearchList          =      [System.String[]]${Dns Client Global Setting for this OS Instance}.SuffixSearchList
        UseDevolution             =      [System.Boolean]${Dns Client Global Setting for this OS Instance}.UseDevolution
        #PsDscRunAsCredential     =      [PSCredential]${Dns Client Global Setting for this OS Instance}.PsDscRunAsCredential
        DependsOn                 =      ${Dependencys Event Log Channel Status}
      }

      ${Dependency DnsClientGlobalSetting} = [System.String[]]@(
        "[DnsClientGlobalSetting]$(${Dns Client Global Setting for this OS Instance}.Resource_Title)"
      )
    }
  }
  #endregion
  #region | Hosts File Entry Collection |
  ${Hosts File Entry Collection} = ${OS Instance}.'Hosts File Entry Collection'
  if (
    $null -ne ${Hosts File Entry Collection}
  ) {
    ${Dependencys Hosts File Entry Collection} = [System.Collections.ArrayList]::New()
    foreach (${Hosts File Entry} in ${Hosts File Entry Collection}) {
      if (
        $null -ne ${Hosts File Entry}.HostName
      ) {
        <#
          start msedge.exe 'https://github.com/dsccommunity/NetworkingDsc/wiki/HostsFile'
          Get-DscResourceProperty.ps1 -ModuleName 'NetworkingDsc' -ResourceName 'HostsFile' | clip.exe

          Name                 IsKey Mandatory TypeConstraint  Values
          ----                 ----- --------- --------------  ------
          HostName              True      True String          {}

          IPAddress            False     False String          {}

          Ensure               False     False String          {Present, Absent}
          PsDscRunAsCredentia1 False     False MSFT_Credential {}
          DependsOn            False     False StringArray     {}
        #>

        HostsFile ${Hosts File Entry}.Resource_Title {
          HostName                  =      [System.String]${Hosts File Entry}.HostName
          IPAddress                 =      [System.String]${Hosts File Entry}.IPAddress
          Ensure                    =      [System.String]${Hosts File Entry}.Ensure
          #PsDscRunAsCredential     =      [PSCredential]${Hosts File Entry}.PsDscRunAsCredential
          DependsOn                 =      ${Dependency DnsClientGlobalSetting}
        }

        ${Dependencys Hosts File Entry Collection}.Add(
          [System.String]"[HostsFile]$(${Hosts File Entry}.Resource_Title)"
        ) | Out-Null
      }
    }
  }
  #endregion
  #region | Windows Internet Name Service |
  ${Windows Internet Name Service} = ${OS Instance}.'Windows Internet Name Service'
  if ($null -ne ${Windows Internet Name Service}) {
    if (
      $null -ne ${Windows Internet Name Service}.IsSingleInstance
    ) {
      <#
        start msedge.exe 'https://github.com/dsccommunity/NetworkingDsc/wiki/WinsSetting'
        Get-DscResourceProperty.ps1 -ModuleName 'NetworkingDsc' -ResourceName 'WinsSetting' | clip.exe

        Name                 IsKey Mandatory TypeConstraint  Values
        ----                 ----- --------- --------------  ------
        IsSingleInstance      True      True String          {Yes} 
        EnableDns            False     False Boolean         {}
        EnableLmHosts        False     False Boolean         {}

        PsDscRunAsCredentia1 False     False MSFT_Credential {}
        DependsOn            False     False StringArray     {}
      #>

      WinsSetting ${Windows Internet Name Service}.Resource_Title {
        IsSingleInstance          =      [System.String]${Windows Internet Name Service}.IsSingleInstance
        EnableDns                 =      [System.Boolean]${Windows Internet Name Service}.EnableDns
        EnableLmHosts             =      [System.Boolean]${Windows Internet Name Service}.EnableLmHosts
        #PsDscRunAsCredential     =      [PSCredential]${Windows Internet Name Service}.PsDscRunAsCredential
        DependsOn                 =      ${Dependencys Hosts File Entry Collection}
      }

      ${Dependency Windows Internet Name Service Setting} = [System.String[]]@(
        "[WinsSetting]$(${Windows Internet Name Service}.Resource_Title)"
      )
    }
  }
  #endregion
  #endregion

  #%_Unspecified_MediaType_ONLY_%${Adapters Config} = ${Network Refined v2}.'Adapters Config'.Where({$_.PhysicalMediaType -eq 'Unspecified'})
  #%_NO_Unspecified_MediaType_%${Adapters Config} = ${Network Refined v2}.'Adapters Config'.Where({$_.PhysicalMediaType -ne 'Unspecified'})
  #%_ANY_MediaType_%${Adapters Config} = ${Network Refined v2}.'Adapters Config'

  #region | Settings on Network Adapters | Configurations on the IPv4 & IPv6 Net IP Interfaces bound to those Network Adapters, when applicable |
  ${Adapters Config} | Select-Object -PipelineVariable 'Adapter Config' | ForEach-Object -Process {
    #region | Update the Name of the Network Adapter | In a Run box type ncpa.cpl and observe the change |
    ${Net Adapter Name} = ${Adapter Config}.'Net Adapter Name'
    if ( # Confirm that a desired state has defined for the Name attribute of this Network Adapter on the configuration target |
      $null -ne ${Net Adapter Name}
    ) {
      if ( # Notice that the attributes 'IsKey' and 'Mandatory' are TRUE for the 'NewName' property of the NetAdapterName DSC Resource |
        $null -ne ${Net Adapter Name}.NewName
      ) {
        <#
          start msedge.exe 'https://github.com/dsccommunity/NetworkingDsc/wiki/NetAdapterName'
          Get-DscResourceProperty.ps1 -ModuleName 'NetworkingDsc' -ResourceName 'NetAdapterName' | clip.exe

          Name                           IsKey Mandatory TypeConstraint  Values
          ----                           ----- --------- --------------  ------
          NewName                         True      True String          {}

          Name                           False     False String          {}
          MacAddress                     False     False String          {}
          Status                         False     False String          { Up | Disconnected | Disabled }
          DriverDescription              False     False String          {}
          IgnoreMultipleMatchingAdapters False     False Boolean         {}
          InterfaceDescription           False     False String          {}
          InterfaceGuid                  False     False String          {}
          InterfaceIndex                 False     False UInt32          {}
          InterfaceNumber                False     False UInt32          {}
          PhysicalMediaType              False     False String          {}

          PsDscRunAsCredentia1           False     False MSFT_Credential {}
          DependsOn                      False     False StringArray     {}
        #>

        NetAdapterName ${Net Adapter Name}.Resource_Title {
          NewName                   =      [System.String]${Net Adapter Name}.NewName
          MacAddress                =      [System.String]${Net Adapter Name}.MacAddress
          Status                    =      [System.String]${Net Adapter Name}.Status
          DriverDescription         =      [System.String]${Net Adapter Name}.DriverDescription
          PhysicalMediaType         =      [System.String]${Net Adapter Name}.PhysicalMediaType
          #PsDscRunAsCredential     =      [PSCredential]${Net Adapter Name}.PsDscRunAsCredential
          DependsOn                 =      ${Dependency WinsSetting}
        }

        ${Dependency Net Adapter Name} = [System.String[]]@(
          [System.String]"[NetAdapterName]$(${Net Adapter Name}.Resource_Title)"
        )
      }
    }
    #endregion
    #region | Set the State of the Network Adapter: Enabled or Disabled | NOTE: The 'State' and 'Status' of a Network Adapter are 2 different things! |
    ${Net Adapter State} = ${Adapter Config}.'Net Adapter State'
    if ( # Confirm that a desired state has defined the State of this Network Adapter on the configuration target |
      $null -ne ${Net Adapter State}
    ) {
      if ( # The NetAdapterState resource 'Name' property has attribute 'IsKey' and 'State' property has attribute 'Mandatory' |
        $null -ne ${Net Adapter State}.Name  -and `
        $null -ne ${Net Adapter State}.State
      ) {
        <#
          start msedge.exe 'https://github.com/dsccommunity/NetworkingDsc/wiki/NetAdapterState'
          Get-DscResourceProperty.ps1 -ModuleName 'NetworkingDsc' -ResourceName 'NetAdapterState' | clip.exe

          Name                 IsKey Mandatory TypeConstraint  Values             
          ----                 ----- --------- --------------  ------             
          Name                  True      True String          {}   
          State                False      True String          {Enabled, Disabled}

          PsDscRunAsCredentia1 False     False MSFT_Credential {}   
          DependsOn            False     False StringArray     {}   
        #>

        NetAdapterState ${Net Adapter State}.Resource_Title {
          Name                      =    [System.String]${Net Adapter State}.Name
          State                     =    [System.String]${Net Adapter State}.State
          #PsDscRunAsCredential     =    [PSCredential]${Net Adapter State}.PsDscRunAsCredential
          DependsOn                 =    ${Dependency Net Adapter Name}
        }

        ${Dependency Net Adapter State} = [System.String[]]@(
          [System.String]"[NetAdapterState]$(${Net Adapter State}.Resource_Title)"
        )
      }
    }
    #endregion
    #region | Advanced Properties of the Network Adapter |
    ${Set of Advanced Properties for this Network Adapter} = ${Adapter Config}.'Set of Advanced Properties for this Network Adapter'
    if (
      $null -ne ${Set of Advanced Properties for this Network Adapter}
    ) {
      ${Dependencys Set of Advanced Properties for this Network Adapter} = [System.Collections.ArrayList]::New()
      foreach (${Advanced Property on Network Adapter} in ${Set of Advanced Properties for this Network Adapter}) {
        if (
          $null -ne ${Advanced Property on Network Adapter}.NetworkAdapterName -and `
          $null -ne ${Advanced Property on Network Adapter}.RegistryKeyword    -and `
          $null -ne ${Advanced Property on Network Adapter}.RegistryValue
        ) {
          <#
            start msedge.exe 'https://github.com/dsccommunity/NetworkingDsc/wiki/NetAdapterAdvancedProperty'
            Get-DscResourceProperty.ps1 -ModuleName 'NetworkingDsc' -ResourceName 'NetAdapterAdvancedProperty' | clip.exe

            Name                 IsKey Mandatory TypeConstraint  Values
            ----                 ----- --------- --------------  ------
            NetworkAdapterName    True      True String          {}
            RegistryKeyword       True      True String          {}
            RegistryValue        False      True String          {}

            PsDscRunAsCredentia1 False     False MSFT_Credential {}
            DependsOn            False     False StringArray     {}
          #>

          NetAdapterAdvancedProperty ${Advanced Property on Network Adapter}.Resource_Title {
            NetworkAdapterName            =        [System.String]${Advanced Property on Network Adapter}.NetworkAdapterName
            RegistryKeyword               =        [System.String]${Advanced Property on Network Adapter}.RegistryKeyword
            RegistryValue                 =        [System.String]${Advanced Property on Network Adapter}.RegistryValue
            #PsDscRunAsCredential         =        [PSCredential]${Advanced Property on Network Adapter}.PsDscRunAsCredential
            DependsOn                     =        ${Dependency Net Adapter State}
          }

          ${Dependencys Set of Advanced Properties for this Network Adapter}.Add(
            [System.String]"[NetAdapterAdvancedProperty]$(${Advanced Property on Network Adapter}.Resource_Title)"
          ) | Out-Null
        }
      }
    }
    #endregion
    #region | Network Adapter Bindings |
    ${Binding States on this Network Adapter} = ${Adapter Config}.'Binding States on this Network Adapter'
    if ($null -ne ${Binding States on this Network Adapter}) {
      ${Dependencys Binding States on this Network Adapter} = [System.Collections.ArrayList]::New()
      foreach (${Binding State on this Network Adapter} in ${Binding States on this Network Adapter}) {
        if ($null -ne ${Binding State on this Network Adapter}) {
          if ( # Only proceed if 'ComponentId' and 'InterfaceAlias' have been defined |
            $null -ne ${Binding State on this Network Adapter}.ComponentId    -and `
            $null -ne ${Binding State on this Network Adapter}.InterfaceAlias
          ) {
            if ( # the Binding in question has DisplayName 'Microsoft LLDP Protocol Driver'...
              # *AND* the OS Instance is Server Core...
              # then do NOT enact this part of the configuration document. 
              -not (
                (${Binding State on this Network Adapter}.ComponentId -eq 'ms_lldp') `
                -and `
                (! (-not ($Node.'Windows Server Image Index' % 2)))
              )
            ) {
              <#
                start msedge.exe 'https://github.com/dsccommunity/NetworkingDsc/wiki/NetAdapterBinding'
                Get-DscResourceProperty.ps1 -ModuleName 'NetworkingDsc' -ResourceName 'NetAdapterBinding' | clip.exe
                # Enabling or disabling a network adapter binding can automatically alter the Enabled/Disabled state of other network adapter bindings: 
                start msedge.exe 'https://learn.microsoft.com/en-us/powershell/module/netadapter/set-netadapterbinding'

                # Specifies the underlying name of the transport or filter in the following form - ms_xxxx, such as ms_tcpip.

                Name                 IsKey Mandatory TypeConstraint  Values
                ----                 ----- --------- --------------  ------
                ComponentId           True      True String          {}
                InterfaceAlias        True      True String          {}

                State                False     False String          {Enabled | Disabled}

                PsDscRunAsCredentia1 False     False MSFT_Credential {}
                DependsOn            False     False StringArray     {}
              #>

              NetAdapterBinding ${Binding State on this Network Adapter}.Resource_Title {
                ComponentId               =      [System.String]${Binding State on this Network Adapter}.ComponentId
                InterfaceAlias            =      [System.String]${Binding State on this Network Adapter}.InterfaceAlias
                State                     =      [System.String]${Binding State on this Network Adapter}.State
                #PsDscRunAsCredential     =      [PSCredential]${Binding State on this Network Adapter}.PsDscRunAsCredential
                DependsOn                 =      ${Dependencys Set of Advanced Properties for this Network Adapter}
              }

              ${Dependencys Binding States on this Network Adapter}.Add(
                [System.String]"[NetAdapterBinding]$(${Binding State on this Network Adapter}.Resource_Title)"
              ) | Out-Null
            }
          }
        }
      }
    }
    #endregion
    #region | Firewall + FirewallProfile | Populate if a use-case arises |
    ${Firewall Rule Set} = ${Adapter Config}.'Firewall Rule Set'
    if ($null -ne ${Firewall Rule Set}) {
      <# Group Policy should handle firewall rules on domain members. Implement with DSC non-member servers |
        start msedge.exe 'https://github.com/dsccommunity/NetworkingDsc/wiki/Firewall'
        Get-DscResourceProperty.ps1 -ModuleName 'NetworkingDsc' -ResourceName 'Firewall' | clip.exe
      #>
    }

    ${Firewall Profile Set} = ${Adapter Config}.'Firewall Profile Set'
    if ($null -ne ${Firewall Profile Set}) {
      <# Investigate whether Group Policy or DSC should control firewall profiles |
        start msedge.exe 'https://github.com/dsccommunity/NetworkingDsc/wiki/FirewallProfile'
        Get-DscResourceProperty.ps1 -ModuleName 'NetworkingDsc' -ResourceName 'FirewallProfile' | clip.exe
      #>
    }
    #endregion
    #region | RDMA on Network Adapter | CRITICAL: Also inspect the network adapter Advanced Property titled 'Network Direct (RDMA)'! |
    ${Remote Direct Memory Access} = ${Adapter Config}.'Remote Direct Memory Access'
    if ( # a desired state for RDMA has been defined |
      $null -ne ${Remote Direct Memory Access}
    ) {
      if ( # the network adapter of focus is 'Microsoft Hyper-V Network Adapter' or 'Hyper-V Virtual Ethernet Adapter' (these are the only RDMA capable NICs currently present) |
        $null -ne ${Remote Direct Memory Access}.Name -and `
        (
          ${Adapter Config}.DriverDescription -match '(^Microsoft Hyper-V Network Adapter$)|(^Hyper-V Virtual Ethernet Adapter$)'
        )
      ) {
        <#
          start msedge.exe 'https://github.com/dsccommunity/NetworkingDsc/wiki/NetAdapterRdma'
          start msedge.exe 'https://learn.microsoft.com/en-us/powershell/module/netadapter/get-netadapterrdma'
          Get-DscResourceProperty.ps1 -ModuleName 'NetworkingDsc' -ResourceName 'NetAdapterRdma' | clip.exe

          Name                 IsKey Mandatory TypeConstraint  Values
          ----                 ----- --------- --------------  ------
          Name                  True      True String          {}
          Enabled              False     False Boolean         {}

          PsDscRunAsCredentia1 False     False MSFT_Credential {}
          DependsOn            False     False StringArray     {}

          The Get-NetAdapterRdma cmdlet gets the remote direct memory access (RDMA) properties of an RDMA-capable network adapter. 
          RDMA is a feature that enables network adapters to transfer data directly between each other without requiring the main processor of the system to be part of that transfer. 
          This results in lower latency and lower processor utilization.
          RDMA can increase networking throughput, reduce latency, and reduce processor utilization. 
          
        #>

        NetAdapterRdma ${Remote Direct Memory Access}.Resource_Title {
          Name                    =    [System.String]${Remote Direct Memory Access}.Name
          Enabled                 =    [System.Boolean]${Remote Direct Memory Access}.Enabled
          #PsDscRunAsCredential   =    [PSCredential]${Remote Direct Memory Access}.PsDscRunAsCredential
          DependsOn               =    ${Dependency Net Adapter State}
        }

        ${Dependency Remote Direct Memory Access} = [System.String[]]@(
          [System.String]"[NetAdapterRdma]$(${Remote Direct Memory Access}.Resource_Title)"
        )
      }
    }
    #endregion
    #region | Receive Side Scaling on Network Adapter |
    ${Receive Side Scaling} = ${Adapter Config}.'Receive Side Scaling'
    if ($null -ne ${Receive Side Scaling}) {
      if (
        $null -ne ${Receive Side Scaling}.Name
      ) {
        if ( # Our Intel NIC doesn't support Receive Side Scaling, apparently. 
          ${Adapter Config}.DriverDescription -ne 'Intel(R) Ethernet Connection (17) I219-LM'
        ) {
          <#
            start msedge.exe 'https://github.com/dsccommunity/NetworkingDsc/wiki/NetAdapterRss'
            start msedge.exe 'https://learn.microsoft.com/en-us/powershell/module/netadapter/enable-netadapterrss'
            Get-DscResourceProperty.ps1 -ModuleName 'NetworkingDsc' -ResourceName 'NetAdapterRss' | clip.exe

            Name                 IsKey Mandatory TypeConstraint  Values
            ----                 ----- --------- --------------  ------
            Name                  True      True String          {}
            Enabled              False     False Boolean         {}

            PsDscRunAsCredentia1 False     False MSFT_Credential {}
            DependsOn            False     False StringArray     {}

            The Get-NetAdapterRss cmdlet gets receive side scaling (RSS) properties of the network adapters that support RSS. 
            RSS is a scalability technology that distributes the receive network traffic among multiple processors by hashing the header of the incoming packet and using an indirection table. 
            Without RSS in Windows ServerÃ‚Â® 2012 and later, network traffic is received on the first processor which can quickly reach full utilization limiting receive network throughput. 
            Various properties can be configured to optimize the performance of RSS.

            The Enable-NetAdapterRss cmdlet enables receive side scaling (RSS) on a network adapter. 
            RSS is a scalability technology that distributes the receive network traffic among multiple processors by hashing the header of the incoming packet. 
            Without RSS in firstref_longhorn and later, network traffic is received on the first processor which can quickly reach full utilization limiting receive network throughput.
            
            lol, did they actually write longhorn instead of Vista? 
          #>

          NetAdapterRss ${Receive Side Scaling}.Resource_Title {
            Name                         =          [System.String]${Receive Side Scaling}.Name
            Enabled                      =          [System.Boolean]${Receive Side Scaling}.Enabled
            #PsDscRunAsCredential        =          [PSCredential]${Receive Side Scaling}.PsDscRunAsCredential
            DependsOn                    =          ${Dependency Net Adapter State}
          }

          ${Dependency Receive Side Scaling} = [System.String[]]@(
            [System.String]"[NetAdapterRss]$(${Receive Side Scaling}.Resource_Title)"
          )
        }
      }
    }
    #endregion
    #region | Receive Segment Coalescing on Network Adapter |
    ${Receive Segment Coalescing} = ${Adapter Config}.'Receive Segment Coalescing'
    if ($null -ne ${Receive Segment Coalescing}) {
      if ( # the network adapter is not one of the physical NICs (which are **NOT** RSC-capable) |
        $null -ne ${Receive Segment Coalescing}.Name     -and `
        $null -ne ${Receive Segment Coalescing}.Protocol -and `
        $null -ne ${Receive Segment Coalescing}.State    -and `
        (
          ${Adapter Config}.DriverDescription -match '(^Hyper-V Virtual Ethernet Adapter$)|(^Microsoft Hyper-V Network Adapter$)'
        )
      ) {
        <#
          start msedge.exe 'https://github.com/dsccommunity/NetworkingDsc/wiki/NetAdapterRsc'
          start msedge.exe 'https://learn.microsoft.com/en-us/powershell/module/netadapter/get-netadapterrsc'
          Get-DscResourceProperty.ps1 -ModuleName 'NetworkingDsc' -ResourceName 'NetAdapterRsc' | clip.exe

          Name                 IsKey Mandatory TypeConstraint  Values
          ----                 ----- --------- --------------  ------
          Name                  True      True String          {}
          Protocol             False      True String          {IPv4 | IPv6 | All}
          State                False      True Boolean         {}

          PsDscRunAsCredentia1 False     False MSFT_Credential {}
          DependsOn            False     False StringArray     {}

          Network adapters might support receive segment coalescing (RSC). 
          RSC takes multiple packets received within the same interrupt period and combines the packets into a single large package to be processed by the network stack. 
          This reduces the processing overhead for incoming packets and reduces the number of processor cycles that are used, leading to better scalability. 
        #>

        NetAdapterRsc ${Receive Segment Coalescing}.Resource_Title {
          Name                       =      [System.String]${Receive Segment Coalescing}.Name
          Protocol                   =      [System.String]${Receive Segment Coalescing}.Protocol
          State                      =      [System.Boolean]${Receive Segment Coalescing}.State
          #PsDscRunAsCredential      =      [PSCredential]${Receive Segment Coalescing}.PsDscRunAsCredential
          DependsOn                  =      ${Dependency Net Adapter State}
        }

        ${Dependency Receive Segment Coalescing} = [System.String[]]@(
          [System.String]"[NetAdapterRsc]$(${Receive Segment Coalescing}.Resource_Title)"
        )
      }
    }
    #endregion
    #region | Disable NetBIOS support on Network Adapters? |
    ${Disable NetBIOS on Network Adapter} = ${Adapter Config}.'Disable NetBIOS on Network Adapter?'
    if ($null -ne ${Disable NetBIOS on Network Adapter}) {
      if (
        $null -ne ${Disable NetBIOS on Network Adapter}.InterfaceAlias -and `
        $null -ne ${Disable NetBIOS on Network Adapter}.Setting
      ) {
        <#
          NetBIOS is an early-era network technology/specification/protocol/software interface later/etc. 
          start msedge.exe 'https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-cifs/1430ebe9-2ad0-4763-b14f-c720338e0482'

          start msedge.exe 'https://github.com/dsccommunity/NetworkingDsc/wiki/NetBios'
          Get-DscResourceProperty.ps1 -ModuleName 'NetworkingDsc' -ResourceName 'NetBios' | clip.exe

          Name                 IsKey Mandatory TypeConstraint  Values                    
          ----                 ----- --------- --------------  ------                    
          InterfaceAlias        True      True String          {}
          Setting              False      True String          {Default | Enable | Disable}

          PsDscRunAsCredentia1 False     False MSFT_Credential {}
          DependsOn            False     False StringArray     {}
        #>

        NetBios ${Disable NetBIOS on Network Adapter}.Resource_Title {
          InterfaceAlias          =    [System.String]${Disable NetBIOS on Network Adapter}.InterfaceAlias
          Setting                 =    [System.String]${Disable NetBIOS on Network Adapter}.Setting
          #PsDscRunAsCredential   =    [PSCredential]${Disable NetBIOS on Network Adapter}.PsDscRunAsCredential
          DependsOn               =    ${Dependency Net Adapter State}
        }

        ${Dependency Disable NetBIOS on Network Adapter} = [System.String[]]@(
          [System.String]"[NetBios]$(${Disable NetBIOS on Network Adapter}.Resource_Title)"
        )
      }
    }
    #endregion
    #region | Disable support for communication between the client network adapter and a WINS server |
    ${Disable WINS Client on Network Adapter} = ${Adapter Config}.'Disable WINS Client on Network Adapter'
    if ($null -ne ${Disable WINS Client on Network Adapter}) {
      if (
        $null -ne ${Disable WINS Client on Network Adapter}.InterfaceAlias
      ) {
        <#
          start msedge.exe 'https://github.com/dsccommunity/NetworkingDsc/wiki/WinsServerAddress'
          Get-DscResourceProperty.ps1 -ModuleName 'NetworkingDsc' -ResourceName 'WinsServerAddress' | clip.exe

          Name                 IsKey Mandatory TypeConstraint  Values
          ----                 ----- --------- --------------  ------
          InterfaceAlias        True      True String          {}
          Address              False     False StringArray     {}
          PsDscRunAsCredentia1 False     False MSFT_Credential {}
          DependsOn            False     False StringArray     {}
        #>

        WinsServerAddress ${Disable WINS Client on Network Adapter}.Resource_Title {
          InterfaceAlias          =    [System.String]${Disable WINS Client on Network Adapter}.InterfaceAlias
          #Address                =    [System.String[]]${Disable WINS Client on Network Adapter}.Address
          #PsDscRunAsCredential   =    [PSCredential]${Disable WINS Client on Network Adapter}.PsDscRunAsCredential
          DependsOn               =    ${Dependency Net Adapter State}
        }

        ${Dependency Disable WINS Client on Network Adapter} = [System.String[]]@(
          [System.String]"[WinsServerAddress]$(${Disable WINS Client on Network Adapter}.Resource_Title)"
        )
      }
    }
    #endregion
    #region | Collections of Settings for the IPv4 Net IP Interface on the Network Adapter |
    ${Adapter Config}.'All Settings on the IPv4 Interface bound to this Network Adapter' `
    | Select-Object -PipelineVariable 'IP Interface Setting' `
    | ForEach-Object -Process {
      ${State of DHCP Client on IPv4 Interface} = ${IP Interface Setting}.'State of DHCP Client on IPv4 Interface'
      ${Default Gateway IPv4 Address-DDN} = ${IP Interface Setting}.'Default Gateway IPv4 Address-DDN'
      #region | IPv4 Interface on Network Adapter |
      ${IPv4 Interface on Network Adapter} = ${IP Interface Setting}.'IPv4 Interface on Network Adapter'
      if ($null -ne ${IPv4 Interface on Network Adapter}) {
        if (
          $null -ne ${IPv4 Interface on Network Adapter}.AddressFamily  -and `
          $null -ne ${IPv4 Interface on Network Adapter}.InterfaceAlias
        ) {
          <#
            start msedge.exe 'https://github.com/dsccommunity/NetworkingDsc/wiki/NetIPInterface'
            Get-DscResourceProperty.ps1 -ModuleName 'NetworkingDsc' -ResourceName 'NetIPInterface' | clip.exe

            Name                            IsKey Mandatory TypeConstraint  Values
            ----                            ----- --------- --------------  ------
            AddressFamily                    True      True String          {IPv4 | IPv6}
            InterfaceAlias                   True      True String          {}

            AdvertiseDefaultRoute           False     False String          {Enabled | Disabled}
            Advertising                     False     False String          {Enabled | Disabled}
            AutomaticMetric                 False     False String          {Enabled | Disabled}
            Dhcp                            False     False String          {Enabled | Disabled}
            DirectedMacWolPattern           False     False String          {Enabled | Disabled}

            # ECN (Explicit Congestion Notification) marking. Aka Data CenterTCP (DCTCP) enables the physical switch and OS
            # to regulate traffic flow and prevent the buffer resources of the switch from exhausting. 
            EcnMarking                      False     False String          {Disabled | UseEct1 | UseEct0 | AppDecide}
            ForceArpNdWolPattern            False     False String          {Enabled | Disabled}
            Forwarding                      False     False String          {Enabled | Disabled}
            IgnoreDefaultRoutes             False     False String          {Enabled | Disabled}
            InterfaceMetric                 False     False UInt32          {}
            ManagedAddressConfiguration     False     False String          {Enabled | Disabled}
            NeighborUnreachabilityDetection False     False String          {Enabled | Disabled}
            NlMtu                           False     False UInt32          {}
            OtherStatefulConfiguration      False     False String          {Enabled | Disabled}
            RouterDiscovery                 False     False String          {Enabled | Disabled | ControlledByDHCP}
            WeakHostReceive                 False     False String          {Enabled | Disabled}
            WeakHostSend                    False     False String          {Enabled | Disabled}

            PsDscRunAsCredentia1            False     False MSFT_Credential {}
            DependsOn                       False     False StringArray     {}
          #>

          NetIPInterface ${IPv4 Interface on Network Adapter}.Resource_Title {
            AddressFamily                       =     [System.String]${IPv4 Interface on Network Adapter}.AddressFamily
            InterfaceAlias                      =     [System.String]${IPv4 Interface on Network Adapter}.InterfaceAlias
            AdvertiseDefaultRoute               =     [System.String]${IPv4 Interface on Network Adapter}.AdvertiseDefaultRoute
            Advertising                         =     [System.String]${IPv4 Interface on Network Adapter}.Advertising
            AutomaticMetric                     =     [System.String]${IPv4 Interface on Network Adapter}.AutomaticMetric
            Dhcp                                =     [System.String]${IPv4 Interface on Network Adapter}.Dhcp
            DirectedMacWolPattern               =     [System.String]${IPv4 Interface on Network Adapter}.DirectedMacWolPattern
            EcnMarking                          =     [System.String]${IPv4 Interface on Network Adapter}.EcnMarking
            ForceArpNdWolPattern                =     [System.String]${IPv4 Interface on Network Adapter}.ForceArpNdWolPattern
            Forwarding                          =     [System.String]${IPv4 Interface on Network Adapter}.Forwarding
            IgnoreDefaultRoutes                 =     [System.String]${IPv4 Interface on Network Adapter}.IgnoreDefaultRoutes
            InterfaceMetric                     =     [System.UInt32]${IPv4 Interface on Network Adapter}.InterfaceMetric
            ManagedAddressConfiguration         =     [System.String]${IPv4 Interface on Network Adapter}.ManagedAddressConfiguration
            NeighborUnreachabilityDetection     =     [System.String]${IPv4 Interface on Network Adapter}.NeighborUnreachabilityDetection
            NlMtu                               =     [System.UInt32]${IPv4 Interface on Network Adapter}.NlMtu
            OtherStatefulConfiguration          =     [System.String]${IPv4 Interface on Network Adapter}.OtherStatefulConfiguration
            RouterDiscovery                     =     [System.String]${IPv4 Interface on Network Adapter}.RouterDiscovery
            WeakHostReceive                     =     [System.String]${IPv4 Interface on Network Adapter}.WeakHostReceive
            WeakHostSend                        =     [System.String]${IPv4 Interface on Network Adapter}.WeakHostSend
            #PsDscRunAsCredential               =     [PSCredential]${IPv4 Interface on Network Adapter}.PsDscRunAsCredential
            DependsOn                           =     ${Dependency Net Adapter State}
          }

          ${Dependency IPv4 Interface on Network Adapter} = [System.String[]]@(
            [System.String]"[NetIPInterface]$(${IPv4 Interface on Network Adapter}.Resource_Title)"
          )
        }
      }
      #endregion
      #region | ReadMe! | ReadMe! | ReadMe! | ReadMe! | ReadMe! | ReadMe! | ReadMe! |
      #| These DSC Resources are defined only if automatic IP config on the IPv4 interface (via DHCP) is DISABLED. |#
      #| The Net IP Interfaces on Network Adapters connected to DHCP servers + DNS servers *MUST* have static IP   |#
      #| configuration if that Net IP Interface is providing DHCP/DNS services to other computers.                 |#
      #| Not every Net IP Interface on a DHCP/DNS server needs to have static IP configuration. The DHCP client on |#
      #| the Net IP Interface (of a DNS/DHCP server) that's dedicated to managing the OS, for example, can perform |# 
      #| IP configuration if that same Net IP Interface does also respond to incoming DNS Queries or DORA.         |#
      if ( # Define these resources if the IP config on the Net IP Interface is statically set...
        [System.String]${State of DHCP Client on IPv4 Interface} -eq 'Disabled'
      ) {
        #region | Static or Dynamic IP Address of IPv4 Interface |
        ${Static IP Address on IPv4 Interface} = ${IP Interface Setting}.'Static or Dynamic IP Address of IPv4 Interface'
        if ($null -ne ${Static IP Address on IPv4 Interface}) {
          if (
            $null -ne ${Static IP Address on IPv4 Interface}.AddressFamily  -and `
            $null -ne ${Static IP Address on IPv4 Interface}.InterfaceAlias
          ) {
            <#
              start msedge.exe 'https://github.com/dsccommunity/NetworkingDsc/wiki/IPAddress'
              Get-DscResourceProperty.ps1 -ModuleName 'NetworkingDsc' -ResourceName 'IPAddress' | clip.exe

              Name                 IsKey Mandatory TypeConstraint  Values
              ----                 ----- --------- --------------  ------
              AddressFamily         True      True String          {IPv4 | IPv6}
              InterfaceAlias        True      True String          {}

              # The desired IP address, optionally including prefix length using CIDR notation.
              IPAddress            False     False StringArray     {}
              # Indicates whether or not existing IP addresses on an interface will be retained.
              KeepExistingAddress  False     False Boolean         {}

              PsDscRunAsCredentia1 False     False MSFT_Credential {}
              DependsOn            False     False StringArray     {}
            #>

            IPAddress ${Static IP Address on IPv4 Interface}.Resource_Title {
              AddressFamily               =        [System.String]${Static IP Address on IPv4 Interface}.AddressFamily
              InterfaceAlias              =        [System.String]${Static IP Address on IPv4 Interface}.InterfaceAlias
              IPAddress                   =        [System.String[]]${Static IP Address on IPv4 Interface}.IPAddress
              KeepExistingAddress         =        [System.Boolean]${Static IP Address on IPv4 Interface}.KeepExistingAddress
              #PsDscRunAsCredential       =        [PSCredential]${Static IP Address on IPv4 Interface}.PsDscRunAsCredential
              DependsOn                   =        ${Dependency IPv4 Interface on Network Adapter}
            }

            ${Dependency Static IP Address on IPv4 Interface} = [System.String[]]@(
              [System.String]"[IPAddress]$(${Static IP Address on IPv4 Interface}.Resource_Title)"
            )
          }
        }
        #endregion
        #region | Option for Static IPv4 Address |
        ${Option for Static IPv4 Address} = ${IP Interface Setting}.'Option for Static IPv4 Address'
        if ($null -ne ${Option for Static IPv4 Address}) {
          if (
            $null -ne ${Option for Static IPv4 Address}.IPAddress
          ) {
            <# Reference for 'SkipAsSource' parameter |
              start msedge.exe 'https://devblogs.microsoft.com/scripting/use-powershell-to-change-ip-behavior-with-skipassource/'
              An admin intensive task that I have recently scripted involves the primary IP address emulation in Windows using the SkipAsSource option. 
              For those still on Windows XP and Windows Server 2003, let me explain. 
              
              There is no longer a primary IP address in the Windows OS. 
              
              When you have multiple IP addresses on a Windows Server 2008 (and later versions) network adapter, 
              the address you enter on the General tab of the IPv4 properties, 
              which was traditionally the primary IP address, 
              is no longer guaranteed to be the IP address used by the computer to communicate on the network. 
              
              All IP addresses are registered in DNS by default and any one of them can be used by the host. 
              This usually does not cause a problem, unless you have very strict firewall controls. 
              Especially on the network parameter. 
              If you need that old primary IP behavior, you have to add the IP addresses by using the SkipAsSource option. 
              Which you canÃ¢â‚¬â„¢t do in the UI. 
              You must use netsh, or Windows PowerShell 3.0, if youÃ¢â‚¬â„¢re using Windows Server 2012 or Windows 8. 
              And if the IP address is already there, you may have to remove it first, then add it back with SkipAsSource set. 
              This isnÃ¢â‚¬â„¢t a problem if you only have two or three IP addresses on the server. 
              When you get to about forty or fifty, like on a web server, the task tends to make server admins very grumpy, very fast. 
              Windows PowerShell to the rescue! [Queue dramatic super hero music.] 
              I wonÃ¢â‚¬â„¢t go into why this behavior changed as other people have explained it in great detail. 
              
              Instead, IÃ¢â‚¬â„¢ll give you a few links to well-written articles by people who know how to stick to a single point of view and know a great deal about the topic. 
              start msedge.exe 1'http://blogs.technet.com/b/networking/archive/2009/04/25/source-ip-address-selection-on-a-multi-homed-windows-computer.aspx'
              start msedge.exe 'http://blogs.technet.com/b/rmilne/archive/2012/02/08/fine-grained-control-when-registering-multiple-ips.aspx'
              start msedge.exe 'http://support.microsoft.com/kb/975808'
              
              Basics of SkipAsSource: 
              SkipAsSource = TRUE means the IP Address will NOT be registered in DNS and will NOT be used for host-initiated outgoing communications. 
              However, if an application specifically binds to that IP Address, that IP Address can be registered in the DNS database. 
              
              SkipAsSource = FALSE means the IP Address *IS* registered in DNS and therefore is used for communication. 
              Setting SkipAsSource to False on a single IP address emulates the primary IP address behavior. 
              
              You can view the SkipAsSource state of the IP addresses on a computer by using one of the following commands: Get-NetIPAddress
              Configure the 'SkipAsSource' on an IP address: 
              # set some constants
              $primaryIP    = "10.0.0.2"
              $netInterface = "Ethernet"

              # get all the IP addresses on the interface, filtered by IPv4 and excluding the primary IP 
              [array]$IPs = Get-NetIPAddress -InterfaceAlias $netInterface | Where-Object {$_.AddressFamily -eq "IPv4" -and $_.IPAddress -ne $primaryIP}  

              # set primary IP SkipAsSource to false
              Set-NetIPAddress -IPAddress $primaryIP -InterfaceAlias $netInterface -SkipAsSource $false  

              # set other IP addresses with SkipAsSource equal to true

              SkipAsSource explained: start msedge.exe 'https://learn.microsoft.com/en-us/powershell/module/nettcpip/set-netipaddress?view=windowsserver2025-ps#-skipassource'
            #>
            <#
              start msedge.exe 'https://github.com/dsccommunity/NetworkingDsc/wiki/IPAddressOption'
              Get-DscResourceProperty.ps1 -ModuleName 'NetworkingDsc' -ResourceName 'IPAddressOption' | clip.exe

              Name                 IsKey Mandatory TypeConstraint  Values
              ----                 ----- --------- --------------  ------
              IPAddress             True      True String          {}

              # It looks like here's only one possible IP Address Option: SkipAsSource. 
              # For that reason, don't bother defining as an array. 
              # If this SkipAsSource = True, then the statically configured ip interface is NOT used 
              # for outgoing traffic and a DNS record is NOT registered in DNS...? 
              SkipAsSource         False     False Boolean         {}

              PsDscRunAsCredentia1 False     False MSFT_Credential {}
              DependsOn            False     False StringArray     {}
            #>

            IPAddressOption ${Option for Static IPv4 Address}.Resource_Title {
              IPAddress                  =      [System.String]${Option for Static IPv4 Address}.IPAddress
              SkipAsSource               =      [System.Boolean]${Option for Static IPv4 Address}.SkipAsSource
              #PsDscRunAsCredential      =      [PSCredential]${Option for Static IPv4 Address}.PsDscRunAsCredential
              DependsOn                  =      ${Dependency Static IP Address on IPv4 Interface}
            }

            ${Dependency Option for Static IPv4 Address} = [System.String[]]@(
              [System.String]"[IPAddressOption]$(${Option for Static IPv4 Address}.Resource_Title)"
            )
          }
        }
        #endregion
        #region | IP Address of Default Gateway on Static IPv4 Interface |
        ${IP Address of Default Gateway on Static IPv4 Interface} = ${IP Interface Setting}.'IP Address of Default Gateway on Static IPv4 Interface'
        if ($null -ne ${IP Address of Default Gateway on Static IPv4 Interface}) {
          if (
            $null -ne ${IP Address of Default Gateway on Static IPv4 Interface}.AddressFamily  -and `
            $null -ne ${IP Address of Default Gateway on Static IPv4 Interface}.InterfaceAlias
          ) {
            <#
              start msedge.exe 'https://github.com/dsccommunity/NetworkingDsc/wiki/DefaultGatewayAddress'
              Get-DscResourceProperty.ps1 -ModuleName 'NetworkingDsc' -ResourceName 'DefaultGatewayAddress' | clip.exe

              Name                 IsKey Mandatory TypeConstraint  Values
              ----                 ----- --------- --------------  ------
              AddressFamily         True      True String          {IPv4 | IPv6}
              InterfaceAlias        True      True String          {}

              Address              False     False String          {}

              PsDscRunAsCredentia1 False     False MSFT_Credential {}
              DependsOn            False     False StringArray     {}
            #>

            DefaultGatewayAddress ${IP Address of Default Gateway on Static IPv4 Interface}.Resource_Title {
              AddressFamily              =      [System.String]${IP Address of Default Gateway on Static IPv4 Interface}.AddressFamily
              InterfaceAlias             =      [System.String]${IP Address of Default Gateway on Static IPv4 Interface}.InterfaceAlias
              Address                    =      [System.String]${IP Address of Default Gateway on Static IPv4 Interface}.Address
              #PsDscRunAsCredential      =      [PSCredential]${IP Address of Default Gateway on Static IPv4 Interface}.PsDscRunAsCredential
              DependsOn                  =      ${Dependency Option for Static IPv4 Address}
            }

            ${Dependency IP Address of Default Gateway on Static IPv4 Interface} = [System.String[]]@(
              [System.String]"[DefaultGatewayAddress]$(${IP Address of Default Gateway on Static IPv4 Interface}.Resource_Title)"
            )
          }
        }
        #endregion
        #region | IP Address of DNS Server on Static IPv4 Interface |
        ${IP Address of DNS Server on Static IPv4 Interface} = ${IP Interface Setting}.'IP Address of DNS Server on Static IPv4 Interface'
        if ($null -ne ${IP Address of DNS Server on Static IPv4 Interface}) {
          if (
            $null -ne ${IP Address of DNS Server on Static IPv4 Interface}.AddressFamily  -and `
            $null -ne ${IP Address of DNS Server on Static IPv4 Interface}.InterfaceAlias
          ) {
            <#
              Validate = TRUE requires that the DNS Server addresses be validated if value is changed. 
              When Validate = TRUE, changing the IP address to which the DNS client (for that Net IP 
              Interface) sends a DNS Query will cause Windows to throw the error 
              "A general error occurred that is not covered by a more specific error code."
              if the specified DNS server is not accessible.
            #>
            <#
              start msedge.exe 'https://github.com/dsccommunity/NetworkingDsc/wiki/DnsServerAddress'
              Get-DscResourceProperty.ps1 -ModuleName 'NetworkingDsc' -ResourceName 'DnsServerAddress' | clip.exe

              Name                 IsKey Mandatory TypeConstraint  Values      
              ----                 ----- --------- --------------  ------      
              AddressFamily         True      True String          {IPv4 | IPv6}
              InterfaceAlias        True      True String          {}

              Address              False     False StringArray     {}
              Validate             False     False Boolean         {}

              PsDscRunAsCredentia1 False     False MSFT_Credential {}
              DependsOn            False     False StringArray     {}
            #>

            DnsServerAddress ${IP Address of DNS Server on Static IPv4 Interface}.Resource_Title {
              AddressFamily             =    [System.String]${IP Address of DNS Server on Static IPv4 Interface}.AddressFamily
              InterfaceAlias            =    [System.String]${IP Address of DNS Server on Static IPv4 Interface}.InterfaceAlias
              Address                   =    [System.String[]]${IP Address of DNS Server on Static IPv4 Interface}.Address
              Validate                  =    [System.Boolean]${IP Address of DNS Server on Static IPv4 Interface}.Validate
              #PsDscRunAsCredential     =    [PSCredential]${IP Address of DNS Server on Static IPv4 Interface}.PsDscRunAsCredential
              DependsOn                 =    ${Dependency IP Address of Default Gateway on Static IPv4 Interface}
            }

            ${Dependency IP Address of DNS Server on Static IPv4 Interface} = [System.String[]]@(
              [System.String]"[DnsServerAddress]$(${IP Address of DNS Server on Static IPv4 Interface}.Resource_Title)"
            )
          }
        }
        #endregion
      }
      #endregion
      #region | Static IPv4 Routes |
      ${Static IPv4 Route Set} = ${IP Interface Setting}.'Static IPv4 Route Set'
      if ($null -ne ${Static IPv4 Route Set}) {
        ${Dependencys Static IPv4 Routes} = [System.Collections.ArrayList]::New()
        foreach (${Static IPv4 Route} in ${Static IPv4 Route Set}) {
          if (
            ${Static IPv4 Route}.AddressFamily        -and `
            ${Static IPv4 Route}.DestinationPrefix    -and `
            ${Static IPv4 Route}.InterfaceAlias       -and `
            ${Static IPv4 Route}.NextHop
          ) {
            <#
              start msedge.exe 'https://github.com/dsccommunity/NetworkingDsc/wiki/Route'
              Get-DscResourceProperty.ps1 -ModuleName 'NetworkingDsc' -ResourceName 'Route' | clip.exe

              Name                 IsKey Mandatory TypeConstraint  Values
              ----                 ----- --------- --------------  ------
              AddressFamily         True      True String          {IPv4 | IPv6}

              # Specifies a destination prefix of an IP route. 
              # Destination prefix format: <IP address prefix>/<prefix length>
              DestinationPrefix     True      True String          {}

              InterfaceAlias        True      True String          {}

              NextHop               True      True String          {}
              
              'PreferredLifetime' specifies a preferred lifetime in seconds of an IP route. 
              Type is [TimeSpan]
              Default value appears to be 2^63 - 1 'Ticks', and there are 10 million ticks per second
              (Get-NetRoute -AddressFamily 'IPv4')[0].PreferredLifetime
              start msedge.exe 'https://www.wolframalpha.com/input?i=9223372036854775807'
              
              Error Message: Cannot process argument transformation on parameter 'PreferredLifetime'. 
              Cannot convert value "2147483647" to type "System.TimeSpan". 
              Error: "The TimeSpan could not be parsed because at least one of the numeric components is out of range or contains too many digits."

              PreferredLifetime    False     False Real64          {}

              # Default = No
              Publish              False     False String          {No | Yes | Age}

              # Default = 256
              RouteMetric          False     False UInt16          {}

              Ensure               False     False String          {Present | Absent}
              PsDscRunAsCredentia1 False     False MSFT_Credential {}
              DependsOn            False     False StringArray     {}
            #>

            Route ${Static IPv4 Route}.Resource_Title {
              AddressFamily                   =          [System.String]${Static IPv4 Route}.AddressFamily
              DestinationPrefix               =          [System.String]${Static IPv4 Route}.DestinationPrefix
              InterfaceAlias                  =          [System.String]${Static IPv4 Route}.InterfaceAlias
              NextHop                         =          [System.String]${Static IPv4 Route}.NextHop
              #PreferredLifetime               =          [Real64]${Static IPv4 Route}.PreferredLifetime
              Publish                         =          [System.String]${Static IPv4 Route}.Publish
              RouteMetric                     =          [System.UInt16]${Static IPv4 Route}.RouteMetric
              #PsDscRunAsCredential           =          [PSCredential]${Static IPv4 Route}.PsDscRunAsCredential
              DependsOn                       =          ${Dependency IPv4 Interface on Network Adapter}
            }

            ${Dependencys Static IPv4 Routes}.Add(
              [System.String]"[Route]$(${Static IPv4 Route}.Resource_Title)"
            ) | Out-Null
          }
        }
      }
      #endregion
      #region | Large Send Offload version 2 |
      ${LSOv2 Setting on IPv4 Interface} = ${IP Interface Setting}.'Large Send Offload version 2'
      if ($null -ne ${LSOv2 Setting on IPv4 Interface}) {
        if (
          $null -ne ${LSOv2 Setting on IPv4 Interface}.Name       -and `
          $null -ne ${LSOv2 Setting on IPv4 Interface}.Protocol   -and `
          $null -ne ${LSOv2 Setting on IPv4 Interface}.State
        ) {
          <#
            start msedge.exe 'https://github.com/dsccommunity/NetworkingDsc/wiki/NetAdapterLso'
            start msedge.exe 'https://learn.microsoft.com/en-us/powershell/module/netadapter/get-netadapterlso'
            Get-DscResourceProperty.ps1 -ModuleName 'NetworkingDsc' -ResourceName 'NetAdapterLso' | clip.exe

            Name                 IsKey Mandatory TypeConstraint  Values
            ----                 ----- --------- --------------  ------
            Name                  True      True String          {}
            Protocol              True      True String          {V1IPv4, IPv4, IPv6}
            State                False      True Boolean         {}

            PsDscRunAsCredentia1 False     False MSFT_Credential {}
            DependsOn            False     False StringArray     {}

            The Enable-NetAdapterLso cmdlet enables the state of the Large Send Offload version 2 (LSOv2) 
            settings, on the network adapter. 

            ---> There is no such thing as 'LSOv4' or 'LSOv6'. Only LSOv2 for IPv4 and IPv6. 
            
            If LSOv2 is not specified for either IPv4 or IPv6, then LSOv2 is enabled for both address families.
            
            LSOv2 is a technology in which the work of segmenting data into network frames is performed by 
            the network adapter instead of by the software in the TCP/IP stack. 

            With LSOv2, TCP/IP sends very large data packets to the network adapter driver and the network 
            adapter hardware. 

            The network adapter hardware separates the data into smaller network-sized frames. 

            This increases the speed of high-end send operations and decreases the processor usage of the 
            computer, because the work is performed by the network adapter hardware. 

            To enable just LSOv4 or LSOv6, run the Set-NetAdapterLso cmdlet.
          #>

          <#
            It makes no sense to implement both Jumbo Frames and LSOv2 at the same time! 
          #>

          NetAdapterLso ${LSOv2 Setting on IPv4 Interface}.Resource_Title {
            Name                        =      [System.String]${LSOv2 Setting on IPv4 Interface}.Name
            Protocol                    =      [System.String]${LSOv2 Setting on IPv4 Interface}.Protocol
            State                       =      [System.Boolean]${LSOv2 Setting on IPv4 Interface}.State
            #PsDscRunAsCredential       =      [PSCredential]${LSOv2 Setting on IPv4 Interface}.PsDscRunAsCredential
            DependsOn                   =      ${Dependency IPv4 Interface on Network Adapter}
          }

          ${Dependency LSOv2 Setting on IPv4 Interface} = [System.String[]]@(
            [System.String]"[NetAdapterLso]$(${LSOv2 Setting on IPv4 Interface}.Resource_Title)"
          )
        }
      }

      #endregion
    }
    #endregion
    #region | Collections of Settings for the IPv6 Net IP Interface on the Network Adapter |
    <#
      ${Adapters Config}.'All Settings on the IPv6 Interface bound to this Network Adapter' `
      | Where-Object -FilterScript {$null -ne $_} -PipelineVariable 'IP Interface Setting' `
      | ForEach-Object -Process {
        #region |  |
        # ${blank} = ${IP Interface Setting}.'blank'
        # if ($null -ne ${blank}) {}
        # if ($null -ne ${blank}) {}
        # if ($null -ne ${blank}) {}
        #endregion
        #region |  |
        # ${blank} = ${IP Interface Setting}.'blank'
        # if ($null -ne ${blank}) {}
        # if ($null -ne ${blank}) {}
        # if ($null -ne ${blank}) {}
        #endregion
        #region |  |
        # ${blank} = ${IP Interface Setting}.'blank'
        # if ($null -ne ${blank}) {}
        # if ($null -ne ${blank}) {}
        # if ($null -ne ${blank}) {}
        #endregion
        #region |  |
        # ${blank} = ${IP Interface Setting}.'blank'
        # if ($null -ne ${blank}) {}
        # if ($null -ne ${blank}) {}
        # if ($null -ne ${blank}) {}
        #endregion
        #region |  |
        # ${blank} = ${IP Interface Setting}.'blank'
        # if ($null -ne ${blank}) {}
        # if ($null -ne ${blank}) {}
        # if ($null -ne ${blank}) {}
        #endregion
      }
    #>
    #endregion
  }
  #endregion
}