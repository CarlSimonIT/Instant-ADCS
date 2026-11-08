[DscResource()]
class DhcpExclusionSpace {
  [DscProperty(Key)]
  [ValidatePattern('\.clixml$')]
  [System.String]
  $OutputPath

  [DscProperty(Mandatory)]
  [ValidatePattern('\.clixml$')]
  [System.String]
  $InputPath

  [DscProperty(Mandatory)]
  [System.String]
  $VLAN_ID_Binary

  [DscProperty()]
  [System.UInt32]
  $CIDR = 22

  [DscProperty(NotConfigurable)]
  [System.Boolean]
  $Assessment

  [DscProperty(Mandatory)]
  [Ensure]
  $Ensure

  #%_Test Explained Here-String_%
  [System.Boolean] Test () {
    #region | Test() Subphase A | Uncover the reality |
    Write-Verbose -Message "Test() Subphase A"
    ${OBSERVED real-world state of the object which corresponds to this exact specific DSC Resource instance} = Get-Item -Path ($this.OutputPath) -ErrorAction 'SilentlyContinue'

    if ($null -ne ${OBSERVED real-world state of the object which corresponds to this exact specific DSC Resource instance}) {
      ${Does there exist on this computer a real-world object whose properties perfectly match the exact specific DSC Resource instance?} = 'Yup'
    } else {
      ${Does there exist on this computer a real-world object whose properties perfectly match the exact specific DSC Resource instance?} = 'Nope'
    }
    #endregion

    #region | Test() Subphase B | Consider whether this reality is desired |
    Write-Verbose -Message "Test() Subphase B"
    if (
      'Yup' -eq ${Does there exist on this computer a real-world object whose properties perfectly match the exact specific DSC Resource instance?} `
      -and `
      $this.Ensure -eq [Ensure]::Present
    ) {
      $this.Assessment = $true
    }

    if (
      'Nope' -eq ${Does there exist on this computer a real-world object whose properties perfectly match the exact specific DSC Resource instance?} `
      -and `
      $this.Ensure -eq [Ensure]::Present
    ) {
      $this.Assessment = $false
    }

    if (
      'Yup' -eq ${Does there exist on this computer a real-world object whose properties perfectly match the exact specific DSC Resource instance?} `
      -and `
      $this.Ensure -eq [Ensure]::Absent
    ) {
      $this.Assessment = $false
    }

    if (
      'Nope' -eq ${Does there exist on this computer a real-world object whose properties perfectly match the exact specific DSC Resource instance?} `
      -and `
      $this.Ensure -eq [Ensure]::Absent
    ) {
      $this.Assessment = $true
    }
    #endregion

    #region | Test() Subphase C | Return to Set() the $Assessment. If this reality is NOT desired, Set() will handle the details |
    Write-Verbose -Message "Test() Subphase C: `$Assessment = $($this.Assessment)"
    return $this.Assessment
    #endregion
  }

  #%_Set Explained Here-String_%
  [System.Void] Set () {
    Write-Verbose -Message "Call to Set()"
    if ($this.Ensure -eq [Ensure]::Present) 
    {
      $Octet1Binary = '0000' + [System.Convert]::ToString(10,2)
      $NetworkNumberBinary = $Octet1Binary + '00' + $this.VLAN_ID_Binary + '0000000000'

      $ExcIncOutline = Import-CliXml -Path $this.InputPath
      $ExcIncOutline[0] = $ExcIncOutline[0] + 1
      $ExclusionSubSpace = [System.Collections.ArrayList]::New()
      $ExclusionSpace = [System.Collections.ArrayList]::New()
      $InclusionSubSpace = [System.Collections.ArrayList]::New()
      $InclusionSpace = [System.Collections.ArrayList]::New()
      ${Cumulative Sum of ArrayList Elements} = 0
      $TargetSubSpaceBinaryStringLength = 32 - $this.CIDR

      for ($ArrayPosition = 0; $ArrayPosition -lt $ExcIncOutline.Count; $ArrayPosition++) {
        if (-not ($ArrayPosition % 2)) { # Position index in $ExcIncOutline array is Even, meaning an exclusion subspace is being defined |
          #region | Generate Exclusion Subspace |
          ${Local IP Address Set in Decimal Non-Cumulative} = 1..$ExcIncOutline[$ArrayPosition]

          ${Local IP Address Set in Decimal Cumulative} = foreach (${Local IP Address in Decimal Non-Cumulative} in ${Local IP Address Set in Decimal Non-Cumulative}) {
            ${Local IP Address in Decimal Non-Cumulative} + ${Cumulative Sum of ArrayList Elements}
          }

          ${Local IP Address Set in Binary Cumulative} = ${Local IP Address Set in Decimal Cumulative}.ForEach({
            [System.Convert]::ToString($_,2)
          })

          ${Padded Local IP Address Set in Binary Cumulative} = ${Local IP Address Set in Binary Cumulative}.PadLeft($TargetSubSpaceBinaryStringLength,'0')

          foreach (${Padded Local IP Address in Binary Cumulative} in ${Padded Local IP Address Set in Binary Cumulative}) {
            [System.Void]$ExclusionSubSpace.Add(${Padded Local IP Address in Binary Cumulative})
            [System.Void]$ExclusionSpace.Add($NetworkNumberBinary.Substring(0,$this.CIDR) + ${Padded Local IP Address in Binary Cumulative})
          }
          #endregion
          
          ${Cumulative Sum of ArrayList Elements} += $ExcIncOutline[$ArrayPosition]
        } 
        else { # Position index in $ExcIncOutline array is Odd, meaning an inclusion subspace is being defined |
          #region | Generate Inclusion Subspace |
          ${Local IP Address Set in Decimal Non-Cumulative} = 1..$ExcIncOutline[$ArrayPosition]

          ${Local IP Address Set in Decimal Cumulative} = foreach (${Local IP Address in Decimal Non-Cumulative} in ${Local IP Address Set in Decimal Non-Cumulative}) {
            ${Local IP Address in Decimal Non-Cumulative} + ${Cumulative Sum of ArrayList Elements}
          }

          ${Local IP Address Set in Binary Cumulative} = ${Local IP Address Set in Decimal Cumulative}.ForEach({
            [System.Convert]::ToString($_,2)
          })

          ${Padded Local IP Address Set in Binary Cumulative} = ${Local IP Address Set in Binary Cumulative}.PadLeft($TargetSubSpaceBinaryStringLength,'0')

          foreach (${Padded Local IP Address in Binary Cumulative} in ${Padded Local IP Address Set in Binary Cumulative}) {
            [System.Void]$InclusionSubSpace.Add(${Padded Local IP Address in Binary Cumulative})
            [System.Void]$InclusionSpace.Add($NetworkNumberBinary.Substring(0,$this.CIDR) + ${Padded Local IP Address in Binary Cumulative})
          }
          #endregion
          
          ${Cumulative Sum of ArrayList Elements} += $ExcIncOutline[$ArrayPosition]
        }
      }

      $path = ([System.IO.FileInfo]$this.OutputPath).DirectoryName
      $folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}

      Export-CliXml -Path $this.OutputPath -InputObject ($ExclusionSpace)
      Set-ItemProperty -Path $this.OutputPath -Name 'IsReadOnly' -Value $true
    }
    elseif ($this.Ensure -eq [Ensure]::Absent) 
    {
      Write-Verbose -Message "Delete .clixml file"
      Set-ItemProperty -Path $this.OutputPath -Name 'IsReadOnly' -Value $false
      Remove-Item -Path ($this.OutputPath) -Force
    }
  }

  #%_Get Explained Here-String_%
  [DhcpExclusionSpace] Get () {
    Write-Verbose -Message "Get () real-world state of DhcpExclusionSpace resource instance"

    $CurrentState = [System.Collections.Hashtable]::New()    

    ${OBSERVED real-world state of the object which corresponds to this exact specific DSC Resource instance} = Get-Item -Path ($this.OutputPath) -ErrorAction 'SilentlyContinue'


    if ($null -ne ${OBSERVED real-world state of the object which corresponds to this exact specific DSC Resource instance}) 
    {
      $CurrentState.Add('OutputPath',${OBSERVED real-world state of the object which corresponds to this exact specific DSC Resource instance}.FullName)
      $CurrentState.Add('Ensure',[Ensure]::Present)
    } 
    else 
    {
      $CurrentState.Add('Ensure',[Ensure]::Absent)
    }

    return $CurrentState
  }
}