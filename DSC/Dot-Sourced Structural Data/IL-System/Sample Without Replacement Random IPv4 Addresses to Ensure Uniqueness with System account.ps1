${Regex Pattern for IP Address File BaseName} = '^[a-z0-9-]+ [0-9a-z]$'
${All Defined VLAN Titles} = $Node.'All Defined VLAN Titles'
foreach (${Defined VLAN Title} in ${All Defined VLAN Titles}) {
  $IsIncomplete = $false
  $VlanFilePath = "$Statics\MaxIP\VLANs\${Defined VLAN Title}.txt"
  $IsVlanFilePresent = Test-Path -Path $VlanFilePath
  if ($IsVlanFilePresent) {
    ${Defined VLAN ID-Binary} = Get-Content -Path $VlanFilePath
  } else {
    continue
  }

  ${Defined VLAN ID-Base10} = [System.Convert]::ToInt32(${Defined VLAN ID-Binary},2)
  ${Defined VLAN ID-Base10 Padded} = ${Defined VLAN ID-Base10}.ToString('0000')

  $IsExclusionSpaceDefined = Test-Path -Path "$Statics\MaxIP\IPv4\${Defined VLAN Title} ${Defined VLAN ID-Base10 Padded}\ExclusionSpace.clixml"
  if (-not $IsExclusionSpaceDefined) {
    $IsIncomplete = $true
    continue
  }

  $IsInclusionSpaceDefined = Test-Path -Path "$Statics\MaxIP\IPv4\${Defined VLAN Title} ${Defined VLAN ID-Base10 Padded}\InclusionSpace.clixml"
  if (-not $IsInclusionSpaceDefined) {
    $IsIncomplete = $true
    continue
  }

  $IsExclusionRangesDDNDefined = Test-Path -Path "$Statics\MaxIP\IPv4\${Defined VLAN Title} ${Defined VLAN ID-Base10 Padded}\ExclusionRangesDDN.clixml"
  if (-not $IsExclusionRangesDDNDefined) {
    $IsIncomplete = $true
    continue
  }

  if (-not $IsIncomplete) {
    # IPv4 Addresses for either static IP config or written into DHCP Reservations. 
    # Randomly generated and saved in a Read-Only text file. 
    $Node.'Randomly Assign Unique IPv4 Addresses to Net IP Interfaces' `
    | Where-Object -PipelineVariable 'File of Random IPv4 Address in this VLAN' -FilterScript {
      $pattern = '^' + ${Defined VLAN Title} + ' ' + ${Defined VLAN ID-Base10 Padded} + '$'
      ([System.IO.FileInfo]$_.DestinationPath).Directory.Name -match $pattern
    } | ForEach-Object -Process {
      $IsPresent = Test-Path -Path ${File of Random IPv4 Address in this VLAN}.DestinationPath

      if (-not $IsPresent) {
        $file = [System.IO.FileInfo]${File of Random IPv4 Address in this VLAN}.DestinationPath

        $file.Directory.Name -match '^(?<VLAN_Title>.+) (?<VLAN_ID_Base10_Padded>\d{4})$' | Out-Null
        $VLAN_Title = [System.String]$Matches['VLAN_Title']
        $VLAN_ID_Base10_Padded = [System.String]$Matches['VLAN_ID_Base10_Padded']

        $file.BaseName -match '^(?<Config_Target_Mgmt_Cname>[a-z0-9-]+) (?<Network_Adapter_Index>[0-9a-z])$' | Out-Null
        $Config_Target_Mgmt_Cname = [System.String]$Matches['Config_Target_Mgmt_Cname']
        $Network_Adapter_Index = [System.String]$Matches['Network_Adapter_Index']

        $Dhcp = [System.String]${File of Random IPv4 Address in this VLAN}.Dhcp
        switch ($Dhcp) {
          'Enabled'  {
            ${IPv4 Address Sample Set} = Import-CliXml -Path "$Statics\MaxIP\IPv4\$VLAN_Title $VLAN_ID_Base10_Padded\InclusionSpace.clixml"
            $SampleSize = ${IPv4 Address Sample Set}.Count
          }
          'Disabled' {
            ${IPv4 Address Sample Set} = Import-CliXml -Path "$Statics\MaxIP\IPv4\$VLAN_Title $VLAN_ID_Base10_Padded\ExclusionSpace.clixml"
            $SampleSize = ${IPv4 Address Sample Set}.Count
          }
        }

        File ${File of Random IPv4 Address in this VLAN}.Resource_Title {
          DestinationPath           =     [System.String]${File of Random IPv4 Address in this VLAN}.DestinationPath
          Type                      =     [System.String]${File of Random IPv4 Address in this VLAN}.Type
          Attributes                =     [System.String[]]${File of Random IPv4 Address in this VLAN}.Attributes
          Contents                  =     [System.String]$(
            ${All IPv4 Addresses Confirmed Unique} = $false

            $files = Get-ChildItem -Path "$Statics\MaxIP\IPv4\$VLAN_Title $VLAN_ID_Base10_Padded" -Recurse -File -PipelineVariable 'IPAddressFile' | Where-Object -FilterScript {
              $IPAddressFile.BaseName -match ${Regex Pattern for IP Address File BaseName}
            }

            if ($null -ne $files) {
              ${Already-Assigned IPv4 Addresses} = $files | ForEach-Object -PipelineVariable 'IPAddressFile' -Process {
                Get-Content -Path $IPAddressFile.FullName
              }

              do 
              {
                ${IPv4 Address Candidate} = ${IPv4 Address Sample Set}[$(Get-Random -Minimum 0 -Maximum $SampleSize)]

                if (${Already-Assigned IPv4 Addresses} -notcontains ${IPv4 Address Candidate}) {
                  ${All IPv4 Addresses Confirmed Unique} = $true
                }
              } 
              until 
              (
                ${All IPv4 Addresses Confirmed Unique}
              )

              ${IPv4 Address Candidate}            
            } 
            else {
              ${IPv4 Address Candidate} = ${IPv4 Address Sample Set}[$(Get-Random -Minimum 0 -Maximum $SampleSize)]

              ${IPv4 Address Candidate}
            }
          )
          Force                     =     [System.Boolean]${File of Random IPv4 Address in this VLAN}.Force
          #Credential               =     [PSCredential]${File of Random IPv4 Address in this VLAN}.Credential
          Ensure                    =     [System.String]${File of Random IPv4 Address in this VLAN}.Ensure
          #PsDscRunAsCredential     =     [PSCredential]${File of Random IPv4 Address in this VLAN}.PsDscRunAsCredential
          DependsOn                 =     ${Dependencys Event Log Channel Status}
        }
      }
    }

    # Pick from Inclusion Space if the IP address on the Net IP Interface that serves as the default gateway is to be assigned via DHCP
    ${IPv4 Address Selection Space} = Import-CliXml -Path "$Statics\MaxIP\IPv4\${Defined VLAN Title} ${Defined VLAN ID-Base10 Padded}\InclusionSpace.clixml"
    # Pick from Exclusion Space if IP address on the Net IP Interface that serves as the default gateway is to be statically configured
    $Size_Of_Sample = ${IPv4 Address Selection Space}.Count

    (0..4) | Select-Object -PipelineVariable 'Index of Default Gateway in this VLAN' | ForEach-Object -Process {
      # Allow 'default-gateway 0' to stand as a virtual IP for hot-standby router protocol, when the time arrives. 
      $DestinationPath = "$Statics\MaxIP\IPv4\${Defined VLAN Title} ${Defined VLAN ID-Base10 Padded}\default-gateway ${Index of Default Gateway in this VLAN}.txt"
      ${Is IPv4 of this Default Gateway for this VLAN defined} = Test-Path -Path $DestinationPath
      if (-not ${Is IPv4 of this Default Gateway for this VLAN defined}) {
        File "Default Gateway ${Index of Default Gateway in this VLAN} for VLAN titled \${Defined VLAN Title}\" {
          DestinationPath = [System.String]$DestinationPath
          Type            = [System.String]'File'
          Attributes      = [System.String[]]@('ReadOnly')
          Contents        = [System.String]$(
            ${All IPv4 Addresses Confirmed Unique} = $false

            $InputHT = @{
              Path             = "$Statics\MaxIP\IPv4\${Defined VLAN Title} ${Defined VLAN ID-Base10 Padded}"
              Recurse          = $true
              File             = $true
              PipelineVariable = 'IPv4_Addr_File'
              Filter           = '*.txt'
            }
            $txtFiles = Get-ChildItem @InputHT | Where-Object -FilterScript {
              $IPv4_Addr_File.BaseName -match ${Regex Pattern for IP Address File BaseName}
            }

            if ($null -ne $txtFiles) {
              ${Already-Assigned IPv4 Addresses} = $txtFiles | Select-Object -PipelineVariable 'IPv4_Addr_File' | ForEach-Object -Process {
                Get-Content -Path $IPv4_Addr_File.FullName
              }
              do {
                ${IPv4 Address Candidate} = ${IPv4 Address Selection Space}[$(Get-Random -Minimum 0 -Maximum $Size_Of_Sample)]
                if (${Already-Assigned IPv4 Addresses} -notcontains ${IPv4 Address Candidate}) {
                  ${All IPv4 Addresses Confirmed Unique} = $true
                }
              } until (${All IPv4 Addresses Confirmed Unique})
              ${IPv4 Address Candidate}            
            } 
            else {
              ${IPv4 Address Candidate} = ${IPv4 Address Selection Space}[$(Get-Random -Minimum 0 -Maximum $Size_Of_Sample)]
              ${IPv4 Address Candidate}
            }
          )
          Force           = [System.Boolean]$false
          Ensure          = [System.String]'Present'
        }
      }
    }
  }
}