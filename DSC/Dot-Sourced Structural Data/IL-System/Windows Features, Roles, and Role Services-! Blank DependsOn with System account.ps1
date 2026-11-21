<# Notes |
  The set of available ADCS-related features/roles/role services seem to differ across Server Core 
  and Desktop Experience editions of Windows Server! 
  ################################################################################################
  ## Server 2025 Standard Server Core |
  Display Name                                      Name                     Install State
  ------------                                      ----                     -------------
  [ ] Active Directory Certificate Services         AD-Certificate           Available
    [ ] Certification Authority                     ADCS-Cert-Authority      Available
    [ ] Certificate Enrollment Policy Web Service   ADCS-Enroll-Web-Pol      Available
    [ ] Certificate Enrollment Web Service          ADCS-Enroll-Web-Svc      Available
    [ ] Certification Authority Web Enrollment      ADCS-Web-Enrollment      Available
    [ ] Network Device Enrollment Service           ADCS-Device-Enrollment   Available
    [ ] Online Responder                            ADCS-Online-Cert         Available
  ################################################################################################

  ################################################################################################
  ## Server 2025 Standard with Desktop Experience |
  Display Name                                    Name                   Install State
  ------------                                    ----                   -------------
  [ ] Active Directory Certificate Services       AD-Certificate         Available
    [ ] Certification Authority                   ADCS-Cert-Authority    Available
    [ ] Certificate Enrollment Policy Web Service ADCS-Enroll-Web-Pol    Available
    [ ] Certificate Enrollment Web Service        ADCS-Enroll-Web-Svc    Available
    [ ] Certification Authority Web Enrollment    ADCS-Web-Enrollment    Available
    [ ] Network Device Enrollment Service         ADCS-Device-Enrollment Available
    [ ] Online Responder                          ADCS-Online-Cert       Available

  [ ] Remote Server Administration Tools              RSAT                  Available
    [ ] Role Administration Tools                     RSAT-Role-Tools       Available
      [ ] Active Directory Certificate Services Tools RSAT-ADCS             Available
        [ ] Certification Authority Management Tools  RSAT-ADCS-Mgmt        Available
        [ ] Online Responder Tools                    RSAT-Online-Responder Available
  ################################################################################################
#>

${Windows Feature Collection} = $Node.'Windows Features, Roles, and Role Services'
if ($null -ne ${Windows Feature Collection}) {
  ${Dependencys Windows Feature Collection} = [System.Collections.ArrayList]::New()
  foreach (${Windows Feature} in ${Windows Feature Collection}) {
    if (
      $null -ne ${Windows Feature Collection}.Name
    ) {
      <#
        start msedge.exe 'https://github.com/dsccommunity/xPSDesiredStateConfiguration/wiki/xWindowsFeature'
        Get-DscResourceProperty.ps1 -ModuleName 'xPSDesiredStateConfiguration' -ResourceName 'xWindowsFeature'

        Name                 IsKey Mandatory TypeConstraint  Values
        ----                 ----- --------- --------------  ------
        Name                  True      True String          {}

        IncludeAllSubFeature False     False Boolean         {}
        LogPath              False     False String          {}

        Credentia1           False     False MSFT_Credentia1 {}
        Ensure               False     False String          {Present, Absent}
        PsDscRunAsCredentia1 False     False MSFT_Credentia1 {}
        Depends0n            False     False StringArray     {}
      #>

      xWindowsFeature ${Windows Feature}.Resource_Title {
        Name                        = [System.String]${Windows Feature}.Name
        IncludeAllSubfeature        = [System.Boolean]${Windows Feature}.IncludeAllSubfeature
        LogPath                     = [System.String]${Windows Feature}.LogPath
        #Credential                 = [PSCredential]${Windows Feature}.Credential
        Ensure                      = [System.String]${Windows Feature}.Ensure
        #PsDscRunAsCredential       = [PSCredential]${Windows Feature}.PsDscRunAsCredential
        #DependsOn                   = '%_String_%'
        #Depends0n                  = ${Dependencys Event Log Channel Status}
      }

      ${Dependencys Windows Feature Collection}.Add(
        [System.String]"[xWindowsFeature]$(${Windows Feature}.Resource_Title)"
      ) > $null
    }
  }
}