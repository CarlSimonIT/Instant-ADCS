#Requires -Version 5.1
#Requires -PSEdition Desktop


${explorer.exe Owner} = Import-CliXml -Path "$PSScriptRoot\..\..\..\.CommonItems\explorer.exe Owner.clixml"
${WinPE Image Creation Parent Path} = "$PSScriptRoot\..\..\..\.CommonItems\WinPE"
$FolderFQN = Import-CliXml -Path "$PSScriptRoot\..\..\..\.CommonItems\FolderFQN.clixml"
${WinPE Image Creation Parent Folder} = try {
  Get-Item -Path ${WinPE Image Creation Parent Path} -ErrorAction 'Stop'
} catch {
  New-Item -Path ${WinPE Image Creation Parent Path} -ItemType 'Directory' -Force
}

# Import into memory the unique identifiers for the disk holding the external removable bootable media: 
. "$PSScriptRoot\..\..\output\$FolderFQN\usb1\$FolderFQN\Base\5.1\External Bootable Media Drive Letters.ps1"

# . "C:\Users\lowpr\GitHub\CarlSimonIT\Instant-ADCS\output\Instant-ADCS\usb1\Instant-ADCS\Base\5.1\External Bootable Media Drive Letters.ps1"

${OSDeploy FriendlyName} = 'Samsung Flash Drive'
${OSDeploy UniqueId Raw} = 'USBSTOR\DISK&VEN_SAMSUNG&PROD_FLASH_DRIVE&REV_1100\0373515120000331&0:DESKTOP-RDASIMT'
${OSDeploy UniqueId Raw} -match ${Pattern UniqueId Raw} | Out-Null
${OSDeploy UniqueId} = $Matches['Unique_ID']
${OSDeploy SerialNumber} = 'AA00000000000489'

Write-Host -Object "`${OSDeploy FriendlyName} = ${OSDeploy FriendlyName}"
Write-Host -Object "`${OSDeploy UniqueId} = ${OSDeploy UniqueId}"
Write-Host -Object "`${OSDeploy UniqueId Raw} = ${OSDeploy UniqueId Raw}"
Write-Host -Object "`${OSDeploy SerialNumber} = ${OSDeploy SerialNumber}"



<#
  On GPT drives the System partition is the "EFI System Partition", or the ESP. 
  Stored on primary hard drive, which means the hard drive that contains an OS for the end-user? 
  A device boots to the ESP. 

  start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/configure-uefigpt-based-hard-drive-partitions?view=windows-11#system-partition'
#>


#region | ESP (EFI System Partition) |
${EFI System Partition on Removable External Bootable Media Command Here-String Precursor} = $(
  #region | Keep |
  # "#R3quires -Version 5.1`n"
  # "#R3quires -PSEdition Desktop`n"
  # "#R3quires -RunAsAdministrator`n"
  "`n"
  "`n"
  #endregion
  #region | Write/Read |

  "`t`t`t& { # Created with $([System.Char]39).\ConvertTo-HereStringCompatible.ps1$([System.Char]39) |`n"
  "`t`t`t  `${OSDeploy FriendlyName},`${OSDeploy SerialNumber},`${OSDeploy UniqueId Raw} = $([System.Char]39)%_OSDeploy FriendlyName_%$([System.Char]39),$([System.Char]39)%_OSDeploy SerialNumber_%$([System.Char]39),$([System.Char]34)%_OSDeploy UniqueId Raw_%$([System.Char]34)`n"
  "`t`t`t  `${Disk CIM Instance} = Get-Disk | Where-Object -FilterScript {`n"
  "`t`t`t    `$_.FriendlyName -eq `${OSDeploy FriendlyName} -and $([System.Char]96)`n"
  "`t`t`t    `$_.SerialNumber -eq `${OSDeploy SerialNumber} -and $([System.Char]96)`n"
  "`t`t`t    `$_.UniqueId     -eq `${OSDeploy UniqueId Raw}`n"
  "`t`t`t  }`n"
  "`t`t`t  `${Cleared Disk CIM Instance} = `${Disk CIM Instance} | Clear-Disk -RemoveData -RemoveOEM -Confirm:`$false -Verbose:`$true -PassThru`n"
  "`t`t`t  `${Cleared Disk CIM Instance} | Set-Disk -PartitionStyle $([System.Char]39)GPT$([System.Char]39) -Verbose:`$true`n"
  "`t`t`t  `${EFI System Partition CIM Instance} = `${Disk CIM Instance} | New-Partition -Size 827MB -AssignDriveLetter -GptType $([System.Char]39){c12a7328-f81f-11d2-ba4b-00a0c93ec93b}$([System.Char]39) -Verbose:`$true`n"
  "`t`t`t  # The entirety of the EFI System Partition must contain a FAT32-formatted volume:`n"
  "`t`t`t  `$NewFileSystemLabel = $([System.Char]39)WINPE_B0oT$([System.Char]39)`n"
  "`t`t`t  `${FAT32 Volume on ESP CIM Instance} = Format-Volume -FileSystem $([System.Char]39)FAT32$([System.Char]39) -DriveLetter `${EFI System Partition CIM Instance}.DriveLetter -NewFileSystemLabel `$NewFileSystemLabel -Verbose:`$true`n"
  "`t`t`t  `${WinPE Volume} = Get-Volume -FriendlyName `$NewFileSystemLabel -Verbose:`$true`n"
  "`t`t`t  `${WinPE Bootable USB Volume Letter} = `${FAT32 Volume on ESP CIM Instance}.DriveLetter + $([System.Char]39):$([System.Char]39)`n"
  "`t`t`t}`n"

  #endregion
  {
    #########################################-BOUNDARY-#########################################
    & { # Created with '.\ConvertTo-HereStringCompatible.ps1' |
      ${OSDeploy FriendlyName},${OSDeploy SerialNumber},${OSDeploy UniqueId Raw} = '%_OSDeploy FriendlyName_%','%_OSDeploy SerialNumber_%',"%_OSDeploy UniqueId Raw_%"
      ${Disk CIM Instance} = Get-Disk | Where-Object -FilterScript {
        $_.FriendlyName -eq ${OSDeploy FriendlyName} -and `
        $_.SerialNumber -eq ${OSDeploy SerialNumber} -and `
        $_.UniqueId     -eq ${OSDeploy UniqueId Raw}
      }
      ${Cleared Disk CIM Instance} = ${Disk CIM Instance} | Clear-Disk -RemoveData -RemoveOEM -Confirm:$false -Verbose:$true -PassThru
      ${Cleared Disk CIM Instance} | Set-Disk -PartitionStyle 'GPT' -Verbose:$true
      ${EFI System Partition CIM Instance} = ${Disk CIM Instance} | New-Partition -Size 827MB -AssignDriveLetter -GptType '{c12a7328-f81f-11d2-ba4b-00a0c93ec93b}' -Verbose:$true
      # The entirety of the EFI System Partition must contain a FAT32-formatted volume:
      $NewFileSystemLabel = 'WINPE_B0oT'
      ${FAT32 Volume on ESP CIM Instance} = Format-Volume -FileSystem 'FAT32' -DriveLetter ${EFI System Partition CIM Instance}.DriveLetter -NewFileSystemLabel $NewFileSystemLabel -Verbose:$true
      ${WinPE Volume} = Get-Volume -FriendlyName $NewFileSystemLabel -Verbose:$true
      ${WinPE Bootable USB Volume Letter} = ${FAT32 Volume on ESP CIM Instance}.DriveLetter + ':'
    }
    #########################################-BOUNDARY-#########################################
   } | Out-Null  
) -join ''


${EFI System Partition on Removable External Bootable Media Command Here-String} = ${EFI System Partition on Removable External Bootable Media Command Here-String Precursor} -replace '%_OSDeploy FriendlyName_%',${OSDeploy FriendlyName}
${EFI System Partition on Removable External Bootable Media Command Here-String} = ${EFI System Partition on Removable External Bootable Media Command Here-String} -replace '%_OSDeploy SerialNumber_%',${OSDeploy SerialNumber}
${EFI System Partition on Removable External Bootable Media Command Here-String} = ${EFI System Partition on Removable External Bootable Media Command Here-String} -replace '%_OSDeploy UniqueId Raw_%',${OSDeploy UniqueId Raw}
${EFI System Partition on Removable External Bootable Media Command} = [ScriptBlock]::Create(${EFI System Partition on Removable External Bootable Media Command Here-String})

<#
#>
${EFI System Partition on Removable External Bootable Media Script Path} = "${WinPE Image Creation Parent Folder}\EFI System Partition on Removable External Bootable Media Script.ps1"
Set-Content -Path ${EFI System Partition on Removable External Bootable Media Script Path} -Value (${EFI System Partition on Removable External Bootable Media Command Here-String})

<#
  Start-Process powershell.exe -ArgumentList @(
    ${EFI System Partition on Removable External Bootable Media Command}
  ) -Verb 'RunAs' -Verbose:$true -WindowStyle 'Normal' -Wait
#>

<#
  Start-Process powershell.exe -ArgumentList ${EFI System Partition on Removable External Bootable Media Command} -Verb 'RunAs' -Verbose:$true -WindowStyle 'Normal' -Wait
#>


$ArgumentList = @(
  "`${Here-String} = Get-Item -Path '${EFI System Partition on Removable External Bootable Media Script Path}' | Get-Content -Raw; `$ScriptBlock = [ScriptBlock]::Create(`${Here-String}); `$ScriptBlock | Invoke-Expression"
)

Start-Process -FilePath powershell.exe -ArgumentList $ArgumentList -Verb 'RunAs' -Verbose:$true -WindowStyle 'Normal' -Wait

#endregion
