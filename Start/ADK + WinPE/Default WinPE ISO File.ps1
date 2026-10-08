#Requires -Version 5.1
#Requires -PSEdition Desktop

param (
  $DefaultImageFolderName
)


${explorer.exe Owner} = Import-CliXml -Path "$PSScriptRoot\..\..\..\.CommonItems\explorer.exe Owner.clixml"

#region | Default WinPE ISO File |
<#
  $DefaultImageFolderName = 'Trial-00'
  ${explorer.exe Owner} = Import-CliXml -Path "${env:.CommonItems}\explorer.exe Owner.clixml"
#>

${Duplicate Uncompressed WinPE Files Here-String Precursor} = $(
  "`${WinPE Image Creation Parent Path} = $([System.Char]34)`$env:SystemDrive\Users\%_explorer_owner_%\WinPE$([System.Char]34)`n"
  "`$folder = try {`n"
  "  Get-Item -Path `${WinPE Image Creation Parent Path} -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
  "} catch {`n"
  "  New-Item -Path `${WinPE Image Creation Parent Path} -ItemType $([System.Char]39)Directory$([System.Char]39) -Force`n"
  "}`n"

  "`${WinPE x64 Tools Path} = $([System.Char]34)`${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64$([System.Char]34)`n"
  "`${WinPE Default Image Creation Path} = $([System.Char]34)`${WinPE Image Creation Parent Path}\%_DefaultImageFolderName_%$([System.Char]34)`n"
  "`${WinPE Default ISO Folder Path} = $([System.Char]34)`${WinPE Default Image Creation Path}\Default ISO$([System.Char]34)`n"
  #"copype amd64 `${WinPE Default ISO Folder Path}`n"
  "copype.cmd .\amd64\ `${WinPE Default ISO Folder Path}`n"
) -join ''
${Duplicate Uncompressed WinPE Files Here-String} = ${Duplicate Uncompressed WinPE Files Here-String Precursor} `
  -replace '%_DefaultImageFolderName_%',$DefaultImageFolderName `
  -replace '%_explorer_owner_%',${explorer.exe Owner}

#Set-Content -Path "$env:Temp\Make_WinPE_Media_Script.ps1" -Value (${Duplicate Uncompressed WinPE Files Here-String})
Set-Content -Path "$env:SystemDrive\Users\${explorer.exe Owner}\WinPE\Duplicate Uncompressed WinPE Files Script.ps1" -Value (${Duplicate Uncompressed WinPE Files Here-String})
$WorkingDirectory = "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools"
Start-Process -FilePath cmd.exe -ArgumentList @(
  #"/c $([System.Char]34)$WorkingDirectory\DandISetEnv.bat$([System.Char]34) && powershell.exe -NoProfile -ExecutionPolicy 'RemoteSigned'; Invoke-Expression -Command (Get-Content -Raw -Path '$env:TEMP\Make_WinPE_Media_Script.ps1')"
  "/c $([System.Char]34)$WorkingDirectory\DandISetEnv.bat$([System.Char]34) && powershell.exe -NoProfile -ExecutionPolicy 'RemoteSigned'; Invoke-Expression -Command (Get-Content -Raw -Path '$env:SystemDrive\Users\${explorer.exe Owner}\WinPE\Duplicate Uncompressed WinPE Files Script.ps1')"
) -Verb 'RunAs'

<#
  The following folders have now been created:
  ${WinPE Default Image Creation Path}\Default ISO\bootbins
  ${WinPE Default Image Creation Path}\Default ISO\media
  ${WinPE Default Image Creation Path}\Default ISO\mount
#>


${Compress Default WinPE Files to ISO Here-String Precursor} = $(
  "`${WinPE Image Creation Parent Path} = $([System.Char]34)`$env:SystemDrive\Users\%_explorer_owner_%\WinPE$([System.Char]34)`n"
  "`$folder = try {`n"
  "  Get-Item -Path `${WinPE Image Creation Parent Path} -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
  "} catch {`n"
  "  New-Item -Path `${WinPE Image Creation Parent Path} -ItemType $([System.Char]39)Directory$([System.Char]39) -Force`n"
  "}`n"

  "`${WinPE x64 Tools Path} = $([System.Char]34)`${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64$([System.Char]34)`n"
  "`${WinPE Default Image Creation Path} = $([System.Char]34)`${WinPE Image Creation Parent Path}\%_DefaultImageFolderName_%$([System.Char]34)`n"
  "`${WinPE Default ISO Folder Path} = $([System.Char]34)`${WinPE Default Image Creation Path}\Default ISO$([System.Char]34)`n"
  #"MakeWinPeMedia /ISO `${WinPE Default ISO Folder Path} $([System.Char]34)`${WinPE Default ISO Folder Path}\WinPE_amd64.iso$([System.Char]34)`n"
  "MakeWinPeMedia.cmd /ISO `${WinPE Default ISO Folder Path} $([System.Char]34)`${WinPE Default ISO Folder Path}\WinPE_amd64.iso$([System.Char]34)`n"
) -join ''
${Compress Default WinPE Files to ISO Here-String} = ${Compress Default WinPE Files to ISO Here-String Precursor} `
  -replace '%_DefaultImageFolderName_%',$DefaultImageFolderName `
  -replace '%_explorer_owner_%',${explorer.exe Owner}

# Set-Content -Path "$env:Temp\Make_WinPE_Media_Script.ps1" -Value (${Make WinPE Media Here-String})
Set-Content -Path "$env:SystemDrive\Users\${explorer.exe Owner}\WinPE\Compress Default WinPE Files to ISO Script.ps1" -Value (${Compress Default WinPE Files to ISO Here-String})

$WorkingDirectory = "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools"
Start-Process -FilePath cmd.exe -ArgumentList @(
  #"/c $([System.Char]34)$WorkingDirectory\DandISetEnv.bat$([System.Char]34) && powershell.exe -NoProfile -ExecutionPolicy 'RemoteSigned'; Invoke-Expression -Command (Get-Content -Raw -Path '$env:TEMP\Make_WinPE_Media_Script.ps1')"
  #"/c $([System.Char]34)$WorkingDirectory\DandISetEnv.bat$([System.Char]34) && powershell.exe -NoProfile -ExecutionPolicy 'RemoteSigned'; Invoke-Expression -Command (Get-Content -Raw -Path '$env:SystemDrive\Users\${explorer.exe Owner}\WinPE\Duplicate Uncompressed WinPE Files Script.ps1')"
  "/c $([System.Char]34)$WorkingDirectory\DandISetEnv.bat$([System.Char]34) && powershell.exe -NoProfile -ExecutionPolicy 'RemoteSigned'; Invoke-Expression -Command (Get-Content -Raw -Path '$env:SystemDrive\Users\${explorer.exe Owner}\WinPE\Compress Default WinPE Files to ISO Script.ps1')"
) -Verb 'RunAs'





#endregion

<#
  $path = "$env:SystemDrive\Users\${explorer.exe Owner}\WinPE\$DefaultImageFolderName\winpe_amd64"; 
  $folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}

  # start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/winpe-add-packages--optional-components-reference?view=windows-11'

  ${Mount Image Command Here-String Precursor} = $(
    "  & {`n"
    "    `${WinPE x64 Tools Path} = $([System.Char]34)`${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64$([System.Char]34)`n"
    "    `${WinPE Default Image Creation Path} = $([System.Char]34)`$env:SystemDrive\Users\%_explorer_owner_%\WinPE\%_DefaultImageFolderName_%$([System.Char]34)`n"
    "    `${WinPE Default ISO Folder Path} = $([System.Char]34)`${WinPE Default Image Creation Path}\Default ISO$([System.Char]34)`n"
    "    `$WinPeMount = $([System.Char]34)`${WinPE Default Image Creation Path}\mount$([System.Char]34)`n"
    "    `$PackagePath = $([System.Char]34)`${WinPE x64 Tools Path}\WinPE_OCs$([System.Char]34)`n"
    "    `$lang = $([System.Char]34)en-us$([System.Char]34)`n"
    "    `n"
    "    `$path = $([System.Char]34)`$WinPeMount$([System.Char]34)`n"
    "    `$folder = try {Get-Item -Path `$path -ErrorAction $([System.Char]39)Stop$([System.Char]39)} catch {New-Item -Path `$path -ItemType $([System.Char]39)Directory$([System.Char]39) -Force}`n"
    "    dism.exe /Mount-Image /ImageFile:$([System.Char]34)`${WinPE Default ISO Folder Path}\media\sources\boot.wim$([System.Char]34) /Index:1 /MountDir:$([System.Char]34)`${WinPE Default Image Creation Path}\winpe_amd64$([System.Char]34)`n"
    "  }`n"
  ) -join ''
  ${Mount Image Command Here-String} = ${Mount Image Command Here-String Precursor} `
    -replace '%_DefaultImageFolderName_%',$DefaultImageFolderName `
    -replace '%_explorer_owner_%',${explorer.exe Owner}

  ${Mount Image Script Path} = "$env:SystemDrive\Users\${explorer.exe Owner}\WinPE\Mount Image Script.ps1"
  Set-Content -Path ${Mount Image Script Path} -Value ${Mount Image Command Here-String}

  Start-Process -ArgumentList @(
    "Get-Item -Path '${Mount Image Script Path}' | Get-Content -Raw | Invoke-Expression"
  ) -FilePath powershell.exe -Verb 'RunAs' -WindowStyle 'Normal' # -Wait
#>

<#
  ${Command Here-String Precursor} = $(
    "  & {`n"
    "    `${WinPE x64 Tools Path} = $([System.Char]34)`${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64$([System.Char]34)`n"
    "    `${WinPE Default Image Creation Path} = $([System.Char]34)`$env:SystemDrive\Users\%_explorer_owner_%\WinPE\%_DefaultImageFolderName_%$([System.Char]34)`n"
    "    `${WinPE Default ISO Folder Path} = $([System.Char]34)`${WinPE Default Image Creation Path}\Default ISO$([System.Char]34)`n"
    "    `$WinPeMount = $([System.Char]34)`${WinPE Default Image Creation Path}\mount$([System.Char]34)`n"
    "    `$PackagePath = $([System.Char]34)`${WinPE x64 Tools Path}\WinPE_OCs$([System.Char]34)`n"
    "    `$lang = $([System.Char]34)en-us$([System.Char]34)`n"

    "    `$path = $([System.Char]34)`$WinPeMount$([System.Char]34)`n"
    "    `$folder = try {Get-Item -Path `$path -ErrorAction $([System.Char]39)Stop$([System.Char]39)} catch {New-Item -Path `$path -ItemType $([System.Char]39)Directory$([System.Char]39) -Force}`n"
    "    pause`n"
    "    Set-ItemProperty -Path $([System.Char]34)`${WinPE x64 Tools Path}\`$lang\winpe.wim$([System.Char]34) -Name IsReadOnly -Value `$false`n"
    "    pause`n"
    "    dism.exe /Mount-Image /ImageFile:$([System.Char]34)`${WinPE x64 Tools Path}\`$lang\winpe.wim$([System.Char]34) /Index:1 /MountDir:`$WinPeMount`n"
    "    pause`n"
    "    dism.exe /Add-Package /Image:`$WinPeMount /PackagePath:$([System.Char]34)`$PackagePath\WinPE-WMI.cab$([System.Char]34)`n"
    "    dism.exe /Add-Package /Image:`$WinPeMount /PackagePath:$([System.Char]34)`$PackagePath\`$lang\WinPE-WMI_`$lang.cab$([System.Char]34)`n"
    "    pause`n"
    #"    dism.exe /Add-Package /Image:`$WinPeMount /PackagePath:$([System.Char]34)`$PackagePath\WinPE-NetFX.cab$([System.Char]34)`n"
    #"    dism.exe /Add-Package /Image:`$WinPeMount /PackagePath:$([System.Char]34)`$PackagePath\`$lang\WinPE-NetFX_`$lang.cab$([System.Char]34)`n"
    #"    dism.exe /Add-Package /Image:`$WinPeMount /PackagePath:$([System.Char]34)`$PackagePath\WinPE-Scripting.cab$([System.Char]34)`n"
    #"    dism.exe /Add-Package /Image:`$WinPeMount /PackagePath:$([System.Char]34)`$PackagePath\`$lang\WinPE-Scripting_`$lang.cab$([System.Char]34)`n"
    #"    dism.exe /Add-Package /Image:`$WinPeMount /PackagePath:$([System.Char]34)`$PackagePath\WinPE-PowerShell.cab$([System.Char]34)`n"
    #"    dism.exe /Add-Package /Image:`$WinPeMount /PackagePath:$([System.Char]34)`$PackagePath\`$lang\WinPE-PowerShell_`$lang.cab$([System.Char]34)`n"
    #"    dism.exe /Add-Package /Image:`$WinPeMount /PackagePath:$([System.Char]34)`$PackagePath\WinPE-StorageWMI.cab$([System.Char]34)`n"
    #"    dism.exe /Add-Package /Image:`$WinPeMount /PackagePath:$([System.Char]34)`$PackagePath\`$lang\WinPE-StorageWMI_`$lang.cab$([System.Char]34)`n"
    #"    dism.exe /Add-Package /Image:`$WinPeMount /PackagePath:$([System.Char]34)`$PackagePath\WinPE-DismCmdlets.cab$([System.Char]34)`n"
    #"    dism.exe /Add-Package /Image:`$WinPeMount /PackagePath:$([System.Char]34)`$PackagePath\`$lang\WinPE-DismCmdlets_`$lang.cab$([System.Char]34)`n"
    #"    dism.exe /Add-Package /Image:`$WinPeMount /PackagePath:$([System.Char]34)`$PackagePath\WinPE-SecureStartup.cab$([System.Char]34)`n"
    #"    dism.exe /Add-Package /Image:`$WinPeMount /PackagePath:$([System.Char]34)`$PackagePath\`$lang\WinPE-SecureStartup_`$lang.cab$([System.Char]34)`n"
    #"    dism.exe /Add-Package /Image:`$WinPeMount /PackagePath:$([System.Char]34)`$PackagePath\WinPE-EnhancedStorage.cab$([System.Char]34)`n"
    #"    dism.exe /Add-Package /Image:`$WinPeMount /PackagePath:$([System.Char]34)`$PackagePath\`$lang\WinPE-EnhancedStorage_`$lang.cab$([System.Char]34)`n"
    #"    dism.exe /Add-Package /Image:`$WinPeMount /PackagePath:$([System.Char]34)`$PackagePath\WinPE-PmemCmdlets.cab$([System.Char]34)`n"
    #"    dism.exe /Add-Package /Image:`$WinPeMount /PackagePath:$([System.Char]34)`$PackagePath\`$lang\WinPE-PmemCmdlets_`$lang.cab$([System.Char]34)`n"
    #"    dism.exe /Add-Package /Image:`$WinPeMount /PackagePath:$([System.Char]34)`$PackagePath\WinPE-PlatformId.cab$([System.Char]34)`n"
    #"    dism.exe /Add-Package /Image:`$WinPeMount /PackagePath:$([System.Char]34)`$PackagePath\WinPE-SecureBootCmdlets.cab$([System.Char]34)`n"
    #"    dism.exe /Add-Package /Image:`$WinPeMount /PackagePath:$([System.Char]34)`$PackagePath\WinPE-HSP-Driver.cab$([System.Char]34)`n"
    "    pause`n"
    "  }`n"
  ) -join ''
#>


<#
  ${Command Here-String} = ${Command Here-String Precursor} `
    -replace '%_DefaultImageFolderName_%',$DefaultImageFolderName `
    -replace '%_explorer_owner_%',${explorer.exe Owner}

  ${Mount Image Script Path} = "$env:UserProfile\WinPE\Mount Image Script.ps1"
  Set-Content -Path ${Mount Image Script Path} -Value ${Command Here-String}

  Start-Process -ArgumentList @(
    "Get-Item -Path '${Mount Image Script Path}' | Get-Content -Raw | Invoke-Expression"
  ) -FilePath powershell.exe -Verb 'RunAs' -WindowStyle 'Normal' # -Wait
#>


