[DscResource()]
class DhcpExclusionInclusionOutline {
  [DscProperty(Key)]
  [ValidatePattern('\.clixml$')]
  [System.String]
  $FilePath

  [DscProperty()]
  [System.UInt32]
  $CIDR = 22

  [DscProperty()]
  [ValidateRange(1,9)]
  [System.UInt32]
  $ExclusionRangeSizeMinimumValue = 3

  [DscProperty()]
  [ValidateRange(11,19)]
  [System.UInt32]
  $ExclusionRangeSizeMaximumValue = 11

  [DscProperty()]
  [ValidateRange(1,50)]
  [System.UInt32]
  $InclusionRangeSizeMinimumValue = 25

  [DscProperty()]
  [ValidateRange(51,99)]
  [System.UInt32]
  $InclusionRangeSizeMaximumValue = 75

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
    ${OBSERVED real-world state of the object which corresponds to this exact specific DSC Resource instance} = Get-Item -Path ($this.FilePath) -ErrorAction 'SilentlyContinue'

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
      $ExcIncArrayList = [System.Collections.ArrayList]::New()
      $Exponent = 32 - $this.CIDR
      $AddressQuantity = ([System.Math]::Pow(2,$Exponent) - 3)

      $loopIndex = 0

      while (
        ($ExcIncArrayList | Measure-Object -Sum | Select-Object -ExpandProperty 'Sum') -lt $AddressQuantity
      ) {
        if (-not ($loopIndex % 2)) {
          $ExclusionRangeSize = Get-Random -Maximum $this.ExclusionRangeSizeMaximumValue -Minimum $this.ExclusionRangeSizeMinimumValue
          $ExcIncArrayList.Add([System.UInt32]$ExclusionRangeSize) | Out-Null
        } 
        else {
          $InclusionRangeSize = Get-Random -Maximum $this.InclusionRangeSizeMaximumValue -Minimum $this.InclusionRangeSizeMinimumValue
          $ExcIncArrayList.Add([System.UInt32]$InclusionRangeSize) | Out-Null
        }
        $loopIndex++
      }

      if (($ExcIncArrayList | Measure-Object -Sum | Select-Object -ExpandProperty 'Sum') -ne $AddressQuantity) {
        $Excess = ($ExcIncArrayList | Measure-Object -Sum | Select-Object -ExpandProperty 'Sum') - $AddressQuantity
        $ExcIncArrayList[-1] = $ExcIncArrayList[-1] - $Excess
      } 

      Write-Verbose -Message "Prior `$ExcIncArrayList[-1] = $($ExcIncArrayList[-1])"
      Write-Verbose -Message "Prior `$ExcIncArrayList[-2] = $($ExcIncArrayList[-2])"
      # The final element of $ExcIncArrayList cannot be the value 1. An exclusion or inclusion range length 1 doesn't make sense. 
      if ($ExcIncArrayList[-1] -eq 1) {   # If final element = 1
        $ExcIncArrayList[-1] += 1         # Then add 1 to final element
        Write-Verbose -Message "After `$ExcIncArrayList[-1] = $($ExcIncArrayList[-1])"
        $ExcIncArrayList[-2] -= 1         # and subtract 1 from penultimate element
        Write-Verbose -Message "After `$ExcIncArrayList[-2] = $($ExcIncArrayList[-2])"
      }
      ${Exclusion-Inclusion ArrayList} = $ExcIncArrayList

      $path = ([System.IO.FileInfo]$this.FilePath).DirectoryName
      $folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}

      Export-CliXml -Path $this.FilePath -InputObject (${Exclusion-Inclusion ArrayList}) # -Force
      Set-ItemProperty -Path $this.FilePath -Name 'IsReadOnly' -Value $true
    } 
    elseif ($this.Ensure -eq [Ensure]::Absent) 
    {
      Write-Verbose -Message "Delete .clixml file"
      Set-ItemProperty -Path $this.FilePath -Name 'IsReadOnly' -Value $false
      Remove-Item -Path ($this.FilePath) -Force
    }
  }

  #%_Get Explained Here-String_%
  [DhcpExclusionInclusionOutline] Get () {
    Write-Verbose -Message "Get () real-world state of DhcpExclusionInclusionOutline resource instance"

    $CurrentState = [System.Collections.Hashtable]::New()    

    ${OBSERVED real-world state of the object which corresponds to this exact specific DSC Resource instance} = Get-Item -Path ($this.FilePath) -ErrorAction 'SilentlyContinue'

    if ($null -ne ${OBSERVED real-world state of the object which corresponds to this exact specific DSC Resource instance}) 
    {
      $CurrentState.Add('FilePath',${OBSERVED real-world state of the object which corresponds to this exact specific DSC Resource instance}.FullName)
      $CurrentState.Add('Ensure',[Ensure]::Present)
    } 
    else 
    {
      $CurrentState.Add('Ensure',[Ensure]::Absent)
    }

    return $CurrentState
  }
}