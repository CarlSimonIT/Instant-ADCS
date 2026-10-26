[DscResource()]
class GlobalCertificateSignerSequence0 {
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

  [DscProperty()]
  [System.String]
  $PrePKICertificateDuration = '4.03:02:01'

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
    ${OBSERVED real-world state of the object which corresponds to this exact specific DSC Resource instance} = Get-ChildItem -Path 'Cert:\LocalMachine\My' -Recurse `
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
    #$PSModuleInfo = Import-Module 'PKI' -Force -Passthru

    if ($this.Ensure -eq [Ensure]::Present) 
    {
      ${Extension to X.509v3 OID-Enhanced Key Usage} = ([System.Security.Cryptography.Oid]'Enhanced Key Usage').Value
      ${Extension to X.509v3 OID-Subject Alternative Name} = ([System.Security.Cryptography.Oid]'Subject Alternative Name').Value
      $HT = @{
        FriendlyName                = [System.String]$this.FriendlyName
        Subject                     = [System.String]"CN=$($env:ComputerName)"
        Type                        = 'Custom'
        Provider                    = [System.String]'Microsoft Software Key Storage Provider'  # start msedge.exe 'https://www.pkisolutions.com/understanding-microsoft-crypto-providers/'
        NotAfter                    = [System.DateTime]([System.DateTime]::Now).Add([System.TimeSpan]($this.PrePKICertificateDuration))
        KeyUsage                    = [System.String[]]@('CertSign')
        KeyUsageProperty            = [System.String[]]@('Sign')
        KeyExportPolicy             = [System.String[]]('NonExportable') # try 'ExportableEncrypted' 
        KeyProtection               = [System.String[]]('None')
        AlternateSignatureAlgorithm = [System.Boolean]$this.AlternateSignatureAlgorithm
      }

      #$PSModuleInfo = Import-Module -Name 'PKI' -Force -PassThru
      Import-Module -Name 'PKI' -Cmdlet 'New-SelfSignedCertificate' -RequiredVersion '1.0.0.0'
      ${Cert-Global Certificate Signer} = New-SelfSignedCertificate @HT
      ${Cert Thumbprint-Global Certificate Signer} = ${Cert-Global Certificate Signer}.Thumbprint

      Write-Verbose -Message "Update FriendlyName of public key cert in Intermediate Certificate Authorities store"
      $CertPath = "Cert:\LocalMachine\CA\${Cert Thumbprint-Global Certificate Signer}"
      (Get-Item -Path $CertPath).FriendlyName = $this.FriendlyName

      $HT = @{
        Path  = "${env:Pre-PKI CertFSOs}\$($this.FriendlyName).txt"
        Value = ${Cert Thumbprint-Global Certificate Signer}
        Force = $true
      }
      Set-Content @HT | Out-Null
    } 
    elseif ($this.Ensure -eq [Ensure]::Absent) 
    {
      Write-Debug -Message "Code executed when Test () returns `$false and Ensure is 'Absent'"

      ${Cert-Global Certificate Signer} = Get-ChildItem -Path 'Cert:\LocalMachine\My' -Recurse | Where-Object -FilterScript {
        $_.FriendlyName -eq $this.FriendlyName
      }
      ${Cert Thumbprint-Global Certificate Signer} = ${Cert-Global Certificate Signer}.Thumbprint
      ${Cert-Global Certificate Signer} | Remove-Item -Force

      Write-Verbose -Message "Eliminating the self-signed cert from Intermediate Certificate Authorities store"
      
      Remove-Item -Path "Cert:\LocalMachine\CA\${Cert Thumbprint-Global Certificate Signer}" -Verbose -Force
    }
  }

  #%_Get Explained Here-String_%
  [GlobalCertificateSignerSequence0] Get () {
    Write-Verbose -Message "Get () real-world state of GlobalCertificateSignerSequence0 resource instance"

    $CurrentState = [System.Collections.Hashtable]::New()    

    ${OBSERVED real-world state of the object which corresponds to this exact specific DSC Resource instance} = Get-ChildItem -Path 'Cert:\LocalMachine\My' -Recurse `
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