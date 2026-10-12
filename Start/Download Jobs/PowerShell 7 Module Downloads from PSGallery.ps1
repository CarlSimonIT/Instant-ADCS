#Requires -Version 7.4
#Requires -PSEdition Core

${PowerShell 7 module Save Path} = Import-CliXml -Path "$PSScriptRoot\..\..\..\.CommonItems\PowerShell 7 module Save Path.clixml"
${PowerShell 7 Module Names} = Import-CliXml -Path "$PSScriptRoot\..\..\..\.CommonItems\PowerShell 7 Module Names.clixml"

foreach (${PowerShell 7 Module Name} in ${PowerShell 7 Module Names}) {
  $IsZipPresent = Test-Path -Path "${PowerShell 7 module Save Path}\${PowerShell 7 Module Name}.zip"
  if (-not $IsZipPresent) {
    Write-Verbose -Message "Downloading installation files for the '${PowerShell 7 Module Name}' DSC Resource module."
    Save-Module -Name ${PowerShell 7 Module Name} -Path ${PowerShell 7 module Save Path} -Repository 'PSGallery' -AllowPrerelease:$true
    Start-Sleep 5

    Write-Verbose -Message "Compressing installation files for the '${PowerShell 7 Module Name}' DSC Resource module to .zip"
    Compress-Archive -Path "${PowerShell 7 module Save Path}\${PowerShell 7 Module Name}" -DestinationPath "${PowerShell 7 module Save Path}\${PowerShell 7 Module Name}.zip"
    Start-Sleep 5

    Write-Verbose -Message "Removinging downloaded & uncompressed '${PowerShell 7 Module Name}' installation files"
    Remove-Item -Path "${PowerShell 7 module Save Path}\${PowerShell 7 Module Name}" -Recurse:$true -Force:$true
  }
}