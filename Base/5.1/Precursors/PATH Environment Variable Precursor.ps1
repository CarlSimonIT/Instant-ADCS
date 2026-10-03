#region | $env:PATH is the COMBINATION of system-scope AND user-scope paths! | See chapter 16.2 in PowerShell Cookbook (4th Ed.) by Lee Holmes |
${User-scope %Path% Set} = [System.String[]]@(
  [System.Environment]::GetEnvironmentVariable('Path','User') -split ';'
)

#region | Script Storage Paths |
${ScriptStoragePaths Single String Raw} = '%_ScriptStoragePaths Single String Raw_%'
${ScriptStoragePaths Single String} = ${ScriptStoragePaths Single String Raw} -replace '\r\n$',''
${ScriptStoragePaths Multi-String} = ${ScriptStoragePaths Single String} -split '\r\n'
$ScriptStoragePathSet = ${ScriptStoragePaths Multi-String} -replace '\r',''

if ($null -ne ${explorer.exe Owner}) {
  foreach ($ScriptStoragePath in $ScriptStoragePathSet) {
    ${User-scope %Path% Set} += $ScriptStoragePath
  }
}
#endregion

# Include '.' in the %path% for PowerShell to include current directory in the search for executable files like .exe and .ps1
${User-scope %Path% Set} += '.'

# Remove collection elements that are empty.
${User-scope %Path% Set} = ${User-scope %Path% Set}.Where({$_ -ne ''})
# Ensure that all entries in $env:Path are unique
${User-scope %Path% Set} = ${User-scope %Path% Set} | Sort-Object -Descending | Get-Unique
# Concatenate each element of the array into a single string, with each array element being separated by a semicolon
${Updated User-scope %Path%} = ${User-scope %Path% Set} -join ';'
# Write the new value for the user-scope $env:Path environment variable to persistent storage. 
[System.Environment]::SetEnvironmentVariable('Path',${Updated User-scope %Path%},'User')
# A logoff/logon is required for PowerShell to search a newly-added directory path to the user-scope %path%
#endregion

