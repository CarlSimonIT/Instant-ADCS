#Requires -Version 5.1
#Requires -PSEdition Desktop

param (
  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  $EmailAddressOfBitwardenAccount,

  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  $BadPassword = 'BadPassword!',

  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  $FolderFQN
)

Export-CliXml -Path "$PSScriptRoot\..\..\.CommonItems\EmailAddressOfBitwardenAccount.clixml" -InputObject ($EmailAddressOfBitwardenAccount)
<# Note |
  Fully Qualified Name (FQN) of the Folder object in the Bitwarden 
  Vault that contains the secure strings for this project follows
  the NAME of the project: $FolderFQN
#>
Export-CliXml -Path "$PSScriptRoot\..\..\.CommonItems\BadPassword.clixml" -InputObject ($BadPassword)
Export-CliXml -Path "$PSScriptRoot\..\..\.CommonItems\FolderFQN.clixml" -InputObject ($FolderFQN)

${Full Computer Name} = Get-ItemPropertyValue -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name 'HostName'
Export-CliXml -Path "$PSScriptRoot\..\..\.CommonItems\Full Computer Name.clixml" -InputObject (${Full Computer Name})
