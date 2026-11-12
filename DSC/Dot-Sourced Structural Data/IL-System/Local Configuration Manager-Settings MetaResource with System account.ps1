<# Explanations |
  Microsoft Learn's example generates self-signed certificates (with the EKU of Document Encryption) on 
  each DSC configuration target: 
  start msedge.exe 'https://learn.microsoft.com/en-us/powershell/dsc/pull-server/securemof?view=dsc-1.1'
  NOTE: EKU = 'Enhanced Key Usage' or 'Extended Key Usage'. EKU is one of the appx 20 certificate extensions 
  defined by version 3 of the X.509 standard. 
  
  This project defines a single self-signed certificate that can sign other certificates (the 'pre-PKI 
  Global Certificate Signer') and then generates those 'pre-PKI Global Certificate Signer'-signed cert-
  ificates as they need to be created. Each DSC configuration target has the 'pre-PKI Global Certificate
  Signer' installed at 'Cert:\LocalMachine\Root' and every other certificate is installed to Personal. 
  
  A great many certificates will be installed to Personal. The 'CertificateID' property of the 'Settings'
  meta-resource in the configuration document for the LCM must be the thumbprint of the certificate that 
  decrypts secure strings in the meta.mof file that results when that configuration document is compiled.
  
  So the configuration target computer has some software called the Local Configuration Manager (LCM). The
  configuration target receives a .MOF file from another computer. When an environment implements DSC in 
  "Pull Mode", the configuration target computer takes the initiative to obtain the .MOF file. Usually the 
  .MOF file is downloaded from an IIS-enabled "pull server" and in very rare cases an SMB share could provide
  the .MOF file. When an environment implements DSC in "Push Mode", this means that some other machine (that 
  is not the configuration target) performs the work to ensure the .MOF file is on the configuration target 
  computer. 
  
  This project will demarcate the computer on which the configuration document is compiled to bring the .MOF 
  file into existence as the "DSC Authoring Station". During this project's Push Mode phase, the DSC Authoring 
  Station will also act as the push server, and transmit the .MOF file to the DSC configuration target via an 
  HTTPS-secured PowerShell Remoting session. 
  
  DSC configurations distributed via Push Mode will construct a computer demarcated as the "DSC Web Server", 
  which will eventually act as the "pull server" for this project. 

  .MOF files are always CREATED on the DSC Authoring Station and .MOF files are always ENACTED by the Local
  Configuration Manager within the DSC configuration target computer. 

  Two important items: 
  1) Technical professionals might sometimes say that the Local Configuration Manager is what "compiles the 
  MOF". Strictly speaking, that statement is not correct. The PowerShell function titled 'Configuration' is 
  the mechanism that compiles the configuration document, and the end-result of compiling the configuration 
  document is a Managed Object Format file-system object whose extension is .mof. The Local Configuration 
  Manager is the component of DSC that reads the instructions inside the .MOF file (which were written by the
  'Configuration' function) and then establishes those specific details that should be present on the config-
  uration target computer. Stated differently, the LCM "enacts the MOF". 

  2) A .MOF file can be created + enacted on the same computer. The very first .ps1 file with structural DSC
  data (the Hadean configuration document) is an example of the DSC Authoring Station producing and enacting 
  its very own .MOF file! 
#>

Settings {
  ActionAfterReboot              = [System.String]$Node.'Local Configuration Manager-PUSH MODE'.Settings.ActionAfterReboot
  AllowModuleOverwrite           = [System.Boolean]$Node.'Local Configuration Manager-PUSH MODE'.Settings.AllowModuleOverwrite
  CertificateID                  = [System.String]$Node.'Local Configuration Manager-PUSH MODE'.Settings.CertificateID
  ConfigurationMode              = [System.String]$Node.'Local Configuration Manager-PUSH MODE'.Settings.ConfigurationMode
  ConfigurationModeFrequencyMins = [System.UInt32]$Node.'Local Configuration Manager-PUSH MODE'.Settings.ConfigurationModeFrequencyMins
  DebugMode                      = [System.String[]]$Node.'Local Configuration Manager-PUSH MODE'.Settings.DebugMode
  RefreshFrequencyMins           = [System.UInt32]$Node.'Local Configuration Manager-PUSH MODE'.Settings.RefreshFrequencyMins
  RebootNodeIfNeeded             = [System.Boolean]$Node.'Local Configuration Manager-PUSH MODE'.Settings.RebootNodeIfNeeded
  RefreshMode                    = [System.String]$Node.'Local Configuration Manager-PUSH MODE'.Settings.RefreshMode
  StatusRetentionTimeInDays      = [System.UInt32]$Node.'Local Configuration Manager-PUSH MODE'.Settings.StatusRetentionTimeInDays
}

<# Properties of the in-box 'LocalConfigurationManager' DSC resource provided by the 'PSDesiredStateConfiguration' module |
  Get-DscResourceProperty.ps1 -ModuleName 'PSDesiredStateConfiguration' -ResourceName 'LocalConfigurationManager' | clip.exe

  Name                           IsKey Mandatory TypeConstraint                     Values
  ----                           ----- --------- --------------                     ------
  ActionAfterReboot              False     False String                             {ContinueConfiguration | StopConfiguration}
  AllowModuleOverwrite           False     False Boolean                            {}
  CertificateID                  False     False String                             {}
  ConfigurationDownloadManagers  False     False OMI_ConfigurationDownloadManager[] {}
  ConfigurationID                False     False String                             {}
  ConfigurationMode              False     False String                             {ApplyOnly | ApplyAndMonitor | ApplyAndAutoCorrect | MonitorOnly}
  ConfigurationModeFrequencyMins False     False UInt32                             {}
  DebugMode                      False     False StringArray                        {None | ForceModuleImport | All}
  DownloadManagerCustomData      False     False MSFT_KeyValuePair[]                {}
  DownloadManagerName            False     False String                             {}
  MaximumDownloadSizeMB          False     False UInt32                             {}
  PartialConfigurations          False     False MSFT_PartialConfiguration[]        {}
  RebootNodeIfNeeded             False     False Boolean                            {}
  RefreshFrequencyMins           False     False UInt32                             {}
  RefreshMode                    False     False String                             {Push | Pull | Disabled}
  ReportManagers                 False     False OMI_ReportManager[]                {}
  ResourceModuleManagers         False     False OMI_ResourceModuleManager[]        {}
  SignatureValidationPolicy      False     False String                             {}
  SignatureValidations           False     False MSFT_SignatureValidation[]         {}
  StatusRetentionTimeInDays      False     False UInt32                             {}
  Credentia1                     False     False MSFT_Credential                    {}
#>