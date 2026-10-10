#Requires -Version 5.1
#Requires -PSEdition Desktop



[CmdletBinding()]
param (
  #region | External Storage Media |
  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  ${usb0 FriendlyName},

  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  ${usb0 UniqueId Raw},

  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  ${usb0 SerialNumber},

  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  ${usb1 FriendlyName},

  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  ${usb1 UniqueId Raw},

  [Parameter(
    Mandatory = $true
  )]
  [System.String]
  ${usb1 SerialNumber}
  #endregion
)

#region | External Storage Media Drive Letters |
${External Storage Media Drive Letters Precursor} = Get-Content -Path "$PSScriptRoot\Precursors\External Storage Media Drive Letters Precursor.ps1"
${External Storage Media Drive Letters} = ${External Storage Media Drive Letters Precursor} `
  -replace '%_usb0 FriendlyName_%',${usb0 FriendlyName} `
  -replace '%_usb0 UniqueId Raw_%',${usb0 UniqueId Raw} `
  -replace '%_usb0 SerialNumber_%',${usb0 SerialNumber} `
  -replace '%_usb1 FriendlyName_%',${usb1 FriendlyName} `
  -replace '%_usb1 UniqueId Raw_%',${usb1 UniqueId Raw} `
  -replace '%_usb1 SerialNumber_%',${usb1 SerialNumber}
Set-Content -Path "$PSScriptRoot\..\..\${New Windows PowerShell Base Folder PARTIAL Path}\External Storage Media Drive Letters.ps1" -Value (${External Storage Media Drive Letters})
#endregion
