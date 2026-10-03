#Requires -Version 7.4
#Requires -PSEdition Core

#region | Install Modules for Credential Generation and Retrevial |
Write-Host -Object "`n  Installing 'TUN.CredentialManager' and 'SecretManagement.Warden' modules for PowerShell 7...`n" -ForegroundColor ([System.ConsoleColor]::DarkYellow)

$ModuleNames = @(
  'TUN.CredentialManager'
  'SecretManagement.Warden'
)

foreach ($ModuleName in $ModuleNames) {
  $InstallModuleHT = @{
    Scope      = 'CurrentUser'
    Repository = 'PSGallery'
    Verbose    = $true
  }
  try {
    Get-InstalledModule -Name $ModuleName -ErrorAction 'Stop' | Format-Table -AutoSize
  } 
  catch {
    Install-Module -Name $ModuleName @InstallModuleHT | Format-Table -AutoSize
  }
}
#endregion

#region | Build the Secure-Automations-Toolset PowerShell 7 module | Copy to the 'CurrentUser' module path for PowerShell 7 |
Write-Host -Object "`n  Build the Secure-Automations-Toolset PowerShell 7 module.`n  Copy to the 'CurrentUser' module path for PowerShell 7.`n" -ForegroundColor ([System.ConsoleColor]::Magenta)
$ModuleName = 'Secure-Automations-Toolset'
Push-Location ".\$ModuleName"
${SAT Was Already Built} = Test-Path -Path ".\output\builtModule\$ModuleName"
if (${SAT Was Already Built}) {
  # Import functions defined in "Lightweight Functions.ps1" to use 'Call-ISO8601TimeDate'
  $ParentPath = Resolve-Path -Path "$((Get-Location).Path)\.." | Select-Object -ExpandProperty 'Path'
  ${Lightweight Functions Path} = Join-Path -Path $ParentPath -ChildPath 'Instant-ADCS\output\Instant-ADCS\usb1\Instant-ADCS\Base\5.1\Lightweight Functions.ps1'
  . ${Lightweight Functions Path}
  $TimeDate = Call-ISO8601TimeDate

  Push-Location '.\output\builtModule'
  Get-Item -Path $ModuleName | Rename-Item -NewName "$ModuleName $TimeDate"
  Pop-Location
}
  
$ModuleVariablesHT = @{
  ModuleName = $ModuleName
  ModuleVersion = '0.0.2'
}
.\build.ps1 @ModuleVariablesHT
Pop-Location

Push-Location ".\$ModuleName\output\builtModule"
${All PS Module Paths} = $env:PSModulePath -split ';'

${Path of Module Directory for CurrentUser Scope} = ${All PS Module Paths} `
| Where-Object -FilterScript {$_ -match [regex]::Escape('\Documents\PowerShell\Modules')} `
| Select-Object -First 1

${Module Directory Path} = Join-Path -Path ${Path of Module Directory for CurrentUser Scope} -ChildPath $ModuleName
${SAT Was Already Installed} = Test-Path -Path ${Module Directory Path}
if (${SAT Was Already Installed}) {
  Push-Location ${Path of Module Directory for CurrentUser Scope}
  Get-Item -Path $ModuleName | Remove-Item -Recurse -Force
  Pop-Location
}

Copy-Item -Path ".\$ModuleName" -Destination "${Path of Module Directory for CurrentUser Scope}\$ModuleName" -Recurse
Pop-Location

#endregion

#region | Use PowerShell 7 to install Bitwarden Password Manager CLI with script in Secure Automations Toolset |
Write-Host -Object "`n  Installing Bitwarden Password Manager CLI with script from Secure Automations Toolset...`n" -ForegroundColor ([System.ConsoleColor]::DarkGray)
$ModuleName = 'Secure-Automations-Toolset'
$PSModuleInfo = Import-Module $ModuleName -PassThru -Force
Set-PrerequisiteConditions

#endregion

#region | Authenticate into the Bitwarden CLI and register the local Secrets Vault |
$ModuleName = 'Secure-Automations-Toolset'
$PSModuleInfo = Import-Module $ModuleName -PassThru -Force

#$FolderFQN = 'Instant-ADCS'
#$FolderFQN = 'Instant-ADCS'
$FolderFQN = Import-CliXml -Path "$PSScriptRoot\..\..\.CommonItems\FolderFQN.clixml"

$EmailAddressOfBitwardenAccount = Import-CliXml -Path "$PSScriptRoot\..\..\.CommonItems\EmailAddressOfBitwardenAccount.clixml"

${Bitwarden Client ID Title} = "!BW_CLIENTID $FolderFQN"

$key1 = 'BW_CLIENTID'
$scope1 = 'User'
${BW_CLIENTID Secret} = Get-StoredCredential -Target ${Bitwarden Client ID Title} -AsCredentialObject | Select-Object -ExpandProperty 'Password'
[System.Environment]::SetEnvironmentVariable($key1,${BW_CLIENTID Secret},$scope1)

${Bitwarden Client Secret Title} = "!BW_CLIENTSECRET $FolderFQN"
$key2 = 'BW_CLIENTSECRET'
$scope2 = 'User'
${BW_CLIENTSECRET Secret} = Get-StoredCredential -Target ${Bitwarden Client Secret Title} -AsCredentialObject | Select-Object -ExpandProperty 'Password'
[System.Environment]::SetEnvironmentVariable($key2,${BW_CLIENTSECRET Secret},$scope2)

Set-PrerequisiteConditions -Verbose
$EmailAddressOfBitwardenAccount = Import-CliXml -Path "$PSScriptRoot\..\..\.CommonItems\EmailAddressOfBitwardenAccount.clixml"
Unlock-BwCli -EmailAddressOfBitwardenAccount $EmailAddressOfBitwardenAccount -Verbose

$ModuleName = 'SecretManagement.Warden'
try {
  $SecretVaultInfo = Get-SecretVault -Name $FolderFQN -ErrorAction 'Stop'
} catch {
  $HT = @{
    Name            = $FolderFQN
    ModuleName      = $ModuleName
    VaultParameters = @{
      ExportObjectsToSecureNotesAs = 'CliXml'
      MaximumObjectDepth           = 150
    }
    ErrorAction     = 'SilentlyContinue'
  }
  Register-SecretVault @HT
}

${Bitwarden Account Password Title} = "!Bitwarden Account Password-DELETE THIS"

$EncryptedObject = Get-StoredCredential -Target ${Bitwarden Account Password Title}

$EncryptedPassword = $EncryptedObject.Password

#$BwAccountPwd = Read-Host -Prompt "Bitwarden Account Password" -AsSecureString
$BwAccountPwd = $EncryptedPassword

#$FolderFQN = 'Instant-ADCS'

#Unlock-SecretVault -Name $FolderFQN -Password $BwAccountPwd
Unlock-SecretVault -Name $FolderFQN -Password $EncryptedPassword

$IsSecretVaultUnlocked = Test-SecretVault -Name $FolderFQN
Write-Verbose -Message "`$IsSecretVaultUnlocked = $IsSecretVaultUnlocked"
#endregion

