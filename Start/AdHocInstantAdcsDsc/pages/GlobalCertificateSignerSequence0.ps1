#Requires -Modules @{ModuleName='PKI';RequiredVersion="1.0.0.0"}

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
    '^Global Cert Signer$'
  )]
  [System.String]
  $FriendlyName

  [DscProperty()]
  [System.Boolean]
  $AlternateSignatureAlgorithm = $true

  [DscProperty()]
  [System.TimeSpan]
  ${Pre-PKI Certificate Duration} = (New-TimeSpan -Days 4 -Hours 3 -Minutes 2 -Seconds 1)

  [DscProperty()]
  [Ensure]$Ensure = [Ensure]::Present

  # Configuration Enact implements Test () and Set ()
  [System.Boolean] Test () {
    Write-Verbose -Message "String introducing Test () method of the GlobalCertificateSignerSequence0 class-based DSC Resource"

    Write-Debug -Message "Code that returns either `$null or an object instance represening the current state"


    ${Detected Object} = Get-ChildItem -Path 'Cert:\LocalMachine\My' -Recurse | Where-Object -FilterScript {
      $_.FriendlyName -eq $CurrentState.FriendlyName
    }

    $IsPresent = $null -ne ${Detected Object}

    if ($CurrentState.Ensure -eq [Ensure]::Present) {
      if ($IsPresent) 
      {
        Write-Verbose -Message "Want present and IS present"
        return $true
      } 
      else 
      {
        Write-Verbose -Message "Want present but is NOT present"
        return $false
      }
    } 
    else {
      if ($IsPresent) 
      {
        Write-Verbose -Message "Do NOT want present but IS present"
        return $false
      } 
      else 
      {
        Write-Verbose -Message "Do NOT want present and IS NOT present"
        return $true
      }
    }
  }

  [System.Void] Set () {
    Write-Verbose -Message "String introducing Set () method of the GlobalCertificateSignerSequence0 class-based DSC Resource"
    $PSModuleInfo = Import-Module 'PKI' -Force -Passthru

    if ($this.Ensure -eq [Ensure]::Present) 
    {
      Write-Debug -Message "Code executed when Test () returns `$false and Ensure is 'Present'"
      ${Imported Module} = Import-Module -Name 'PKI' -Force -PassThru
      #using namespace Microsoft.CertificateServices.Commands

      ${Extension to X.509v3 OID-Enhanced Key Usage} = ([System.Security.Cryptography.Oid]'Enhanced Key Usage').Value
      ${Extension to X.509v3 OID-Subject Alternative Name} = ([System.Security.Cryptography.Oid]'Subject Alternative Name').Value
      $HT = @{
        FriendlyName                = [System.String]$this.FriendlyName
        Subject                     = [System.String]"CN=$($env:ComputerName)"
        Type                       = 'Custom'
        Provider                    = [System.String]'Microsoft Software Key Storage Provider' # start msedge.exe 'https://www.pkisolutions.com/understanding-microsoft-crypto-providers/'
        NotAfter                    = [System.DateTime]([System.DateTime]::Now).Add(${Pre-PKI Certificate Duration})
        KeyUsage                    = [Microsoft.CertificateServices.Commands.KeyUsage[]]@('CertSign')
        KeyUsageProperty            = [Microsoft.CertificateServices.Commands.KeyUsageProperty[]]@('Sign')
        KeyExportPolicy             = [Microsoft.CertificateServices.Commands.KeyExportPolicy[]]('NonExportable')  # try 'ExportableEncrypted' 
        KeyProtection               = [Microsoft.CertificateServices.Commands.KeyProtection[]]('None')
        AlternateSignatureAlgorithm = [System.Boolean]$this.AlternateSignatureAlgorithm
      }
      ${Cert-Global Certificate Signer} = New-SelfSignedCertificate @HT

      Write-Verbose -Message "Update FriendlyName of public key cert in Intermediate Certificate Authorities store"
      (Get-Item -Path "Cert:\LocalMachine\CA\$(${Cert-Global Certificate Signer}.Thumbprint)").FriendlyName = $this.FriendlyName

      Set-Content -Value $() -Path 
      ${FriendlyName Sanitized} = $this.FriendlyName -replace [System.Char]39,''
      ${Thumbprint Sanitized} = ${Cert-Global Certificate Signer}.Thumbprint -replace '\s', ''

      $HT = @{
        Path  = "${env:Pre-PKI CertFSOs}\${FriendlyName Sanitized}.txt"
        Value = ${Thumbprint Sanitized}
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
      ${Cert-Global Certificate Signer} | Remove-Item -Force

      Write-Verbose -Message "Eliminating the self-signed cert from Intermediate Certificate Authorities store"

      $Thumbprint = ${Cert-Global Certificate Signer}.Thumbprint
      
      Remove-Item -Path "Cert:\LocalMachine\CA\$Thumbprint" -Verbose -Force
    }
  }
  
  # Get () retrieves current state of the resource instance
  [GlobalCertificateSignerSequence0] Get () {
    Write-Verbose -Message "String introducing Get () method of the GlobalCertificateSignerSequence0 class-based DSC Resource"
    $CurrentState = [System.Collections.Hashtable]::New()    
    Write-Debug -Message "Code that returns either `$null or an object instance represening the current state"

    ${Detected Object} = Get-ChildItem -Path 'Cert:\LocalMachine\My' -Recurse | Where-Object -FilterScript {
      $_.FriendlyName -eq $this.FriendlyName
    }


    if ($null -ne ${Detected Object}) 
    {
      $CurrentState.Add('FriendlyName',${Detected Object}.FriendlyName)
      $CurrentState.Add('IsSingleInstance',$this.IsSingleInstance)
      $CurrentState.Add('Ensure',[Ensure]::Present)
    } 
    else {
      $CurrentState.Add('Ensure',[Ensure]::Absent)
    }

    return $CurrentState
  }
}