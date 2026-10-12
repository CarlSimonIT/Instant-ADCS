#Requires -Version 5.1
#Requires -PSEdition Desktop

$PSModuleInfo = Import-Module 'PowerShellGet' -Force -PassThru

${DSC Resource module Save Path} = Import-CliXml -Path "$PSScriptRoot\..\..\..\.CommonItems\DSC Resource module Save Path.clixml"
${DSC Resource Module Names} = Import-CliXml -Path "$PSScriptRoot\..\..\..\.CommonItems\DSC Resource Module Names.clixml"

foreach (${DSC Resource Module Name} in ${DSC Resource Module Names}) {
  $IsZipPresent = Test-Path -Path "${DSC Resource module Save Path}\${DSC Resource Module Name}.zip"
  if (-not $IsZipPresent) {
    Write-Verbose -Message "Downloading installation files for the '${DSC Resource Module Name}' DSC Resource module."
    Save-Module -Name ${DSC Resource Module Name} -Path ${DSC Resource module Save Path} -Repository 'PSGallery' -AllowPrerelease:$true
    Start-Sleep 5

    Write-Verbose -Message "Compressing installation files for the '${DSC Resource Module Name}' DSC Resource module to .zip"
    Compress-Archive -Path "${DSC Resource module Save Path}\${DSC Resource Module Name}" -DestinationPath "${DSC Resource module Save Path}\${DSC Resource Module Name}.zip"
    Start-Sleep 5

    Write-Verbose -Message "Removinging downloaded & uncompressed '${DSC Resource Module Name}' installation files"
    Remove-Item -Path "${DSC Resource module Save Path}\${DSC Resource Module Name}" -Recurse:$true -Force:$true
  }
}