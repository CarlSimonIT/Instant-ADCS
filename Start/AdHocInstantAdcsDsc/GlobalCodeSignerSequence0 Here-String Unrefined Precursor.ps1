[DscResource()]
class GlobalCodeSignerSequence0 {
  [DscProperty(Key)]
  [ValidatePattern(
    '^Yes$'
  )]
  [System.String]
  $IsSingleInstance

  [DscProperty(Key)]
  [ValidatePattern(
    '^Global Code Signer$'
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
      ${EKU OID-Code Signing} = ([System.Security.Cryptography.Oid]'Code Signing').Value
      ${Extension to X.509v3 OID-Subject Alternative Name} = ([System.Security.Cryptography.Oid]'Subject Alternative Name').Value
      $TextExtensions = @(
        "${Extension to X.509v3 OID-Enhanced Key Usage}={text}${EKU OID-Code Signing}"
      )

      $HT = @{
        FriendlyName                = [System.String]$this.FriendlyName
        Subject                     = [System.String]"CN=$($env:ComputerName)"
        TextExtension               = [System.String[]]$TextExtensions
        Provider                    = [System.String]'Microsoft Software Key Storage Provider'  # start msedge.exe 'https://www.pkisolutions.com/understanding-microsoft-crypto-providers/'
        NotAfter                    = [System.DateTime]([System.DateTime]::Now).Add([System.TimeSpan]($this.PrePKICertificateDuration))
        HashAlgorithm               = [System.String]"SHA256"
        KeyAlgorithm                = [System.String]'RSA'
        KeyLength                   = [System.Int32]4096
        KeyExportPolicy             = [System.String[]]('ExportableEncrypted')
        KeyProtection               = [System.String[]]('None')
        AlternateSignatureAlgorithm = [System.Boolean]$this.AlternateSignatureAlgorithm
        Signer                      = $(
          Get-ChildItem -Path 'Cert:\LocalMachine\My' -Recurse | Where-Object -FilterScript {
            $_.FriendlyName -eq 'Global Certificate Signer'
          }
        )
      }

      Import-Module -Name 'PKI' -Cmdlet 'New-SelfSignedCertificate' -RequiredVersion '1.0.0.0'
      ${Cert-Global Code Signer} = New-SelfSignedCertificate @HT
      ${Cert Thumbprint-Global Code Signer} = ${Cert-Global Code Signer}.Thumbprint

      $HT = @{
        Path  = "${env:Pre-PKI CertFSOs}\$($this.FriendlyName).txt"
        Value = ${Cert Thumbprint-Global Code Signer}
        Force = $true
      }
      Set-Content @HT | Out-Null
    } 
    elseif ($this.Ensure -eq [Ensure]::Absent) 
    {
      Write-Debug -Message "Code executed when Test () returns `$false and Ensure is 'Absent'"

      ${Cert-Global Code Signer} = Get-ChildItem -Path 'Cert:\LocalMachine\My' -Recurse | Where-Object -FilterScript {
        $_.FriendlyName -eq $this.FriendlyName
      }
      ${Cert Thumbprint-Global Code Signer} = ${Cert-Global Code Signer}.Thumbprint
      ${Cert-Global Code Signer} | Remove-Item -Force

      Write-Verbose -Message "Remove text file containing cert thumbprint"
      Remove-Item -Path "${env:Pre-PKI CertFSOs}\$($this.FriendlyName).txt" -Force
    }
  }

  #%_Get Explained Here-String_%
  [GlobalCodeSignerSequence0] Get () {
    Write-Verbose -Message "Get () real-world state of GlobalCodeSignerSequence0 resource instance"

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