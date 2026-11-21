<# NOTES |
  The 'IEEnhancedSecurityConfiguration' DSC Resource only applies when the OS instance has a GUI!
#>

${Windows Server Image Index} = $Node.'Windows Server Image Index'
if ( # the configuration target runs an edition of Desktop Experience |
  -not (${Windows Server Image Index} % 2)
) { # the set the IE Enhanced Security Configuration |
  $IEEnhancedSecurityConfigurations = $Node.'IE Enhanced Security Configuration'
  ${Dependencys IE Enhanced Security Configuration} = [System.Collections.ArrayList]::New()
  foreach ($IEEnhancedSecurityConfiguration in $IEEnhancedSecurityConfigurations) {
    if ($null -ne $IEEnhancedSecurityConfiguration) {
      if (
        $null -ne $IEEnhancedSecurityConfiguration.Role    -and `
        $null -ne $IEEnhancedSecurityConfiguration.Enabled
      ) {
        <#
          start msedge.exe 'https://github.com/dsccommunity/ComputerManagementDsc/wiki/IEEnhancedSecurityConfiguration'
          Get-DscResourceProperty.ps1 -ModuleName 'ComputerManagementDsc' -ResourceName 'IEEnhancedSecurityConfiguration' | clip.exe

          Name                 IsKey Mandatory TypeConstraint  Values
          ----                 ----- --------- --------------  ------
          Role                  True      True String          {Administrators | Users}
          Enabled              False      True Boolean         {}

          SuppressRestart      False     False Boolean         {}

          PsDscRunAsCredentia1 False     False MSFT_Credential {}
          DependsOn            False     False StringArray     {}
        #>

        IEEnhancedSecurityConfiguration $IEEnhancedSecurityConfiguration.Resource_Title {
          Role                      =     [System.String]$IEEnhancedSecurityConfiguration.Role
          Enabled                   =     [System.Boolean]$IEEnhancedSecurityConfiguration.Enabled
          SuppressRestart           =     [System.Boolean]$IEEnhancedSecurityConfiguration.SuppressRestart
          #PsDscRunAsCredential     =     [PSCredential]$IEEnhancedSecurityConfiguration.PsDscRunAsCredential
          DependsOn                 =     ${Dependencys Event Log Channel Status}
        }

        ${Dependencys IE Enhanced Security Configuration}.Add(
          [System.String]"[IEEnhancedSecurityConfiguration]$($IEEnhancedSecurityConfiguration.Resource_Title)"
        ) | Out-Null
      }
    }
  }
}