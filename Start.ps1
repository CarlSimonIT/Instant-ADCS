#Requires -Version 5.1
#Requires -PSEdition Desktop

param (
  [Parameter(
    Mandatory = $true,
    HelpMessage = "Regular expression sourced from 'https://www.regular-expressions.info/email.html'"
  )]
  [ValidatePattern(
    '^[a-z0-9._%+-]+@[a-z0-9.-]+\.[a-z]{2,}$'
  )]
  [System.String]
  [Alias(
    'email'
  )]
  $EmailAddressOfBitwardenAccount,

  [Parameter(
    Mandatory = $false
  )]
  [System.String]
  $BadPassword = 'BadPassword!',

  [Parameter(
    Mandatory = $false
  )]
  [Alias('Folder Fully Qualified Name')]
  [System.String]
  $FolderFQN = 'Instant-ADCS',

  [Parameter(
    Mandatory = $true
  )]
  [ValidatePattern(
    '^(?!(\d{1,15}|ANONYMOUS|BATCH|BUILTIN|DIALUP|DOMAIN|ENTERPRISE|INTERACTIVE|INTERNET|LOCAL|NETWORK|NULL|PROXY|RESTRICTED|SELF|SERVER|SERVICE|SYSTEM|USERS|WORLD)$)[a-z0-9][a-z0-9-]{1,13}[a-z0-9]$'
  )]
  [System.String]
  ${NetBIOS Name of Root Domain in AD Forest},

  [Parameter(
    Mandatory = $true
  )]
  [ValidatePattern(
    '^ad\.[0-9a-z-]{1,256}\.INTERNAL$'
  )]
  [System.String]
  ${DNS Name of Root Domain in AD Forest}
)


#region | Export non-senstive strings to .clixml for later import by other applications |
$HT = @{
  EmailAddressOfBitwardenAccount = $EmailAddressOfBitwardenAccount
  BadPassword                    = $BadPassword
  FolderFQN                      = $FolderFQN
}
& "$PSScriptRoot\Start\Export non-senstive strings to .clixml for later import by other applications.ps1" @HT
#endregion

#region | Install NuGet | Set PSGallery as Trusted | Install 'TUN.CredentialManager' |
. powershell.exe -NoProfile -File "$PSScriptRoot\Start\NuGet-PSGallery-Windows PowerShell Module Install.ps1"
#endregion

#region | Write sensitive strings providing access to online Bitwarden Vault into local Windows Credential Manager |
. powershell.exe -NoProfile -File "$PSScriptRoot\Start\Write sensitive strings providing access to online Bitwarden Vault into local Windows Credential Manager.ps1"
#endregion

#region | Collect and export to .clixml the unique identifiers of removable external storage media |
. powershell.exe -NoProfile -File "$PSScriptRoot\Start\Collect and export to .clixml the unique identifiers of removable external storage media.ps1"
#endregion

#region | Generate Windows PowerShell-compatible profile.ps1 file for Instant-ADCS |
$HT = @{
  'NetBIOS Name of Root Domain in AD Forest' = ${NetBIOS Name of Root Domain in AD Forest}
  'DNS Name of Root Domain in AD Forest'     = ${DNS Name of Root Domain in AD Forest}
}
& "$PSScriptRoot\Start\Construct profile.ps1 for Windows PowerShell.ps1" @HT
#endregion

#region | Install machine-scope PowerShell 7 and register Event Logging Manifest |
. powershell.exe -NoProfile -File "$PSScriptRoot\Start\Install machine-scope PowerShell 7 and register Event Logging Manifest.ps1"
#endregion

#region | Install Bitwarden CLI, log into Bitwarden CLI, and Build SAT module |
. "$env:ProgramFiles\PowerShell\7\pwsh.exe" -NoProfile -File "$PSScriptRoot\Start\Build Secure-Automations-Toolset Module.ps1"
#endregion
#region | Variable Setup in Windows PowerShell and Export to CliXml |
. powershell.exe -NoProfile -File "$PSScriptRoot\Start\Variable Setup in Windows PowerShell and Export to CliXml.ps1"
#endregion

#region | Persistent Secrets in Bitwarden Vault | WARNING: This will take over 60 minutes! |
<#
  For this reason, the code should run in a PowerShell Job!! 
#>
#region | Generate secure strings in online Bitwarden Vault |

<# Temporary Halt |
  . "$env:ProgramFiles\PowerShell\7\pwsh.exe" -NoProfile -File "$PSScriptRoot\Start\Generate and Save Credentials into Bitwarden Vault.ps1"
#>
#endregion

#region | Install 'TUN.CredentialManager' module for Windows PowerShell |
<# I think we can delete this because the module has already been established much earlier |
  Write-Host -Object "`n  Installing 'TUN.CredentialManager' module for Windows PowerShell...`n" -ForegroundColor ([System.ConsoleColor]::DarkYellow)
  $InstallModuleHT = @{
    Scope      = 'CurrentUser'
    Repository = 'PSGallery'
    Verbose    = $true
  }
  $ModuleName = 'TUN.CredentialManager'
  try {
    Get-InstalledModule -Name $ModuleName -ErrorAction 'Stop' | Format-Table -AutoSize
  } 
  catch {
    Install-Module -Name $ModuleName @InstallModuleHT | Format-Table -AutoSize
  }
#>
#endregion

#region | Synchronize in-cloud Bitwarden Items down to local Windows Credential Manager |
#. powershell.exe -NoProfile -File "$PSScriptRoot\Start\Synchronize in-cloud Bitwarden Items down to local Windows Credential Manager.ps1"
<# I think we can delete. 
  #   Exporting $FolderFQN to CliXml happens early 
  #   in .\Start.ps1 and exporting $FolderId to CliXml happens during 
  #   'Generate and Save Credentials into Bitwarden Vault.ps1'

  . "$env:ProgramFiles\PowerShell\7\pwsh.exe" -NoProfile -File "$PSScriptRoot\Start\Export FolderId and FolderFQN to CliXml.ps1"
#>
#region | Import FolderId  GUID and`$FolderFQN from .clixml file into separate in-memory variables |
<# Can we delete? I think this was not necessary |
  Write-Verbose -Message "Import `$FolderId and `$FolderFQN from .clixml file into separate in-memory variables"

  $CliXmlFile = Get-ChildItem -Path "$PSScriptRoot\..\.CommonItems\FolderId and FolderFQN *.clixml" `
  | Sort-Object `
  | Select-Object -Last 1

  $CliXmlHT = Import-CliXml -Path $CliXmlFile.FullName

  foreach ($Ea in ($CliXmlHT.GetEnumerator() | Write-Output)) {
    $_Var_Name = $Ea.Name
    try {Clear-Variable -Name $_Var_Name -ErrorAction 'Stop'} catch {New-Variable -Name $_Var_Name -Value $null}
    Set-Variable -Name $_Var_Name -Value ($Ea.Value)
  }
  Write-Verbose -Message "`$FolderFQN = $FolderFQN"
  Write-Verbose -Message "`$FolderId = $FolderId"
#>
#endregion
#region | Compile Quick Lookup Table.csv File |
#TEMPORARY#. "$env:ProgramFiles\PowerShell\7\pwsh.exe" -NoProfile -File "$PSScriptRoot\Start\Compile Quick Lookup Table.csv File.ps1"
#endregion
#region | Update Password for Logging into Bare-metal Server (aka DSC Authoring Station, aka Unclustered Hyper-V Host) to a value you know |
#TEMPORARY#. "$env:ProgramFiles\PowerShell\7\pwsh.exe" -NoProfile -File "$PSScriptRoot\Start\Update Password for Logging into Bare-metal Unclustered Hyper-V Host.ps1"
#endregion
#region | Write password from local Secrets Vault into local Windows Credential Manager |
#TEMPORARY#. "$env:ProgramFiles\PowerShell\7\pwsh.exe" -NoProfile -File "$PSScriptRoot\Start\Write password from local Secrets Vault into local Windows Credential Manager.ps1"
#endregion
#endregion

#endregion


#region | Download Windows Server .ISO file | Download Windows 11 Enterprise .ISO file |
#endregion

#region | Download, but do not install, DSC Resource Modules |
#endregion

#region | Download, but do not install, Windows PowerShell Modules |
#endregion

#region | Resume authoring the custom InstantAdcsRev5 DSC Resource module | Write build script upon completion. |
#endregion







#region | Windows Assessment and Deployment Kit | Phase 1 |
<#
  
#>
#endregion









#region | Windows Assessment and Deployment Kit | Phase 2 |
<#
  
#>
#endregion









