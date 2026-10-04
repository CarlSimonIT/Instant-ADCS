#Requires -Version 5.1
#Requires -PSEdition Desktop

param (
  [Parameter(
    Mandatory = $false,
    HelpMessage = "The SHA256 hash you download might not match the default value in the Start.ps1 script. `r`nSome websites for reference on hash verification of an iso:`r`n  'https://woshub.com/check-file-hash-windows/'`r`n  'https://files.rg-adguard.net/?dark=1'`r`n  'https://my.visualstudio.com/Downloads' "
  )]
  [ValidatePattern(
    '^[0-9a-f]{64}$'
  )]
  [System.String]
  ${SHA256 of Windows Server 2025 ISO File} = 'D0EF4502E350E3C6C53C15B1B3020D38A5DED011BF04998E950720AC8579B23D',

  [Parameter(
    Mandatory = $false,
    HelpMessage = "The SHA256 hash you download might not match the default value in the Start.ps1 script. `r`nSome websites for reference on hash verification of an iso:`r`n  'https://woshub.com/check-file-hash-windows/'`r`n  'https://files.rg-adguard.net/?dark=1'`r`n  'https://my.visualstudio.com/Downloads' "
  )]
  [ValidatePattern(
    '^[0-9a-f]{64}$'
  )]
  [System.String]
  ${SHA256 of WinPE 2026-09 EXE File} = 'D4DE67ACC83DE253CCC941DD0590808D83726BDD8EA768A374A7BEAFF7949D6A',

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
  'SHA256 of Windows Server 2025 ISO File' = ${SHA256 of Windows Server 2025 ISO File}
  EmailAddressOfBitwardenAccount           = $EmailAddressOfBitwardenAccount
  BadPassword                              = $BadPassword
  FolderFQN                                = $FolderFQN
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
  $JobName = 'Generate secure strings in online Bitwarden Vault'
  Start-Job -Name $JobName -ArgumentList $ArgumentList -ScriptBlock {
    $StartFolder = $args[0]
    . "$env:ProgramFiles\PowerShell\7\pwsh.exe" -NoProfile -File "$StartFolder\PowerShell 5.1 Job that calls pwsh.exe to Generate and Save Credentials into Bitwarden Vault.ps1"
    . "$env:ProgramFiles\PowerShell\7\pwsh.exe" -NoProfile -File "$StartFolder\PowerShell 5.1 Job that compiles the Quick Lookup Table.csv File.ps1"
    . "$env:ProgramFiles\PowerShell\7\pwsh.exe" -NoProfile -File "$StartFolder\PowerShell 5.1 Job that updates the password for logging into the bare-metal unclustered Hyper-V host.ps1"
    . "$env:ProgramFiles\PowerShell\7\pwsh.exe" -NoProfile -File "$StartFolder\PowerShell 5.1 Job that writes passwords from local Secrets Vault into local Windows Credential Manager.ps1"
  }
#>
#endregion

#region | Download Windows Server .ISO file | Download Windows 11 Enterprise .ISO file |
# Push-Location -Path "$PSScriptRoot\Start\Download Jobs"
# . powershell.exe -NoProfile -File '.\Latest Windows Server .iso File.ps1'
# Pop-Location

$FolderFQN = Import-CliXml -Path "$PSScriptRoot\..\.CommonItems\FolderFQN.clixml"
${SHA256 of Windows Server 2025 ISO File} = Import-CliXml -Path "$PSScriptRoot\..\.CommonItems\SHA256 of Windows Server 2025 ISO File.clixml"
$path = "$PSScriptRoot\..\.CommonItems\usb0\$FolderFQN\Microsoft\OS\Server 25\Original"
$folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
${Windows Server 2025 ISO File} = Get-ChildItem -Path "$folder" -File | Where-Object -PipelineVariable 'file' -FilterScript {$_.Extension -eq '.iso'} | ForEach-Object -Process {Get-FileHash -Path $file.FullName -Algorithm 'SHA256' | Where-Object -PipelineVariable 'AlgoHashPath' -FilterScript {$_.Hash -eq ${SHA256 of Windows Server 2025 ISO File}} | ForEach-Object -Process {Get-Item -Path $AlgoHashPath.Path}} | Sort-Object -Property 'LastWriteTime' -Descending | Select-Object -First 1
if (${Windows Server 2025 ISO File} -eq $null) {
  $ArgumentList = @(
    ${Windows Server 2025 ISO File}
    'https://go.microsoft.com/fwlink/?linkid=2293312&clcid=0x409&culture=en-us&country=us'
    "$folder\Windows Server 2025.iso"
    $ProgressPreference
  )
  $JobName = 'Download Windows Server 2025 ISO File'
  # (Get-Job -Name $JobName).Where({$_.State -eq 'Running'})

  Start-Job -Name $JobName -ArgumentList $ArgumentList -ScriptBlock {
    ${Windows Server 2025 ISO File} = $args[0]
    $WebPath                        = $args[1]
    $FilePath                       = $args[2]
    $OriginalProgressPreference     = $args[3]

    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest -Uri $WebPath -OutFile $FilePath
    $ProgressPreference = $OriginalProgressPreference
  }
}
#endregion


#region | Windows Assessment and Deployment Kit | Phase 1 |
<# Windows ADK 10.1.26100.9457 (September 2026) |
  'https://learn.microsoft.com/en-us/windows-hardware/get-started/adk-install'
  'https://go.microsoft.com/fwlink/?linkid=2289980'
#>
<# Windows PE add-on for Windows ADK 10.1.26100.9457 (September 2026) |
  'https://go.microsoft.com/fwlink/?linkid=2289981'
#>
start msedge.exe 'https://go.microsoft.com/fwlink/?linkid=2289981'
Get-FileHash -Path "C:\Users\lowpr\Downloads\adkwinpesetup.exe" -Algorithm sha256
'D4DE67ACC83DE253CCC941DD0590808D83726BDD8EA768A374A7BEAFF7949D6A'

#endregion



#region | Download, but do not install, DSC Resource Modules |

#endregion

#region | Download, but do not install, Windows PowerShell Modules |
#endregion

#region | Resume authoring the custom InstantAdcsRev5 DSC Resource module | Write build script upon completion. |
#endregion














#region | Windows Assessment and Deployment Kit | Phase 2 |
<#
  
#>
#endregion









