${VLAN .txt Files} = $Node.'VLAN .txt Files'
if ($null -ne ${VLAN .txt Files}) {
  foreach (${VLAN .txt File} in ${VLAN .txt Files}) {
    $IsPresent = Test-Path -Path ${VLAN .txt File}.DestinationPath
    if (-not $IsPresent) {
      File ${VLAN .txt File}.Resource_Title {
        DestinationPath             =         [System.String]${VLAN .txt File}.DestinationPath
        Type                        =         [System.String]${VLAN .txt File}.Type
        Attributes                  =         [System.String[]]${VLAN .txt File}.Attributes
        Contents                    =         [System.String]$(
          ${All VLAN IDs Confirmed Unique} = $false
          $files = Get-ChildItem -Path "$Statics\MaxIP\VLANs" -Filter "*.txt" -File
          if ($null -ne $files) { # Scriptblock bound to 'if' keyword executes if "$Statics\MaxIP\VLANs" has >0 VLAN Title txt files |
            ${VLAN ID Bits in Base2 Set} = $files | ForEach-Object -Process {
              Get-Content -Path $_.FullName
            }
            do {
              ${Random VLAN ID Bits in Base2} = (
                1..12 | ForEach-Object -Process {
                  [System.String](Get-Random -Maximum 2)
                }
              ) -join ''
              if (${VLAN ID Bits in Base2 Set} -notcontains ${Random VLAN ID Bits in Base2}) {
                ${All VLAN IDs Confirmed Unique} = $true
              }
            } 
            until (${All VLAN IDs Confirmed Unique})
            ${Random VLAN ID Bits in Base2}
          } 
          else { # Scriptblock bound to 'else' keyword executes if "$Statics\MaxIP\VLANs" has no VLAN Title txt files |
            ${Random VLAN ID Bits in Base2} = (
              1..12 | ForEach-Object -Process {
                [System.String](Get-Random -Maximum 2)
              }
            ) -join ''

            ${Random VLAN ID Bits in Base10} = [System.Convert]::ToInt32(${Random VLAN ID Bits in Base2},2)
            ${Random VLAN ID Bits in Base16} = '{0,0:x4}' -f ${Random VLAN ID Bits in Base10}
            ${Random VLAN ID Bits in Base2}
          }
        )
        Force                       =         [System.Boolean]${VLAN .txt File}.Force
        #Credential                 =         [PSCredential]${VLAN .txt File}.Credential
        Ensure                      =         [System.String]${VLAN .txt File}.Ensure
        #PsDscRunAsCredential       =         [PSCredential]${VLAN .txt File}.PsDscRunAsCredential
        DependsOn                   =         ${Dependencys Event Log Channel Status}
      }
    }
  }
}