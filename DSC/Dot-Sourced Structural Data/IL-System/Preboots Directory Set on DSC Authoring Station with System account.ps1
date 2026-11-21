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