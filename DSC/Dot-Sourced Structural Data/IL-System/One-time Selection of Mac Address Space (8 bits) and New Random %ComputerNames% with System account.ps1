<# EXPLANATION |
  These are .txt files with values that are generated randomly and only once per deployment of the 
  bare-metal DSC Authoring Station (aka the primordial unclustered Hyper-V Host.)

  Values for a DSC configuration target computer's %ComputerName% are randomly generated and written 
  to a .txt file that is subsequently set to Read-Only. The BaseName of this .txt file follows the 
  pattern of "<Config_Target_Mgmt_Cname> ComputerName". 

  Referencing computers by the CNAME value of their management network IP interface greatly simplifies 
  the process of migrating apps + services to a different system because only the resolved value 
  of a CNAME record needs to change. 

  A MAC Address Space for each physical machine running Windows Server is randomly generated, written 
  to .txt file, and set to Read-Only. A MAC Address Space is generated for each physical machine regard-
  less of whether the computer is also a Hyper-V Host. 

  NOTE: the network adapters connected to a Hyper-V virtual machine all have the same first 24 bits: 
  0000 0000
  0001 0101
  0101 1101
  Hexadecimal representation is 00:15:5d. 
#>

${Static NetIpInt Mgmt Cname Files for Hyper-V Hosts} = $Node.'Static NetIpInt Mgmt Cname Files for Hyper-V Hosts'
if ($null -ne ${Static NetIpInt Mgmt Cname Files for Hyper-V Hosts}) {
  ${Dependencys Static NetIpInt Mgmt Cname Files for Hyper-V Hosts} = [System.Collections.ArrayList]::New()
  ${Dependencys Static MAC Address Space Files} = [System.Collections.ArrayList]::New()

  foreach (${Static NetIpInt Mgmt Cname File for Hyper-V Host} in ${Static NetIpInt Mgmt Cname Files for Hyper-V Hosts}) {
    $IsPresent = Test-Path -Path ${Static NetIpInt Mgmt Cname File for Hyper-V Host}.DestinationPath
    if (-not $IsPresent) {
      File ${Static NetIpInt Mgmt Cname File for Hyper-V Host}.Resource_Title {
        DestinationPath         =    [System.String]${Static NetIpInt Mgmt Cname File for Hyper-V Host}.DestinationPath
        Type                    =    [System.String]${Static NetIpInt Mgmt Cname File for Hyper-V Host}.Type
        Attributes              =    [System.String[]]${Static NetIpInt Mgmt Cname File for Hyper-V Host}.Attributes
        Contents                =    [System.String]$(
          ('WIN-' + ([System.IO.Path]::GetRandomFileName()) -replace '\.','' -join '').ToUpper()
        )
        Force                   =    [System.Boolean]${Static NetIpInt Mgmt Cname File for Hyper-V Host}.Force
        #Credential             =    [PSCredential]${Static NetIpInt Mgmt Cname File for Hyper-V Host}.Credential
        Ensure                  =    [System.String]${Static NetIpInt Mgmt Cname File for Hyper-V Host}.Ensure
        #PsDscRunAsCredential   =    [PSCredential]${Static NetIpInt Mgmt Cname File for Hyper-V Host}.PsDscRunAsCredential
        DependsOn               =    ${Dependencys DSC_CFG_ROOT Directory Tree Set}
      }

      ${Dependencys Static NetIpInt Mgmt Cname Files for Hyper-V Hosts}.Add(
        [System.String]"[File]$(${Static NetIpInt Mgmt Cname File for Hyper-V Host}.Resource_Title)"
      ) | Out-Null
    }

    $IsPresent_mas = Test-Path -Path ${Static NetIpInt Mgmt Cname File for Hyper-V Host}.DestinationPath_mas
    if (-not $IsPresent_mas) {
      $ParentPath_mas = [System.IO.FileInfo]${Static NetIpInt Mgmt Cname File for Hyper-V Host}.DestinationPath_mas `
      | Select-Object -ExpandProperty 'DirectoryName'
      
      File ${Static NetIpInt Mgmt Cname File for Hyper-V Host}.Resource_Title_mas {
        DestinationPath         =    [System.String]${Static NetIpInt Mgmt Cname File for Hyper-V Host}.DestinationPath_mas
        Type                    =    [System.String]${Static NetIpInt Mgmt Cname File for Hyper-V Host}.Type_mas
        Attributes              =    [System.String[]]${Static NetIpInt Mgmt Cname File for Hyper-V Host}.Attributes_mas
        Contents                =    [System.String]$(
          $AreAllUnique = $false
          #$files = Get-ChildItem -Path $ParentPath_mas -Filter "*MAC Address Space.txt" -ErrorAction 'SilentlyContinue'
          $files = Get-ChildItem -Path $ParentPath_mas -Filter "*.txt" -ErrorAction 'SilentlyContinue'
          if ($null -ne $files) { # Scriptblock executes if $ParentPath_mas has >0 MAC Address Space txt files |
            ${MAC Address Bits 25-32 in Base2 Set} = $files | ForEach-Object -Process {
              Get-Content -Path $_.FullName
            }
            do {
              ${Random MAC Address Bits 25-32 in Base2} = (
                1..8 | ForEach-Object -Process {
                  [System.String](Get-Random -Maximum 2)
                }
              ) -join ''
              if (${MAC Address Bits 25-32 in Base2 Set} -notcontains ${Random MAC Address Bits 25-32 in Base2}) {
                $AreAllUnique = $true
              }
            } 
            until ($AreAllUnique)
            ${Random MAC Address Bits 25-32 in Base2}
          } 
          else { # Scriptblock executes if $ParentPath_mas has 0 MAC Address Space txt files |

            #       XX:XX:XX:XX:XX:XX
            #       Byte1:Byte2:Byte3:Byte4:Byte5:Byte6
            #       0000 0000 x 00    # Bits  1 -  8
            #       0001 0101 x 15    # Bits  9 - 16
            #       0101 1101 x 5d    # Bits 17 - 24
            #       0000 0000 x       # Bits 25 - 32
            #       0000 0000 x       # Bits 33 - 40
            #       0000 0000 x       # Bits 41 - 48

            ${Random MAC Address Bits 25-32 in Base2} = (
              1..8 | ForEach-Object -Process {
                [System.String](Get-Random -Maximum 2)
              }
            ) -join ''
            ${Random MAC Address Bits 25-32 in Base10} = [System.Convert]::ToInt32(${Random MAC Address Bits 25-32 in Base2},2)
            ${Random MAC Address Bits 25-32 in Base16} = '{0,0:x4}' -f ${Random MAC Address Bits 25-32 in Base10}
            ${Random MAC Address Bits 25-32 in Base2}
          }
        )
        Force                     =    [System.Boolean]${Static NetIpInt Mgmt Cname File for Hyper-V Host}.Force_mas
        #Credential               =    [PSCredential]${Static NetIpInt Mgmt Cname File for Hyper-V Host}.Credential_mas
        Ensure                    =    [System.String]${Static NetIpInt Mgmt Cname File for Hyper-V Host}.Ensure_mas
        #PsDscRunAsCredential     =    [PSCredential]${Static NetIpInt Mgmt Cname File for Hyper-V Host}.PsDscRunAsCredential_mas
        DependsOn                 =    ${Dependencys Event Log Channel Status}
      }

      ${Dependencys Static MAC Address Space Files}.Add(
        [System.String]"[File]$(${Static NetIpInt Mgmt Cname File for Hyper-V Host}.Resource_Title_mas)"
      ) | Out-Null
    }
  }
}

<# EXPLANATION |
  Values for a Hyper-V VM's %ComputerName% are randomly generated and written to .txt file, which is set Read-Only.
  Greatly simplifies the process of migrating apps + services to a different system because only the resolved value 
  of a CNAME record needs to change.
#>

${Static NetIpInt Mgmt Cname Files for Hyper-V VMs} = $Node.'Static NetIpInt Mgmt Cname Files for Hyper-V VMs'
if ($null -ne ${Static NetIpInt Mgmt Cname Files for Hyper-V VMs}) {
  ${Dependencys Static NetIpInt Mgmt Cname Files for Hyper-V VMs} = [System.Collections.ArrayList]::New()
  foreach (${Static NetIpInt Mgmt Cname File for Hyper-V VM} in ${Static NetIpInt Mgmt Cname Files for Hyper-V VMs}) {
    # New values of %ComputerName% for VMs. Randomly generated once per bare-metal deployment of the DSC Authoring Station. 
    $IsPresent = Test-Path -Path ${Static NetIpInt Mgmt Cname File for Hyper-V VM}.DestinationPath
    if (-not $IsPresent) {
      File ${Static NetIpInt Mgmt Cname File for Hyper-V VM}.Resource_Title {
        DestinationPath         =    [System.String]${Static NetIpInt Mgmt Cname File for Hyper-V VM}.DestinationPath
        Type                    =    [System.String]${Static NetIpInt Mgmt Cname File for Hyper-V VM}.Type
        Attributes              =    [System.String[]]${Static NetIpInt Mgmt Cname File for Hyper-V VM}.Attributes
        Contents                =    [System.String]$(
          ('WIN-' + ([System.IO.Path]::GetRandomFileName()) -replace '\.','' -join '').ToUpper()
        )
        Force                   =    [System.Boolean]${Static NetIpInt Mgmt Cname File for Hyper-V VM}.Force
        #Credential             =    [PSCredential]${Static NetIpInt Mgmt Cname File for Hyper-V VM}.Credential
        Ensure                  =    [System.String]${Static NetIpInt Mgmt Cname File for Hyper-V VM}.Ensure
        #PsDscRunAsCredential   =    [PSCredential]${Static NetIpInt Mgmt Cname File for Hyper-V VM}.PsDscRunAsCredential
        DependsOn               =    ${Dependencys Event Log Channel Status}
      }

      ${Dependencys Static NetIpInt Mgmt Cname Files for Hyper-V VMs}.Add(
        [System.String]"[File]$(${Static NetIpInt Mgmt Cname File for Hyper-V VM}.Resource_Title)"
      ) | Out-Null
    }
  }
}

${Infrastructure Version File} = $Node.'Infrastructure Version File'
if ($null -ne ${Infrastructure Version File}) {
  $IsPresent = Test-Path -Path ${Infrastructure Version File}.DestinationPath
  if (-not $IsPresent) {
    File ${Infrastructure Version File}.Resource_Title {
      DestinationPath         =    [System.String]${Infrastructure Version File}.DestinationPath
      Type                    =    [System.String]${Infrastructure Version File}.Type
      Attributes              =    [System.String[]]${Infrastructure Version File}.Attributes        
      Contents                =    [System.String]$(
        Call-DateVar
      )
      Force                   =    [System.Boolean]${Infrastructure Version File}.Force
      #Credential             =    [PSCredential]${Infrastructure Version File}.Credential
      Ensure                  =    [System.String]${Infrastructure Version File}.Ensure
      #PsDscRunAsCredential   =    [PSCredential]${Infrastructure Version File}.PsDscRunAsCredential
      DependsOn               =    ${Dependencys Event Log Channel Status}
    }

    ${Dependency Infrastructure Version File} = [System.String[]]@(
      "[File]$(${Infrastructure Version File}.Resource_Title)"
    )
  }
}
