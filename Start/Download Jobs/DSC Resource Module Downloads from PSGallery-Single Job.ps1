#Requires -Version 7.4
#Requires -PSEdition Core


$FolderFQN = Import-CliXml -Path "$PSScriptRoot\..\..\..\.CommonItems\FolderFQN.clixml"
$ModuleSavePath = "$PSScriptRoot\..\..\..\.CommonItems\usb0\$FolderFQN\cfg\DSC Resources\PowerShell Gallery"

$ArgumentList = @(
  $ModuleSavePath
)

Start-Job -Name 'Prepare .Zip files of DSC Resource modules from PSGallery' -ArgumentList $ArgumentList -ScriptBlock {
  $ModuleSavePath = $args[0]
  ${DSC Resource Module Names} = @(
    #'ActiveDirectoryCSDsc'
    'ActiveDirectoryDsc'
    #'cDhcpServerDynamicUpdate'
    'CertificateDsc'
    #'cHyper-V'
    'ComputerManagementDsc'
    #'DhcpServerDsc'
    #'DnsServerDsc'
    #'GroupPolicyDsc'
    #'HyperVDsc'
    #'NetworkingDsc'
    #'StorageDsc'
    #'UpdateServicesDsc'
    #'WebAdministrationDsc'
    #'WmiNamespaceSecurity'
    #'WSManDsc'
    #'xCIMSecurity'
    #'xComputerManagement'
    #'xPendingReboot'
    #'xPSDesiredStateConfiguration'
  )

  ${DSC Resource Module Names} | Select-Object -PipelineVariable 'DSC Resource Module Name' | ForEach-Object -Process {

    $IsZipPresent = Test-Path -Path "$ModuleSavePath\${DSC Resource Module Name}.zip"

    if (-not $IsZipPresent) {
      Save-Module -Name ${DSC Resource Module Name} -Path $ModuleSavePath -Repository 'PSGallery' -AllowPrerelease
      Start-Sleep 10
      Compress-Archive -Path "$ModuleSavePath\${DSC Resource Module Name}" -DestinationPath "$ModuleSavePath\${DSC Resource Module Name}.zip"
      Remove-Item -Path "$ModuleSavePath\${DSC Resource Module Name}" -Recurse -Force
    }




  }






}