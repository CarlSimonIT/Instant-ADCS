#Requires -Version 5.1
#Requires -PSEdition Desktop

param (
  ${WinPE Workspace Folder Name}
)

Set-StrictMode -Version 'Latest'

#region | Multi-script common variables |
${explorer.exe Owner} = Import-CliXml -Path "$PSScriptRoot\..\..\..\.CommonItems\explorer.exe Owner.clixml"
$FolderFQN = Import-CliXml -Path "$PSScriptRoot\..\..\..\.CommonItems\FolderFQN.clixml"
${WinPE Image Creation Parent Path} = "$PSScriptRoot\..\..\..\.CommonItems\WinPE"
${WinPE Image Creation Parent Folder} = try {
  Get-Item -Path ${WinPE Image Creation Parent Path} -ErrorAction 'Stop'
} catch {
  New-Item -Path ${WinPE Image Creation Parent Path} -ItemType 'Directory' -Force
}
#[System.Environment]::SetEnvironmentVariable('.CommonItems',"$PSScriptRoot\..\..\.CommonItems")
[System.Environment]::SetEnvironmentVariable(
  '.CommonItems',
  $(Resolve-Path -Path "$PSScriptRoot\..\..\..\.CommonItems" | Select-Object -ExpandProperty 'Path')
)

#${Cultures Defined} = Import-CliXml -Path "$PSScriptRoot\..\..\..\.CommonItems\Cultures Defined.clixml"
${Cultures Defined} = Import-CliXml -Path "${env:.CommonItems}\Cultures Defined.clixml"
# Import into memory the unique identifiers for the disk holding the external removable bootable media: 
. "$PSScriptRoot\..\..\output\$FolderFQN\usb1\$FolderFQN\Base\5.1\External Bootable Media Drive Letters.ps1"
#endregion

#region | Write "${env:.CommonItems}\WinPE\startnet.cmd" to the file system of the technician PC |
${startnet.cmd File Contents} = $(

  #region |  |
  "`n"
  "wpeinit.exe`n"
  "powercfg.exe /s 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c`n"
  "powershell.exe -command $([System.Char]34)iex $([System.Char]39)Set-ExecutionPolicy RemoteSigned; & X:\Scriptoids\00-sample.ps1$([System.Char]39)$([System.Char]34)`n"
  "powershell.exe -command $([System.Char]34)iex $([System.Char]39)& X:\Scriptoids\01-DiskPartClean.ps1$([System.Char]39)$([System.Char]34)`n"
  "powershell.exe -command $([System.Char]34)iex $([System.Char]39)& X:\Scriptoids\03-OsDiskPart1.ps1$([System.Char]39)$([System.Char]34)`n"
  "powershell.exe -command $([System.Char]34)iex $([System.Char]39)& X:\Scriptoids\03-OsDiskPart2.ps1$([System.Char]39)$([System.Char]34)`n"
  "powershell.exe -command $([System.Char]34)iex $([System.Char]39)& X:\Scriptoids\05-DismLoad-ApplyImage.ps1$([System.Char]39)$([System.Char]34)`n"
  "`t`t"
  #endregion


  #########################################-BOUNDARY-#########################################
  { # Create with ConvertTo-HereStringPrecursor |
    wpeinit.exe
    powercfg.exe /s 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c
    powershell.exe -command "iex 'Set-ExecutionPolicy RemoteSigned; & X:\Scriptoids\00-sample.ps1'"
    powershell.exe -command "iex '& X:\Scriptoids\01-DiskPartClean.ps1'"
    powershell.exe -command "iex '& X:\Scriptoids\03-OsDiskPart1.ps1'"
    powershell.exe -command "iex '& X:\Scriptoids\03-OsDiskPart2.ps1'"
    powershell.exe -command "iex '& X:\Scriptoids\05-DismLoad-ApplyImage.ps1'"




  } | Out-Null
  #########################################-BOUNDARY-#########################################
) -join ''

${startnet.cmd File Path} = "${WinPE Image Creation Parent Folder}\startnet.cmd"
Set-Content -Path ${startnet.cmd File Path} -Value (${startnet.cmd File Contents})
#endregion

#region | Write "${env:.CommonItems}\WinPE\00-sample.ps1" to the file system of the technician PC |
${00-sample Command Here-String Precursor} = $(
  #region | OS Disk | Hyper-V Disk |


  #region |  |
  "`n"
  "& {`n"
  "  Get-Process`n"
  "  Set-ExecutionPolicy -ExecutionPolicy $([System.Char]39)RemoteSigned$([System.Char]39) -Scope $([System.Char]39)LocalMachine$([System.Char]39) -Force`n"
  "}`n"
  "`t`t"

  #endregion

  #endregion
  #########################################-BOUNDARY-#########################################
  { # Create with ConvertTo-HereStringPrecursor |
    & {
      Get-Process
      Set-ExecutionPolicy -ExecutionPolicy 'RemoteSigned' -Scope 'LocalMachine' -Force
    }
  } | Out-Null
  #########################################-BOUNDARY-#########################################
) -join ''

${00-sample Command Here-String} = ${00-sample Command Here-String Precursor}
${00-sample Command} = [ScriptBlock]::Create(${00-sample Command Here-String})

${00-sample Script Path} = "${WinPE Image Creation Parent Folder}\00-sample.ps1"
Set-Content -Path ${00-sample Script Path} -Value (${00-sample Command Here-String})
#endregion

#region | Write "${env:.CommonItems}\WinPE\01-DiskPartClean.ps1" to the file system of the technician PC |
${01-DiskPartClean Command Here-String Precursor} = $(
  #region |  |

  "`n"
  "& {`n"
  "  `${non-USB disks} = (Get-Disk).Where({`$_.BusType -match $([System.Char]39)NVMe|SATA$([System.Char]39)}) | Sort-Object -Property $([System.Char]39)Size$([System.Char]39)`n"
  "  foreach (`${non-USB disk} in `${non-USB disks}) {`n"
  "    `${DiskPartClean Here-String Precursor} = $([System.Char]34)select disk %_DISK_NUMBER_%$([System.Char]34)`n"
  "    `${DiskPartClean Here-String Precursor} += $([System.Char]34)`n$([System.Char]34)`n"
  "    `${DiskPartClean Here-String Precursor} += $([System.Char]34)clean$([System.Char]34)`n"
  "    `${DiskPartClean Here-String} = `${DiskPartClean Here-String Precursor} -replace $([System.Char]39)%_DISK_NUMBER_%$([System.Char]39),`${non-USB disk}.Number`n"
  "    `$ContentPath = $([System.Char]34)X:\Scriptoids\DiskPartClean`$(`${non-USB disk}.Number).txt$([System.Char]34)`n"
  "    Set-Content -Path `$ContentPath -Value (`${DiskPartClean Here-String})`n"
  "    `$ArgumentList = @(`n"
  "      $([System.Char]39)/s$([System.Char]39)`n"
  "      `$ContentPath`n"
  "    )`n"
  "    Start-Process diskpart.exe -ArgumentList `$ArgumentList -NoNewWindow`n"
  "  }`n"
  "  Write-Host -Object $([System.Char]34)Sleeping for 3 seconds...$([System.Char]34)`n"
  "  Start-Sleep 3`n"
  "}`n"
  "`t`t"



  #endregion
  #########################################-BOUNDARY-#########################################
  { # Create with ConvertTo-HereStringPrecursor |
    & {
      ${non-USB disks} = (Get-Disk).Where({$_.BusType -match 'NVMe|SATA'}) | Sort-Object -Property 'Size'
      foreach (${non-USB disk} in ${non-USB disks}) {
        ${DiskPartClean Here-String Precursor} = "select disk %_DISK_NUMBER_%"
        ${DiskPartClean Here-String Precursor} += "`n"
        ${DiskPartClean Here-String Precursor} += "clean"
        ${DiskPartClean Here-String} = ${DiskPartClean Here-String Precursor} -replace '%_DISK_NUMBER_%',${non-USB disk}.Number
        $ContentPath = "X:\Scriptoids\DiskPartClean$(${non-USB disk}.Number).txt"
        Set-Content -Path $ContentPath -Value (${DiskPartClean Here-String})
        $ArgumentList = @(
          '/s'
          $ContentPath
        )
        Start-Process diskpart.exe -ArgumentList $ArgumentList -NoNewWindow
      }
      Write-Host -Object "Sleeping for 3 seconds..."
      Start-Sleep 3
    }
  } | Out-Null
  #########################################-BOUNDARY-#########################################
) -join ''

${01-DiskPartClean Command Here-String} = ${01-DiskPartClean Command Here-String Precursor}
${01-DiskPartClean Command} = [ScriptBlock]::Create(${01-DiskPartClean Command Here-String})

${01-DiskPartClean Script Path} = "${WinPE Image Creation Parent Folder}\01-DiskPartClean.ps1"
Set-Content -Path ${01-DiskPartClean Script Path} -Value (${01-DiskPartClean Command Here-String})
#endregion

#region | Write "${env:.CommonItems}\WinPE\03-OsDiskPart1.ps1" to the file system of the technician PC |
${03-OsDiskPart1 Command Here-String Precursor} = $(
  #region | OS Disk | Hyper-V Disk |

  #region |  |
  "`n"
  "    & {`n"
  "      `$PSModuleInfo = Import-Module $([System.Char]39)Storage$([System.Char]39) -PassThru -Force`n"
  "`n"
  "      #region | Initialize All SATA/NVMe Disks |`n"
  "      `${non-USB disks} = (Get-Disk).Where({`$_.BusType -match $([System.Char]39)NVMe|SATA$([System.Char]39)}) | Sort-Object -Property $([System.Char]39)Size$([System.Char]39)`n"
  "      #   foreach (`${non-USB disk} in `${non-USB disks}) {Clear-Disk -UniqueId `${non-USB disk}.UniqueId -RemoveData -RemoveOEM -Confirm:`$false -Verbose:`$false -PassThru}`n"
  "      foreach (`${non-USB disk} in `${non-USB disks}) {`n"
  "        Initialize-Disk -UniqueId `${non-USB disk}.UniqueId -PartitionStyle $([System.Char]39)GPT$([System.Char]39) -Confirm:`$false -Verbose:`$true -PassThru`n"
  "      }`n"
  "      #endregion`n"
  "`n"
  "      #region | OS Disk |`n"
  "      `${OS Disk CIM Instance} = `${non-USB disks}[0]`n"
  "      #`${OS Disk CIM Instance} = `${Discovered OS Disk CIM Instance} | Clear-Disk -RemoveData -RemoveOEM -Confirm:`$false -Verbose:`$false -PassThru`n"
  "      Set-Disk -UniqueId `${OS Disk CIM Instance}.UniqueId -PartitionStyle $([System.Char]39)GPT$([System.Char]39)`n"
  "      #region | EFI System Partition |`n"
  "      `${EFI System Partition OS Disk CIM Instance} = `${OS Disk CIM Instance} | New-Partition -GptType $([System.Char]39){c12a7328-f81f-11d2-ba4b-00a0c93ec93b}$([System.Char]39) -Size 628MB # -AssignDriveLetter`n"
  "      # The entirety of the EFI System Partition must contain a FAT32-formatted volume:`n"
  "      #`$NewFileSystemLabel = $([System.Char]39)EFI_SP$([System.Char]39)`n"
  "      `$NewFileSystemLabel = $([System.Char]39)System$([System.Char]39)`n"
  "      #`${FAT32 Volume on EFI System Partition OS Disk CIM Instance} = Format-Volume -FileSystem $([System.Char]39)FAT32$([System.Char]39) -NewFileSystemLabel `$NewFileSystemLabel # -DriveLetter `${EFI System Partition OS Disk CIM Instance}.DriveLetter`n"
  "      `${FAT32 Volume on EFI System Partition OS Disk CIM Instance} = `${EFI System Partition OS Disk CIM Instance} | Format-Volume -FileSystem $([System.Char]39)FAT32$([System.Char]39) -NewFileSystemLabel `$NewFileSystemLabel # -DriveLetter `${EFI System Partition OS Disk CIM Instance}.DriveLetter`n"
  "      #`${EFI_SP Volume Letter} = `${FAT32 Volume on EFI System Partition OS Disk CIM Instance}.DriveLetter + $([System.Char]39):$([System.Char]39)`n"
  "      #endregion`n"
  "      #region | Microsoft Reserved Partition |`n"
  "      `${MS Reserved Partition OS Disk CIM Instance} = `${OS Disk CIM Instance} | New-Partition -GptType $([System.Char]39){e3c9e316-0b5c-4db8-817d-f92df00215ae}$([System.Char]39) # -Size 20MB # -AssignDriveLetter`n"
  "      #endregion`n"
  "      #region | OS Partition |`n"
  "      `${OS Partition Size} = `${OS Disk CIM Instance}.Size - (`${EFI System Partition OS Disk CIM Instance}.Size + `${MS Reserved Partition OS Disk CIM Instance}.Size + 888MB)`n"
  "      `${OS Partition OS Disk CIM Instance} = `${OS Disk CIM Instance} | New-Partition -GptType $([System.Char]39){ebd0a0a2-b9e5-4433-87c0-68b6b72699c7}$([System.Char]39) -Size (`${OS Partition Size}) -AssignDriveLetter   # -UseMaximumSize`n"
  "      Export-CliXml -Path $([System.Char]34)X:\Scriptoids\OS Partition OS Disk CIM Instance.clixml$([System.Char]34) -InputObject (`${OS Partition OS Disk CIM Instance})`n"
  "      `${OS Volume OS Partition OS Disk CIM Instance} = `${OS Partition OS Disk CIM Instance} | Format-Volume -FileSystem $([System.Char]39)NTFS$([System.Char]39) -NewFileSystemLabel $([System.Char]39)LocalOS$([System.Char]39)`n"
  "      Export-CliXml -Path $([System.Char]34)X:\Scriptoids\OS Volume OS Partition OS Disk CIM Instance.clixml$([System.Char]34) -InputObject (`${OS Volume OS Partition OS Disk CIM Instance})`n"
  "      #endregion`n"
  "      #region | Recovery Partition |`n"
  "      Export-CliXml -Path $([System.Char]34)X:\Scriptoids\OS Disk CIM Instance.clixml$([System.Char]34) -InputObject (`${OS Disk CIM Instance})`n"
  "      `${Recovery Partition OS Disk CIM Instance} = `${OS Disk CIM Instance} | New-Partition -GptType $([System.Char]39){de94bba4-06d1-4d40-a16a-bfd50179d6ac}$([System.Char]39) -UseMaximumSize`n"
  "      Export-CliXml -Path $([System.Char]34)X:\Scriptoids\Recovery Partition OS Disk CIM Instance.clixml$([System.Char]34) -InputObject (`${Recovery Partition OS Disk CIM Instance})`n"
  "      `${Recovery Volume OS Disk CIM Instance} = `${Recovery Partition OS Disk CIM Instance} | Format-Volume -FileSystem $([System.Char]39)NTFS$([System.Char]39) -NewFileSystemLabel $([System.Char]39)Recovery$([System.Char]39)`n"
  "      Export-CliXml -Path $([System.Char]34)X:\Scriptoids\Recovery Volume OS Disk CIM Instance.clixml$([System.Char]34) -InputObject (`${Recovery Volume OS Disk CIM Instance})`n"
  "      #endregion`n"
  "`n"
  "      #endregion`n"
  "    }`n"
  "`t`t"

  #endregion

  #endregion
  #########################################-BOUNDARY-#########################################
  { # Create with ConvertTo-HereStringPrecursor |
    & {
      $PSModuleInfo = Import-Module 'Storage' -PassThru -Force

      #region | Initialize All SATA/NVMe Disks |
      ${non-USB disks} = (Get-Disk).Where({$_.BusType -match 'NVMe|SATA'}) | Sort-Object -Property 'Size'
      #   foreach (${non-USB disk} in ${non-USB disks}) {Clear-Disk -UniqueId ${non-USB disk}.UniqueId -RemoveData -RemoveOEM -Confirm:$false -Verbose:$false -PassThru}
      foreach (${non-USB disk} in ${non-USB disks}) {
        Initialize-Disk -UniqueId ${non-USB disk}.UniqueId -PartitionStyle 'GPT' -Confirm:$false -Verbose:$true -PassThru
      }
      #endregion

      #region | OS Disk |
      ${OS Disk CIM Instance} = ${non-USB disks}[0]
      #${OS Disk CIM Instance} = ${Discovered OS Disk CIM Instance} | Clear-Disk -RemoveData -RemoveOEM -Confirm:$false -Verbose:$false -PassThru
      Set-Disk -UniqueId ${OS Disk CIM Instance}.UniqueId -PartitionStyle 'GPT'
      #region | EFI System Partition |
      ${EFI System Partition OS Disk CIM Instance} = ${OS Disk CIM Instance} | New-Partition -GptType '{c12a7328-f81f-11d2-ba4b-00a0c93ec93b}' -Size 628MB # -AssignDriveLetter
      # The entirety of the EFI System Partition must contain a FAT32-formatted volume:
      #$NewFileSystemLabel = 'EFI_SP'
      $NewFileSystemLabel = 'System'
      #${FAT32 Volume on EFI System Partition OS Disk CIM Instance} = Format-Volume -FileSystem 'FAT32' -NewFileSystemLabel $NewFileSystemLabel # -DriveLetter ${EFI System Partition OS Disk CIM Instance}.DriveLetter
      ${FAT32 Volume on EFI System Partition OS Disk CIM Instance} = ${EFI System Partition OS Disk CIM Instance} | Format-Volume -FileSystem 'FAT32' -NewFileSystemLabel $NewFileSystemLabel # -DriveLetter ${EFI System Partition OS Disk CIM Instance}.DriveLetter
      #${EFI_SP Volume Letter} = ${FAT32 Volume on EFI System Partition OS Disk CIM Instance}.DriveLetter + ':'
      #endregion
      #region | Microsoft Reserved Partition |
      ${MS Reserved Partition OS Disk CIM Instance} = ${OS Disk CIM Instance} | New-Partition -GptType '{e3c9e316-0b5c-4db8-817d-f92df00215ae}' # -Size 20MB # -AssignDriveLetter
      #endregion
      #region | OS Partition |
      ${OS Partition Size} = ${OS Disk CIM Instance}.Size - (${EFI System Partition OS Disk CIM Instance}.Size + ${MS Reserved Partition OS Disk CIM Instance}.Size + 888MB)
      ${OS Partition OS Disk CIM Instance} = ${OS Disk CIM Instance} | New-Partition -GptType '{ebd0a0a2-b9e5-4433-87c0-68b6b72699c7}' -Size (${OS Partition Size}) -AssignDriveLetter   # -UseMaximumSize
      Export-CliXml -Path "X:\Scriptoids\OS Partition OS Disk CIM Instance.clixml" -InputObject (${OS Partition OS Disk CIM Instance})
      ${OS Volume OS Partition OS Disk CIM Instance} = ${OS Partition OS Disk CIM Instance} | Format-Volume -FileSystem 'NTFS' -NewFileSystemLabel 'LocalOS'
      Export-CliXml -Path "X:\Scriptoids\OS Volume OS Partition OS Disk CIM Instance.clixml" -InputObject (${OS Volume OS Partition OS Disk CIM Instance})
      #endregion
      #region | Recovery Partition |
      Export-CliXml -Path "X:\Scriptoids\OS Disk CIM Instance.clixml" -InputObject (${OS Disk CIM Instance})
      ${Recovery Partition OS Disk CIM Instance} = ${OS Disk CIM Instance} | New-Partition -GptType '{de94bba4-06d1-4d40-a16a-bfd50179d6ac}' -UseMaximumSize
      Export-CliXml -Path "X:\Scriptoids\Recovery Partition OS Disk CIM Instance.clixml" -InputObject (${Recovery Partition OS Disk CIM Instance})
      ${Recovery Volume OS Disk CIM Instance} = ${Recovery Partition OS Disk CIM Instance} | Format-Volume -FileSystem 'NTFS' -NewFileSystemLabel 'Recovery'
      Export-CliXml -Path "X:\Scriptoids\Recovery Volume OS Disk CIM Instance.clixml" -InputObject (${Recovery Volume OS Disk CIM Instance})
      #endregion

      #endregion
    }
  } | Out-Null
  #########################################-BOUNDARY-#########################################
) -join ''

${03-OsDiskPart1 Command Here-String} = ${03-OsDiskPart1 Command Here-String Precursor}
${03-OsDiskPart1 Command} = [ScriptBlock]::Create(${03-OsDiskPart1 Command Here-String})
${03-OsDiskPart1 Script Path} = "${WinPE Image Creation Parent Folder}\03-OsDiskPart1.ps1"
Set-Content -Path ${03-OsDiskPart1 Script Path} -Value (${03-OsDiskPart1 Command Here-String})
#endregion

#region | Write "${env:.CommonItems}\WinPE\03-OsDiskPart2.ps1" to the file system of the technician PC |
${03-OsDiskPart2 Command Here-String Precursor} = $(
  #region | OS Disk | Hyper-V Disk |

  #region |  |
  "`n"
  "& {`n"
  "  `$PSModuleInfo = Import-Module $([System.Char]39)Storage$([System.Char]39) -PassThru -Force`n"
  "  `${OS Disk CIM Instance} = Import-CliXml -Path $([System.Char]34)X:\Scriptoids\OS Disk CIM Instance.clixml$([System.Char]34)`n"
  "  `${Recovery Partition OS Disk CIM Instance} = Import-CliXml -Path $([System.Char]34)X:\Scriptoids\Recovery Partition OS Disk CIM Instance.clixml$([System.Char]34)`n"
  "  `${Recovery Volume OS Disk CIM Instance} = Import-CliXml -Path $([System.Char]34)X:\Scriptoids\Recovery Volume OS Disk CIM Instance.clixml$([System.Char]34)`n"
  "`n"
  "`n"
  "  `${Apply GPT Attributes to Recovery Partition Here-String Precursor} = $([System.Char]34)select disk %_DISK_NUMBER_%$([System.Char]34)`n"
  "  `${Apply GPT Attributes to Recovery Partition Here-String Precursor} += $([System.Char]34)`n$([System.Char]34)`n"
  "  `${Apply GPT Attributes to Recovery Partition Here-String Precursor} += $([System.Char]34)select partition %_PARTITION_NUMBER_%$([System.Char]34)`n"
  "  `${Apply GPT Attributes to Recovery Partition Here-String Precursor} += $([System.Char]34)`n$([System.Char]34)`n"
  "  `${Apply GPT Attributes to Recovery Partition Here-String Precursor} += $([System.Char]34)gpt attributes=0x8000000000000001$([System.Char]34)`n"
  "`n"
  "  `${Apply GPT Attributes to Recovery Partition Here-String} = `${Apply GPT Attributes to Recovery Partition Here-String Precursor} $([System.Char]96)`n"
  "    -replace $([System.Char]39)%_DISK_NUMBER_%$([System.Char]39),`${OS Disk CIM Instance}.Number $([System.Char]96)`n"
  "    -replace $([System.Char]39)%_PARTITION_NUMBER_%$([System.Char]39),`${Recovery Partition OS Disk CIM Instance}.PartitionNumber`n"
  "  `$ContentPath = $([System.Char]34)X:\Scriptoids\ApplyGptAttributesToRecoveryPartition.txt$([System.Char]34)`n"
  "  Set-Content -Path `$ContentPath -Value (`${Apply GPT Attributes to Recovery Partition Here-String})`n"
  "  `$ArgumentList = @(`n"
  "    $([System.Char]39)/s$([System.Char]39)`n"
  "    `$ContentPath`n"
  "  )`n"
  "  Start-Process diskpart.exe -ArgumentList `$ArgumentList -NoNewWindow`n"
  "`n"
  "  Write-Host -Object $([System.Char]34)Sleeping for 3 seconds...$([System.Char]34)`n"
  "  Start-Sleep 3`n"
  "`n"
  "  #     $([System.Char]34)echo CREATE PARTITION PRIMARY$([System.Char]34)`n"
  "  #     $([System.Char]34)&echo FORMAT QUICK FS=NTFS LABEL=`$([System.Char]34)Recovery`$([System.Char]34)$([System.Char]34)`n"
  "  #     $([System.Char]34)&echo SET ID=`$([System.Char]34)DE94BBA4-06D1-4D40-A16A-BFD50179D6AC`$([System.Char]34)$([System.Char]34)`n"
  "  #     $([System.Char]34)&echo GPT ATTRIBUTES=0x8000000000000001$([System.Char]34)`n"
  "  #region |  |`n"
  "  `${non-USB disks} = (Get-Disk).Where({`$_.BusType -match $([System.Char]39)NVMe|SATA$([System.Char]39)}) | Sort-Object -Property $([System.Char]39)Size$([System.Char]39)`n"
  "  if ( # If there are 2 or more SATA/NVMe disks, then the largest disk is the Hyper-V Host drive |`n"
  "    `$null -ne (`${non-USB disks}).Count`n"
  "  ) {`n"
  "    `${HvH Disk} = `${non-USB disks}[-1]`n"
  "  }`n"
  "  #endregion`n"
  "}`n"
  "`t`t"

  #endregion


  #endregion
  #########################################-BOUNDARY-#########################################
  { # Create with ConvertTo-HereStringPrecursor |
    & {
      $PSModuleInfo = Import-Module 'Storage' -PassThru -Force
      ${OS Disk CIM Instance} = Import-CliXml -Path "X:\Scriptoids\OS Disk CIM Instance.clixml"
      ${Recovery Partition OS Disk CIM Instance} = Import-CliXml -Path "X:\Scriptoids\Recovery Partition OS Disk CIM Instance.clixml"
      ${Recovery Volume OS Disk CIM Instance} = Import-CliXml -Path "X:\Scriptoids\Recovery Volume OS Disk CIM Instance.clixml"


      ${Apply GPT Attributes to Recovery Partition Here-String Precursor} = "select disk %_DISK_NUMBER_%"
      ${Apply GPT Attributes to Recovery Partition Here-String Precursor} += "`n"
      ${Apply GPT Attributes to Recovery Partition Here-String Precursor} += "select partition %_PARTITION_NUMBER_%"
      ${Apply GPT Attributes to Recovery Partition Here-String Precursor} += "`n"
      ${Apply GPT Attributes to Recovery Partition Here-String Precursor} += "gpt attributes=0x8000000000000001"

      ${Apply GPT Attributes to Recovery Partition Here-String} = ${Apply GPT Attributes to Recovery Partition Here-String Precursor} `
        -replace '%_DISK_NUMBER_%',${OS Disk CIM Instance}.Number `
        -replace '%_PARTITION_NUMBER_%',${Recovery Partition OS Disk CIM Instance}.PartitionNumber
      $ContentPath = "X:\Scriptoids\ApplyGptAttributesToRecoveryPartition.txt"
      Set-Content -Path $ContentPath -Value (${Apply GPT Attributes to Recovery Partition Here-String})
      $ArgumentList = @(
        '/s'
        $ContentPath
      )
      Start-Process diskpart.exe -ArgumentList $ArgumentList -NoNewWindow

      Write-Host -Object "Sleeping for 3 seconds..."
      Start-Sleep 3

      #     "echo CREATE PARTITION PRIMARY"
      #     "&echo FORMAT QUICK FS=NTFS LABEL=$([System.Char]34)Recovery$([System.Char]34)"
      #     "&echo SET ID=$([System.Char]34)DE94BBA4-06D1-4D40-A16A-BFD50179D6AC$([System.Char]34)"
      #     "&echo GPT ATTRIBUTES=0x8000000000000001"
      #region |  |
      ${non-USB disks} = (Get-Disk).Where({$_.BusType -match 'NVMe|SATA'}) | Sort-Object -Property 'Size'
      if ( # If there are 2 or more SATA/NVMe disks, then the largest disk is the Hyper-V Host drive |
        $null -ne (${non-USB disks}).Count
      ) {
        ${HvH Disk} = ${non-USB disks}[-1]
      }
      #endregion
    }
  } | Out-Null
  #########################################-BOUNDARY-#########################################
) -join ''

${03-OsDiskPart2 Command Here-String} = ${03-OsDiskPart2 Command Here-String Precursor}
${03-OsDiskPart2 Command} = [ScriptBlock]::Create(${03-OsDiskPart2 Command Here-String})
${03-OsDiskPart2 Script Path} = "${WinPE Image Creation Parent Folder}\03-OsDiskPart2.ps1"
Set-Content -Path ${03-OsDiskPart2 Script Path} -Value (${03-OsDiskPart2 Command Here-String})
#endregion

#region | Write "${env:.CommonItems}\WinPE\05-DismLoad-ApplyImage.ps1" to the file system of the technician PC |
${05-DismLoad-ApplyImage Command Here-String Precursor} = $(
  #region | OS Disk | Hyper-V Disk |

  
  #region |  |
  "`n"
  "    & {`n"
  "      `$PSModuleInfo = Import-Module $([System.Char]39)Storage$([System.Char]39) -PassThru -Force`n"
  "      #region | Precursor Variable Series I |`n"
  "      `${Pattern UniqueId Raw} = $([System.Char]39)^(?<Unique_ID>[^:]+)(?<Discarded>\:.*)?`$$([System.Char]39)`n"
  "`n"
  "      # Yes, we need these underscores left of $([System.Char]39)FriendlyName$([System.Char]39), $([System.Char]39)SerialNumber$([System.Char]39), and $([System.Char]39)UniqueId Raw$([System.Char]39) in the variable name`n"
  "      `${OSDeploy_FriendlyName} = (Import-CliXml -Path $([System.Char]39)X:\Scriptoids\OSDeploy FriendlyName.clixml$([System.Char]39)) -replace $([System.Char]34)$([System.Char]39)$([System.Char]34),$([System.Char]34)$([System.Char]34)`n"
  "      `${OSDeploy_SerialNumber} = (Import-CliXml -Path $([System.Char]39)X:\Scriptoids\OSDeploy SerialNumber.clixml$([System.Char]39)) -replace $([System.Char]34)$([System.Char]39)$([System.Char]34),$([System.Char]34)$([System.Char]34)`n"
  "      `${OSDeploy_UniqueId Raw} = (Import-CliXml -Path $([System.Char]39)X:\Scriptoids\OSDeploy UniqueId Raw.clixml$([System.Char]39)) -replace $([System.Char]34)$([System.Char]39)$([System.Char]34),$([System.Char]34)$([System.Char]34)`n"
  "      `${OSDeploy_UniqueId Raw} -match `${Pattern UniqueId Raw} | Out-Null`n"
  "      `${OSDeploy_UniqueId} = `$Matches[$([System.Char]39)Unique_ID$([System.Char]39)]`n"
  "`n"
  "      `$OSDeployDisk = Get-Disk | Where-Object -FilterScript {`n"
  "        `$_.FriendlyName -eq    `${OSDeploy_FriendlyName}                                             -and $([System.Char]96)`n"
  "        `$_.UniqueId     -match [System.Text.RegularExpressions.Regex]::Escape(`${OSDeploy_UniqueId}) -and $([System.Char]96)`n"
  "        `$_.SerialNumber -eq    `${OSDeploy_SerialNumber}`n"
  "      }`n"
  "`n"
  "      if (`$null -ne `$OSDeployDisk) {`n"
  "        `${Volume DriveLetters Precursor} = Get-Partition -DiskNumber `$OSDeployDisk.Number | Get-Volume | Select-Object -ExpandProperty $([System.Char]39)DriveLetter$([System.Char]39)`n"
  "        foreach (`${Volume DriveLetter Precursor} in `${Volume DriveLetters Precursor}) {`n"
  "          `${Volume DriveLetter} = [System.String]`${Volume DriveLetter Precursor} + $([System.Char]39):$([System.Char]39)`n"
  "          `$IsWindowsOS = Test-Path -Path $([System.Char]34)`${Volume DriveLetter}\setup.exe$([System.Char]34)`n"
  "          if (`$IsWindowsOS) {`n"
  "            `$OSDeploy = `${Volume DriveLetter}`n"
  "          }`n"
  "        }`n"
  "      }`n"
  "`n"
  "      `${usb0_FriendlyName} = (Import-CliXml -Path $([System.Char]39)X:\Scriptoids\usb0 FriendlyName.clixml$([System.Char]39)) -replace $([System.Char]34)$([System.Char]39)$([System.Char]34),$([System.Char]34)$([System.Char]34)`n"
  "      `${usb0_SerialNumber} = (Import-CliXml -Path $([System.Char]39)X:\Scriptoids\usb0 SerialNumber.clixml$([System.Char]39)) -replace $([System.Char]34)$([System.Char]39)$([System.Char]34),$([System.Char]34)$([System.Char]34)`n"
  "      `${usb0_UniqueId Raw} = (Import-CliXml -Path $([System.Char]39)X:\Scriptoids\usb0 UniqueId Raw.clixml$([System.Char]39)) -replace $([System.Char]34)$([System.Char]39)$([System.Char]34),$([System.Char]34)$([System.Char]34)`n"
  "      `${usb0_UniqueId Raw} -match `${Pattern UniqueId Raw} | Out-Null`n"
  "      `${usb0_UniqueId} = `$Matches[$([System.Char]39)Unique_ID$([System.Char]39)]`n"
  "`n"
  "      `${usb1_FriendlyName} = (Import-CliXml -Path $([System.Char]39)X:\Scriptoids\usb1 FriendlyName.clixml$([System.Char]39)) -replace $([System.Char]34)$([System.Char]39)$([System.Char]34),$([System.Char]34)$([System.Char]34)`n"
  "      `${usb1_SerialNumber} = (Import-CliXml -Path $([System.Char]39)X:\Scriptoids\usb1 SerialNumber.clixml$([System.Char]39)) -replace $([System.Char]34)$([System.Char]39)$([System.Char]34),$([System.Char]34)$([System.Char]34)`n"
  "      `${usb1_UniqueId Raw} = (Import-CliXml -Path $([System.Char]39)X:\Scriptoids\usb1 UniqueId Raw.clixml$([System.Char]39)) -replace $([System.Char]34)$([System.Char]39)$([System.Char]34),$([System.Char]34)$([System.Char]34)`n"
  "      `${usb1_UniqueId Raw} -match `${Pattern UniqueId Raw} | Out-Null`n"
  "      `${usb1_UniqueId} = `$Matches[$([System.Char]39)Unique_ID$([System.Char]39)]`n"
  "      #endregion`n"
  "`n"
  "      `${OS Disk CIM Instance} = Import-CliXml -Path $([System.Char]34)X:\Scriptoids\OS Disk CIM Instance.clixml$([System.Char]34)`n"
  "      `${Recovery Partition OS Disk CIM Instance} = Import-CliXml -Path $([System.Char]34)X:\Scriptoids\Recovery Partition OS Disk CIM Instance.clixml$([System.Char]34)`n"
  "      `${Recovery Volume OS Disk CIM Instance} = Import-CliXml -Path $([System.Char]34)X:\Scriptoids\Recovery Volume OS Disk CIM Instance.clixml$([System.Char]34)`n"
  "`n"
  "      #region | Activate New Version of DISM |`n"
  "      . $([System.Char]39)X:\DISM\WimMountAdkSetupAmd64.exe$([System.Char]39) /Install /q`n"
  "      #endregion`n"
  "      #region | Apply Image |`n"
  "      `${OS Volume OS Partition OS Disk CIM Instance} = Import-CliXml -Path $([System.Char]34)X:\Scriptoids\OS Volume OS Partition OS Disk CIM Instance.clixml$([System.Char]34)`n"
  "      `${LocalOS Volume Letter} = [System.String]`${OS Volume OS Partition OS Disk CIM Instance}.DriveLetter + $([System.Char]39):$([System.Char]39)`n"
  "      `n"
  "      . $([System.Char]39)X:\DISM\dism.exe$([System.Char]39) /Apply-Image /ImageFile:$([System.Char]34)`$OSDeploy\sources\install.wim$([System.Char]34) /Index:2 /ApplyDir:`${LocalOS Volume Letter} /CheckIntegrity /Verify`n"
  "      #endregion`n"
  "    }`n"
  "`t`t"
  #endregion

  #endregion
  #########################################-BOUNDARY-#########################################
  { # Create with ConvertTo-HereStringPrecursor |
    & {
      $PSModuleInfo = Import-Module 'Storage' -PassThru -Force
      #region | Precursor Variable Series I |
      ${Pattern UniqueId Raw} = '^(?<Unique_ID>[^:]+)(?<Discarded>\:.*)?$'

      # Yes, we need these underscores left of 'FriendlyName', 'SerialNumber', and 'UniqueId Raw' in the variable name
      ${OSDeploy_FriendlyName} = (Import-CliXml -Path 'X:\Scriptoids\OSDeploy FriendlyName.clixml') -replace "'",""
      ${OSDeploy_SerialNumber} = (Import-CliXml -Path 'X:\Scriptoids\OSDeploy SerialNumber.clixml') -replace "'",""
      ${OSDeploy_UniqueId Raw} = (Import-CliXml -Path 'X:\Scriptoids\OSDeploy UniqueId Raw.clixml') -replace "'",""
      ${OSDeploy_UniqueId Raw} -match ${Pattern UniqueId Raw} | Out-Null
      ${OSDeploy_UniqueId} = $Matches['Unique_ID']

      $OSDeployDisk = Get-Disk | Where-Object -FilterScript {
        $_.FriendlyName -eq    ${OSDeploy_FriendlyName}                                             -and `
        $_.UniqueId     -match [System.Text.RegularExpressions.Regex]::Escape(${OSDeploy_UniqueId}) -and `
        $_.SerialNumber -eq    ${OSDeploy_SerialNumber}
      }

      if ($null -ne $OSDeployDisk) {
        ${Volume DriveLetters Precursor} = Get-Partition -DiskNumber $OSDeployDisk.Number | Get-Volume | Select-Object -ExpandProperty 'DriveLetter'
        foreach (${Volume DriveLetter Precursor} in ${Volume DriveLetters Precursor}) {
          ${Volume DriveLetter} = [System.String]${Volume DriveLetter Precursor} + ':'
          $IsWindowsOS = Test-Path -Path "${Volume DriveLetter}\setup.exe"
          if ($IsWindowsOS) {
            $OSDeploy = ${Volume DriveLetter}
          }
        }
      }

      ${usb0_FriendlyName} = (Import-CliXml -Path 'X:\Scriptoids\usb0 FriendlyName.clixml') -replace "'",""
      ${usb0_SerialNumber} = (Import-CliXml -Path 'X:\Scriptoids\usb0 SerialNumber.clixml') -replace "'",""
      ${usb0_UniqueId Raw} = (Import-CliXml -Path 'X:\Scriptoids\usb0 UniqueId Raw.clixml') -replace "'",""
      ${usb0_UniqueId Raw} -match ${Pattern UniqueId Raw} | Out-Null
      ${usb0_UniqueId} = $Matches['Unique_ID']

      ${usb1_FriendlyName} = (Import-CliXml -Path 'X:\Scriptoids\usb1 FriendlyName.clixml') -replace "'",""
      ${usb1_SerialNumber} = (Import-CliXml -Path 'X:\Scriptoids\usb1 SerialNumber.clixml') -replace "'",""
      ${usb1_UniqueId Raw} = (Import-CliXml -Path 'X:\Scriptoids\usb1 UniqueId Raw.clixml') -replace "'",""
      ${usb1_UniqueId Raw} -match ${Pattern UniqueId Raw} | Out-Null
      ${usb1_UniqueId} = $Matches['Unique_ID']
      #endregion

      ${OS Disk CIM Instance} = Import-CliXml -Path "X:\Scriptoids\OS Disk CIM Instance.clixml"
      ${Recovery Partition OS Disk CIM Instance} = Import-CliXml -Path "X:\Scriptoids\Recovery Partition OS Disk CIM Instance.clixml"
      ${Recovery Volume OS Disk CIM Instance} = Import-CliXml -Path "X:\Scriptoids\Recovery Volume OS Disk CIM Instance.clixml"

      #region | Activate New Version of DISM |
      . 'X:\DISM\WimMountAdkSetupAmd64.exe' /Install /q
      #endregion
      #region | Apply Image |
      ${OS Volume OS Partition OS Disk CIM Instance} = Import-CliXml -Path "X:\Scriptoids\OS Volume OS Partition OS Disk CIM Instance.clixml"
      ${LocalOS Volume Letter} = [System.String]${OS Volume OS Partition OS Disk CIM Instance}.DriveLetter + ':'
      
      . 'X:\DISM\dism.exe' /Apply-Image /ImageFile:"$OSDeploy\sources\install.wim" /Index:2 /ApplyDir:${LocalOS Volume Letter} /CheckIntegrity /Verify
      #endregion
    }
  } | Out-Null
  #########################################-BOUNDARY-#########################################
) -join ''

${05-DismLoad-ApplyImage Command Here-String} = ${05-DismLoad-ApplyImage Command Here-String Precursor}
${05-DismLoad-ApplyImage Command} = [ScriptBlock]::Create(${05-DismLoad-ApplyImage Command Here-String})
${05-DismLoad-ApplyImage Script Path} = "${WinPE Image Creation Parent Folder}\05-DismLoad-ApplyImage.ps1"
Set-Content -Path ${05-DismLoad-ApplyImage Script Path} -Value (${05-DismLoad-ApplyImage Command Here-String})
#endregion

#region | Write "${env:.CommonItems}\WinPE\Bootable USB with PowerShell-enabled WinPE Script.ps1" to the file system of the technician PC |
${Bootable USB with PowerShell-enabled WinPE Command Here-String Precursor} = $(
  #region | requires params and strict mode |
  "#Requires -Version 5.1`n"
  "#Requires -PSEdition Desktop`n"
  "#Requires -RunAsAdministrator`n"
  "Set-StrictMode -Version $([System.Char]39)Latest$([System.Char]39)`n"
  "`n"
  "`n"
  "`n"
  #endregion
  #region | New Precursor Volume for eventual WinPE | Custom WinPE image written to USB Flash Drive |


  #region |  |

  "`n"
  "#region | Script-wide Variables |`n"
  "`${WinPE Workspace Folder Name}      = $([System.Char]39)%_WinPE Workspace Folder Name_%$([System.Char]39)`n"
  "`${explorer.exe Owner}               = $([System.Char]39)%_explorer_owner_%$([System.Char]39)`n"
  "`${WinPE Image Creation Parent Path} = $([System.Char]39)%_WinPE Image Creation Parent Path_%$([System.Char]39)`n"
  "`$FolderFQN                          = $([System.Char]39)%_FolderFQN_%$([System.Char]39)`n"
  "`${.CommonItems}                     = $([System.Char]39)%_.CommonItems_%$([System.Char]39)`n"
  "`n"
  "Set-ExecutionPolicy -ExecutionPolicy $([System.Char]39)RemoteSigned$([System.Char]39) -Scope $([System.Char]39)Process$([System.Char]39) -Force`n"
  ". $([System.Char]34)`${.CommonItems}\..\`$FolderFQN\output\`$FolderFQN\usb1\`$FolderFQN\Base\5.1\Computer Info Lite.ps1$([System.Char]34)`n"
  ". $([System.Char]34)`${.CommonItems}\..\`$FolderFQN\output\`$FolderFQN\usb1\`$FolderFQN\Base\5.1\Location - Culture - Geography.ps1$([System.Char]34)`n"
  "`${Cultures Defined} = Import-CliXml -Path $([System.Char]34)`${.CommonItems}\Cultures Defined.clixml$([System.Char]34)`n"
  "`${Cultures Excluded} = `${Cultures Defined}.Where({`$_ -ne `${UserLocale}})`n"
  "#endregion`n"
  "& {`n"
  "  #region | New Precursor Volume for eventual WinPE |`n"
  "  `${Uncleared OSDeploy Disk CIM Instance} = Get-Disk | Where-Object -FilterScript {`n"
  "    `$_.FriendlyName -eq $([System.Char]34)${OSDeploy FriendlyName}$([System.Char]34) -and $([System.Char]96)`n"
  "    `$_.SerialNumber -eq $([System.Char]34)${OSDeploy SerialNumber}$([System.Char]34) -and $([System.Char]96)`n"
  "    `$_.UniqueId     -eq $([System.Char]34)${OSDeploy UniqueId Raw}$([System.Char]34)`n"
  "  }`n"
  "`n"
  "  `${OSDeploy Disk CIM Instance} = `${Uncleared OSDeploy Disk CIM Instance} | Clear-Disk -RemoveData -RemoveOEM -Confirm:`$false -Verbose:`$true -PassThru`n"
  "`n"
  "  `${OSDeploy Disk CIM Instance} | Set-Disk -PartitionStyle $([System.Char]39)MBR$([System.Char]39) -Verbose:`$true`n"
  "  `${WinPE Partition Size} = 1400MB`n"
  "  `${MBR Partition 1 on OSDeploy Disk CIM Instance} = `${OSDeploy Disk CIM Instance} | New-Partition -Size (`${WinPE Partition Size}) -AssignDriveLetter -MbrType $([System.Char]39)FAT32$([System.Char]39) -Verbose:`$true`n"
  "`n"
  "  # The volume on the WinPE partition must be FAT32-formatted: `n"
  "  `$NewFileSystemLabel = $([System.Char]39)PRE_WINPE$([System.Char]39)`n"
  "  `${WinPE Volume on MBR Partition 1 on OSDeploy Disk CIM Instance} = Format-Volume -FileSystem $([System.Char]39)FAT32$([System.Char]39) -DriveLetter `${MBR Partition 1 on OSDeploy Disk CIM Instance}.DriveLetter -NewFileSystemLabel `$NewFileSystemLabel -Verbose:`$true`n"
  "  `${WinPE Volume Drive Letter} = [System.String]`${WinPE Volume on MBR Partition 1 on OSDeploy Disk CIM Instance}.DriveLetter + $([System.Char]39):$([System.Char]39)`n"
  "  <# NOTE! |`n"
  "    # The indented code directly below does not resolve any volume letters because at this point $([System.Char]39)PRE_WINPE$([System.Char]39) is a partition, and not a volume: `n"
  "      `${WinPE Volume} = Get-Volume -FriendlyName `$NewFileSystemLabel -Verbose:`$true; `n"
  "      `${WinPE Bootable USB Volume Letter} = `${WinPE Volume on MBR Partition 1 on OSDeploy Disk CIM Instance}.DriveLetter + $([System.Char]39):$([System.Char]39)`n"
  "  #>`n"
  "  #endregion`n"
  "  #region | New volume for eventual Server25 |`n"
  "  # The remaining space can be NTFS. It will hold an extracted iso with setup.exe at the root. `n"
  "  `${MBR Partition 2 on OSDeploy Disk CIM Instance} = `${OSDeploy Disk CIM Instance} | New-Partition -UseMaximumSize -AssignDriveLetter -MbrType $([System.Char]39)IFS$([System.Char]39) -Verbose:`$true`n"
  "  `$NewFileSystemLabel = $([System.Char]39)Server25$([System.Char]39)`n"
  "  `${Server25 Volume on MBR Partition 2 on OSDeploy Disk CIM Instance} = Format-Volume -FileSystem $([System.Char]39)NTFS$([System.Char]39) -DriveLetter `${MBR Partition 2 on OSDeploy Disk CIM Instance}.DriveLetter -NewFileSystemLabel `$NewFileSystemLabel -Verbose:`$true`n"
  "  `${OSDeploy Volume Drive Letter} = [System.String]`${Server25 Volume on MBR Partition 2 on OSDeploy Disk CIM Instance}.DriveLetter + $([System.Char]39):$([System.Char]39)`n"
  "  #endregion`n"
  "  #region | Unmodified WinPE |`n"
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
  "  `${WinPE Default boot.wim Extracted Folder Path} = $([System.Char]34)`${WinPE Image Creation Path}\.Default boot.wim File Extracted$([System.Char]34)`n"
  "`n"
  "  <# Do what copype.cmd does, but with PowerShell |`n"
  "    `$KitsRoot      = $([System.Char]34)C:\Program Files (x86)\Windows Kits\10$([System.Char]34)`n"
  "    `$TEMPL         = $([System.Char]39)media$([System.Char]39)`n"
  "    `$BOOTBINS      = $([System.Char]39)bootbins$([System.Char]39)`n"
  "    `$WINPE_ARCH    = `$env:PROCESSOR_ARCHITECTURE`n"
  "    `$WinPERoot     = $([System.Char]34)`$KitsRoot\Assessment and Deployment Kit\Windows Preinstallation Environment$([System.Char]34)`n"
  "    `$SOURCE        = $([System.Char]34)`$WinPERoot\`$WINPE_ARCH$([System.Char]34)`n"
  "    `$DandIRoot     = $([System.Char]34)`$KitsRoot\Assessment and Deployment Kit\Deployment Tools$([System.Char]34)`n"
  "    `$OSCDImgRoot   = $([System.Char]34)`$DandIRoot\`$WINPE_ARCH\Oscdimg$([System.Char]34)`n"
  "    `$FWFILESROOT   = Resolve-Path -Path $([System.Char]34)`$OSCDImgRoot\..\..\`$WINPE_ARCH\Oscdimg$([System.Char]34) | Select-Object -ExpandProperty $([System.Char]39)Path$([System.Char]39)`n"
  "    `$DEST          = `${WinPE Default boot.wim Extracted Folder Path}`n"
  "    `$WIMSOURCEPATH = $([System.Char]34)`$SOURCE\en-us\winpe.wim$([System.Char]34)`n"
  "    `$DISMRoot      = $([System.Char]34)`$DandIRoot\`$WINPE_ARCH\DISM$([System.Char]34)`n"
  "`n"
  "    `$path = $([System.Char]34)`$DEST\`$TEMPL$([System.Char]34); `$folder = try {Get-Item -Path `$path -ErrorAction $([System.Char]39)Stop$([System.Char]39)} catch {New-Item -Path `$path -ItemType $([System.Char]39)Directory$([System.Char]39) -Force}`n"
  "    `$path = $([System.Char]34)`$DEST\mount$([System.Char]34); `$folder = try {Get-Item -Path `$path -ErrorAction $([System.Char]39)Stop$([System.Char]39)} catch {New-Item -Path `$path -ItemType $([System.Char]39)Directory$([System.Char]39) -Force}`n"
  "    `$path = $([System.Char]34)`$DEST\`$BOOTBINS$([System.Char]34); `$folder = try {Get-Item -Path `$path -ErrorAction $([System.Char]39)Stop$([System.Char]39)} catch {New-Item -Path `$path -ItemType $([System.Char]39)Directory$([System.Char]39) -Force}`n"
  "    echo $([System.Char]39)Staging media files...$([System.Char]39)`n"
  "    # Copy the boot files and WinPE WIM to the destination location.`n"
  "    # /h Hidden and system files.`n"
  "    # /e Copy dirs and subdirs, including empty ones.`n"
  "    # /r Overwrite read-only files.`n"
  "    # /k Copies attributes. xcopy.exe without /k will reset read-only attributes.`n"
  "    # /y Suppresses prompt for confirmation to overwrite an existing destination file.`n"
  "    xcopy.exe /herky $([System.Char]34)`$SOURCE\Media$([System.Char]34) $([System.Char]34)`$DEST\`$TEMPL\$([System.Char]34)`n"
  "    `$path = $([System.Char]34)`$DEST\`$TEMPL\sources$([System.Char]34); `$folder = try {Get-Item -Path `$path -ErrorAction $([System.Char]39)Stop$([System.Char]39)} catch {New-Item -Path `$path -ItemType $([System.Char]39)Directory$([System.Char]39) -Force}`n"
  "    copy `$WIMSOURCEPATH $([System.Char]34)`$folder\boot.wim$([System.Char]34) `n"
  "`n"
  "    echo $([System.Char]34)Mount the WinPE WIM file:$([System.Char]34)`n"
  "    .\amd64\DISM\dism.exe /Mount-Image /ImageFile:$([System.Char]34)`$folder\boot.wim$([System.Char]34) /Index:1 /MountDir:$([System.Char]34)`$DEST\mount$([System.Char]34) /ReadOnly`n"
  "`n"
  "    #echo $([System.Char]34)Copy 2011 signed boot manager for later use$([System.Char]34)`n"
  "    #copy $([System.Char]34)`$DEST\mount\Windows\Boot\EFI\bootmgfw.efi$([System.Char]34) $([System.Char]34)`$DEST\`$BOOTBINS$([System.Char]34)`n"
  "`n"
  "    echo $([System.Char]34)Copy 2023 signed BOOT MANAGER for later use$([System.Char]34)`n"
  "    copy $([System.Char]34)`$DEST\mount\Windows\Boot\EFI\bootmgfw_EX.efi$([System.Char]34) $([System.Char]34)`$DEST\`$BOOTBINS$([System.Char]34)`n"
  "`n"
  "    echo $([System.Char]39)Copy the BOOT SECTOR files from mounted .wim to enable booting & ISO creation:$([System.Char]39)`n"
  "    # UEFI boot uses efisys.bin and efisys_EX.bin`n"
  "    copy $([System.Char]34)`$FWFILESROOT\efisys.bin$([System.Char]34) $([System.Char]34)`$DEST\`$BOOTBINS$([System.Char]34)`n"
  "    copy $([System.Char]34)`$FWFILESROOT\efisys_noprompt.bin$([System.Char]34) $([System.Char]34)`$DEST\`$BOOTBINS$([System.Char]34)`n"
  "    copy $([System.Char]34)`$FWFILESROOT\efisys_EX.bin$([System.Char]34) $([System.Char]34)`$DEST\`$BOOTBINS$([System.Char]34)`n"
  "    copy $([System.Char]34)`$FWFILESROOT\efisys_noprompt_EX.bin$([System.Char]34) $([System.Char]34)`$DEST\`$BOOTBINS$([System.Char]34)`n"
  "`n"
  "    # BIOS boot uses etfsboot.com`n"
  "    #copy $([System.Char]34)`$FWFILESROOT\etfsboot.com$([System.Char]34) $([System.Char]34)`$DEST\`$BOOTBINS$([System.Char]34)`n"
  "    echo $([System.Char]34)Unmounting $([System.Char]39)`$DEST\`$TEMPL\sources\boot.wim$([System.Char]39)$([System.Char]34)`n"
  "    .\amd64\DISM\dism.exe /Unmount-Image /MountDir:$([System.Char]34)`$DEST\mount$([System.Char]34) /Discard`n"
  "  #>`n"
  "`n"
  "  <# No need to create this folder of the extracted WinPE.wim file |`n"
  "    # Extracts boot.wim (the WinPE image file) and copies into $([System.Char]39).\.Default boot.wim File Extracted\$([System.Char]39). `n"
  "    copype.cmd .\amd64\ `${WinPE Default boot.wim Extracted Folder Path}`n"
  "  #>`n"
  "  `n"
  "  #region | Deprecated |`n"
  "  <#`n"
  "    `${CopyPE Amd64 Folder Path} = Join-Path -Path (Split-Path -Path `${WinPE Default boot.wim Extracted Folder Path} -Parent) -ChildPath $([System.Char]39)amd64$([System.Char]39)`n"
  "    copype.cmd .\amd64\ `${CopyPE Amd64 Folder Path}`n"
  "    `${CopyPE arm64 Folder Path} = Join-Path -Path (Split-Path -Path `${WinPE Default boot.wim Extracted Folder Path} -Parent) -ChildPath $([System.Char]39)arm64$([System.Char]39)`n"
  "    copype.cmd .\arm64\ `${CopyPE arm64 Folder Path}`n"
  "  #>`n"
  "`n"
  "  <#`n"
  "    `${CopyPE x86 Folder Path} = Join-Path -Path (Split-Path -Path `${WinPE Default boot.wim Extracted Folder Path} -Parent) -ChildPath $([System.Char]39)x86$([System.Char]39)`n"
  "    copype.cmd .\x86\ `${CopyPE x86 Folder Path}`n"
  "    `${CopyPE arm Folder Path} = Join-Path -Path (Split-Path -Path `${WinPE Default boot.wim Extracted Folder Path} -Parent) -ChildPath $([System.Char]39)arm$([System.Char]39)`n"
  "    copype.cmd .\arm\ `${CopyPE arm Folder Path}`n"
  "  #>`n"
  "  #endregion`n"
  "`n"
  "  <# No need to create this .iso file of WinPE |`n"
  "    # Write to disk an .iso file of an original, unmodified instance of WinPE`n"
  "    `$path = $([System.Char]34)`${WinPE Image Creation Path}\Default$([System.Char]34); `$folder = try {Get-Item -Path `$path -ErrorAction $([System.Char]39)Stop$([System.Char]39)} catch {New-Item -Path `$path -ItemType $([System.Char]39)Directory$([System.Char]39) -Force}`n"
  "    MakeWinPeMedia.cmd /ISO `${WinPE Default boot.wim Extracted Folder Path} $([System.Char]34)`$folder\WinPE.iso$([System.Char]34) /bootex`n"
  "  #>`n"
  "  #endregion`n"
  "  #region | Custom WinPE |`n"
  "  `${WinPE Updated boot.wim Extracted Folder Path} = $([System.Char]34)`${WinPE Image Creation Parent Folder}\`${WinPE Workspace Folder Name}\.Updated boot.wim File Extracted$([System.Char]34)`n"
  "  `$IsPresent = Test-Path -Path `${WinPE Updated boot.wim Extracted Folder Path}`n"
  "  if (-not `$IsPresent) {`n"
  "    copype.cmd .\amd64\ `${WinPE Updated boot.wim Extracted Folder Path}`n"
  "    <#`n"
  "      foreach (`${Culture Excluded} in `${Cultures Excluded}) {`n"
  "        Get-ChildItem -Depth 0 -Path `${WinPE Updated boot.wim Extracted Folder Path} -Directory $([System.Char]96)`n"
  "        | Where-Object -FilterScript {`$_.BaseName -eq `${Culture Excluded}} $([System.Char]96)`n"
  "        | Remove-Item -Recurse -Force`n"
  "`n"
  "        Get-ChildItem -Depth 1 -Path `${WinPE Updated boot.wim Extracted Folder Path} -Directory $([System.Char]96)`n"
  "        | Where-Object -FilterScript {`$_.BaseName -eq `${Culture Excluded}} $([System.Char]96)`n"
  "        | Remove-Item -Recurse -Force`n"
  "`n"
  "        Get-ChildItem -Depth 2 -Path `${WinPE Updated boot.wim Extracted Folder Path} -Directory $([System.Char]96)`n"
  "        | Where-Object -FilterScript {`$_.BaseName -eq `${Culture Excluded}} $([System.Char]96)`n"
  "        | Remove-Item -Recurse -Force`n"
  "      }`n"
  "    #>`n"
  "    `${Mount Directory Path} = $([System.Char]34)`${WinPE Image Creation Parent Folder}\`${WinPE Workspace Folder Name}\Outside Mount$([System.Char]34)`n"
  "    `$path = `${Mount Directory Path}; `$folder = try {Get-Item -Path `$path -ErrorAction $([System.Char]39)Stop$([System.Char]39)} catch {New-Item -Path `$path -ItemType $([System.Char]39)Directory$([System.Char]39) -Force}`n"
  "    `$lang = $([System.Char]34)`${UserLocale}$([System.Char]34)`n"
  "    .\amd64\DISM\dism.exe /Mount-Image /ImageFile:$([System.Char]34)`${WinPE Updated boot.wim Extracted Folder Path}\media\sources\boot.wim$([System.Char]34) /Index:1 /MountDir:$([System.Char]34)`${Mount Directory Path}$([System.Char]34)`n"
  "`n"
  "    #region | Enable Windows PowerShell support in the WinPE operating system |`n"
  "    `$path = $([System.Char]34)`${Mount Directory Path}\Canary 00.txt$([System.Char]34); `$file = try {Get-Item -Path `$path -ErrorAction $([System.Char]39)Stop$([System.Char]39)} catch {New-Item -Path `$path -ItemType $([System.Char]39)File$([System.Char]39) -Force}`n"
  "    #region | WinPE Optional Components (OCs) |`n"
  "    # start msedge.exe $([System.Char]39)https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/winpe-add-packages--optional-components-reference?view=windows-11#winpe-optional-components$([System.Char]39)`n"
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
  "    `$path = $([System.Char]34)`${Mount Directory Path}\Canary 05.txt$([System.Char]34); `$file = try {Get-Item -Path `$path -ErrorAction $([System.Char]39)Stop$([System.Char]39)} catch {New-Item -Path `$path -ItemType $([System.Char]39)File$([System.Char]39) -Force}`n"
  "    #endregion`n"
  "`n"
  "    #region | Scriptoids |`n"
  "    `$path = $([System.Char]34)`${Mount Directory Path}\Scriptoids$([System.Char]34)`n"
  "    `$folder = try {Get-Item -Path `$path -ErrorAction $([System.Char]39)Stop$([System.Char]39)} catch {New-Item -Path `$path -ItemType $([System.Char]39)Directory$([System.Char]39) -Force}`n"
  "    Get-ChildItem -Path $([System.Char]34)`${WinPE Image Creation Parent Folder}\..\* FriendlyName.clixml$([System.Char]34) | ForEach-Object -Process {Copy-Item -Path `$_.FullName -Destination $([System.Char]34)`$folder$([System.Char]34)}`n"
  "    Get-ChildItem -Path $([System.Char]34)`${WinPE Image Creation Parent Folder}\..\* SerialNumber.clixml$([System.Char]34) | ForEach-Object -Process {Copy-Item -Path `$_.FullName -Destination $([System.Char]34)`$folder$([System.Char]34)}`n"
  "    Get-ChildItem -Path $([System.Char]34)`${WinPE Image Creation Parent Folder}\..\* UniqueId Raw.clixml$([System.Char]34) | ForEach-Object -Process {Copy-Item -Path `$_.FullName -Destination $([System.Char]34)`$folder$([System.Char]34)}`n"
  "    Move-Item -Path $([System.Char]34)`${WinPE Image Creation Parent Folder}\00-sample.ps1$([System.Char]34) -Destination $([System.Char]34)`$folder$([System.Char]34)`n"
  "    Move-Item -Path $([System.Char]34)`${WinPE Image Creation Parent Folder}\01-DiskPartClean.ps1$([System.Char]34) -Destination $([System.Char]34)`$folder$([System.Char]34)`n"
  "    Move-Item -Path $([System.Char]34)`${WinPE Image Creation Parent Folder}\03-OsDiskPart1.ps1$([System.Char]34) -Destination $([System.Char]34)`$folder$([System.Char]34)`n"
  "    Move-Item -Path $([System.Char]34)`${WinPE Image Creation Parent Folder}\03-OsDiskPart2.ps1$([System.Char]34) -Destination $([System.Char]34)`$folder$([System.Char]34)`n"
  "    Move-Item -Path $([System.Char]34)`${WinPE Image Creation Parent Folder}\05-DismLoad-ApplyImage.ps1$([System.Char]34) -Destination $([System.Char]34)`$folder$([System.Char]34)`n"
  "    #endregion`n"
  "`n"
  "    #region | Use newer version of DISM in WinPE | Update Startup script to load drivers for DISM |`n"
  "    #Copy-Item -Path $([System.Char]34)`${ADK x64 Tools Path}\DISM$([System.Char]34) -Destination $([System.Char]34)`${Mount Directory Path}$([System.Char]34) -Recurse`n"
  "    `$path = $([System.Char]34)`${Mount Directory Path}\DISM$([System.Char]34); `n"
  "    `$folder = try {Get-Item -Path `$path -ErrorAction $([System.Char]39)Stop$([System.Char]39)} catch {New-Item -Path `$path -ItemType $([System.Char]39)Directory$([System.Char]39) -Force}`n"
  "    robocopy $([System.Char]34)C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\DISM$([System.Char]34) $([System.Char]34)`$folder$([System.Char]34)`n"
  "    #endregion`n"
  "`n"
  "    `$path = $([System.Char]34)`${Mount Directory Path}\Canary 10.txt$([System.Char]34)`n"
  "    `$file = try {Get-Item -Path `$path -ErrorAction $([System.Char]39)Stop$([System.Char]39)} catch {New-Item -Path `$path -ItemType $([System.Char]39)File$([System.Char]39) -Force}`n"
  "`n"
  "    #region | startnet.cmd > Startup Script |`n"
  "    # Best performed separately. $([System.Char]34)`${Mount Directory Path}\Windows\System32\startnet.cmd$([System.Char]34) begins with a call to wpeinit`n"
  "    # Syntax for wpeinit is simple: `n"
  "    #     Wpeinit [-unattend:<path_to_answer_file>]`n"
  "    # Example of wpeinit in action: `n"
  "    #     Wpeinit -unattend:$([System.Char]34)C:\Unattend-PE.xml$([System.Char]34)`n"
  "    # So can Startnet.cmd launch a PowerShell script? `n"
  "    # I think it can. See the Unattend setting titled Microsoft-Windows-Setup/RunSynchronous.`n"
  "    # That$([System.Char]39)s probably how the PowerShell script is going to launch.`n"
  "    Get-Item -Path $([System.Char]34)`${Mount Directory Path}\Windows\System32\startnet.cmd$([System.Char]34) | Rename-Item -NewName $([System.Char]39)startnet.cmd.old$([System.Char]39)`n"
  "    `n"
  "    Move-Item -Path $([System.Char]34)`${WinPE Image Creation Parent Folder}\startnet.cmd$([System.Char]34) -Destination $([System.Char]34)`${Mount Directory Path}\Windows\System32$([System.Char]34)`n"
  "`n"
  "    #  `$content = Get-Content -Path $([System.Char]34)`$PSScriptRoot\startnet.cmd$([System.Char]34) -Raw`n"
  "    #  Get-Item -Path $([System.Char]34)`${Mount Directory Path}\Windows\System32\startnet.cmd$([System.Char]34) | Set-Content -Value `$content`n"
  "`n"
  "    #Get-Item -Path $([System.Char]34)`${Mount Directory Path}\Windows\System32\startnet.cmd$([System.Char]34) | Add-Content -Value $([System.Char]34)powercfg.exe /s 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c$([System.Char]34)`n"
  "    #Get-Item -Path $([System.Char]34)`${Mount Directory Path}\Windows\System32\startnet.cmd$([System.Char]34) | Add-Content -Value $([System.Char]34)powershell.exe$([System.Char]34)`n"
  "    #endregion`n"
  "`n"
  "    #region | Increase temporary storage on the RAMDisk (scratch space) |`n"
  "    # Probably not necessary`n"
  "    .\amd64\DISM\dism.exe /Set-ScratchSpace:512 /Image:$([System.Char]34)`${Mount Directory Path}$([System.Char]34)`n"
  "    #endregion`n"
  "`n"
  "    # Unmount the WinPE image and create media`n"
  "    .\amd64\DISM\dism.exe /Unmount-Image /MountDir:$([System.Char]34)`${Mount Directory Path}$([System.Char]34) /Commit`n"
  "`n"
  "    # `${Disk CIM Instance} = Get-Disk | Where-Object -FilterScript {`n"
  "    #   `$_.FriendlyName -eq $([System.Char]34)${OSDeploy FriendlyName}$([System.Char]34) -and $([System.Char]96)`n"
  "    #   `$_.SerialNumber -eq $([System.Char]34)${OSDeploy SerialNumber}$([System.Char]34) -and $([System.Char]96)`n"
  "    #   `$_.UniqueId     -eq $([System.Char]34)${OSDeploy UniqueId Raw}$([System.Char]34)`n"
  "    # }`n"
  "    #`${WinPE Partition Drive Letter Precursor} = `${Disk CIM Instance} | Get-Partition | Select-Object -ExpandProperty $([System.Char]39)DriveLetter$([System.Char]39)`n"
  "    #`${WinPE Volume Drive Letter} = [System.String]`${WinPE Partition Drive Letter Precursor} + $([System.Char]39):$([System.Char]39)`n"
  "`n"
  "    MakeWinPeMedia.cmd /UFD /f `${WinPE Updated boot.wim Extracted Folder Path} `${WinPE Volume Drive Letter} /bootex`n"
  "    <# No need to create this .iso file of WinPE either |`n"
  "      `$path = $([System.Char]34)`${WinPE Image Creation Path}\Updated$([System.Char]34); `$folder = try {Get-Item -Path `$path -ErrorAction $([System.Char]39)Stop$([System.Char]39)} catch {New-Item -Path `$path -ItemType $([System.Char]39)Directory$([System.Char]39) -Force}`n"
  "      MakeWinPeMedia.cmd /ISO `${WinPE Updated boot.wim Extracted Folder Path} $([System.Char]34)`$folder\WinPE.iso$([System.Char]34) /bootex`n"
  "    #>`n"
  "    `n"
  "    Remove-Item -Path $([System.Char]34)`${Mount Directory Path}$([System.Char]34)`n"
  "  }`n"
  "  #endregion`n"
  "}`n"
  "`t`t"


  #endregion



  #endregion
  #########################################-BOUNDARY-#########################################
  { # Create with ConvertTo-HereStringPrecursor |
    #region | Script-wide Variables |
    ${WinPE Workspace Folder Name}      = '%_WinPE Workspace Folder Name_%'
    ${explorer.exe Owner}               = '%_explorer_owner_%'
    ${WinPE Image Creation Parent Path} = '%_WinPE Image Creation Parent Path_%'
    $FolderFQN                          = '%_FolderFQN_%'
    ${.CommonItems}                     = '%_.CommonItems_%'

    Set-ExecutionPolicy -ExecutionPolicy 'RemoteSigned' -Scope 'Process' -Force
    . "${.CommonItems}\..\$FolderFQN\output\$FolderFQN\usb1\$FolderFQN\Base\5.1\Computer Info Lite.ps1"
    . "${.CommonItems}\..\$FolderFQN\output\$FolderFQN\usb1\$FolderFQN\Base\5.1\Location - Culture - Geography.ps1"
    ${Cultures Defined} = Import-CliXml -Path "${.CommonItems}\Cultures Defined.clixml"
    ${Cultures Excluded} = ${Cultures Defined}.Where({$_ -ne ${UserLocale}})
    #endregion
    & {
      #region | New Precursor Volume for eventual WinPE |
      ${Uncleared OSDeploy Disk CIM Instance} = Get-Disk | Where-Object -FilterScript {
        $_.FriendlyName -eq "${OSDeploy FriendlyName}" -and `
        $_.SerialNumber -eq "${OSDeploy SerialNumber}" -and `
        $_.UniqueId     -eq "${OSDeploy UniqueId Raw}"
      }

      ${OSDeploy Disk CIM Instance} = ${Uncleared OSDeploy Disk CIM Instance} | Clear-Disk -RemoveData -RemoveOEM -Confirm:$false -Verbose:$true -PassThru

      ${OSDeploy Disk CIM Instance} | Set-Disk -PartitionStyle 'MBR' -Verbose:$true
      ${WinPE Partition Size} = 1400MB
      ${MBR Partition 1 on OSDeploy Disk CIM Instance} = ${OSDeploy Disk CIM Instance} | New-Partition -Size (${WinPE Partition Size}) -AssignDriveLetter -MbrType 'FAT32' -Verbose:$true

      # The volume on the WinPE partition must be FAT32-formatted: 
      $NewFileSystemLabel = 'PRE_WINPE'
      ${WinPE Volume on MBR Partition 1 on OSDeploy Disk CIM Instance} = Format-Volume -FileSystem 'FAT32' -DriveLetter ${MBR Partition 1 on OSDeploy Disk CIM Instance}.DriveLetter -NewFileSystemLabel $NewFileSystemLabel -Verbose:$true
      ${WinPE Volume Drive Letter} = [System.String]${WinPE Volume on MBR Partition 1 on OSDeploy Disk CIM Instance}.DriveLetter + ':'
      <# NOTE! |
        # The indented code directly below does not resolve any volume letters because at this point 'PRE_WINPE' is a partition, and not a volume: 
          ${WinPE Volume} = Get-Volume -FriendlyName $NewFileSystemLabel -Verbose:$true; 
          ${WinPE Bootable USB Volume Letter} = ${WinPE Volume on MBR Partition 1 on OSDeploy Disk CIM Instance}.DriveLetter + ':'
      #>
      #endregion
      #region | New volume for eventual Server25 |
      # The remaining space can be NTFS. It will hold an extracted iso with setup.exe at the root. 
      ${MBR Partition 2 on OSDeploy Disk CIM Instance} = ${OSDeploy Disk CIM Instance} | New-Partition -UseMaximumSize -AssignDriveLetter -MbrType 'IFS' -Verbose:$true
      $NewFileSystemLabel = 'Server25'
      ${Server25 Volume on MBR Partition 2 on OSDeploy Disk CIM Instance} = Format-Volume -FileSystem 'NTFS' -DriveLetter ${MBR Partition 2 on OSDeploy Disk CIM Instance}.DriveLetter -NewFileSystemLabel $NewFileSystemLabel -Verbose:$true
      ${OSDeploy Volume Drive Letter} = [System.String]${Server25 Volume on MBR Partition 2 on OSDeploy Disk CIM Instance}.DriveLetter + ':'
      #endregion
      #region | Unmodified WinPE |
      ${WinPE x64 Tools Path} = "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64"
      ${ADK x64 Tools Path} = Resolve-Path -Path "${WinPE x64 Tools Path}\..\..\Deployment Tools\amd64" | Select-Object -ExpandProperty 'Path'

      # Define directory that contains unmodified files for WinPE ISO file generation
      ${WinPE Image Creation Parent Folder} = try {
        Get-Item -Path ${WinPE Image Creation Parent Path} -ErrorAction 'Stop'
      } catch {
        New-Item -Path ${WinPE Image Creation Parent Path} -ItemType 'Directory' -Force
      }
      ${WinPE Image Creation Path} = "${WinPE Image Creation Parent Path}\${WinPE Workspace Folder Name}"
      ${WinPE Default boot.wim Extracted Folder Path} = "${WinPE Image Creation Path}\.Default boot.wim File Extracted"

      <# Do what copype.cmd does, but with PowerShell |
        $KitsRoot      = "C:\Program Files (x86)\Windows Kits\10"
        $TEMPL         = 'media'
        $BOOTBINS      = 'bootbins'
        $WINPE_ARCH    = $env:PROCESSOR_ARCHITECTURE
        $WinPERoot     = "$KitsRoot\Assessment and Deployment Kit\Windows Preinstallation Environment"
        $SOURCE        = "$WinPERoot\$WINPE_ARCH"
        $DandIRoot     = "$KitsRoot\Assessment and Deployment Kit\Deployment Tools"
        $OSCDImgRoot   = "$DandIRoot\$WINPE_ARCH\Oscdimg"
        $FWFILESROOT   = Resolve-Path -Path "$OSCDImgRoot\..\..\$WINPE_ARCH\Oscdimg" | Select-Object -ExpandProperty 'Path'
        $DEST          = ${WinPE Default boot.wim Extracted Folder Path}
        $WIMSOURCEPATH = "$SOURCE\en-us\winpe.wim"
        $DISMRoot      = "$DandIRoot\$WINPE_ARCH\DISM"

        $path = "$DEST\$TEMPL"; $folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
        $path = "$DEST\mount"; $folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
        $path = "$DEST\$BOOTBINS"; $folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
        echo 'Staging media files...'
        # Copy the boot files and WinPE WIM to the destination location.
        # /h Hidden and system files.
        # /e Copy dirs and subdirs, including empty ones.
        # /r Overwrite read-only files.
        # /k Copies attributes. xcopy.exe without /k will reset read-only attributes.
        # /y Suppresses prompt for confirmation to overwrite an existing destination file.
        xcopy.exe /herky "$SOURCE\Media" "$DEST\$TEMPL\"
        $path = "$DEST\$TEMPL\sources"; $folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
        copy $WIMSOURCEPATH "$folder\boot.wim" 

        echo "Mount the WinPE WIM file:"
        .\amd64\DISM\dism.exe /Mount-Image /ImageFile:"$folder\boot.wim" /Index:1 /MountDir:"$DEST\mount" /ReadOnly

        #echo "Copy 2011 signed boot manager for later use"
        #copy "$DEST\mount\Windows\Boot\EFI\bootmgfw.efi" "$DEST\$BOOTBINS"

        echo "Copy 2023 signed BOOT MANAGER for later use"
        copy "$DEST\mount\Windows\Boot\EFI\bootmgfw_EX.efi" "$DEST\$BOOTBINS"

        echo 'Copy the BOOT SECTOR files from mounted .wim to enable booting & ISO creation:'
        # UEFI boot uses efisys.bin and efisys_EX.bin
        copy "$FWFILESROOT\efisys.bin" "$DEST\$BOOTBINS"
        copy "$FWFILESROOT\efisys_noprompt.bin" "$DEST\$BOOTBINS"
        copy "$FWFILESROOT\efisys_EX.bin" "$DEST\$BOOTBINS"
        copy "$FWFILESROOT\efisys_noprompt_EX.bin" "$DEST\$BOOTBINS"

        # BIOS boot uses etfsboot.com
        #copy "$FWFILESROOT\etfsboot.com" "$DEST\$BOOTBINS"
        echo "Unmounting '$DEST\$TEMPL\sources\boot.wim'"
        .\amd64\DISM\dism.exe /Unmount-Image /MountDir:"$DEST\mount" /Discard
      #>

      <# No need to create this folder of the extracted WinPE.wim file |
        # Extracts boot.wim (the WinPE image file) and copies into '.\.Default boot.wim File Extracted\'. 
        copype.cmd .\amd64\ ${WinPE Default boot.wim Extracted Folder Path}
      #>
      
      #region | Deprecated |
      <#
        ${CopyPE Amd64 Folder Path} = Join-Path -Path (Split-Path -Path ${WinPE Default boot.wim Extracted Folder Path} -Parent) -ChildPath 'amd64'
        copype.cmd .\amd64\ ${CopyPE Amd64 Folder Path}
        ${CopyPE arm64 Folder Path} = Join-Path -Path (Split-Path -Path ${WinPE Default boot.wim Extracted Folder Path} -Parent) -ChildPath 'arm64'
        copype.cmd .\arm64\ ${CopyPE arm64 Folder Path}
      #>

      <#
        ${CopyPE x86 Folder Path} = Join-Path -Path (Split-Path -Path ${WinPE Default boot.wim Extracted Folder Path} -Parent) -ChildPath 'x86'
        copype.cmd .\x86\ ${CopyPE x86 Folder Path}
        ${CopyPE arm Folder Path} = Join-Path -Path (Split-Path -Path ${WinPE Default boot.wim Extracted Folder Path} -Parent) -ChildPath 'arm'
        copype.cmd .\arm\ ${CopyPE arm Folder Path}
      #>
      #endregion

      <# No need to create this .iso file of WinPE |
        # Write to disk an .iso file of an original, unmodified instance of WinPE
        $path = "${WinPE Image Creation Path}\Default"; $folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
        MakeWinPeMedia.cmd /ISO ${WinPE Default boot.wim Extracted Folder Path} "$folder\WinPE.iso" /bootex
      #>
      #endregion
      #region | Custom WinPE |
      ${WinPE Updated boot.wim Extracted Folder Path} = "${WinPE Image Creation Parent Folder}\${WinPE Workspace Folder Name}\.Updated boot.wim File Extracted"
      $IsPresent = Test-Path -Path ${WinPE Updated boot.wim Extracted Folder Path}
      if (-not $IsPresent) {
        copype.cmd .\amd64\ ${WinPE Updated boot.wim Extracted Folder Path}
        <#
          foreach (${Culture Excluded} in ${Cultures Excluded}) {
            Get-ChildItem -Depth 0 -Path ${WinPE Updated boot.wim Extracted Folder Path} -Directory `
            | Where-Object -FilterScript {$_.BaseName -eq ${Culture Excluded}} `
            | Remove-Item -Recurse -Force

            Get-ChildItem -Depth 1 -Path ${WinPE Updated boot.wim Extracted Folder Path} -Directory `
            | Where-Object -FilterScript {$_.BaseName -eq ${Culture Excluded}} `
            | Remove-Item -Recurse -Force

            Get-ChildItem -Depth 2 -Path ${WinPE Updated boot.wim Extracted Folder Path} -Directory `
            | Where-Object -FilterScript {$_.BaseName -eq ${Culture Excluded}} `
            | Remove-Item -Recurse -Force
          }
        #>
        ${Mount Directory Path} = "${WinPE Image Creation Parent Folder}\${WinPE Workspace Folder Name}\Outside Mount"
        $path = ${Mount Directory Path}; $folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
        $lang = "${UserLocale}"
        .\amd64\DISM\dism.exe /Mount-Image /ImageFile:"${WinPE Updated boot.wim Extracted Folder Path}\media\sources\boot.wim" /Index:1 /MountDir:"${Mount Directory Path}"

        #region | Enable Windows PowerShell support in the WinPE operating system |
        $path = "${Mount Directory Path}\Canary 00.txt"; $file = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'File' -Force}
        #region | WinPE Optional Components (OCs) |
        # start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/winpe-add-packages--optional-components-reference?view=windows-11#winpe-optional-components'
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
        $path = "${Mount Directory Path}\Canary 05.txt"; $file = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'File' -Force}
        #endregion

        #region | Scriptoids |
        $path = "${Mount Directory Path}\Scriptoids"
        $folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
        Get-ChildItem -Path "${WinPE Image Creation Parent Folder}\..\* FriendlyName.clixml" | ForEach-Object -Process {Copy-Item -Path $_.FullName -Destination "$folder"}
        Get-ChildItem -Path "${WinPE Image Creation Parent Folder}\..\* SerialNumber.clixml" | ForEach-Object -Process {Copy-Item -Path $_.FullName -Destination "$folder"}
        Get-ChildItem -Path "${WinPE Image Creation Parent Folder}\..\* UniqueId Raw.clixml" | ForEach-Object -Process {Copy-Item -Path $_.FullName -Destination "$folder"}
        Move-Item -Path "${WinPE Image Creation Parent Folder}\00-sample.ps1" -Destination "$folder"
        Move-Item -Path "${WinPE Image Creation Parent Folder}\01-DiskPartClean.ps1" -Destination "$folder"
        Move-Item -Path "${WinPE Image Creation Parent Folder}\03-OsDiskPart1.ps1" -Destination "$folder"
        Move-Item -Path "${WinPE Image Creation Parent Folder}\03-OsDiskPart2.ps1" -Destination "$folder"
        Move-Item -Path "${WinPE Image Creation Parent Folder}\05-DismLoad-ApplyImage.ps1" -Destination "$folder"
        #endregion

        #region | Use newer version of DISM in WinPE | Update Startup script to load drivers for DISM |
        #Copy-Item -Path "${ADK x64 Tools Path}\DISM" -Destination "${Mount Directory Path}" -Recurse
        $path = "${Mount Directory Path}\DISM"; 
        $folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
        robocopy "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\DISM" "$folder"
        #endregion

        $path = "${Mount Directory Path}\Canary 10.txt"
        $file = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'File' -Force}

        #region | startnet.cmd > Startup Script |
        # Best performed separately. "${Mount Directory Path}\Windows\System32\startnet.cmd" begins with a call to wpeinit
        # Syntax for wpeinit is simple: 
        #     Wpeinit [-unattend:<path_to_answer_file>]
        # Example of wpeinit in action: 
        #     Wpeinit -unattend:"C:\Unattend-PE.xml"
        # So can Startnet.cmd launch a PowerShell script? 
        # I think it can. See the Unattend setting titled Microsoft-Windows-Setup/RunSynchronous.
        # That's probably how the PowerShell script is going to launch.
        Get-Item -Path "${Mount Directory Path}\Windows\System32\startnet.cmd" | Rename-Item -NewName 'startnet.cmd.old'
        
        Move-Item -Path "${WinPE Image Creation Parent Folder}\startnet.cmd" -Destination "${Mount Directory Path}\Windows\System32"

        #  $content = Get-Content -Path "$PSScriptRoot\startnet.cmd" -Raw
        #  Get-Item -Path "${Mount Directory Path}\Windows\System32\startnet.cmd" | Set-Content -Value $content

        #Get-Item -Path "${Mount Directory Path}\Windows\System32\startnet.cmd" | Add-Content -Value "powercfg.exe /s 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c"
        #Get-Item -Path "${Mount Directory Path}\Windows\System32\startnet.cmd" | Add-Content -Value "powershell.exe"
        #endregion

        #region | Increase temporary storage on the RAMDisk (scratch space) |
        # Probably not necessary
        .\amd64\DISM\dism.exe /Set-ScratchSpace:512 /Image:"${Mount Directory Path}"
        #endregion

        # Unmount the WinPE image and create media
        .\amd64\DISM\dism.exe /Unmount-Image /MountDir:"${Mount Directory Path}" /Commit

        # ${Disk CIM Instance} = Get-Disk | Where-Object -FilterScript {
        #   $_.FriendlyName -eq "${OSDeploy FriendlyName}" -and `
        #   $_.SerialNumber -eq "${OSDeploy SerialNumber}" -and `
        #   $_.UniqueId     -eq "${OSDeploy UniqueId Raw}"
        # }
        #${WinPE Partition Drive Letter Precursor} = ${Disk CIM Instance} | Get-Partition | Select-Object -ExpandProperty 'DriveLetter'
        #${WinPE Volume Drive Letter} = [System.String]${WinPE Partition Drive Letter Precursor} + ':'

        MakeWinPeMedia.cmd /UFD /f ${WinPE Updated boot.wim Extracted Folder Path} ${WinPE Volume Drive Letter} /bootex
        <# No need to create this .iso file of WinPE either |
          $path = "${WinPE Image Creation Path}\Updated"; $folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
          MakeWinPeMedia.cmd /ISO ${WinPE Updated boot.wim Extracted Folder Path} "$folder\WinPE.iso" /bootex
        #>
        
        Remove-Item -Path "${Mount Directory Path}"
      }
      #endregion
    }
  } | Out-Null
  #########################################-BOUNDARY-#########################################
) -join ''

${Bootable USB with PowerShell-enabled WinPE Command Here-String} = ${Bootable USB with PowerShell-enabled WinPE Command Here-String Precursor} `
  -replace '%_WinPE Workspace Folder Name_%',${WinPE Workspace Folder Name} `
  -replace '%_explorer_owner_%',${explorer.exe Owner} `
  -replace '%_WinPE Image Creation Parent Path_%',${WinPE Image Creation Parent Path} `
  -replace '%_FolderFQN_%',$FolderFQN `
  -replace '%_\.CommonItems_%',${env:.CommonItems}
${Bootable USB with PowerShell-enabled WinPE Command} = [ScriptBlock]::Create(${Bootable USB with PowerShell-enabled WinPE Command Here-String})

${Bootable USB with PowerShell-enabled WinPE Script Path} = "${WinPE Image Creation Parent Folder}\Bootable USB with PowerShell-enabled WinPE Script.ps1"
Set-Content -Path ${Bootable USB with PowerShell-enabled WinPE Script Path} -Value (${Bootable USB with PowerShell-enabled WinPE Command Here-String})

$WorkingDirectory = "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools"
return @{
  'Bootable USB with PowerShell-enabled WinPE Script Path' = ${Bootable USB with PowerShell-enabled WinPE Script Path}
  WorkingDirectory                                         = $WorkingDirectory
  'WinPE Image Creation Parent Folder'                     = ${WinPE Image Creation Parent Folder}
}
#endregion




