#Requires -Version 5.1
#Requires -PSEdition Desktop
#Requires -RunAsAdministrator


Get-Disk | Where-Object -FilterScript {$_.FriendlyName -eq 'Samsung Flash Drive'} | Clear-Disk -RemoveData -Confirm:$false -Verbose:$false
Get-Disk | Where-Object -FilterScript {$_.FriendlyName -eq 'Samsung Flash Drive'} | Clear-Disk -RemoveData -RemoveOEM -Confirm:$false -Verbose:$false
Get-Disk | Where-Object -FilterScript {$_.FriendlyName -eq 'Samsung Flash Drive'} | Clear-Disk -RemoveData -Sanitize -RemoveOEM -Confirm:$false -Verbose:$false
Get-Disk | Where-Object -FilterScript {$_.FriendlyName -eq 'Samsung Flash Drive'} | Clear-Disk -RemoveData
Get-Disk | Where-Object -FilterScript {$_.FriendlyName -eq 'Samsung Flash Drive'} | Initialize-Disk -PartitionStyle 'GPT'

#region | System Partition |
<#
  On GPT drives the System partition is the "EFI System Partition", or the ESP. 
  Stored on primary hard drive, which means the hard drive that contains an OS for the end-user? 
  A device boots to the ESP. 

  start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/configure-uefigpt-based-hard-drive-partitions?view=windows-11#system-partition'
#>

${Disk CIM Instance} = Get-Disk | Where-Object -FilterScript {
  $_.FriendlyName -eq 'Samsung Flash Drive'
} | Clear-Disk -RemoveData -RemoveOEM -Confirm:$false -Verbose:$false -PassThru

${Disk CIM Instance} | Set-Disk -PartitionStyle 'GPT'

${EFI System Partition CIM Instance} = ${Disk CIM Instance} | New-Partition -Size 628MB -AssignDriveLetter -GptType '{c12a7328-f81f-11d2-ba4b-00a0c93ec93b}'

# The entirety of the EFI System Partition must contain a FAT32-formatted volume:
$NewFileSystemLabel = 'WINPE_BOOT'
${EFS FAT32 Volume CIM Instance} = Format-Volume -FileSystem 'FAT32' -DriveLetter ${EFI System Partition CIM Instance}.DriveLetter -NewFileSystemLabel $NewFileSystemLabel
${WinPE Volume} = Get-Volume -FriendlyName $NewFileSystemLabel
${WinPE Bootable USB Volume Letter} = ${EFS FAT32 Volume CIM Instance}.DriveLetter + ':'


<#
  Set-ExecutionPolicy -ExecutionPolicy 'RemoteSigned' -Scope 'Process' -Force
  . "C:\Users\lowpr\GitHub\CarlSimonIT\Instant-ADCS\output\Instant-ADCS\usb1\Instant-ADCS\Base\5.1\Computer Info Lite.ps1"
  . "C:\Users\lowpr\GitHub\CarlSimonIT\Instant-ADCS\output\Instant-ADCS\usb1\Instant-ADCS\Base\5.1\Define explorer.exe Owner variable.ps1"
#>

#$ImagePath = [System.String[]]@("$env:UserProfile\WinPE\PowerShell-Infused\Updated ISO\PowerShell-Infused.iso")
$ImagePath = [System.String[]]@("$env:SystemDrive\Users\${explorer.exe Owner}\WinPE\PowerShell-Infused\Updated ISO\PowerShell-Infused.iso")
$HT = @{
  ImagePath     = $ImagePath
  StorageType   = [Microsoft.PowerShell.Cmdletization.GeneratedTypes.DiskImage.StorageType]::ISO
  NoDriveLetter = $false
  PassThru      = $true
}
${Mounted ISO CIM Instance} = Mount-DiskImage @HT
Get-Volume | Where-Object -FilterScript {$_.FriendlyName -eq 'DVD_ROM' -and $_.DriveType -eq 'CD-ROM'}

${Mounted ISO Volume} = Get-Volume | Where-Object -FilterScript {$_.DriveType -eq 'CD-ROM'}

$DriveLetter = Get-Volume | Where-Object -FilterScript {$_.FileSystemLabel -eq 'DVD_ROM' -and $_.DriveType -eq 'CD-ROM'} | Select-Object -ExpandProperty 'DriveLetter'
${WinPE Monted ISO Volume Letter} = $DriveLetter + ':'

Get-ChildItem -Path ${WinPE Monted ISO Volume Letter} -Directory | ForEach-Object -Process {Copy-Item -Path $_.FullName -Destination ${WinPE Bootable USB Volume Letter} -Recurse}
Get-ChildItem -Path ${WinPE Monted ISO Volume Letter} -File | ForEach-Object -Process {Copy-Item -Path $_.FullName -Destination ${WinPE Bootable USB Volume Letter}}

${Dismounted ISO CIM Instance} = ${Mounted ISO CIM Instance} | Dismount-DiskImage


#endregion





start msedge.exe 'https://learn.microsoft.com/en-us/windows-server/administration/windows-commands/set-id'
start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/configure-uefigpt-based-hard-drive-partitions?view=windows-11'

# WinPE Startup Scripts: 
start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/wpeinit-and-startnetcmd-using-winpe-startup-scripts?view=windows-11'
# 



# Apply Windows images on a newly created partition: 
start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/capture-and-apply-windows-system-and-recovery-partitions?view=windows-11'
# Windows Factory OS for OEMs. Windows Factory OS is targeted at two use cases: factory floor and driver development. 
start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/factoryos/?view=windows-11'
# Install Windows from a Flash Drive
'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/install-windows-from-a-usb-flash-drive?view=windows-11'
# Deployment Lab Sample Scripts
start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/oem-deployment-of-windows-desktop-editions-sample-scripts?view=windows-11&preserve-view=true#-createpartitions-uefitxt'

