[DscResource()]
class PrePKIClientAuthenticationCertificateSequence0 {
  [DscProperty(Key)]
  [ValidatePattern(
    "^Local Account '[a-z0-9_-]{1,63} \d{3}'`$"
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
    Write-Verbose -Message "Call to Set()"
    if ($this.Ensure -eq [Ensure]::Present) 
    {
      $this.FriendlyName -match "^Local Account $([System.Char]39)(?<Config_Target_Mgmt_Cname>[a-z0-9_-]{1,63}) (?<Relative_ID_Segment>\d{3})$([System.Char]39)`$" | Out-Null
      $Config_Target_Mgmt_Cname = $Matches['Config_Target_Mgmt_Cname']
      $Relative_ID_Segment = $Matches['Relative_ID_Segment']
      if ($Config_Target_Mgmt_Cname -ne ${env:NetBIOS Name of Root Domain in AD Forest}) {
        $ConfigTargetComputerName = [QuickMgmtCnameConversion]::CN($Config_Target_Mgmt_Cname)
        $UserName = $ConfigTargetComputerName + ' ' + $Relative_ID_Segment
        $UPN0 = "$([System.Char]39)$($UserName)$([System.Char]39)$([System.Char]64)localhost"
        $UPN1 = "$UserName$([System.Char]64)localhost"
      } 
      else {
        $UserName = ${env:NetBIOS Name of Root Domain in AD Forest} + ' ' + $Relative_ID_Segment
        $UPN0 = "$([System.Char]39)$($UserName)$([System.Char]39)$([System.Char]64)localhost"
        $UPN1 = "$UserName$([System.Char]64)localhost"
      }

      ${Extension to X.509v3 OID-Enhanced Key Usage} = ([System.Security.Cryptography.Oid]'Enhanced Key Usage').Value
      ${EKU OID-Client Authentication} = ([System.Security.Cryptography.Oid]'Client Authentication').Value
      ${Extension to X.509v3 OID-Subject Alternative Name} = ([System.Security.Cryptography.Oid]'Subject Alternative Name').Value
      $TextExtensions = @(
        "${Extension to X.509v3 OID-Enhanced Key Usage}={text}${EKU OID-Client Authentication}"
        "${Extension to X.509v3 OID-Subject Alternative Name}={text}upn=$UPN0&upn=$UPN1"
      )
      $Subject = "CN=$([System.Char]39)$($UserName)$([System.Char]39)$([System.Char]64)localhost"

      $HT = @{
        FriendlyName                = [System.String]$this.FriendlyName
        Subject                     = [System.String]$Subject
        TextExtension               = [System.String[]]$TextExtensions
        Provider                    = [System.String]'Microsoft Software Key Storage Provider'  # start msedge.exe 'https://www.pkisolutions.com/understanding-microsoft-crypto-providers/'
        NotAfter                    = [System.DateTime]([System.DateTime]::Now).Add([System.TimeSpan]($this.PrePKICertificateDuration))
        HashAlgorithm               = [System.String]"SHA256"
        KeyAlgorithm                = [System.String]'RSA'
        KeyLength                   = [System.Int32]4096
        KeyUsage                    = [System.String[]]@(
          'CertSign'
          #'CRLSign'
          #'DataEncipherment'
          #'DecipherOnly'
          'DigitalSignature'
          #'EncipherOnly'
          #'KeyAgreement'
          'KeyEncipherment'
          #'None'
          #'NonRepudiation'
        )
        KeyUsageProperty            = [System.String[]]@(
          'Sign'
          #'All'
          #'Decrypt'
          #'KeyAgreement'
          #'None'
        )
        KeyExportPolicy             = [System.String[]]('ExportableEncrypted')
        KeyProtection               = [System.String[]]("None")
        AlternateSignatureAlgorithm = [System.Boolean]$this.AlternateSignatureAlgorithm
        Signer                      = $(
          Get-ChildItem -Path 'Cert:\LocalMachine\Root' -Recurse | Where-Object -FilterScript {
            $_.FriendlyName -eq 'Pre-PKI Global Certificate Signer'
          }
        )
      }
      Import-Module -Name 'PKI' -Cmdlet 'New-SelfSignedCertificate' -RequiredVersion '1.0.0.0'
      ${Cert-Pre-PKI Public Key from Client to Server for WS-Man Connection-EKU Client Authentication} = New-SelfSignedCertificate @HT
      ${Cert Thumbprint-Pre-PKI Public Key from Client to Server for WS-Man Connection-EKU Client Authentication} = ${Cert-Pre-PKI Public Key from Client to Server for WS-Man Connection-EKU Client Authentication}.Thumbprint

      Write-Verbose -Message "Write thumbprint to text file."
      $CertPath = "Cert:\LocalMachine\My\${Cert Thumbprint-Pre-PKI Public Key from Client to Server for WS-Man Connection-EKU Client Authentication}"
      (Get-Item -Path $CertPath).FriendlyName = $this.FriendlyName

      $HT = @{
        Path  = "${env:Pre-PKI CertFSOs}\$($this.FriendlyName).txt"
        Value = ${Cert Thumbprint-Pre-PKI Public Key from Client to Server for WS-Man Connection-EKU Client Authentication}
        Force = $true
      }
      Set-Content @HT | Out-Null
    } 
    elseif ($this.Ensure -eq [Ensure]::Absent) 
    {
      Write-Verbose -Message "Eliminating the cert from LocalMachine\My"
      ${Cert-Pre-PKI Public Key from Client to Server for WS-Man Connection-EKU Client Authentication} = Get-ChildItem -Path 'Cert:\LocalMachine\My' -Recurse | Where-Object -FilterScript {
        $_.FriendlyName -eq $this.FriendlyName
      }
      ${Cert-Pre-PKI Public Key from Client to Server for WS-Man Connection-EKU Client Authentication} | Remove-Item -Verbose -Force
      Write-Verbose -Message "Removing text file containing cert thumbprint"
    }
  }

  #%_Get Explained Here-String_%
  [PrePKIClientAuthenticationCertificateSequence0] Get () {
    Write-Verbose -Message "Get () real-world state of PrePKIClientAuthenticationCertificateSequence0 resource instance"

    $CurrentState = [System.Collections.Hashtable]::New()    

    ${OBSERVED real-world state of the object which corresponds to this exact specific DSC Resource instance} = Get-ChildItem -Path 'Cert:\LocalMachine\My' -Recurse `
    | Where-Object -FilterScript {
      $_.FriendlyName -eq $this.FriendlyName
    }

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