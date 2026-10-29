#Requires -Version 5.1
#Requires -PSEdition Desktop

#region | Install an appropriately up-to-date version of the NuGet package provider  |
#$PackageManagerName = (Get-PackageProvider).Where({$_.Name -eq 'NuGet'}).Name
$PackageProviders = Get-PackageProvider
$NuGetPackageProvider = Get-PackageProvider | Where-Object -FilterScript {$_.Name -eq 'NuGet'}

${NuGet Needs To Be Installed} = $NuGetPackageProvider -eq $null
if (${NuGet Needs To Be Installed}) {
  ${Install NuGet Command Here-String} = $(
    #region | Hashtag Requires structures-Do not delete |
    "#Requires -Version 5.1`n"
    "#Requires -PSEdition Desktop`n"
    "#Requires -RunAsAdministrator`n"
    "`n"
    "`n"
    #endregion
    #region |  |
    "`n"
    "& {Install-PackageProvider -Name $([System.Char]39)NuGet$([System.Char]39) -Scope $([System.Char]39)AllUsers$([System.Char]39) -MinimumVersion $([System.Char]39)2.8.5.208$([System.Char]39) -Force | Format-Table -AutoSize}`n"
    "`t`t"
    #endregion
    { # Above lines generated with 'ConvertTo-HereStringPrecursor' function provided by importin 'HereStringConversionModule.psm1' module inside '.\A0\' folder |
      & {Install-PackageProvider -Name 'NuGet' -Scope 'AllUsers' -MinimumVersion '2.8.5.208' -Force | Format-Table -AutoSize}
    } | Out-Null
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

<#
  $Repository = 'PSGallery'
  $InstallationPolicy = (Get-PSRepository -Name $Repository).InstallationPolicy
  if ($InstallationPolicy -eq 'Untrusted') {
    Set-PSRepository -Name $Repository -InstallationPolicy 'Trusted' -Verbose:$true
  }
#>

$Repository = 'PSGallery'
$IsTrusted = (Get-PSRepository -Name $Repository).Trusted
if (-not $IsTrusted) {
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

#region | Install 'TUN.CredentialManager' and 'MSCatalog' modules for Windows PowerShell in 'AllUsers' scope |
${Name Of Windows PowerShell Module from PSGallery} = 'TUN.CredentialManager'
${Install PowerShell 5.1 Modules from PSGallery in AllUsers Scope Command Here-String} = $(
  #region | Hashtag Requires structures-Do not delete |
  "#Requires -Version 5.1`n"
  "#Requires -PSEdition Desktop`n"
  "#Requires -RunAsAdministrator`n"
  "`n"
  "`n"
  #endregion
  #region |  |
  "`n"
  "& {`n"
  "  Set-ExecutionPolicy -ExecutionPolicy $([System.Char]39)RemoteSigned$([System.Char]39) -Scope $([System.Char]39)Process$([System.Char]39) -Force`n"
  "  Import-Module $([System.Char]39)PowerShellGet$([System.Char]39) -MinimumVersion $([System.Char]39)2.2.5$([System.Char]39)`n"
  "  `$InstallModuleHT = @{`n"
  "    Name       = $([System.Char]34)${Name Of Windows PowerShell Module from PSGallery}$([System.Char]34)`n"
  "    Scope      = $([System.Char]39)AllUsers$([System.Char]39)`n"
  "    Repository = $([System.Char]39)PSGallery$([System.Char]39)`n"
  "    Verbose    = `$true`n"
  "    Force      = `$true`n"
  "  }`n"
  "  Install-Module @InstallModuleHT`n"
  "}`n"
  "`t`t"
  #endregion
  { # Above lines generated with 'ConvertTo-HereStringPrecursor' function provided by importing 'HereStringConversionModule.psm1' module inside '.\A0\' folder |
    & {
      Set-ExecutionPolicy -ExecutionPolicy 'RemoteSigned' -Scope 'Process' -Force
      Import-Module 'PowerShellGet' -MinimumVersion '2.2.5'
      $InstallModuleHT = @{
        Name       = "${Name Of Windows PowerShell Module from PSGallery}"
        Scope      = 'AllUsers'
        Repository = 'PSGallery'
        Verbose    = $true
        Force      = $true
      }
      Install-Module @InstallModuleHT
    }
  } | Out-Null
) -join ''

${Install PowerShell 5.1 Modules from PSGallery in AllUsers Scope Script Path} = "$env:Temp\Install PowerShell 5.1 Modules from PSGallery in AllUsers Scope Script.ps1"
Set-Content -Path ${Install PowerShell 5.1 Modules from PSGallery in AllUsers Scope Script Path} -Value ${Install PowerShell 5.1 Modules from PSGallery in AllUsers Scope Command Here-String}
${PSCustomObject InstalledModule} = Get-InstalledModule -Name ${Name Of Windows PowerShell Module from PSGallery} -ErrorAction 'SilentlyContinue' -Verbose:$false

if (${PSCustomObject InstalledModule} -eq $null) {
  Start-Process -ArgumentList @(
    "Get-Item -Path '${Install PowerShell 5.1 Modules from PSGallery in AllUsers Scope Script Path}' | Get-Content -Raw | Invoke-Expression"
  ) -FilePath powershell.exe -Verb 'RunAs' -Wait
}
#endregion

