${Outline Random Exclusion-Inclusion Address Spaces} = $Node.'Outline Random Exclusion-Inclusion Address Spaces'
if ($null -ne ${Outline Random Exclusion-Inclusion Address Spaces}) {
  ${Dependencys Outline Random Exclusion-Inclusion Address Spaces} = [System.Collections.ArrayList]::New()

  foreach (${Outline Random Exclusion-Inclusion Address Space} in ${Outline Random Exclusion-Inclusion Address Spaces}) {
    DhcpExclusionInclusionOutline ${Outline Random Exclusion-Inclusion Address Space}.Resource_Title {
      FilePath                   =      [System.String]${Outline Random Exclusion-Inclusion Address Space}.FilePath
      Ensure                     =      [System.String]${Outline Random Exclusion-Inclusion Address Space}.Ensure
      #PsDscRunAsCredential      =      [PSCredential]${Outline Random Exclusion-Inclusion Address Space}.PsDscRunAsCredential
      DependsOn                  =      ${Dependencys Event Log Channel Status}
    }

    ${Dependencys Outline Random Exclusion-Inclusion Address Spaces}.Add(
      [System.String]"[DhcpExclusionInclusionOutline]$(${Outline Random Exclusion-Inclusion Address Space}.Resource_Title)"
    ) | Out-Null
  }
}

${All Defined VLAN Titles} = $Node.'All Defined VLAN Titles'

${Is the task of defining all Exclusion-Inclusion Outlines not yet complete?} = $false
foreach (${Defined VLAN Title} in ${All Defined VLAN Titles}) {
  $VlanFilePath = "$Statics\MaxIP\VLANs\${Defined VLAN Title}.txt"
  $IsVlanFilePresent = Test-Path -Path $VlanFilePath
  if ($IsVlanFilePresent) {
    ${Defined VLAN ID-Binary} = Get-Content -Path $VlanFilePath
  } else {
    ${Is the task of defining all Exclusion-Inclusion Outlines not yet complete?} = $true
    break
  }
  ${Defined VLAN ID-Base10} = [System.Convert]::ToInt32(${Defined VLAN ID-Binary},2)
  ${Defined VLAN ID-Base10 Padded} = ${Defined VLAN ID-Base10}.ToString('0000')
  
  $IsExcIncOutlineForVlanDefined = Test-Path -Path "$Statics\MaxIP\IPv4\${Defined VLAN Title} ${Defined VLAN ID-Base10 Padded}\ExcIncOutline.clixml"
  if (-not $IsExcIncOutlineForVlanDefined) {
    ${Is the task of defining all Exclusion-Inclusion Outlines not yet complete?} = $true
    break
  }
}

if (-not ${Is the task of defining all Exclusion-Inclusion Outlines not yet complete?}) {
  ${Define Exclusion Address Spaces} = $Node.'Define Exclusion Address Spaces'
  if ($null -ne ${Define Exclusion Address Spaces}) {
    ${Dependencys Define Exclusion Address Spaces} = [System.Collections.ArrayList]::New()

    foreach (${Define Exclusion Address Space} in ${Define Exclusion Address Spaces}) {
      DhcpExclusionSpace ${Define Exclusion Address Space}.Resource_Title {
        OutputPath                =      [System.String]${Define Exclusion Address Space}.OutputPath
        InputPath                 =      [System.String]${Define Exclusion Address Space}.InputPath
        VLAN_ID_Binary            =      [System.String]${Define Exclusion Address Space}.VLAN_ID_Binary
        Ensure                    =      [System.String]${Define Exclusion Address Space}.Ensure
        #PsDscRunAsCredential     =      [PSCredential]${Define Exclusion Address Space}.PsDscRunAsCredential
        #DependsOn                =      ${Dependencys Event Log Channel Status}
        DependsOn                 =      ${Dependencys Outline Random Exclusion-Inclusion Address Spaces}
      }
    }
  }

  ${Define Inclusion Address Spaces} = $Node.'Define Inclusion Address Spaces'
  if ($null -ne ${Define Inclusion Address Spaces}) {
    ${Dependencys Define Inclusion Address Spaces} = [System.Collections.ArrayList]::New()

    foreach (${Define Inclusion Address Space} in ${Define Inclusion Address Spaces}) {
      DhcpInclusionSpace ${Define Inclusion Address Space}.Resource_Title {
        OutputPath                =      [System.String]${Define Inclusion Address Space}.OutputPath
        InputPath                 =      [System.String]${Define Inclusion Address Space}.InputPath
        VLAN_ID_Binary            =      [System.String]${Define Inclusion Address Space}.VLAN_ID_Binary
        Ensure                    =      [System.String]${Define Inclusion Address Space}.Ensure
        #PsDscRunAsCredential     =      [PSCredential]${Define Inclusion Address Space}.PsDscRunAsCredential
        #DependsOn                =      ${Dependencys Event Log Channel Status}
        DependsOn                 =      ${Dependencys Outline Random Exclusion-Inclusion Address Spaces}
      }
    }
  }

  ${Define Exclusion Ranges Collection} = $Node.'Define Exclusion Ranges Collection'
  if ($null -ne ${Define Exclusion Ranges Collection}) {
    ${Dependencys Define Exclusion Ranges Collection} = [System.Collections.ArrayList]::New()

    foreach (${Define Exclusion Ranges} in ${Define Exclusion Ranges Collection}) {
      DhcpExclusionRangesDDN ${Define Exclusion Ranges}.Resource_Title {
        OutputPath                =      [System.String]${Define Exclusion Ranges}.OutputPath
        InputPath                 =      [System.String]${Define Exclusion Ranges}.InputPath
        VLAN_ID_Binary            =      [System.String]${Define Exclusion Ranges}.VLAN_ID_Binary
        Ensure                    =      [System.String]${Define Exclusion Ranges}.Ensure
        #PsDscRunAsCredential     =      [PSCredential]${Define Exclusion Ranges}.PsDscRunAsCredential
        DependsOn                 =      ${Dependencys Event Log Channel Status}
      }
    }
  }
}