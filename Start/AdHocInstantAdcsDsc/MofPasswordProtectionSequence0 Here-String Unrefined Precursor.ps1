[DscResource()]
class MofPasswordProtectionSequence0 {
  [DscProperty(Key)]
  [ValidatePattern(
    '^Encrypt Passwords in MOF for LCM on [a-z0-9_-]{1,63}$'
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
    if ($this.Ensure -eq [Ensure]::Present) 
    {
      ${Extension to X.509v3 OID-Enhanced Key Usage} = ([System.Security.Cryptography.Oid]'Enhanced Key Usage').Value
      ${EKU OID-Document Encryption} = ([System.Security.Cryptography.Oid]'Document Encryption').Value
      $TextExtensions = @(
        "${Extension to X.509v3 OID-Enhanced Key Usage}={text}${EKU OID-Document Encryption}"
      )
      $this.FriendlyName -match "^(?<LHS>Encrypt Passwords in MOF for LCM on) (?<Config_Target_Mgmt_Cname>$(${env:regex literal DNS CNAME (Anchorless)}))`$" | Out-Null

      $Config_Target_Mgmt_Cname = $Matches['Config_Target_Mgmt_Cname']
      $ConfigTargetComputerNameFile = $Config_Target_Mgmt_Cname | ForEach-Object -Process {
        $HT = @{
          Path    = $env:Statics
          Filter  = "*$_ ComputerName.txt"
          Recurse = $true
        }
        Get-ChildItem @HT
      }
      $ConfigTargetComputerName = $ConfigTargetComputerNameFile | Get-Content

      $HT = @{
        FriendlyName                = [System.String]$this.FriendlyName
        Subject                     = [System.String]"CN=$($ConfigTargetComputerName)"
        TextExtension               = [System.String[]]$TextExtensions
        Provider                    = [System.String]'Microsoft Software Key Storage Provider'  # start msedge.exe 'https://www.pkisolutions.com/understanding-microsoft-crypto-providers/'
        NotAfter                    = [System.DateTime]([System.DateTime]::Now).Add([System.TimeSpan]($this.PrePKICertificateDuration))
        HashAlgorithm               = [System.String]'SHA256'
        KeyAlgorithm                = [System.String]'RSA'
        KeyLength                   = [System.Int32]4096
        KeyUsage                    = [System.String[]]@(
          #'CertSign'
          #'CRLSign'
          'DataEncipherment'
          #'DecipherOnly'
          #'DigitalSignature'
          #'EncipherOnly'
          #'KeyAgreement'
          'KeyEncipherment'
          #'None'
          #'NonRepudiation'
        )
        KeyExportPolicy             = [System.String[]]('ExportableEncrypted')
        KeyProtection               = [System.String[]]('None')
        AlternateSignatureAlgorithm = [System.Boolean]$this.AlternateSignatureAlgorithm
        Signer                      = $(
          Get-ChildItem -Path 'Cert:\LocalMachine\Root' -Recurse | Where-Object -FilterScript {
            $_.FriendlyName -eq 'Global Certificate Signer'
          }
        )
      }
      Import-Module -Name 'PKI' -Cmdlet 'New-SelfSignedCertificate' -RequiredVersion '1.0.0.0'
      ${Cert-MOF Password Protector-EKU Document Encryption} = New-SelfSignedCertificate @HT
      ${Cert Thumbprint-MOF Password Protector-EKU Document Encryption} = ${Cert-MOF Password Protector-EKU Document Encryption}.Thumbprint

      Write-Verbose -Message "Write thumbprint to text file."
      $CertPath = "Cert:\LocalMachine\My\${Cert Thumbprint-MOF Password Protector-EKU Document Encryption}"
      (Get-Item -Path $CertPath).FriendlyName = $this.FriendlyName

      $HT = @{
        Path  = "${env:Pre-PKI CertFSOs}\$($this.FriendlyName).txt"
        Value = ${Cert Thumbprint-MOF Password Protector-EKU Document Encryption}
        Force = $true
      }
      Set-Content @HT | Out-Null
    } 
    elseif ($this.Ensure -eq [Ensure]::Absent) 
    {
      Write-Verbose -Message "Eliminating the cert from LocalMachine\My"
      ${Cert-MOF Password Protector-EKU Document Encryption} = Get-ChildItem -Path 'Cert:\LocalMachine\My' -Recurse | Where-Object -FilterScript {
        $_.FriendlyName -eq $this.FriendlyName
      }
      ${Cert-MOF Password Protector-EKU Document Encryption} | Remove-Item -Verbose -Force
      Write-Verbose -Message "Removing text file containing cert thumbprint"
    }
  }

  #%_Get Explained Here-String_%
  [MofPasswordProtectionSequence0] Get () {
    Write-Verbose -Message "Get () real-world state of MofPasswordProtectionSequence0 resource instance"

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