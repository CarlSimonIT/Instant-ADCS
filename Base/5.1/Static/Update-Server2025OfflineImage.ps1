#Requires -Version 5.1
#Requires -PSEdition Desktop
#Requires -RunAsAdministrator

param (
  [Parameter(
    Mandatory = $true
  )]
  [ValidateSet(1,2,3,4)]
  [System.UInt16]
  ${Windows Server Image Index},

  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  ${install.wim File Path},

  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  ${Mount Directory Path},

  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  ${Package Directory Path}
)

Set-Location -Path "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\DISM"

${Function Start Time} = [DateTime]::Now

${Mount Start} = [DateTime]::Now
dism.exe /Mount-Wim /WimFile:${install.wim File Path} /Index:${Windows Server Image Index} /MountDir:${Mount Directory Path}
${Mount Finish} = [DateTime]::Now
Write-Verbose -Message "  Mount Duration for `${Windows Server Image Index} = ${Windows Server Image Index}$([System.Char]58) $((${Mount Finish} - ${Mount Start}).TotalSeconds.ToString('n3')) Seconds"

## Apply Update Package(s)
${Add-Packages Start} = [DateTime]::Now
dism.exe /Add-Package /Image:${Mount Directory Path} /PackagePath:${Package Directory Path}
${Add-Packages Finish} = [DateTime]::Now

# Unmount the volume back to install.wim on the local file system
${Commit Start} = [DateTime]::Now
Dism.exe /Unmount-Wim /MountDir:${Mount Directory Path} /Commit # /Discard
${Commit Finish} = [DateTime]::Now

${Function End Time} = [DateTime]::Now
${Function TimeSpan} = ${Function End Time} - ${Function Start Time}
$min = ${Function TimeSpan}.Minutes
$sec = ${Function TimeSpan}.Seconds
Write-Verbose -Message "  Function total duration on `$index = $index$([System.Char]58) $($min)m$($sec)s"

