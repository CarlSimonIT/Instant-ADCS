#Requires -Version 5.1
#Requires -PSEdition Desktop

param (
  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  ${PSPKI Module Version}
)

${using module PSPKI Here-String} = "using module 'C:\Program Files\WindowsPowerShell\Modules\PSPKI\${PSPKI Module Version}\PSPKI.psm1'" + "`n"
${using module PKI Here-String} = "using module PKI" + "`n"
${using namespace PKIClient Here-String} = "using namespace Microsoft.CertificateServices.PKIClient" + "`n"
${using namespace CertificateServices Here-String} = "using namespace Microsoft.CertificateServices" + "`n"
${Import Module PKI 1.0.0.0 Here-String} = "`$PSModuleInfo = Import-Module -Name 'PKI' -PassThru -Force" + "`n"
${enum Ensure Here-String} = 'enum Ensure {Present;Absent}' + "`n"
${Requires Module PKI 1.0.0.0 Here-String} = "$([System.Char]35)Requires -Modules @{ModuleName='PKI';RequiredVersion='1.0.0.0'}" + "`n"
${Requires Module xDscDiagnostics 2.8.0 Here-String} = "$([System.Char]35)Requires -Modules @{ModuleName='xDscDiagnostics';RequiredVersion='2.8.0'}" + "`n"
<#
  code "$env:OneDrive\Synth\PowerShellGet\PSModule.psm1"
  Microsoft.PowerShell.Management\Join-Path
#>
#. "C:\Users\lowpr\GitHub\InterM3d\mc3\CarlSimonIT\Instant-ADCS\output\Instant-ADCS\usb1\Instant-ADCS\Base\5.1\Certification Authority CommonNames.ps1"
# code "C:\Users\lowpr\GitHub\InterM3d\mc3\CarlSimonIT\Instant-ADCS\output\Instant-ADCS\usb1\Instant-ADCS\Base\5.1\profile.ps1"

$FolderFQN = Import-CliXml -Path "$PSScriptRoot\..\..\..\.CommonItems\FolderFQN.clixml"
. "$PSScriptRoot\..\..\..\$FolderFQN\output\$FolderFQN\usb1\$FolderFQN\Base\5.1\PKI Misc.ps1"
. "$PSScriptRoot\..\..\..\$FolderFQN\output\$FolderFQN\usb1\$FolderFQN\Base\5.1\Important Variables.ps1"

#"C:\Users\lowpr\GitHub\InterM3d\mc3\CarlSimonIT\Instant-ADCS\Base\5.1\Static\Type Accelerator Instance.ps1"
#"C:\Users\lowpr\GitHub\InterM3d\mc3\CarlSimonIT\Instant-ADCS\Base\5.1\Precursors\Certification Authority CommonNames Precursor.ps1"

${DSC Resource Module Name} = 'AdHocInstantAdcsDsc'
${DSC Resource Module Vers} = Get-Variable -Name "${DSC Resource Module Name} Version" | Select-Object -ExpandProperty 'Value'

$path = "$PSScriptRoot\..\..\..\.CommonItems\Authored\${DSC Resource Module Name}\${DSC Resource Module Vers}\DSCClassResources"
${DSCClassResources Folder} = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}

#   "$PSScriptRoot\..\..\..\.CommonItems\usb0\$FolderFQN\cfg\DSC Resources\Authored for $FolderFQN"

#region | Test() Set() Get() Explained |
${Get Explained Here-String Precursor} = $(
  "  "
  "  <#"
  "    Get() method returns a hashtable whose key-value pairs are defined by the "
  "    current real-world state of the resource instance. "
  "    Not the desired state of the resource instance. "
  "    The Get() method you write must accept as input parameters those properties of the"
  "    resource instance that have either the 'Key' or 'Mandatory' attributes."
  "    Object returned by Get() is a hashtable whose key-value pairs are the"
  "    'Key' and 'Mandatory' properties of the DETECTED resource instance."
  "    Stated differently, the Get() method returns an object instance of type"
  "    'System.Collections.Hashtable' that represents real-world state of the resource"
  "    instance being evaluated."
  "    Confusing the Get() and Test() methods is an easy mistake to make."
  "  #>`n"
) -join "`n"
${Test Explained Here-String Precursor} = $(
  "  "
  "  <# Conceptualize the Test() method as consisting of 3 sub-phases |"
  "    The LCM runs the code inside Test() to decide whether a configuration enactment must be undertaken."
  "    "
  "    >> Test() Subphase A: Performs the work to determine the real-world state of an object"
  "    which corresponds to the '%_Authored DSC Resource Name_%' DSC Resource instance."
  "    Sometimes Test() Subphase A is complete after quickly determining that absolutely no"
  "    indication of a real-world object corresponding to that exact specific DSC Resource instance"
  "    exists."
  "    Other times, Test() Subphase A is complete after determining that a real-world object with"
  "    that name does indeed exist, but the properties of the detected real-world object are not in"
  "    perfect alignment with the properties of a DESIRED instance of that exact specific DSC"
  "    Resource instance."
  "    "
  "    >> Test() Subphase B: Realize that there's a difference between the DESIRED PROPERTIES of"
  "    an exact specific DSC Resource instance... and the DESIRED STATE of an exact specific"
  "    DSC Resource instance. For example, the desired properties of a DSC Resource instance of"
  "    type NtfsFile could include a certain path in the directory, and a certain set of attributes"
  "    on that file, and a specific string within that file. Those items could define the desired"
  "    PROPERTIES of an exact specific DSC Resource instance."
  "    Defining the desired STATE of a real-world entity in a computer requires an additional"
  "    virtual property to signal whether that real-world entity (represented by that exact specific"
  "    DSC Resource instance) should be PRESENT or ABSENT."
  "    Indicate whether that exact specific real-world entity in the computer should be present or"
  "    absent by virtually attaching the 'Ensure' virtual property to that exact specific real-world"
  "    entity. The DSC environmental data (i.e., `$ConfigurationData) should provide a value"
  "    to the Ensure property of each and every single one of the DSC Resource instances that"
  "    the LCM is tasked with configuring."
  "    The definition of an object's DESIRED STATE is incomplete if a value for the Ensure property"
  "    is not provided or implied. For this reason, the DSC Resources that have been custom-authored"
  "    for this project will always have the 'Mandatory' attribute on the Ensure property."
  "    Test() Subphase B accepts as input the observed real-world state (detected by Test() Subphase"
  "    A) and the value for Ensure (provided by the `$ConfigurationData variable.)"
  "    Next, Test() Subphase B applies the custom logic written by the module author to assess whether"
  "    things are fine the way they are, or whether something needs to change."
  "    "
  "    >> Test() Subphase C: If Test() Subphase B has decided that things are fine the way they are,"
  "    and therefore the Set() method does not need to be called, and that nothing needs to change,"
  "    Test() Subphase C emits an object instance of type [System.Boolean] with value `$true."
  "    On the other hand, if Test() Subphase B has assessed that exact specific DSC Resource instance"
  "    under evaluation is NOT perfectly congruent with the detected observed real-world state of an"
  "    object in the computer, Test() Subphase C returns `$false, thereby launching the Set() method."
  "  #>`n"
) -join "`n"
${Set Explained Here-String Precursor} = $(
  "  "
  "  <#"
  "    Set() method"
  "    "
  "    "
  "    "
  "  #>`n"
) -join "`n"
#endregion

#     . "C:\Users\lowpr\GitHub\InterM3d\mc3\CarlSimonIT\Instant-ADCS\output\Instant-ADCS\usb1\Instant-ADCS\Base\5.1\Lightweight Functions.ps1"
#     [System.String]$(Call-VersVar) | Set-Clipboard
#     $(Call-DateVar) | Set-Clipboard

$_Var_Name = 'NestedModules'
try {Clear-Variable -Name $_Var_Name -ErrorAction 'Stop'} catch {New-Variable -Name $_Var_Name -Value $null}
$_Var_Name = 'DscResourcesToExport'
try {Clear-Variable -Name $_Var_Name -ErrorAction 'Stop'} catch {New-Variable -Name $_Var_Name -Value $null}

$(${Authored DSC Resource Name} = 'PrePKIGlobalCertificateSignerSequence0'; $IndividualDscResourceVersion = '2026.10.25.1652';
  $Path = "$PSScriptRoot\${Authored DSC Resource Name} Here-String Unrefined Precursor.ps1"
  ${Authored Here-String Unrefined Precursor} = Get-Content -Path $Path -Raw
  #region | Adjusted Get/Test/Set explanation here-strings applied to Unrefined Precursor result in Precursor |
  ${Get Explained Here-String}  = ${Get Explained Here-String Precursor}  -replace '%_Authored DSC Resource Name_%',  ${Authored DSC Resource Name}
  ${Test Explained Here-String} = ${Test Explained Here-String Precursor} -replace '%_Authored DSC Resource Name_%',  ${Authored DSC Resource Name}
  ${Set Explained Here-String}  = ${Set Explained Here-String Precursor}  -replace '%_Authored DSC Resource Name_%',  ${Authored DSC Resource Name}

  ${Authored Here-String Precursor} = ${Authored Here-String Unrefined Precursor} `
    -replace '#%_Get Explained Here-String_%',${Get Explained Here-String} `
    -replace '#%_Test Explained Here-String_%',${Test Explained Here-String} `
    -replace '#%_Set Explained Here-String_%',${Set Explained Here-String}
  #endregion

  ${Authored Here-String} = $(
    #${using module PKI Here-String}
    #${Requires Module PKI 1.0.0.0 Here-String}
    #${Import Module PKI 1.0.0.0 Here-String}
    ${enum Ensure Here-String}
    ${Authored Here-String Precursor}
  ) -join ''

  # Define the path of the parent directory for this class-based DSC Resource's module file.
  $path = "$PSScriptRoot\..\..\..\.CommonItems\Authored\${DSC Resource Module Name}\${DSC Resource Module Vers}\DSCClassResources\${Authored DSC Resource Name}"
  $folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}

  # Define the module file of this class-based DSC Resource.
  Set-Content -Path "$folder\${Authored DSC Resource Name}.psm1" -Value (${Authored Here-String})

  # Define the module manifest file of this class-based DSC Resource
  $HT = @{
    Path                 = "$folder\${Authored DSC Resource Name}.psd1"
    RootModule           = "${Authored DSC Resource Name}.psm1"
    Guid                 = (New-Guid).Guid
    Author               = 'CarlSimonIT'
    Company              = 'CarlSimonIT'
    PowerShellVersion    = '5.1'
    ModuleVersion        = $IndividualDscResourceVersion
    DscResourcesToExport = ${Authored DSC Resource Name}
    Verbose              = $true
  }
  New-ModuleManifest @HT

  $NestedModules += @("DSCClassResources\${Authored DSC Resource Name}\${Authored DSC Resource Name}.psd1")
  $DscResourcesToExport += @(${Authored DSC Resource Name})
)
#     [System.String]::Format('{0:yyyy}.{0:MM}.{0:dd}.{0:HH}{0:mm}',[System.DateTime]::Now) | Set-Clipboard
$(${Authored DSC Resource Name} = 'WindowsEventLogChannelThatIsENABLEDforDscTracking'; $IndividualDscResourceVersion = '2026.10.25.2150';
  $Path = "$PSScriptRoot\${Authored DSC Resource Name} Here-String Unrefined Precursor.ps1"
  ${Authored Here-String Unrefined Precursor} = Get-Content -Path $Path -Raw
  #region | Adjusted Get/Test/Set explanation here-strings applied to Unrefined Precursor result in Precursor |
  ${Get Explained Here-String}  = ${Get Explained Here-String Precursor}  -replace '%_Authored DSC Resource Name_%',  ${Authored DSC Resource Name}
  ${Test Explained Here-String} = ${Test Explained Here-String Precursor} -replace '%_Authored DSC Resource Name_%',  ${Authored DSC Resource Name}
  ${Set Explained Here-String}  = ${Set Explained Here-String Precursor}  -replace '%_Authored DSC Resource Name_%',  ${Authored DSC Resource Name}

  ${Authored Here-String Precursor} = ${Authored Here-String Unrefined Precursor} `
    -replace '#%_Get Explained Here-String_%',${Get Explained Here-String} `
    -replace '#%_Test Explained Here-String_%',${Test Explained Here-String} `
    -replace '#%_Set Explained Here-String_%',${Set Explained Here-String}
  #endregion

  ${Authored Here-String} = $(
    ${Requires Module xDscDiagnostics 2.8.0 Here-String}
    ${enum Ensure Here-String}
    ${Authored Here-String Precursor}
  ) -join "`n"

  # Define the path of the parent directory for this class-based DSC Resource's module file.
  $path = "$PSScriptRoot\..\..\..\.CommonItems\Authored\${DSC Resource Module Name}\${DSC Resource Module Vers}\DSCClassResources\${Authored DSC Resource Name}"
  $folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}

  # Define the module file of this class-based DSC Resource.
  Set-Content -Path "$folder\${Authored DSC Resource Name}.psm1" -Value (${Authored Here-String})

  # Define the module manifest file of this class-based DSC Resource
  $HT = @{
    Path                 = "$folder\${Authored DSC Resource Name}.psd1"
    RootModule           = "${Authored DSC Resource Name}.psm1"
    Guid                 = (New-Guid).Guid
    Author               = 'CarlSimonIT'
    Company              = 'CarlSimonIT'
    PowerShellVersion    = '5.1'
    ModuleVersion        = $IndividualDscResourceVersion
    DscResourcesToExport = ${Authored DSC Resource Name}
    Verbose              = $true
  }
  New-ModuleManifest @HT

  $NestedModules += @("DSCClassResources\${Authored DSC Resource Name}\${Authored DSC Resource Name}.psd1")
  $DscResourcesToExport += @(${Authored DSC Resource Name})
)
#     [System.String]::Format('{0:yyyy}.{0:MM}.{0:dd}.{0:HH}{0:mm}',[System.DateTime]::Now) | Set-Clipboard
$(${Authored DSC Resource Name} = 'PrePKIGlobalCodeSignerSequence0'; $IndividualDscResourceVersion = '2026.10.26.0921';
  $Path = "$PSScriptRoot\${Authored DSC Resource Name} Here-String Unrefined Precursor.ps1"
  ${Authored Here-String Unrefined Precursor} = Get-Content -Path $Path -Raw
  #region | Adjusted Get/Test/Set explanation here-strings applied to Unrefined Precursor result in Precursor |
  ${Get Explained Here-String}  = ${Get Explained Here-String Precursor}  -replace '%_Authored DSC Resource Name_%',  ${Authored DSC Resource Name}
  ${Test Explained Here-String} = ${Test Explained Here-String Precursor} -replace '%_Authored DSC Resource Name_%',  ${Authored DSC Resource Name}
  ${Set Explained Here-String}  = ${Set Explained Here-String Precursor}  -replace '%_Authored DSC Resource Name_%',  ${Authored DSC Resource Name}

  ${Authored Here-String Precursor} = ${Authored Here-String Unrefined Precursor} `
    -replace '#%_Get Explained Here-String_%',${Get Explained Here-String} `
    -replace '#%_Test Explained Here-String_%',${Test Explained Here-String} `
    -replace '#%_Set Explained Here-String_%',${Set Explained Here-String}
  #endregion

  ${Authored Here-String} = $(
    ${enum Ensure Here-String}
    ${Authored Here-String Precursor}
  ) -join "`n"

  # Define the path of the parent directory for this class-based DSC Resource's module file.
  $path = "$PSScriptRoot\..\..\..\.CommonItems\Authored\${DSC Resource Module Name}\${DSC Resource Module Vers}\DSCClassResources\${Authored DSC Resource Name}"
  $folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}

  # Define the module file of this class-based DSC Resource.
  Set-Content -Path "$folder\${Authored DSC Resource Name}.psm1" -Value (${Authored Here-String})

  # Define the module manifest file of this class-based DSC Resource
  $HT = @{
    Path                 = "$folder\${Authored DSC Resource Name}.psd1"
    RootModule           = "${Authored DSC Resource Name}.psm1"
    Guid                 = (New-Guid).Guid
    Author               = 'CarlSimonIT'
    Company              = 'CarlSimonIT'
    PowerShellVersion    = '5.1'
    ModuleVersion        = $IndividualDscResourceVersion
    DscResourcesToExport = ${Authored DSC Resource Name}
    Verbose              = $true
  }
  New-ModuleManifest @HT

  $NestedModules += @("DSCClassResources\${Authored DSC Resource Name}\${Authored DSC Resource Name}.psd1")
  $DscResourcesToExport += @(${Authored DSC Resource Name})
)
#     [System.String]::Format('{0:yyyy}.{0:MM}.{0:dd}.{0:HH}{0:mm}',[System.DateTime]::Now) | Set-Clipboard
$(${Authored DSC Resource Name} = 'PrePKIGlobalCertificateSignerSequence1'; $IndividualDscResourceVersion = '2026.10.26.1400';
  $Path = "$PSScriptRoot\${Authored DSC Resource Name} Here-String Unrefined Precursor.ps1"
  ${Authored Here-String Unrefined Precursor} = Get-Content -Path $Path -Raw
  #region | Adjusted Get/Test/Set explanation here-strings applied to Unrefined Precursor result in Precursor |
  ${Get Explained Here-String}  = ${Get Explained Here-String Precursor}  -replace '%_Authored DSC Resource Name_%',  ${Authored DSC Resource Name}
  ${Test Explained Here-String} = ${Test Explained Here-String Precursor} -replace '%_Authored DSC Resource Name_%',  ${Authored DSC Resource Name}
  ${Set Explained Here-String}  = ${Set Explained Here-String Precursor}  -replace '%_Authored DSC Resource Name_%',  ${Authored DSC Resource Name}

  ${Authored Here-String Precursor} = ${Authored Here-String Unrefined Precursor} `
    -replace '#%_Get Explained Here-String_%',${Get Explained Here-String} `
    -replace '#%_Test Explained Here-String_%',${Test Explained Here-String} `
    -replace '#%_Set Explained Here-String_%',${Set Explained Here-String}
  #endregion

  ${Authored Here-String} = $(
    ${enum Ensure Here-String}
    ${Authored Here-String Precursor}
  ) -join "`n"

  # Define the path of the parent directory for this class-based DSC Resource's module file.
  $path = "$PSScriptRoot\..\..\..\.CommonItems\Authored\${DSC Resource Module Name}\${DSC Resource Module Vers}\DSCClassResources\${Authored DSC Resource Name}"
  $folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}

  # Define the module file of this class-based DSC Resource.
  Set-Content -Path "$folder\${Authored DSC Resource Name}.psm1" -Value (${Authored Here-String})

  # Define the module manifest file of this class-based DSC Resource
  $HT = @{
    Path                 = "$folder\${Authored DSC Resource Name}.psd1"
    RootModule           = "${Authored DSC Resource Name}.psm1"
    Guid                 = (New-Guid).Guid
    Author               = 'CarlSimonIT'
    Company              = 'CarlSimonIT'
    PowerShellVersion    = '5.1'
    ModuleVersion        = $IndividualDscResourceVersion
    DscResourcesToExport = ${Authored DSC Resource Name}
    Verbose              = $true
  }
  New-ModuleManifest @HT

  $NestedModules += @("DSCClassResources\${Authored DSC Resource Name}\${Authored DSC Resource Name}.psd1")
  $DscResourcesToExport += @(${Authored DSC Resource Name})
)
#     [System.String]::Format('{0:yyyy}.{0:MM}.{0:dd}.{0:HH}{0:mm}',[System.DateTime]::Now) | Set-Clipboard
$(${Authored DSC Resource Name} = 'PrePKIMofPasswordProtectionSequence0'; $IndividualDscResourceVersion = '2026.10.26.1541';
  $Path = "$PSScriptRoot\${Authored DSC Resource Name} Here-String Unrefined Precursor.ps1"
  ${Authored Here-String Unrefined Precursor} = Get-Content -Path $Path -Raw
  #region | Adjusted Get/Test/Set explanation here-strings applied to Unrefined Precursor result in Precursor |
  ${Get Explained Here-String}  = ${Get Explained Here-String Precursor}  -replace '%_Authored DSC Resource Name_%',  ${Authored DSC Resource Name}
  ${Test Explained Here-String} = ${Test Explained Here-String Precursor} -replace '%_Authored DSC Resource Name_%',  ${Authored DSC Resource Name}
  ${Set Explained Here-String}  = ${Set Explained Here-String Precursor}  -replace '%_Authored DSC Resource Name_%',  ${Authored DSC Resource Name}

  ${Authored Here-String Precursor} = ${Authored Here-String Unrefined Precursor} `
    -replace '#%_Get Explained Here-String_%',${Get Explained Here-String} `
    -replace '#%_Test Explained Here-String_%',${Test Explained Here-String} `
    -replace '#%_Set Explained Here-String_%',${Set Explained Here-String}
  #endregion

  ${Authored Here-String} = $(
    ${enum Ensure Here-String}
    ${Authored Here-String Precursor}
  ) -join "`n"

  # Define the path of the parent directory for this class-based DSC Resource's module file.
  $path = "$PSScriptRoot\..\..\..\.CommonItems\Authored\${DSC Resource Module Name}\${DSC Resource Module Vers}\DSCClassResources\${Authored DSC Resource Name}"
  $folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}

  # Define the module file of this class-based DSC Resource.
  Set-Content -Path "$folder\${Authored DSC Resource Name}.psm1" -Value (${Authored Here-String})

  # Define the module manifest file of this class-based DSC Resource
  $HT = @{
    Path                 = "$folder\${Authored DSC Resource Name}.psd1"
    RootModule           = "${Authored DSC Resource Name}.psm1"
    Guid                 = (New-Guid).Guid
    Author               = 'CarlSimonIT'
    Company              = 'CarlSimonIT'
    PowerShellVersion    = '5.1'
    ModuleVersion        = $IndividualDscResourceVersion
    DscResourcesToExport = ${Authored DSC Resource Name}
    Verbose              = $true
  }
  New-ModuleManifest @HT

  $NestedModules += @("DSCClassResources\${Authored DSC Resource Name}\${Authored DSC Resource Name}.psd1")
  $DscResourcesToExport += @(${Authored DSC Resource Name})
)
#     [System.String]::Format('{0:yyyy}.{0:MM}.{0:dd}.{0:HH}{0:mm}',[System.DateTime]::Now) | Set-Clipboard
$(${Authored DSC Resource Name} = 'PrePKIEventLogRecordProtectorSequence0'; $IndividualDscResourceVersion = '2026.10.28.0920';
  $Path = "$PSScriptRoot\${Authored DSC Resource Name} Here-String Unrefined Precursor.ps1"
  ${Authored Here-String Unrefined Precursor} = Get-Content -Path $Path -Raw
  #region | Adjusted Get/Test/Set explanation here-strings applied to Unrefined Precursor result in Precursor |
  ${Get Explained Here-String}  = ${Get Explained Here-String Precursor}  -replace '%_Authored DSC Resource Name_%',  ${Authored DSC Resource Name}
  ${Test Explained Here-String} = ${Test Explained Here-String Precursor} -replace '%_Authored DSC Resource Name_%',  ${Authored DSC Resource Name}
  ${Set Explained Here-String}  = ${Set Explained Here-String Precursor}  -replace '%_Authored DSC Resource Name_%',  ${Authored DSC Resource Name}

  ${Authored Here-String Precursor} = ${Authored Here-String Unrefined Precursor} `
    -replace '#%_Get Explained Here-String_%',${Get Explained Here-String} `
    -replace '#%_Test Explained Here-String_%',${Test Explained Here-String} `
    -replace '#%_Set Explained Here-String_%',${Set Explained Here-String}
  #endregion

  ${Authored Here-String} = $(
    ${enum Ensure Here-String}
    ${Authored Here-String Precursor}
  ) -join "`n"

  # Define the path of the parent directory for this class-based DSC Resource's module file.
  $path = "$PSScriptRoot\..\..\..\.CommonItems\Authored\${DSC Resource Module Name}\${DSC Resource Module Vers}\DSCClassResources\${Authored DSC Resource Name}"
  $folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}

  # Define the module file of this class-based DSC Resource.
  Set-Content -Path "$folder\${Authored DSC Resource Name}.psm1" -Value (${Authored Here-String})

  # Define the module manifest file of this class-based DSC Resource
  $HT = @{
    Path                 = "$folder\${Authored DSC Resource Name}.psd1"
    RootModule           = "${Authored DSC Resource Name}.psm1"
    Guid                 = (New-Guid).Guid
    Author               = 'CarlSimonIT'
    Company              = 'CarlSimonIT'
    PowerShellVersion    = '5.1'
    ModuleVersion        = $IndividualDscResourceVersion
    DscResourcesToExport = ${Authored DSC Resource Name}
    Verbose              = $true
  }
  New-ModuleManifest @HT

  $NestedModules += @("DSCClassResources\${Authored DSC Resource Name}\${Authored DSC Resource Name}.psd1")
  $DscResourcesToExport += @(${Authored DSC Resource Name})
)

$InputHT = @{
  Path                 = "$PSScriptRoot\..\..\..\.CommonItems\Authored\${DSC Resource Module Name}\${DSC Resource Module Vers}\${DSC Resource Module Name}.psd1"
  NestedModules        = $NestedModules
  Guid                 = [System.Guid]::NewGuid().Guid
  Author               = 'CarlSimonIT'
  Company              = 'CarlSimonIT'
  PowerShellVersion    = '5.1'
  ModuleVersion        = ${DSC Resource Module Vers}
  Description          = "Class-based DSC Resources specifically for the $FolderFQN project. ${DSC Resource Module Name} is not a general-purpose module."
  DscResourcesToExport = $DscResourcesToExport
  Verbose              = $true
}
New-ModuleManifest @InputHT
Test-ModuleManifest -Path $InputHT['Path'] | Format-List -Property '*'

. "$PSScriptRoot\..\..\output\$FolderFQN\usb1\$FolderFQN\Base\5.1\External Storage Media Drive Letters.ps1"
$path = [System.IO.FileInfo]"$PSScriptRoot\..\..\..\.CommonItems\usb0\$FolderFQN\cfg\DSC Resources\Authored for $FolderFQN\${DSC Resource Module Name}.zip"
$IsPresent = Test-Path -Path $path.FullName
if ($IsPresent) {Remove-Item -Path $path.FullName}
Compress-Archive -Path "$PSScriptRoot\..\..\..\.CommonItems\Authored\${DSC Resource Module Name}" -Destination $path.FullName -Force -Verbose

Copy-Item -Path $path.FullName -Destination "$usb0\$FolderFQN\cfg\DSC Resources\Authored for $FolderFQN\${DSC Resource Module Name}.zip" -Force


