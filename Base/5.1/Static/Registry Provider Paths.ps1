#region | Registry Provider Paths |
${HKCR PSDrive} = try {
  Get-PSDrive -Name 'HKCR' -ErrorAction 'Stop'
} catch {
  New-PSDrive -Name 'HKCR' -PSProvider 'Registry' -Root 'HKEY_CLASSES_ROOT' # -Scope 'Global'
}

${HKU PSDrive} = try {
  Get-PSDrive -Name 'HKU' -ErrorAction 'Stop'
} catch {
  New-PSDrive -Name 'HKU' -PSProvider 'Registry' -Root 'HKEY_USERS' # -Scope 'Global'
}

${HKCC PSDrive} = try {
  Get-PSDrive -Name 'HKCC' -ErrorAction 'Stop'
} catch {
  New-PSDrive -Name 'HKCC' -PSProvider 'Registry' -Root 'HKEY_CURRENT_CONFIG' # -Scope 'Global'
}
#endregion

