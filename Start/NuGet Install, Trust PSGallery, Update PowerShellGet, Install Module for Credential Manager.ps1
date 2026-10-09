#Requires -Version 5.1
#Requires -PSEdition Desktop


#region | Install an appropriately up-to-date version of the NuGet package provider  |
$PackageManagerName = (Get-PackageProvider).Where({$_.Name -eq 'NuGet'}).Name
${NuGet Needs To Be Installed} = $PackageManagerName -eq $null
if (${NuGet Needs To Be Installed}) {
  ${Install NuGet Command Here-String} = $(
    "#Requires -Version 5.1`n"
    "#Requires -PSEdition Desktop`n"
    "#Requires -RunAsAdministrator`n"
    "`n"
    "& {`n"
    "  Install-PackageProvider -Name $([System.Char]39)NuGet$([System.Char]39) -Scope $([System.Char]39)AllUsers$([System.Char]39) -MinimumVersion $([System.Char]39)2.8.5.208$([System.Char]39) -Force | Format-Table -AutoSize`n"
    "}`n"
  ) -join ''
  ${Install NuGet ScriptBlock} = [ScriptBlock]::Create(${Install NuGet Command Here-String})
  
  Start-Process -FilePath powershell.exe -ArgumentList ${Install NuGet ScriptBlock} -Wait -Verb 'RunAs' -WindowStyle 'Hidden'
}
#endregion

#region | Set the PowerShell Gallery (PSGallery) as a trusted repository for PowerShell modules |
$Repository = 'PSGallery'
$InstallationPolicy = (Get-PSRepository -Name $Repository).InstallationPolicy
if ($InstallationPolicy -eq 'Untrusted') {
  Set-PSRepository -Name $Repository -InstallationPolicy 'Trusted' -Verbose:$true
}
#endregion

#region | Deduce version of PowerShellGet and install if built-in version is still present |
$PSModuleInfo = Import-Module -Name 'PowerShellGet' -Force -PassThru
$PowerShellGetVersion = Get-Module -Name 'PowerShellGet' | Select-Object -ExpandProperty 'Version'
${PowerShellGet Needs to be Updated} = "$PowerShellGetVersion" -eq '1.0.0.1'
if (${PowerShellGet Needs to be Updated}) {
  ${Update PowerShellGet Command Here-String} = $(
    "#Requires -Version 5.1`n"
    "#Requires -PSEdition Desktop`n"
    "#Requires -RunAsAdministrator`n"
    "`n"
    "& {`n"
    "  Install-Module -Name $([System.Char]39)PowerShellGet$([System.Char]39) -Scope $([System.Char]39)AllUsers$([System.Char]39) -Force -AllowClobber`n"
    "  Update-Module -Name $([System.Char]39)PowerShellGet$([System.Char]39) -Force`n"
    "}`n"
  ) -join ''
  ${Update PowerShellGet ScriptBlock} = [ScriptBlock]::Create(${Update PowerShellGet Command Here-String})
  Start-Process -FilePath powershell.exe -ArgumentList ${Update PowerShellGet ScriptBlock} -Wait -Verb 'RunAs' -WindowStyle 'Hidden'
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
  ${PSCustomObject InstalledModule} = Get-InstalledModule -Name $ModuleName -ErrorAction 'Stop' -Verbose:$false
  # For some reason the 'TUN.CredentialManager' isn't detectable by Get-InstalledModule, Import-Module, Get-Module, etc. 

} catch {
  Install-Module -Name $ModuleName @InstallModuleHT
}
#endregion




<# IMPORTANT |
  No restrictions are placed on who can upload code to the PowerShell Gallery. 
  Microsoft never portrayed the PowerShell Gallery as a secure source of software. 
  The PowerShell Gallery is as trustworthy as any other location on the public Internet. 

  https://learn.microsoft.com/en-us/powershell/module/packagemanagement/get-packageprovider?view=powershellget-2.x

  https://learn.microsoft.com/en-us/powershell/module/packagemanagement/install-packageprovider?view=powershellget-2.x&viewFallbackFrom=powershellget-3.x

  https://learn.microsoft.com/en-us/powershell/module/powershellget/?view=powershellget-2.x
  
  https://www.thomasmaurer.ch/2019/02/update-powershellget-and-packagemanagement/
#>


<#
  #region | Install the NuGet package provider in scope of current user |
  $PackageManagerName = (Get-PackageProvider).Where({$_.Name -eq 'NuGet'}).Name
  ${NuGet Needs To Be Installed} = $PackageManagerName -eq $null
  if (${NuGet Needs To Be Installed}) {
    Install-PackageProvider -Name 'NuGet' -Scope 'CurrentUser' -MinimumVersion '2.8.5.201' -Force | Format-Table -AutoSize
  }
  #endregion

  #region | Set the PowerShell Gallery (PSGallery) as a trusted repository for PowerShell modules |
  $Repository = 'PSGallery'
  $InstallationPolicy = (Get-PSRepository -Name $Repository).InstallationPolicy
  if ($InstallationPolicy -eq 'Untrusted') {
    Set-PSRepository -Name $Repository -InstallationPolicy 'Trusted' -Verbose:$true
  }
  #endregion

  #region | Deduce version of PowerShellGet and install if built-in version is still present |
  $PSModuleInfo = Import-Module -Name 'PowerShellGet' -Force -PassThru
  $PowerShellGetVersion = Get-Module -Name 'PowerShellGet' | Select-Object -ExpandProperty 'Version'
  $IsUpdated = "$PowerShellGetVersion" -ne '1.0.0.1'
  if (-not $IsUpdated) {
    Install-Module -Name 'PowerShellGet' -Scope 'AllUsers' -Force -AllowClobber
    Update-Module -Name 'PowerShellGet'
  }

  #endregion

#>
