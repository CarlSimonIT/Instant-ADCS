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

#region | Generate secure strings in online Bitwarden Vault and synchronize down to local Windows Credential Manager | WARNING: This will take over 60 minutes! |
<# Notes |
  start msedge.exe 'https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/start-job?view=powershell-5.1'
  Start-Job -ScriptBlock -Name -Credential -Authentication -InitializationScript -RunAs32 -PSVersion -InputObject -ArgumentList -Verbose -Debug -ErrorAction -WarningAction
#>
<# Temporary Halt |
  $ArgumentList = @(
    "$PSScriptRoot\Start"
  )
  Start-Job -Name "Generate secure strings in online Bitwarden Vault" -ArgumentList $ArgumentList -ScriptBlock {
    $StartFolder = $args[0]
    . "$env:ProgramFiles\PowerShell\7\pwsh.exe" -NoProfile -File "$StartFolder\PowerShell 5.1 Job that calls pwsh.exe to Generate and Save Credentials into Bitwarden Vault.ps1"
    . "$env:ProgramFiles\PowerShell\7\pwsh.exe" -NoProfile -File "$StartFolder\PowerShell 5.1 Job that compiles the Quick Lookup Table.csv File.ps1"
    . "$env:ProgramFiles\PowerShell\7\pwsh.exe" -NoProfile -File "$StartFolder\PowerShell 5.1 Job that updates the password for logging into the bare-metal unclustered Hyper-V host.ps1"
    . "$env:ProgramFiles\PowerShell\7\pwsh.exe" -NoProfile -File "$StartFolder\PowerShell 5.1 Job that writes passwords from local Secrets Vault into local Windows Credential Manager.ps1"
  }
#>
#endregion

#region | Download Windows Server .ISO file | Download Windows 11 Enterprise .ISO file |

$ArgumentList = @(
  "$PSScriptRoot\Start\Download Jobs"
)
Start-Job -Name "Download Windows Server .ISO file" -ArgumentList $ArgumentList -ScriptBlock {
  $JobsFolder = $args[0]
  . powershell.exe -NoProfile -File "$JobsFolder\Latest Windows Server .iso File.ps1"
}


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









