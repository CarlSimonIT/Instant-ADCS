#region | PSDefaultParameterValues | Other automatic variables | Preference Variables |
#$PSDefaultParameterValues['Invoke-Command:HideComputerName']   = $true
#$PSDefaultParameterValues['Invoke-Command:ThrottleLimit']      = 33
#$PSDefaultParameterValues['Remove-Item:Verbose']               = $true
#$PSDefaultParameterValues['Move-Item:Verbose']                 = $true

$PSDefaultParameterValues['Test-Connection:Count'] = 1

$PSDefaultParameterValues['Format-Table:AutoSize'] = {
  switch ($Host.Name) {
    'ConsoleHost'             {
      return $true
      break
    }
    'Visual Studio Code Host' {
      return $true
      break
    }
    'ServerRemoteHost'        {
      return $true
      break
    }
    default {
      Write-Host -Object "Holy shit, take a look at the `$PSDefaultParameterValues entry for Format-Table:Autosize. This is a PowerShell host I haven't seen before"
    }
  }
}

$PSDefaultParameterValues['Import-Module:DisableNameChecking']        =      $true
#$PSDefaultParameterValues['Select-Object:ExcludeProperty']           =      'RunspaceId'

$MaximumHistoryCount = [System.Int16]::MaxValue
$MaximumErrorCount   = [System.Int16]::MaxValue
#endregion

