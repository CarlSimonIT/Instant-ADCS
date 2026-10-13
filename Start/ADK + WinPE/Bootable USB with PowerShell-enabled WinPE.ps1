#Requires -Version 5.1
#Requires -PSEdition Desktop

param (
  ${WinPE Workspace Folder Name}
)

${explorer.exe Owner} = Import-CliXml -Path "$PSScriptRoot\..\..\..\.CommonItems\explorer.exe Owner.clixml"
${WinPE Image Creation Parent Path} = "$PSScriptRoot\..\..\..\.CommonItems\WinPE"
${WinPE Image Creation Parent Folder} = try {
  Get-Item -Path ${WinPE Image Creation Parent Path} -ErrorAction 'Stop'
} catch {
  New-Item -Path ${WinPE Image Creation Parent Path} -ItemType 'Directory' -Force
}
$FolderFQN = Import-CliXml -Path "$PSScriptRoot\..\..\..\.CommonItems\FolderFQN.clixml"
# Import into memory the unique identifiers for the disk holding the external removable bootable media: 
. "$PSScriptRoot\..\..\output\$FolderFQN\usb1\$FolderFQN\Base\5.1\External Bootable Media Drive Letters.ps1"


#region | ESP (EFI System Partition) |
#endregion


${Bootable USB with PowerShell-enabled WinPE Command Here-String Precursor} = $(
  #region | Keep |
  "#Requires -Version 5.1`n"
  "#Requires -PSEdition Desktop`n"
  "#Requires -RunAsAdministrator`n"
  "`n"
  #endregion
  #region | EFI System Partition on Removable External Bootable Media |
  "`${OSDeploy FriendlyName},`${OSDeploy SerialNumber},`${OSDeploy UniqueId Raw} = $([System.Char]39)%_OSDeploy FriendlyName_%$([System.Char]39),$([System.Char]39)%_OSDeploy SerialNumber_%$([System.Char]39),$([System.Char]39)%_OSDeploy UniqueId Raw_%$([System.Char]39)`n"
  "`${WinPE Workspace Folder Name},`${explorer.exe Owner},`${WinPE Image Creation Parent Path} = $([System.Char]39)%_WinPE Workspace Folder Name_%$([System.Char]39),$([System.Char]39)%_explorer_owner_%$([System.Char]39),$([System.Char]39)%_WinPE Image Creation Parent Path_%$([System.Char]39)`n"
  "& { # Created with $([System.Char]39).\ConvertTo-HereStringCompatible.ps1$([System.Char]39) |`n"
  "  `${Disk CIM Instance} = Get-Disk | Where-Object -FilterScript {`n"
  "    `$_.FriendlyName -eq `${OSDeploy FriendlyName} -and $([System.Char]96)`n"
  "    `$_.SerialNumber -eq `${OSDeploy SerialNumber} -and $([System.Char]96)`n"
  "    `$_.UniqueId     -eq `${OSDeploy UniqueId Raw}`n"
  "  }`n"
  "  `${Cleared Disk CIM Instance} = `${Disk CIM Instance} | Clear-Disk -RemoveData -RemoveOEM -Confirm:`$false -Verbose:`$true -PassThru`n"
  "`n"
  "  #`${Cleared Disk CIM Instance} | Set-Disk -PartitionStyle $([System.Char]39)GPT$([System.Char]39) -Verbose:`$true`n"
  "  #`${EFI System Partition CIM Instance} = `${Disk CIM Instance} | New-Partition -Size 1500MB -AssignDriveLetter -GptType $([System.Char]39){c12a7328-f81f-11d2-ba4b-00a0c93ec93b}$([System.Char]39) -Verbose:`$true`n"
  "  #`${EFI System Partition CIM Instance} = `${Disk CIM Instance} | New-Partition -Size 1500MB -AssignDriveLetter -GptType $([System.Char]39){ebd0a0a2-b9e5-4433-87c0-68b6b72699c7}$([System.Char]39) -Verbose:`$true`n"
  "`n"
  "  `${Cleared Disk CIM Instance} | Set-Disk -PartitionStyle $([System.Char]39)MBR$([System.Char]39) -Verbose:`$true`n"
  "  `${EFI System Partition CIM Instance} = `${Disk CIM Instance} | New-Partition -Size 1500MB -AssignDriveLetter -MbrType $([System.Char]39)FAT32$([System.Char]39) -Verbose:`$true`n"
  "`n"
  "  # The entirety of the EFI System Partition must contain a FAT32-formatted volume:`n"
  "  `$NewFileSystemLabel = $([System.Char]39)PRE_WINPE$([System.Char]39)`n"
  "  `${FAT32 Volume on ESP CIM Instance} = Format-Volume -FileSystem $([System.Char]39)FAT32$([System.Char]39) -DriveLetter `${EFI System Partition CIM Instance}.DriveLetter -NewFileSystemLabel `$NewFileSystemLabel -Verbose:`$true`n"
  "  <# NOTE! |`n"
  "    # The code below does not resolve any volume letters because at this point $([System.Char]39)PRE_WINPE$([System.Char]39) is a partition, and not a volume! |`n"
  "    `${WinPE Volume} = Get-Volume -FriendlyName `$NewFileSystemLabel -Verbose:`$true; `n"
  "    `${WinPE Bootable USB Volume Letter} = `${FAT32 Volume on ESP CIM Instance}.DriveLetter + $([System.Char]39):$([System.Char]39)`n"
  "  #>`n"
  "}`n"
  "`t`t"
  #endregion
  #########################################-BOUNDARY-#########################################
  {
    ${OSDeploy FriendlyName},${OSDeploy SerialNumber},${OSDeploy UniqueId Raw} = '%_OSDeploy FriendlyName_%','%_OSDeploy SerialNumber_%','%_OSDeploy UniqueId Raw_%'
    ${WinPE Workspace Folder Name},${explorer.exe Owner},${WinPE Image Creation Parent Path} = '%_WinPE Workspace Folder Name_%','%_explorer_owner_%','%_WinPE Image Creation Parent Path_%'
    & { # Created with '.\ConvertTo-HereStringCompatible.ps1' |
      ${Disk CIM Instance} = Get-Disk | Where-Object -FilterScript {
        $_.FriendlyName -eq ${OSDeploy FriendlyName} -and `
        $_.SerialNumber -eq ${OSDeploy SerialNumber} -and `
        $_.UniqueId     -eq ${OSDeploy UniqueId Raw}
      }
      ${Cleared Disk CIM Instance} = ${Disk CIM Instance} | Clear-Disk -RemoveData -RemoveOEM -Confirm:$false -Verbose:$true -PassThru

      #${Cleared Disk CIM Instance} | Set-Disk -PartitionStyle 'GPT' -Verbose:$true
      #${EFI System Partition CIM Instance} = ${Disk CIM Instance} | New-Partition -Size 1500MB -AssignDriveLetter -GptType '{c12a7328-f81f-11d2-ba4b-00a0c93ec93b}' -Verbose:$true
      #${EFI System Partition CIM Instance} = ${Disk CIM Instance} | New-Partition -Size 1500MB -AssignDriveLetter -GptType '{ebd0a0a2-b9e5-4433-87c0-68b6b72699c7}' -Verbose:$true

      ${Cleared Disk CIM Instance} | Set-Disk -PartitionStyle 'MBR' -Verbose:$true
      ${EFI System Partition CIM Instance} = ${Disk CIM Instance} | New-Partition -Size 1500MB -AssignDriveLetter -MbrType 'FAT32' -Verbose:$true

      # The entirety of the EFI System Partition must contain a FAT32-formatted volume:
      $NewFileSystemLabel = 'PRE_WINPE'
      ${FAT32 Volume on ESP CIM Instance} = Format-Volume -FileSystem 'FAT32' -DriveLetter ${EFI System Partition CIM Instance}.DriveLetter -NewFileSystemLabel $NewFileSystemLabel -Verbose:$true
      <# NOTE! |
        # The code below does not resolve any volume letters because at this point 'PRE_WINPE' is a partition, and not a volume! |
        ${WinPE Volume} = Get-Volume -FriendlyName $NewFileSystemLabel -Verbose:$true; 
        ${WinPE Bootable USB Volume Letter} = ${FAT32 Volume on ESP CIM Instance}.DriveLetter + ':'
      #>
    }
  } | Out-Null
  #########################################-BOUNDARY-#########################################
  #region |  |



  "`n"
  "& { # Created with $([System.Char]39).\ConvertTo-HereStringCompatible.ps1$([System.Char]39) |`n"
  "  `${WinPE x64 Tools Path} = $([System.Char]34)`${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64$([System.Char]34)`n"
  "  `${ADK x64 Tools Path} = Resolve-Path -Path $([System.Char]34)`${WinPE x64 Tools Path}\..\..\Deployment Tools\amd64$([System.Char]34) | Select-Object -ExpandProperty $([System.Char]39)Path$([System.Char]39)`n"
  "`n"
  "  # Define directory that contains unmodified files for WinPE ISO file generation`n"
  "  `${WinPE Image Creation Parent Folder} = try {`n"
  "    Get-Item -Path `${WinPE Image Creation Parent Path} -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
  "  } catch {`n"
  "    New-Item -Path `${WinPE Image Creation Parent Path} -ItemType $([System.Char]39)Directory$([System.Char]39) -Force`n"
  "  }`n"
  "  `${WinPE Image Creation Path} = $([System.Char]34)`${WinPE Image Creation Parent Path}\`${WinPE Workspace Folder Name}$([System.Char]34)`n"
  "  `${WinPE Default ISO Folder Path} = $([System.Char]34)`${WinPE Image Creation Path}\.Default ISO$([System.Char]34)`n"
  "`n"
  "  # Populate the contents of $([System.Char]39).\.Default ISO\$([System.Char]39) with unmodified files for WinPE ISO file generation`n"
  "  copype.cmd .\amd64\ `${WinPE Default ISO Folder Path}`n"
  "`n"
  "  # Write to disk an .iso file of an original, unmodified instance of WinPE`n"
  "  MakeWinPeMedia.cmd /ISO `${WinPE Default ISO Folder Path} $([System.Char]34)`${WinPE Default ISO Folder Path}\WinPE Original.iso$([System.Char]34) /bootex`n"
  "  #      MakeWinPeMedia.cmd /UFD `${WinPE Default ISO Folder Path} F: /bootex`n"
  "`n"
  "  `${Updated ISO Folder Path} = $([System.Char]34)`${WinPE Image Creation Parent Folder}\`${WinPE Workspace Folder Name}\Updated ISO$([System.Char]34)`n"
  "  `$IsPresent = Test-Path -Path `${Updated ISO Folder Path}`n"
  "  if (-not `$IsPresent) {`n"
  "    copype.cmd .\amd64\ `${Updated ISO Folder Path}`n"
  "    #`${Mount Directory Path} = $([System.Char]34)`${Updated ISO Folder Path}\mount$([System.Char]34)`n"
  "    `${Mount Directory Path} = $([System.Char]34)`${WinPE Image Creation Parent Folder}\`${WinPE Workspace Folder Name}\Outside Mount$([System.Char]34); `n"
  "    `$path = `${Mount Directory Path}; `n"
  "    `$folder = try {Get-Item -Path `$path -ErrorAction $([System.Char]39)Stop$([System.Char]39)} catch {New-Item -Path `$path -ItemType $([System.Char]39)Directory$([System.Char]39) -Force}`n"
  "    `$lang = $([System.Char]34)en-us$([System.Char]34)`n"
  "    .\amd64\DISM\dism.exe /Mount-Image /ImageFile:$([System.Char]34)`${Updated ISO Folder Path}\media\sources\boot.wim$([System.Char]34) /Index:1 /MountDir:$([System.Char]34)`${Mount Directory Path}$([System.Char]34)`n"
  "`n"
  "    `$path = $([System.Char]34)`${Mount Directory Path}\Canary 00.txt$([System.Char]34)`n"
  "    `$file = try {Get-Item -Path `$path -ErrorAction $([System.Char]39)Stop$([System.Char]39)} catch {New-Item -Path `$path -ItemType $([System.Char]39)File$([System.Char]39) -Force}`n"
  "`n"
  "    #region | Enable Windows PowerShell support in the WinPE operating system |`n"
  "    `$PackagePath = $([System.Char]34)`${WinPE x64 Tools Path}\WinPE_OCs$([System.Char]34)`n"
  "    .\amd64\DISM\dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\WinPE-WMI.cab$([System.Char]34)`n"
  "    .\amd64\DISM\dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\`$lang\WinPE-WMI_`$lang.cab$([System.Char]34)`n"
  "    .\amd64\DISM\dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\WinPE-NetFX.cab$([System.Char]34)`n"
  "    .\amd64\DISM\dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\`$lang\WinPE-NetFX_`$lang.cab$([System.Char]34)`n"
  "    .\amd64\DISM\dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\WinPE-Scripting.cab$([System.Char]34)`n"
  "    .\amd64\DISM\dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\`$lang\WinPE-Scripting_`$lang.cab$([System.Char]34)`n"
  "    .\amd64\DISM\dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\WinPE-PowerShell.cab$([System.Char]34)`n"
  "    .\amd64\DISM\dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\`$lang\WinPE-PowerShell_`$lang.cab$([System.Char]34)`n"
  "    .\amd64\DISM\dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\WinPE-StorageWMI.cab$([System.Char]34)`n"
  "    .\amd64\DISM\dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\`$lang\WinPE-StorageWMI_`$lang.cab$([System.Char]34)`n"
  "    .\amd64\DISM\dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\WinPE-DismCmdlets.cab$([System.Char]34)`n"
  "    .\amd64\DISM\dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\`$lang\WinPE-DismCmdlets_`$lang.cab$([System.Char]34)`n"
  "    .\amd64\DISM\dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\WinPE-SecureStartup.cab$([System.Char]34)`n"
  "    .\amd64\DISM\dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\`$lang\WinPE-SecureStartup_`$lang.cab$([System.Char]34)`n"
  "    .\amd64\DISM\dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\WinPE-EnhancedStorage.cab$([System.Char]34)`n"
  "    .\amd64\DISM\dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\`$lang\WinPE-EnhancedStorage_`$lang.cab$([System.Char]34)`n"
  "    .\amd64\DISM\dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\WinPE-PmemCmdlets.cab$([System.Char]34)`n"
  "    .\amd64\DISM\dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\`$lang\WinPE-PmemCmdlets_`$lang.cab$([System.Char]34)`n"
  "    .\amd64\DISM\dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\WinPE-PlatformId.cab$([System.Char]34)`n"
  "    .\amd64\DISM\dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\WinPE-SecureBootCmdlets.cab$([System.Char]34)`n"
  "    .\amd64\DISM\dism.exe /Add-Package /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /PackagePath:$([System.Char]34)`$PackagePath\WinPE-HSP-Driver.cab$([System.Char]34)`n"
  "    #endregion`n"
  "`n"
  "    `$path = $([System.Char]34)`${Mount Directory Path}\Canary 05.txt$([System.Char]34)`n"
  "    `$file = try {Get-Item -Path `$path -ErrorAction $([System.Char]39)Stop$([System.Char]39)} catch {New-Item -Path `$path -ItemType $([System.Char]39)File$([System.Char]39) -Force}`n"
  "`n"
  "    #region | Use newer version of DISM in WinPE | Update Startup script to load drivers for DISM |`n"
  "    Copy-Item -Path $([System.Char]34)`${ADK x64 Tools Path}\DISM$([System.Char]34) -Destination $([System.Char]34)`${Mount Directory Path}$([System.Char]34) -Recurse`n"
  "    #endregion`n"
  "`n"
  "    `$path = $([System.Char]34)`${Mount Directory Path}\Canary 10.txt$([System.Char]34)`n"
  "    `$file = try {Get-Item -Path `$path -ErrorAction $([System.Char]39)Stop$([System.Char]39)} catch {New-Item -Path `$path -ItemType $([System.Char]39)File$([System.Char]39) -Force}`n"
  "`n"
  "    #region | Startup Script |`n"
  "    # Best performed separately. $([System.Char]34)`${Mount Directory Path}\Windows\System32\startnet.cmd$([System.Char]34) begins with a call to wpeinit`n"
  "    # Syntax for wpeinit is simple: `n"
  "    #     Wpeinit [-unattend:<path_to_answer_file>]`n"
  "    # Example of wpeinit in action: `n"
  "    #     Wpeinit -unattend:$([System.Char]34)C:\Unattend-PE.xml$([System.Char]34)`n"
  "    # So can Startnet.cmd launch a PowerShell script? `n"
  "    # I think it can. See the Unattend setting titled Microsoft-Windows-Setup/RunSynchronous.`n"
  "    # That$([System.Char]39)s probably how the PowerShell script is going to launch.`n"
  "    #endregion`n"
  "`n"
  "    <# Unmount the WinPE image and create media |`n"
  "      start msedge.exe $([System.Char]39)https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/winpe-mount-and-customize?view=windows-11#unmount-the-windows-pe-image-and-create-media$([System.Char]39)`n"
  "    #>`n"
  "    .\amd64\DISM\dism.exe /Unmount-Image /MountDir:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /Commit`n"
  "    #copype.cmd .\amd64\ $([System.Char]34)`${Updated ISO Folder Path}$([System.Char]34)`n"
  "    #MakeWinPeMedia.cmd /ISO $([System.Char]34)`${Updated ISO Folder Path}$([System.Char]34) $([System.Char]34)`${Updated ISO Folder Path}\`${WinPE Workspace Folder Name}.iso$([System.Char]34) /bootex`n"
  "`n"
  "`n"
  "    `${Disk CIM Instance} = Get-Disk | Where-Object -FilterScript {`n"
  "      `$_.FriendlyName -eq `${OSDeploy FriendlyName} -and $([System.Char]96)`n"
  "      `$_.SerialNumber -eq `${OSDeploy SerialNumber} -and $([System.Char]96)`n"
  "      `$_.UniqueId     -eq `${OSDeploy UniqueId Raw}`n"
  "    }`n"
  "    `${WinPE Partition Drive Letter Precursor} = `${Disk CIM Instance} | Get-Partition | Select-Object -ExpandProperty $([System.Char]39)DriveLetter$([System.Char]39)`n"
  "    `${WinPE Partition Drive Letter} = [System.String]`${WinPE Partition Drive Letter Precursor} + $([System.Char]39):$([System.Char]39)`n"
  "`n"
  "    #MakeWinPeMedia.cmd /UFD /f $([System.Char]34)`${Updated ISO Folder Path}$([System.Char]34) $([System.Char]34)`${WinPE Partition Drive Letter}$([System.Char]34) /bootex`n"
  "    #MakeWinPeMedia.cmd /UFD /f $([System.Char]34)`${WinPE Default ISO Folder Path}$([System.Char]34) $([System.Char]34)`${WinPE Partition Drive Letter}$([System.Char]34) /bootex`n"
  "    #MakeWinPeMedia.cmd /UFD /f $([System.Char]34)`${Mount Directory Path}$([System.Char]34) $([System.Char]34)`${WinPE Partition Drive Letter}$([System.Char]34) /bootex`n"
  "    #MakeWinPeMedia.cmd /UFD /f `${Mount Directory Path} `${WinPE Partition Drive Letter} /bootex`n"
  "    <#`n"
  "      start msedge.exe $([System.Char]39)https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/makewinpemedia-command-line-options?view=windows-11&source=recommendations#makewinpemedia-parameters$([System.Char]39)`n"
  "    #>`n"
  "    MakeWinPeMedia.cmd /UFD /f `${Updated ISO Folder Path} `${WinPE Partition Drive Letter} /bootex`n"
  "  }`n"
  "}`n"
  "`t`t"



  #endregion
  #########################################-BOUNDARY-#########################################
  {
    & { # Created with '.\ConvertTo-HereStringCompatible.ps1' |
      ${WinPE x64 Tools Path} = "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64"
      ${ADK x64 Tools Path} = Resolve-Path -Path "${WinPE x64 Tools Path}\..\..\Deployment Tools\amd64" | Select-Object -ExpandProperty 'Path'

      # Define directory that contains unmodified files for WinPE ISO file generation
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

      ${Updated ISO Folder Path} = "${WinPE Image Creation Parent Folder}\${WinPE Workspace Folder Name}\Updated ISO"
      $IsPresent = Test-Path -Path ${Updated ISO Folder Path}
      if (-not $IsPresent) {
        copype.cmd .\amd64\ ${Updated ISO Folder Path}
        ${Mount Directory Path} = "${WinPE Image Creation Parent Folder}\${WinPE Workspace Folder Name}\Outside Mount"; 
        $path = ${Mount Directory Path}; 
        $folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
        $lang = "en-us"
        .\amd64\DISM\dism.exe /Mount-Image /ImageFile:"${Updated ISO Folder Path}\media\sources\boot.wim" /Index:1 /MountDir:"${Mount Directory Path}"

        #region | Enable Windows PowerShell support in the WinPE operating system |
        $path = "${Mount Directory Path}\Canary 00.txt"
        $file = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'File' -Force}

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

        $path = "${Mount Directory Path}\Canary 05.txt"
        $file = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'File' -Force}
        #endregion

        #region | Use newer version of DISM in WinPE | Update Startup script to load drivers for DISM |
        Copy-Item -Path "${ADK x64 Tools Path}\DISM" -Destination "${Mount Directory Path}" -Recurse
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

        # Unmount the WinPE image and create media
        .\amd64\DISM\dism.exe /Unmount-Image /MountDir:"${Mount Directory Path}" /Commit

        ${Disk CIM Instance} = Get-Disk | Where-Object -FilterScript {
          $_.FriendlyName -eq ${OSDeploy FriendlyName} -and `
          $_.SerialNumber -eq ${OSDeploy SerialNumber} -and `
          $_.UniqueId     -eq ${OSDeploy UniqueId Raw}
        }
        ${WinPE Partition Drive Letter Precursor} = ${Disk CIM Instance} | Get-Partition | Select-Object -ExpandProperty 'DriveLetter'
        ${WinPE Partition Drive Letter} = [System.String]${WinPE Partition Drive Letter Precursor} + ':'

        MakeWinPeMedia.cmd /UFD /f ${Updated ISO Folder Path} ${WinPE Partition Drive Letter} /bootex
      }
    }
  } | Out-Null
  #########################################-BOUNDARY-#########################################
) -join ''

<#
  Prep And  Burn
  Bootable USB with PowerShell-enabled WinPE
#>

${Bootable USB with PowerShell-enabled WinPE Command Here-String} = ${Bootable USB with PowerShell-enabled WinPE Command Here-String Precursor} -replace '%_OSDeploy FriendlyName_%',${OSDeploy FriendlyName}
${Bootable USB with PowerShell-enabled WinPE Command Here-String} = ${Bootable USB with PowerShell-enabled WinPE Command Here-String} -replace '%_OSDeploy SerialNumber_%',${OSDeploy SerialNumber}
${Bootable USB with PowerShell-enabled WinPE Command Here-String} = ${Bootable USB with PowerShell-enabled WinPE Command Here-String} -replace '%_OSDeploy UniqueId Raw_%',${OSDeploy UniqueId Raw}
${Bootable USB with PowerShell-enabled WinPE Command Here-String} = ${Bootable USB with PowerShell-enabled WinPE Command Here-String} -replace '%_explorer_owner_%',${explorer.exe Owner}
${Bootable USB with PowerShell-enabled WinPE Command Here-String} = ${Bootable USB with PowerShell-enabled WinPE Command Here-String} -replace '%_WinPE Workspace Folder Name_%',${WinPE Workspace Folder Name}
${Bootable USB with PowerShell-enabled WinPE Command Here-String} = ${Bootable USB with PowerShell-enabled WinPE Command Here-String} -replace '%_WinPE Image Creation Parent Path_%',${WinPE Image Creation Parent Path}


${Bootable USB with PowerShell-enabled WinPE Command} = [ScriptBlock]::Create(${Bootable USB with PowerShell-enabled WinPE Command Here-String})

<##>
${Bootable USB with PowerShell-enabled WinPE Script Path} = "${WinPE Image Creation Parent Folder}\Bootable USB with PowerShell-enabled WinPE Script.ps1"
Set-Content -Path ${Bootable USB with PowerShell-enabled WinPE Script Path} -Value (${Bootable USB with PowerShell-enabled WinPE Command Here-String})

$WorkingDirectory = "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools"
return @{
  'Bootable USB with PowerShell-enabled WinPE Script Path' = ${Bootable USB with PowerShell-enabled WinPE Script Path}
  WorkingDirectory                                         = ${WorkingDirectory}
  'WinPE Image Creation Parent Folder'                     = ${WinPE Image Creation Parent Folder}
}

<#
  Start-Process powershell.exe -ArgumentList @(
    ${Bootable USB with PowerShell-enabled WinPE Command}
  ) -Verb 'RunAs' -Verbose:$true -WindowStyle 'Normal' -Wait
#>

<#
  Start-Process powershell.exe -ArgumentList ${Bootable USB with PowerShell-enabled WinPE Command} -Verb 'RunAs' -Verbose:$true -WindowStyle 'Normal' -Wait
#>
<# Unmount the WinPE image and create media |
  start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/winpe-mount-and-customize?view=windows-11#unmount-the-windows-pe-image-and-create-media'
#>
<# CLI Options for the MakeWinPeMedia.cmd batch file |
  start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/makewinpemedia-command-line-options?view=windows-11&source=recommendations#makewinpemedia-parameters'
#>

<#
  $ArgumentList = @(
    "`${Here-String} = Get-Item -Path '${Bootable USB with PowerShell-enabled WinPE Script Path}' | Get-Content -Raw; `$ScriptBlock = [ScriptBlock]::Create(`${Here-String}); `$ScriptBlock | Invoke-Expression"
  )
  Start-Process -FilePath powershell.exe -ArgumentList $ArgumentList -Verb 'RunAs' -Verbose:$true -WindowStyle 'Normal' -Wait
#>


<#

  $WorkingDirectory = "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools"
  #         ${cmd H-S} = Get-Content -Raw -Path ${Bootable USB with PowerShell-enabled WinPE Script Path}; ${cmd ScBk} = [ScriptBlock]::Create(${cmd H-S}); & ${cmd ScBk}
  $path = "${WinPE Image Creation Parent Folder}\${WinPE Workspace Folder Name}\Updated ISO"
  $IsPresent = Test-Path -Path $path
  if (-not $IsPresent) {
    Start-Process -FilePath cmd.exe -ArgumentList @(
      #"/c $([System.Char]34)$WorkingDirectory\DandISetEnv.bat$([System.Char]34) && powershell.exe -NoProfile -ExecutionPolicy 'RemoteSigned'; Invoke-Expression -Command (Get-Content -Raw -Path '${Bootable USB with PowerShell-enabled WinPE Script Path}');"
      "/c $([System.Char]34)$WorkingDirectory\DandISetEnv.bat$([System.Char]34) && powershell.exe -NoProfile -ExecutionPolicy 'RemoteSigned'; `${cmd H-S} = gc -Raw -Path '${Bootable USB with PowerShell-enabled WinPE Script Path}'; `${cmd ScBk} = [ScriptBlock]::Create(`${cmd H-S}); & `${cmd ScBk}"
    ) -Verb 'RunAs' -Wait
  }
#>

<#
  $path = "${WinPE Image Creation Parent Folder}\${WinPE Workspace Folder Name}\Updated ISO"
  $IsPresent = Test-Path -Path $path
  if (-not $IsPresent) {
    $ArgumentList = @(
      $WorkingDirectory
      ${Bootable USB with PowerShell-enabled WinPE Script Path}
    )
    Start-Job -Name ${WinPE Workspace Folder Name} -ArgumentList $ArgumentList -ScriptBlock {
      $WorkingDirectory = $args[0]
      ${Bootable USB with PowerShell-enabled WinPE Script Path} = $args[1]
      Start-Process -FilePath cmd.exe -ArgumentList @(
        "/c $([System.Char]34)$WorkingDirectory\DandISetEnv.bat$([System.Char]34) && powershell.exe -NoProfile -ExecutionPolicy 'RemoteSigned'; Invoke-Expression -Command (Get-Content -Raw -Path '${Bootable USB with PowerShell-enabled WinPE Script Path}');"
      ) -Verb 'RunAs' -Verbose:$true -WindowStyle 'Hidden' -Wait
    }
  }
#>







