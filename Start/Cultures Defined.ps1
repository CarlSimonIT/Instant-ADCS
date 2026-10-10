#Requires -Version 7.4
#Requires -PSEdition Core


${Cultures Defined} = (Get-Culture -ListAvailable).Name
Export-CliXml -Path "$PSScriptRoot\..\..\.CommonItems\Cultures Defined.clixml" -InputObject (${Cultures Defined})