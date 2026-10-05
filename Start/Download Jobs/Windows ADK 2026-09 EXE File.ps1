#Requires -Version 5.1
#Requires -PSEdition Desktop







<# Windows ADK 10.1.26100.9457 (September 2026) |
  'https://learn.microsoft.com/en-us/windows-hardware/get-started/adk-install'
#>


$FolderFQN = Import-CliXml -Path "$PSScriptRoot\..\..\..\.CommonItems\FolderFQN.clixml"
${SHA256 of Windows ADK 2026-09 EXE File} = Import-CliXml -Path "$PSScriptRoot\..\..\..\.CommonItems\SHA256 of Windows ADK 2026-09 EXE File.clixml"
$path = "$PSScriptRoot\..\..\..\.CommonItems\usb0\$FolderFQN\cfg\installs\Windows ADK 2026-09"
$folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
${Windows ADK 2026-09 EXE File} = Get-ChildItem -Path "$folder" -File | Where-Object -PipelineVariable 'file' -FilterScript {$_.Extension -eq '.exe'} | ForEach-Object -Process {Get-FileHash -Path $file.FullName -Algorithm 'SHA256' | Where-Object -PipelineVariable 'AlgoHashPath' -FilterScript {$_.Hash -eq ${SHA256 of Windows ADK 2026-09 EXE File}} | ForEach-Object -Process {Get-Item -Path $AlgoHashPath.Path}} | Sort-Object -Property 'LastWriteTime' -Descending | Select-Object -First 1
if (${Windows ADK 2026-09 EXE File} -eq $null) {
  $JobName = 'Download Windows ADK 2026-09 EXE File'
  $RunningJob = Get-Job | Where-Object -FilterScript {
    $_.Name  -eq $JobName  -and `
    $_.State -eq 'Running'
  }
  if ($RunningJob -eq $null) {
    $ArgumentList = @(
      'https://go.microsoft.com/fwlink/?linkid=2289980'
      "$folder\adksetup.exe"
      $ProgressPreference
    )

    Start-Job -Name $JobName -ArgumentList $ArgumentList -ScriptBlock {
      $WebPath                    = $args[0]
      $FilePath                   = $args[1]
      $OriginalProgressPreference = $args[2]

      $ProgressPreference = 'SilentlyContinue'
      Invoke-WebRequest -Uri $WebPath -OutFile $FilePath
      $ProgressPreference = $OriginalProgressPreference
    }
  }
}

