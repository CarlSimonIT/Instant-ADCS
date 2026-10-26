[DscResource()]
class GlobalCertificateSignerSequence1 {
  [DscProperty(Key)]
  [ValidatePattern(
    '^Yes$'
  )]
  [System.String]
  $IsSingleInstance

  [DscProperty(Key)]
  [ValidatePattern(
    '^Global Certificate Signer$'
  )]
  [System.String]
  $FriendlyName

  [DscProperty()]
  [System.Boolean]
  $AlternateSignatureAlgorithm = $true

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
    ${OBSERVED real-world state of the object which corresponds to this exact specific DSC Resource instance} = Get-ChildItem -Path 'Cert:\LocalMachine\Root' -Recurse `
    | Where-Object -FilterScript {
      $_.FriendlyName -eq $this.FriendlyName
    }

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
    if ($this.Ensure -eq [Ensure]::Present) 
    {
      ${Cert-Global Certificate Signer} = Get-ChildItem -Path 'Cert:\LocalMachine\CA' -Recurse | Where-Object -FilterScript {
        $_.FriendlyName -eq $this.FriendlyName
      }

      ${Machine Store Root Container} = Get-Item -Path 'Cert:\LocalMachine\Root'
      ${Machine Store Root Container}.Open("ReadWrite")
      ${Machine Store Root Container}.Add(${Cert-Global Certificate Signer})
      ${Machine Store Root Container}.Close()

      Write-Verbose -Message "Export public key to file system as .cer"
      $HT = @{
        Type     = 'CERT'
        Cert     = ${Cert-Global Certificate Signer}
        FilePath = "${env:Pre-PKI CertFSOs}\$($this.FriendlyName).cer"
        Confirm  = $false
      }
      Export-Certificate @HT | Out-Null
    } 
    elseif ($this.Ensure -eq [Ensure]::Absent) 
    {
      Write-Debug -Message "Code executed when Test () returns `$false and Ensure is 'Absent'"
      Write-Verbose -Message "Eliminating '$($this.FriendlyName)' cert from Root"
      ${Cert-Global Certificate Signer} = Get-ChildItem -Path 'Cert:\LocalMachine\Root' -Recurse | Where-Object -FilterScript {
        $_.FriendlyName -eq $this.FriendlyName
      }
      ${Cert-Global Certificate Signer} | Remove-Item -Force

      Write-Verbose -Message "Delete .cer file"      
      Remove-Item -Path "${env:Pre-PKI CertFSOs}\$($this.FriendlyName).cer" -Verbose -Force
    }
  }

  #%_Get Explained Here-String_%
  [GlobalCertificateSignerSequence1] Get () {
    Write-Verbose -Message "Get () real-world state of GlobalCertificateSignerSequence1 resource instance"

    $CurrentState = [System.Collections.Hashtable]::New()    

    ${OBSERVED real-world state of the object which corresponds to this exact specific DSC Resource instance} = Get-ChildItem -Path 'Cert:\LocalMachine\Root' -Recurse `
    | Where-Object -FilterScript {
      $_.FriendlyName -eq $this.FriendlyName
    }

    if ($null -ne ${OBSERVED real-world state of the object which corresponds to this exact specific DSC Resource instance}) 
    {
      $CurrentState.Add('IsSingleInstance',$this.IsSingleInstance)
      $CurrentState.Add('FriendlyName',${OBSERVED real-world state of the object which corresponds to this exact specific DSC Resource instance}.FriendlyName)
      $CurrentState.Add('Ensure',[Ensure]::Present)
    } 
    else {
      $CurrentState.Add('IsSingleInstance',$this.IsSingleInstance)
      $CurrentState.Add('FriendlyName',$null)
      $CurrentState.Add('Ensure',[Ensure]::Absent)
    }

    return $CurrentState
  }
}