#region | Windows PowerShell in Action (3rd Ed.) Selections |
#region | Chapter 3 experiments |
function Find-dotNetType {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory)]
    [System.Text.RegularExpressions.Regex]
    $RegEx
  )
  [System.AppDomain]::CurrentDomain.GetAssemblies().GetTypes() | Select-String -Pattern $RegEx
}
function Find-dotNetType0 {
  param (
    [System.Text.RegularExpressions.Regex]
    $RegEx
  )
  
  $QueriedTypes = $null

  for ($i = 0; $i -lt [System.AppDomain]::CurrentDomain.GetAssemblies().count; $i++) {
    $QueriedTypes = [System.AppDomain]::CurrentDomain.GetAssemblies()[$i].GetTypes() | ? {($_.Name -match "$RegEx") -or ($_.BaseType -match "$RegEx")}
    if (-not ($null -eq $QueriedTypes)) {
      Write-Host "Iteration number $i"
      Write-Host "Assembly:"
      [System.AppDomain]::CurrentDomain.GetAssemblies()[$i] | select FullName,Location
      Write-Host "`r`n"
      Write-Host "Types in the assembly with regular expression: $RegEx :"
      $QueriedTypes
      Write-Host "`r`n"
    }
  }
}
function Find-dotNetType1 {
  param (
    [System.Text.RegularExpressions.Regex]
    $RegEx
  )

  $QueriedTypes = $null

  for ($i = 0; $i -lt [System.AppDomain]::CurrentDomain.GetAssemblies().count; $i++) {
    $QueriedTypes = [System.AppDomain]::CurrentDomain.GetAssemblies()[$i].GetTypes() | ? {($_.Name -match "$RegEx") -or ($_.BaseType -match "$RegEx")}
    if (-not ($null -eq $QueriedTypes)) {
      Write-Host "Iteration number $i"
      Write-Host "Assembly:"
      [System.AppDomain]::CurrentDomain.GetAssemblies()[$i] | select Location
      Write-Host "`r`n"
      Write-Host "Types in the assembly with regular expression: $RegEx :"
      $QueriedTypes
      Write-Host "`r`n"
    }
  }
}
function Find-dotNetType2 {
  param (
    [System.Text.RegularExpressions.Regex]
    $RegEx
  )

  $QueriedTypes = $null

  for ($i = 0; $i -lt [System.AppDomain]::CurrentDomain.GetAssemblies().count; $i++) {
    $QueriedTypes = [System.AppDomain]::CurrentDomain.GetAssemblies()[$i].GetTypes() | ? {($_.Name -match "$RegEx") -or ($_.BaseType -match "$RegEx")}
    if (-not ($null -eq $QueriedTypes)) {
      Write-Host "Iteration number $i"
      Write-Host "Assembly:"
      [System.AppDomain]::CurrentDomain.GetAssemblies()[$i] | select FullName
      Write-Host "`r`n"
      Write-Host "Types in the assembly whose Name -OR- BaseType match with the regular expression pattern: $RegEx :"
      $QueriedTypes
      Write-Host "`r`n"
    }
  }
}
#endregion

#endregion

