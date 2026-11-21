${xCIMSecurity Set Collection} = $Node.'WMI Namespace Access Right Set Collection'
if ($null -ne ${xCIMSecurity Set Collection}) {
  foreach ($xCIMSecurity in ${xCIMSecurity Set Collection}) {
    if (
      $null -ne $xCIMSecurity.AccountName -and `
      #$null -ne $xCIMSecurity.ACL         -and `
      $null -ne $xCIMSecurity.NameSpace
    ) {
      xCIMSecurity $xCIMSecurity.Resource_Title {
        AccountName               =     [System.String]$xCIMSecurity.AccountName
        ACL                       =     $(
          @(
            CIM_ACL {
              AceFlags = 'NameSpaceOnly'          # NameSpaceOnly # ChildOnly # WithChild # 
              Allow    = $true
              Right    = 'Enable','MethodExecute','ProviderWrite','RemoteAccess' 
            }
          )
        )
        NameSpace                 =     [System.String]$xCIMSecurity.NameSpace
        #PsDscRunAsCredential     =     [PSCredential]$xCIMSecurity.PsDscRunAsCredential
        DependsOn                 =     ${Dependency Firewall-Allow Inbound HTTPS-secured WinRM}
      }
    }
  }
}

<# Notes | Reference | Examples |
  start msedge.exe 'https://www.powershellgallery.com/packages/xCimSecurity'
  Get-DscResourceProperty -ModuleName 'xCimSecurity' -ResourceName 'xCimSecurity' | clip.exe

  Name                 IsKey Mandatory TypeConstraint  Values
  ----                 ----- --------- --------------  ------
  AccountName           True      True String          {}
  ACL                  False      True CIM_ACl[]       {}
  NameSpace            False      True String          {}
  PsDscRunAsCredentia1 False     False MSFT_Credential {}
  DependsOn            False     False StringArray     {}

  xCIMSecurity 'Resource_Title' {
    AccountName                 =       [string]
    ACL                         =       [CIM_ACl[]]
    NameSpace                   =       [string]
    [DependsOn                  =       [string[]]]
    [PsDscRunAsCredentia1       =       [PSCredential]]
  }

  View these files for examples:   "$env:ProgramFiles\WindowsPowerShell\Modules\xCIMSecurity\1.0.0.1\DSCResources\xCIMSecurity"

  # examples: 
  start msedge.exe 'https://github.com/PowerShell/WmiNamespaceSecurityDsc/tree/dev/Examples/Resources/WmiNamespaceSecurity'

  # The 'WmiNamespaceSecurityDsc' DSC Resource doesn't seem to work. At least, I can't get it to work. 
  start msedge.exe 'https://github.com/PowerShell/WmiNamespaceSecurityDsc'

  # WMI Namespace Access Settings
  start msedge.exe 'https://learn.microsoft.com/en-us/windows/win32/wmisdk/access-to-wmi-namespaces?source=recommendations#namespace-access-settings'

  # UAC and WMI: 
  start msedge.exe 'https://learn.microsoft.com/en-us/windows/win32/wmisdk/user-account-control-and-wmi'
#>