#Requires -Version 7.4
#Requires -PSEdition Core


$FolderFQN = Import-CliXml -Path "$PSScriptRoot\..\..\..\.CommonItems\FolderFQN.clixml"
$ModuleSavePath = "$PSScriptRoot\..\..\..\.CommonItems\usb0\$FolderFQN\cfg\installs\PowerShell 5.1\Modules\DSC Resources"
#$ModuleSavePath = "$env:UserProfile\GitHub\CarlSimonIT\.CommonItems\usb0\Instant-ADCS\cfg\installs\PowerShell 5.1\Modules\DSC Resources"
${DSC Resource Module Names} = @(
  'ActiveDirectoryCSDsc'
  'ActiveDirectoryDsc'
  'cDhcpServerDynamicUpdate'
  'CertificateDsc'
  'cHyper-V'
  'ComputerManagementDsc'
  'DhcpServerDsc'
  'DnsServerDsc'
  'GroupPolicyDsc'
  'HyperVDsc'
  'NetworkingDsc'
  'StorageDsc'
  'UpdateServicesDsc'
  'WebAdministrationDsc'
  'WmiNamespaceSecurity'
  'WSManDsc'
  'xCIMSecurity'
  'xComputerManagement'
  'xPendingReboot'
  'xPSDesiredStateConfiguration'
)

${DSC Resource Module Names} | Select-Object -PipelineVariable 'DSC Resource Module Name' | ForEach-Object -Process {
  # Only launch the Job based on the result of a test for the absence of the corresponding archive file
  $IsZipPresent = Test-Path -Path "$ModuleSavePath\${DSC Resource Module Name}.zip"
  if (-not $IsZipPresent) {
    $JobName = "Save-Compress-Remove ${DSC Resource Module Name}"

    $ArgumentList = $(
      $ModuleSavePath
      ${DSC Resource Module Name}
    )

    Start-Job -Name $JobName -ArgumentList $ArgumentList -ScriptBlock {
      $ModuleSavePath = $args[0]
      ${DSC Resource Module Name} = $args[1]

      Save-Module -Name ${DSC Resource Module Name} -Path $ModuleSavePath -Repository 'PSGallery' -AllowPrerelease
      Compress-Archive -Path "$ModuleSavePath\${DSC Resource Module Name}" -DestinationPath "$ModuleSavePath\${DSC Resource Module Name}.zip"
      Remove-Item -Path "$ModuleSavePath\${DSC Resource Module Name}" -Recurse -Force
    } | Out-Null
  }
}




