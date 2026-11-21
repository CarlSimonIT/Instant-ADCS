<# Notes |
  Recall that WS-Management listeners should only be configured on remoting *TARGETS*! 

  The value for Address should be the IPs of the Net IP Interfaces that should receive inbound 
  attempts to establish a PowerShell Remoting session. Assigning the wildcard character (*)
  as the Address is not optimal. 

  It seems that the 'WSManListener' resource removes any other HTTPS Listener currently in-place.

  Leave the HTTP Listener as-is! Do NOT delete the HTTP Listener! PowerShell Direct (communication 
  through the Hyper-V bus) apparently relies on the WinRM service's HTTP Listener. I would be 
  interested if someone could confirm that this is not the case via demonstration.
#>

${WS-Management HTTPS Listener} = $Node.'Web Services Management'.'WS-Man Listeners'.'WS-Management HTTPS Listener'
if ($null -ne ${WS-Management HTTPS Listener}) {
  if (
    $null -ne ${WS-Management HTTPS Listener}.Transport -and `
    $null -ne ${WS-Management HTTPS Listener}.Ensure
  ) {
    <#
      start msedge.exe 'https://github.com/dsccommunity/WSManDsc/wiki/WSManListener'
      Get-DscResourceProperty.ps1 -ModuleName 'WSManDsc' -ResourceName 'WSManListener' | clip.exe

      Name                  IsKey Mandatory TypeConstraint  Values
      ----                  ----- --------- --------------  ------
      Transport              True      True String          {HTTP, HTTPS}
      Ensure                False      True String          {Present, Absent}

      Address               False     False String          {}
      CertificateThumbprint False     False String          {}
      DN                    False     False String          {}
      Hostname              False     False String          {}
      Issuer                False     False String          {}
      MatchAlternate        False     False Boolean         {}
      Port                  False     False UInt16          {}
      SubjectFormat         False     False String          {Both, FQDNOnly, NameOnly}

      PsDscRunAsCredentia1  False     False MSFT_Credential {}
      DependsOn             False     False StringArray     {}

      WSManListener Resource_Title {
        Ensure                = [System.String]{ Absent | Present }
        Transport             = [System.String]{ HTTP | HTTPS }

        Address               = [System.String]
        CertificateThumbprint = [System.String]
        DN                    = [System.String]
        Hostname              = [System.String]
        Issuer                = [System.String]
        MatchAlternate        = [System.Boolean]
        Port                  = [System.UInt16]
        SubjectFormat         = [System.String]{ Both | FQDNOnly | NameOnly }

        PsDscRunAsCredentia1  = [PSCredential]
        DependsOn             = [System.String[]]

        Get-WSManInstance -ResourceURI "WinRM/Config/Listener" -SelectorSet @{Address = '*'; Transport = "HTTPS"}
      }
    #>

    WSManListener ${WS-Management HTTPS Listener}.Resource_Title {
      Transport                 =     [System.String]${WS-Management HTTPS Listener}.Transport
      Ensure                    =     [System.String]${WS-Management HTTPS Listener}.Ensure
      Address                   =     [System.String]${WS-Management HTTPS Listener}.Address
      CertificateThumbprint     =     [System.String]${WS-Management HTTPS Listener}.CertificateThumbprint
      #PsDscRunAsCredential     =     [PSCredential]${WS-Management HTTPS Listener}.PsDscRunAsCredential
      DependsOn                 =     ${Dependency Firewall-Allow Inbound HTTPS-secured WinRM}
    }
  }
}

${WS-Management HTTP Listener} = $Node.'Web Services Management'.'WS-Man Listeners'.'WS-Management HTTP Listener'
if ($null -ne ${WS-Management HTTP Listener}) {
  if (
    $null -ne ${WS-Management HTTP Listener}.Transport -and `
    $null -ne ${WS-Management HTTP Listener}.Ensure
  ) {
    WSManListener ${WS-Management HTTP Listener}.Resource_Title {
      Transport                 =       [System.String]${WS-Management HTTP Listener}.Transport
      Ensure                    =       [System.String]'Present'
      Address                   =       [System.String]${WS-Management HTTP Listener}.Address
      #PsDscRunAsCredential     =       [PSCredential]${WS-Management HTTP Listener}.PsDscRunAsCredential
      DependsOn                 =       ${Dependency WSManServiceConfig}
    }
  }
}

<# xoap examples
  ##################################### ##################################### ##################################### #####################################
  Create an HTTPS Listener using a LocalMachine certificate with a thumbprint
  matching 'F2BE91E92AF040EF116E1CDC91D75C22F47D7BD6'. If the subject in the
  certificate does not match the name of the host then the Hostname parameter
  must be specified. In this example the subject in the certificate is
  'WsManListenerCert'.

  Configuration WSManListener_HTTPS_WithThumbprintAndHostname_Config
  {
      Import-DscResource -Module WSManDsc

      Node localhost
      {
          WSManListener HTTPS
          {
              Transport             = 'HTTPS'
              Ensure                = 'Present'
              CertificateThumbprint = 'F2BE91E92AF040EF116E1CDC91D75C22F47D7BD6'
              Hostname              = 'WsManListenerCert'
          } # End of WSManListener Resource
      } # End of Node
  } # End of Configuration
  ##################################### ##################################### ##################################### #####################################
  Create an HTTPS Listener using a LocalMachine certificate with a thumbprint
  matching 'F2BE91E92AF040EF116E1CDC91D75C22F47D7BD6'. The host name in the
  certificate must match the name of the host machine.

  Configuration WSManListener_HTTPS_WithThumbprint_Config
  {
      Import-DscResource -Module WSManDsc

      Node localhost
      {
          WSManListener HTTPS
          {
              Transport             = 'HTTPS'
              Ensure                = 'Present'
              CertificateThumbprint = 'F2BE91E92AF040EF116E1CDC91D75C22F47D7BD6'
          } # End of WSManListener Resource
      } # End of Node
  } # End of Configuration
  ##################################### ##################################### ##################################### #####################################
  Create an HTTPS Listener using a LocalMachine certificate containing a DN matching
  'O=Contoso Inc, S=Pennsylvania, C=US' that is installed and issued by
  'CN=CONTOSO.COM Issuing CA, DC=CONTOSO, DC=COM' on port 5986.

  Configuration WSManListener_HTTPS_WithDN_Config
  {
      Import-DscResource -Module WSManDsc

      Node localhost
      {
          WSManListener HTTPS
          {
              Transport = 'HTTPS'
              Ensure    = 'Present'
              Issuer    = 'CN=CONTOSO.COM Issuing CA, DC=CONTOSO, DC=COM'
              DN        = 'O=Contoso Inc, S=Pennsylvania, C=US'
          } # End of WSManListener Resource
      } # End of Node
  } # End of Configuration
  ##################################### ##################################### ##################################### #####################################
  Create an HTTPS Listener using a LocalMachine certificate that
  is installed and issued by 'CN=CONTOSO.COM Issuing CA, DC=CONTOSO, DC=COM'
  on port 5986.

  Configuration WSManListener_HTTPS_Config
  {
      Import-DscResource -Module WSManDsc

      Node localhost
      {
          WSManListener HTTPS
          {
              Transport = 'HTTPS'
              Ensure    = 'Present'
              Issuer    = 'CN=CONTOSO.COM Issuing CA, DC=CONTOSO, DC=COM'
          } # End of WSManListener Resource
      } # End of Node
  } # End of Configuration
  ##################################### ##################################### ##################################### #####################################
#>