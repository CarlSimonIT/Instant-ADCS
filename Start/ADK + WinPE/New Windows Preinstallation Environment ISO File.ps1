#Requires -Version 5.1
#Requires -PSEdition Desktop

param (
  ${WinPE Workspace Folder Name}
)

${explorer.exe Owner} = Import-CliXml -Path "$PSScriptRoot\..\..\..\.CommonItems\explorer.exe Owner.clixml"
${WinPE Image Creation Parent Path} = "$env:SystemDrive\Users\${explorer.exe Owner}\WinPE"
${WinPE Image Creation Parent Folder} = try {
  Get-Item -Path ${WinPE Image Creation Parent Path} -ErrorAction 'Stop'
} catch {
  New-Item -Path ${WinPE Image Creation Parent Path} -ItemType 'Directory' -Force
}

<#
  ${WinPE Workspace Folder Name} = 'PowerShell-Infused WinPE-00'
  ${explorer.exe Owner} = Import-CliXml -Path "${env:.CommonItems}\explorer.exe Owner.clixml"
#>

${Unique WinPE ISO Command Here-String Precursor} = $(
        
  "`n"
  "`t`t`t    & { # Created with $([System.Char]39).\ConvertTo-HereStringCompatible.ps1$([System.Char]39) |`n"
  "`t`t`t      `${WinPE x64 Tools Path} = $([System.Char]34)`${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64$([System.Char]34)`n"
  "`t`t`t      `${WinPE Workspace Folder Name},`${explorer.exe Owner} = $([System.Char]39)%_WinPE Workspace Folder Name_%$([System.Char]39),$([System.Char]39)%_explorer_owner_%$([System.Char]39)`n"
  "`t`t`t`n"
  "`t`t`t      # Define directory that contains unmodified files for WinPE ISO file generation`n"
  "`t`t`t      `${WinPE Image Creation Parent Path} = $([System.Char]34)`$env:SystemDrive\Users\`${explorer.exe Owner}\WinPE$([System.Char]34)`n"
  "`t`t`t      `${WinPE Image Creation Parent Folder} = try {`n"
  "`t`t`t        Get-Item -Path `${WinPE Image Creation Parent Path} -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
  "`t`t`t      } catch {`n"
  "`t`t`t        New-Item -Path `${WinPE Image Creation Parent Path} -ItemType $([System.Char]39)Directory$([System.Char]39) -Force`n"
  "`t`t`t      }`n"
  "`t`t`t      `${WinPE Image Creation Path} = $([System.Char]34)`${WinPE Image Creation Parent Path}\`${WinPE Workspace Folder Name}$([System.Char]34)`n"
  "`t`t`t      `${WinPE Default ISO Folder Path} = $([System.Char]34)`${WinPE Image Creation Path}\.Default ISO$([System.Char]34)`n"
  "`t`t`t`n"
  "`t`t`t      # Populate the contents of $([System.Char]39).\.Default ISO\$([System.Char]39) with unmodified files for WinPE ISO file generation`n"
  "`t`t`t      copype.cmd .\amd64\ `${WinPE Default ISO Folder Path}`n"
  "`t`t`t`n"
  "`t`t`t      # Write to disk an .iso file of an original, unmodified instance of WinPE`n"
  "`t`t`t      MakeWinPeMedia.cmd /ISO `${WinPE Default ISO Folder Path} $([System.Char]34)`${WinPE Default ISO Folder Path}\WinPE Original.iso$([System.Char]34)`n"
  "`t`t`t`n"
  "`t`t`t      `${Updated ISO Folder Path} = $([System.Char]34)`${WinPE Image Creation Parent Folder}\`${WinPE Workspace Folder Name}\Updated ISO$([System.Char]34)`n"
  "`t`t`t      `$IsPresent = Test-Path -Path `${Updated ISO Folder Path}`n"
  "`t`t`t      if (-not `$IsPresent) {`n"
  "`t`t`t        `${Updated ISO Folder} = try {`n"
  "`t`t`t          Get-Item -Path `${Updated ISO Folder Path} -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
  "`t`t`t        } catch {`n"
  "`t`t`t          New-Item -Path `${Updated ISO Folder Path} -ItemType $([System.Char]39)Directory$([System.Char]39) -Force`n"
  "`t`t`t        }`n"
  "`t`t`t`n"
  "`t`t`t        Copy-Item -Path $([System.Char]34)`${WinPE Image Creation Path}\.Default ISO\bootbins$([System.Char]34) -Destination $([System.Char]34)`${Updated ISO Folder}\bootbins$([System.Char]34) -Recurse`n"
  "`t`t`t        Copy-Item -Path $([System.Char]34)`${WinPE Image Creation Path}\.Default ISO\media$([System.Char]34) -Destination $([System.Char]34)`${Updated ISO Folder}\media$([System.Char]34) -Recurse`n"
  "`t`t`t        Copy-Item -Path $([System.Char]34)`${WinPE Image Creation Path}\.Default ISO\mount$([System.Char]34) -Destination $([System.Char]34)`${Updated ISO Folder}\mount$([System.Char]34) -Recurse`n"
  "`t`t`t`n"
  "`t`t`t        `${Mount Directory Path} = $([System.Char]34)`${Updated ISO Folder}\mount$([System.Char]34)`n"
  "`t`t`t        `$lang = $([System.Char]34)en-us$([System.Char]34)`n"
  "`t`t`t        Copy-Item -Path $([System.Char]34)`${WinPE x64 Tools Path}\`$lang\WinPE.wim$([System.Char]34) -Destination $([System.Char]34)`${Updated ISO Folder}$([System.Char]34)`n"
  "`t`t`t        dism.exe /Mount-Image /ImageFile:$([System.Char]34)`${Updated ISO Folder}\WinPE.wim$([System.Char]34) /Index:1 /MountDir:$([System.Char]34)`${Mount Directory Path}$([System.Char]34)`n"
  "`t`t`t`n"
  "`t`t`t        `$PackagePath = $([System.Char]34)`${WinPE x64 Tools Path}\WinPE_OCs$([System.Char]34)`n"
  "`t`t`t        dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\WinPE-WMI.cab$([System.Char]34)`n"
  "`t`t`t        dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\`$lang\WinPE-WMI_`$lang.cab$([System.Char]34)`n"
  "`t`t`t        dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\WinPE-NetFX.cab$([System.Char]34)`n"
  "`t`t`t        dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\`$lang\WinPE-NetFX_`$lang.cab$([System.Char]34)`n"
  "`t`t`t        dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\WinPE-Scripting.cab$([System.Char]34)`n"
  "`t`t`t        dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\`$lang\WinPE-Scripting_`$lang.cab$([System.Char]34)`n"
  "`t`t`t        dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\WinPE-PowerShell.cab$([System.Char]34)`n"
  "`t`t`t        dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\`$lang\WinPE-PowerShell_`$lang.cab$([System.Char]34)`n"
  "`t`t`t        dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\WinPE-StorageWMI.cab$([System.Char]34)`n"
  "`t`t`t        dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\`$lang\WinPE-StorageWMI_`$lang.cab$([System.Char]34)`n"
  "`t`t`t        dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\WinPE-DismCmdlets.cab$([System.Char]34)`n"
  "`t`t`t        dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\`$lang\WinPE-DismCmdlets_`$lang.cab$([System.Char]34)`n"
  "`t`t`t        dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\WinPE-SecureStartup.cab$([System.Char]34)`n"
  "`t`t`t        dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\`$lang\WinPE-SecureStartup_`$lang.cab$([System.Char]34)`n"
  "`t`t`t        dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\WinPE-EnhancedStorage.cab$([System.Char]34)`n"
  "`t`t`t        dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\`$lang\WinPE-EnhancedStorage_`$lang.cab$([System.Char]34)`n"
  "`t`t`t        dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\WinPE-PmemCmdlets.cab$([System.Char]34)`n"
  "`t`t`t        dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\`$lang\WinPE-PmemCmdlets_`$lang.cab$([System.Char]34)`n"
  "`t`t`t        dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\WinPE-PlatformId.cab$([System.Char]34)`n"
  "`t`t`t        dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\WinPE-SecureBootCmdlets.cab$([System.Char]34)`n"
  "`t`t`t        dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\WinPE-HSP-Driver.cab$([System.Char]34)`n"
  "`t`t`t`n"
  "`t`t`t        dism.exe /Unmount-Image /MountDir:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /Commit`n"
  "`t`t`t`n"
  "`t`t`t        copype.cmd .\amd64\ $([System.Char]34)`${Updated ISO Folder}$([System.Char]34)`n"
  "`t`t`t        MakeWinPeMedia.cmd /ISO $([System.Char]34)`${Updated ISO Folder}$([System.Char]34) $([System.Char]34)`${Updated ISO Folder}\`${WinPE Workspace Folder Name}.iso$([System.Char]34)`n"
  "`t`t`t      }`n"
  "`t`t`t    }`n"
  "`t`t`t`n"
  "`t`t"


  <#
    & { # Created with '.\ConvertTo-HereStringCompatible.ps1' |
      ${WinPE x64 Tools Path} = "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64"
      ${WinPE Workspace Folder Name},${explorer.exe Owner} = '%_WinPE Workspace Folder Name_%','%_explorer_owner_%'

      # Define directory that contains unmodified files for WinPE ISO file generation
      ${WinPE Image Creation Parent Path} = "$env:SystemDrive\Users\${explorer.exe Owner}\WinPE"
      ${WinPE Image Creation Parent Folder} = try {
        Get-Item -Path ${WinPE Image Creation Parent Path} -ErrorAction 'Stop'
      } catch {
        New-Item -Path ${WinPE Image Creation Parent Path} -ItemType 'Directory' -Force
      }
      ${WinPE Image Creation Path} = "${WinPE Image Creation Parent Path}\${WinPE Workspace Folder Name}"
      ${WinPE Default ISO Folder Path} = "${WinPE Image Creation Path}\.Default ISO"

      # Populate the contents of '.\.Default ISO\' with unmodified files for WinPE ISO file generation
      copype.cmd .\amd64\ ${WinPE Default ISO Folder Path}

      # Write to disk an .iso file of an original, unmodified instance of WinPE
      MakeWinPeMedia.cmd /ISO ${WinPE Default ISO Folder Path} "${WinPE Default ISO Folder Path}\WinPE Original.iso"

      ${Updated ISO Folder Path} = "${WinPE Image Creation Parent Folder}\${WinPE Workspace Folder Name}\Updated ISO"
      $IsPresent = Test-Path -Path ${Updated ISO Folder Path}
      if (-not $IsPresent) {
        ${Updated ISO Folder} = try {
          Get-Item -Path ${Updated ISO Folder Path} -ErrorAction 'Stop'
        } catch {
          New-Item -Path ${Updated ISO Folder Path} -ItemType 'Directory' -Force
        }

        Copy-Item -Path "${WinPE Image Creation Path}\.Default ISO\bootbins" -Destination "${Updated ISO Folder}\bootbins" -Recurse
        Copy-Item -Path "${WinPE Image Creation Path}\.Default ISO\media" -Destination "${Updated ISO Folder}\media" -Recurse
        Copy-Item -Path "${WinPE Image Creation Path}\.Default ISO\mount" -Destination "${Updated ISO Folder}\mount" -Recurse

        ${Mount Directory Path} = "${Updated ISO Folder}\mount"
        $lang = "en-us"
        Copy-Item -Path "${WinPE x64 Tools Path}\$lang\WinPE.wim" -Destination "${Updated ISO Folder}"
        dism.exe /Mount-Image /ImageFile:"${Updated ISO Folder}\WinPE.wim" /Index:1 /MountDir:"${Mount Directory Path}"

        $PackagePath = "${WinPE x64 Tools Path}\WinPE_OCs"
        dism.exe /Add-Package /Image:"${Mount Directory Path}" /PackagePath:"$PackagePath\WinPE-WMI.cab"
        dism.exe /Add-Package /Image:"${Mount Directory Path}" /PackagePath:"$PackagePath\$lang\WinPE-WMI_$lang.cab"
        dism.exe /Add-Package /Image:"${Mount Directory Path}" /PackagePath:"$PackagePath\WinPE-NetFX.cab"
        dism.exe /Add-Package /Image:"${Mount Directory Path}" /PackagePath:"$PackagePath\$lang\WinPE-NetFX_$lang.cab"
        dism.exe /Add-Package /Image:"${Mount Directory Path}" /PackagePath:"$PackagePath\WinPE-Scripting.cab"
        dism.exe /Add-Package /Image:"${Mount Directory Path}" /PackagePath:"$PackagePath\$lang\WinPE-Scripting_$lang.cab"
        dism.exe /Add-Package /Image:"${Mount Directory Path}" /PackagePath:"$PackagePath\WinPE-PowerShell.cab"
        dism.exe /Add-Package /Image:"${Mount Directory Path}" /PackagePath:"$PackagePath\$lang\WinPE-PowerShell_$lang.cab"
        dism.exe /Add-Package /Image:"${Mount Directory Path}" /PackagePath:"$PackagePath\WinPE-StorageWMI.cab"
        dism.exe /Add-Package /Image:"${Mount Directory Path}" /PackagePath:"$PackagePath\$lang\WinPE-StorageWMI_$lang.cab"
        dism.exe /Add-Package /Image:"${Mount Directory Path}" /PackagePath:"$PackagePath\WinPE-DismCmdlets.cab"
        dism.exe /Add-Package /Image:"${Mount Directory Path}" /PackagePath:"$PackagePath\$lang\WinPE-DismCmdlets_$lang.cab"
        dism.exe /Add-Package /Image:"${Mount Directory Path}" /PackagePath:"$PackagePath\WinPE-SecureStartup.cab"
        dism.exe /Add-Package /Image:"${Mount Directory Path}" /PackagePath:"$PackagePath\$lang\WinPE-SecureStartup_$lang.cab"
        dism.exe /Add-Package /Image:"${Mount Directory Path}" /PackagePath:"$PackagePath\WinPE-EnhancedStorage.cab"
        dism.exe /Add-Package /Image:"${Mount Directory Path}" /PackagePath:"$PackagePath\$lang\WinPE-EnhancedStorage_$lang.cab"
        dism.exe /Add-Package /Image:"${Mount Directory Path}" /PackagePath:"$PackagePath\WinPE-PmemCmdlets.cab"
        dism.exe /Add-Package /Image:"${Mount Directory Path}" /PackagePath:"$PackagePath\$lang\WinPE-PmemCmdlets_$lang.cab"
        dism.exe /Add-Package /Image:"${Mount Directory Path}" /PackagePath:"$PackagePath\WinPE-PlatformId.cab"
        dism.exe /Add-Package /Image:"${Mount Directory Path}" /PackagePath:"$PackagePath\WinPE-SecureBootCmdlets.cab"
        dism.exe /Add-Package /Image:"${Mount Directory Path}" /PackagePath:"$PackagePath\WinPE-HSP-Driver.cab"

        dism.exe /Unmount-Image /MountDir:"${Mount Directory Path}" /Commit

        copype.cmd .\amd64\ "${Updated ISO Folder}"
        MakeWinPeMedia.cmd /ISO "${Updated ISO Folder}" "${Updated ISO Folder}\${WinPE Workspace Folder Name}.iso"
      }
    }
  #>


) -join ''


${Unique WinPE ISO Command Here-String} = ${Unique WinPE ISO Command Here-String Precursor} -replace '%_explorer_owner_%',${explorer.exe Owner}
${Unique WinPE ISO Command Here-String} = ${Unique WinPE ISO Command Here-String} -replace '%_WinPE Workspace Folder Name_%',${WinPE Workspace Folder Name}

${Unique WinPE ISO Script Path} = "${WinPE Image Creation Parent Folder}\Unique WinPE ISO Script.ps1"
Set-Content -Path ${Unique WinPE ISO Script Path} -Value (${Unique WinPE ISO Command Here-String})
$WorkingDirectory = "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools"

$path = "${WinPE Image Creation Parent Folder}\${WinPE Workspace Folder Name}\Updated ISO"
$IsPresent = Test-Path -Path $path
if (-not $IsPresent) {
  Start-Process -FilePath cmd.exe -ArgumentList @(
    "/c $([System.Char]34)$WorkingDirectory\DandISetEnv.bat$([System.Char]34) && powershell.exe -NoProfile -ExecutionPolicy 'RemoteSigned'; Invoke-Expression -Command (Get-Content -Raw -Path '${Unique WinPE ISO Script Path}')"
  ) -Verb 'RunAs' -Wait
}






<#
  ${Duplicate Uncompressed WinPE Files Here-String Precursor} = $(
    "`${WinPE x64 Tools Path} = $([System.Char]34)`${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64$([System.Char]34)`n"
    "`${WinPE Image Creation Path} = $([System.Char]34)`${WinPE Image Creation Parent Path}\%_WinPE Workspace Folder Name_%$([System.Char]34)`n"
    "`${WinPE Default ISO Folder Path} = $([System.Char]34)`${WinPE Image Creation Path}\.Default ISO$([System.Char]34)`n"
    "copype.cmd .\amd64\ `${WinPE Default ISO Folder Path}`n"
  ) -join ''
  ${Duplicate Uncompressed WinPE Files Here-String} = ${Duplicate Uncompressed WinPE Files Here-String Precursor} `
    -replace '%_WinPE Workspace Folder Name_%',${WinPE Workspace Folder Name} `
    -replace '%_explorer_owner_%',${explorer.exe Owner}

  Set-Content -Path "${WinPE Image Creation Parent Path}\Duplicate Uncompressed WinPE Files Script.ps1" -Value (${Duplicate Uncompressed WinPE Files Here-String})
  $WorkingDirectory = "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools"

  $IsPresent = Test-Path -Path "${WinPE Image Creation Parent Path}\${WinPE Workspace Folder Name}\.Default ISO"
  if (-not $IsPresent) {
    Start-Process -FilePath cmd.exe -ArgumentList @(
      #"/c $([System.Char]34)$WorkingDirectory\DandISetEnv.bat$([System.Char]34) && powershell.exe -NoProfile -ExecutionPolicy 'RemoteSigned'; Invoke-Expression -Command (Get-Content -Raw -Path '$env:SystemDrive\Users\${explorer.exe Owner}\WinPE\Duplicate Uncompressed WinPE Files Script.ps1')"
      "/c $([System.Char]34)$WorkingDirectory\DandISetEnv.bat$([System.Char]34) && powershell.exe -NoProfile -ExecutionPolicy 'RemoteSigned'; Invoke-Expression -Command (Get-Content -Raw -Path '${WinPE Image Creation Parent Path}\Duplicate Uncompressed WinPE Files Script.ps1')"
    ) -Verb 'RunAs' -Wait
  }
#>


<##>
<#
  The following folders have now been created:
  ${WinPE Image Creation Path}\.Default ISO\bootbins
  ${WinPE Image Creation Path}\.Default ISO\media
  ${WinPE Image Creation Path}\.Default ISO\mount
#>

<#
  ${WinPE Default ISO File BaseName} = '_OriginalWinPE'
  ${Compress Default WinPE Files to ISO Here-String Precursor} = $(
    "`${WinPE Image Creation Parent Path} = $([System.Char]34)`$env:SystemDrive\Users\%_explorer_owner_%\WinPE$([System.Char]34)`n"
    "`$folder = try {`n"
    "  Get-Item -Path `${WinPE Image Creation Parent Path} -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
    "} catch {`n"
    "  New-Item -Path `${WinPE Image Creation Parent Path} -ItemType $([System.Char]39)Directory$([System.Char]39) -Force`n"
    "}`n"

    "`${WinPE x64 Tools Path} = $([System.Char]34)`${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64$([System.Char]34)`n"
    "`${WinPE Image Creation Path} = $([System.Char]34)`${WinPE Image Creation Parent Path}\%_WinPE Workspace Folder Name_%$([System.Char]34)`n"
    "`${WinPE Default ISO Folder Path} = $([System.Char]34)`${WinPE Image Creation Path}\.Default ISO$([System.Char]34)`n"
    #"MakeWinPeMedia /ISO `${WinPE Default ISO Folder Path} $([System.Char]34)`${WinPE Default ISO Folder Path}\WinPE_amd64.iso$([System.Char]34)`n"
    #"MakeWinPeMedia.cmd /ISO `${WinPE Default ISO Folder Path} $([System.Char]34)`${WinPE Default ISO Folder Path}\WinPE_amd64.iso$([System.Char]34)`n"
    "MakeWinPeMedia.cmd /ISO `${WinPE Default ISO Folder Path} $([System.Char]34)`${WinPE Default ISO Folder Path}\%_WinPE Default ISO File BaseName_%.iso$([System.Char]34)`n"
  ) -join ''
  ${Compress Default WinPE Files to ISO Here-String} = ${Compress Default WinPE Files to ISO Here-String Precursor} `
    -replace '%_WinPE Workspace Folder Name_%',${WinPE Workspace Folder Name} `
    -replace '%_explorer_owner_%',${explorer.exe Owner} `
    -replace '%_WinPE Default ISO File BaseName_%',${WinPE Default ISO File BaseName}

  # Set-Content -Path "$env:Temp\Make_WinPE_Media_Script.ps1" -Value (${Make WinPE Media Here-String})
  Set-Content -Path "${WinPE Image Creation Parent Path}\Compress Default WinPE Files to ISO Script.ps1" -Value (${Compress Default WinPE Files to ISO Here-String})
  $WorkingDirectory = "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools"

  $IsPresent = Test-Path -Path "${WinPE Image Creation Parent Path}\${WinPE Workspace Folder Name}\.Default ISO\${WinPE Default ISO File BaseName}.iso"
  if (-not $IsPresent) {
    Start-Process -FilePath cmd.exe -ArgumentList @(
      #"/c $([System.Char]34)$WorkingDirectory\DandISetEnv.bat$([System.Char]34) && powershell.exe -NoProfile -ExecutionPolicy 'RemoteSigned'; Invoke-Expression -Command (Get-Content -Raw -Path '$env:TEMP\Make_WinPE_Media_Script.ps1')"
      #"/c $([System.Char]34)$WorkingDirectory\DandISetEnv.bat$([System.Char]34) && powershell.exe -NoProfile -ExecutionPolicy 'RemoteSigned'; Invoke-Expression -Command (Get-Content -Raw -Path '$env:SystemDrive\Users\${explorer.exe Owner}\WinPE\Duplicate Uncompressed WinPE Files Script.ps1')"
      "/c $([System.Char]34)$WorkingDirectory\DandISetEnv.bat$([System.Char]34) && powershell.exe -NoProfile -ExecutionPolicy 'RemoteSigned'; Invoke-Expression -Command (Get-Content -Raw -Path '${WinPE Image Creation Parent Path}\Compress Default WinPE Files to ISO Script.ps1')"
    ) -Verb 'RunAs' -wait
  }
#>


<#
  start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/get-started/adk-install#install-the-adk'
  start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/get-started/adk-offline-install'
  start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/get-started/adk-offline-install#using-the-command-line'

  adksetup.exe cli syntax: 
  start msedge.exe 'https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-8.1-and-8/dn621910(v=win.10)'
#>

# start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/winpe-add-packages--optional-components-reference?view=windows-11'
<#
  ${Mount Directory Path} = "${Updated ISO Folder Path}\mount"
  ${Mount-Adjust-Eject WinPE.wim File Command Here-String Precursor} = $(
    "`${Updated ISO Folder Path} = $([System.Char]34)%_Updated ISO Folder Path_%$([System.Char]34)`n"
    "`${WinPE x64 Tools Path} = $([System.Char]34)`${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64$([System.Char]34)`n"
    "`${Mount Directory Path} = $([System.Char]34)`${Updated ISO Folder Path}\mount$([System.Char]34)`n"
    "`$lang = $([System.Char]34)en-us$([System.Char]34)`n"
    "`n"
    "dism.exe /Mount-Image /ImageFile:$([System.Char]34)`${WinPE x64 Tools Path}\`$lang\WinPE.wim$([System.Char]34) /Index:1 /MountDir:$([System.Char]34)`${Mount Directory Path}$([System.Char]34)`n"
    "`n"
    "`n"
    "`n"
    "`n"
    "`n"
    "`n"
    "`$PackagePath = $([System.Char]34)`${WinPE x64 Tools Path}\WinPE_OCs$([System.Char]34)`n"
    "`n"
    "dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\WinPE-WMI.cab$([System.Char]34)`n"
    "dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\`$lang\WinPE-WMI_`$lang.cab$([System.Char]34)`n"

    "dism.exe /Unmount-Image /MountDir:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /Commit`n"
    "`n"
    "`n"
    "`n"
    "`n"
    "`n"
    "`n"
  ) -join ''

  ${Mount-Adjust-Eject WinPE.wim File Command Here-String} = ${Mount-Adjust-Eject WinPE.wim File Command Here-String Precursor} `
    -replace '%_Mount Directory Path_%',${Mount Directory Path} `
    -replace '%_Updated ISO Folder Path_%',${Updated ISO Folder Path}

  ${Mount-Adjust-Eject WinPE.wim File Script Path} = "${WinPE Image Creation Parent Path}\Mount-Adjust-Eject WinPE.wim File Script.ps1"
  Set-Content -Path ${Mount-Adjust-Eject WinPE.wim File Script Path} -Value ${Mount-Adjust-Eject WinPE.wim File Command Here-String}
  $WorkingDirectory = "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools"

  Start-Process -ArgumentList @(
    #"Get-Item -Path '${Mount-Adjust-Eject WinPE.wim File Script Path}' | Get-Content -Raw | Invoke-Expression"
    "/c $([System.Char]34)$WorkingDirectory\DandISetEnv.bat$([System.Char]34) && powershell.exe -NoProfile -ExecutionPolicy 'RemoteSigned'; Invoke-Expression -Command (Get-Content -Raw -Path '${Mount-Adjust-Eject WinPE.wim File Script Path}')"
  ) -FilePath powershell.exe -Verb 'RunAs' -WindowStyle 'Normal' -Wait


#>


<#
  ${Command Here-String Precursor} = $(
    "  & {`n"
    "    `${WinPE x64 Tools Path} = $([System.Char]34)`${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64$([System.Char]34)`n"
    "    `${WinPE Image Creation Path} = $([System.Char]34)`$env:SystemDrive\Users\%_explorer_owner_%\WinPE\%_WinPE Workspace Folder Name_%$([System.Char]34)`n"
    "    `${WinPE Default ISO Folder Path} = $([System.Char]34)`${WinPE Image Creation Path}\.Default ISO$([System.Char]34)`n"
    "    `${Mount Directory Path} = $([System.Char]34)`${WinPE Image Creation Path}\mount$([System.Char]34)`n"
    "    `$PackagePath = $([System.Char]34)`${WinPE x64 Tools Path}\WinPE_OCs$([System.Char]34)`n"
    "    `$lang = $([System.Char]34)en-us$([System.Char]34)`n"

    "    `$path = $([System.Char]34)`${Mount Directory Path}$([System.Char]34)`n"
    "    `$folder = try {Get-Item -Path `$path -ErrorAction $([System.Char]39)Stop$([System.Char]39)} catch {New-Item -Path `$path -ItemType $([System.Char]39)Directory$([System.Char]39) -Force}`n"
    "    pause`n"
    "    Set-ItemProperty -Path $([System.Char]34)`${WinPE x64 Tools Path}\`$lang\winpe.wim$([System.Char]34) -Name IsReadOnly -Value `$false`n"
    "    pause`n"
    "    dism.exe /Mount-Image /ImageFile:$([System.Char]34)`${WinPE x64 Tools Path}\`$lang\winpe.wim$([System.Char]34) /Index:1 /MountDir:`${Mount Directory Path}`n"
    "    pause`n"
    "    pause`n"
    "    pause`n"
    "  }`n"
  ) -join ''
#>


<#
  ${Command Here-String} = ${Command Here-String Precursor} `
    -replace '%_WinPE Workspace Folder Name_%',${WinPE Workspace Folder Name} `
    -replace '%_explorer_owner_%',${explorer.exe Owner}

  ${Mount Image Script Path} = "$env:UserProfile\WinPE\Mount Image Script.ps1"
  Set-Content -Path ${Mount Image Script Path} -Value ${Command Here-String}

  Start-Process -ArgumentList @(
    "Get-Item -Path '${Mount Image Script Path}' | Get-Content -Raw | Invoke-Expression"
  ) -FilePath powershell.exe -Verb 'RunAs' -WindowStyle 'Normal' # -Wait
#>



<# Windows ADK Installation Options |
  OptionId.ApplicationCompatibilityToolkit
  OptionId.DeploymentTools
  OptionId.ImagingAndConfigurationDesigner
  OptionId.ICDConfigurationDesigner
  OptionId.UserStateMigrationTool
  OptionId.VolumeActivationManagementTool
  OptionId.WindowsPerformanceToolkit
  OptionId.WindowsAssessmentToolkit
  OptionId.UEVTools
  OptionId.AppmanSequencer
  OptionId.AppmanAutoSequencer
  OptionId.MediaeXperienceAnalyzer
  OptionId.SupplyChainTrustTools
#>

