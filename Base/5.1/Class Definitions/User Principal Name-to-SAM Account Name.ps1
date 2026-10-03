#region | Calculate hash of lowercase UPN and truncate to 20 alphanumeric characters |
class Pre2000WindowsAccountUserNameFrom20CharactersOfSha512HashOfUserPrincipalName {
  static [System.String] Un ([System.String] $UserPrincipalName) {
    ${Bytes UTF8}    = [System.Text.Encoding]::UTF8.GetBytes($UserPrincipalName.ToLower())
    ${Bytes SHA512}  = [System.Security.Cryptography.SHA512Cng]::New().ComputeHash(${Bytes UTF8})
    $Base64String    = [System.Convert]::ToBase64String(${Bytes SHA512}).ToLower() -replace '\W',''
    return $Base64String.SubString(0,20)
  }
}
# 'p2k' stands for pre-Windows 2000
$accelerators::Add('p2k','Pre2000WindowsAccountUserNameFrom20CharactersOfSha512HashOfUserPrincipalName')
#endregion

