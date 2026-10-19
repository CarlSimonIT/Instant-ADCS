#Requires -Version 5.1
#Requires -PSEdition Desktop
#Requires -RunAsAdministrator

param (
  ${Windows Server 2025 ISO Original File Path},
  ${Windows Server 2025 ISO Patched File Path}
)

<#
  ${Windows Server 2025 ISO Original File Path} = "C:\Users\lowpr\GitHub\CarlSimonIT\.CommonItems\usb0\Instant-ADCS\Microsoft\OS\Server 25\Original\Windows Server 2025.iso"
  ${Windows Server 2025 ISO Patched File Path}  = "C:\Users\lowpr\GitHub\CarlSimonIT\.CommonItems\usb0\Instant-ADCS\Microsoft\OS\Server 25\Patched\Windows Server 2025.iso"
#>


  #########################################-BOUNDARY-#########################################
  {
    ${Windows Server 2025 ISO Original File Path} = '%_Windows Server 2025 ISO Original File Path_%'
    ${Windows Server 2025 ISO Patched File Path} = '%_Windows Server 2025 ISO Patched File Path_%'
    & { # Created with '.\ConvertTo-HereStringCompatible.ps1' |


    }
  } | Out-Null
  #########################################-BOUNDARY-#########################################





& {

}

Get-Disk | Where-Object -FilterScript {$_.FriendlyName -eq 'Samsung Flash Drive'} | Clear-Disk -RemoveData -Confirm:$false -Verbose:$false
Get-Disk | Where-Object -FilterScript {$_.FriendlyName -eq 'Samsung Flash Drive'} | Clear-Disk -RemoveData -RemoveOEM -Confirm:$false -Verbose:$false
Get-Disk | Where-Object -FilterScript {$_.FriendlyName -eq 'Samsung Flash Drive'} | Clear-Disk -RemoveData -Sanitize -RemoveOEM -Confirm:$false -Verbose:$false
Get-Disk | Where-Object -FilterScript {$_.FriendlyName -eq 'Samsung Flash Drive'} | Clear-Disk -RemoveData
Get-Disk | Where-Object -FilterScript {$_.FriendlyName -eq 'Samsung Flash Drive'} | Initialize-Disk -PartitionStyle 'GPT'

#region | System Partition |
${Disk CIM Instance} = Get-Disk | Where-Object -FilterScript {
  $_.FriendlyName -eq 'Samsung Flash Drive'
} | Clear-Disk -RemoveData -RemoveOEM -Confirm:$false -Verbose:$false -PassThru
${Disk CIM Instance} | Set-Disk -PartitionStyle 'GPT'
${EFI System Partition CIM Instance} = ${Disk CIM Instance} | New-Partition -Size 628MB -AssignDriveLetter -GptType '{c12a7328-f81f-11d2-ba4b-00a0c93ec93b}'
# The entirety of the EFI System Partition must contain a FAT32-formatted volume:
$NewFileSystemLabel = 'WINPE_BOOT'
${FAT32 Volume on ESP CIM Instance} = Format-Volume -FileSystem 'FAT32' -DriveLetter ${EFI System Partition CIM Instance}.DriveLetter -NewFileSystemLabel $NewFileSystemLabel
${WinPE Volume} = Get-Volume -FriendlyName $NewFileSystemLabel
${WinPE Bootable USB Volume Letter} = ${FAT32 Volume on ESP CIM Instance}.DriveLetter + ':'


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