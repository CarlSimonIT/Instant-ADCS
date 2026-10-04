#Requires -Version 5.1
#Requires -PSEdition Desktop

param (
  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  ${SHA256 of Windows Server 2025 ISO File},

  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  ${SHA256 of WinPE 2026-09 EXE File},

  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  ${SHA256 of ADK 2026-09 EXE File},

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

Export-CliXml -Path "$PSScriptRoot\..\..\.CommonItems\SHA256 of Windows Server 2025 ISO File.clixml" -InputObject (${SHA256 of Windows Server 2025 ISO File})
Export-CliXml -Path "$PSScriptRoot\..\..\.CommonItems\SHA256 of WinPE 2026-09 EXE File.clixml" -InputObject (${SHA256 of WinPE 2026-09 EXE File})
Export-CliXml -Path "$PSScriptRoot\..\..\.CommonItems\SHA256 of ADK 2026-09 EXE File.clixml" -InputObject (${SHA256 of ADK 2026-09 EXE File})
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
