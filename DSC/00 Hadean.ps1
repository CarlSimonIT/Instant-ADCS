#region | Classes/Functions/Variables defined before launching a chronological unit |
$ProjectName = "Instant-ADCS"
${.s} = "$env:DSC_CFG_ROOT\$ProjectName\Dot-Sourced Structural Data"

. "$PSHOME\Lightweight Functions.ps1"
. "$PSHOME\Important Variables.ps1"
. "$PSHOME\Node Mgmt NetIPInterface CNAMEs.ps1"
. "$PSHOME\Type Accelerator Instance.ps1"
. "$PSHOME\Class Definitions\Windows Server Image Index.ps1"
. "$PSHOME\Class Definitions\Quick Management Cname Conversions.ps1"
. "$PSHOME\Regular Expression Patterns.ps1"

$Host.PrivateData.DebugForegroundColor = $(rFc)
# $Host.PrivateData.DebugBackgroundColor = $(rBc)

$Host.PrivateData.VerboseForegroundColor = $(rFc)
# $Host.PrivateData.VerboseBackgroundColor = $(rBc)
$error.Clear()
#endregion

$InstanceIndex = '00'; $InstanceChrono = 'Hadean'; $InstanceDesc = "Pre-Document Encryption"
$InstanceName = 'x_' + $InstanceIndex + '_' + $InstanceChrono + '__' + $($InstanceDesc -replace '[^\w\.-]','_')
$InstanceFolderName = $InstanceIndex + ' ' + $InstanceChrono + ' ' + $InstanceDesc
$LCM_InstanceName = 'LCM_' + $InstanceIndex + '_' + $InstanceChrono + '__' + $($InstanceDesc -replace '[^\w\.-]','_')

$path = "$MOFs\$InstanceFolderName"; 
$OutputFolder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}

[System.Management.Automation.DscLocalConfigurationManagerAttribute()] Configuration $LCM_InstanceName {
  Node 'localhost' {
    Settings {
      ActionAfterReboot              = [System.String]'ContinueConfiguration'
      AllowModuleOverwrite           = [System.Boolean]$true
      ConfigurationMode              = [System.String]'ApplyAndAutoCorrect'
      ConfigurationModeFrequencyMins = [System.UInt32]15
      RefreshFrequencyMins           = [System.UInt32]30
      RebootNodeIfNeeded             = [System.Boolean]$true
      RefreshMode                    = [System.String]'Push'
      StatusRetentionTimeInDays      = [System.UInt32]20
    }
  }
}
$lcmHT = @{
  InstanceName = $LCM_InstanceName
  OutputPath   = "$OutputFolder"
  Verbose      = $true
}
Invoke-Expression -Verbose:$true -Command "$LCM_InstanceName @lcmHT"
Set-DscLocalConfigurationManager -ComputerName 'localhost' -Path $lcmHT['OutputPath'] -Force

Configuration $InstanceName {
  #region | Import DSC Resources into the Configuration Document |
  Import-DscResource -ModuleName 'PSDesiredStateConfiguration'  -ModuleVersion 1.1
  Import-DscResource -ModuleName 'xPSDesiredStateConfiguration' -ModuleVersion 9.2.2
  Import-DscResource -ModuleName 'AdHocInstantAdcsDsc'          -ModuleVersion 0.4.0
  Import-DscResource -ModuleName 'ComputerManagementDsc'        -ModuleVersion 10.0.1
  Import-DscResource -ModuleName 'CertificateDsc'               -ModuleVersion 6.1.0
  #endregion

  Node 'localhost' {
    #region | Strictest Level of Windows PowerShell Transcription and ScriptBlock/Module Logging |
    $ParentPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell"
    xRegistry 'PowerShell 5.1 Module Logging' { # PowerShell 5.1 Module Logging |
      ValueName = 'EnableModuleLogging'
      Key       = "$ParentPath\ModuleLogging"
      ValueData = '1'
      ValueType = 'Dword'
      Force     = $true
      Ensure    = 'Present'
    }
    xRegistry 'PowerShell 5.1 ScriptBlock Logging' { # PowerShell 5.1 ScriptBlock Logging |
      ValueName = 'EnableScriptBlockLogging'
      Key       = "$ParentPath\ScriptBlockLogging"
      ValueData = '1'
      ValueType = 'DWord'
      Force     = $true
      Ensure    = 'Present'
      DependsOn = [System.String[]]@(
        "[xRegistry]PowerShell 5.1 Module Logging"
      )
    }
    xRegistry 'PowerShell 5.1 ScriptBlock Invocation Logging' { # PowerShell 5.1 ScriptBlock Invocation Logging |
      ValueName = 'EnableScriptBlockInvocationLogging'
      Key       = "$ParentPath\ScriptBlockLogging"
      ValueData = '1'
      ValueType = 'Dword'
      Force     = $true
      Ensure    = 'Present'
      DependsOn = [System.String[]]@(
        "[xRegistry]PowerShell 5.1 ScriptBlock Logging"
      )
    }
    xRegistry 'PowerShell 5.1 Transcription-Enable Invocation Header' { # PowerShell 5.1 Transcription-Enable Invocation Header |
      ValueName = 'EnableInvocationHeader'
      Key       = "$ParentPath\Transcription"
      ValueData = '1'
      ValueType = 'Dword'
      Force     = $true
      Ensure    = 'Present'
      DependsOn = [System.String[]]@(
        "[xRegistry]PowerShell 5.1 ScriptBlock Invocation Logging"
      )
    }
    xRegistry 'PowerShell 5.1 Transcription-Enable Transcribing' { # PowerShell 5.1 Transcription-Enable Transcribing |
      ValueName = 'EnableTranscribing'
      Key       = "$ParentPath\Transcription"
      ValueData = "1"
      ValueType = 'String'
      Force     = $true
      Ensure    = 'Present'
      DependsOn = [System.String[]]@(
        "[xRegistry]PowerShell 5.1 Transcription-Enable Invocation Header"
      )
    }
    xRegistry 'PowerShell 5.1 Transcription-Enable Transcripting' { # PowerShell 5.1 Transcription-Enable Transcripting |
      ValueName = 'EnableTranscripting'
      Key       = "$ParentPath\Transcription"
      ValueData = "1"
      ValueType = 'Dword'
      Force     = $true
      Ensure    = 'Present'
      DependsOn = [System.String[]]@(
        "[xRegistry]PowerShell 5.1 Transcription-Enable Transcribing"
      )
    }
    xRegistry 'PowerShell 5.1 Transcription-Output Directory' { # PowerShell 5.1 Transcription-Output Directory |
      ValueName = 'OutputDirectory'
      Key       = "$ParentPath\Transcription"
      ValueData = "$env:ProgramData\Transcript-PowerShell 5.1"
      ValueType = 'String'
      Force     = $true
      Ensure    = 'Present'
      DependsOn = [System.String[]]@(
        "[xRegistry]PowerShell 5.1 Transcription-Enable Transcripting"
      )
    }
    #endregion

    #region | System-scope Environment Variables |
    xEnvironment 'regex literal DNS CNAME \Anchorless\' {
      Name      = "regex literal DNS CNAME (Anchorless)"
      Value     = ${regex literal DNS CNAME (Anchorless)}
      Ensure    = 'Present'
      Path      = $false
      DependsOn = [System.String[]]@( 
        "[xRegistry]PowerShell 5.1 Transcription-Output Directory"
      )
    }
    #endregion

    #region | Diagnostics-Enable channels in the Microsoft-Windows-Dsc Event Log Provider |
    WindowsEventLogChannelThatIsENABLEDforDscTracking 'Operational channel for the Microsoft-Windows-Dsc event log provider on localhost' {
      Channel   = 'Operational'
      Ensure    = 'Present'
      DependsOn = [System.String[]]@(
        "[xEnvironment]regex literal DNS CNAME \Anchorless\"
      )
    }
    WindowsEventLogChannelThatIsENABLEDforDscTracking 'Analytic channel for the Microsoft-Windows-Dsc event log provider on localhost' {
      Channel   = 'Analytic'
      Ensure    = 'Present'
      DependsOn = [System.String[]]@(
        "[WindowsEventLogChannelThatIsENABLEDforDscTracking]Operational channel for the Microsoft-Windows-Dsc event log provider on localhost"
      )
    }
    WindowsEventLogChannelThatIsENABLEDforDscTracking 'Debug channel for the Microsoft-Windows-Dsc event log provider on localhost' {
      Channel   = 'Debug'
      Ensure    = 'Present'
      DependsOn = [System.String[]]@(
        "[WindowsEventLogChannelThatIsENABLEDforDscTracking]Analytic channel for the Microsoft-Windows-Dsc event log provider on localhost"
      )
    }
    #endregion

    #region | One-time Generation of New Random %ComputerNames% |
    ${Is file with new random %ComputerNames% present at time of MOF compilation} = Test-Path -Path "$Statics\CNs\${DSC Authoring Station Mgmt Cname} ComputerName.txt"
    if (-not ${Is file with new random %ComputerNames% present at time of MOF compilation}) {
      File "New Random ComputerName for primordial Unclustered Hyper-V Host" {
        DestinationPath = "$Statics\CNs\${DSC Authoring Station Mgmt Cname} ComputerName.txt"
        Attributes      = @('ReadOnly')
        Contents        = $(('WIN-' + ([System.IO.Path]::GetRandomFileName()) -replace '\.','' -join '').ToUpper())
        Force           = $true
        Type            = 'File'
        Ensure          = 'Present'
        DependsOn       = [System.String[]]@(
          "[WindowsEventLogChannelThatIsENABLEDforDscTracking]Debug channel for the Microsoft-Windows-Dsc event log provider on localhost"
        )
      }
    }
    #region | Rename Computer and Reboot |
    if (${Is file with new random %ComputerNames% present at time of MOF compilation}) {
      Computer "New Random ComputerName for primordial Unclustered Hyper-V Host" {
        Name                  = $(Get-Content -Path "$Statics\CNs\${DSC Authoring Station Mgmt Cname} ComputerName.txt")
        Description           = 'Description TBD'
        WorkGroupName         = 'NoNetwork'
        DependsOn             = [System.String[]]@(
          "[WindowsEventLogChannelThatIsENABLEDforDscTracking]Debug channel for the Microsoft-Windows-Dsc event log provider on localhost"
        )
      }
      PendingReboot "New Random ComputerName for primordial Unclustered Hyper-V Host" {
        Name                        = "Hostname change on ${DSC Authoring Station Mgmt Cname} leads to Pending Reboot"
        SkipPendingComputerRename   = $false
        SkipCcmClientSDK            = $false
        SkipComponentBasedServicing = $false
        SkipPendingFileRename       = $false
        SkipWindowsUpdate           = $false
        DependsOn                   = [System.String[]]@(
          "[Computer]New Random ComputerName for primordial Unclustered Hyper-V Host"
        )
      }
    }
    #endregion
    #endregion                            

    #region | Essential Directory Structure |
    File $InstanceFolderName {
      DestinationPath = "$MOFs\$InstanceFolderName"
      Force           = $true
      Type            = 'Directory'
      Ensure          = 'Present'
      DependsOn       = [System.String[]]@(
        "[WindowsEventLogChannelThatIsENABLEDforDscTracking]Debug channel for the Microsoft-Windows-Dsc event log provider on localhost"
      )
    }
    ${Dependency x_00_Hadean__PreDocEcyn} = [System.String[]]@(
      "[File]$InstanceFolderName"
    )

    File 'Self-Signed Certs Directory' {
      DestinationPath = ${env:Pre-PKI CertFSOs}
      Force           = $true
      Type            = 'Directory'
      Ensure          = 'Present'
      DependsOn       = ${Dependency x_00_Hadean__PreDocEcyn}
    }
    ${Dependency Self-Signed Certs Directory} = [System.String[]]@(
      "[File]Self-Signed Certs Directory"
    )
    #endregion

    #region | Establish MaxIPs Directory | Write MACs of detected non-USB NICs to .txt file |
    File "Physical Non-Removable PCIe Adapter MACs Directory" {
      DestinationPath = "$Statics\MAC Address Space\Physical Non-Removable PCIe Adapter MACs"
      #Attributes      = @('Hidden')
      Force           = $true
      Type            = 'Directory'
      Ensure          = 'Present'
      DependsOn       = ${Dependency Self-Signed Certs Directory}
    }
    ${Dependency Physical Non-Removable PCIe Adapter MACs Directory} = [System.String[]]@(
      "[File]Physical Non-Removable PCIe Adapter MACs Directory"
    )
    File "MaxIP Directory" {
      DestinationPath = "$Statics\MaxIP\VLANs"
      #Attributes      = @('Hidden')
      Force           = $true
      Type            = 'Directory'
      Ensure          = 'Present'
      DependsOn       = ${Dependency Self-Signed Certs Directory}
    }
    ${Dependency MaxIP Directory} = [System.String[]]@(
      "[File]MaxIP Directory"
    )
    ${Is Physical Non-Removable PCIe Adapter MACs child Directory present at time of MOF compilation} = Test-Path -Path "$Statics\MAC Address Space\Physical Non-Removable PCIe Adapter MACs"
    if (-not ${Is Physical Non-Removable PCIe Adapter MACs child Directory present at time of MOF compilation}) {
      Get-CimInstance -ClassName 'Win32_NetworkAdapter' `
      | Where-Object -FilterScript {
        ($_.PNPDeviceID -cmatch '^PCI\\') -and ($_.Name -cmatch '^Realtek PCIe GbE Family Controller')
      } `
      | ForEach-Object -Process {Get-NetAdapter -InterfaceDescription $_.Name} `
      | Select-Object -ExpandProperty 'MacAddress' -PipelineVariable 'MacAddress' `
      | ForEach-Object -Process {
        $MacAddrNoHyperLowerCase = ($MacAddress -replace '-','').ToLower()
        ${Guid Value} = [System.Guid]::NewGuid().Guid
        File "Write MAC Address to ${Guid Value}.txt File" {
          DestinationPath = "$Statics\MAC Address Space\Physical Non-Removable PCIe Adapter MACs\${Guid Value}.txt"
          #Attributes      = @('Hidden','ReadOnly')
          Attributes      = @('ReadOnly')
          Contents        = $MacAddrNoHyperLowerCase
          Force           = $false
          Type            = 'File'
          Ensure          = 'Present'
          DependsOn       = ${Dependency Physical Non-Removable PCIe Adapter MACs Directory}
        }
      }
    }
    if (${Is Physical Non-Removable PCIe Adapter MACs child Directory present at time of MOF compilation}) {
      $files = Get-ChildItem -Path "$Statics\MAC Address Space\Physical Non-Removable PCIe Adapter MACs" -Filter "*.txt" -File | Sort-Object -Property 'BaseName'
      File "$($files[0].BaseName)" {
        DestinationPath = "$Statics\MAC Address Space\${DSC Authoring Station Mgmt Cname} Virtualized Workloads 0.txt"
        SourcePath = $files[0].FullName
      }
      File "$($files[1].BaseName)" {
        DestinationPath = "$Statics\MAC Address Space\${DSC Authoring Station Mgmt Cname} iSCSI Storage 0.txt"
        SourcePath = $files[1].FullName
      }

      Get-CimInstance -ClassName 'Win32_NetworkAdapter' `
      | Where-Object -FilterScript {
        ($_.PNPDeviceID -cmatch '^PCI\\') -and ($_.Name -notmatch '^Realtek PCIe GbE Family Controller')
      } `
      | ForEach-Object -Process {Get-NetAdapter -InterfaceDescription $_.Name} `
      | Select-Object -ExpandProperty 'MacAddress' -PipelineVariable 'MacAddress' `
      | ForEach-Object -Process {
        $MacAddrNoHyperLowerCase = ($MacAddress -replace '-','').ToLower()

        File "Write MAC Address to txt File" {
          DestinationPath = "$Statics\MAC Address Space\${DSC Authoring Station Mgmt Cname} Administrative Control 0.txt"
          Attributes      = @('ReadOnly')
          Contents        = $MacAddrNoHyperLowerCase
          Force           = $false
          Type            = 'File'
          Ensure          = 'Present'
        }
      }
    }
    #endregion

    #region | Pre-PKI Global Certificate Signer |
    ${Is CertFSOs Directory present at time of MOF compilation} = Test-Path -Path ${env:Pre-PKI CertFSOs}
    if (${Is CertFSOs Directory present at time of MOF compilation}) {
      if (${Is file with new random %ComputerNames% present at time of MOF compilation}) {
        ${New Random ComputerName} = Get-Content -Path "$Statics\CNs\${DSC Authoring Station Mgmt Cname} ComputerName.txt"
        ${Current ComputerName confirmed to match New Random ComputerName} = ${New Random ComputerName} -eq $env:ComputerName
        if (${Current ComputerName confirmed to match New Random ComputerName}) {
          PrePKIGlobalCertificateSignerSequence0 'Pre-PKI Global Certificate Signer' {
            IsSingleInstance            = [System.String]'Yes'
            FriendlyName                = [System.String]'Pre-PKI Global Certificate Signer'
            Ensure                      = [System.String]'Present'
          }
          ${Dependency PrePKIGlobalCertificateSignerSequence0} = [System.String[]]@(
            "[PrePKIGlobalCertificateSignerSequence0]Pre-PKI Global Certificate Signer"
          )
          #region | Document Encryption Certificate for primordial unclustered Hyper-V host |
          ${All Certs in Personal LocalMachine Store} = Get-ChildItem -Path 'Cert:\LocalMachine\My' -Recurse
          ${Pre-PKI Global Certificate Signing Certificate} = ${All Certs in Personal LocalMachine Store} | Where-Object -FilterScript {
            $_.FriendlyName -eq 'Pre-PKI Global Certificate Signer'
          }
          if ($null -ne ${Pre-PKI Global Certificate Signing Certificate}) {
            PrePKIGlobalCodeSignerSequence0 'Pre-PKI Global Code Signer' {
              IsSingleInstance = [System.String]'Yes'
              FriendlyName     = [System.String]'Pre-PKI Global Code Signer'
              Ensure           = [System.String]'Present'
              DependsOn        = ${Dependency PrePKIGlobalCertificateSignerSequence0}
            }
            ${Dependency PrePKIGlobalCodeSignerSequence0} = [System.String[]]@(
              "[PrePKIGlobalCodeSignerSequence0]Pre-PKI Global Code Signer"
            )
            PrePKIGlobalCertificateSignerSequence1 'Pre-PKI Global Certificate Signer' {
              IsSingleInstance = [System.String]'Yes'
              FriendlyName     = [System.String]'Pre-PKI Global Certificate Signer'
              Ensure           = [System.String]'Present'
              DependsOn        = ${Dependency PrePKIGlobalCertificateSignerSequence0}
            }
            ${Dependency PrePKIGlobalCertificateSignerSequence1} = [System.String[]]@(
              "[PrePKIGlobalCertificateSignerSequence1]Pre-PKI Global Certificate Signer"
            )

            # Encrypting the sensitive strings (e.g., passwords) inside of .MOF files:
            ## start msedge.exe 'https://learn.microsoft.com/en-us/powershell/dsc/pull-server/securemof?view=dsc-1.1'
            PrePKIMofPasswordProtectionSequence0 "Encrypt Passwords in MOF for LCM on ${DSC Authoring Station Mgmt Cname}" {
              FriendlyName = [System.String]"Encrypt Passwords in MOF for LCM on ${DSC Authoring Station Mgmt Cname}"
              Ensure       = [System.String]'Present'
              DependsOn    = ${Dependency PrePKIGlobalCertificateSignerSequence0}
            }
            PrePKIEventLogRecordProtectorSequence0 "Encrypt Event Log Records Originating from ${DSC Authoring Station Mgmt Cname}" {
              FriendlyName = [System.String]"Encrypt Event Log Records Originating from ${DSC Authoring Station Mgmt Cname}"
              Ensure       = [System.String]'Present'
              DependsOn    = ${Dependency PrePKIGlobalCertificateSignerSequence0}
            }
            ${Is Global Code Signer Thumbprint Present} = Test-Path -Path "${env:Pre-PKI CertFSOs}\Pre-PKI Global Code Signer.txt"
            if (${Is Global Code Signer Thumbprint Present}) {
              PrePKIGlobalCodeSignerSequence1 'Pre-PKI Global Code Signer' {
                IsSingleInstance = [System.String]'Yes'
                FriendlyName     = [System.String]'Pre-PKI Global Code Signer'
                Ensure           = [System.String]'Present'
                DependsOn        = ${Dependency PrePKIGlobalCodeSignerSequence0}
              }
              ${Dependency PrePKIGlobalCodeSignerSequence1} = [System.String[]]@(
                "[PrePKIGlobalCodeSignerSequence1]Pre-PKI Global Code Signer"
              )
              
              #region | Install Hyper-V if the Global Code Signer has been exported to .cer |
              ${Is Global Code Signer cert exported to file system} = Test-Path -Path "${env:Pre-PKI CertFSOs}\Pre-PKI Global Code Signer.cer"
              if (${Is Global Code Signer cert exported to file system}) {
                xWindowsFeature "Install Hyper-V and only Hyper-V. IncludeAllSubfeature is FALSE" {
                  Name                 = 'Hyper-V'
                  IncludeAllSubfeature = $false
                  LogPath              = "$env:ProgramData\$Name.log"
                  Ensure               = 'Present'
                  DependsOn            = ${Dependency PrePKIGlobalCodeSignerSequence1}
                }
                ${Dependency Installation-HyperV} = [System.String[]]@(
                  "[xWindowsFeature]$('Install Hyper-V and only Hyper-V. IncludeAllSubfeature is FALSE')"
                )
              }
              #endregion
            }
          }
          #endregion
        }
      }
    }
    #endregion
  }
}
$HT = @{
  InstanceName = $InstanceName
  OutputPath   = $lcmHT['OutputPath']
  Verbose      = $true
}

Invoke-Expression -Verbose:$true -Command "$InstanceName @HT"
Publish-DscConfiguration -ComputerName 'localhost' -Path $lcmHT['OutputPath'] -Force -Verbose:$true
Start-DscConfiguration -UseExisting -Force -Wait:$true -Verbose:$true
Start-Sleep 15