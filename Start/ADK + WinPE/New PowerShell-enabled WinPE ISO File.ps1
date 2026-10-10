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
  "    & { # Created with $([System.Char]39).\ConvertTo-HereStringCompatible.ps1$([System.Char]39) |`n"
  "      `${WinPE x64 Tools Path} = $([System.Char]34)`${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64$([System.Char]34)`n"
  "      `${ADK x64 Tools Path} = Resolve-Path -Path $([System.Char]34)`${WinPE x64 Tools Path}\..\..\Deployment Tools\amd64$([System.Char]34) | Select-Object -ExpandProperty $([System.Char]39)Path$([System.Char]39)`n"
  "      `${WinPE Workspace Folder Name},`${explorer.exe Owner} = $([System.Char]39)%_WinPE Workspace Folder Name_%$([System.Char]39),$([System.Char]39)%_explorer_owner_%$([System.Char]39)`n"
  "`n"
  "      # Define directory that contains unmodified files for WinPE ISO file generation`n"
  "      `${WinPE Image Creation Parent Path} = $([System.Char]34)`$env:SystemDrive\Users\`${explorer.exe Owner}\WinPE$([System.Char]34)`n"
  "      `${WinPE Image Creation Parent Folder} = try {`n"
  "        Get-Item -Path `${WinPE Image Creation Parent Path} -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
  "      } catch {`n"
  "        New-Item -Path `${WinPE Image Creation Parent Path} -ItemType $([System.Char]39)Directory$([System.Char]39) -Force`n"
  "      }`n"
  "      `${WinPE Image Creation Path} = $([System.Char]34)`${WinPE Image Creation Parent Path}\`${WinPE Workspace Folder Name}$([System.Char]34)`n"
  "      `${WinPE Default ISO Folder Path} = $([System.Char]34)`${WinPE Image Creation Path}\.Default ISO$([System.Char]34)`n"
  "`n"
  "      # Populate the contents of $([System.Char]39).\.Default ISO\$([System.Char]39) with unmodified files for WinPE ISO file generation`n"
  "      copype.cmd .\amd64\ `${WinPE Default ISO Folder Path}`n"
  "`n"
  "      # Write to disk an .iso file of an original, unmodified instance of WinPE`n"
  "      MakeWinPeMedia.cmd /ISO `${WinPE Default ISO Folder Path} $([System.Char]34)`${WinPE Default ISO Folder Path}\WinPE Original.iso$([System.Char]34) /bootex`n"
  "      # MakeWinPeMedia.cmd /ISO `${WinPE Default ISO Folder Path} $([System.Char]39)C:\Users\lowpr\NoSync\reimages\rocks\WinPE Original.iso$([System.Char]39) /bootex`n"
  "      # MakeWinPeMedia.cmd /ISO `${WinPE Default ISO Folder Path} $([System.Char]39)C:\Users\lowpr\NoSync\reimages\rocks\WinPE Original.iso$([System.Char]39) /bootex`n"
  "      # MakeWinPeMedia.cmd /UFD $([System.Char]34)`${WinPE Default ISO Folder Path}$([System.Char]34) P: /bootex`n"
  "`n"
  "      `${Updated ISO Folder Path} = $([System.Char]34)`${WinPE Image Creation Parent Folder}\`${WinPE Workspace Folder Name}\Updated ISO$([System.Char]34)`n"
  "      `$IsPresent = Test-Path -Path `${Updated ISO Folder Path}`n"
  "      if (-not `$IsPresent) {`n"
  "        #`${Updated ISO F0lder} = try {Get-Item -Path `${Updated ISO Folder Path} -ErrorAction $([System.Char]39)Stop$([System.Char]39)} catch {New-Item -Path `${Updated ISO Folder Path} -ItemType $([System.Char]39)Directory$([System.Char]39) -Force}`n"
  "        # Copy-Item -Path $([System.Char]34)`${WinPE Image Creation Path}\.Default ISO\bootbins$([System.Char]34) -Destination $([System.Char]34)`${Updated ISO Folder Path}\bootbins$([System.Char]34) -Recurse`n"
  "        # Copy-Item -Path $([System.Char]34)`${WinPE Image Creation Path}\.Default ISO\media$([System.Char]34) -Destination $([System.Char]34)`${Updated ISO Folder Path}\media$([System.Char]34) -Recurse`n"
  "        # Copy-Item -Path $([System.Char]34)`${WinPE Image Creation Path}\.Default ISO\mount$([System.Char]34) -Destination $([System.Char]34)`${Updated ISO Folder Path}\mount$([System.Char]34) -Recurse`n"
  "`n"
  "        copype.cmd .\amd64\ `${Updated ISO Folder Path}`n"
  "        `${Mount Directory Path} = $([System.Char]34)`${Updated ISO Folder Path}\mount$([System.Char]34)`n"
  "        `$lang = $([System.Char]34)en-us$([System.Char]34)`n"
  "        # Get-ChildItem -Path $([System.Char]34)`${Updated ISO Folder Path}\media$([System.Char]34) -Directory`n"
  "        .\amd64\DISM\dism.exe /Mount-Image /ImageFile:$([System.Char]34)`${Updated ISO Folder Path}\media\sources\boot.wim$([System.Char]34) /Index:1 /MountDir:$([System.Char]34)`${Mount Directory Path}$([System.Char]34)`n"
  "        #Copy-Item -Path $([System.Char]34)`${WinPE x64 Tools Path}\`$lang\WinPE.wim$([System.Char]34) -Destination $([System.Char]34)`${Updated ISO Folder Path}$([System.Char]34)`n"
  "        #.\amd64\DISM\dism.exe /Mount-Image /ImageFile:$([System.Char]34)`${Updated ISO Folder Path}\WinPE.wim$([System.Char]34) /Index:1 /MountDir:$([System.Char]34)`${Mount Directory Path}$([System.Char]34)`n"
  "        `n"
  "        # Get-Item -Path $([System.Char]34)`${Updated ISO Folder Path}\WinPE.wim$([System.Char]34) | Rename-Item -NewName $([System.Char]34)`${WinPE Workspace Folder Name}.wim$([System.Char]34)`n"
  "        # dism.exe /Mount-Image /ImageFile:$([System.Char]34)`${Updated ISO Folder Path}\WinPE.wim$([System.Char]34) /Index:1 /MountDir:$([System.Char]34)`${Mount Directory Path}$([System.Char]34)`n"
  "        # dism.exe /Get-ImageInfo /ImageFile:$([System.Char]34)`${Updated ISO Folder Path}\`${WinPE Workspace Folder Name}.wim$([System.Char]34)`n"
  "        # dism.exe /Mount-Image /ImageFile:$([System.Char]34)`${Updated ISO Folder Path}\`${WinPE Workspace Folder Name}.wim$([System.Char]34) /Index:1 /MountDir:$([System.Char]34)`${Mount Directory Path}$([System.Char]34)`n"
  "              `n"
  "        `$path = $([System.Char]34)`${Mount Directory Path}\Canary 00.txt$([System.Char]34)`n"
  "        `$file = try {Get-Item -Path `$path -ErrorAction $([System.Char]39)Stop$([System.Char]39)} catch {New-Item -Path `$path -ItemType $([System.Char]39)File$([System.Char]39) -Force}`n"
  "`n"
  "        #region | Enable Windows PowerShell support in WinPE |`n"
  "        `$PackagePath = $([System.Char]34)`${WinPE x64 Tools Path}\WinPE_OCs$([System.Char]34)`n"
  "        .\amd64\DISM\dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\WinPE-WMI.cab$([System.Char]34)`n"
  "        .\amd64\DISM\dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\`$lang\WinPE-WMI_`$lang.cab$([System.Char]34)`n"
  "        .\amd64\DISM\dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\WinPE-NetFX.cab$([System.Char]34)`n"
  "        .\amd64\DISM\dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\`$lang\WinPE-NetFX_`$lang.cab$([System.Char]34)`n"
  "        .\amd64\DISM\dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\WinPE-Scripting.cab$([System.Char]34)`n"
  "        .\amd64\DISM\dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\`$lang\WinPE-Scripting_`$lang.cab$([System.Char]34)`n"
  "        .\amd64\DISM\dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\WinPE-PowerShell.cab$([System.Char]34)`n"
  "        .\amd64\DISM\dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\`$lang\WinPE-PowerShell_`$lang.cab$([System.Char]34)`n"
  "        .\amd64\DISM\dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\WinPE-StorageWMI.cab$([System.Char]34)`n"
  "        .\amd64\DISM\dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\`$lang\WinPE-StorageWMI_`$lang.cab$([System.Char]34)`n"
  "        .\amd64\DISM\dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\WinPE-DismCmdlets.cab$([System.Char]34)`n"
  "        .\amd64\DISM\dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\`$lang\WinPE-DismCmdlets_`$lang.cab$([System.Char]34)`n"
  "        .\amd64\DISM\dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\WinPE-SecureStartup.cab$([System.Char]34)`n"
  "        .\amd64\DISM\dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\`$lang\WinPE-SecureStartup_`$lang.cab$([System.Char]34)`n"
  "        .\amd64\DISM\dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\WinPE-EnhancedStorage.cab$([System.Char]34)`n"
  "        .\amd64\DISM\dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\`$lang\WinPE-EnhancedStorage_`$lang.cab$([System.Char]34)`n"
  "        .\amd64\DISM\dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\WinPE-PmemCmdlets.cab$([System.Char]34)`n"
  "        .\amd64\DISM\dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\`$lang\WinPE-PmemCmdlets_`$lang.cab$([System.Char]34)`n"
  "        .\amd64\DISM\dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\WinPE-PlatformId.cab$([System.Char]34)`n"
  "        .\amd64\DISM\dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\WinPE-SecureBootCmdlets.cab$([System.Char]34)`n"
  "        .\amd64\DISM\dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\WinPE-HSP-Driver.cab$([System.Char]34)`n"
  "        #endregion`n"
  "`n"
  "        `$path = $([System.Char]34)`${Mount Directory Path}\Canary 05.txt$([System.Char]34)`n"
  "        `$file = try {Get-Item -Path `$path -ErrorAction $([System.Char]39)Stop$([System.Char]39)} catch {New-Item -Path `$path -ItemType $([System.Char]39)File$([System.Char]39) -Force}`n"
  "`n"
  "        #region | Use newer version of DISM in WinPE | Update Startup script to load drivers for DISM |`n"
  "        Copy-Item -Path $([System.Char]34)`${ADK x64 Tools Path}\DISM$([System.Char]34) -Destination $([System.Char]34)`${Mount Directory Path}$([System.Char]34) -Recurse`n"
  "        #Copy-Item -Path $([System.Char]34)`${ADK x64 Tools Path}\DISM$([System.Char]34) -Destination `${Mount Directory Path} -Recurse`n"
  "        ## md C:\WinPE_amd64\mount\DISM`n"
  "        ## robocopy $([System.Char]34)C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\DISM$([System.Char]34) C:\WinPE_amd64\mount\DISM`n"
  "        #endregion`n"
  "`n"
  "        `$path = $([System.Char]34)`${Mount Directory Path}\Canary 10.txt$([System.Char]34)`n"
  "        `$file = try {Get-Item -Path `$path -ErrorAction $([System.Char]39)Stop$([System.Char]39)} catch {New-Item -Path `$path -ItemType $([System.Char]39)File$([System.Char]39) -Force}`n"
  "`n"
  "        #region | Startup Script |`n"
  "        # Best performed separately. $([System.Char]34)`${Mount Directory Path}\Windows\System32\startnet.cmd$([System.Char]34) begins with a call to wpeinit`n"
  "        # Syntax for wpeinit is simple: `n"
  "        #     Wpeinit [-unattend:<path_to_answer_file>]`n"
  "        # Example of wpeinit in action: `n"
  "        #     Wpeinit -unattend:$([System.Char]34)C:\Unattend-PE.xml$([System.Char]34)`n"
  "        # So can Startnet.cmd launch a PowerShell script? `n"
  "        # I think it can. See the Unattend setting titled Microsoft-Windows-Setup/RunSynchronous. `n"
  "        # That's probably how the PowerShell script is going to launch. `n"
  "        #endregion`n"
  "`n"
  "        .\amd64\DISM\dism.exe /Unmount-Image /MountDir:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /Commit`n"
  "`n"
  "        #copype.cmd .\amd64\ $([System.Char]34)`${Updated ISO Folder Path}$([System.Char]34)`n"
  "        #MakeWinPeMedia.cmd /ISO $([System.Char]34)`${Updated ISO Folder Path}$([System.Char]34) $([System.Char]34)`${Updated ISO Folder Path}\`${WinPE Workspace Folder Name}.iso$([System.Char]34) /bootex`n"
  "`n"
  "`n"
  "        MakeWinPeMedia.cmd /UFD /f $([System.Char]34)`${Updated ISO Folder Path}$([System.Char]34) P: /bootex`n"
  "      }`n"
  "      #########################################-BOUNDARY-#########################################`n"
  "    }`n"
  "`t`t"


  [System.Void]{
    & { # Created with '.\ConvertTo-HereStringCompatible.ps1' |
      ${WinPE x64 Tools Path} = "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64"
      ${ADK x64 Tools Path} = Resolve-Path -Path "${WinPE x64 Tools Path}\..\..\Deployment Tools\amd64" | Select-Object -ExpandProperty 'Path'
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
      MakeWinPeMedia.cmd /ISO ${WinPE Default ISO Folder Path} "${WinPE Default ISO Folder Path}\WinPE Original.iso" /bootex
      # MakeWinPeMedia.cmd /ISO ${WinPE Default ISO Folder Path} 'C:\Users\lowpr\NoSync\reimages\rocks\WinPE Original.iso' /bootex
      # MakeWinPeMedia.cmd /ISO ${WinPE Default ISO Folder Path} 'C:\Users\lowpr\NoSync\reimages\rocks\WinPE Original.iso' /bootex
      # MakeWinPeMedia.cmd /UFD "${WinPE Default ISO Folder Path}" P: /bootex

      ${Updated ISO Folder Path} = "${WinPE Image Creation Parent Folder}\${WinPE Workspace Folder Name}\Updated ISO"
      $IsPresent = Test-Path -Path ${Updated ISO Folder Path}
      if (-not $IsPresent) {
        #${Updated ISO F0lder} = try {Get-Item -Path ${Updated ISO Folder Path} -ErrorAction 'Stop'} catch {New-Item -Path ${Updated ISO Folder Path} -ItemType 'Directory' -Force}
        # Copy-Item -Path "${WinPE Image Creation Path}\.Default ISO\bootbins" -Destination "${Updated ISO Folder Path}\bootbins" -Recurse
        # Copy-Item -Path "${WinPE Image Creation Path}\.Default ISO\media" -Destination "${Updated ISO Folder Path}\media" -Recurse
        # Copy-Item -Path "${WinPE Image Creation Path}\.Default ISO\mount" -Destination "${Updated ISO Folder Path}\mount" -Recurse

        copype.cmd .\amd64\ ${Updated ISO Folder Path}
        ${Mount Directory Path} = "${Updated ISO Folder Path}\mount"
        $lang = "en-us"
        # Get-ChildItem -Path "${Updated ISO Folder Path}\media" -Directory
        .\amd64\DISM\dism.exe /Mount-Image /ImageFile:"${Updated ISO Folder Path}\media\sources\boot.wim" /Index:1 /MountDir:"${Mount Directory Path}"
        #Copy-Item -Path "${WinPE x64 Tools Path}\$lang\WinPE.wim" -Destination "${Updated ISO Folder Path}"
        #.\amd64\DISM\dism.exe /Mount-Image /ImageFile:"${Updated ISO Folder Path}\WinPE.wim" /Index:1 /MountDir:"${Mount Directory Path}"
        
        # Get-Item -Path "${Updated ISO Folder Path}\WinPE.wim" | Rename-Item -NewName "${WinPE Workspace Folder Name}.wim"
        # dism.exe /Mount-Image /ImageFile:"${Updated ISO Folder Path}\WinPE.wim" /Index:1 /MountDir:"${Mount Directory Path}"
        # dism.exe /Get-ImageInfo /ImageFile:"${Updated ISO Folder Path}\${WinPE Workspace Folder Name}.wim"
        # dism.exe /Mount-Image /ImageFile:"${Updated ISO Folder Path}\${WinPE Workspace Folder Name}.wim" /Index:1 /MountDir:"${Mount Directory Path}"
              
        $path = "${Mount Directory Path}\Canary 00.txt"
        $file = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'File' -Force}

        #region | Enable Windows PowerShell support in WinPE |
        $PackagePath = "${WinPE x64 Tools Path}\WinPE_OCs"
        .\amd64\DISM\dism.exe /Add-Package /Image:"${Mount Directory Path}" /PackagePath:"$PackagePath\WinPE-WMI.cab"
        .\amd64\DISM\dism.exe /Add-Package /Image:"${Mount Directory Path}" /PackagePath:"$PackagePath\$lang\WinPE-WMI_$lang.cab"
        .\amd64\DISM\dism.exe /Add-Package /Image:"${Mount Directory Path}" /PackagePath:"$PackagePath\WinPE-NetFX.cab"
        .\amd64\DISM\dism.exe /Add-Package /Image:"${Mount Directory Path}" /PackagePath:"$PackagePath\$lang\WinPE-NetFX_$lang.cab"
        .\amd64\DISM\dism.exe /Add-Package /Image:"${Mount Directory Path}" /PackagePath:"$PackagePath\WinPE-Scripting.cab"
        .\amd64\DISM\dism.exe /Add-Package /Image:"${Mount Directory Path}" /PackagePath:"$PackagePath\$lang\WinPE-Scripting_$lang.cab"
        .\amd64\DISM\dism.exe /Add-Package /Image:"${Mount Directory Path}" /PackagePath:"$PackagePath\WinPE-PowerShell.cab"
        .\amd64\DISM\dism.exe /Add-Package /Image:"${Mount Directory Path}" /PackagePath:"$PackagePath\$lang\WinPE-PowerShell_$lang.cab"
        .\amd64\DISM\dism.exe /Add-Package /Image:"${Mount Directory Path}" /PackagePath:"$PackagePath\WinPE-StorageWMI.cab"
        .\amd64\DISM\dism.exe /Add-Package /Image:"${Mount Directory Path}" /PackagePath:"$PackagePath\$lang\WinPE-StorageWMI_$lang.cab"
        .\amd64\DISM\dism.exe /Add-Package /Image:"${Mount Directory Path}" /PackagePath:"$PackagePath\WinPE-DismCmdlets.cab"
        .\amd64\DISM\dism.exe /Add-Package /Image:"${Mount Directory Path}" /PackagePath:"$PackagePath\$lang\WinPE-DismCmdlets_$lang.cab"
        .\amd64\DISM\dism.exe /Add-Package /Image:"${Mount Directory Path}" /PackagePath:"$PackagePath\WinPE-SecureStartup.cab"
        .\amd64\DISM\dism.exe /Add-Package /Image:"${Mount Directory Path}" /PackagePath:"$PackagePath\$lang\WinPE-SecureStartup_$lang.cab"
        .\amd64\DISM\dism.exe /Add-Package /Image:"${Mount Directory Path}" /PackagePath:"$PackagePath\WinPE-EnhancedStorage.cab"
        .\amd64\DISM\dism.exe /Add-Package /Image:"${Mount Directory Path}" /PackagePath:"$PackagePath\$lang\WinPE-EnhancedStorage_$lang.cab"
        .\amd64\DISM\dism.exe /Add-Package /Image:"${Mount Directory Path}" /PackagePath:"$PackagePath\WinPE-PmemCmdlets.cab"
        .\amd64\DISM\dism.exe /Add-Package /Image:"${Mount Directory Path}" /PackagePath:"$PackagePath\$lang\WinPE-PmemCmdlets_$lang.cab"
        .\amd64\DISM\dism.exe /Add-Package /Image:"${Mount Directory Path}" /PackagePath:"$PackagePath\WinPE-PlatformId.cab"
        .\amd64\DISM\dism.exe /Add-Package /Image:"${Mount Directory Path}" /PackagePath:"$PackagePath\WinPE-SecureBootCmdlets.cab"
        .\amd64\DISM\dism.exe /Add-Package /Image:"${Mount Directory Path}" /PackagePath:"$PackagePath\WinPE-HSP-Driver.cab"
        #endregion

        $path = "${Mount Directory Path}\Canary 05.txt"
        $file = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'File' -Force}

        #region | Use newer version of DISM in WinPE | Update Startup script to load drivers for DISM |
        Copy-Item -Path "${ADK x64 Tools Path}\DISM" -Destination "${Mount Directory Path}" -Recurse
        #Copy-Item -Path "${ADK x64 Tools Path}\DISM" -Destination ${Mount Directory Path} -Recurse
        ## md C:\WinPE_amd64\mount\DISM
        ## robocopy "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\DISM" C:\WinPE_amd64\mount\DISM
        #endregion

        $path = "${Mount Directory Path}\Canary 10.txt"
        $file = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'File' -Force}

        #region | Startup Script |
        # Best performed separately. "${Mount Directory Path}\Windows\System32\startnet.cmd" begins with a call to wpeinit
        # Syntax for wpeinit is simple: 
        #     Wpeinit [-unattend:<path_to_answer_file>]
        # Example of wpeinit in action: 
        #     Wpeinit -unattend:"C:\Unattend-PE.xml"
        # So can Startnet.cmd launch a PowerShell script? 
        # I think it can. See the Unattend setting titled Microsoft-Windows-Setup/RunSynchronous.
        # That's probably how the PowerShell script is going to launch.
        #endregion

        .\amd64\DISM\dism.exe /Unmount-Image /MountDir:"${Mount Directory Path}" /Commit

        #copype.cmd .\amd64\ "${Updated ISO Folder Path}"
        #MakeWinPeMedia.cmd /ISO "${Updated ISO Folder Path}" "${Updated ISO Folder Path}\${WinPE Workspace Folder Name}.iso" /bootex


        MakeWinPeMedia.cmd /UFD /f "${Updated ISO Folder Path}" P: /bootex
      }
      #########################################-BOUNDARY-#########################################
    }


   } | Out-Null
  
) -join ''


${Unique WinPE ISO Command Here-String} = ${Unique WinPE ISO Command Here-String Precursor} -replace '%_explorer_owner_%',${explorer.exe Owner}
${Unique WinPE ISO Command Here-String} = ${Unique WinPE ISO Command Here-String} -replace '%_WinPE Workspace Folder Name_%',${WinPE Workspace Folder Name}

${Unique WinPE ISO Script Path} = "${WinPE Image Creation Parent Folder}\Unique WinPE ISO Script.ps1"
Set-Content -Path ${Unique WinPE ISO Script Path} -Value (${Unique WinPE ISO Command Here-String})
$WorkingDirectory = "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools"

$path = "${WinPE Image Creation Parent Folder}\${WinPE Workspace Folder Name}\Updated ISO"
$IsPresent = Test-Path -Path $path

<#
  if (-not $IsPresent) {
    Start-Process -FilePath cmd.exe -ArgumentList @(
      "/c $([System.Char]34)$WorkingDirectory\DandISetEnv.bat$([System.Char]34) && powershell.exe -NoProfile -ExecutionPolicy 'RemoteSigned'; Invoke-Expression -Command (Get-Content -Raw -Path '${Unique WinPE ISO Script Path}');"
    ) -Verb 'RunAs' -Wait
  }
#>





# "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\DandISetEnv.bat"
# #cmd /k powershell.exe -NoProfile -ExecutionPolicy 'RemoteSigned'; ni "$env:userprofile\hello0.txt";

#cmd /k 'C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\DandISetEnv.bat' && powershell.exe -NoProfile -ExecutionPolicy 'RemoteSigned'; ni C:\hello00.txt;



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

