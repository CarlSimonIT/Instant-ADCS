
<#
  Deployment Tools Reference for WinPE. 
  start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/winpe-intro?view=windows-11'

  All changes to the running instance of a WinPE OS are lost when WinPE reboots, including drivers, drive letters, and the WinPE Registry. 
  You'll want a customized WinPE image to work with:  
  start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/winpe-mount-and-customize?view=windows-11'

  Create bootable WinPE Media
  start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/winpe-create-usb-bootable-drive?view=windows-11'

  start msedge.exe ''

  Boot To WinPE
  start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/boot-to-winpe?view=windows-11'
#>


<#
  . "$env:UserProfile\GitHub\CarlSimonIT\$FolderFQN\output\$FolderFQN\usb1\$FolderFQN\Base\5.1\External Storage Media Drive Letters.ps1"
  "$usb0"
#>

#region | Default WinPE ISO File |
$amd64_XX = 'amd64_03'
${Make WinPE Media Here-String Precursor} = @'
  $WinPePath = "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Windows Preinstallation Environment\amd64"
  $WinPeDest = "$env:UserProfile\WinPE\%_amd64_XX_%"
  $WinPeIsoFolderPath = "$WinPeDest\ISO"
  copype.cmd amd64 $WinPeIsoFolderPath
  MakeWinPeMedia.cmd /ISO $WinPeIsoFolderPath $WinPeIsoFolderPath\WinPE_amd64.iso
'@
${Make WinPE Media Here-String} = ${Make WinPE Media Here-String Precursor} -replace '%_amd64_XX_%',$amd64_XX
Set-Content -Path "$env:Temp\Make_WinPE_Media_Script.ps1" -Value (${Make WinPE Media Here-String})
$WorkingDirectory = "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools"
Start-Process -FilePath cmd.exe -ArgumentList @(
  "/c $([System.Char]34)$WorkingDirectory\DandISetEnv.bat$([System.Char]34) && powershell.exe -NoProfile -ExecutionPolicy 'RemoteSigned'; Invoke-Expression -Command (Get-Content -Raw -Path '$env:TEMP\Make_WinPE_Media_Script.ps1')"
) -Verb 'RunAs'
#endregion

#region | Custom WinPE ISO File derived from default WinPE .iso |
#region | Add Windows PowerShell support to the WinPE OS |
# start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/winpe-adding-powershell-support-to-windows-pe?view=windows-11'
$path = "$env:UserProfile\WinPE\$amd64_XX\winpe_amd64"; 
$folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}

${Command Here-String Precursor} = $(
  # . "$env:UserProfile\GitHub\CarlSimonIT\Instant-ADCS\A0\ConvertTo-HereStringCompatible.ps1"
  "  & {`n"
  "    dism.exe /Mount-Image /ImageFile:$([System.Char]34)`$env:UserProfile\WinPE\%_amd64_XX_%\ISO\media\sources\boot.wim$([System.Char]34) /Index:1 /MountDir:$([System.Char]34)`$env:UserProfile\WinPE\%_amd64_XX_%\winpe_amd64$([System.Char]34)`n"
  "  }`n"
) -join ''
${Command Here-String} = ${Command Here-String Precursor} -replace '%_amd64_XX_%',$amd64_XX
${Mount Image Script Path} = "$env:UserProfile\WinPE\Mount Image Script.ps1"
Set-Content -Path ${Mount Image Script Path} -Value ${Command Here-String}
Start-Process -ArgumentList @(
  "Get-Item -Path '${Mount Image Script Path}' | Get-Content -Raw | Invoke-Expression"
) -FilePath powershell.exe -Verb 'RunAs' -WindowStyle 'Normal' # -Wait





${DISM_Testing Here-String} = @'
  dism.exe /help
'@
Set-Content -Path "$env:Temp\DISM_Testing.ps1" -Value (${DISM_Testing Here-String})
$WorkingDirectory = "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\DISM"

Dism.exe /Get-ImageInfo /ImageFile:"$ns\reimages\Win11Pro_ISO\sources\install.wim"

Start-Process -FilePath '.\dism.exe' -ArgumentList @(
  "/Get-ImageInfo"
  "/ImageFile:$env:UserProfile\WinPE\$amd64_XX\ISO\media\sources\boot.wim"

  #'/Mount-Image'
  #"/ImageFile:$([System.Char]34)$env:UserProfile\WinPE\$amd64_XX\ISO\media\sources\boot.wim$([System.Char]34)"
  #'/Index:1'
  #"/MountDir:$([System.Char]34)$env:UserProfile\WinPE\$amd64_XX\mount$([System.Char]34)"
) -Verb 'RunAs' -WorkingDirectory $WorkingDirectory -WindowStyle 'Normal' -Wait

$ArgumentList = @(
  "/Get-ImageInfo"
  "/ImageFile:$env:UserProfile\WinPE\$amd64_XX\ISO\media\sources\boot.wim"

  #'/Mount-Image'
  #"/ImageFile:$([System.Char]34)$env:UserProfile\WinPE\$amd64_XX\ISO\media\sources\boot.wim$([System.Char]34)"
  #'/Index:1'
  #"/MountDir:$([System.Char]34)$env:UserProfile\WinPE\$amd64_XX\mount$([System.Char]34)"
)
Start-Process -FilePath '.\dism.exe' -ArgumentList $ArgumentList -Verb 'RunAs' -WorkingDirectory $WorkingDirectory -WindowStyle 'Normal' -Wait


#   Dism /Mount-Image /ImageFile:"C:\WinPE_amd64_PS\media\sources\boot.wim" /Index:1 /MountDir:"C:\WinPE_amd64_PS\mount"

gci "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\DISM"

#endregion

#endregion


#region | WinPE |
${Micro Center 128GB Disk Orange} = Get-Disk | Where-Object -FilterScript {
  $_.FriendlyName -eq    " USB DISK 3.0" -and `
  $_.UniqueId     -match [regex]::Escape('USBSTOR\DISK&VEN_&PROD_USB_DISK_3.0&REV_PMAP\0721548B01B8DE35&0') -and `
  $_.SerialNumber -eq    '0D7E23155040'  
}
if (${Micro Center 128GB Disk Orange}.Count -ne 0) {
  ${Micro Center 128GB Partition Orange} = Get-Partition -DiskNumber ${Micro Center 128GB Disk Orange}.Number | Sort-Object Size -Descending | Select-Object -First 1
  ${Micro Center 128GB Volume Orange} = [System.String]${Micro Center 128GB Partition Orange}.DriveLetter + ":"
  $drivers128 = ${Micro Center 128GB Volume Orange}
}
Write-Host -Object "`r`n`t`$drivers128 = $drivers128`r`n"



"/k $([System.Char]34)$WorkingDirectory\DandISetEnv.bat$([System.Char]34) && powershell.exe -NoProfile -ExecutionPolicy 'RemoteSigned' -Command $([System.Char]34)Get-Item -Path '$env:TEMP\Make_WinPE_Media_Script.ps1' | Get-Content -Raw | Invoke-Expression$([System.Char]34)"



<#
  powershell.exe -NoProfile -ExecutionPolicy 'RemoteSigned' -Command "Get-Item -Path '$env:TEMP\Make_WinPE_Media_Script.s1' | Get-Content -Raw | Invoke-Expression"

  powershell.exe -NoProfile -ExecutionPolicy 'RemoteSigned' -Command "Get-Item -Path '%TEMP%\Make_WinPE_Media_Script.ps1' | Get-Content -Raw | Invoke-Expression"
  powershell.exe -NoProfile -ExecutionPolicy 'RemoteSigned' -Command "& '%TEMP%\Make_WinPE_Media_Script.ps1'"
  powershell.exe -NoProfile -ExecutionPolicy 'RemoteSigned' -Command "& '$env:temp\Make_WinPE_Media_Script.ps1'"
  powershell.exe -NoProfile -ExecutionPolicy 'RemoteSigned' -Command "& 'C:\Users\lowpr\AppData\Local\Temp\Make_WinPE_Media_Script.ps1'"
  powershell.exe -NoProfile -ExecutionPolicy 'RemoteSigned' -Command "Set-executionpolicy -executionpolicy RemoteSigned -scope process; & 'C:\Users\lowpr\AppData\Local\Temp\Make_WinPE_Media_Script.ps1'"


  powershell.exe -NoProfile -File %TEMP%\Make_WinPE_Media_Script.ps1
  powershell.exe -NoProfile -File '%TEMP%\Make_WinPE_Media_Script.ps1'
  powershell.exe -NoProfile -Command "Write-Host -Object 'Hello, World!'"
  powershell.exe -NoProfile -Command ""
#>


. "$env:ProgramFiles\PowerShell\7\pwsh.exe" -NoProfile -File "$PSScriptRoot\Start\Build Secure-Automations-Toolset Module.ps1"

#endregion



#region | PATCH TUESDAY | Apply Windows Updates to .iso file | Apply Windows Updates to bootable media | PATCH TUESDAY |
#region | ALL editions of Windows Server 2025 > Patched with most recent Windows Updates and No OEM-specific drivers |
$SamsungFITdisk = Get-Disk | Select-Object * | Where-Object -FilterScript {
  $_.FriendlyName -eq "Samsung Flash Drive FIT" -and `
  $_.UniqueId -match 'USBSTOR\\DISK&VEN_SAMSUNG&PROD_FLASH_DRIVE_FIT&REV_1100\\0330123070003679&0' -and `
  $_.SerialNumber -eq 'AA00000000000489'
}
if (-not ($SamsungFITdisk -eq $null)) {$SamsungFITpart = Get-Partition -DiskNumber $SamsungFITdisk.Number | Select-Object -First 1; $global:usb0 = [System.String]$SamsungFITpart.DriveLetter + ":"}
#                   start msedge 'https://www.catalog.update.microsoft.com/Home.aspx'
$PackageDirectory = "$ns\reimages\24H2_updates\2026-09";
$path = "$ns\reimages\ISO Image Files"; $dir = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -ItemType 'Directory' -Path $path -Force}
$path = "$ns\reimages\Server25_ISO";    $dir = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -ItemType 'Directory' -Path $path -Force}
$path = "$ns\reimages\m0unted_w1m";     $dir = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -ItemType 'Directory' -Path $path -Force}
$dir = try {Get-Item -Path $PackageDirectory -ErrorAction 'Stop'} catch {New-Item -ItemType 'Directory' -Path $PackageDirectory -Force}
$path = "$ns\reimages\winpe_amd64";     $dir = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -ItemType 'Directory' -Path $path -Force}
$path = "$ns\reimages\HelpFiles";       $dir = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -ItemType 'Directory' -Path $path -Force}
$path = "$ns\wsim\clg";                 $dir = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -ItemType 'Directory' -Path $path -Force}
$path = "$ns\wsim\Server25_ISO";        $dir = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -ItemType 'Directory' -Path $path -Force}

${Iso File Path} = "$ns\reimages\ISO Image Files\${Latest Server 2025}.iso"
if (Test-Path -Path ${Iso File Path}) {Remove-Item -Path ${Iso File Path}}
Copy-Item -Path "$usb0\Microsoft\OS\Server 25\Original\${Latest Server 2025}.iso" -Destination ${Iso File Path} -Force
#Copy-Item -Path "$usb0\Microsoft\OS\Server 25\Patched\${Latest Server 2025}.iso" -Destination ${Iso File Path} -Force
write "Mount the Server 2025 iso. Copy contents to `"$ns\reimages\Server25_ISO`". Dismount the iso."
# This should mount the ISO: 
start msedge.exe 'https://github.com/dsccommunity/StorageDsc/wiki/MountImage'
# This ain't it # ${Mounted Image Letter} = [System.String](Mount-DiskImage -ImagePath ${Iso File Path} -PassThru | Get-DiskImage | Get-Volume | % 'DriveLetter') + [System.String]':'
# This ain't it # Get-ChildItem -Path "${Mounted Image Letter}\" | Where-Object {$_.PSIsContainer -eq $true} | % {Copy-Item -Path $_.FullName -Destination "$ns\reimages\Server25_ISO" -Recurse}
# This ain't it # Get-ChildItem -Path "${Mounted Image Letter}\" | Where-Object {$_.PSIsContainer -eq $false} | % {Copy-Item -Path $_.FullName -Destination "$ns\reimages\Server25_ISO"}
# This ain't it # Dismount-DiskImage -ImagePath ${Iso File Path} | Out-Null
Set-ItemProperty -Path "$ns\reimages\Server25_ISO\sources\install.wim" -Name IsReadOnly -Value $false # Disable the ReadOnly attribute on the install.wim object
Set-Location -Path "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\DISM"

function Update-Server2025OfflineImage {
  [CmdletBinding()]
  param (
    [Parameter(
      Mandatory = $true
    )]
    [ValidateSet(1,2,3,4)]
    [System.Int32]
    $Index,

    [Parameter(
      Mandatory = $true
    )]
    [System.IO.DirectoryInfo]
    $PackageDirectory
  )

  ${Function Start Time} = [DateTime]::Now

  if ($usb0 -eq $null) {
    break
  }

  ${Mount Start} = [DateTime]::Now
  dism.exe /Mount-Wim /WimFile:"$ns\reimages\Server25_ISO\sources\install.wim" /Index:$Index /MountDir:"$ns\reimages\m0unted_w1m"
  ${Mount Finish} = [DateTime]::Now
  Write-Verbose -Message "  Mount Duration for `$index = $index$([System.Char]58) $((${Mount Finish} - ${Mount Start}).TotalSeconds.ToString('n3')) Seconds"
  
  ## Apply Update Package(s)
  # Do 1 and 20XX-XX need to be applied separately?! 
  ${Add-Package 1 Start} = [DateTime]::Now
  #Dism.exe /Image:"$ns\reimages\m0unted_w1m" /Add-Package /PackagePath:"$ns\reimages\24H2_updates\1"
  ${Add-Package 1 Finish} = [DateTime]::Now
  Write-Verbose -Message "  Phase I packaging duration on `$index = $index$([System.Char]58) $((${Add-Package 1 Finish} - ${Add-Package 1 Start}).TotalSeconds.ToString('n3')) Seconds"

  ${Add-Packages Start} = [DateTime]::Now
  #Dism.exe /Image:"$ns\reimages\m0unted_w1m" /Add-Package /PackagePath:"$ns\reimages\24H2_updates\2026-06"
  Dism.exe /Image:"$ns\reimages\m0unted_w1m" /Add-Package /PackagePath:$PackageDirectory
  ${Add-Packages Finish} = [DateTime]::Now
  Write-Verbose -Message "  Phase II packaging duration on `$index = $index$([System.Char]58) $((${Add-Packages Finish} - ${Add-Packages Start}).TotalSeconds.ToString('n3')) Seconds"

  ## Copy install.wim of focus to directory for CLG files...? 
  #Copy-Item -Path "$ns\reimages\m0unted_w1m"

  # Unmount the volume back to install.wim on the local file system
  ${Commit Start} = [DateTime]::Now
  Dism.exe /Unmount-Wim /MountDir:"$ns\reimages\m0unted_w1m" /Commit # /Discard
  ${Commit Finish} = [DateTime]::Now

  ${Function End Time} = [DateTime]::Now
  #Write-Verbose -Message "  Function total duration on `$index = $index$([System.Char]58) $((${Function End Time} - ${Function Start Time}).TotalSeconds.ToString('n3')) Seconds"
  ${Function TimeSpan} = ${Function End Time} - ${Function Start Time}
  $min = ${Function TimeSpan}.Minutes
  $sec = ${Function TimeSpan}.Seconds
  Write-Verbose -Message "  Function total duration on `$index = $index$([System.Char]58) $($min)m$($sec)s"
}
Update-Server2025OfflineImage -Index 1 -PackageDirectory $PackageDirectory
Update-Server2025OfflineImage -Index 2 -PackageDirectory $PackageDirectory
Update-Server2025OfflineImage -Index 3 -PackageDirectory $PackageDirectory
Update-Server2025OfflineImage -Index 4 -PackageDirectory $PackageDirectory

Set-Location -Path "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\Oscdimg"
Copy-Item -Path ".\efisys.bin" -Destination "$ns\reimages\HelpFiles" -Force
.\oscdimg.exe -b".\efisys.bin" -pEF -u1 -udfver102 "$ns\reimages\Server25_ISO" "$ns\reimages\winpe_amd64\${Latest Server 2025}.iso"
Set-Location "$env:SystemDrive"
Copy-Item -Path "$ns\reimages\winpe_amd64\${Latest Server 2025}.iso" -Destination "$usb0\Microsoft\OS\Server 25\Patched" -Force

${Iso File Path in WSIM} = "$env:NoSync\wsim\${Latest Server 2025}.iso"
if (Test-Path -Path ${Iso File Path in WSIM}) {Remove-Item -Path ${Iso File Path in WSIM}}
Copy-Item -Path "$ns\reimages\winpe_amd64\${Latest Server 2025}.iso" -Destination "$env:NoSync\wsim" -Force
# Get-Item -Path "$ns\reimages\winpe_amd64\${Latest Server 2025}.iso" | Remove-Item
if (Test-Path -Path ${Iso File Path}) {Remove-Item -Path ${Iso File Path}}
Set-Location $env:SystemDrive

#       Dont forget to load the drivers onto the bootable media! 

#region | Delete When The Time Is Right |
$Indexes = @(1,2,3,4)
for ($index = 1; $index -le 4; $index++) {
  ${Mount Start} = [DateTime]::Now
  dism.exe /Mount-Wim /WimFile:"$ns\reimages\Server25_ISO\sources\install.wim" /Index:$index /MountDir:"$ns\reimages\m0unted_w1m"
  ${Mount Finish} = [DateTime]::Now
  Write-Verbose -Message "  Mount Duration for `$index = $index$([System.Char]58) $((${Mount Finish} - ${Mount Start}).TotalSeconds.ToString('n3')) Seconds"
  
  # Extract onto mounted volume the PowerShell 5.1 modules containing DSC Resources
  $DscResourceModuleNames = @(
    'CertificateDsc'
    'ComputerManagementDsc'
    'PowerShellModule'
    'WSManDsc'
    'xComputerManagement'
    'xPSDesiredStateConfiguration'
  ) | Sort-Object | Get-Unique

  #Save-Module -Name $ModuleNames -Path "$ns\reimages\m0unted_w1m\Program Files\WindowsPowerShell\Modules"
  foreach ($DscResourceModuleName in $DscResourceModuleNames) {
    Get-Item -Path "$usb0\cfg\Preboots\dsc0\Modules\$DscResourceModuleName.zip" | ForEach-Object -Process {
      $HT = @{
        Path        = $_.FullName
        Destination = "$ns\reimages\m0unted_w1m\Program Files\WindowsPowerShell\Modules"
        Verbose     = $false
        Force       = $true
      }
      Expand-Archive @HT
    }
  }
  #  Get-ChildItem -Path "$usb0\cfg\installs\Modules\5.1" -Filter "*.zip" | ForEach-Object -Process {Expand-Archive -Path $_.FullName -Destination "$ns\reimages\m0unted_w1m\Program Files\WindowsPowerShell\Modules" -Force}

  $WindowsPowerShellModuleNames = @(
    #'Microsoft.PowerShell.Operation.Validation'
    #'PackageManagement'
    #'Pester'
    #'PowerShellGet'
    #'PSReadLine'
    'xDscDiagnostics'
  ) | Sort-Object | Get-Unique

  #Save-Module -Name $ModuleNames -Path "$ns\reimages\m0unted_w1m\Program Files\WindowsPowerShell\Modules"
  foreach ($WindowsPowerShellModuleName in $WindowsPowerShellModuleNames) {
    Get-Item -Path "$usb0\cfg\installs\Modules\5.1\$WindowsPowerShellModuleName.zip" | ForEach-Object -Process {
      $HT = @{
        Path        = $_.FullName
        Destination = "$ns\reimages\m0unted_w1m\Program Files\WindowsPowerShell\Modules"
        Verbose     = $false
        Force       = $true
      }
      Expand-Archive @HT
    }
  }

  ## Apply Update Package(s)
  # Do 1 and 20XX-XX need to be applied separately?! 
  ${Add-Package 1 Start} = [DateTime]::Now
  #Dism.exe /Image:"$ns\reimages\m0unted_w1m" /Add-Package /PackagePath:"$ns\reimages\24H2_updates\1"
  ${Add-Package 1 Finish} = [DateTime]::Now
  Write-Verbose -Message "  Phase I packaging duration on `$index = $index$([System.Char]58) $((${Add-Package 1 Finish} - ${Add-Package 1 Start}).TotalSeconds.ToString('n3')) Seconds"

  ${Add-Packages Start} = [DateTime]::Now
  Dism.exe /Image:"$ns\reimages\m0unted_w1m" /Add-Package /PackagePath:"$ns\reimages\24H2_updates\2026-06"
  ${Add-Packages Finish} = [DateTime]::Now
  Write-Verbose -Message "  Phase II packaging duration on `$index = $index$([System.Char]58) $((${Add-Packages Finish} - ${Add-Packages Start}).TotalSeconds.ToString('n3')) Seconds"

  # Unmount the volume back to install.wim on the local file system
  ${Commit Start} = [DateTime]::Now
  Dism.exe /Unmount-Wim /MountDir:"$ns\reimages\m0unted_w1m" /Commit # /Discard
  ${Commit Finish} = [DateTime]::Now
}
#endregion

#endregion

#region | ALL Editions of Windows 11 > Patched with most recent Windows Updates and No OEM-specific drivers |
$SamsungFITdisk = Get-Disk | Select-Object * | Where-Object -FilterScript {
  $_.FriendlyName -eq    "Samsung Flash Drive FIT"   -and `
  $_.UniqueId     -match 'USBSTOR\\DISK&VEN_SAMSUNG&PROD_FLASH_DRIVE_FIT&REV_1100\\0330123070003679&0' -and `
  $_.SerialNumber -eq    'AA00000000000489'
}
if (-not ($SamsungFITdisk -eq $null)) {
  $SamsungFITpart = Get-Partition -DiskNumber $SamsungFITdisk.Number | Select-Object -First 1; 
  $global:usb0 = [System.String]$SamsungFITpart.DriveLetter + ":"
}
Get-HotFix | sort InstalledOn -Descending | select HotfixID,Description,InstalledOn | Format-Table -AutoSize
#     start msedge 'https://www.catalog.update.microsoft.com/Home.aspx' # Grabbed 2 .msu files
#region | Windows 11 Enterprise |
$path = "$ns\reimages\ISO Image Files"; $dir = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -ItemType 'Directory' -Path $path -Force}
$path = "$ns\reimages\Win11Ent_ISO";    $dir = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -ItemType 'Directory' -Path $path -Force}
$path = "$ns\reimages\m0unted_w1m";     $dir = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -ItemType 'Directory' -Path $path -Force}
$path = "$ns\reimages\25H2_updates\2026-06";  $dir = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -ItemType 'Directory' -Path $path -Force}
$path = "$ns\reimages\winpe_amd64";     $dir = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -ItemType 'Directory' -Path $path -Force}
$path = "$ns\reimages\HelpFiles";       $dir = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -ItemType 'Directory' -Path $path -Force}
#$path = "$ns\reimages\FOD";            $dir = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -ItemType 'Directory' -Path $path -Force}

${Iso File Path} = "$ns\reimages\ISO Image Files\${Latest Windows 11 Enterprise}.iso"
if (Test-Path -Path ${Iso File Path}) {Remove-Item -Path ${Iso File Path}}
Copy-Item -Path "$usb0\Microsoft\OS\Windows 11 Enterprise\Original\${Latest Windows 11 Enterprise}.iso" -Destination ${Iso File Path} -Force
write "Mount the Windows 11 Enterprise iso. Copy contents to `"$ns\reimages\Win11Ent_ISO`". Dismount the iso."
Set-ItemProperty -Path "$ns\reimages\Win11Ent_ISO\sources\install.wim" -Name IsReadOnly -Value $false # Disable the ReadOnly attribute on the install.wim object
Set-Location -Path "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\DISM"
#     Dism.exe /Get-ImageInfo /ImageFile:"$ns\reimages\Win11Ent_ISO\sources\install.wim"
Dism.exe /Mount-Wim /WimFile:"$ns\reimages\Win11Ent_ISO\sources\install.wim" /Index:1 /MountDir:"$ns\reimages\m0unted_w1m"
# Extract onto mounted volume the PowerShell 5.1 modules containing DSC Resources
$DscResourceModuleNames = @(
  'CertificateDsc'
  'ComputerManagementDsc'
  'PowerShellModule'
  'WSManDsc'
  'xComputerManagement'
  'xPSDesiredStateConfiguration'
) | Sort-Object | Get-Unique
foreach ($DscResourceModuleName in $DscResourceModuleNames) {
  Get-Item -Path "$usb0\cfg\Preboots\dsc0\Modules\$DscResourceModuleName.zip" | ForEach-Object -Process {
    $HT = @{
      Path        = $_.FullName
      Destination = "$ns\reimages\m0unted_w1m\Program Files\WindowsPowerShell\Modules"
      Verbose     = $true
      Force       = $true
    }
    Expand-Archive @HT
  }
}
$WindowsPowerShellModuleNames = @(
  'xDscDiagnostics'
) | Sort-Object | Get-Unique
foreach ($WindowsPowerShellModuleName in $WindowsPowerShellModuleNames) {
  Get-Item -Path "$usb0\cfg\installs\Modules\5.1\$WindowsPowerShellModuleName.zip" | ForEach-Object -Process {
    $HT = @{
      Path        = $_.FullName
      Destination = "$ns\reimages\m0unted_w1m\Program Files\WindowsPowerShell\Modules"
      Verbose     = $true
      Force       = $true
    }
    Expand-Archive @HT
  }
}
<#
  Dism.exe /Image:"$ns\reimages\m0unted_w1m" /Get-Features > "$env:NoSync\Hyper-V Prep\Capabilities.txt"
  notepad.exe "$env:SystemDrive\Hyper-V Prep\features.txt"
  Dism.exe /Image:"$ns\reimages\m0unted_w1m" /Get-Packages
  write "Extract the Dell-provided drivers and don't forget the Mellanox drivers!"
  Dism.exe /Image:"$ns\reimages\m0unted_w1m" /Get-Capabilities > "$env:NoSync\Hyper-V Prep\Capabilities.txt"
#>
<# Installation of the RSATs on an offline mounted image of Windows 11 Enterprise | I'm starting to accept that this isn't possible! |
  start msedge.exe 'https://learn.microsoft.com/en-us/windows-hardware/manufacture/desktop/features-on-demand-non-language-fod?view=windows-11#remote-server-administration-tools-rsat'
  start msedge.exe 'https://github.com/IrrevocableNoob/RSAT-FOD-Offline-Install'
  start msedge.exe 'https://learn.microsoft.com/en-us/azure/virtual-desktop/windows-11-language-packs'
  start msedge.exe 'https://learn.microsoft.com/en-us/azure/virtual-desktop/windows-11-language-packs#prerequisites'
  start msedge.exe 'https://software-static.download.prss.microsoft.com/dbazure/888969d5-f34g-4e03-ac9d-1f9786c66749/26100.6584.250904-1728.ge_release_svc_prod1_amd64fre_InboxApps.iso'

  # Add Windows Capabilities: 
  DISM.exe /Image:"$ns\reimages\m0unted_w1m" /Add-Capability /CapabilityName:"Rsat.ServerManager.Tools~~~~0.0.1.0" /Source:"$usb0\"
#>

# Apply Update Package
Dism.exe /Image:"$ns\reimages\m0unted_w1m" /Add-Package /PackagePath:"$ns\reimages\25H2_updates\2026-06"

# Unmount the volume back to install.wim on the local file system
Dism.exe /Unmount-Wim /MountDir:"$ns\reimages\m0unted_w1m" /Commit # /Discard

Set-Location -Path "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\Oscdimg"
Copy-Item -Path ".\efisys.bin" -Destination "$ns\reimages\HelpFiles" -Force
.\oscdimg.exe -b".\efisys.bin" -pEF -u1 -udfver102 "$ns\reimages\Win11Ent_ISO" "$ns\reimages\winpe_amd64\${Latest Windows 11 Enterprise}.iso"
Set-Location "$env:SystemDrive"
Copy-Item -Path "$ns\reimages\winpe_amd64\${Latest Windows 11 Enterprise}.iso" -Destination "$usb0\Microsoft\OS\Windows 11 Enterprise\Patched" -Force
#       Get-Item -Path "$ns\reimages\winpe_amd64\${Latest Windows 11 Enterprise}.iso" | Remove-Item
Set-Location $env:SystemDrive
#endregion

#region | Windows 11 non-Enterprise |
$SamsungFITdisk = Get-Disk | Select-Object * | Where-Object -FilterScript {
  $_.FriendlyName -eq "Samsung Flash Drive FIT" -and `
  $_.UniqueId -match 'USBSTOR\\DISK&VEN_SAMSUNG&PROD_FLASH_DRIVE_FIT&REV_1100\\0330123070003679&0' -and `
  $_.SerialNumber -eq 'AA00000000000489'
}
if (-not ($SamsungFITdisk -eq $null)) {$SamsungFITpart = Get-Partition -DiskNumber $SamsungFITdisk.Number | Select-Object -First 1; $global:usb0 = [System.String]$SamsungFITpart.DriveLetter + ":"}
#                   start msedge 'https://www.catalog.update.microsoft.com/Home.aspx'
$PackageDirectory = "$ns\reimages\25H2_updates\2026-09";
$path = "$ns\reimages\ISO Image Files"; $dir = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -ItemType 'Directory' -Path $path -Force}
$path = "$ns\reimages\Win11Home_ISO";   $dir = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -ItemType 'Directory' -Path $path -Force}
$path = "$ns\reimages\Win11Pro_ISO";    $dir = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -ItemType 'Directory' -Path $path -Force}
$path = "$ns\reimages\m0unted_w1m";     $dir = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -ItemType 'Directory' -Path $path -Force}
$dir = try {Get-Item -Path $PackageDirectory -ErrorAction 'Stop'} catch {New-Item -ItemType 'Directory' -Path $PackageDirectory -Force}
$path = "$ns\reimages\winpe_amd64";     $dir = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -ItemType 'Directory' -Path $path -Force}
$path = "$ns\reimages\HelpFiles";       $dir = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -ItemType 'Directory' -Path $path -Force}

${Latest Windows 11 non-Enterprise} = 'Win11_25H2_English_x64_v2'
Copy-Item -Path "$usb0\Microsoft\OS\Windows 11 non-Enterprise\Original\${Latest Windows 11 non-Enterprise}.iso" -Destination "$ns\reimages\ISO Image Files"
#region | Windows 11 Home |
${Windows 11 Image Index} = 1
${Windows 11 PreMount} = 'Win11Home_ISO'

write "Mount the Windows 11 iso. Copy contents to:`r`n`t$ns\reimages\${Windows 11 PreMount}`r`nDismount the iso."
Remove-Item -Path "$ns\reimages\ISO Image Files\${Latest Windows 11 non-Enterprise}.iso"
Set-Location -Path "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\DISM"

Dism.exe /Get-ImageInfo /ImageFile:"$ns\reimages\${Windows 11 PreMount}\sources\install.wim" /Index:${Windows 11 Image Index}
Dism.exe /Mount-Wim /WimFile:"$ns\reimages\${Windows 11 PreMount}\sources\install.wim" /Index:${Windows 11 Image Index} /MountDir:"$ns\reimages\m0unted_w1m"
Dism.exe /Image:"$ns\reimages\m0unted_w1m" /Add-Package /PackagePath:$PackageDirectory
Dism.exe /Unmount-Wim /MountDir:"$ns\reimages\m0unted_w1m" /Commit # /Discard

Set-Location -Path "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\Oscdimg"
Copy-Item -Path ".\efisys.bin" -Destination "$ns\reimages\HelpFiles" -Force
.\oscdimg.exe -b".\efisys.bin" -pEF -u1 -udfver102 "$ns\reimages\${Windows 11 PreMount}" "$ns\reimages\winpe_amd64\${Latest Windows 11 non-Enterprise}.iso"
Set-Location "$env:SystemDrive"
Copy-Item -Path "$ns\reimages\winpe_amd64\${Latest Windows 11 non-Enterprise}.iso" -Destination "$usb0\Microsoft\OS\Windows 11 non-Enterprise\Patched" -Force
#endregion

#region | Windows 11 Pro |
${Windows 11 Image Index} = 6
${Windows 11 PreMount} = 'Win11Pro_ISO'

write "Mount the Windows 11 iso. Copy contents to:`r`n`t$ns\reimages\${Windows 11 PreMount}`r`nDismount the iso."
Remove-Item -Path "$ns\reimages\ISO Image Files\${Latest Windows 11 non-Enterprise}.iso"
Set-Location -Path "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\DISM"

Dism.exe /Get-ImageInfo /ImageFile:"$ns\reimages\${Windows 11 PreMount}\sources\install.wim" /Index:${Windows 11 Image Index}
Dism.exe /Mount-Wim /WimFile:"$ns\reimages\${Windows 11 PreMount}\sources\install.wim" /Index:${Windows 11 Image Index} /MountDir:"$ns\reimages\m0unted_w1m"
Dism.exe /Image:"$ns\reimages\m0unted_w1m" /Add-Package /PackagePath:$PackageDirectory
Dism.exe /Unmount-Wim /MountDir:"$ns\reimages\m0unted_w1m" /Commit # /Discard

Set-Location -Path "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\Oscdimg"
Copy-Item -Path ".\efisys.bin" -Destination "$ns\reimages\HelpFiles" -Force
.\oscdimg.exe -b".\efisys.bin" -pEF -u1 -udfver102 "$ns\reimages\${Windows 11 PreMount}" "$ns\reimages\winpe_amd64\${Latest Windows 11 non-Enterprise}.iso"
Set-Location "$env:SystemDrive"
Copy-Item -Path "$ns\reimages\winpe_amd64\${Latest Windows 11 non-Enterprise}.iso" -Destination "$usb0\Microsoft\OS\Windows 11 non-Enterprise\Patched" -Force
#endregion

{ # Windows 11 Professional (non-Enterprise) |
  Copy-Item -Path "$usb0\Microsoft\OS\Windows 11 Pro\Original\${Latest Windows 11 Pro}.iso" -Destination "$ns\reimages\ISO Image Files"
  #Copy-Item -Path "$usb0\Microsoft\OS\Windows 11 Pro\Patched\${Latest Windows 11 Pro}.iso" -Destination "$ns\reimages\ISO Image Files"
  write "Mount the Windows 11 Pro iso. Copy contents to:`r`n`t$ns\reimages\Win11Pro_ISO`r`nDismount the iso."
  Remove-Item -Path "$ns\reimages\ISO Image Files\${Latest Windows 11 Pro}.iso"
  Set-Location -Path "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\DISM"

  # Windows 11 Pro
  Dism.exe /Get-ImageInfo /ImageFile:"$ns\reimages\Win11Pro_ISO\sources\install.wim" /Index:6
  Dism.exe /Mount-Wim /WimFile:"$ns\reimages\Win11Pro_ISO\sources\install.wim" /Index:6 /MountDir:"$ns\reimages\m0unted_w1m"
  $DscResourceModules = @(
    "$usb0\cfg\Preboots\dsc0\Modules\xPSDesiredStateConfiguration.zip"
    "$usb0\cfg\Preboots\dsc0\Modules\WSManDsc.zip"
    "$usb0\cfg\Preboots\dsc0\Modules\ComputerManagementDsc.zip"
    #     "$usb0\cfg\Preboots\dsc0\Modules\PowerShellModule.zip"
    #     "$usb0\cfg\Preboots\dsc0\Modules\CertificateDsc.zip"
    #     "$usb0\cfg\Preboots\dsc0\Modules\xComputerManagement.zip"
    "$usb0\cfg\installs\Modules\5.1\xDscDiagnostics.zip"
  )
  $DscResourceModules | ForEach-Object {
    $HT = @{
      Path            = $_
      DestinationPath = "$ns\reimages\m0unted_w1m\Program Files\WindowsPowerShell\Modules"
      Verbose         = $true
      Force           = $true
    }
    Expand-Archive @HT
  }
  Dism.exe /Image:"$ns\reimages\m0unted_w1m" /Add-Package /PackagePath:"$ns\reimages\25H2_updates\2025-12\1"
  Dism.exe /Image:"$ns\reimages\m0unted_w1m" /Add-Package /PackagePath:"$ns\reimages\25H2_updates\2025-12\2"
  Dism.exe /Unmount-Wim /MountDir:"$ns\reimages\m0unted_w1m" /Commit # /Discard
  
  ## Windows 11 Pro for Workstations
  #Dism.exe /Get-ImageInfo /ImageFile:"$ns\reimages\Win11Pro_ISO\sources\install.wim" /Index:10
  
  Set-Location -Path "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\Oscdimg"
  Copy-Item -Path "$ns\reimages\Win11Pro_ISO\efi\microsoft\boot\efisys.bin" -Destination "$ns\reimages\HelpFiles" -Force
  .\oscdimg.exe -b"$ns\reimages\HelpFiles\efisys.bin" -pEF -u1 -udfver102 "$ns\reimages\Win11Pro_ISO" "$ns\reimages\winpe_amd64\${Latest Windows 11 Pro}.iso"
  Copy-Item -Path "$ns\reimages\winpe_amd64\${Latest Windows 11 Pro}.iso" -Destination "$usb0\Microsoft\OS\Windows 11 Pro\Patched" -Force
  Set-Location "$env:SystemDrive"
}
#endregion
#endregion

#region | PATCH TUESDAY: Apply Windows Updates for both editions of Datacenter to each USB drive containing mootable bedia |
Set-Location -Path "C:\Program Files (x86)\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\DISM"

$DriveLetter = (Get-Disk).Where({($_.FriendlyName -eq 'USB SanDisk 3.2Gen1') -and ($_.SerialNumber -match '03028531021721131723')}) | % 'Number' | % {Get-Partition -DiskNumber $_} | Sort-Object Size -Descending | Select-Object -First 1 | % 'DriveLetter'; $orange16 = $DriveLetter + ':'; Write-Host -Object "`r`n`t`$orange16 = $orange16`r`n"
$usbVol = $orange16; $index = 3
.\Set-Location -Path "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\DISM"
Dism.exe /Mount-Wim /WimFile:"$usbVol\sources\install.wim" /Index:$index /MountDir:"$ns\reimages\m0unted_w1m"
.\dism.exe /Image:"$ns\reimages\m0unted_w1m" /Cleanup-Image /StartComponentCleanup

Dism.exe /Image:"$ns\reimages\m0unted_w1m" /Cleanup-Image /CheckHealth
Dism.exe /Image:"$ns\reimages\m0unted_w1m" /Cleanup-Image /ScanHealth
Dism.exe /Image:"$ns\reimages\m0unted_w1m" /Cleanup-Image /StartComponentCleanup /ResetBase
Dism.exe /Image:"$ns\reimages\m0unted_w1m" /Add-Package /PackagePath:"$ns\reimages\24H2_updates\1"
Dism.exe /Image:"$ns\reimages\m0unted_w1m" /Add-Package /PackagePath:"$ns\reimages\24H2_updates\2"
.\dism.exe /Unmount-Wim /MountDir:"$ns\reimages\m0unted_w1m" /Commit
.\dism.exe /Unmount-Wim /MountDir:"$ns\reimages\m0unted_w1m" /Discard
$usbVol = $orange16; $index = 4
Set-Location -Path "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\DISM"
Dism.exe /Mount-Wim /WimFile:"$usbVol\sources\install.wim" /Index:$index /MountDir:"$ns\reimages\m0unted_w1m"
Dism.exe /Image:"$ns\reimages\m0unted_w1m" /Add-Package /PackagePath:"$ns\reimages\24H2_updates\1"
Dism.exe /Image:"$ns\reimages\m0unted_w1m" /Add-Package /PackagePath:"$ns\reimages\24H2_updates\2"
Dism.exe /Unmount-Wim /MountDir:"$ns\reimages\m0unted_w1m" /Commit

$DriveLetter = (Get-Disk).Where({($_.FriendlyName -eq 'USB SanDisk 3.2Gen1') -and ($_.SerialNumber -match '03036108020821093957')}) | % 'Number' | % {Get-Partition -DiskNumber $_} | Sort-Object Size -Descending | Select-Object -First 1 | % 'DriveLetter'; $pink16 = $DriveLetter + ':';   Write-Host -Object "`r`n`t`$pink16 = $pink16`r`n"
$usbVol = $pink16; $index = 3
Set-Location -Path "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\DISM"
Dism.exe /Mount-Wim /WimFile:"$usbVol\sources\install.wim" /Index:$index /MountDir:"$ns\reimages\m0unted_w1m"
Dism.exe /Image:"$ns\reimages\m0unted_w1m" /Add-Package /PackagePath:"$ns\reimages\24H2_updates\1"
Dism.exe /Image:"$ns\reimages\m0unted_w1m" /Add-Package /PackagePath:"$ns\reimages\24H2_updates\2"
Dism.exe /Unmount-Wim /MountDir:"$ns\reimages\m0unted_w1m" /Commit
$usbVol = $pink16; $index = 4
Set-Location -Path "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\DISM"
Dism.exe /Mount-Wim /WimFile:"$usbVol\sources\install.wim" /Index:$index /MountDir:"$ns\reimages\m0unted_w1m"
Dism.exe /Image:"$ns\reimages\m0unted_w1m" /Add-Package /PackagePath:"$ns\reimages\24H2_updates\1"
Dism.exe /Image:"$ns\reimages\m0unted_w1m" /Add-Package /PackagePath:"$ns\reimages\24H2_updates\2"
Dism.exe /Unmount-Wim /MountDir:"$ns\reimages\m0unted_w1m" /Commit

${Samsung BAR Plus 64 GB Disk Brown} = (Get-Disk).Where({($_.FriendlyName -eq 'Samsung Flash Drive') -and ($_.SerialNumber -match 'AA00000000000489') -and ($_.UniqueId -match [System.Text.RegularExpressions.Regex]::Escape('USBSTOR\DISK&VEN_SAMSUNG&PROD_FLASH_DRIVE&REV_1100\0363923110003084&0'))}); if (${Samsung BAR Plus 64 GB Disk Brown}.Count -ne 0) {${Samsung BAR Plus 64 GB Partition Brown} = Get-Partition -DiskNumber ${Samsung BAR Plus 64 GB Disk Brown}.Number | Sort-Object Size -Descending | Select-Object -First 1; ${Samsung BAR Plus 64 GB Vol Brown} = [System.String]${Samsung BAR Plus 64 GB Partition Brown}.DriveLetter + ":"; $global:brown64 = ${Samsung BAR Plus 64 GB Vol Brown}}; Write-Host -Object "`r`n`t`$brown64 = $brown64`r`n"
$usbVol = $brown64; $index = 6
Set-Location -Path "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\DISM"
Dism.exe /Mount-Wim /WimFile:"$usbVol\sources\install.wim" /Index:$index /MountDir:"$ns\reimages\m0unted_w1m"
Dism.exe /Image:"$ns\reimages\m0unted_w1m" /Add-Package /PackagePath:"$ns\reimages\24H2_updates\1"
Dism.exe /Image:"$ns\reimages\m0unted_w1m" /Add-Package /PackagePath:"$ns\reimages\24H2_updates\2"
Dism.exe /Unmount-Wim /MountDir:"$ns\reimages\m0unted_w1m" /Commit

$DriveLetter = (Get-Disk).Where({($_.FriendlyName -eq 'USB SanDisk 3.2Gen1') -and ($_.SerialNumber -match '03021506111324074313')}) | % 'Number' | % {Get-Partition -DiskNumber $_} | Sort-Object Size -Descending | Select-Object -First 1 | % 'DriveLetter'; $yellow64 = $DriveLetter + ':'; Write-Host -Object "`r`n`t`$yellow64 = $yellow64`r`n"
$usbVol = $yellow64; $index = 4
Set-Location -Path "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\DISM"
Dism.exe /Mount-Wim /WimFile:"$usbVol\sources\install.wim" /Index:$index /MountDir:"$ns\reimages\m0unted_w1m"
Dism.exe /Image:"$ns\reimages\m0unted_w1m" /Add-Package /PackagePath:"$ns\reimages\24H2_updates\1"
Dism.exe /Image:"$ns\reimages\m0unted_w1m" /Add-Package /PackagePath:"$ns\reimages\24H2_updates\2"
Dism.exe /Unmount-Wim /MountDir:"$ns\reimages\m0unted_w1m" /Commit

# Formerly the HP ProDesk with the Coffee Lake processor. Repurposed for OfflineDSC as of 2025-06-24. 
$DriveLetter = ((Get-Disk).Where({($_.FriendlyName -eq "ADATA USB Flash Drive") -and ($_.UniqueId -match [regex]::Escape('USBSTOR\DISK&VEN_ADATA&PROD_USB_FLASH_DRIVE&REV_1100\26910013401500DC&0'))}) | % 'Number' | % {Get-Partition -DiskNumber $_} | Sort-Object Size -Descending | Select-Object -First 1 | % 'DriveLetter'); $sky16 = $DriveLetter + ':'; Write-Host -Object "`r`n`t`$sky16 = $sky16`r`n"
$usbVol = $sky16; $index = 3
Set-Location -Path "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\DISM"
Dism.exe /Mount-Wim /WimFile:"$usbVol\sources\install.wim" /Index:$index /MountDir:"$ns\reimages\m0unted_w1m"
Dism.exe /Image:"$ns\reimages\m0unted_w1m" /Add-Package /PackagePath:"$ns\reimages\24H2_updates\1"
Dism.exe /Image:"$ns\reimages\m0unted_w1m" /Add-Package /PackagePath:"$ns\reimages\24H2_updates\2"
Dism.exe /Unmount-Wim /MountDir:"$ns\reimages\m0unted_w1m" /Commit
$usbVol = $sky16; $index = 4
Set-Location -Path "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\DISM"
Dism.exe /Mount-Wim /WimFile:"$usbVol\sources\install.wim" /Index:$index /MountDir:"$ns\reimages\m0unted_w1m"
Dism.exe /Image:"$ns\reimages\m0unted_w1m" /Add-Package /PackagePath:"$ns\reimages\24H2_updates\1"
Dism.exe /Image:"$ns\reimages\m0unted_w1m" /Add-Package /PackagePath:"$ns\reimages\24H2_updates\2"
Dism.exe /Unmount-Wim /MountDir:"$ns\reimages\m0unted_w1m" /Commit

${Samsung Flash Drive FIT 128 GB Disk Gray} = (Get-Disk).Where({($_.FriendlyName -eq 'Samsung Flash Drive FIT') -and ($_.SerialNumber -match 'AA00000000000489') -and ($_.UniqueId -match [System.Text.RegularExpressions.Regex]::Escape('USBSTOR\DISK&VEN_SAMSUNG&PROD_FLASH_DRIVE_FIT&REV_1100\0360921080001525&0'))}); if (${Samsung Flash Drive FIT 128 GB Disk Gray}.Count -ne 0) {${Samsung Flash Drive FIT 128 GB Partition Gray} = Get-Partition -DiskNumber ${Samsung Flash Drive FIT 128 GB Disk Gray}.Number | Sort-Object Size -Descending | Select-Object -First 1; ${Samsung Flash Drive FIT 128 GB Vol Gray} = [System.String]${Samsung Flash Drive FIT 128 GB Partition Gray}.DriveLetter + ":"; $global:gray128 = ${Samsung Flash Drive FIT 128 GB Vol Gray}}; Write-Host -Object "`r`n`t`$gray128 = $gray128`r`n"
$usbVol = $gray128; $index = 3
Set-Location -Path "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\DISM"
Dism.exe /Mount-Wim /WimFile:"$usbVol\sources\install.wim" /Index:$index /MountDir:"$ns\reimages\m0unted_w1m"
Dism.exe /Image:"$ns\reimages\m0unted_w1m" /Add-Package /PackagePath:"$ns\reimages\24H2_updates\1"
Dism.exe /Image:"$ns\reimages\m0unted_w1m" /Add-Package /PackagePath:"$ns\reimages\24H2_updates\2"
Dism.exe /Unmount-Wim /MountDir:"$ns\reimages\m0unted_w1m" /Commit
$usbVol = $gray128; $index = 4
Set-Location -Path "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\DISM"
Dism.exe /Mount-Wim /WimFile:"$usbVol\sources\install.wim" /Index:$index /MountDir:"$ns\reimages\m0unted_w1m"
Dism.exe /Image:"$ns\reimages\m0unted_w1m" /Add-Package /PackagePath:"$ns\reimages\24H2_updates\1"
Dism.exe /Image:"$ns\reimages\m0unted_w1m" /Add-Package /PackagePath:"$ns\reimages\24H2_updates\2"
Dism.exe /Unmount-Wim /MountDir:"$ns\reimages\m0unted_w1m" /Commit



{ # 2025-07 Patch APPLIED |
  ${Samsung BAR Plus 64 GB Disk Red} = (Get-Disk).Where({($_.FriendlyName -eq 'Samsung Flash Drive') -and ($_.SerialNumber -match 'AA00000000000489') -and ($_.UniqueId -match [System.Text.RegularExpressions.Regex]::Escape('USBSTOR\DISK&VEN_SAMSUNG&PROD_FLASH_DRIVE&REV_1100\0317923110003028&0'))}); if (${Samsung BAR Plus 64 GB Disk Red}.Count -ne 0) {${Samsung BAR Plus 64 GB Partition Red} = Get-Partition -DiskNumber ${Samsung BAR Plus 64 GB Disk Red}.Number | Sort-Object Size -Descending | Select-Object -First 1; ${Samsung BAR Plus 64 GB Vol Red} = [System.String]${Samsung BAR Plus 64 GB Partition Red}.DriveLetter + ":"; $global:red64 = ${Samsung BAR Plus 64 GB Vol Red}}; Write-Host -Object "`r`n`t`$red64 = $red64`r`n"
  $usbVol = $red64; $index = 3
  Set-Location -Path "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\DISM"
Dism.exe /Mount-Wim /WimFile:"$usbVol\sources\install.wim" /Index:$index /MountDir:"$ns\reimages\m0unted_w1m"
  Dism.exe /Image:"$ns\reimages\m0unted_w1m" /Add-Package /PackagePath:"$ns\reimages\24H2_updates\1"
  Dism.exe /Image:"$ns\reimages\m0unted_w1m" /Add-Package /PackagePath:"$ns\reimages\24H2_updates\2"
  Dism.exe /Unmount-Wim /MountDir:"$ns\reimages\m0unted_w1m" /Commit
  
  $usbVol = $red64; $index = 4
  Set-Location -Path "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\DISM"
Dism.exe /Mount-Wim /WimFile:"$usbVol\sources\install.wim" /Index:$index /MountDir:"$ns\reimages\m0unted_w1m"
  if (Test-Path -Path "$ns\localhost.mof") { # Copy over the
    Copy-Item -Path "$ns\localhost.mof" -Destination "$ns\reimages\m0unted_w1m\Windows\System32\Configuration\Pending.mof" -Force
    Test-Path -Path "$ns\reimages\m0unted_w1m\Windows\System32\Configuration\Pending.mof"
  }
  Dism.exe /Image:"$ns\reimages\m0unted_w1m" /Add-Package /PackagePath:"$ns\reimages\24H2_updates\1"
  Dism.exe /Image:"$ns\reimages\m0unted_w1m" /Add-Package /PackagePath:"$ns\reimages\24H2_updates\2"
  Dism.exe /Unmount-Wim /MountDir:"$ns\reimages\m0unted_w1m" /Commit
}




$DriveLetter = (Get-Disk).Where({($_.FriendlyName -eq 'USB SanDisk 3.2Gen1') -and ($_.SerialNumber -match '0401b24272bbb7468580')}) | % 'Number' | % {Get-Partition -DiskNumber $_} | Sort-Object Size -Descending | Select-Object -First 1 | % 'DriveLetter'; $SkyBlue32 = $DriveLetter + ':';   Write-Host -Object "`r`n`t`$SkyBlue32 = $SkyBlue32`r`n"
$DriveLetter = (Get-Disk).Where({($_.FriendlyName -eq 'USB SanDisk 3.2Gen1') -and ($_.SerialNumber -match '040170557f5ffbf9a7af')}) | % 'Number' | % {Get-Partition -DiskNumber $_} | Sort-Object Size -Descending | Select-Object -First 1 | % 'DriveLetter'; $red32 = $DriveLetter + ':';   Write-Host -Object "`r`n`t`$red32 = $red32`r`n"
#endregion
#endregion



#region | Windows 11 Pro on Dell Precision 3460 |
${Windows 11 Image Index} = 6
${Micro Center 128GB Disk Orange} = Get-Disk | Where-Object -FilterScript {
  $_.FriendlyName -eq    " USB DISK 3.0" -and `
  $_.UniqueId     -match [regex]::Escape('USBSTOR\DISK&VEN_&PROD_USB_DISK_3.0&REV_PMAP\0721548B01B8DE35&0') -and `
  $_.SerialNumber -eq    '0D7E23155040'  
}
if (${Micro Center 128GB Disk Orange}.Count -ne 0) {
  ${Micro Center 128GB Partition Orange} = Get-Partition -DiskNumber ${Micro Center 128GB Disk Orange}.Number | Sort-Object Size -Descending | Select-Object -First 1
  ${Micro Center 128GB Volume Orange} = [System.String]${Micro Center 128GB Partition Orange}.DriveLetter + ":"
  $drivers128 = ${Micro Center 128GB Volume Orange}
}
Write-Host -Object "`r`n`t`$drivers128 = $drivers128`r`n"

Get-HotFix | sort InstalledOn -Descending | select HotfixID,Description,InstalledOn | Format-Table -AutoSize
start msedge 'https://www.xda-developers.com/best-windows-powershell-commands/'
$HIRO = "$drivers128\drivers\realtek\HIRO PCIe Gigabit NIC"
$path = "$ns\reimages\ISO Image Files"; $dir = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -ItemType 'Directory' -Path $path -Force}
$path = "$ns\reimages\Win11Pro_ISO"; $dir = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -ItemType 'Directory' -Path $path -Force}
$path = "$ns\reimages\Win11Home_ISO"; $dir = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -ItemType 'Directory' -Path $path -Force}
$path = "$ns\reimages\m0unted_w1m"; $dir = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -ItemType 'Directory' -Path $path -Force}
$path = "$ns\reimages\24H2_updates"; $dir = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -ItemType 'Directory' -Path $path -Force}
$path = "$ns\reimages\25H2_updates"; $dir = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -ItemType 'Directory' -Path $path -Force}
$path = "$ns\reimages\26H2_updates"; $dir = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -ItemType 'Directory' -Path $path -Force}
$path = "$ns\reimages\HelpFiles"; $dir = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -ItemType 'Directory' -Path $path -Force}
$path = "$ns\reimages\winpe_amd64"; $dir = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -ItemType 'Directory' -Path $path -Force}
$path = "$ns\reimages\Extracted Driver Files"; $dir = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -ItemType 'Directory' -Path $path -Force}
#   Export-WindowsDriver -Online -Destination "$dir" -Verbose
#   Dism.exe /online /export-driver /destination:"$dir"

$DriveLetter = (Get-Disk).Where({($_.FriendlyName -eq 'USB SanDisk 3.2Gen1') -and ($_.SerialNumber -match '03028531021721131723')}) | Select-Object -ExpandProperty 'Number' | ForEach-Object -Process {Get-Partition -DiskNumber $_} | Sort-Object Size -Descending | Select-Object -First 1 | Select-Object -ExpandProperty 'DriveLetter'; $orange16 = $DriveLetter + ':'; $orange16; 
if ($orange16.Length -eq 2) {$usbVol = $orange16}
$DriveLetter = (Get-Disk).Where({($_.FriendlyName -eq 'USB SanDisk 3.2Gen1') -and ($_.SerialNumber -match '03036108020821093957')}) | Select-Object -ExpandProperty 'Number' | ForEach-Object -Process {Get-Partition -DiskNumber $_} | Sort-Object Size -Descending | Select-Object -First 1 | Select-Object -ExpandProperty 'DriveLetter'; $pink16 = $DriveLetter + ':'; $pink16; 
if ($pink16.Length -eq 2) {$usbVol = $pink16}

${RealTek RTL8153} = "$drivers128\drivers\realtek\RTL8153\USB Type-A to Ethernet Dongle from Uni Accessories\Win11 Auto Installation Program (NetAdapterCx) (2024-12-06)\Install\Install\WIN11\cx\64"
Set-Location -Path "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\DISM"
dism.exe /Mount-Wim /WimFile:"$usbVol\sources\install.wim" /Index:${Windows 11 Image Index} /MountDir:"$ns\reimages\m0unted_w1m"
#region | Drivers for Datacenter Desktop Experience | Features |
# Driver > Realtek USB Ethernet
dism.exe /Image:"$ns\reimages\m0unted_w1m" /Add-Driver /Driver:"${RealTek RTL8153}\rtu53cx22x64sta.INF"

# Driver > HIRO PCIe Ethernet (Realtek)
# HIRO PCIe Ethernet NICs require the RealTek drivers otherwise the system will BSoD
dism.exe /Image:"$ns\reimages\m0unted_w1m" /Add-Driver /Driver:"$HIRO\Install_Win11\WIN10\64\rt640x64sta.inf"

# Driver > "Intel PCIe Ethernet Controller Driver"
dism.exe /Image:"$ns\reimages\m0unted_w1m" /Add-Driver /Driver:"$drivers128\drivers\dell\Dell Precision 3460\Intel PCIe Ethernet Controller Driver (2026-05-27)\ext" /Recurse

# Driver > "Intel Ethernet Connection (17) I219-LM"
#dism.exe /Image:"$ns\reimages\m0unted_w1m" /Add-Driver /Driver:"$drivers128\drivers\intel\Ethernet\Server 2025\Wired_driver_29.5_x64\PRO1000\Winx64\WS2025\e1d.inf"

# Driver > Intel Graphics Driver
dism.exe /Image:"$ns\reimages\m0unted_w1m" /Add-Driver /Driver:"$drivers128\drivers\dell\Dell Precision 3460\Intel Graphics Driver (2026-08-10)\ext" /Recurse

# Driver > Intel Graphics
#dism.exe /Image:"$ns\reimages\m0unted_w1m" /Add-Driver /Driver:"$drivers128\drivers\dell\Dell Precision 3460\Intel UHD Graphics" /Recurse

# Driver > Intel HID Event Filter Driver
dism.exe /Image:"$ns\reimages\m0unted_w1m" /Add-Driver /Driver:"$drivers128\drivers\dell\Dell Precision 3460\Intel HID Event Filter Driver (2026-02-05)\ext" /Recurse

# Driver > Intel Innovation Platform Framework and Provider Package Driver
dism.exe /Image:"$ns\reimages\m0unted_w1m" /Add-Driver /Driver:"$drivers128\drivers\dell\Dell Precision 3460\Intel Innovation Platform Framework and Provider Package Driver (2026-07-26)\ext" /Recurse

# Driver > Intel Serial IO Driver
dism.exe /Image:"$ns\reimages\m0unted_w1m" /Add-Driver /Driver:"$drivers128\drivers\dell\Dell Precision 3460\Intel Serial IO Driver (2026-02-12)\ext" /Recurse

# Driver > Intel Rapid Storage Technology
dism.exe /Image:"$ns\reimages\m0unted_w1m" /Add-Driver /Driver:"$drivers128\drivers\dell\Dell Precision 3460\Intel RST" /Recurse

# Intel Management Engine Components Installer
dism.exe /Image:"$ns\reimages\m0unted_w1m" /Add-Driver /Driver:"$drivers128\drivers\dell\Dell Precision 3460\Intel ME Components Installer" /Recurse
#endregion
dism.exe /Unmount-Wim /MountDir:"$ns\reimages\m0unted_w1m" /Commit #  /Discard
#endregion


