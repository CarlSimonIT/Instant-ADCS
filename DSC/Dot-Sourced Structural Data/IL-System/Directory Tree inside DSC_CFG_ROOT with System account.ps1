${DSC_CFG_ROOT Directory Tree Set} = $ConfigurationData.GCD.'DSC_CFG_ROOT Directory Tree Set'
${DSC_CFG_ROOT Directory Tree Credentials} = $Node.'DSC_CFG_ROOT Directory Tree Credentials'

if ($null -ne ${DSC_CFG_ROOT Directory Tree Set}) {
  ${Dependencys DSC_CFG_ROOT Directory Tree Set} = [System.Collections.ArrayList]::New()
  foreach (${DSC_CFG_ROOT Directory Tree} in ${DSC_CFG_ROOT Directory Tree Set}) {
    File ${DSC_CFG_ROOT Directory Tree}.Resource_Title {
      DestinationPath           =      [System.String]${DSC_CFG_ROOT Directory Tree}.DestinationPath
      Type                      =      [System.String]${DSC_CFG_ROOT Directory Tree}.Type
      Force                     =      [System.Boolean]${DSC_CFG_ROOT Directory Tree}.Force
      #Credential               =      [PSCredential]${DSC_CFG_ROOT Directory Tree Credentials}.Credential
      Ensure                    =      [System.String]${DSC_CFG_ROOT Directory Tree}.Ensure
      #PsDscRunAsCredential     =      [PSCredential]${DSC_CFG_ROOT Directory Tree Credentials}.PsDscRunAsCredential
      DependsOn                 =      ${Dependencys Event Log Channel Status}
    }

    ${Dependencys DSC_CFG_ROOT Directory Tree Set}.Add(
      [System.String]"[File]$(${DSC_CFG_ROOT Directory Tree}.Resource_Title)"
    ) | Out-Null
  }
}


<#
  ${Preboots Directory Set on DSC Authoring Station} = $Node.'Preboots Directory Set on DSC Authoring Station'
  if ($null -ne ${Preboots Directory Set on DSC Authoring Station}) {
    ${Dependencys Preboots Directory Set on DSC Authoring Station} = [System.Collections.ArrayList]::New()
    foreach (${Preboots Directory on DSC Authoring Station} in ${Preboots Directory Set on DSC Authoring Station}) {
      File ${Preboots Directory on DSC Authoring Station}.Resource_Title {
        DestinationPath           =      [System.String]${Preboots Directory on DSC Authoring Station}.DestinationPath
        Type                      =      [System.String]${Preboots Directory on DSC Authoring Station}.Type
        Force                     =      [System.Boolean]${Preboots Directory on DSC Authoring Station}.Force
        #Credential               =      [PSCredential]${Preboots Directory on DSC Authoring Station}.Credential
        Ensure                    =      [System.String]${Preboots Directory on DSC Authoring Station}.Ensure
        #PsDscRunAsCredential     =      [PSCredential]${Preboots Directory on DSC Authoring Station}.PsDscRunAsCredential
        DependsOn                 =      ${Dependencys DSC_CFG_ROOT Directory Tree Set}
      }

      ${Dependencys Preboots Directory Set on DSC Authoring Station}.Add(
        [System.String]"[File]$(${Preboots Directory on DSC Authoring Station}.Resource_Title)"
      ) | Out-Null
    }
  }
#>