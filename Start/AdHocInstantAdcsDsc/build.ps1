#Requires -Version 5.1
#Requires -PSEdition Desktop

param (
  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  ${PSPKI Module Version}
)

${using module PSPKI Here-String} = "using module 'C:\Program Files\WindowsPowerShell\Modules\PSPKI\${PSPKI Module Version}\PSPKI.psm1'"
${enum Ensure Here-String} = 'enum Ensure {Present;Absent}'
${Requires Module PKI 1.0.0.0 Here-String} = "$([System.Char]35)Requires -Modules @{ModuleName='PKI';RequiredVersion='1.0.0.0'}"

<#
  code "C:\Users\lowpr\OneDrive\Synth\AdHocUtilsDsc\0rch\!EditAdHocUtilsDsc.ps1"
#>
<#
  ${Class and Module Here-String Precursor 0} = -join $(
    "using module $([System.Char]39)C:\Program Files\WindowsPowerShell\Modules\PSPKI\%_PSPKI_Version_%\PSPKI.psm1$([System.Char]39)`n"
    "#   using module $([System.Char]39)C:\Program Files\WindowsPowerShell\Modules\xDscDiagnostics\2.8.0\xDscDiagnostics.psm1$([System.Char]39)`n"
    "#   `$PSModuleInfo = Import-Module $([System.Char]39)xDscDiagnostics$([System.Char]39) -Force -Passthru`n"
    "#   `$PSModuleInfo = Import-Module $([System.Char]39)xDscDiagnostics$([System.Char]39) -Force -Passthru`n"
    "`n"
    "enum Ensure {`n"
    "  Present`n"
    "  Absent`n"
    "}`n"
    "`n"
    "# These will eventually # `$modulePath = Join-Path -Path (Split-Path -Path (Split-Path -Path `$PSScriptRoot -Parent) -Parent) -ChildPath $([System.Char]39)Modules$([System.Char]39)`n"
    "# get implemented       # Import-Module -Name (Join-Path -Path `$modulePath -ChildPath (Join-Path -Path $([System.Char]34)$ModName.Common$([System.Char]34) -ChildPath $([System.Char]34)$ModName.Common.psm1$([System.Char]34)))`n"
  )
  ${Class and Module Here-String Precursor 1} = ${Class and Module Here-String Precursor 0} -replace '%_PSPKI_Version_%',$(${Imported Module-PSPKI}.Version.ToString())
  ${Class and Module Here-String} = ${Class and Module Here-String Precursor 1} + "`n" + ${Instant-ADCS-Class-Collection}
#>
<#
  "C:\Users\lowpr\NoSync\dsc modules\ComputerManagementDsc\ComputerManagementDsc\10.0.1\DSCResources\DSC_SmbShare\DSC_SmbShare.psm1"

  $PSScriptR00t = 
  "C:\Users\lowpr\NoSync\dsc modules\ComputerManagementDsc\ComputerManagementDsc\10.0.1\DSCResources\DSC_SmbShare"
  Split-Path -Path $PSScriptR00t -Parent = 
  "C:\Users\lowpr\NoSync\dsc modules\ComputerManagementDsc\ComputerManagementDsc\10.0.1\DSCResources"
  Split-Path -Path (Split-Path -Path $PSScriptR00t -Parent) -Parent = 
  "C:\Users\lowpr\NoSync\dsc modules\ComputerManagementDsc\ComputerManagementDsc\10.0.1"
  Join-Path -Path (Split-Path -Path (Split-Path -Path $PSScriptR00t -Parent) -Parent) -ChildPath 'Modules' = 
  "C:\Users\lowpr\NoSync\dsc modules\ComputerManagementDsc\ComputerManagementDsc\10.0.1\Modules"

  $modulePath = "C:\Users\lowpr\NoSync\dsc modules\ComputerManagementDsc\ComputerManagementDsc\10.0.1\Modules"

  # Import the 'ComputerManagementDsc.Common' module
  Import-Module -Name (
    Join-Path -Path $modulePath -ChildPath (
      Join-Path -Path 'ComputerManagementDsc.Common' -ChildPath 'ComputerManagementDsc.Common.psm1'
    )
  )

  # Import the 'DscResource.Common' module
  Import-Module -Name (
    Join-Path -Path $modulePath -ChildPath 'DscResource.Common'
  )
#>




$FolderFQN = Import-CliXml -Path "$PSScriptRoot\..\..\..\.CommonItems\FolderFQN.clixml"

${DSC Resource Module Name} = 'AdHocInstantAdcsDsc'
${DSC Resource Module Vers} = '0.4.0'
$IndividualDscResourceVersion = '0.0.10'

$path = "$PSScriptRoot\..\..\..\.CommonItems\Authored\AdHocInstantAdcsDsc\${DSC Resource Module Vers}\DSCClassResources"
${DSCClassResources Folder} = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}




$path = "$PSScriptRoot\..\..\..\.CommonItems\Authored\AdHocInstantAdcsDsc"
$folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}

$path = "$PSScriptRoot\..\..\..\.CommonItems\Authored\AdHocInstantAdcsDsc"
$folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}



#   Get-Content -Path "$PSScriptRoot\GlobalCertificateSignerSequence0_PRECURSOR.ps1" -Raw




#     "$PSScriptRoot\..\..\..\.CommonItems\usb0\$FolderFQN\cfg\DSC Resources\Authored for $FolderFQN"