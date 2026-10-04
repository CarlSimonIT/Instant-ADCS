#Requires -Version 7.4
#Requires -PSEdition Core

$FolderFQN = Import-CliXml -Path "$PSScriptRoot\..\..\.CommonItems\FolderFQN.clixml"
$EmailAddressOfBitwardenAccount = Import-CliXml -Path "$PSScriptRoot\..\..\.CommonItems\EmailAddressOfBitwardenAccount.clixml"

#region | Install Modules for Credential Generation and Retrevial |
Write-Host -Object "`n  Ensuring that the 'TUN.CredentialManager' and 'SecretManagement.Warden' modules for PowerShell 7 have been installed.`n" -ForegroundColor ([System.ConsoleColor]::DarkYellow)

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
$ModuleName = 'Secure-Automations-Toolset'
Write-Host -Object "`n  Build the $ModuleName PowerShell 7 module.`n  Copy to the 'CurrentUser' module path for PowerShell 7.`n" -ForegroundColor ([System.ConsoleColor]::Magenta)
Push-Location ".\$ModuleName"
${SAT Was Already Built} = Test-Path -Path ".\output\builtModule\$ModuleName"
if (${SAT Was Already Built}) {
  Write-Verbose -Message "Import functions defined in $([System.Char]34)Lightweight Functions.ps1$([System.Char]34) to use 'Call-ISO8601TimeDate'"
  $ParentPath = Resolve-Path -Path "$((Get-Location).Path)\.." | Select-Object -ExpandProperty 'Path'
  ${Lightweight Functions Path} = Join-Path -Path $ParentPath -ChildPath "$FolderFQN\output\$FolderFQN\usb1\$FolderFQN\Base\5.1\Lightweight Functions.ps1"
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

#region | Use PowerShell 7 to install Bitwarden Password Manager CLI with script in Secure-Automations-Toolset |
Write-Host -Object "`n  Installing (1) Bitwarden Password Manager CLI and (2) jq JSON processor with script from $ModuleName.`n" -ForegroundColor ([System.ConsoleColor]::DarkGray)
$PSModuleInfo = Import-Module $ModuleName -PassThru -Force
Set-PrerequisiteConditions -Verbose
#endregion

#region | Authenticate into the Bitwarden CLI and register the local Secrets Vault |
Write-Verbose -Message "Generating the '!BW_CLIENTID $FolderFQN' user-scope environment variable"
${Bitwarden Client ID Title} = "!BW_CLIENTID $FolderFQN"
$key1 = 'BW_CLIENTID'
$scope1 = 'User'
${BW_CLIENTID Secret} = Get-StoredCredential -Target ${Bitwarden Client ID Title} -AsCredentialObject | Select-Object -ExpandProperty 'Password'
[System.Environment]::SetEnvironmentVariable($key1,${BW_CLIENTID Secret},$scope1)

Write-Verbose -Message "Generating the '!BW_CLIENTSECRET $FolderFQN' user-scope environment variable"
${Bitwarden Client Secret Title} = "!BW_CLIENTSECRET $FolderFQN"
$key2 = 'BW_CLIENTSECRET'
$scope2 = 'User'
${BW_CLIENTSECRET Secret} = Get-StoredCredential -Target ${Bitwarden Client Secret Title} -AsCredentialObject | Select-Object -ExpandProperty 'Password'
[System.Environment]::SetEnvironmentVariable($key2,${BW_CLIENTSECRET Secret},$scope2)

# Set-PrerequisiteConditions -Verbose
Write-Host -Object "`n  Open your authenticator app. Copy the TOTP for the Bitwarden Account of '$EmailAddressOfBitwardenAccount' and press Enter.`n" -ForegroundColor ([System.ConsoleColor]::DarkRed)
pause
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
Unlock-SecretVault -Name $FolderFQN -Password $EncryptedPassword

$IsSecretVaultUnlocked = Test-SecretVault -Name $FolderFQN
Write-Verbose -Message "`$IsSecretVaultUnlocked = $IsSecretVaultUnlocked"
#endregion