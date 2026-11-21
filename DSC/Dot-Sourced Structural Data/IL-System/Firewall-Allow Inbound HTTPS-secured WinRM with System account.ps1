${Firewall-Allow Inbound HTTPS-secured WinRM} = $Node.'Firewall-Allow Inbound HTTPS-secured WinRM'
if ($null -ne ${Firewall-Allow Inbound HTTPS-secured WinRM}) {
  if (
    $null -ne ${Firewall-Allow Inbound HTTPS-secured WinRM}.Name
  ) {
    <#
      start msedge.exe 'https://github.com/dsccommunity/NetworkingDsc/wiki/Firewall'
      Get-DscResourceProperty.ps1 -ModuleName 'NetworkingDsc' -ResourceName 'Firewall' | clip.exe

      Name                 IsKey Mandatory TypeConstraint  Values
      ----                 ----- --------- --------------  ------
      Name                  True      True String          {}

      Action               False     False String          {NotConfigured, Allow, Block}                                
      Authentication       False     False String          {NotRequired, Required, NoEncap}                             
      Description          False     False String          {}
      Direction            False     False String          {Inbound, Outbound}                                          
      DisplayName          False     False String          {}
      DynamicTransport     False     False String          {Any | ProximityApps | ProximitySharing | WifiDirectDevices | WifiDirectDisplay | WifiDirectPrinting}
      EdgeTraversalPolicy  False     False String          {Block, Allow, DeferToUser, DeferToApp}                      
      Enabled              False     False String          {True, False}                                                
      Encryption           False     False String          {NotRequired, Required, Dynamic}                             
      Group                False     False String          {}
      IcmpType             False     False StringArray     {}
      InterfaceAlias       False     False StringArray     {}
      InterfaceType        False     False String          {Any, Wired, Wireless, RemoteAccess}                         
      LocalAddress         False     False StringArray     {}
      LocalOnlyMapping     False     False Boolean         {}
      LocalPort            False     False StringArray     {}
      LocalUser            False     False String          {}
      LooseSourceMapping   False     False Boolean         {}
      OverrideBlockRules   False     False Boolean         {}
      Owner                False     False String          {}
      Package              False     False String          {}
      Platform             False     False StringArray     {}
      Profile              False     False StringArray     {}
      Program              False     False String          {}
      Protocol             False     False String          {}
      RemoteAddress        False     False StringArray     {}
      RemoteMachine        False     False String          {}
      RemotePort           False     False StringArray     {}
      RemoteUser           False     False String          {}
      Service              False     False String          {}                   

      Ensure               False     False String          {Present, Absent}                                            
      PsDscRunAsCredentia1 False     False MSFT_Credential {}
      DependsOn            False     False StringArray     {}
    #>
    <#
      Firewall "[System.String] #ResourceName" {
        Name                 = [System.String]

        Action               = [System.String]{ Allow | Block | NotConfigured }
        Authentication       = [System.String]{ NoEncap | NotRequired | Required }
        Description          = [System.String]
        Direction            = [System.String]{ Inbound | Outbound }
        DisplayName          = [System.String]
        DynamicTransport     = [System.String]{ Any | ProximityApps | ProximitySharing | WifiDirectDevices | WifiDirectDisplay | WifiDirectPrinting }
        EdgeTraversalPolicy  = [System.String]{ Allow | Block | DeferToApp | DeferToUser }
        Enabled              = [System.String]{ False | True }
        Encryption           = [System.String]{ Dynamic | NotRequired | Required }
        Group                = [System.String]
        IcmpType             = [System.String[]]
        InterfaceAlias       = [System.String[]]
        InterfaceType        = [System.String]{ Any | RemoteAccess | Wired | Wireless }
        LocalAddress         = [System.String[]]
        LocalOnlyMapping     = [bool]
        LocalPort            = [System.String[]]
        LocalUser            = [System.String]
        LooseSourceMapping   = [bool]
        OverrideBlockRules   = [bool]
        Owner                = [System.String]
        Package              = [System.String]
        Platform             = [System.String[]]
        Profile              = [System.String[]]
        Program              = [System.String]
        Protocol             = [System.String]
        RemoteAddress        = [System.String[]]
        RemoteMachine        = [System.String]
        RemotePort           = [System.String[]]
        RemoteUser           = [System.String]
        Service              = [System.String]

        Ensure               = [System.String]{ Absent | Present }
        PsDscRunAsCredentia1 = [PSCredential]
        DependsOn            = [System.String[]]
      }
    #>

    Firewall ${Firewall-Allow Inbound HTTPS-secured WinRM}.Resource_Title {
      Name                   = [System.String]${Firewall-Allow Inbound HTTPS-secured WinRM}.Name
      DisplayName            = [System.String]${Firewall-Allow Inbound HTTPS-secured WinRM}.DisplayName
      Group                  = [System.String]${Firewall-Allow Inbound HTTPS-secured WinRM}.Group
      Description            = [System.String]${Firewall-Allow Inbound HTTPS-secured WinRM}.Description
      Enabled                = [System.String]${Firewall-Allow Inbound HTTPS-secured WinRM}.Enabled
      Action                 = [System.String]${Firewall-Allow Inbound HTTPS-secured WinRM}.Action
      Direction              = [System.String]${Firewall-Allow Inbound HTTPS-secured WinRM}.Direction
      Protocol               = [System.String]${Firewall-Allow Inbound HTTPS-secured WinRM}.Protocol
      LocalPort              = [System.String[]]${Firewall-Allow Inbound HTTPS-secured WinRM}.LocalPort
      # Service              = [System.String]${Firewall-Allow Inbound HTTPS-secured WinRM}.Service
      RemoteAddress          = [System.String[]]${Firewall-Allow Inbound HTTPS-secured WinRM}.RemoteAddress
      # Authentication       = [System.String]${Firewall-Allow Inbound HTTPS-secured WinRM}.Authentication
      # Encryption           = [System.String]${Firewall-Allow Inbound HTTPS-secured WinRM}.Encryption
      Profile                = [System.String[]]${Firewall-Allow Inbound HTTPS-secured WinRM}.Profile
      # DynamicTransport     = [System.String]{ Any | ProximityApps | ProximitySharing | WifiDirectDevices | WifiDirectDisplay | WifiDirectPrinting }
      # EdgeTraversalPolicy  = [System.String]{ Allow | Block | DeferToApp | DeferToUser }
      # IcmpType             = [System.String[]]
      # InterfaceAlias       = [System.String[]]
      # InterfaceType        = [System.String]{ Any | RemoteAccess | Wired | Wireless }
      # LocalAddress         = [System.String[]]
      # LocalOnlyMapping     = [bool]
      # LocalUser            = [System.String]
      # LooseSourceMapping   = [bool]
      # OverrideBlockRules   = [bool]
      # Owner                = [System.String]
      # Package              = [System.String]
      # Platform             = [System.String[]]
      # Program              = [System.String]
      # RemoteMachine        = [System.String]
      # RemotePort           = [System.String[]]
      # RemoteUser           = [System.String]
      Ensure                 = [System.String]${Firewall-Allow Inbound HTTPS-secured WinRM}.Ensure
      #PsDscRunAsCredential  = [PSCredential]${Firewall-Allow Inbound HTTPS-secured WinRM}.PsDscRunAsCredential
      DependsOn              = ${Dependency WSManServiceConfig}
    }

    ${Dependency Firewall-Allow Inbound HTTPS-secured WinRM} = [System.String[]]@(
      "[Firewall]$(${Firewall-Allow Inbound HTTPS-secured WinRM}.Resource_Title)"
    )
  }
}

<# Notes + reference for 'FirewallProfile' DSC Resource |
  start msedge.exe 'https://github.com/dsccommunity/NetworkingDsc/wiki/FirewallProfile'

  FirewallProfile "[System.String] #ResourceName" {
    Name                            = [System.String]{ Domain | Private | Public }
    Enabled                         = [System.String]{ False | NotConfigured | True }

    AllowInboundRules               = [System.String]{ False | NotConfigured | True }
    AllowLocalFirewallRules         = [System.String]{ False | NotConfigured | True }
    AllowLocalIPsecRules            = [System.String]{ False | NotConfigured | True }
    AllowUnicastResponseToMulticast = [System.String]{ False | NotConfigured | True }
    AllowUserApps                   = [System.String]{ False | NotConfigured | True }
    AllowUserPorts                  = [System.String]{ False | NotConfigured | True }
    DefaultInboundAction            = [System.String]{ Allow | Block | NotConfigured }
    DefaultOutboundAction           = [System.String]{ Allow | Block | NotConfigured }
    DependsOn                       = [System.String[]]
    DisabledInterfaceAliases        = [System.String[]]
    EnableStealthModeForIPsec       = [System.String]{ False | NotConfigured | True }
    LogAllowed                      = [System.String]{ False | NotConfigured | True }
    LogBlocked                      = [System.String]{ False | NotConfigured | True }
    LogFileName                     = [System.String]
    LogIgnored                      = [System.String]{ False | NotConfigured | True }
    LogMaxSizeKilobytes             = [UInt64]
    NotifyOnListen                  = [System.String]{ False | NotConfigured | True }
    PsDscRunAsCredentia1            = [PSCredential]
  }  

  #-\~|~/-#-\~|~/-#-\~|~/-#-\~|~/-#-\~|~/-#-\~|~/-#-\~|~/-#-\~|~/-#-\~|~/-#-\~|~/-#
  Get-DscResourceProperty -ModuleName 'NetworkingDsc' -ResourceName 'FirewallProfile' | clip.exe

  Name                            IsKey Mandatory TypeConstraint  Values
  ----                            ----- --------- --------------  ------
  Name                             True      True String          {Domain, Public, Private}
  Enabled                         False     False String          {True, False, NotConfigured}

  DisabledInterfaceAliases        False     False StringArray     {}
  AllowInboundRules               False     False String          {True, False, NotConfigured}
  AllowLocalFirewallRules         False     False String          {True, False, NotConfigured}
  AllowLocalIPsecRules            False     False String          {True, False, NotConfigured}
  AllowUnicastResponseToMulticast False     False String          {True, False, NotConfigured}
  AllowUserApps                   False     False String          {True, False, NotConfigured}
  AllowUserPorts                  False     False String          {True, False, NotConfigured}
  DefaultInboundAction            False     False String          {Block, Allow, NotConfigured}
  DefaultOutboundAction           False     False String          {Block, Allow, NotConfigured}
  EnableStealthModeForIPsec       False     False String          {True, False, NotConfigured}
  LogAllowed                      False     False String          {True, False, NotConfigured}
  LogBlocked                      False     False String          {True, False, NotConfigured}
  LogFileName                     False     False String          {}
  LogIgnored                      False     False String          {True, False, NotConfigured}
  LogMaxSizeKilobytes             False     False UInt64          {}
  NotifyOnListen                  False     False String          {True, False, NotConfigured}

  PsDscRunAsCredentia1            False     False MSFT_Credential {}
  DependsOn                       False     False StringArray     {}
#>