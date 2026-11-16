#Requires -Version 5.1
#Requires -PSEdition Desktop

param (
  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  ${Target Get-XDayOfMonth.ps1 File Path},

  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  ${SHA256 of Get-XDayOfMonth.ps1 File}
)

Set-StrictMode -Version 'Latest'

${Target Get-XDayOfMonth.ps1 File} = [System.IO.FileInfo]${Target Get-XDayOfMonth.ps1 File Path}

$hash = ${SHA256 of Get-XDayOfMonth.ps1 File}
${Local Get-XDayOfMonth.ps1 File} = Get-ChildItem -Path "$PSScriptRoot\..\output" -Recurse -File `
| Where-Object -PipelineVariable 'file' -FilterScript {$_.Name -eq 'Get-XDayOfMonth.ps1'} `
| ForEach-Object -Process {Get-FileHash -Path $file.FullName -Algorithm 'SHA256' `
| Where-Object -PipelineVariable 'AlgoHashPath' -FilterScript {$_.Hash -eq $hash} `
| ForEach-Object -Process {Get-Item -Path $AlgoHashPath.Path}} `
| Sort-Object -Property 'LastWriteTime' -Descending `
| Select-Object -First 1

if ($null -ne ${Local Get-XDayOfMonth.ps1 File}) {
  Copy-Item -Path ${Local Get-XDayOfMonth.ps1 File}.FullName -Destination ${Target Get-XDayOfMonth.ps1 File}.DirectoryName
} else {
  $Uri = 'https://gist.githubusercontent.com/andyzib/22c4732627ae9a1d3f1776374980ec9c/raw/6442a572cbf096b62004c30097cd1aac1e99d18a/Get-XDayOfMonth.ps1'
  do {
    Invoke-WebRequest -Uri $Uri -OutFile ${Target Get-XDayOfMonth.ps1 File}.FullName
    Start-Sleep 5
  } until ({
    $IsPresent = Test-Path -Path ${Target Get-XDayOfMonth.ps1 File}.FullName
    return $IsPresent
  })
}
. ${Target Get-XDayOfMonth.ps1 File}

$HT = @{
  Find    = 'Second'
  Weekday = 'Tuesday'
  Month   = $([System.String]::Format('{0:MM}',[System.DateTime]::Now))
  Year    = $([System.String]::Format('{0:yyyy}',[System.DateTime]::Now))
}
${Patch Tuesday Of This Month} = Get-XDayOfMonth @HT

return @{
  'Patch Tuesday Of This Month' = ${Patch Tuesday Of This Month}
}