Write-Host -Object "`n  Installing PowerShell 7 in machine scope with script available at 'https://aka.ms/install-powershell.ps1'.  " -ForegroundColor ([System.ConsoleColor]::DarkMagenta)
${Executed Command} = @'
    ${Command Here-String} = -join $(
      "& {`n"
      "  `$InstallScript = Invoke-RestMethod $([System.Char]39)https://aka.ms/install-powershell.ps1$([System.Char]39)`n"
      "  `$InstallScriptBlock = [ScriptBlock]::Create(`$InstallScript)`n"
      "  `$Command = $([System.Char]34)& `$InstallScriptBlock -useMSI -Quiet -AddToPath -EnablePSRemoting -Destination `$env:ProgramFiles$([System.Char]34)`n"
      "}`n"
    )
    $Command = [ScriptBlock]::Create(${Command Here-String})

    ${Win32_Product Name} = Get-CimInstance -ClassName 'Win32_Product' `
    | Where-Object -FilterScript {$_.Name -eq 'PowerShell 7-x64'} `
    | Select-Object -ExpandProperty 'Name'

    if (${Win32_Product Name} -eq $null) {
      Start-Process powershell.exe $Command -Verb 'RunAs' -WindowStyle 'Hidden'

      Write-Host -Object "`n  Registering the PowerShell 7 event log provider: " -ForegroundColor ([System.ConsoleColor]::DarkRed)
      ${Command Here-String} = -join $(
        "& {`n"
        "  $([System.Char]34)`$PSHOME\RegisterManifest.ps1 -Verbose$([System.Char]34)`n"
        "}`n"
      )
      $Command = [ScriptBlock]::Create(${Command Here-String})

      Start-Process -FilePath "$env:ProgramFiles\PowerShell\7\pwsh.exe" $Command -Verb 'RunAs' -WindowStyle 'Normal'
    }
'@
Write-Host -Object "  Literal text representation of command being executed is:`n" -ForegroundColor ([System.ConsoleColor]::DarkMagenta)
Write-Host -Object ${Executed Command} -ForegroundColor ([System.ConsoleColor]::DarkYellow)
Write-Host -Object "`n  Supply admin credentials when the UAC prompt appears:`n  " -ForegroundColor ([System.ConsoleColor]::DarkMagenta)
pause

${Command Here-String} = $(
  "& {`n"
  "  `$InstallScript = Invoke-RestMethod $([System.Char]39)https://aka.ms/install-powershell.ps1$([System.Char]39)`n"
  "  `$InstallScriptBlock = [ScriptBlock]::Create(`$InstallScript)`n"
  "  `$Command = $([System.Char]34)& `$InstallScriptBlock -useMSI -Quiet -AddToPath -EnablePSRemoting -Destination `$env:ProgramFiles$([System.Char]34)`n"
  "}`n"
) -join ''
$Command = [ScriptBlock]::Create(${Command Here-String})

${Win32_Product Name} = Get-CimInstance -ClassName 'Win32_Product' `
| Where-Object -FilterScript {$_.Name -eq 'PowerShell 7-x64'} `
| Select-Object -ExpandProperty 'Name'

if (${Win32_Product Name} -eq $null) {
  Start-Process powershell.exe $Command -Verb 'RunAs' -WindowStyle 'Hidden' -Wait

  Write-Host -Object "`n  Registering the PowerShell 7 event log provider: " -ForegroundColor ([System.ConsoleColor]::DarkRed)
  ${Command Here-String} = $(
    "& {`n"
    "  $([System.Char]34)`$PSHOME\RegisterManifest.ps1 -Verbose$([System.Char]34)`n"
    "}`n"
  ) -join ''
  $Command = [ScriptBlock]::Create(${Command Here-String})

  Start-Process -FilePath "$env:ProgramFiles\PowerShell\7\pwsh.exe" $Command -Verb 'RunAs' -WindowStyle 'Hidden' -Wait
}