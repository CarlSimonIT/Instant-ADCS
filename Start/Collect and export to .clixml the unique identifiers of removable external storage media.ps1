#Requires -Version 5.1
#Requires -PSEdition Desktop

""
${External Storage Media Here-String} = @'
  Read all subsequent steps before pressing Enter to continue: 

  1. Insert removable external storage media. 
  2. Launch another instance of Windows PowerShell. 
  3. Execute the code below in that newly created session to view 
     details of removable external storage drives that are not also
     bootable media: 

       Get-Disk `
       | Where-Object -PipelineVariable 'Disk' -FilterScript {
         $_.BusType           -eq 'USB'     -and `
         $_.OperationalStatus -eq 'Online'  -and `
         $_.HealthStatus      -eq 'Healthy'
       } `
       | ForEach-Object -Process {
         Get-Partition -DiskNumber $Disk.Number `
         | Where-Object -PipelineVariable 'Partition' -FilterScript {
           $_.Type              -match 'Basic|IFS'   -and `
           $_.OperationalStatus -eq    'Online'      -and `
           $null                -ne    'DriveLetter'
         } `
         | ForEach-Object -Process {
           Get-Volume -Partition ($Partition) `
           | Where-Object -PipelineVariable 'Volume' -FilterScript {
             $_.FileSystemType -eq 'NTFS'
           } `
           | ForEach-Object -Process {
             if (-not (Test-Path -Path "$($Volume.DriveLetter):\setup.exe")) {
               Write-Host -Object "DriveLetter = $($Volume.DriveLetter)"
               Write-Host -Object "  Disk FriendlyName = '$($Disk.FriendlyName)'"
               Write-Host -Object "  Disk UniqueId Raw = '$($Disk.UniqueId)'"
               Write-Host -Object "  Disk SerialNumber = '$($Disk.SerialNumber)'`n"
             }
           }
         }
       }

  4. Copy & paste the results into Notepad. 
  5. Return to this original instance of Windows PowerShell and hit Enter.

'@
""
Write-Host -Object ${External Storage Media Here-String} -ForegroundColor ([System.ConsoleColor]::Blue)
pause

${External Storage Media Note Preamble Here-String} = -join $(
  "`n"
  "  * usb0 will hold application installation files + OS images in .iso format.`n"
  "  * usb1 will hold DSC data and Windows PowerShell scripts.`n"
  "`n"
  "  Decide which external removable non-bootable storage drive will be 'usb0' and which`n"
  "  will be 'usb1' before pressing Enter to continue.`n"
  "`n"
)
Write-Host -Object ${External Storage Media Note Preamble Here-String} -ForegroundColor ([System.ConsoleColor]::Cyan)
pause

${External Storage Media Note Here-String} = -join $(
  "`n"
  "  Copy + paste the corresponding strings written into Notepad. `n"
  "  Be sure to include the entire displayed value, including single quotes and space characters. `n"
  "  For example: `n"
  "    PS> usb0 FriendlyName: $([System.Char]39)WD My Passport 259F$([System.Char]39)`n"
  "    PS> usb0 SerialNumber: $([System.Char]39)WXV1E651JMYD    $([System.Char]39)`n"
  "    PS> usb1 UniqueId Raw: $([System.Char]39) USB$([System.Char]39)`n"
  "`n"
)
Write-Host -Object ${External Storage Media Note Here-String} -ForegroundColor ([System.ConsoleColor]::Cyan)