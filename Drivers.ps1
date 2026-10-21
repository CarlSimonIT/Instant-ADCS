#Requires -Version 5.1
#Requires -PSEdition Desktop

'https://raw.githubusercontent.com/MicrosoftDocs/SupportArticles-docs/refs/heads/main/support/windows-server/support-tools/scripts-extract-msu-cab-files.md'
'https://raw.githubusercontent.com/CarlSimonIT/SupportArticles-docs/refs/heads/main/support/windows-server/support-tools/scripts-extract-msu-cab-files.md'
function Extract-MSUAndCAB {
  param (
    [Parameter(Mandatory = $true)]
    [string]$filePath,
    [Parameter(Mandatory = $true)]
    [string]$destinationPath
  )

  <# SOURCE |
    start msedge.exe 'https://learn.microsoft.com/en-us/troubleshoot/windows-server/support-tools/scripts-extract-msu-cab-files'
  #>

  # Display the note to the user
  Write-Host "==========================="
  Write-Host
  Write-Host -ForegroundColor Yellow "Note: Do not close any Windows opened by this script until it is completed."
  Write-Host
  Write-Host "==========================="
  Write-Host


  # Remove quotes if present
  $filePath = $filePath -replace '"', ''
  $destinationPath = $destinationPath -replace '"', ''

  # Trim trailing backslash if present
  $destinationPath = $destinationPath.TrimEnd('\')

  if (-not (Test-Path $filePath -PathType Leaf)) {
    Write-Host "The specified file does not exist: $filePath"
    return
  }

  if (-not (Test-Path $destinationPath -PathType Container)) {
    Write-Host "Creating destination directory: $destinationPath"
    New-Item -Path $destinationPath -ItemType Directory | Out-Null
  }

  $processedFiles = @{}

  function Extract-File ($file, $destination) {
    Write-Host "Extracting $file to $destination"
    Start-Process -FilePath "cmd.exe" -ArgumentList "/c expand.exe `"$file`" -f:* `"$destination`" > nul 2>&1" -Wait -WindowStyle Hidden | Out-Null
    $processedFiles[$file] = $true
    Write-Host "Extraction completed for $file"
  }

  function Rename-File ($file) {
    if (Test-Path -Path $file) {
      $newName = [System.IO.Path]::GetFileNameWithoutExtension($file) + "_" + [System.Guid]::NewGuid().ToString("N") + [System.IO.Path]::GetExtension($file)
      $newPath = Join-Path -Path ([System.IO.Path]::GetDirectoryName($file)) -ChildPath $newName
      Write-Host "Renaming $file to $newPath"
      Rename-Item -Path $file -NewName $newPath
      Write-Host "Renamed $file to $newPath"
      return $newPath
    }
    Write-Host "File $file does not exist for renaming"
    return $null
  }

  function Process-CabFiles ($directory) {
    while ($true) {
      $cabFiles = Get-ChildItem -Path $directory -Filter "*.cab" -File | Where-Object { -not $processedFiles[$_.FullName] -and $_.Name -ne "wsusscan.cab" }

      if ($cabFiles.Count -eq 0) {
        Write-Host "No more CAB files found in $directory"
        break
      }

      foreach ($cabFile in $cabFiles) {
        Write-Host "Processing CAB file $($cabFile.FullName)"
        $cabFilePath = Rename-File -file $cabFile.FullName

        if ($cabFilePath -ne $null) {
          Extract-File -file $cabFilePath -destination $directory
          Process-CabFiles -directory $directory
        }
      }
    }
  }

  try {
    # Initial extraction
    if ($filePath.EndsWith(".msu")) {
      Write-Host "Extracting .msu file to: $destinationPath"
      Extract-File -file $filePath -destination $destinationPath
    } elseif ($filePath.EndsWith(".cab")) {
      Write-Host "Extracting .cab file to: $destinationPath"
      Extract-File -file $filePath -destination $destinationPath
    } else {
      Write-Host "The specified file is not a .msu or .cab file: $filePath"
      return
    }

    # Process all .cab files recursively
    Write-Host "Starting to process CAB files in $destinationPath"
    Process-CabFiles -directory $destinationPath
  }
  catch {
    Write-Host "An error occurred while extracting the file. Error: $_"
    return
  }

  Write-Host "Extraction completed. Files are located in $destinationPath"
  return $destinationPath
}

<#
  $CloningRepoPath = "$env:UserProfile\GitHub\InterM3d\mc3\CarlSimonIT"; 
  $CloningRepoFolder = try {Get-Item -Path $CloningRepoPath -ErrorAction 'Stop'} catch {New-Item -Path $CloningRepoPath -ItemType 'Directory' -Force}; 
  Set-Location -Path "$CloningRepoFolder"
  Set-ExecutionPolicy -ExecutionPolicy 'RemoteSigned' -Scope 'Process' -Force; 
  $HT = @{EmailAddressOfBitwardenAccount = 'pwdsec3@gmail.com'; 'Folder Fully Qualified Name' = 'Instant-ADCS'; BadPassword = 'BadPassword!'; 'NetBIOS Name of Root Domain in AD Forest' = 'BeefBurito'; 'DNS Name of Root Domain in AD Forest' = 'ad.Chicken-Salad.INTERNAL'}; & '.\Instant-ADCS\Start.ps1' @HT; Set-Location -Path 'C:\'; 
  (Get-Job).Where({$_.State -ne 'Running'}) | Remove-Job; Get-Job | Format-Table -AutoSize

  Set-ExecutionPolicy -ExecutionPolicy 'RemoteSigned' -Scope 'Process' -Force; 
  $CloningRepoPath = "$env:UserProfile\GitHub\InterM3d\mc3\CarlSimonIT"; 
  $CloningRepoFolder = try {Get-Item -Path $CloningRepoPath -ErrorAction 'Stop'} catch {New-Item -Path $CloningRepoPath -ItemType 'Directory' -Force}; 
  Set-Location -Path "$CloningRepoFolder"; Set-ExecutionPolicy -ExecutionPolicy 'RemoteSigned' -Scope 'Process' -Force; 
  & '.\Instant-ADCS\Drivers.ps1'; 
  Set-Location -Path 'C:\'; (Get-Job).Where({$_.State -ne 'Running'}) | Remove-Job; Get-Job | Format-Table -AutoSize; 
#>


${Intermediary Partial Path} = 'InterM3d\mc3'
${explorer.exe Owner} = 'lowpr'
$CloningRepoFolder = Get-Item -Path "$env:SystemDrive\Users\${explorer.exe Owner}\GitHub\${Intermediary Partial Path}\CarlSimonIT"
#Set-Location -Path "$CloningRepoFolder"
[System.Environment]::SetEnvironmentVariable('.CommonItems',"$CloningRepoFolder\.CommonItems")
$FolderFQN = Import-CliXml -Path "${env:.CommonItems}\FolderFQN.clixml"
# & ".\$FolderFQN\Drivers.ps1"
. "$CloningRepoFolder\$FolderFQN\output\$FolderFQN\usb1\$FolderFQN\Base\5.1\External Bootable Media Drive Letters.ps1"

<# pnputil.exe /? |
  PNPUTIL [
    /add-driver <...> | 
    /delete-driver <...> | 
    /export-driver <...> | 
    /enum-drivers [<...>] | 
    /enum-devices [<...>] | 
    /enum-devicetree [<...>] | 
    /disable-device <...> | 
    /enable-device <...> | 
    /restart-device <...> | 
    /remove-device <...> | 
    /scan-devices [<...>] | 
    /enum-classes [<...>] | 
    /enum-interfaces [<...>] | 
    /enum-containers [<...>] | 
    /?
  ]

  Commands:
    /add-driver <filename.inf | *.inf> [/subdirs] [/install] [/reboot]

      Add driver package(s) into the driver store.
        /subdirs - traverse sub directories for driver packages.
        /install - install/update drivers on any matching devices.
        /reboot - reboot system if needed to complete the operation.

      Examples:
        Add driver package:
          pnputil /add-driver x:\driver.inf
        Add multiple driver packages:
          pnputil /add-driver c:\oem\*.inf
        Add and install driver package:
          pnputil /add-driver device.inf /install

    /delete-driver <oem#.inf> [/uninstall] [/force] [/reboot]

      Delete driver package from the driver store.
        /uninstall - uninstall driver package from any devices using it.
        /force - delete driver package even when it is in use by devices.
        /reboot - reboot system if needed to complete the operation.

      Examples:
        Delete driver package:
          pnputil /delete-driver oem0.inf
        Force delete driver package:
          pnputil /delete-driver oem1.inf /force

    /export-driver <oem#.inf | *> <target directory>

      Export driver package(s) from the driver store into a target directory.

      Examples:
        Export driver package:
          pnputil /export-driver oem6.inf .
        Export all driver packages:
          pnputil /export-driver * c:\backup

    /enum-drivers [/class <name | GUID>] [/files] [/ids] [/devices]
                  [/format <txt | xml | csv>] [/output-file [<filename>]]

      Enumerate all 3rd party driver packages in the driver store.
        /class <name | GUID> - filter by driver class name or GUID.
        /files - enumerate all driver package files.
        /ids - display driver package and family IDs.
        /devices - display devices with driver package installed.
        /format - format output as text, XML, or CSV.
        /output-file [<filename>] - write output to optional filename.

      Examples:
        Enumerate all OEM driver packages:
          pnputil /enum-drivers
        Enumerate all OEM driver packages of a specific class:
          pnputil /enum-drivers /class "System"
        Enumerate all OEM driver packages and show driver files:
          pnputil /enum-drivers /files

    /disable-device [<instance ID> | /deviceid <device ID>] [/class <name | GUID>]
                    [/bus <name | GUID>] [/reboot] [/force]

      Disable devices on the system.
        /deviceid <device ID> - disable all devices with matching device ID.
        /class <name | GUID> - filter by device class name or GUID.
        /bus <name | GUID> - filter by bus enumerator name or bus type GUID.
        /reboot - reboot system if needed to complete the operation.
        /force - disable even if device provides critical system functionality.

      Examples:
        Disable device:
          pnputil /disable-device "USB\VID_045E&PID_00DB\6&870CE29&0&1"
        Disable all devices with specific hardware/compatible ID:
          pnputil /disable-device /deviceid "USB\Class_03"
        Disable all devices of a specific class on a specific bus:
          pnputil /disable-device /class "USB" /bus "PCI"

    /enable-device [<instance ID> | /deviceid <device ID>] [/class <name | GUID>]
                  [/bus <name | GUID>] [/reboot]

      Enable devices on the system.
        /deviceid <device ID> - enable all devices with matching device ID.
        /class <name | GUID> - filter by device class name or GUID.
        /bus <name | GUID> - filter by bus enumerator name or bus type GUID.
        /reboot - reboot system if needed to complete the operation.

      Examples:
        Enable device:
          pnputil /enable-device "USB\VID_045E&PID_00DB\6&870CE29&0&1"
        Enable all devices with specific hardware/compatible ID:
          pnputil /enable-device /deviceid "USB\Class_03"
        Enable all devices of a specific class on a specific bus:
          pnputil /enable-device /class "USB" /bus "PCI"

    /restart-device [<instance ID> | /deviceid <device ID>] [/class <name | GUID>]
                    [/bus <name | GUID>] [/reboot]

      Restart devices on the system.
        /deviceid <device ID> - restart all devices with matching device ID.
        /class <name | GUID> - filter by device class name or GUID.
        /bus <name | GUID> - filter by bus enumerator name or bus type GUID.
        /reboot - reboot system if needed to complete the operation.

      Examples:
        Restart device:
          pnputil /restart-device "USB\VID_045E&PID_00DB\6&870CE29&0&1"
        Restart all devices with specific hardware/compatible ID:
          pnputil /restart-device /deviceid "USB\Class_03"
        Restart all devices of a specific class on a specific bus:
          pnputil /restart-device /class "USB" /bus "PCI"

    /remove-device [<instance ID> | /deviceid <device ID>] [/class <name | GUID>]
                  [/bus <name | GUID>] [/subtree] [/reboot] [/force]

      Attempt to remove a device from the system.
        /deviceid <device ID> - remove all devices with matching device ID.
        /class <name | GUID> - filter by device class name or GUID.
        /bus <name | GUID> - filter by bus enumerator name or bus type GUID.
        /subtree - remove entire device subtree, including any child devices.
        /reboot - reboot system if needed to complete the operation.
        /force - remove even if device provides critical system functionality.

      Examples:
        Remove device:
          pnputil /remove-device "USB\VID_045E&PID_00DB\6&870CE29&0&1"
        Remove all devices with specific hardware/compatible ID:
          pnputil /remove-device /deviceid "USB\Class_03"
        Remove all devices of a specific class on a specific bus:
          pnputil /remove-device /class "USB" /bus "PCI"

    /scan-devices [/instanceid <instance ID>] [/async]

      Scan the system for any device hardware changes.
        /instanceid <instance ID> - scan device subtree for changes.
        /async - scan for changes asynchronously.

      Examples:
        Scan devices:
          pnputil /scan-devices

    /enum-devices [/connected | /disconnected] [/class <name | GUID>]
                  [/instanceid <instance ID> | /deviceid <device ID>]
                  [/problem [<code>]] [/bus [<name | GUID>]] [/deviceids]
                  [/relations] [/services] [/stack] [/location] [/drivers]
                  [/interfaces] [/properties] [/resources]
                  [/format <txt | xml | csv>] [/output-file [<filename>]]

      Enumerate all devices on the system.
        /connected | /disconnected - filter by connected devices or
                                    filter by disconnected devices.
        /class <name | GUID> - filter by device class name or GUID.
        /instanceid <instance ID> - filter by device instance ID.
        /deviceid <device ID> - filter by device hardware/compatible ID.
        /problem [<code>] - filter by devices with problems or
                            filter by specific problem code.
        /bus [<name | GUID>] - display bus enumerator name and bus type GUID or
                              filter by bus enumerator name or bus type GUID.
        /deviceids - display hardware/compatible IDs.
        /relations - display parent and child device relations.
        /services - display device services.
        /stack - display effective device stack information.
        /location - display location information and paths.
        /drivers - display matching and installed drivers.
        /interfaces - display device interfaces.
        /properties - display all device properties.
        /resources - display device resources.
        /format - format output as text, XML, or CSV.
        /output-file [<filename>] - write output to optional filename.

      Examples:
        Enumerate only connected devices on the system:
          pnputil /enum-devices /connected
        Enumerate device with specific instance ID:
          pnputil /enum-devices /instanceid "ACPI\PNP0A08\1"
        Enumerate all devices with specific hardware/compatible ID:
          pnputil /enum-devices /deviceid "USB\Class_03"
        Enumerate all devices with specific class:
          pnputil /enum-devices /class Display
          pnputil /enum-devices /class {4d36e97d-e325-11ce-bfc1-08002be10318}
        Enumerate all devices with specific problem code:
          pnputil /enum-devices /problem 28
          pnputil /enum-devices /problem 0xA
        Enumerate all devices with specific bus:
          pnputil /enum-devices /bus PCI
          pnputil /enum-devices /bus {c8ebdfb0-b510-11d0-80e5-00a0c92542e3}
        Enumerate all devices with problems and display hardware/compatible IDs:
          pnputil /enum-devices /problem /deviceids

    /enum-interfaces [/enabled | /disabled] [/class <GUID>] [/instanceid <instance ID>]
                    [/properties] [/format <txt | xml | csv>] [/output-file [<filename>]]

      Enumerate all device interfaces on the system.
        /enabled | /disabled - filter by enabled interfaces or
                              filter by disabled interfaces.
        /class <GUID> - filter by interface class GUID.
        /instanceid <instance ID> - filter by device instance ID.
        /properties - display all interface properties.
        /format - format output as text, XML, or CSV.
        /output-file [<filename>] - write output to optional filename.

      Examples:
        Enumerate only enabled interfaces on the system:
          pnputil /enum-interfaces /enabled
        Enumerate all interfaces with specific interface class GUID:
          pnputil /enum-interfaces /class {884b96c3-56ef-11d1-bc8c-00a0c91405dd}

    /enum-classes [/class <name | GUID>] [/services] [/format <txt | xml | csv>]
                  [/output-file [<filename>]]

      Enumerate all device setup classes on the system.
        /class <name | GUID> - filter by device class name or GUID.
        /services - display device class services.
        /format - format output as text, XML, or CSV.
        /output-file [<filename>] - write output to optional filename.

      Examples:
        Enumerate all device setup classes on the system:
          pnputil /enum-classes
        Enumerate information for a specific device setup class:
          pnputil /enum-classes /class Display
          pnputil /enum-classes /class {4d36e968-e325-11ce-bfc1-08002be10318}

      /enum-devicetree [root device instance ID] [/connected] [/services]
                      [/stack] [/drivers] [/interfaces]

      Enumerate the device tree.
        /connected - filter by connected devices.
        /services - display device services.
        /stack - display effective device stack information.
        /drivers - display matching and installed drivers.
        /interfaces - display device interfaces.

      Examples:
        Enumerate device tree:
          pnputil /enum-devicetree
        Enumerate device tree with "ACPI\PNP0A03\0" as root:
          pnputil /enum-devicetree "ACPI\PNP0A03\0"
        Enumerate tree of connected devices and display device interfaces:
          pnputil /enum-devicetree /connected /interfaces

      /enum-containers [/containerid <container id>] [/connected | /disconnected]
                      [/problem] [/devices] [/format <txt | xml | csv>]
                      [/output-file [<filename>]]

      Enumerate all device containers on the system.
        /containerid <container id> - filter by container ID.
        /connected | /disconnected - filter by connected device containers or
                                    filter by disconnected device containers.
        /problem - filter by device containers with problems.
        /devices - display container devices.
        /format - format output as text, XML, or CSV.
        /output-file [<filename>] - write output to optional filename.

      Examples:
        Enumerate all device containers on the system:
          pnputil /enum-containers
        Enumerate specific device container:
          pnputil /enum-containers /containerid "{00000000-0000-0000-ffff-ffffffffffff}"
        Enumerate all connected device containers and associated devices:
          pnputil /enum-containers /connected /devices

    /?

      Show usage screen.
#>

${OSDeploy Disk CIM Instance} = Get-Disk | Where-Object -FilterScript {
  $_.FriendlyName -eq    ${OSDeploy FriendlyName}                                             -and `
  $_.UniqueId     -match [System.Text.RegularExpressions.Regex]::Escape(${OSDeploy UniqueId}) -and `
  $_.SerialNumber -eq    ${OSDeploy SerialNumber}
}
${WinPE Volume} = ${OSDeploy Disk CIM Instance} | Get-Partition | Where-Object -FilterScript {$_.Type -eq 'FAT32 XINT13'} | Get-Volume
${Server25 Volume} = ${OSDeploy Disk CIM Instance} | Get-Partition | Where-Object -FilterScript {$_.Type -eq 'IFS'} | Get-Volume
${WinPE Volume Root} = [System.String]${WinPE Volume}.DriveLetter + ':'
${Server25 Volume Root} = [System.String]${Server25 Volume}.DriveLetter + ':'

#region | Micro Center 128GB Disk Orange |
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

#endregion

#${WinPE .cab File} = Get-Item -Path "$drivers128\drivers\dell\Dell Precision 3460\Dell Command Deploy WinPE 11.0 Driver Pack\WinPE11.0-Drivers-A11-KHF4P.cab"
${WinPE .cab File} = Get-Item -Path "${env:.CommonItems}\WinPE\cab\WinPE11.0-Drivers-A11-KHF4P.cab"


# HP WinPE driver pack
start msedge.exe 'https://ftp.ext.hp.com/pub/caps-softpaq/cmit/HP_WinPE_DriverPack.html'

#region | WinPE11.0-Drivers-A11-KHF4P |
${DISM Folder} = Get-Item -Path "${env:ProgramFiles(x86)}\Windows Kits\10\Assessment and Deployment Kit\Deployment Tools\amd64\DISM"
${UFD boot.wim File} = Get-Item -Path "${WinPE Volume Root}\sources\boot.wim"
. "${DISM Folder}\dism.exe" /Get-ImageInfo /ImageFile:"${UFD boot.wim File}" /Index:1
$path = "${env:.CommonItems}\WinPE\zzWhoWhatWhen"; ${MountedWIM folder} = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
. "${DISM Folder}\dism.exe" /Mount-Wim /WimFile:"${UFD boot.wim File}" /Index:1 /MountDir:"${MountedWIM folder}"

Set-ItemProperty -Path "$folder\sources\boot.wim" -Name 'IsReadOnly' -Value $false # Disable the ReadOnly attribute on the install.wim object

$path = "${env:.CommonItems}\WinPE\Extracted CAB"; ${Extracted CAB folder} = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
$InputHT = @{
  FilePath        = "${WinPE .cab File}"
  DestinationPath = "${Extracted CAB folder}"
}
Extract-MSUAndCAB @InputHT

. "${DISM Folder}\dism.exe" /Add-Driver /Image:"${MountedWIM folder}" /Driver:"${Extracted CAB folder}" /Recurse

# Dism.exe /Image:"$ns\reimages\m0un7ed_wlm" /Add-Package /PackagePath:$PackageDirectory
dism.exe /Unmount-Wim /MountDir:"${MountedWIM folder}" /Commit
dism.exe /Unmount-Wim /MountDir:"${MountedWIM folder}" /Discard

${WinPE Volume Root}
#endregion

#region | Download and execute 'Extract-MSUAndCAB.ps1' script to expand .msu/.cab files |
${Extract-MSUAndCAB.ps1 File} = [System.IO.FileInfo]"$PSScriptRoot\output\$FolderFQN\usb1\$FolderFQN\Base\5.1\Extract-MSUAndCAB.ps1"
. "${Extract-MSUAndCAB.ps1 File}"

$InputHT = @{
  FilePath        = "${WinPE .cab File}"
  DestinationPath = "${Extracted CAB folder}"
}
& "$PSScriptRoot\output\$FolderFQN\usb1\$FolderFQN\Base\5.1\Extract-MSUAndCAB.ps1" @InputHT
#endregion




























