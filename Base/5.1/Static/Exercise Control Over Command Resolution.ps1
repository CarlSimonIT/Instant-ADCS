#region | Exercise Control Over Command Resolution |
#######################################################################
#region | PreCommandLookupAction | (Exercise Control Over Command Resolution) |
${Get-Process Here-String} = @'
  Write-Host -Object "Replacement for the Get-Process command"
'@; ${Get-Process} = [ScriptBlock]::Create(${Get-Process Here-String})

${Pre-Command Lookup Action Set} = {
  param (
    $C0mmandCharact3rSeq,
    $CommandLookupEventArgs
  )

  switch -Regex ($C0mmandCharact3rSeq) 
  {
    '^Get-Process2$' {
      $CommandLookupEventArgs.CommandScriptBlock = ${Get-Process}.GetNewClosure()
      $CommandLookupEventArgs.StopSearch = $true
      break
    }

    # Get-ChildItem Replacement: 
    '^Get-ChildItem2$' {
      $CommandInfo = Get-Command -Name 'Get-ChildItem'
      $CommandLookupEventArgs.Command = $CommandInfo
      $CommandLookupEventArgs.StopSearch = $true
      break
    }

    default {break}
  }
}
$ExecutionContext.SessionState.InvokeCommand.PreCommandLookupAction = ${Pre-Command Lookup Action Set}
#endregion
#######################################################################
#region | PostCommandLookupAction | (Exercise Control Over Command Resolution) |
${Post-Command Lookup Action Set} = {
  param (
    $C0mmandCharact3rSeq,
    $CommandLookupEventArgs
  )

  # Initialize a hashtable in a variable that stores a count user-invoked commands
  if (-not (Test-Path -Path "Variable:\User-Invoked Command Count")) {
    ${global:User-Invoked Command Count} = [System.Collections.Hashtable]::New()
    #${global:User-Invoked Command Count} = @{}
  }

  # Initialize a hashtable in a variable that stores a count nonUser-invoked commands
  #if (-not (Test-Path -Path "Variable:\NonUser-Invoked Command Count")) {
  #  #${global:NonUser-Invoked Command Count} = [System.Collections.Hashtable]::New()
  #  ${global:NonUser-Invoked Command Count} = @{}
  #}

  
  if ($CommandLookupEventArgs.CommandOrigin -eq 'Runspace') 
  { # A command whose origin is the 'Runspace' means a person invoked it? 
    ${User-Invoked Command Count}[$C0mmandCharact3rSeq] = ${User-Invoked Command Count}[$C0mmandCharact3rSeq] + 1
  } 
  #elseif ($CommandLookupEventArgs.CommandOrigin -ne 'Runspace') 
  #{ # Command origins that are not 'Runspace' means the command was called by another command? I don't know. 
  #  ${NonUser-Invoked Command Count}[$C0mmandCharact3rSeq] = ${NonUser-Invoked Command Count}[$C0mmandCharact3rSeq] + 1
  #}
}
$ExecutionContext.SessionState.InvokeCommand.PostCommandLookupAction = ${Post-Command Lookup Action Set}
#endregion
#######################################################################
#region | CommandNotFoundAction | (Exercise Control Over Command Resolution) |
${Purge-Sessions Here-String} = @'
  (Get-PSSession).Where({
    $_.State -match 'Broken|Disconnected|Closed'
  }) | Remove-PSSession -ErrorAction 'SilentlyContinue' -Confirm:$false > $null
'@
${goog Here-String} = @'
  start msedge.exe 'https://www.google.com/'
'@
${vault Here-String} = @'
  start msedge.exe 'https://vault.bitwarden.com/#/login'
'@
${learn Here-String} = @'
  start msedge.exe 'https://learn.microsoft.com/en-us/training/paths/manage-virtualization-containers-hybrid-environment/'
'@
${General URL Here-String} = @'
  start msedge.exe $C0mmandCharact3rSeq
'@
${rmjb Here-String} = @'
  Get-Job | Remove-Job
'@
${gpu Here-String} = @'
  Purge-DownedPowerShellRemotingSessions
  $sessions = Get-PSSession
  foreach ($session in $sessions) {
    Invoke-Command -Session $session -ScriptBlock {
      gpupdate.exe
    } -AsJob
  }
'@

${gpuf Here-String} = @'
  Purge-DownedPowerShellRemotingSessions
  $sessions = Get-PSSession
  foreach ($session in $sessions) {
    Invoke-Command -Session $session -ScriptBlock {
      gpupdate.exe /force
    } -AsJob
  }
'@

${gpubf Here-String} = @'
  Purge-DownedPowerShellRemotingSessions
  $sessions = Get-PSSession
  foreach ($session in $sessions) {
    Invoke-Command -Session $session -ScriptBlock {
      gpupdate.exe /boot /force
    } -AsJob
  }
'@

${Command Not Found Action Set} = {
  param (
    $C0mmandCharact3rSeq,
    $CommandLookupEventArgs
  )

  switch -Regex ($C0mmandCharact3rSeq) 
  {
    '^Purge-Sessions$'    {
      $CommandLookupEventArgs.CommandScriptBlock = [ScriptBlock]::Create(${Purge-Sessions Here-String}).GetNewClosure()
      $CommandLookupEventArgs.StopSearch = $true
      break
    }
    '^goog$'              {
      $CommandLookupEventArgs.CommandScriptBlock = [ScriptBlock]::Create(${goog Here-String}).GetNewClosure()
      $CommandLookupEventArgs.StopSearch = $true
      break
    }
    '^vault$'             {
      $CommandLookupEventArgs.CommandScriptBlock = [ScriptBlock]::Create(${vault Here-String}).GetNewClosure()
      $CommandLookupEventArgs.StopSearch = $true
      break
    }
    '^learn$'             {
      $CommandLookupEventArgs.CommandScriptBlock = [ScriptBlock]::Create(${learn Here-String}).GetNewClosure()
      $CommandLookupEventArgs.StopSearch = $true
      break
    }
    '^[a-z]+\.(com|net)$' {
      $CommandLookupEventArgs.CommandScriptBlock = [ScriptBlock]::Create(${General URL Here-String}).GetNewClosure()
      $CommandLookupEventArgs.StopSearch = $true
      break
    }
    '^rmjb$'              {
      $CommandLookupEventArgs.CommandScriptBlock = [ScriptBlock]::Create(${rmjb Here-String}).GetNewClosure()
      $CommandLookupEventArgs.StopSearch = $true
      break
    }
    '^gpu$'               {
      $CommandLookupEventArgs.CommandScriptBlock = [ScriptBlock]::Create(${gpu Here-String}).GetNewClosure()
      $CommandLookupEventArgs.StopSearch = $true
      break
    }
    '^gpuf$'              {
      $CommandLookupEventArgs.CommandScriptBlock = [ScriptBlock]::Create(${gpuf Here-String}).GetNewClosure()
      $CommandLookupEventArgs.StopSearch = $true
      break
    }
    '^gpubf$'             {
      $CommandLookupEventArgs.CommandScriptBlock = [ScriptBlock]::Create(${gpubf Here-String}).GetNewClosure()
      $CommandLookupEventArgs.StopSearch = $true
      break
    }

    default {break}
  }
}
$ExecutionContext.SessionState.InvokeCommand.CommandNotFoundAction = ${Command Not Found Action Set}
#endregion
#######################################################################
#endregion

