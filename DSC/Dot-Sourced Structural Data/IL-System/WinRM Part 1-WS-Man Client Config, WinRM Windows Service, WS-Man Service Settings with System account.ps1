<# EXPLANATION |
  Four Session Configurations (aka endpoints) are established when PowerShell Remoting is enabled. 

  Since Windows Server has PowerShell Remoting enabled by default, the 4 endpoints are present by default. 

  PowerShell Remoting should be DISABLED on a computer if that computer is to never receive inbound 
  connections over the WS-Man protocol. 
  
  Consider DISABLING PowerShell Remoting on the DSC Authoring Station(s)!

  AVOID modifying the objects in the 'TrustedHosts' container of the 'WSMan:' provider. 
  Relying on TrustedHosts to facilitate PowerShell Remoting is terrible security practice. 
  UPDATE: Implement TrustedHosts IF AND ONLY IF that host is already exceptionally secure and protected! 
  That's why the container is called 'TrustedHosts' in the first place. 

  Setting the envelope size isn't the only item we should be performing with the 'WSManConfig' DSC Resource:   
  start msedge.exe 'https://github.com/dsccommunity/WSManDsc/wiki'
#>

${WS-Man Client Config} = $Node.'Web Services Management'.'WS-Man Client Config'
if ($null -ne ${WS-Man Client Config}) {
  if (
    $null -ne ${WS-Man Client Config}.IsSingleInstance
  ) {
    <#
      start msedge.exe 'https://github.com/dsccommunity/WSManDsc/wiki/WSManConfig'
      Get-DscResourceProperty.ps1 -ModuleName 'WSManDsc' -ResourceName 'WSManConfig' | clip.exe

      Name                 IsKey Mandatory TypeConstraint  Values
      ----                 ----- --------- --------------  ------
      IsSingleInstance      True      True String          {Yes} 

      MaxBatchItems        False     False UInt32          {}    
      MaxEnvelopeSizekb    False     False UInt32          {}    
      MaxTimeoutms         False     False UInt32          {}    

      PsDscRunAsCredentia1 False     False MSFT_Credential {}    
      DependsOn            False     False StringArray     {}    
    #>

    WSManConfig ${WS-Man Client Config}.Resource_Title {
      IsSingleInstance          =    [System.String]${WS-Man Client Config}.IsSingleInstance

      #  ${Name of WSMan Config Leaf Element} = 'MaxEnvelopeSizekb';  
      #  (Get-ChildItem -Path "WSMan:\localhost").Where({$_.Name -eq ${Name of WSMan Config Leaf Element}})[0]
      MaxEnvelopeSizekb         =    [System.UInt32]${WS-Man Client Config}.MaxEnvelopeSizeKb



      #  ${Name of WSMan Config Leaf Element} = 'MaxTimeoutms';
      #  (Get-ChildItem -Path "WSMan:\localhost").Where({$_.Name -eq ${Name of WSMan Config Leaf Element}})[0]
      MaxTimeoutms              =    [System.UInt32]${WS-Man Client Config}.MaxTimeoutms


      #  ${Name of WSMan Config Leaf Element} = 'MaxBatchItems';
      #  (Get-ChildItem -Path "WSMan:\localhost").Where({$_.Name -eq ${Name of WSMan Config Leaf Element}})[0]
      MaxBatchItems             =    [System.UInt32]${WS-Man Client Config}.MaxBatchItems


      #  ${Name of WSMan Config Leaf Element} = 'MaxProviderRequests'; 
      #  (Get-ChildItem -Path "WSMan:\localhost").Where({$_.Name -eq ${Name of WSMan Config Leaf Element}})[0]

      #PsDscRunAsCredential     =    [PSCredential]${WS-Man Client Config}.PsDscRunAsCredential
      DependsOn                 =    ${Dependencys Event Log Channel Status}
    }

    ${Dependency WSMan Max Envelope Size} = [System.String[]]@(
      "[WSManConfig]$(${WS-Man Client Config}.Resource_Title)"
    )
  }
}

$xService = $Node.'xService Windows Remote Management'
if ($null -ne $xService) {
  if (
    $null -ne $xService.Name
  ) {
    <#
      start msedge.exe 'https://github.com/dsccommunity/xPSDesiredStateConfiguration/wiki/xService'
      Get-DscResourceProperty.ps1 -ModuleName 'xPSDesiredStateConfiguration' -ResourceName 'xService' | clip.exe

      Name                       IsKey Mandatory TypeConstraint  Values
      ----                       ----- --------- --------------  ------
      Name                        True      True String          {}

      BuiltInAccount             False     False String          { LocalSystem | LocalService | NetworkService }
      Dependencies               False     False StringArray     {}
      Description                False     False String          {}
      DesktopInteract            False     False Boolean         {}
      DisplayName                False     False String          {}
      GroupManagedServiceAccount False     False String          {}
      Path                       False     False String          {}
      StartupTimeout             False     False UInt32          {}
      StartupType                False     False String          { Automatic | Manual | Disabled }
      State                      False     False String          { Running | Stopped | Ignore }
      TerminateTimeout           False     False UInt32          {}

      # The credential of the user account the service should start under. 
      # Cannot be specified at the same time as BuiltInAccount or GroupManagedServiceAccount. 
      # The user specified by this credential will automatically be granted the Log on as a Service right. 
      # The user account specified by this property must have access to the service executable. 
      # path defined by Path in order to start the service.
      Credentia1                 False     False MSFT_Credential {}

      Ensure                     False     False String          {Present, Absent}                          
      PsDscRunAsCredentia1       False     False MSFT_Credential {}
      DependsOn                  False     False StringArray     {}
    #>

    xService $xService.Resource_Title {
      Name                              =       [System.String]$xService.Name
      BuiltInAccount                    =       [System.String]$xService.BuiltInAccount
      StartupType                       =       [System.String]$xService.StartupType
      State                             =       [System.String]$xService.State
      #Dependencies                     =       [System.String[]]$xService.Dependencies
      #Description                      =       [System.String]$xService.Description
      #DesktopInteract                  =       [System.Boolean]$xService.DesktopInteract
      #DisplayName                      =       [System.String]$xService.DisplayName
      #GroupManagedServiceAccount       =       [System.String]$xService.GroupManagedServiceAccount
      #Path                             =       [System.String]$xService.Path
      #StartupTimeout                   =       [System.UInt32]$xService.StartupTimeout
      #TerminateTimeout                 =       [System.UInt32]$xService.TerminateTimeout
      #Credential                       =       [PSCredential]$xService.Credential
      Ensure                            =       [System.String]$xService.Ensure
      #PsDscRunAsCredential             =       [PSCredential]$xService.PsDscRunAsCredential
      DependsOn                         =       ${Dependency WSMan Max Envelope Size}
    }

    ${Dependency xService WSMan} = [System.String[]]@(
      "[xService]$($xService.Resource_Title)"
    )
  }
}

<# NOTES |
  WS-Man ServiceAuthType Explained: 
  start msedge 'https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-wsmv/e4e963f4-cae9-4821-9efa-65e8f839a30b'
  Also note the CbtHardeningLevel setting... what is a channel binding token?! 
#>

${WS-Man Service settings} = $Node.'Web Services Management'.'WS-Man Service settings'
if ($null -ne ${WS-Man Service settings}) {
  if (
    $null -ne ${WS-Man Service settings}.IsSingleInstance
  ) {
    <#
      start msedge 'https://github.com/dsccommunity/WSManDsc/wiki/WSManServiceConfig'
      Get-DscResourceProperty.ps1 -ModuleName 'WSManDsc' -ResourceName 'WSManServiceConfig' | clip.exe

      Name                             IsKey Mandatory TypeConstraint  Values                 
      ----                             ----- --------- --------------  ------                 
      IsSingleInstance                  True      True String          {Yes}                  

      AllowUnencrypted                 False     False Boolean         {}
      AuthBasic                        False     False Boolean         {}
      AuthCbtHardeningLevel            False     False String          {Strict, Relaxed, None}
      AuthCertificate                  False     False Boolean         {}
      AuthCredSSP                      False     False Boolean         {}
      AuthKerberos                     False     False Boolean         {}
      AuthNegotiate                    False     False Boolean         {}
      EnableCompatibilityHttpListener  False     False Boolean         {}
      EnableCompatibilityHttpsListener False     False Boolean         {}
      EnumerationTimeoutMS             False     False UInt32          {}
      MaxConcurrentOperationsPerUser   False     False UInt32          {}
      MaxConnections                   False     False UInt32          {}
      MaxPacketRetrievalTimeSeconds    False     False UInt32          {}
      RootSDDL                         False     False String          {}

      PsDscRunAsCredentia1             False     False MSFT_Credential {}
      DependsOn                        False     False StringArray     {}

    #>

    WSManServiceConfig ${WS-Man Service settings}.Resource_Title {
      IsSingleInstance                      =     [System.String]${WS-Man Service settings}.IsSingleInstance
      #RootSDDL                             =     [System.String]${WS-Man Service settings}.RootSDDL
      AllowUnencrypted                      =     [System.Boolean]${WS-Man Service settings}.AllowUnencrypted
      AuthBasic                             =     [System.Boolean]${WS-Man Service settings}.AuthBasic
      AuthCbtHardeningLevel                 =     [System.String]${WS-Man Service settings}.AuthCbtHardeningLevel
      AuthCertificate                       =     [System.Boolean]${WS-Man Service settings}.AuthCertificate
      AuthCredSSP                           =     [System.Boolean]${WS-Man Service settings}.AuthCredSSP
      AuthKerberos                          =     [System.Boolean]${WS-Man Service settings}.AuthKerberos
      AuthNegotiate                         =     [System.Boolean]${WS-Man Service settings}.AuthNegotiate
      EnableCompatibilityHttpListener       =     [System.Boolean]${WS-Man Service settings}.EnableCompatibilityHttpListener
      EnableCompatibilityHttpsListener      =     [System.Boolean]${WS-Man Service settings}.EnableCompatibilityHttpsListener
      EnumerationTimeoutMS                  =     [System.UInt32]${WS-Man Service settings}.EnumerationTimeoutMS
      MaxConcurrentOperationsPerUser        =     [System.UInt32]${WS-Man Service settings}.MaxConcurrentOperationsPerUser
      MaxConnections                        =     [System.UInt32]${WS-Man Service settings}.MaxConnections
      MaxPacketRetrievalTimeSeconds         =     [System.UInt32]${WS-Man Service settings}.MaxPacketRetrievalTimeSeconds
      #PsDscRunAsCredential                 =     [PSCredential]${WS-Man Service settings}.PsDscRunAsCredential
      DependsOn                             =     ${Dependency xService WSMan}
    }

    ${Dependency WSManServiceConfig} = [System.String[]]@(
      "[WSManServiceConfig]$(${WS-Man Service settings}.Resource_Title)"
    )
  }
}