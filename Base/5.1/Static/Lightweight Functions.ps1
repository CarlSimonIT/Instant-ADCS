#region | Lightweight Functions |
#region | Time & Date Functions |
#function Call-DateVar {[System.String]::Format('{0:yyyy}.{0:MMdd}.{0:HH}{0:mm}.{0:ss}',[System.DateTime]::Now)}
function Call-DateVar {[System.String]::Format('{0:yyyy}.{0:MM}{0:dd}.{0:HH}{0:mm}.{0:ss}',[System.DateTime]::Now)}
Set-Alias -Name 'cdv' -Value 'Call-DateVar'
#function Call-DateVar {[System.String]::Format('{0:yyyy}.{0:MM}.{0:dd}.{0:HH}{0:mm}',[System.DateTime]::Now)}

#function Call-VersVar {[System.Version][System.String]::Format('{0:yyyy}.{0:MMdd}.{0:HH}{0:mm}.{0:ss}',[System.DateTime]::Now)}
function Call-VersVar {[System.Version][System.String]::Format('{0:yyyy}.{0:MM}{0:dd}.{0:HH}{0:mm}.{0:ss}',[System.DateTime]::Now)}
Set-Alias -Name 'cvv' -Value 'Call-VersVar'

function Call-ISO8601TimeDate {
  [System.String](Get-Date -Date $(([System.DateTime]::Now)) -Format "yyyy-MM-ddTHH-mm-ssZ")
}
#endregion

# See Windows PowerShell in Action (3rd Ed.) Chapter 01 for explanation of these two functions. 
function Quote-List {$args}
Set-Alias -Name 'ql' -Value 'Quote-List'
function Quote-String {"$args"}
Set-Alias -Name 'qs' -Value 'Quote-String'

function View-Win32Products {
  $Products = Get-CimInstance -ClassName 'Win32_Product'
  $Sorted = $Products | Sort-Object -Property 'Name'
  $FieldFilter = $Sorted | Select-Object -Property 'Name','Vendor','Version','IdentifyingNumber'
  # Out-GridView -InputObject ($FieldFilter) # WTF this doesn't work because: 
  ##  To use the Out-GridView, install Windows PowerShell ISE by using Server Manager, and then restart this application. (Could not load file or assembly 'Microsoft.PowerShell.GraphicalHost, Version=3.0.0.0, Culture=neutral, PublicKeyToken=31bf3856ad364e35' or one of its dependencies. The system cannot find the file specified.)
  $Formatted = $FieldFilter | Format-Table -AutoSize
  $Formatted
}

#region | PowerShell Remoting Session Cleanup functions |
function Get-SortedAndFormattedPowerShellRemotingSessions {
  $SortedSessions = Get-PSSession | Sort-Object -Property 'id'
  $SelectedObjects = $SortedSessions | Select-Object -Property 'Id','Name','State','ComputerName','ComputerType','ConfigurationName','Availability'
  $FormattedObjects = $SelectedObjects | Format-Table -AutoSize
  $FormattedObjects
}
New-Alias -Name 'gpsn' -Value 'Get-SortedAndFormattedPowerShellRemotingSessions'

function Remove-BrokenPowerShellRemotingSessions {
  Get-PSSession | Where-Object -FilterScript {
    $_.State -eq 'Broken'
  } | Remove-PSSession -ErrorAction 'SilentlyContinue'
}
New-Alias -Name 'rbpsn' -Value 'Remove-BrokenPowerShellRemotingSessions'

function Remove-DisconnectedPowerShellRemotingSessions {
  Get-PSSession | Where-Object -FilterScript {
    $_.State -eq 'Disconnected'
  } | Remove-PSSession -ErrorAction 'SilentlyContinue'
}
New-Alias -Name 'rdpsn' -Value 'Remove-DisconnectedPowerShellRemotingSessions'

function Remove-ClosedPowerShellRemotingSessions {
  Get-PSSession | Where-Object -FilterScript {
    $_.State -eq 'Closed'
  } | Remove-PSSession -ErrorAction 'SilentlyContinue'
}
New-Alias -Name 'rcpsn' -Value 'Remove-ClosedPowerShellRemotingSessions'

function Purge-DownedPowerShellRemotingSessions {
  (Get-PSSession).Where({
    $_.State -match 'Broken|Disconnected|Closed'
  }) | Remove-PSSession -ErrorAction 'SilentlyContinue' -Confirm:$false > $null
}
New-Alias -Name 'purge' -Value 'Purge-DownedPowerShellRemotingSessions'
#endregion


#region | Randomized Color Selection |
$RandomObject = [System.Random]::New()

${Console Output-Foreground Colors} = [System.ConsoleColor]::New() | Get-Member -Static -MemberType 'Property' | Select-Object -ExpandProperty 'Name'
function Pick-RandomForegroundColor {${Console Output-Foreground Colors}[$RandomObject.Next(0,${Console Output-Foreground Colors}.Length)]}
New-Alias -Name 'rFc' -Value 'Pick-RandomForegroundColor'

${Console Output-Background Colors} = @(
  [System.ConsoleColor]::Black
  [System.ConsoleColor]::DarkBlue
  [System.ConsoleColor]::DarkGreen
  [System.ConsoleColor]::DarkCyan
  [System.ConsoleColor]::DarkRed
  #[System.ConsoleColor]::DarkMagenta
  [System.ConsoleColor]::DarkYellow
  [System.ConsoleColor]::Gray
  [System.ConsoleColor]::DarkGray
  #[System.ConsoleColor]::Blue
  #[System.ConsoleColor]::Green
  #[System.ConsoleColor]::Cyan
  #[System.ConsoleColor]::Red
  #[System.ConsoleColor]::Magenta
  #[System.ConsoleColor]::Yellow
  #[System.ConsoleColor]::White
)
function Pick-RandomBackgroundColor {${Console Output-Background Colors}[$RandomObject.Next(0,${Console Output-Background Colors}.Length)]}
New-Alias -Name 'rBc' -Value 'Pick-RandomBackgroundColor'
#endregion

function Get-RandomFileName {[System.IO.Path]::GetRandomFileName()}
Set-Alias -Name 'grfn' -Value 'Get-RandomFileName'

#endregion

