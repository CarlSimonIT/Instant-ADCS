#Requires -Version 5.1
#Requires -PSEdition Desktop

$PSModuleInfo = Import-Module 'PowerShellGet' -Force -PassThru

${Windows PowerShell module Save Path} = Import-CliXml -Path "$PSScriptRoot\..\..\..\.CommonItems\Windows PowerShell module Save Path.clixml"
${Windows PowerShell Module Names} = Import-CliXml -Path "$PSScriptRoot\..\..\..\.CommonItems\Windows PowerShell Module Names.clixml"

foreach (${Windows PowerShell Module Name} in ${Windows PowerShell Module Names}) {
  $IsZipPresent = Test-Path -Path "${Windows PowerShell module Save Path}\${Windows PowerShell Module Name}.zip"
  if (-not $IsZipPresent) {
    Write-Verbose -Message "Downloading installation files for the '${Windows PowerShell Module Name}' DSC Resource module."
    Save-Module -Name ${Windows PowerShell Module Name} -Path ${Windows PowerShell module Save Path} -Repository 'PSGallery' -AllowPrerelease:$true
    Start-Sleep 5

    Write-Verbose -Message "Compressing installation files for the '${Windows PowerShell Module Name}' DSC Resource module to .zip"
    Compress-Archive -Path "${Windows PowerShell module Save Path}\${Windows PowerShell Module Name}" -DestinationPath "${Windows PowerShell module Save Path}\${Windows PowerShell Module Name}.zip"
    Start-Sleep 5

    Write-Verbose -Message "Removinging downloaded & uncompressed '${Windows PowerShell Module Name}' installation files"
    Remove-Item -Path "${Windows PowerShell module Save Path}\${Windows PowerShell Module Name}" -Recurse:$true -Force:$true
  }
}