#Requires -Version 5.1
#Requires -PSEdition Desktop

param (
  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  ${SHA256 of Windows Server 2025 ISO File},

  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  ${SHA256 of WinPE 2026-09 EXE File},

  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  ${SHA256 of Windows ADK 2026-09 EXE File},

  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  $EmailAddressOfBitwardenAccount,

  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  $BadPassword = 'BadPassword!',

  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  $FolderFQN
)

Export-CliXml -Path "$PSScriptRoot\..\..\.CommonItems\SHA256 of Windows Server 2025 ISO File.clixml" -InputObject (${SHA256 of Windows Server 2025 ISO File})
Export-CliXml -Path "$PSScriptRoot\..\..\.CommonItems\SHA256 of WinPE 2026-09 EXE File.clixml" -InputObject (${SHA256 of WinPE 2026-09 EXE File})
Export-CliXml -Path "$PSScriptRoot\..\..\.CommonItems\SHA256 of Windows ADK 2026-09 EXE File.clixml" -InputObject (${SHA256 of Windows ADK 2026-09 EXE File})
Export-CliXml -Path "$PSScriptRoot\..\..\.CommonItems\EmailAddressOfBitwardenAccount.clixml" -InputObject ($EmailAddressOfBitwardenAccount)
<# Note |
  Fully Qualified Name (FQN) of the Folder object in the Bitwarden 
  Vault that contains the secure strings for this project follows
  the NAME of the project: $FolderFQN
#>
Export-CliXml -Path "$PSScriptRoot\..\..\.CommonItems\BadPassword.clixml" -InputObject ($BadPassword)
Export-CliXml -Path "$PSScriptRoot\..\..\.CommonItems\FolderFQN.clixml" -InputObject ($FolderFQN)

${Full Computer Name} = Get-ItemPropertyValue -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Tcpip\Parameters" -Name 'HostName'
Export-CliXml -Path "$PSScriptRoot\..\..\.CommonItems\Full Computer Name.clixml" -InputObject (${Full Computer Name})


#region | As of 26H2 it appears that an elevated security context requires finding the owner of a process |
<# The commented-out code within now requires a powershell.exe session running at Integrity Level-High, it seems |
  Write-Host -Object "  Determine the type of Windows installation."
  ${Windows Installation Type} = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name 'InstallationType' | Select-Object -ExpandProperty 'InstallationType'
  Write-Host -Object "  `${Windows Installation Type} = ${Windows Installation Type}"

  if (${Windows Installation Type} -eq 'Server Core') {
    Write-Host -Object "  Exiting because this instance of Windows is Server Core"
    break
  }

  Write-Host -Object "  Initialize and set to `$null a variable that will hold the object representing explorer.exe process"
  $_Var_Name = 'explorer.exe Process'
  try {Clear-Variable -Name $_Var_Name -ErrorAction 'Stop'} catch {New-Variable -Name $_Var_Name -Value $null}

  Write-Host -Object "  Get Windows RDS Session number for the current interactive logon session."
  $UserTerminalSessionID = Get-Process -Id ([System.Diagnostics.Process]::GetCurrentProcess().Id) | Select-Object -ExpandProperty 'SessionId'
  Write-Host -Object "  `$UserTerminalSessionID = $UserTerminalSessionID"

  Write-Host -Object "  Save to recently initialized variable the object representing explorer.exe"
  Set-Variable -Name $_Var_Name -Value $(
    Get-CimInstance -ClassName 'Win32_Process' -Filter "Name = 'explorer.exe' and SessionId = '$UserTerminalSessionID'" -Verbose:$false `
    | Sort-Object 'ProcessId' `
    | Select-Object -First 1
  )

  Write-Host -Object "  Initialize and set to `$null a variable that will hold the UserName of the account that owns the explorer.exe process"
  $_Var_Name = 'explorer.exe Owner'
  try {Clear-Variable -Name $_Var_Name -ErrorAction 'Stop'} catch {New-Variable -Name $_Var_Name -Value $null}

  Write-Host -Object "  Save to recently initialized variable the UserName of the account that owns the explorer.exe process"
  Set-Variable -Name $_Var_Name -Value $(
    Invoke-CimMethod -InputObject ${explorer.exe Process} -MethodName 'GetOwner' -Verbose:$false `
    | Select-Object -ExpandProperty 'User'
  )
#>


#region | user session awareness |
<#
  ${Windows Installation Type} = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name 'InstallationType' `
  | Select-Object -ExpandProperty 'InstallationType'

  if (${Windows Installation Type} -eq 'Server Core') {
    Write-Host -Object "  Exiting because this instance of Windows is Server Core"
    break
  }

  $_Var_Name = 'explorer.exe Process'
  try {Clear-Variable -Name $_Var_Name -ErrorAction 'Stop'} catch {New-Variable -Name $_Var_Name -Value $null}
  $UserTerminalSessionID = Get-Process -Id ([System.Diagnostics.Process]::GetCurrentProcess().Id) | Select-Object -ExpandProperty 'SessionId'
  Set-Variable -Name $_Var_Name -Value $(
    Get-CimInstance -ClassName 'Win32_Process' -Filter "Name = 'explorer.exe' and SessionId = '$UserTerminalSessionID'" -Verbose:$false `
    | Sort-Object 'ProcessId' `
    | Select-Object -First 1
  )

  $_Var_Name = 'explorer.exe Owner'
  try {Clear-Variable -Name $_Var_Name -ErrorAction 'Stop'} catch {New-Variable -Name $_Var_Name -Value $null}

  Set-Variable -Name $_Var_Name -Value $(
    ${explorer.exe Owner Precursor} = Get-Process -PID ${explorer.exe Process}.ProcessId -IncludeUserName `
    | Select-Object -ExpandProperty 'UserName'
    ${explorer.exe Owner Precursor} -match '^(?<Computer_Name>.+)\\(?<User_Name>.+)$' > $null
    $Matches['User_Name']
  )
#>

<#
  & {
    ${Windows Installation Type} = Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion" -Name 'InstallationType' `
    | Select-Object -ExpandProperty 'InstallationType'

    if (${Windows Installation Type} -eq 'Server Core') {
      Write-Host -Object "  Exiting because this instance of Windows is Server Core"
      break
    }

    $_Var_Name = 'explorer.exe Process'
    try {Clear-Variable -Name $_Var_Name -ErrorAction 'Stop'} catch {New-Variable -Name $_Var_Name -Value $null}
    $UserTerminalSessionID = Get-Process -Id ([System.Diagnostics.Process]::GetCurrentProcess().Id) | Select-Object -ExpandProperty 'SessionId'
    Set-Variable -Name $_Var_Name -Value $(
      Get-CimInstance -ClassName 'Win32_Process' -Filter "Name = 'explorer.exe' and SessionId = '$UserTerminalSessionID'" -Verbose:$false `
      | Sort-Object 'ProcessId' `
      | Select-Object -First 1
    )

    $_Var_Name = 'explorer.exe Owner'
    try {Clear-Variable -Name $_Var_Name -ErrorAction 'Stop'} catch {New-Variable -Name $_Var_Name -Value $null}

    Set-Variable -Name $_Var_Name -Value $(
      ${explorer.exe Owner Precursor} = Get-Process -PID ${explorer.exe Process}.ProcessId -IncludeUserName `
      | Select-Object -ExpandProperty 'UserName'
      ${explorer.exe Owner Precursor} -match '^(?<Computer_Name>.+)\\(?<User_Name>.+)$' > $null
      $Matches['User_Name']
    )

    Export-CliXml -Path "$PSScriptRoot\..\..\.CommonItems\explorer.exe Owner.clixml" -InputObject (${explorer.exe Owner})
  }
#>
#endregion

$IsPresent = Test-Path -Path "$PSScriptRoot\..\..\.CommonItems\explorer.exe Owner.clixml"
if (-not $IsPresent) {
  ${explorer.exe Owner CliXml File Path} = "$PSScriptRoot\..\..\.CommonItems\explorer.exe Owner.clixml"
  ${Command Here-String} = $(
    "  & {`n"
    "    `${Windows Installation Type} = Get-ItemProperty -Path $([System.Char]34)HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion$([System.Char]34) -Name $([System.Char]39)InstallationType$([System.Char]39) $([System.Char]96)`n"
    "    | Select-Object -ExpandProperty $([System.Char]39)InstallationType$([System.Char]39)`n"
    "  `n"
    "    if (`${Windows Installation Type} -eq $([System.Char]39)Server Core$([System.Char]39)) {`n"
    "      Write-Host -Object $([System.Char]34)  Exiting because this instance of Windows is Server Core$([System.Char]34)`n"
    "      break`n"
    "    }`n"
    "  `n"
    "    `$_Var_Name = $([System.Char]39)explorer.exe Process$([System.Char]39)`n"
    "    try {Clear-Variable -Name `$_Var_Name -ErrorAction $([System.Char]39)Stop$([System.Char]39)} catch {New-Variable -Name `$_Var_Name -Value `$null}`n"
    "    `$UserTerminalSessionID = Get-Process -Id ([System.Diagnostics.Process]::GetCurrentProcess().Id) | Select-Object -ExpandProperty $([System.Char]39)SessionId$([System.Char]39)`n"
    "    Set-Variable -Name `$_Var_Name -Value `$(`n"
    "      Get-CimInstance -ClassName $([System.Char]39)Win32_Process$([System.Char]39) -Filter $([System.Char]34)Name = $([System.Char]39)explorer.exe$([System.Char]39) and SessionId = $([System.Char]39)`$UserTerminalSessionID$([System.Char]39)$([System.Char]34) -Verbose:`$false $([System.Char]96)`n"
    "      | Sort-Object $([System.Char]39)ProcessId$([System.Char]39) $([System.Char]96)`n"
    "      | Select-Object -First 1`n"
    "    )`n"
    "  `n"
    "    `$_Var_Name = $([System.Char]39)explorer.exe Owner$([System.Char]39)`n"
    "    try {Clear-Variable -Name `$_Var_Name -ErrorAction $([System.Char]39)Stop$([System.Char]39)} catch {New-Variable -Name `$_Var_Name -Value `$null}`n"
    "  `n"
    "    Set-Variable -Name `$_Var_Name -Value `$(`n"
    "      `${explorer.exe Owner Precursor} = Get-Process -PID `${explorer.exe Process}.ProcessId -IncludeUserName $([System.Char]96)`n"
    "      | Select-Object -ExpandProperty $([System.Char]39)UserName$([System.Char]39)`n"
    "      `${explorer.exe Owner Precursor} -match $([System.Char]39)^(?<Computer_Name>.+)\\(?<User_Name>.+)`$$([System.Char]39) > `$null`n"
    "      `$Matches[$([System.Char]39)User_Name$([System.Char]39)]`n"
    "    )`n"
    "  `n"
    "    Export-CliXml -Path $([System.Char]34)${explorer.exe Owner CliXml File Path}$([System.Char]34) -InputObject (`${explorer.exe Owner})`n"
    "  }`n"
  ) -join ''

  ${Command Script Path} = "$env:Temp\Find Explorer.exe Owner.ps1"
  Set-Content -Path ${Command Script Path} -Value ${Command Here-String}

  Start-Process -ArgumentList @(
    "Get-Item -Path '${Command Script Path}' | Get-Content -Raw | Invoke-Expression"
  ) -FilePath powershell.exe -Verb 'RunAs' -Wait
}



#endregion
