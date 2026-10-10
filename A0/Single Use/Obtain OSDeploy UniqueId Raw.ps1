#Requires -Version 5.1
#Requires -PSEdition Desktop

param (
  [Parameter(
    Mandatory = $true
  )]
  [ValidateNotNullOrEmpty()]
  [System.String]
  ${OSDeploy UniqueId Raw}
)

$BaseName = ([System.IO.FileInfo]$($MyInvocation.MyCommand.Definition)).BaseName -replace '^Obtain ',''

Export-CliXml -Path "$PSScriptRoot\..\..\..\.CommonItems\$BaseName.clixml" -InputObject (
  Get-Variable -Name $BaseName | Select-Object -ExpandProperty 'Value'
)