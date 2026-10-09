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
<# IMPORTANT |
  No restrictions are placed on who can upload code to PSGallery. 
  While PSGallery is a secure source for software, it is NOT a source for secure software.
  Microsoft never portrayed PSGallery as an online repository to be trusted. 
  Therefore, the PowerShell Gallery is as trustworthy as any other location on the public Internet. 
#>
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

