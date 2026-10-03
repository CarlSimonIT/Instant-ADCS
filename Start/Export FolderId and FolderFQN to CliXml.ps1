#Requires -Version 7.4
#Requires -PSEdition Core



Write-Verbose -Message "Collect GUID value of `$FolderId for the 'Instant-ADCS' project and export to CliXml"

Unlock-BwCLI -Verbose

#$FolderFQN = 'Instant-ADCS'
$FolderFQN = Import-CliXml -Path "$PSScriptRoot\..\..\.CommonItems\FolderFQN.clixml"

$FolderId = New-BitwardenVaultFolder -Verbose:$true -Name $FolderFQN -Check


$TimeDate = (Call-ISO8601TimeDateUTC).Replace(':','-')
$CliXmlHT = [System.Collections.Hashtable]::New()
$CliXmlHT.Add('FolderFQN',$FolderFQN)
$CliXmlHT.Add('FolderId',$FolderId)
$path = "$PSScriptRoot\..\..\.CommonItems\FolderId and FolderFQN $TimeDate.clixml"
$CliXmlFile = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'File' -Force}      
Export-CliXml -Path $CliXmlFile -InputObject ($CliXmlHT)
