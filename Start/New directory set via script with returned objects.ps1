#Requires -Version 5.1
#Requires -PSEdition Desktop

param (
  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  ${Offline WU-Original Server 2025 Folder Path}, 

  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  ${Offline WU-Patched Server 2025 Folder Path},

  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  ${WinPE Installs Path}
)

Set-StrictMode -Version 'Latest'

$path = ${Offline WU-Original Server 2025 Folder Path}
${Offline WU-Original Server 2025 Folder} = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}

$path = ${Offline WU-Patched Server 2025 Folder Path}
${Offline WU-Patched Server 2025 Folder} = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}

$path = "${WinPE Installs Path}\ADK + WinPE (2026-09)"
#$AppFolder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
${Apps for OS Image Prep Folder} = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}

return @{
  'Offline WU-Original Server 2025 Folder' = ${Offline WU-Original Server 2025 Folder}
  'Offline WU-Patched Server 2025 Folder'  = ${Offline WU-Patched Server 2025 Folder}
  #'AppFolder'                             = $AppFolder
  'Apps for OS Image Prep Folder'          = ${Apps for OS Image Prep Folder}
}