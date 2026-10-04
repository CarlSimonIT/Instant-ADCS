#Requires -Version 5.1
#Requires -PSEdition Desktop

$FolderFQN = Import-CliXml -Path "$PSScriptRoot\..\..\.CommonItems\FolderFQN.clixml"

""
${API Key for Bitwarden CLI Here-String} = @'
  1. Review the 'New Bitwarden Account' video at 'https://github.com/CarlSimonIT/Secure-Automations-Toolset'

  2. Visit 'https://vault.bitwarden.com/#/login' to create a free personal Bitwarden Account. 

  3. Authenticate into your Bitwarden Vault > 
    select 'Bitwarden Password Manager' in lower-left corner > 
      select 'Settings' blade > 
        select 'Security' blade > 
          select 'Keys' tab > 
            in 'API Key' section hit 'View API Key' button.

  4. Input the password of your personal Bitwarden Account. 
    
  5. Collect your Bitwarden Client ID + Generate new Bitwarden Client Secret. 

  6. Press Enter once those values are available. PowerShell will save 
     these sensitive strings to the local Windows Credential Manager. 

'@
""
Write-Host -Object ${API Key for Bitwarden CLI Here-String} -ForegroundColor ([System.ConsoleColor]::Green)
pause 

#region | Securely write into local Windows Credential Manager: (1) Bitwarden Client ID |
# Title of Bitwarden Client ID
${Bitwarden Client ID Title} = "!BW_CLIENTID $FolderFQN"

# Verify whether the Bitwarden Client ID is already present in the local Windows Credential Manager
$StoredCred = Get-StoredCredential -Target ${Bitwarden Client ID Title}
if ($StoredCred -eq $null) {
  # Value of Bitwarden Client ID, symmetrically encrypted with the Windows Data Protection API (DPAPI)
  ${Bitwarden Client ID Value-SECURED} = Read-Host -Prompt 'Bitwarden Client ID Value' -AsSecureString
  $HT = @{
    Target         = ${Bitwarden Client ID Title}
    UserName       = ${Bitwarden Client ID Title}
    SecurePassword = ${Bitwarden Client ID Value-SECURED}
    Comment        = "Bitwarden Client ID"
    Type           = "Generic"
    Persist        = 'LocalMachine'
    Verbose        = $true
  }
  # Write the Bitwarden Client ID into the local Windows Credential Manager. 
  New-StoredCredential @HT

  # Destroy the in-memory representation of the Bitwarden Client ID
  Remove-Variable -Name 'Bitwarden Client ID Value-SECURED'
} else {
  Write-Host -Object "`n  [x] Object titled '${Bitwarden Client ID Title}' already present in local Windows Credential Manager" -ForegroundColor ([System.ConsoleColor]::DarkGreen)
}
#endregion

#region | Securely write into local Windows Credential Manager: (2) Bitwarden Client Secret |
# Title of Bitwarden Client ID
${Bitwarden Client Secret Title} = "!BW_CLIENTSECRET $FolderFQN"

# Verify whether the Bitwarden Client Secret is already present in the local Windows Credential Manager
$StoredCred = Get-StoredCredential -Target ${Bitwarden Client Secret Title}
if ($StoredCred -eq $null) {
  # Value of Bitwarden Client Secret, symmetrically encrypted with the Windows Data Protection API (DPAPI)
  ${Bitwarden Client Secret Value-SECURED} = Read-Host -Prompt 'Bitwarden Client Secret Value' -AsSecureString
  $HT = @{
    Target         = ${Bitwarden Client Secret Title}
    UserName       = ${Bitwarden Client Secret Title}
    SecurePassword = ${Bitwarden Client Secret Value-SECURED}
    Comment        = "No comment"
    Type           = "Generic"
    Persist        = 'LocalMachine'
    Verbose        = $true
  }
  # Write the Bitwarden Client Secret into the local Windows Credential Manager. 
  New-StoredCredential @HT

  # Destroy the in-memory representation of the Bitwarden Client Secret
  Remove-Variable -Name 'Bitwarden Client Secret Value-SECURED'
} else {
  Write-Host -Object "`n  [x] Object titled '${Bitwarden Client Secret Title}' already present in local Windows Credential Manager" -ForegroundColor ([System.ConsoleColor]::DarkGreen)
}
#endregion

#region | Securely write into local Windows Credential Manager: (3) Bitwarden Vault password |
<# IMPORTANT |
  DELETE this entry in the Credential Manager before exporting to .crd file!
#>
# Title of Bitwarden Account password
${Bitwarden Account Password Title} = "!Bitwarden Account Password-DELETE THIS"

# Verify whether the Bitwarden Account password is already present in the local Windows Credential Manager
$StoredCred = Get-StoredCredential -Target ${Bitwarden Account Password Title}
if ($StoredCred -eq $null) {
  # Value of Bitwarden Account password, symmetrically encrypted with the Windows Data Protection API (DPAPI)
  ${Bitwarden Account Password-SECURED} = Read-Host -Prompt "Supply the password to authenticate into 'https://vault.bitwarden.com/#/login'" -AsSecureString
  $HT = @{
    Target         = ${Bitwarden Account Password Title}
    UserName       = ${Bitwarden Account Password Title}
    SecurePassword = ${Bitwarden Account Password-SECURED}
    Comment        = "Delete this credential BEFORE exporting to .crd file"
    Type           = "Generic"
    Persist        = 'LocalMachine'
    Verbose        = $true
  }

  # Write the Bitwarden Account password into the local Windows Credential Manager. 
  New-StoredCredential @HT

  # Destroy the in-memory representation of the Bitwarden Account password
  Remove-Variable -Name 'Bitwarden Account Password-SECURED'
} else {
  Write-Host -Object "`n  [x] Object titled '${Bitwarden Account Password Title}' already present in local Windows Credential Manager and will be deleted shortly." -ForegroundColor ([System.ConsoleColor]::DarkGreen)
}
#endregion