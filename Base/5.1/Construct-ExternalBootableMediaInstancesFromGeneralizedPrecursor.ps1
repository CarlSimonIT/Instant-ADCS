#Requires -Version 5.1
#Requires -PSEdition Desktop


[CmdletBinding()]
param (
  #region | External Storage Media |
  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  ${OSDeploy FriendlyName},

  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  ${OSDeploy UniqueId Raw},

  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  ${OSDeploy SerialNumber},
  #endregion

  #region | Location for ofautput content inside '.\output' directory of project root |
  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  ${New Windows PowerShell Base Folder PARTIAL Path}
  #endregion
)

Write-Host -Object 'External Bootable Media Drive Letters'
pause

#region | External Bootable Media Drive Letters |
${External Bootable Media Drive Letters Precursor} = Get-Content -Path "$PSScriptRoot\Precursors\External Bootable Media Drive Letters Precursor.ps1"
${External Bootable Media Drive Letters} = ${External Bootable Media Drive Letters Precursor} `
  -replace '%_OSDeploy FriendlyName_%',${OSDeploy FriendlyName} `
  -replace '%_OSDeploy UniqueId Raw_%',${OSDeploy UniqueId Raw} `
  -replace '%_OSDeploy SerialNumber_%',${OSDeploy SerialNumber}
Set-Content -Path "$PSScriptRoot\..\..\${New Windows PowerShell Base Folder PARTIAL Path}\External Bootable Media Drive Letters.ps1" -Value (${External Bootable Media Drive Letters})
#endregion
