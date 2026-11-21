<# Notes |
  MAC addresses of virtual network adapters on Hyper-V VMs and the Hyper-V Hosts of those VMs. 
  Randomly generated and saved in a Read-Only text file. 
#>
<# Reference | Padding | -f | [System.String]::Format()
  ${Mof Wave Dir Names} = [System.String[]]@(0..4 | % {"Wave__$(($_).ToString('00'))"})
  '|{0,10}| 0x{1:x}|{2,-10}|{3}|' -f 10,20,30,40
  [System.String]::Format('|{0,10}| 0x{1:x}|{2,-10}|{3}|',(10,255,20,'Forty'))

  # Page 165 of PowerShell Cookbook, 4th Edition: 
  ${Random Bits 25-39 in Base2} = (1..15 | ForEach-Object -Process {[System.String](Get-Random -Maximum 2)}) -join ''
  ${Random Bits 25-39 in Base10} = [System.Convert]::ToInt32(${Random Bits 25-39 in Base2},2)
  ${Random Bits 25-39 in Base16} = '{0,0:x4}' -f ${Random Bits 25-39 in Base10}
  ${Random Bits 25-39 in Base16}

  '92454.jpg' | % PadLeft 12 '0'
  '92454.jpg'.PadLeft(12,'0')
#>

${MAC Address Space File} = [System.IO.FileInfo]"$Statics\MAC Address Space\$($Node.NodeMgmtCname).txt"
${MAC Address Space File Path} = ${MAC Address Space File}.FullName
${Is MAC Address Space Defined} = Test-Path -Path ${MAC Address Space File Path}

if (${Is MAC Address Space Defined}) {
  ${MAC Address Space} = Get-Content -Path ${MAC Address Space File}.FullName
  ${MAC Address Space bit length} = ${MAC Address Space}.Length
  ${Qty of MAC Address Bits for Adapter} = 24 - ${MAC Address Space bit length}

  ${MAC Address Set v3} = $Node.'MAC Address Set v3 on Unclustered Hyper-V Host'
  if ($null -ne ${MAC Address Set v3}) {
    ${MAC Address Bits on Adapter-Max} = (1..${Qty of MAC Address Bits for Adapter} | ForEach-Object -Process {'1'}) -join ''
    ${MAC Address Bits 25-48 in Base2-Upper Bound} = ${MAC Address Space} + ${MAC Address Bits on Adapter-Max}
    ${MAC Address Bits 25-48 in Base10-Upper Bound} = [System.Convert]::ToInt32(${MAC Address Bits 25-48 in Base2-Upper Bound},2)
    ${MAC Address Bits 25-48 in Base16-Upper Bound} = '{0,0:x4}' -f ${MAC Address Bits 25-48 in Base10-Upper Bound}
    ${MAC Address Maximum in Base16} = '00155d' + ${MAC Address Bits 25-48 in Base16-Upper Bound}

    ${MAC Address Bits on Adapter-Min} = (1..${Qty of MAC Address Bits for Adapter} | ForEach-Object -Process {'0'}) -join ''
    ${MAC Address Bits 25-48 in Base2-Lower Bound} = ${MAC Address Space} + ${MAC Address Bits on Adapter-Min}
    ${MAC Address Bits 25-48 in Base10-Lower Bound} = [System.Convert]::ToInt32(${MAC Address Bits 25-48 in Base2-Lower Bound},2)
    ${MAC Address Bits 25-48 in Base16-Lower Bound} = '{0,0:x4}' -f ${MAC Address Bits 25-48 in Base10-Lower Bound}
    ${MAC Address Minimum in Base16} = '00155d' + ${MAC Address Bits 25-48 in Base16-Lower Bound}

    foreach (${MAC Address v3} in ${MAC Address Set v3}) {
      $IsPresent = Test-Path -Path ${MAC Address v3}.DestinationPath
      if (-not $IsPresent) {
        File ${MAC Address v3}.Resource_Title {
          DestinationPath             =         [System.String]${MAC Address v3}.DestinationPath
          Type                        =         [System.String]${MAC Address v3}.Type
          Attributes                  =         [System.String[]]${MAC Address v3}.Attributes
          Contents                    =         [System.String]$(
            ${All MAC Addresses Confirmed Unique} = $false
            $files = Get-ChildItem -Path "$Statics\MAC Address Space" -Filter "*MAC Address.txt" -File
            if ($null -ne $files) {
              ${MAC Address Set} = $files | ForEach-Object -Process {
                Get-Content -Path $_.FullName
              }
              do {
                ${Random MAC Address in Base16-Bits 25-48} = '{0:x6}' -f (Get-Random -Maximum ${MAC Address Bits 25-48 in Base10-Upper Bound} -Minimum ${MAC Address Bits 25-48 in Base10-Lower Bound})
                
                if (${MAC Address Set} -notcontains ${Random MAC Address in Base16-Bits 25-48}) {
                  ${All MAC Addresses Confirmed Unique} = $true
                }
              } 
              until (${All MAC Addresses Confirmed Unique})
              '00155d' + ${Random MAC Address in Base16-Bits 25-48}
            } 
            else {
              ${Random MAC Address in Base16-Bits 25-48} = '{0:x6}' -f (Get-Random -Maximum ${MAC Address Bits 25-48 in Base10-Upper Bound} -Minimum ${MAC Address Bits 25-48 in Base10-Lower Bound})
              '00155d' + ${Random MAC Address in Base16-Bits 25-48}
            }
          )
          Force                       =         [System.Boolean]${MAC Address v3}.Force
          #Credential                 =         [PSCredential]${MAC Address v3}.Credential
          Ensure                      =         [System.String]${MAC Address v3}.Ensure
          #PsDscRunAsCredential       =         [PSCredential]${MAC Address v3}.PsDscRunAsCredential
          DependsOn                   =         ${Dependencys Event Log Channel Status}
        }
      }
    }
  }
}