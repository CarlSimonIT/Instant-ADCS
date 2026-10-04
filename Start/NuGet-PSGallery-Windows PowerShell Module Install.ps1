#Requires -Version 5.1
#Requires -PSEdition Desktop

#region | Install the NuGet package provider in scope of current user |
$PackageManagerName = (Get-PackageProvider).Where({$_.Name -eq 'NuGet'}).Name
${NuGet Needs To Be Installed} = $PackageManagerName -eq $null
if (${NuGet Needs To Be Installed}) {
  Install-PackageProvider -Name 'NuGet' -Scope 'CurrentUser' -MinimumVersion '2.8.5.201' -Force | Format-Table -AutoSize
}
#endregion

#region | Set the PowerShell Gallery (PSGallery) as a trusted repository for PowerShell modules |
<# IMPORTANT |
  No restrictions are placed on who can upload code to the PowerShell Gallery. 
  Microsoft never portrayed the PowerShell Gallery as a secure source of software. 
  The PowerShell Gallery is as trustworthy as any other location on the public Internet. 
#>
$Repository = 'PSGallery'
$InstallationPolicy = (Get-PSRepository -Name $Repository).InstallationPolicy
if ($InstallationPolicy -eq 'Untrusted') {
  Set-PSRepository -Name $Repository -InstallationPolicy 'Trusted' -Verbose:$true
}
#endregion

#region | Install 'TUN.CredentialManager' module for Windows PowerShell in 'CurrentUser' scope |
Write-Host -Object "  Ensuring that the 'TUN.CredentialManager' module`n  for Windows PowerShell is installed in 'CurrentUser' scope:"
$InstallModuleHT = @{
  Scope      = 'CurrentUser'
  Repository = 'PSGallery'
  Verbose    = $true
}
$ModuleName = 'TUN.CredentialManager'
try {
  ${PSCustomObject InstalledModule} = Get-InstalledModule -Name $ModuleName -ErrorAction 'Stop'
} catch {
  Install-Module -Name $ModuleName @InstallModuleHT
}
#endregion
