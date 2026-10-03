#region | Resolve Owner of explorer.exe process for user session awareness |
if (${Computer Info Lite}.WindowsInstallationType -ne 'Server Core') {
  $_Var_Name = 'explorer.exe Process'
  try {Clear-Variable -Name $_Var_Name -ErrorAction 'Stop'} catch {New-Variable -Name $_Var_Name -Value $null}

  $UserTerminalSessionID = Get-Process -Id ${Computer Info Lite}.PowerShellInstancePID | % 'SessionId'
  Set-Variable -Name $_Var_Name -Value $(
    Get-CimInstance -ClassName 'Win32_Process' -Filter "Name = 'explorer.exe' and SessionId = '$UserTerminalSessionID'" `
    | Sort-Object 'ProcessId' `
    | Select-Object -First 1
  )

  # This 'if' statement below is included because remote connections into an instance of Desktop Experience would not own explorer.exe
  if ($null -ne ${explorer.exe Process}) {
    $_Var_Name = 'explorer.exe Owner'
    try {Clear-Variable -Name $_Var_Name -ErrorAction 'Stop'} catch {New-Variable -Name $_Var_Name -Value $null}

    Set-Variable -Name $_Var_Name -Value $(
      Invoke-CimMethod -InputObject ${explorer.exe Process} -MethodName 'GetOwner' `
      | Select-Object -ExpandProperty 'User'
    )
  }
}
#endregion

