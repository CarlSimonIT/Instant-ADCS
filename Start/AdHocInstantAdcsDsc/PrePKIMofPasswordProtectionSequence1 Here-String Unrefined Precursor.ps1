[DscResource()]
class PrePKIMofPasswordProtectionSequence1 {
  [DscProperty(Key)]
  [ValidatePattern(
    '^Encrypt Passwords in MOF for LCM on [a-z0-9_-]{1,63}$'
  )]
  [System.String]
  $FriendlyName

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
    ${OBSERVED real-world state of the object which corresponds to this exact specific DSC Resource instance} = Get-ChildItem -Path "${env:Pre-PKI CertFSOs}" -File | Where-Object -FilterScript {$_.Name -eq "$($this.FriendlyName).cer"}

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
      Write-Verbose -Message "Export public key to file system as .cer"
      $cert = Get-ChildItem -Path 'Cert:\LocalMachine\My' -Recurse | Where-Object -FilterScript {
        $_.FriendlyName -eq $this.FriendlyName
      }
      $HT = @{
        Type     = 'CERT'
        Cert     = $cert
        FilePath = "${env:Pre-PKI CertFSOs}\$($this.FriendlyName).cer"
        Confirm  = $false
      }
      Import-Module -Name 'PKI' -Cmdlet 'Export-Certificate' -RequiredVersion '1.0.0.0'
      Export-Certificate @HT | Out-Null
    } 
    elseif ($this.Ensure -eq [Ensure]::Absent) 
    {
      Write-Verbose -Message "Delete .cer file"
      Remove-Item -Path "${env:Pre-PKI CertFSOs}\$($this.FriendlyName).cer" -Force
    }
  }

  #%_Get Explained Here-String_%
  [PrePKIMofPasswordProtectionSequence1] Get () {
    Write-Verbose -Message "Get () real-world state of PrePKIMofPasswordProtectionSequence1 resource instance"

    $CurrentState = [System.Collections.Hashtable]::New()    

    ${OBSERVED real-world state of the object which corresponds to this exact specific DSC Resource instance} = Get-ChildItem -Path "${env:Pre-PKI CertFSOs}" -File | Where-Object -FilterScript {$_.Name -eq "$($this.FriendlyName).cer"}

    if ($null -ne ${OBSERVED real-world state of the object which corresponds to this exact specific DSC Resource instance}) 
    {
      $CurrentState.Add('FriendlyName',${OBSERVED real-world state of the object which corresponds to this exact specific DSC Resource instance}.FriendlyName)
      $CurrentState.Add('Ensure',[Ensure]::Present)
    } 
    else {
      $CurrentState.Add('FriendlyName',$null)
      $CurrentState.Add('Ensure',[Ensure]::Absent)
    }

    return $CurrentState
  }
}