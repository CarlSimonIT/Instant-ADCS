#Requires -Version 5.1
#Requires -PSEdition Desktop

# Re-establish this soon ---->    Set-StrictMode -Version 'Latest'

<# Announcements! |
  VBScript is undergoing deprecation:
  start msedge.exe 'https://techcommunity.microsoft.com/blog/windows-itpro-blog/vbscript-deprecation-timelines-and-next-steps/4148301'

  Guide for converting code from VBScript to Windows PowerShell:  
  start msedge.exe 'https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-powershell-1.0/ee221101(v=msdn.10)'
#>

#region |  |
$error.Clear()

$FolderFQN = Import-CliXml -Path "$PSScriptRoot\..\..\..\.CommonItems\FolderFQN.clixml"
. "$PSScriptRoot\..\..\output\$FolderFQN\usb1\$FolderFQN\Base\5.1\External Bootable Media Drive Letters.ps1"
. "$PSScriptRoot\..\..\output\$FolderFQN\usb1\$FolderFQN\Base\5.1\External Storage Media Drive Letters.ps1"
. "$PSScriptRoot\..\..\output\$FolderFQN\usb1\$FolderFQN\Base\5.1\Computer Info Lite.ps1"
. "$PSScriptRoot\..\..\output\$FolderFQN\usb1\$FolderFQN\Base\5.1\Location - Culture - Geography.ps1"
#. "$PSScriptRoot\..\..\output\$FolderFQN\usb1\$FolderFQN\Base\5.1\Type Accelerator Instance.ps1"
#. "$PSScriptRoot\..\..\output\$FolderFQN\usb1\$FolderFQN\Base\5.1\Class Definitions\Quick Management Cname Conversions.ps1"
. "$PSScriptRoot\..\..\output\$FolderFQN\usb1\$FolderFQN\Base\5.1\Class Definitions\Windows Server Image Index.ps1"
. "$PSScriptRoot\..\..\output\$FolderFQN\usb1\$FolderFQN\Base\5.1\Constants for Organization Naming that are not directly related to IT operations.ps1"
$__DirectoryForDscConfigs = Import-CliXml -Path "$PSScriptRoot\..\..\..\.CommonItems\__DirectoryForDscConfigs.clixml"

${AdHocCertsDsc Version} = '0.0.2'
${AdHocNetsDsc Version}  = '0.0.2'
${AdHocPkiDsc Version}   = '0.0.2'
${AdHocUtilsDsc Version} = '0.0.2'
#endregion

#region | Node-Specific Variables | Temporary File | XML Writer Settings |
$CliXmlFile = Get-ChildItem -Path "$PSScriptRoot\..\..\..\.CommonItems\Variables *.clixml" | Sort-Object | Select-Object -Last 1
$VariableHT = Import-CliXml -Path $CliXmlFile.FullName
$ConfigTargetCname = $VariableHT['DSC Authoring Station Mgmt Cname']
$UserName = 'HyperV OS Deploy'
$DisplayName = 'Hyper-V Local Administrator'
$Description = 'Local administrator for local interactive logon sessions'
$ClearPw = Get-StoredCredential -Target $UserName -AsCredentialObject | Select-Object -ExpandProperty 'Password'
$AdjustedClearPw = $ClearPw + "Password"
$PwBytes = [System.Text.Encoding]::Unicode.GetBytes($AdjustedClearPw)
$EncodedPw = [System.Convert]::ToBase64String($PwBytes)

#${Windows Server Image Index-XML} = [WindowsServerImageIndex]::DatacenterDesktopExperience
${Windows Server Image Index-XML} = [System.Int32][WindowsServerImageIndex]::DatacenterDesktopExperience
${offlineImage Xml Element OS Edition Code} = [System.Int32]${Windows Server Image Index-XML}

${offlineImage cpi source} = "wim:c:/users/$(($UserName -replace ' ',$([System.Char]37 + ('{0:x}' -f [System.Int32][System.Char]' '))).ToLower())/install.wim$([System.Char]35)Windows Server 2025 ${offlineImage Xml Element OS Edition Code}"

$wcmNamespaceUrl = 'http://schemas.microsoft.com/WMIConfig/2002/State'

# Temporary File
$file = New-TemporaryFile
$XmlFile = Rename-Item -Path "$file" -NewName $($file.BaseName + '.xml') -PassThru

# XML Writer Settings
$XmlWriterSettings = [System.Xml.XmlWriterSettings]::New()
$XmlWriterSettings.Indent = $true
$XmlWriter = [System.Xml.XmlWriter]::Create($XmlFile.FullName,$XmlWriterSettings)
#endregion

#region | XML Writer |
$XmlWriter.WriteStartDocument()
  $XmlWriter.WriteStartElement('unattend','urn:schemas-microsoft-com:unattend')

  #region | settings |
    #region | settings | pass = windowsPE |
    $XmlWriter.WriteStartElement('settings')
      $XmlWriter.WriteAttributeString('pass','windowsPE')

      #region | settings | pass = windowsPE | component | name = Microsoft-Windows-International-Core-WinPE |
      $XmlWriter.WriteStartElement('component')
        $XmlWriter.WriteAttributeString('name','Microsoft-Windows-International-Core-WinPE')
        $XmlWriter.WriteAttributeString('processorArchitecture','amd64')
        $XmlWriter.WriteAttributeString('publicKeyToken','31bf3856ad364e35')
        $XmlWriter.WriteAttributeString('language','neutral')
        $XmlWriter.WriteAttributeString('versionScope','nonSxS')
        $XmlWriter.WriteAttributeString("xmlns","wcm", $null,"http://schemas.microsoft.com/WMIConfig/2002/State")
        $XmlWriter.WriteAttributeString("xmlns","xsi", $null,"http://www.w3.org/2001/XMLSchema-instance")
        $XmlWriter.WriteStartElement('SetupUILanguage')
          $XmlWriter.WriteElementString('UILanguage',${SetupUILanguage-UILanguage})
        $XmlWriter.WriteEndElement()
        $XmlWriter.WriteElementString('InputLocale',${InputLocale})
        $XmlWriter.WriteElementString('SystemLocale',${SystemLocale})
        $XmlWriter.WriteElementString('UILanguage',${UILanguage})
        $XmlWriter.WriteElementString('UserLocale',${UserLocale})
      $XmlWriter.WriteEndElement()
      #endregion

      #region | settings | pass = windowsPE | component | name = Microsoft-Windows-Setup |
      $XmlWriter.WriteStartElement('component')
        $XmlWriter.WriteAttributeString('name','Microsoft-Windows-Setup')
        $XmlWriter.WriteAttributeString('processorArchitecture','amd64')
        $XmlWriter.WriteAttributeString('publicKeyToken','31bf3856ad364e35')
        $XmlWriter.WriteAttributeString('language','neutral')
        $XmlWriter.WriteAttributeString('versionScope','nonSxS')
        $XmlWriter.WriteAttributeString("xmlns","wcm", $null,"http://schemas.microsoft.com/WMIConfig/2002/State")
        $XmlWriter.WriteAttributeString("xmlns","xsi", $null,"http://www.w3.org/2001/XMLSchema-instance")

        $XmlWriter.WriteStartElement('ImageInstall')
          $XmlWriter.WriteStartElement('OSImage')
            $XmlWriter.WriteStartElement('InstallTo')
              $XmlWriter.WriteElementString('DiskID',"0")
              $XmlWriter.WriteElementString('PartitionID',"3")
            $XmlWriter.WriteEndElement()
            $XmlWriter.WriteStartElement('InstallFrom')
              $XmlWriter.WriteStartElement('MetaData')
                $XmlWriter.WriteElementString('Key',"/Image/Index")
                $XmlWriter.WriteElementString('Value',${Windows Server Image Index-XML})
              $XmlWriter.WriteEndElement()
            $XmlWriter.WriteEndElement()
          $XmlWriter.WriteEndElement()
        $XmlWriter.WriteEndElement()

        $XmlWriter.WriteStartElement('UserData')
          $XmlWriter.WriteStartElement('ProductKey')
            $XmlWriter.WriteElementString('Key','D764K-2NDRG-47T6Q-P8T8W-YP6DF')
            $XmlWriter.WriteEndElement()
          $XmlWriter.WriteElementString('AcceptEula','true')
        $XmlWriter.WriteEndElement()

        #region | Disk 0 | Primary Hard Drive | Disk has boot partition | WITH Disk Assertions |
        <#
          $XmlWriter.WriteStartElement('RunSynchr0nous')
            $XmlWriter.WriteStartElement('RunSynchronousCommand')
              $XmlWriter.WriteElementString('Order','%_Order_Index_%')
              $XmlWriter.WriteComment("Copied almost entirely word-for-word from the online autounattend.xml generator by schneegans.de")
              $XmlWriter.WriteElementString('Description',"Define the X:\pe.cmd file")
              $XmlWriter.WriteElementString('Path',$(
                -join @(
                  'cmd.exe /c '
                  ">>X:pe.cmd "
                  [System.Char]40
                  "echo:@echo off"
                  "&echo:all "
                  ":print ^$([System.Char]34)Setting keyboard layout for PE session^$([System.Char]34)"
                  "&echo:wpeutil.exe SetKeyboardLayout ${InputLocale}"
                  "&echo:for^%^%d in "
                  ""
                  ""
                  ""
                  ""
                  [System.Char]41
                  " do ()"
                )
              ))
            $XmlWriter.WriteEndElement()

            $XmlWriter.WriteStartElement('RunSynchronousCommand')
              $XmlWriter.WriteElementString('Order','%_Order_Index_%')
              $XmlWriter.WriteComment("Max length of $([System.Char]39)Description$([System.Char]39) element is 250 characters")
              $XmlWriter.WriteElementString('Description',"")
              $XmlWriter.WriteElementString('Path',$(
                -join @(
                  'cmd.exe /c '
                  ">>X:pe.cmd "
                  [System.Char]40
                  "echo:"
                  ""
                  ""
                  ""
                  [System.Char]41
                )
              ))
            $XmlWriter.WriteEndElement()

            $XmlWriter.WriteStartElement('RunSynchronousCommand')
              $XmlWriter.WriteElementString('Order','%_Order_Index_%')
              $XmlWriter.WriteComment("No Comment")
              $XmlWriter.WriteElementString('Description',"")
              $XmlWriter.WriteElementString('Path',$(
                -join @(
                  'cmd.exe /c '
                  ">>X:pe.cmd "
                  [System.Char]40
                  "echo:"
                  ""
                  ""
                  ""
                  ""
                  [System.Char]41
                )
              ))
            $XmlWriter.WriteEndElement()

            $XmlWriter.WriteStartElement('RunSynchronousCommand')
              $XmlWriter.WriteElementString('Order','%_Order_Index_%')
              $XmlWriter.WriteComment("No Comment")
              $XmlWriter.WriteElementString('Description',"")
              $XmlWriter.WriteElementString('Path',$(
                -join @(
                  'cmd.exe /c '
                  ">>X:pe.cmd "
                  [System.Char]40
                  "echo:"
                  ""
                  ""
                  ""
                  ""
                  [System.Char]41
                )
              ))
            $XmlWriter.WriteEndElement()
          $XmlWriter.WriteEndElement()
        #>
        #endregion

        #region | Disk 0 | Primary Hard Drive | Disk has boot partition | WITHOUT Disk Assertions |
        $XmlWriter.WriteStartElement('RunSynchronous')
          $XmlWriter.WriteStartElement('RunSynchronousCommand')
            $XmlWriter.WriteElementString('Order','%_Order_Index_%')
            $XmlWriter.WriteComment("Added a new RunSynchronousCommand element. This is a comment.")
            $XmlWriter.WriteElementString('Description',"Added a new RunSynchronousCommand element. this is a Description")
            $XmlWriter.WriteElementString('Path',$(
              -join @(
                'powershell.exe '
                "-WindowStyle $([System.Char]34)Maximized$([System.Char]34) "
                '-NoProfile '
                '-Command '
                [System.Char]34
                "Get-ChildItem; pause"
                [System.Char]34
              )
            ))
          $XmlWriter.WriteEndElement()

          $XmlWriter.WriteStartElement('RunSynchronousCommand')
            $XmlWriter.WriteElementString('Order','%_Order_Index_%')
            $XmlWriter.WriteComment("Max length of $([System.Char]39)Description$([System.Char]39) element is 250 characters")
            $XmlWriter.WriteElementString('Description',"New diskpart.txt file in root of WindowsPE. Contents are DISKPART commands. Clean disk 0, GPT partition table style")
            $XmlWriter.WriteElementString('Path',$(
              -join @(
                'cmd.exe /c '
                [System.Char]34
                ">>$([System.Char]34)X:\diskpart.txt$([System.Char]34) "
                [System.Char]40
                "echo SELECT DISK=0"
                "&echo CLEAN"
                "&echo CONVERT GPT"
                [System.Char]41
                [System.Char]34
              )
            ))
          $XmlWriter.WriteEndElement()

          $XmlWriter.WriteStartElement('RunSynchronousCommand')
            $XmlWriter.WriteElementString('Order','%_Order_Index_%')
            $XmlWriter.WriteElementString('Description',"Partition for the EFI system. FAT32 volume labeled System")
            $XmlWriter.WriteElementString('Path',$(
              -join @(
                'cmd.exe /c '
                [System.Char]34
                ">>$([System.Char]34)X:\diskpart.txt$([System.Char]34) "
                [System.Char]40
                "echo CREATE PARTITION EFI SIZE=314"
                "&echo FORMAT QUICK FS=FAT32 LABEL=$([System.Char]34)System$([System.Char]34)"
                [System.Char]41
                [System.Char]34
              )
            ))
          $XmlWriter.WriteEndElement()

          $XmlWriter.WriteStartElement('RunSynchronousCommand')
            $XmlWriter.WriteElementString('Order','%_Order_Index_%')
            $XmlWriter.WriteElementString('Description',"MSR (Microsoft Reserved) partition. No fs format, no volume label. The size of the MSR is 16MB")
            $XmlWriter.WriteElementString('Path',$(
              -join @(
                'cmd.exe /c '
                [System.Char]34
                ">>$([System.Char]34)X:\diskpart.txt$([System.Char]34) "
                [System.Char]40
                "echo CREATE PARTITION MSR SIZE=20"
                [System.Char]41
                [System.Char]34
              )
            ))
          $XmlWriter.WriteEndElement()

          $XmlWriter.WriteStartElement('RunSynchronousCommand')
            $XmlWriter.WriteElementString('Order','%_Order_Index_%')
            $XmlWriter.WriteElementString('Description',"Partition for bare-metal deployment of Windows Server. Leave some room for the Recovery partition")
            $XmlWriter.WriteElementString('Path',$(
              -join @(
                'cmd.exe /c '
                [System.Char]34
                ">>$([System.Char]34)X:\diskpart.txt$([System.Char]34) "
                [System.Char]40
                "echo CREATE PARTITION PRIMARY"
                "&echo SHRINK MINIMUM=888"
                "&echo FORMAT QUICK FS=NTFS LABEL=$([System.Char]34)LocalOS$([System.Char]34)"
                [System.Char]41
                [System.Char]34
              )
            ))
          $XmlWriter.WriteEndElement()

          $XmlWriter.WriteStartElement('RunSynchronousCommand')
            $XmlWriter.WriteElementString('Order','%_Order_Index_%')
            $XmlWriter.WriteElementString('Description',"Partition holding Recovery tools. Must set the GPT Type ID. I dont know what GPT ATTRIBUTES are...")
            $XmlWriter.WriteElementString('Path',$(
              -join @(
                'cmd.exe /c '
                [System.Char]34
                ">>$([System.Char]34)X:\diskpart.txt$([System.Char]34) "
                [System.Char]40
                "echo CREATE PARTITION PRIMARY"
                "&echo FORMAT QUICK FS=NTFS LABEL=$([System.Char]34)Recovery$([System.Char]34)"
                "&echo SET ID=$([System.Char]34)DE94BBA4-06D1-4D40-A16A-BFD50179D6AC$([System.Char]34)"
                "&echo GPT ATTRIBUTES=0x8000000000000001"
                [System.Char]41
                [System.Char]34
              )
            ))
          $XmlWriter.WriteEndElement()

          $XmlWriter.WriteStartElement('RunSynchronousCommand')
            $XmlWriter.WriteElementString('Order','%_Order_Index_%')
            $XmlWriter.WriteElementString('Description',"Execution of the commands within diskpart.txt by diskpart.exe")
            $XmlWriter.WriteElementString('Path',$(
              -join @(
                'cmd.exe /c '
                [System.Char]34
                "diskpart.exe /s "
                "$([System.Char]34)X:\diskpart.txt$([System.Char]34) "
                ">>$([System.Char]34)X:\diskpart.log$([System.Char]34) "
                "|| "
                [System.Char]40
                " type $([System.Char]34)X:\diskpart.log$([System.Char]34) "
                "& echo diskpart encountered an error. & pause & exit /b 1 "
                [System.Char]41
                [System.Char]34
              )
            ))
          $XmlWriter.WriteEndElement()
        $XmlWriter.WriteEndElement()
        #endregion

        $XmlWriter.WriteElementString('UseConfigurationSet','false')
      $XmlWriter.WriteEndElement()
    #endregion

    $XmlWriter.WriteEndElement()
    #endregion
    
    #region | settings | pass = specialize |
    $XmlWriter.WriteStartElement('settings')
      $XmlWriter.WriteAttributeString('pass','specialize')

      #region | settings | pass = specialize | component | name = Microsoft-Windows-Deployment |
      $XmlWriter.WriteStartElement('component')
        $XmlWriter.WriteAttributeString('name','Microsoft-Windows-Deployment')
        $XmlWriter.WriteAttributeString('processorArchitecture','amd64')
        $XmlWriter.WriteAttributeString('publicKeyToken','31bf3856ad364e35')
        $XmlWriter.WriteAttributeString('language','neutral')
        $XmlWriter.WriteAttributeString('versionScope','nonSxS')
        $XmlWriter.WriteAttributeString("xmlns","wcm", $null,"http://schemas.microsoft.com/WMIConfig/2002/State")
        $XmlWriter.WriteAttributeString("xmlns","xsi", $null,"http://www.w3.org/2001/XMLSchema-instance")
        $XmlWriter.WriteStartElement('RunSynchronous')

          $XmlWriter.WriteStartElement('RunSynchronousCommand') # set machine-wide execution policy. Why cant this go inside the ExtractScript here-string? Because not every OS instance makes use of ExtractScript!
            $XmlWriter.WriteElementString('Order',"%_Order_Index_%")
            $XmlWriter.WriteElementString('Description',"set machine-wide execution policy")
            $XmlWriter.WriteElementString('Path',$(
              -join @(
                "powershell.exe "
                "-WindowStyle $([System.Char]34)Normal$([System.Char]34) "
                "-NoProfile "
                "-Command "
                $([System.Char]34)
                "Set-ExecutionPolicy "
                "-Scope $([System.Char]39)LocalMachine$([System.Char]39) "
                "-ExecutionPolicy $([System.Char]39)RemoteSigned$([System.Char]39) "
                "-Verbose "
                "-Force"
                $([System.Char]34)
              )
            ))
          $XmlWriter.WriteEndElement()

          $XmlWriter.WriteStartElement('RunSynchronousCommand') # unattend element features a child element titled Extensions. ExtractScript, a child of Extensions, is a here-string that gets converted to ScBk and then executed
            $XmlWriter.WriteElementString('Order',"%_Order_Index_%")
            $XmlWriter.WriteElementString('Description',"unattend element features a child element titled Extensions. ExtractScript, a child of Extensions, is a here-string that gets converted to ScBk and then executed.")
            $XmlWriter.WriteElementString('Path',$(
              -join @(
                "powershell.exe "
                "-WindowStyle $([System.Char]34)Normal$([System.Char]34) "
                "-NoProfile "
                "-Command "
                $([System.Char]34)
                "`$xml = [xml]::new(); "
                "`$xml.Load('C:\Windows\Panther\unattend.xml'); "
                "`$sb = [ScriptBlock]::Create(`$xml.unattend.Extensions.ExtractScript); "
                "icm -ArgumentList `$xml -ScriptBlock `$sb"
                $([System.Char]34)
              )
            ))
          $XmlWriter.WriteEndElement()

          $XmlWriter.WriteStartElement('RunSynchronousCommand')
            $XmlWriter.WriteElementString('Order',"%_Order_Index_%")
            $XmlWriter.WriteElementString('Description',"Scriptblocks within SpEcialiZe.ps1 are executed in 'NT Authority\System' context.")
            $XmlWriter.WriteElementString('Path',$(
              -join @(
                "powershell.exe "
                "-WindowStyle $([System.Char]34)Maximized$([System.Char]34) "
                "-NoProfile "
                "-Command "
                $([System.Char]34)
                "Get-Content "
                "-Raw "
                "-Path "
                "$([System.Char]39)C:\Windows\Setup\Scripts\SpEcialiZe.ps1$([System.Char]39) "
                "| "
                "Invoke-Expression "
                "-Verbose"
                $([System.Char]34)
              )
            ))
          $XmlWriter.WriteEndElement()

          $XmlWriter.WriteStartElement('RunSynchronousCommand') # 
            $XmlWriter.WriteElementString('Order',"%_Order_Index_%")
            $XmlWriter.WriteElementString('Description',"Mount the 'C:\Users\Default\NTUSER.DAT' database to load the HKU\DefaultUser hive")
            $XmlWriter.WriteElementString('Path',$(
              -join @(
                "reg.exe "
                "load "
                "$([System.Char]34)HKU\DefaultUser$([System.Char]34) "
                "$([System.Char]34)C:\Users\Default\NTUSER.DAT$([System.Char]34)"
              )
            ))
          $XmlWriter.WriteEndElement()

          $XmlWriter.WriteStartElement('RunSynchronousCommand') # Execute DefaultUser.ps1
            $XmlWriter.WriteElementString('Order',"%_Order_Index_%")
            $XmlWriter.WriteElementString('Description',"Execute DefaultUser.ps1")
            $XmlWriter.WriteElementString('Path',$(
              -join @(
                "powershell.exe "
                "-WindowStyle $([System.Char]34)Maximized$([System.Char]34) "
                "-NoProfile "
                "-Command "
                $([System.Char]34)
                "Get-Content "
                "-Raw "
                "-Path "
                "$([System.Char]39)C:\Windows\Setup\Scripts\DefaultUser.ps1$([System.Char]39) "
                "| "
                "Invoke-Expression "
                "-Verbose"
                $([System.Char]34)
              )
            ))
          $XmlWriter.WriteEndElement()

          $XmlWriter.WriteStartElement('RunSynchronousCommand') # Unload the HKU\DefaultUser hive
            $XmlWriter.WriteElementString('Order',"%_Order_Index_%")
            $XmlWriter.WriteElementString('Description',"Unload the HKU\DefaultUser hive")
            $XmlWriter.WriteElementString('Path',$(
              -join @(
                "reg.exe "
                "unload "
                "$([System.Char]34)HKU\DefaultUser$([System.Char]34)"
              )
            ))
          $XmlWriter.WriteEndElement()

          $XmlWriter.WriteStartElement('RunSynchronousCommand')
            $XmlWriter.WriteElementString('Order',"%_Order_Index_%")
            $XmlWriter.WriteElementString('Description',"Disable built-in Administrator account")
            #$XmlWriter.WriteElementString('Path',"cmd.exe /c net.exe user Administrator /active:no")
            $XmlWriter.WriteElementString('Path',$(
              -join @(
                "cmd.exe "
                "/c "
                "net.exe "
                "user "
                "Administrator "
                "/active:no"
              )
            ))
          $XmlWriter.WriteEndElement()

        $XmlWriter.WriteEndElement()
      $XmlWriter.WriteEndElement()
      #endregion

      #region | settings | pass = specialize | component | name = Microsoft-Windows-ServerManager-SvrMgrNc |
      $XmlWriter.WriteStartElement('component')
        $XmlWriter.WriteAttributeString('name','Microsoft-Windows-ServerManager-SvrMgrNc')
        $XmlWriter.WriteAttributeString('processorArchitecture','amd64')
        $XmlWriter.WriteAttributeString('publicKeyToken','31bf3856ad364e35')
        $XmlWriter.WriteAttributeString('language','neutral')
        $XmlWriter.WriteAttributeString('versionScope','nonSxS')
        $XmlWriter.WriteAttributeString("xmlns","xsi", $null,"http://www.w3.org/2001/XMLSchema-instance")
        $XmlWriter.WriteAttributeString("xmlns","wcm", $null,"http://schemas.microsoft.com/WMIConfig/2002/State")
        $XmlWriter.WriteElementString('DoNotOpenServerManagerAtLogon','true')
      $XmlWriter.WriteEndElement()
      #endregion

      #region | settings | pass = specialize | component | name = Microsoft-Windows-Shell-Setup |
      $XmlWriter.WriteStartElement('component')
        $XmlWriter.WriteAttributeString('name','Microsoft-Windows-Shell-Setup')
        $XmlWriter.WriteAttributeString('processorArchitecture','amd64')
        $XmlWriter.WriteAttributeString('publicKeyToken','31bf3856ad364e35')
        $XmlWriter.WriteAttributeString('language','neutral')
        $XmlWriter.WriteAttributeString('versionScope','nonSxS')
        $XmlWriter.WriteAttributeString("xmlns","wcm", $null,"http://schemas.microsoft.com/WMIConfig/2002/State")
        $XmlWriter.WriteAttributeString("xmlns","xsi", $null,"http://www.w3.org/2001/XMLSchema-instance")
        $XmlWriter.WriteElementString('RegisteredOrganization',${Registered Organization})
        $XmlWriter.WriteElementString('RegisteredOwner',${Registered Owner})
        $XmlWriter.WriteElementString('TimeZone',$([System.String](Get-TimeZone | % 'StandardName')))
        $XmlWriter.WriteElementString('OEMName','Dell')
      $XmlWriter.WriteEndElement()
      #endregion

      #region | settings | pass = specialize | component | name = Microsoft-Windows-IE-InternetExplorer |
      $XmlWriter.WriteStartElement('component')
        $XmlWriter.WriteAttributeString('name','Microsoft-Windows-IE-InternetExplorer')
        $XmlWriter.WriteAttributeString('processorArchitecture','amd64')
        $XmlWriter.WriteAttributeString('publicKeyToken','31bf3856ad364e35')
        $XmlWriter.WriteAttributeString('language','neutral')
        $XmlWriter.WriteAttributeString('versionScope','nonSxS')
        $XmlWriter.WriteAttributeString("xmlns","wcm", $null,"http://schemas.microsoft.com/WMIConfig/2002/State")
        $XmlWriter.WriteAttributeString("xmlns","xsi", $null,"http://www.w3.org/2001/XMLSchema-instance")
        $XmlWriter.WriteElementString('Home_Page','about:blank')
        $XmlWriter.WriteElementString('DisableFirstRunWizard','true')
        $XmlWriter.WriteElementString('DisableOOBAccelerators','true')
        $XmlWriter.WriteElementString('DisableDevTools','true')
        $XmlWriter.WriteElementString('LocalIntranetSites',$(
          $Value = (${Registered Organization}).ToLower()
          "http://*.$Value;https://*.$Value"
        ))
        $XmlWriter.WriteElementString('TrustedSites',$(
          $Value = (${Registered Organization}).ToLower()
          "https://*.$Value"
        ))
      $XmlWriter.WriteEndElement()
      #endregion

      #region | settings | pass = specialize | component | name = Microsoft-Windows-International-Core |
      $XmlWriter.WriteStartElement('component')
        $XmlWriter.WriteAttributeString('name','Microsoft-Windows-International-Core')
        $XmlWriter.WriteAttributeString('processorArchitecture','amd64')
        $XmlWriter.WriteAttributeString('publicKeyToken','31bf3856ad364e35')
        $XmlWriter.WriteAttributeString('language','neutral')
        $XmlWriter.WriteAttributeString('versionScope','nonSxS')
        $XmlWriter.WriteAttributeString("xmlns","wcm", $null,"http://schemas.microsoft.com/WMIConfig/2002/State")
        $XmlWriter.WriteAttributeString("xmlns","xsi", $null,"http://www.w3.org/2001/XMLSchema-instance")
        $XmlWriter.WriteElementString('InputLocale',${InputLocale})
        $XmlWriter.WriteElementString('SystemLocale',${SystemLocale})
        $XmlWriter.WriteElementString('UILanguage',${UILanguage})
        $XmlWriter.WriteElementString('UserLocale',${UserLocale})            
      $XmlWriter.WriteEndElement()
      #endregion

    $XmlWriter.WriteEndElement()
    #endregion

    #region | settings | pass = oobeSystem |
    $XmlWriter.WriteStartElement('settings')
      $XmlWriter.WriteAttributeString('pass','oobeSystem')

      #region | settings | pass = oobeSystem | component | name = Microsoft-Windows-International-Core |

      $XmlWriter.WriteStartElement('component')
        $XmlWriter.WriteAttributeString('name','Microsoft-Windows-International-Core')
        $XmlWriter.WriteAttributeString('processorArchitecture','amd64')
        $XmlWriter.WriteAttributeString('publicKeyToken','31bf3856ad364e35')
        $XmlWriter.WriteAttributeString('language','neutral')
        $XmlWriter.WriteAttributeString('versionScope','nonSxS')
        $XmlWriter.WriteAttributeString("xmlns","wcm", $null,"http://schemas.microsoft.com/WMIConfig/2002/State")
        $XmlWriter.WriteAttributeString("xmlns","xsi", $null,"http://www.w3.org/2001/XMLSchema-instance")
        $XmlWriter.WriteElementString('InputLocale',${InputLocale})
        $XmlWriter.WriteElementString('SystemLocale',${SystemLocale})
        $XmlWriter.WriteElementString('UILanguage',${UILanguage})
        $XmlWriter.WriteElementString('UserLocale',${UserLocale})            
      $XmlWriter.WriteEndElement()

      #endregion

      #region | settings | pass = oobeSystem | component | name = Microsoft-Windows-Shell-Setup |
      $XmlWriter.WriteStartElement('component')
        $XmlWriter.WriteAttributeString('name','Microsoft-Windows-Shell-Setup')
        $XmlWriter.WriteAttributeString('processorArchitecture','amd64')
        $XmlWriter.WriteAttributeString('publicKeyToken','31bf3856ad364e35')
        $XmlWriter.WriteAttributeString('language','neutral')
        $XmlWriter.WriteAttributeString('versionScope','nonSxS')
        $XmlWriter.WriteAttributeString("xmlns","wcm", $null,"http://schemas.microsoft.com/WMIConfig/2002/State")
        $XmlWriter.WriteAttributeString("xmlns","xsi", $null,"http://www.w3.org/2001/XMLSchema-instance")

        #region | FirstLogonCommands |
        $XmlWriter.WriteStartElement('FirstLogonCommands')

          #region | Run FirstLogon.ps1 Script |
          $XmlWriter.WriteStartElement('SynchronousCommand')
            $XmlWriter.WriteElementString('Order',"%_Order_Index_%")
            $XmlWriter.WriteElementString('Description',"First logon commands inside FirstLogon.ps1 file.")
            $XmlWriter.WriteElementString('RequiresUserInput',"false")
            $XmlWriter.WriteElementString('CommandLine',$(
              -join @(
                "powershell.exe "
                "-WindowStyle $([System.Char]34)Normal$([System.Char]34) "
                "-Command "
                $([System.Char]34)
                "Get-Content "
                "-Raw "
                "-Path "
                "$([System.Char]39)C:\Windows\Setup\Scripts\FirstLogon.ps1$([System.Char]39) "
                "| "
                "Invoke-Expression "
                "-Verbose"
                $([System.Char]34)
              )
            ))
          $XmlWriter.WriteEndElement()
          #endregion

          $XmlWriter.WriteStartElement('SynchronousCommand') # Wait 3 seconds
            $XmlWriter.WriteElementString('Order',"%_Order_Index_%")
            $XmlWriter.WriteElementString('Description',"Just wait, okay?!")
            $XmlWriter.WriteElementString('RequiresUserInput',"false")
            $XmlWriter.WriteElementString('CommandLine',$(
              -join @(
                "powershell.exe "
                "-WindowStyle $([System.Char]34)Maximized$([System.Char]34) "
                "-NoProfile "
                "-Command "
                $([System.Char]34)
                "Start-Sleep 3"
                $([System.Char]34)
              )
            ))
          $XmlWriter.WriteEndElement()

          # Pass 00 of HadeanDscConfigurationDocument
          $XmlWriter.WriteStartElement('SynchronousCommand')
            $XmlWriter.WriteElementString('Order',"%_Order_Index_%")
            $XmlWriter.WriteElementString('Description',"Pass 00 of HadeanDscConfigurationDocument.ps1")
            $XmlWriter.WriteElementString('RequiresUserInput',"false")
            $XmlWriter.WriteElementString('CommandLine',$(
              -join @(
                "powershell.exe "
                "-WindowStyle $([System.Char]34)Maximized$([System.Char]34) "
                "-Command "
                $([System.Char]34)
                "Get-Content "
                "-Raw "
                "-Path "
                "$([System.Char]39)C:\Windows\Setup\Scripts\HadeanDscConfigurationDocument.ps1$([System.Char]39) "
                "| "
                "iex "
                "-Verbose; pause"
                $([System.Char]34)
              )
            ))
          $XmlWriter.WriteEndElement()

          # the primordial Hyper-V host / DSC Push server | Burn through 5 passes of the pre-document encryption configuration |
          # Pass 01 of HadeanDscConfigurationDocument
          $XmlWriter.WriteStartElement('SynchronousCommand')
            $XmlWriter.WriteElementString('Order',"%_Order_Index_%")
            $XmlWriter.WriteElementString('Description',"Pass 01 of HadeanDscConfigurationDocument.ps1")
            $XmlWriter.WriteElementString('RequiresUserInput',"false")
            $XmlWriter.WriteElementString('CommandLine',$(
              -join @(
                "powershell.exe "
                "-WindowStyle $([System.Char]34)Maximized$([System.Char]34) "
                "-Command "
                $([System.Char]34)
                "Get-Content "
                "-Raw "
                "-Path "
                "$([System.Char]39)C:\Windows\Setup\Scripts\HadeanDscConfigurationDocument.ps1$([System.Char]39) "
                "| "
                "iex "
                "-Verbose; pause"
                $([System.Char]34)
              )
            ))
          $XmlWriter.WriteEndElement()

          # Pass 02 of HadeanDscConfigurationDocument
          $XmlWriter.WriteStartElement('SynchronousCommand')
            $XmlWriter.WriteElementString('Order',"%_Order_Index_%")
            $XmlWriter.WriteElementString('Description',"Pass 02 of HadeanDscConfigurationDocument.ps1")
            $XmlWriter.WriteElementString('RequiresUserInput',"false")
            $XmlWriter.WriteElementString('CommandLine',$(
              -join @(
                "powershell.exe "
                "-WindowStyle $([System.Char]34)Maximized$([System.Char]34) "
                "-Command "
                $([System.Char]34)
                "Get-Content "
                "-Raw "
                "-Path "
                "$([System.Char]39)C:\Windows\Setup\Scripts\HadeanDscConfigurationDocument.ps1$([System.Char]39) "
                "| "
                "iex "
                "-Verbose; pause"
                $([System.Char]34)
              )
            ))
          $XmlWriter.WriteEndElement()

          # Pass 03 of HadeanDscConfigurationDocument
          $XmlWriter.WriteStartElement('SynchronousCommand')
            $XmlWriter.WriteElementString('Order',"%_Order_Index_%")
            $XmlWriter.WriteElementString('Description',"Pass 03 of HadeanDscConfigurationDocument.ps1")
            $XmlWriter.WriteElementString('RequiresUserInput',"false")
            $XmlWriter.WriteElementString('CommandLine',$(
              -join @(
                "powershell.exe "
                "-WindowStyle $([System.Char]34)Maximized$([System.Char]34) "
                "-Command "
                $([System.Char]34)
                "Get-Content "
                "-Raw "
                "-Path "
                "$([System.Char]39)C:\Windows\Setup\Scripts\HadeanDscConfigurationDocument.ps1$([System.Char]39) "
                "| "
                "iex "
                "-Verbose; pause"
                $([System.Char]34)
              )
            ))
          $XmlWriter.WriteEndElement()

          # Pass 04 of HadeanDscConfigurationDocument
          $XmlWriter.WriteStartElement('SynchronousCommand')
            $XmlWriter.WriteElementString('Order',"%_Order_Index_%")
            $XmlWriter.WriteElementString('Description',"Pass 04 of HadeanDscConfigurationDocument.ps1")
            $XmlWriter.WriteElementString('RequiresUserInput',"false")
            $XmlWriter.WriteElementString('CommandLine',$(
              -join @(
                "powershell.exe "
                "-WindowStyle $([System.Char]34)Maximized$([System.Char]34) "
                "-Command "
                $([System.Char]34)
                "Get-Content "
                "-Raw "
                "-Path "
                "$([System.Char]39)C:\Windows\Setup\Scripts\HadeanDscConfigurationDocument.ps1$([System.Char]39) "
                "| "
                "iex "
                "-Verbose; pause"
                $([System.Char]34)
              )
            ))
          $XmlWriter.WriteEndElement()

          # Pass 05 of HadeanDscConfigurationDocument
          $XmlWriter.WriteStartElement('SynchronousCommand')
            $XmlWriter.WriteElementString('Order',"%_Order_Index_%")
            $XmlWriter.WriteElementString('Description',"Pass 05 of HadeanDscConfigurationDocument.ps1")
            $XmlWriter.WriteElementString('RequiresUserInput',"false")
            $XmlWriter.WriteElementString('CommandLine',$(
              -join @(
                "powershell.exe "
                "-WindowStyle $([System.Char]34)Maximized$([System.Char]34) "
                "-Command "
                $([System.Char]34)
                "Get-Content "
                "-Raw "
                "-Path "
                "$([System.Char]39)C:\Windows\Setup\Scripts\HadeanDscConfigurationDocument.ps1$([System.Char]39) "
                "| "
                "iex "
                "-Verbose; pause"
                $([System.Char]34)
              )
            ))
          $XmlWriter.WriteEndElement()

          #region | HvH with VMs Epoch |
          # Execute 'Epoch_B__HvH_with_VMs__Wave_00' a 1st time
          $XmlWriter.WriteStartElement('SynchronousCommand'); $XmlWriter.WriteElementString('Description',"Copy from external media .ISOs,install files. Export Code Signing .cer file. Define all DocEnc, Sauth, and Cauth certs. Attach non-system VHDX. IP ExcIncOutline. Install Hyper-V Feature. Reboot.")
            $XmlWriter.WriteElementString('Order',"%_Order_Index_%")
            $XmlWriter.WriteElementString('RequiresUserInput',"false")
            $XmlWriter.WriteElementString('CommandLine',$(
              -join @(
                "powershell.exe "
                "-WindowStyle $([System.Char]34)Minimized$([System.Char]34) "
                "-Command "
                $([System.Char]34)
                "& ([ScriptBlock]::Create(`${Epoch_B__HvH_with_VMs__Wave_00 Here-String}))"
                $([System.Char]34)
              )
            ))
          $XmlWriter.WriteEndElement()
          
          # Execute 'Epoch_B__HvH_with_VMs__Wave_00' a 2nd time
          $XmlWriter.WriteStartElement('SynchronousCommand'); $XmlWriter.WriteElementString('Description',"Define and export CER + PFX of all DocEnc certs, Sauth, and Cauth certs.. Save to .txt file the non-system VHDX UniqueIDs. IP Inclusion-Exclusion Spaces + ExclusionRangesDDN. VhdxFromIso. Reboot.")
            $XmlWriter.WriteElementString('Order',"%_Order_Index_%")
            $XmlWriter.WriteElementString('RequiresUserInput',"false")
            $XmlWriter.WriteElementString('CommandLine',$(
              -join @(
                "powershell.exe "
                "-WindowStyle $([System.Char]34)Minimized$([System.Char]34) "
                "-Command "
                $([System.Char]34)
                "& ([ScriptBlock]::Create(`${Epoch_B__HvH_with_VMs__Wave_00 Here-String}))"
                $([System.Char]34)
              )
            ))
          $XmlWriter.WriteEndElement()

          # Execute 'Epoch_B__HvH_with_VMs__Wave_00' a 3rd time
          $XmlWriter.WriteStartElement('SynchronousCommand'); $XmlWriter.WriteElementString('Description',"")
            $XmlWriter.WriteElementString('Order',"%_Order_Index_%")
            $XmlWriter.WriteElementString('RequiresUserInput',"false")
            $XmlWriter.WriteElementString('CommandLine',$(
              -join @(
                "powershell.exe "
                "-WindowStyle $([System.Char]34)Minimized$([System.Char]34) "
                "-Command "
                $([System.Char]34)
                "& ([ScriptBlock]::Create(`${Epoch_B__HvH_with_VMs__Wave_00 Here-String}))"
                $([System.Char]34)
              )
            ))
          $XmlWriter.WriteEndElement()
          
          # Execute 'Epoch_B__HvH_with_VMs__Wave_00' a 4th time
          $XmlWriter.WriteStartElement('SynchronousCommand'); $XmlWriter.WriteElementString('Description',"")
            $XmlWriter.WriteElementString('Order',"%_Order_Index_%")
            $XmlWriter.WriteElementString('RequiresUserInput',"false")
            $XmlWriter.WriteElementString('CommandLine',$(
              -join @(
                "powershell.exe "
                "-WindowStyle $([System.Char]34)Minimized$([System.Char]34) "
                "-Command "
                $([System.Char]34)
                "& ([ScriptBlock]::Create(`${Epoch_B__HvH_with_VMs__Wave_00 Here-String}))"
                $([System.Char]34)
              )
            ))
          $XmlWriter.WriteEndElement()

          $XmlWriter.WriteStartElement('SynchronousCommand') # Deploy XML files for VMs |
            $XmlWriter.WriteElementString('Order',"%_Order_Index_%")
            $XmlWriter.WriteElementString('Description',"Deploy XML files for VMs")
            $XmlWriter.WriteElementString('RequiresUserInput',"false")
            $XmlWriter.WriteElementString('CommandLine',$(
              -join @(
                "powershell.exe "
                "-WindowStyle $([System.Char]34)Normal$([System.Char]34) "
                "-Command "
                $([System.Char]34)
                "& ([ScriptBlock]::Create(`${Prepare_XML_Files Here-String}))"
                $([System.Char]34)
              )
            ))
          $XmlWriter.WriteEndElement()

          $XmlWriter.WriteStartElement('SynchronousCommand') # Define MetaConfig.mof + Pending.mof files for VMs
            $XmlWriter.WriteElementString('Order',"%_Order_Index_%")
            $XmlWriter.WriteElementString('Description',"Define MetaConfig.mof + Pending.mof files for VMs")
            $XmlWriter.WriteElementString('RequiresUserInput',"false")
            $XmlWriter.WriteElementString('CommandLine',$(
              -join @(
                "powershell.exe "
                "-WindowStyle $([System.Char]34)Normal$([System.Char]34) "
                "-Command "
                $([System.Char]34)
                "& ([ScriptBlock]::Create(`${Bootstrap_MOFs Here-String}))"
                $([System.Char]34)
              )
            ))
          $XmlWriter.WriteEndElement()
          
          # Execute 'Epoch_B__HvH_with_VMs__Wave_00' a 5th time
          $XmlWriter.WriteStartElement('SynchronousCommand'); $XmlWriter.WriteElementString('Description',"")
            $XmlWriter.WriteElementString('Order',"%_Order_Index_%")
            $XmlWriter.WriteElementString('RequiresUserInput',"false")
            $XmlWriter.WriteElementString('CommandLine',$(
              -join @(
                "powershell.exe "
                "-WindowStyle $([System.Char]34)Minimized$([System.Char]34) "
                "-Command "
                $([System.Char]34)
                "& ([ScriptBlock]::Create(`${Epoch_B__HvH_with_VMs__Wave_00 Here-String}))"
                $([System.Char]34)
              )
            ))
          $XmlWriter.WriteEndElement()

          # Execute 'Epoch_B__HvH_with_VMs__Wave_00' a 6th time
          $XmlWriter.WriteStartElement('SynchronousCommand'); $XmlWriter.WriteElementString('Description',"")
            $XmlWriter.WriteElementString('Order',"%_Order_Index_%")
            $XmlWriter.WriteElementString('RequiresUserInput',"false")
            $XmlWriter.WriteElementString('CommandLine',$(
              -join @(
                "powershell.exe "
                "-WindowStyle $([System.Char]34)Minimized$([System.Char]34) "
                "-Command "
                $([System.Char]34)
                "& ([ScriptBlock]::Create(`${Epoch_B__HvH_with_VMs__Wave_00 Here-String}))"
                $([System.Char]34)
              )
            ))
          $XmlWriter.WriteEndElement()

          # Execute 'Epoch_B__HvH_with_VMs__Wave_00' a 7th time
          $XmlWriter.WriteStartElement('SynchronousCommand'); $XmlWriter.WriteElementString('Description',"")
            $XmlWriter.WriteElementString('Order',"%_Order_Index_%")
            $XmlWriter.WriteElementString('RequiresUserInput',"false")
            $XmlWriter.WriteElementString('CommandLine',$(
              -join @(
                "powershell.exe "
                "-WindowStyle $([System.Char]34)Minimized$([System.Char]34) "
                "-Command "
                $([System.Char]34)
                "& ([ScriptBlock]::Create(`${Epoch_B__HvH_with_VMs__Wave_00 Here-String}))"
                $([System.Char]34)
              )
            ))
          $XmlWriter.WriteEndElement()
          
          # Execute 'Epoch_B__HvH_with_VMs__Wave_00' an 8th time
          $XmlWriter.WriteStartElement('SynchronousCommand'); $XmlWriter.WriteElementString('Description',"")
            $XmlWriter.WriteElementString('Order',"%_Order_Index_%")
            $XmlWriter.WriteElementString('RequiresUserInput',"false")
            $XmlWriter.WriteElementString('CommandLine',$(
              -join @(
                "powershell.exe "
                "-WindowStyle $([System.Char]34)Minimized$([System.Char]34) "
                "-Command "
                $([System.Char]34)
                "& ([ScriptBlock]::Create(`${Epoch_B__HvH_with_VMs__Wave_00 Here-String}))"
                $([System.Char]34)
              )
            ))
          $XmlWriter.WriteEndElement()

          # Execute 'Epoch_B__HvH_with_VMs__Wave_00' a 9th time
          $XmlWriter.WriteStartElement('SynchronousCommand'); $XmlWriter.WriteElementString('Description',"")
            $XmlWriter.WriteElementString('Order',"%_Order_Index_%")
            $XmlWriter.WriteElementString('RequiresUserInput',"false")
            $XmlWriter.WriteElementString('CommandLine',$(
              -join @(
                "powershell.exe "
                "-WindowStyle $([System.Char]34)Minimized$([System.Char]34) "
                "-Command "
                $([System.Char]34)
                "& ([ScriptBlock]::Create(`${Epoch_B__HvH_with_VMs__Wave_00 Here-String}))"
                $([System.Char]34)
              )
            ))
          $XmlWriter.WriteEndElement()

          # Execute 'Epoch_B__HvH_with_VMs__Wave_00' a 10th time
          $XmlWriter.WriteStartElement('SynchronousCommand'); $XmlWriter.WriteElementString('Description',"")
            $XmlWriter.WriteElementString('Order',"%_Order_Index_%")
            $XmlWriter.WriteElementString('RequiresUserInput',"false")
            $XmlWriter.WriteElementString('CommandLine',$(
              -join @(
                "powershell.exe "
                "-WindowStyle $([System.Char]34)Minimized$([System.Char]34) "
                "-Command "
                $([System.Char]34)
                "& ([ScriptBlock]::Create(`${Epoch_B__HvH_with_VMs__Wave_00 Here-String}))"
                $([System.Char]34)
              )
            ))
          $XmlWriter.WriteEndElement()

          # Execute 'Epoch_B__HvH_with_VMs__Wave_00' a 11th time
          $XmlWriter.WriteStartElement('SynchronousCommand'); $XmlWriter.WriteElementString('Description',"")
            $XmlWriter.WriteElementString('Order',"%_Order_Index_%")
            $XmlWriter.WriteElementString('RequiresUserInput',"false")
            $XmlWriter.WriteElementString('CommandLine',$(
              -join @(
                "powershell.exe "
                "-WindowStyle $([System.Char]34)Minimized$([System.Char]34) "
                "-Command "
                $([System.Char]34)
                "& ([ScriptBlock]::Create(`${Epoch_B__HvH_with_VMs__Wave_00 Here-String}))"
                $([System.Char]34)
              )
            ))
          $XmlWriter.WriteEndElement()
          #endregion

          #region | DSC Push Server Epoch |
          $XmlWriter.WriteStartElement('SynchronousCommand'); $XmlWriter.WriteElementString('Description',"")
            $XmlWriter.WriteElementString('Order',"%_Order_Index_%")
            $XmlWriter.WriteElementString('RequiresUserInput',"false")
            $XmlWriter.WriteElementString('CommandLine',$(
              -join @(
                "powershell.exe "
                "-WindowStyle $([System.Char]34)Hidden$([System.Char]34) "
                "-Command "
                $([System.Char]34)
                "& ([ScriptBlock]::Create(`${Epoch_B__HvH_with_VMs__Wave_01 Here-String}))"
                $([System.Char]34)
              )
            ))
          $XmlWriter.WriteEndElement()

          $XmlWriter.WriteStartElement('SynchronousCommand') # Wait for LCM to complete pending.mof.
            $XmlWriter.WriteElementString('Order',"%_Order_Index_%")
            $XmlWriter.WriteElementString('Description',"Wait for LCM to complete pending.mof.")
            $XmlWriter.WriteElementString('RequiresUserInput',"false")
            $XmlWriter.WriteElementString('CommandLine',$(
              -join @(
                "powershell.exe "
                "-WindowStyle $([System.Char]34)Normal$([System.Char]34) "
                "-Command "
                $([System.Char]34)
                "& ([ScriptBlock]::Create(`${Wait4LCM + import private Key Here-String}))"
                $([System.Char]34)
              )
            ))
          $XmlWriter.WriteEndElement()
          #endregion

          <# pe.cmd investigation |
            $XmlWriter.WriteStartElement('SynchronousCommand'); 
              $XmlWriter.WriteElementString('Order',"%_Order_Index_%"); 
              $XmlWriter.WriteElementString('Description',"pe.cmd investigation"); 
              $XmlWriter.WriteElementString('RequiresUserInput',"false"); 
              $XmlWriter.WriteElementString('CommandLine',$(
                -join @(
                  "cmd.exe /c >>C:\pe.cmd (echo:@echo off&echo:call :print ^$([System.Char]34)Setting keyboard layout for PE session^$([System.Char]34)&echo:wpeutil.exe SetKeyboardLayout 0409:00000409&echo:for ^%^%d in (C D E F G H I J K L M N O P Q T U V X Y Z^) do ()"
                )
              )); 
            $XmlWriter.WriteEndElement()

            $XmlWriter.WriteStartElement('SynchronousCommand'); 
              $XmlWriter.WriteElementString('Order',"%_Order_Index_%"); 
              $XmlWriter.WriteElementString('Description',"pe.cmd investigation"); 
              $XmlWriter.WriteElementString('RequiresUserInput',"false"); 
              $XmlWriter.WriteElementString('CommandLine',$(
                -join @(
                  "cmd.exe /c >>C:\pe.cmd (echo:if exist ^%^%d:\sources\install.wim set ^$([System.Char]34)IMAGE_FILE=^%^%d:\sources\install.wim^$([System.Char]34)&echo:if exist ^%^%d:\sources\install.esd set ^$([System.Char]34)IMAGE_FILE=^%^%d:\sources\install.esd^$([System.Char]34))"
                )
              )); 
            $XmlWriter.WriteEndElement()

            $XmlWriter.WriteStartElement('SynchronousCommand'); 
              $XmlWriter.WriteElementString('Order',"%_Order_Index_%"); 
              $XmlWriter.WriteElementString('Description',"pe.cmd investigation"); 
              $XmlWriter.WriteElementString('RequiresUserInput',"false"); 
              $XmlWriter.WriteElementString('CommandLine',$(
                -join @(
                  "cmd.exe /c >>C:\pe.cmd (echo:if exist ^%^%d:\sources\install.swm set ^$([System.Char]34)IMAGE_FILE=^%^%d:\sources\install.swm^$([System.Char]34) ^& set ^$([System.Char]34)SWM_PARAM=/SWMFile:^%^%d:\sources\install*.swm^$([System.Char]34)&echo:if exist ^%^%d:\autounattend.xml set ^$([System.Char]34)XML_FILE=^%^%d:\autounattend.xml^$([System.Char]34))"
                )
              )); 
            $XmlWriter.WriteEndElement()

            $XmlWriter.WriteStartElement('SynchronousCommand'); 
              $XmlWriter.WriteElementString('Order',"%_Order_Index_%"); 
              $XmlWriter.WriteElementString('Description',"pe.cmd investigation"); 
              $XmlWriter.WriteElementString('RequiresUserInput',"false"); 
              $XmlWriter.WriteElementString('CommandLine',$(
                -join @(
                  "cmd.exe /c >>C:\pe.cmd (echo:if exist ^%^%d:\`$OEM`$ set ^$([System.Char]34)OEM_FOLDER=^%^%d:\`$OEM`$^$([System.Char]34)&echo:if exist ^%^%d:\`$WinPEDriver`$ set ^$([System.Char]34)PEDRIVERS_FOLDER=^%^%d:\`$WinPEDriver`$^$([System.Char]34)&echo:^))"
                )
              )); 
            $XmlWriter.WriteEndElement()

            $XmlWriter.WriteStartElement('SynchronousCommand'); 
              $XmlWriter.WriteElementString('Order',"%_Order_Index_%"); 
              $XmlWriter.WriteElementString('Description',"pe.cmd investigation"); 
              $XmlWriter.WriteElementString('RequiresUserInput',"false"); 
              $XmlWriter.WriteElementString('CommandLine',$(
                -join @(
                  "cmd.exe /c >>C:\pe.cmd (echo:for /f ^$([System.Char]34)tokens=3^$([System.Char]34) ^%^%t in ($([System.Char]39)reg.exe query HKLM\System\Setup /v UnattendFile 2^^^>nul$([System.Char]39)^) do ( if exist ^%^%t set ^$([System.Char]34)XML_FILE=^%^%t^$([System.Char]34) ^))"
                )
              )); 
            $XmlWriter.WriteEndElement()

            $XmlWriter.WriteStartElement('SynchronousCommand'); 
              $XmlWriter.WriteElementString('Order',"%_Order_Index_%"); 
              $XmlWriter.WriteElementString('Description',"pe.cmd investigation"); 
              $XmlWriter.WriteElementString('RequiresUserInput',"false"); 
              $XmlWriter.WriteElementString('CommandLine',$(
                -join @(
                  "cmd.exe /c >>C:\pe.cmd (echo:if not defined IMAGE_FILE call :fail ^$([System.Char]34)Could not locate install.wim, install.esd or install.swm.^$([System.Char]34)&echo:if not defined XML_FILE call :fail ^$([System.Char]34)Could not locate autounattend.xml.^$([System.Char]34)&echo:set ^$([System.Char]34)OS_VERSION=11^$([System.Char]34))"
                )
              )); 
            $XmlWriter.WriteEndElement()

            $XmlWriter.WriteStartElement('SynchronousCommand'); 
              $XmlWriter.WriteElementString('Order',"%_Order_Index_%"); 
              $XmlWriter.WriteElementString('Description',"pe.cmd investigation"); 
              $XmlWriter.WriteElementString('RequiresUserInput',"false"); 
              $XmlWriter.WriteElementString('CommandLine',$(
                -join @(
                  "cmd.exe /c >>C:\pe.cmd (echo:for /f ^$([System.Char]34)tokens=3 delims=.^$([System.Char]34) ^%^%v in ($([System.Char]39)ver$([System.Char]39)^) do (&echo:if ^%^%v LSS 20000 set ^$([System.Char]34)OS_VERSION=10^$([System.Char]34)&echo:^)&echo:if defined PEDRIVERS_FOLDER (&echo:call :print ^$([System.Char]34)Loading drivers from `$WinPEDriver`$ folder^$([System.Char]34))"
                )
              )); 
            $XmlWriter.WriteEndElement()

            $XmlWriter.WriteStartElement('SynchronousCommand'); 
              $XmlWriter.WriteElementString('Order',"%_Order_Index_%"); 
              $XmlWriter.WriteElementString('Description',"pe.cmd investigation"); 
              $XmlWriter.WriteElementString('RequiresUserInput',"false"); 
              $XmlWriter.WriteElementString('CommandLine',$(
                -join @(
                  "cmd.exe /c >>C:\pe.cmd (echo:for /R ^%PEDRIVERS_FOLDER^% ^%^%f IN (*.inf^) do drvload.exe ^$([System.Char]34)^%^%f^$([System.Char]34)&echo:^)&echo:^>X:\assert.vbs (&echo:echo:Function Fail(message^^^)&echo:echo:WScript.Echo message&echo:echo:WScript.Quit 1&echo:echo:End Function)"
                )
              )); 
            $XmlWriter.WriteEndElement()

            $XmlWriter.WriteStartElement('SynchronousCommand'); 
              $XmlWriter.WriteElementString('Order',"%_Order_Index_%"); 
              $XmlWriter.WriteElementString('Description',"pe.cmd investigation"); 
              $XmlWriter.WriteElementString('RequiresUserInput',"false"); 
              $XmlWriter.WriteElementString('CommandLine',$(
                -join @(
                  "cmd.exe /c >>C:\pe.cmd (echo:echo:On Error Resume Next&echo:echo:Set wmi = GetObject(^^^$([System.Char]34)winmgmts:\\.\root\cimv2^^^$([System.Char]34)^^^)&echo:echo:Set drive = wmi.Get(^^^$([System.Char]34)Win32_DiskDrive.DeviceID=$([System.Char]39)\\.\PHYSICALDRIVE0$([System.Char]39)^^^$([System.Char]34)^^^)&echo:echo:If Err.Number ^^^<^^^> 0 Then)"
                )
              )); 
            $XmlWriter.WriteEndElement()

            $XmlWriter.WriteStartElement('SynchronousCommand'); 
              $XmlWriter.WriteElementString('Order',"%_Order_Index_%"); 
              $XmlWriter.WriteElementString('Description',"pe.cmd investigation"); 
              $XmlWriter.WriteElementString('RequiresUserInput',"false"); 
              $XmlWriter.WriteElementString('CommandLine',$(
                -join @(
                  "cmd.exe /c >>C:\pe.cmd (echo:echo:Fail ^^^$([System.Char]34)Could not locate disk 0 (^^^$([System.Char]34) ^^^& Err.Description ^^^& ^^^$([System.Char]34)^^^).^^^$([System.Char]34)&echo:echo:End If&echo:echo:actual = drive.InterfaceType&echo:echo:If actual ^^^<^^^> ^^^$([System.Char]34)IDE^^^$([System.Char]34) And actual ^^^<^^^> ^^^$([System.Char]34)SCSI^^^$([System.Char]34) Then)"
                )
              )); 
            $XmlWriter.WriteEndElement()

            $XmlWriter.WriteStartElement('SynchronousCommand'); 
              $XmlWriter.WriteElementString('Order',"%_Order_Index_%"); 
              $XmlWriter.WriteElementString('Description',"pe.cmd investigation"); 
              $XmlWriter.WriteElementString('RequiresUserInput',"false"); 
              $XmlWriter.WriteElementString('CommandLine',$(
                -join @(
                  "cmd.exe /c >>C:\pe.cmd (echo:echo:Fail ^^^$([System.Char]34)InterfaceType $([System.Char]39)^^^$([System.Char]34) ^^^& actual ^^^& ^^^$([System.Char]34)$([System.Char]39) of disk 0 is unexpected.^^^$([System.Char]34)&echo:echo:End If&echo:echo:actual = drive.MediaType&echo:echo:If actual ^^^<^^^> ^^^$([System.Char]34)Fixed hard disk media^^^$([System.Char]34) Then)"
                )
              )); 
            $XmlWriter.WriteEndElement()

            $XmlWriter.WriteStartElement('SynchronousCommand'); 
              $XmlWriter.WriteElementString('Order',"%_Order_Index_%"); 
              $XmlWriter.WriteElementString('Description',"pe.cmd investigation"); 
              $XmlWriter.WriteElementString('RequiresUserInput',"false"); 
              $XmlWriter.WriteElementString('CommandLine',$(
                -join @(
                  "cmd.exe /c >>C:\pe.cmd (echo:echo:Fail ^^^$([System.Char]34)MediaType $([System.Char]39)^^^$([System.Char]34) ^^^& actual ^^^& ^^^$([System.Char]34)$([System.Char]39) of disk 0 is unexpected.^^^$([System.Char]34)&echo:echo:End If&echo:echo:actual = CInt(drive.Size / 1024 / 1024 / 1024^^^)&echo:echo:expected = 100&echo:echo:If actual ^^^< expected Then)"
                )
              )); 
            $XmlWriter.WriteEndElement()

            $XmlWriter.WriteStartElement('SynchronousCommand'); 
              $XmlWriter.WriteElementString('Order',"%_Order_Index_%"); 
              $XmlWriter.WriteElementString('Description',"pe.cmd investigation"); 
              $XmlWriter.WriteElementString('RequiresUserInput',"false"); 
              $XmlWriter.WriteElementString('CommandLine',$(
                -join @(
                  "cmd.exe /c >>C:\pe.cmd (echo:echo:Fail ^^^$([System.Char]34)Size of disk 0 is expected to be at least ^^^$([System.Char]34) ^^^& expected ^^^& ^^^$([System.Char]34) GiB, but actually is ^^^$([System.Char]34) ^^^& actual ^^^& ^^^$([System.Char]34) GiB.^^^$([System.Char]34)&echo:echo:End If&echo:echo:actual = CInt(drive.Size / 1024 / 1024 / 1024^^^))"
                )
              )); 
            $XmlWriter.WriteEndElement()

            $XmlWriter.WriteStartElement('SynchronousCommand'); 
              $XmlWriter.WriteElementString('Order',"%_Order_Index_%"); 
              $XmlWriter.WriteElementString('Description',"pe.cmd investigation"); 
              $XmlWriter.WriteElementString('RequiresUserInput',"false"); 
              $XmlWriter.WriteElementString('CommandLine',$(
                -join @(
                  "cmd.exe /c >>C:\pe.cmd (echo:echo:expected = 4000&echo:echo:If actual ^^^> expected Then&echo:echo:Fail ^^^$([System.Char]34)Size of disk 0 is expected to be at most ^^^$([System.Char]34) ^^^& expected ^^^& ^^^$([System.Char]34) GiB, but actually is ^^^$([System.Char]34) ^^^& actual ^^^& ^^^$([System.Char]34) GiB.^^^$([System.Char]34)&echo:echo:End If)"
                )
              )); 
            $XmlWriter.WriteEndElement()

            $XmlWriter.WriteStartElement('SynchronousCommand'); 
              $XmlWriter.WriteElementString('Order',"%_Order_Index_%"); 
              $XmlWriter.WriteElementString('Description',"pe.cmd investigation"); 
              $XmlWriter.WriteElementString('RequiresUserInput',"false"); 
              $XmlWriter.WriteElementString('CommandLine',$(
                -join @(
                  "cmd.exe /c >>C:\pe.cmd (echo:echo:WScript.Echo ^^^$([System.Char]34)Disk assertions were satisfied.^^^$([System.Char]34)&echo:echo:WScript.Quit 0&echo:^)&echo:call :print ^$([System.Char]34)Running disk assertions^$([System.Char]34))"
                )
              )); 
            $XmlWriter.WriteEndElement()

            $XmlWriter.WriteStartElement('SynchronousCommand'); 
              $XmlWriter.WriteElementString('Order',"%_Order_Index_%"); 
              $XmlWriter.WriteElementString('Description',"pe.cmd investigation"); 
              $XmlWriter.WriteElementString('RequiresUserInput',"false"); 
              $XmlWriter.WriteElementString('CommandLine',$(
                -join @(
                  "cmd.exe /c >>C:\pe.cmd (echo:cscript.exe //E:vbscript ^$([System.Char]34)X:\assert.vbs^$([System.Char]34) //Nologo ^|^| call :fail ^$([System.Char]34)Disk assertion failed. Windows Setup will halt to avoid potential data loss.^$([System.Char]34)&echo:^>X:\diskpart.txt (&echo:echo:SELECT DISK=0&echo:echo:CLEAN)"
                )
              )); 
            $XmlWriter.WriteEndElement()

            $XmlWriter.WriteStartElement('SynchronousCommand'); 
              $XmlWriter.WriteElementString('Order',"%_Order_Index_%"); 
              $XmlWriter.WriteElementString('Description',"pe.cmd investigation"); 
              $XmlWriter.WriteElementString('RequiresUserInput',"false"); 
              $XmlWriter.WriteElementString('CommandLine',$(
                -join @(
                  "cmd.exe /c >>C:\pe.cmd (echo:echo:CONVERT GPT&echo:echo:CREATE PARTITION EFI SIZE=527&echo:echo:FORMAT QUICK FS=FAT32 LABEL=^^^$([System.Char]34)System^^^$([System.Char]34)&echo:echo:ASSIGN LETTER=S&echo:echo:CREATE PARTITION MSR SIZE=16&echo:echo:CREATE PARTITION PRIMARY)"
                )
              )); 
            $XmlWriter.WriteEndElement()

            $XmlWriter.WriteStartElement('SynchronousCommand'); 
              $XmlWriter.WriteElementString('Order',"%_Order_Index_%"); 
              $XmlWriter.WriteElementString('Description',"pe.cmd investigation"); 
              $XmlWriter.WriteElementString('RequiresUserInput',"false"); 
              $XmlWriter.WriteElementString('CommandLine',$(
                -join @(
                  "cmd.exe /c >>C:\pe.cmd (echo:echo:SHRINK MINIMUM=1238&echo:echo:FORMAT QUICK FS=NTFS LABEL=^^^$([System.Char]34)Windows^^^$([System.Char]34)&echo:echo:ASSIGN LETTER=W&echo:echo:CREATE PARTITION PRIMARY&echo:echo:FORMAT QUICK FS=NTFS LABEL=^^^$([System.Char]34)Recovery^^^$([System.Char]34)&echo:echo:ASSIGN LETTER=R)"
                )
              )); 
            $XmlWriter.WriteEndElement()

            $XmlWriter.WriteStartElement('SynchronousCommand'); 
              $XmlWriter.WriteElementString('Order',"%_Order_Index_%"); 
              $XmlWriter.WriteElementString('Description',"pe.cmd investigation"); 
              $XmlWriter.WriteElementString('RequiresUserInput',"false"); 
              $XmlWriter.WriteElementString('CommandLine',$(
                -join @(
                  "cmd.exe /c >>C:\pe.cmd (echo:echo:SET ID=^^^$([System.Char]34)de94bba4-06d1-4d40-a16a-bfd50179d6ac^^^$([System.Char]34)&echo:echo:GPT ATTRIBUTES=0x8000000000000001&echo:^)&echo:call :print ^$([System.Char]34)diskpart will now partition and format your disk^$([System.Char]34))"
                )
              )); 
            $XmlWriter.WriteEndElement()

            $XmlWriter.WriteStartElement('SynchronousCommand'); 
              $XmlWriter.WriteElementString('Order',"%_Order_Index_%"); 
              $XmlWriter.WriteElementString('Description',"pe.cmd investigation"); 
              $XmlWriter.WriteElementString('RequiresUserInput',"false"); 
              $XmlWriter.WriteElementString('CommandLine',$(
                -join @(
                  "cmd.exe /c >>C:\pe.cmd (echo:diskpart.exe /s X:\diskpart.txt ^|^| call :fail ^$([System.Char]34)diskpart.exe encountered an error.^$([System.Char]34)&echo:set ^$([System.Char]34)IMG_PARAM=/Index:4^$([System.Char]34)&echo:call :print ^$([System.Char]34)Applying Windows image to target disk^$([System.Char]34))"
                )
              )); 
            $XmlWriter.WriteEndElement()

            $XmlWriter.WriteStartElement('SynchronousCommand'); 
              $XmlWriter.WriteElementString('Order',"%_Order_Index_%"); 
              $XmlWriter.WriteElementString('Description',"pe.cmd investigation"); 
              $XmlWriter.WriteElementString('RequiresUserInput',"false"); 
              $XmlWriter.WriteElementString('CommandLine',$(
                -join @(
                  "cmd.exe /c >>C:\pe.cmd (echo:dism.exe /Apply-Image /ImageFile:^%IMAGE_FILE^% ^%SWM_PARAM^% ^%IMG_PARAM^% /ApplyDir:W:\ /CheckIntegrity /Verify ^|^| call :fail ^$([System.Char]34)dism.exe encountered an error.^$([System.Char]34)&echo:call :print ^$([System.Char]34)Making system partition bootable^$([System.Char]34))"
                )
              )); 
            $XmlWriter.WriteEndElement()

            $XmlWriter.WriteStartElement('SynchronousCommand'); 
              $XmlWriter.WriteElementString('Order',"%_Order_Index_%"); 
              $XmlWriter.WriteElementString('Description',"pe.cmd investigation"); 
              $XmlWriter.WriteElementString('RequiresUserInput',"false"); 
              $XmlWriter.WriteElementString('CommandLine',$(
                -join @(
                  "cmd.exe /c >>C:\pe.cmd (echo:bcdboot.exe W:\Windows /s S: ^|^| call :fail ^$([System.Char]34)bcdboot.exe encountered an error.^$([System.Char]34)&echo:bcdedit.exe /set {fwbootmgr} bootsequence {bootmgr}&echo:call :print ^$([System.Char]34)Copying answer file to target disk^$([System.Char]34)&echo:mkdir W:\Windows\Panther)"
                )
              )); 
            $XmlWriter.WriteEndElement()

            $XmlWriter.WriteStartElement('SynchronousCommand'); 
              $XmlWriter.WriteElementString('Order',"%_Order_Index_%"); 
              $XmlWriter.WriteElementString('Description',"pe.cmd investigation"); 
              $XmlWriter.WriteElementString('RequiresUserInput',"false"); 
              $XmlWriter.WriteElementString('CommandLine',$(
                -join @(
                  "cmd.exe /c >>C:\pe.cmd (echo:copy ^%XML_FILE^% W:\Windows\Panther\unattend.xml&echo:if defined PEDRIVERS_FOLDER (&echo:call :print ^$([System.Char]34)Adding drivers from `$WinPEDriver`$ folder to new installation^$([System.Char]34))"
                )
              )); 
            $XmlWriter.WriteEndElement()

            $XmlWriter.WriteStartElement('SynchronousCommand'); 
              $XmlWriter.WriteElementString('Order',"%_Order_Index_%"); 
              $XmlWriter.WriteElementString('Description',"pe.cmd investigation"); 
              $XmlWriter.WriteElementString('RequiresUserInput',"false"); 
              $XmlWriter.WriteElementString('CommandLine',$(
                -join @(
                  "cmd.exe /c >>C:\pe.cmd (echo:dism.exe /Add-Driver /Image:W:\ /Driver:^$([System.Char]34)^%PEDRIVERS_FOLDER^%^$([System.Char]34) /Recurse&echo:^)&echo:call :print ^$([System.Char]34)Setting time zone^$([System.Char]34)&echo:dism.exe /Image:W:\ /Set-TimeZone:^$([System.Char]34)Central Standard Time^$([System.Char]34))"
                )
              )); 
            $XmlWriter.WriteEndElement()

            $XmlWriter.WriteStartElement('SynchronousCommand'); 
              $XmlWriter.WriteElementString('Order',"%_Order_Index_%"); 
              $XmlWriter.WriteElementString('Description',"pe.cmd investigation"); 
              $XmlWriter.WriteElementString('RequiresUserInput',"false"); 
              $XmlWriter.WriteElementString('CommandLine',$(
                -join @(
                  "cmd.exe /c >>C:\pe.cmd (echo:call :print ^$([System.Char]34)Setting device setup region to United States (GeoID 244^)^$([System.Char]34)&echo:reg.exe LOAD HKLM\mount W:\Windows\System32\config\SOFTWARE)"
                )
              )); 
            $XmlWriter.WriteEndElement()

            $XmlWriter.WriteStartElement('SynchronousCommand'); 
              $XmlWriter.WriteElementString('Order',"%_Order_Index_%"); 
              $XmlWriter.WriteElementString('Description',"pe.cmd investigation"); 
              $XmlWriter.WriteElementString('RequiresUserInput',"false"); 
              $XmlWriter.WriteElementString('CommandLine',$(
                -join @(
                  "cmd.exe /c >>C:\pe.cmd (echo:reg.exe ADD ^$([System.Char]34)HKLM\mount\Microsoft\Windows\CurrentVersion\Control Panel\DeviceRegion^$([System.Char]34) /v DeviceRegion /t REG_DWORD /d 244 /f&echo:reg.exe UNLOAD HKLM\mount&echo:call :print ^$([System.Char]34)Computer will now reboot^$([System.Char]34))"
                )
              )); 
            $XmlWriter.WriteEndElement()

            $XmlWriter.WriteStartElement('SynchronousCommand'); 
              $XmlWriter.WriteElementString('Order',"%_Order_Index_%"); 
              $XmlWriter.WriteElementString('Description',"pe.cmd investigation"); 
              $XmlWriter.WriteElementString('RequiresUserInput',"false"); 
              $XmlWriter.WriteElementString('CommandLine',$(
                -join @(
                  "cmd.exe /c >>C:\pe.cmd (echo:wpeutil.exe reboot&echo:goto :eof&echo::fail&echo:echo:&echo:echo:Fatal error: ^%~1&echo:echo:&echo:pause&echo:exit 1&echo::print&echo:echo:&echo:echo:*** ^%~1 ***&echo:echo:&echo:goto :eof)"
                )
              )); 
            $XmlWriter.WriteEndElement()

            $XmlWriter.WriteStartElement('SynchronousCommand'); 
              $XmlWriter.WriteElementString('Order',"%_Order_Index_%"); 
              $XmlWriter.WriteElementString('Description',"pe.cmd investigation"); 
              $XmlWriter.WriteElementString('RequiresUserInput',"false"); 
              $XmlWriter.WriteElementString('CommandLine',$(
                -join @(
                  "cmd.exe /k echo $([System.Char]34)cmd.exe /c C:\pe.cmd$([System.Char]34)"
                )
              )); 
            $XmlWriter.WriteEndElement()
          #>

        $XmlWriter.WriteEndElement()
        #endregion

        #region | UserAccounts |
        $XmlWriter.WriteStartElement('UserAccounts')
          $XmlWriter.WriteStartElement('LocalAccounts')
            $XmlWriter.WriteStartElement('LocalAccount')
              $XmlWriter.WriteElementString('Name',$UserName)
              $XmlWriter.WriteElementString('Group','Administrators')
              $XmlWriter.WriteElementString('Description',$Description)
              $XmlWriter.WriteElementString('DisplayName',$DisplayName)
              $XmlWriter.WriteStartElement('Password')
                $XmlWriter.WriteElementString('Value',$EncodedPw)
                $XmlWriter.WriteElementString('PlainText',"false")
              $XmlWriter.WriteEndElement()
            $XmlWriter.WriteEndElement()
          $XmlWriter.WriteEndElement()
        $XmlWriter.WriteEndElement()
        #endregion

        #region | AutoLogon | LogonCount = 10 |
        $XmlWriter.WriteStartElement('AutoLogon')
          $XmlWriter.WriteElementString('Username',$UserName)
          $XmlWriter.WriteElementString('Enabled',"true")
          $XmlWriter.WriteElementString('LogonCount',"10")
          $XmlWriter.WriteStartElement('Password')
            $XmlWriter.WriteElementString('Value',$EncodedPw)
            $XmlWriter.WriteElementString('PlainText',"false")
          $XmlWriter.WriteEndElement()
        $XmlWriter.WriteEndElement()
        #endregion

        #region | OOBE |
        $XmlWriter.WriteStartElement('OOBE')
          $XmlWriter.WriteElementString('HideEULAPage','true')
          $XmlWriter.WriteElementString('HideWirelessSetupInOOBE','false')
          $XmlWriter.WriteElementString('HideOnlineAccountScreens','false')
        $XmlWriter.WriteEndElement()
        #endregion

      $XmlWriter.WriteEndElement()
      #endregion
    $XmlWriter.WriteEndElement()
    #endregion
  #endregion

  #region | Extensions |
  $XmlWriter.WriteStartElement('Extensions','https://schneegans.de/windows/unattend-generator/')
    #region | ExtractScript here-string for PowerShell scriptblock |
    ${ExtractScript Here-String} = $(
      #region |  |
      "`n"
      "`t`t`tparam (`n"
      "`t`t`t  [System.Xml.XmlDocument]`$XmlDocument`n"
      "`t`t`t)`n"
      "`t`t`t`n"
      "`t`t`tforeach (`$file in `$XmlDocument.unattend.Extensions.File) {`n"
      "`t`t`t  `$path = [System.Environment]::ExpandEnvironmentVariables(`n"
      "`t`t`t    `$file.GetAttribute($([System.Char]39)path$([System.Char]39))`n"
      "`t`t`t  )`n"
      "`t`t`t`n"
      "`t`t`t  mkdir -Path (`$path | Split-Path -Parent) -ErrorAction $([System.Char]39)SilentlyContinue$([System.Char]39)`n"
      "`t`t`t`n"
      "`t`t`t  `$content = `$file.InnerText.Trim()`n"
      "`t`t`t`n"
      "`t`t`t  if (`$file.GetAttribute($([System.Char]39)transformation$([System.Char]39)) -ieq $([System.Char]39)Base64$([System.Char]39)) {`n"
      "`t`t`t    [System.IO.File]::WriteAllBytes(`$patH, [System.Convert]::FromBase64String(`$content))`n"
      "`t`t`t    Write-Host -Object $([System.Char]34)patH =   `$patH$([System.Char]34)`n"
      "`t`t`t  } else {`n"
      "`t`t`t    `$encoding = switch ([System.IO.Path]::GetExtension(`$path)) {`n"
      "`t`t`t      {`$_ -in $([System.Char]39).ps1$([System.Char]39),$([System.Char]39).xml$([System.Char]39)}       {[System.Text.Encoding]::UTF8}`n"
      "`t`t`t      {`$_ -in $([System.Char]39).reg$([System.Char]39),$([System.Char]39).vbs$([System.Char]39),$([System.Char]39).js$([System.Char]39)} {[System.Text.UnicodeEncoding]::New(`$false,`$true)}`n"
      "`t`t`t      default                      {[System.Text.Encoding]::Default}`n"
      "`t`t`t    }`n"
      "`t`t`t    [System.IO.File]::WriteAllBytes(`$pAth,(`$encoding.GetPreamble() + `$encoding.GetBytes(`$content)))`n"
      "`t`t`t    Write-Host -Object $([System.Char]34)pAth =   `$pAth$([System.Char]34)`n"
      "`t`t`t  }`n"
      "`t`t`t}`n"
      "`t`t"
      #endregion
      { # ExtractScript Plain-Text | Converted to ${ExtractScript Here-String} with 'ConvertTo-HereStringCompatible' |
        param (
          [System.Xml.XmlDocument]$XmlDocument
        )

        foreach ($file in $XmlDocument.unattend.Extensions.File) {
          $path = [System.Environment]::ExpandEnvironmentVariables(
            $file.GetAttribute('path')
          )

          mkdir -Path ($path | Split-Path -Parent) -ErrorAction 'SilentlyContinue'

          $content = $file.InnerText.Trim()

          if ($file.GetAttribute('transformation') -ieq 'Base64') {
            [System.IO.File]::WriteAllBytes($patH, [System.Convert]::FromBase64String($content))
            Write-Host -Object "patH =   $patH"
          } else {
            $encoding = switch ([System.IO.Path]::GetExtension($path)) {
              {$_ -in '.ps1','.xml'}       {[System.Text.Encoding]::UTF8}
              {$_ -in '.reg','.vbs','.js'} {[System.Text.UnicodeEncoding]::New($false,$true)}
              default                      {[System.Text.Encoding]::Default}
            }
            [System.IO.File]::WriteAllBytes($pAth,($encoding.GetPreamble() + $encoding.GetBytes($content)))
            Write-Host -Object "pAth =   $pAth"
          }
        }
      } | Out-Null
    ) -join ''
    $XmlWriter.WriteElementString('ExtractScript',${ExtractScript Here-String})
    #endregion

    #region | SpEcialiZe.ps1 Here-String | A-Scripts | Executed by NT Authority\System, before user accounts are created |
    #region | "Pause Windows Update-Command within Scheduled Task.ps1" Here-String | Pause Windows Update until AFTER WSUS construction |
    ${File Pause Windows Update-Command within Scheduled Task.ps1 Here-String} = $(
      #region |  |
      "`n"
      "`t`t`t`$Formatter = {`n"
      "`t`t`t  `$Args[0].ToString( $([System.Char]34)yyyy$([System.Char]39)-$([System.Char]39)MM$([System.Char]39)-$([System.Char]39)dd$([System.Char]39)T$([System.Char]39)HH$([System.Char]39):$([System.Char]39)mm$([System.Char]39):$([System.Char]39)ssK$([System.Char]34) )`n"
      "`t`t`t}`n"
      "`t`t`t`$Now = [DateTime]::UtcNow`n"
      "`t`t`t`$Start = & `$Formatter `$Now`n"
      "`t`t`t`$End = & `$Formatter `$Now.AddDays( 7 )`n"
      "`t`t`t`$params = @{`n"
      "`t`t`t  LiteralPath = $([System.Char]39)Registry::HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings$([System.Char]39)`n"
      "`t`t`t  Type        = $([System.Char]39)String$([System.Char]39)`n"
      "`t`t`t  Force       = `$true`n"
      "`t`t`t}`n"
      "`t`t`tSet-ItemProperty @params -Name $([System.Char]39)PauseFeatureUpdatesStartTime$([System.Char]39) -Value `$Start`n"
      "`t`t`tSet-ItemProperty @params -Name $([System.Char]39)PauseFeatureUpdatesEndTime$([System.Char]39) -Value `$End`n"
      "`t`t`tSet-ItemProperty @params -Name $([System.Char]39)PauseQualityUpdatesStartTime$([System.Char]39) -Value `$Start`n"
      "`t`t`tSet-ItemProperty @params -Name $([System.Char]39)PauseQualityUpdatesEndTime$([System.Char]39) -Value `$End`n"
      "`t`t`tSet-ItemProperty @params -Name $([System.Char]39)PauseUpdatesStartTime$([System.Char]39) -Value `$Start`n"
      "`t`t`tSet-ItemProperty @params -Name $([System.Char]39)PauseUpdatesExpiryTime$([System.Char]39) -Value `$End`n"
      "`t`t"
      #endregion
      {
        $Formatter = {
          $Args[0].ToString( "yyyy'-'MM'-'dd'T'HH':'mm':'ssK" )
        }
        $Now = [DateTime]::UtcNow
        $Start = & $Formatter $Now
        $End = & $Formatter $Now.AddDays( 7 )
        $params = @{
          LiteralPath = 'Registry::HKLM\SOFTWARE\Microsoft\WindowsUpdate\UX\Settings'
          Type        = 'String'
          Force       = $true
        }
        Set-ItemProperty @params -Name 'PauseFeatureUpdatesStartTime' -Value $Start
        Set-ItemProperty @params -Name 'PauseFeatureUpdatesEndTime' -Value $End
        Set-ItemProperty @params -Name 'PauseQualityUpdatesStartTime' -Value $Start
        Set-ItemProperty @params -Name 'PauseQualityUpdatesEndTime' -Value $End
        Set-ItemProperty @params -Name 'PauseUpdatesStartTime' -Value $Start
        Set-ItemProperty @params -Name 'PauseUpdatesExpiryTime' -Value $End


        # Register-ScheduledTask -TaskName 'PauseWindowsUpdate' -Xml $( Get-Content -LiteralPath 'C:\Windows\Setup\Scripts\PauseWindowsUpdate.xml' -Raw );
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\Pause Windows Update-Command within Scheduled Task.ps1')
        $XmlWriter.WriteString(${File Pause Windows Update-Command within Scheduled Task.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion
    #region | "PauseWindowsUpdate.xml" XML Element | Pause Windows Update until AFTER WSUS construction |
    ${file PauseWindowsUpdate.xml} = New-TemporaryFile
    ${XmlFile PauseWindowsUpdate.xml} = Rename-Item -Path "${file PauseWindowsUpdate.xml}" -NewName $(${file PauseWindowsUpdate.xml}.BaseName + '.xml') -PassThru
    ${XmlWriterSettings PauseWindowsUpdate.xml} = [System.Xml.XmlWriterSettings]::New()
    ${XmlWriterSettings PauseWindowsUpdate.xml}.OmitXmlDeclaration = $true
    ${XmlWriterSettings PauseWindowsUpdate.xml}.NewLineOnAttributes = $false
    ${XmlWriterSettings PauseWindowsUpdate.xml}.Indent = $true
    ${XmlWriter PauseWindowsUpdate.xml} = [System.Xml.XmlWriter]::Create(${XmlFile PauseWindowsUpdate.xml}.FullName,${XmlWriterSettings PauseWindowsUpdate.xml})

    ${XmlWriter PauseWindowsUpdate.xml}.WriteStartDocument()
      ${XmlWriter PauseWindowsUpdate.xml}.WriteStartElement('Task','http://schemas.microsoft.com/windows/2004/02/mit/task')
        ${XmlWriter PauseWindowsUpdate.xml}.WriteAttributeString('Version','1.2')

          ${XmlWriter PauseWindowsUpdate.xml}.WriteStartElement('Triggers')
            ${XmlWriter PauseWindowsUpdate.xml}.WriteStartElement('BootTrigger')
              ${XmlWriter PauseWindowsUpdate.xml}.WriteStartElement('Repetition')
                ${XmlWriter PauseWindowsUpdate.xml}.WriteElementString('Interval','P1D')
                ${XmlWriter PauseWindowsUpdate.xml}.WriteElementString('StopAtDurationEnd','false')
              ${XmlWriter PauseWindowsUpdate.xml}.WriteEndElement()
              ${XmlWriter PauseWindowsUpdate.xml}.WriteElementString('Enabled','true')
            ${XmlWriter PauseWindowsUpdate.xml}.WriteEndElement()
          ${XmlWriter PauseWindowsUpdate.xml}.WriteEndElement()

          ${XmlWriter PauseWindowsUpdate.xml}.WriteStartElement('Principals')
            ${XmlWriter PauseWindowsUpdate.xml}.WriteStartElement('Principal')
              ${XmlWriter PauseWindowsUpdate.xml}.WriteAttributeString('id','Author')
                ${XmlWriter PauseWindowsUpdate.xml}.WriteElementString('UserId','S-1-5-19')
                ${XmlWriter PauseWindowsUpdate.xml}.WriteElementString('RunLevel','LeastPrivilege')
            ${XmlWriter PauseWindowsUpdate.xml}.WriteEndElement()
          ${XmlWriter PauseWindowsUpdate.xml}.WriteEndElement()

          ${XmlWriter PauseWindowsUpdate.xml}.WriteStartElement('Settings')
            ${XmlWriter PauseWindowsUpdate.xml}.WriteElementString('MultipleInstancesPolicy','IgnoreNew')
            ${XmlWriter PauseWindowsUpdate.xml}.WriteElementString('DisallowStartIfOnBatteries','false')
            ${XmlWriter PauseWindowsUpdate.xml}.WriteElementString('StopIfGoingOnBatteries','false')
            ${XmlWriter PauseWindowsUpdate.xml}.WriteElementString('AllowHardTerminate','true')
            ${XmlWriter PauseWindowsUpdate.xml}.WriteElementString('StartWhenAvailable','false')
            ${XmlWriter PauseWindowsUpdate.xml}.WriteElementString('RunOnlyIfNetworkAvailable','false')
            ${XmlWriter PauseWindowsUpdate.xml}.WriteStartElement('IdleSettings')
              ${XmlWriter PauseWindowsUpdate.xml}.WriteElementString('StopOnIdleEnd','true')
              ${XmlWriter PauseWindowsUpdate.xml}.WriteElementString('RestartOnIdle','false')
            ${XmlWriter PauseWindowsUpdate.xml}.WriteEndElement()
            ${XmlWriter PauseWindowsUpdate.xml}.WriteElementString('AllowStartOnDemand','true')
            ${XmlWriter PauseWindowsUpdate.xml}.WriteElementString('Enabled','true')
            ${XmlWriter PauseWindowsUpdate.xml}.WriteElementString('Hidden','false')
            ${XmlWriter PauseWindowsUpdate.xml}.WriteElementString('RunOnlyIfIdle','false')
            ${XmlWriter PauseWindowsUpdate.xml}.WriteElementString('WakeToRun','false')
            ${XmlWriter PauseWindowsUpdate.xml}.WriteElementString('ExecutionTimeLimit','PT72H')
            ${XmlWriter PauseWindowsUpdate.xml}.WriteElementString('Priority','7')
          ${XmlWriter PauseWindowsUpdate.xml}.WriteEndElement()

          ${XmlWriter PauseWindowsUpdate.xml}.WriteStartElement('Actions')
            ${XmlWriter PauseWindowsUpdate.xml}.WriteAttributeString('Context','Author')
            ${XmlWriter PauseWindowsUpdate.xml}.WriteStartElement('Exec')
              ${XmlWriter PauseWindowsUpdate.xml}.WriteElementString('Command','C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe')
              ${XmlWriter PauseWindowsUpdate.xml}.WriteElementString('Arguments',"-Command $([System.Char]34)gc -raw -LiteralPath $([System.Char]39)C:\Windows\Setup\Scripts\Pause Windows Update-Command within Scheduled Task.ps1$([System.Char]39) | iex -Verbose$([System.Char]34)")
            ${XmlWriter PauseWindowsUpdate.xml}.WriteEndElement()
          ${XmlWriter PauseWindowsUpdate.xml}.WriteEndElement()
      ${XmlWriter PauseWindowsUpdate.xml}.WriteEndElement()
    ${XmlWriter PauseWindowsUpdate.xml}.WriteEndDocument()
    ${XmlWriter PauseWindowsUpdate.xml}.Close()
    Remove-Variable -Name 'XmlWriter PauseWindowsUpdate.xml'
    Remove-Variable -Name 'XmlWriterSettings PauseWindowsUpdate.xml'

    ${File PauseWindowsUpdate.xml Here-String} = $(
      $([System.Char]10)
      (
        Get-Content -Path $XmlFile.FullName | ForEach-Object -Process {"`t`t`t" + $_}
      ) -join $([System.Char]10)
      $([System.Char]10) + $([System.Char]9) + $([System.Char]9)
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\PauseWindowsUpdate.xml')
        $XmlWriter.WriteString(${File PauseWindowsUpdate.xml Here-String})
      $XmlWriter.WriteEndElement()
    #endregion
    #region | "Windows Update-PAUSE.ps1" XML Element | Pause Windows Update until AFTER WSUS construction |
    ${File Windows Update-PAUSE.ps1 Here-String} = $(
      #region |  |
      "`n"
      "`t`t`tRegister-ScheduledTask -TaskName $([System.Char]39)PauseWindowsUpdate$([System.Char]39) -Xml `$( Get-Content -LiteralPath $([System.Char]39)C:\Windows\Setup\Scripts\PauseWindowsUpdate.xml$([System.Char]39) -Raw );`n"
      "`t`t"
      #endregion
      {
        Register-ScheduledTask -TaskName 'PauseWindowsUpdate' -Xml $( Get-Content -LiteralPath 'C:\Windows\Setup\Scripts\PauseWindowsUpdate.xml' -Raw );
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\Windows Update-PAUSE.ps1')
        $XmlWriter.WriteString(${File Windows Update-PAUSE.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion
    #region | "MoveActiveHours.xml" XML Element | Pause Windows Update until AFTER WSUS construction |
    #endregion

    #region | "No non-GPO audit policy settings.ps1" Here-String and XML Element |
    ${File No non-GPO audit policy settings.ps1 Here-String} = $(
      "`n"
      "`t`t`t# Explicitly DISABLE the $([System.Char]34)Force audit policy subcategory settings to override audit policy category settings$([System.Char]34) policy setting |`n"
      "`t`t`t# This project applies policy settings specific to audit policy through Group Policy Objects.`n"
      "`t`t`t# Reference: $([System.Char]39)https://learn.microsoft.com/en-us/troubleshoot/windows-server/windows-security/security-auditing-settings-not-applied-when-deploy-domain-based-policy#symptoms$([System.Char]39)`n"
      "`t`t`t`$HT = @{`n"
      "`t`t`t  Path  = $([System.Char]39)HKLM:\SYSTEM\CurrentControlSet\Control\Lsa$([System.Char]39)`n"
      "`t`t`t  Name  = $([System.Char]39)SCENoApplyLegacyAuditPolicy$([System.Char]39)`n"
      "`t`t`t  Value = $([System.Char]39)0$([System.Char]39)`n"
      "`t`t`t}`n"
      "`t`t`tSet-ItemProperty @HT`n"
      "`t`t"
      {
        # Explicitly DISABLE the "Force audit policy subcategory settings to override audit policy category settings" policy setting |
        # This project applies policy settings specific to audit policy through Group Policy Objects.
        # Reference: 'https://learn.microsoft.com/en-us/troubleshoot/windows-server/windows-security/security-auditing-settings-not-applied-when-deploy-domain-based-policy#symptoms'
        $HT = @{
          Path  = 'HKLM:\SYSTEM\CurrentControlSet\Control\Lsa'
          Name  = 'SCENoApplyLegacyAuditPolicy'
          Value = '0'
        }
        Set-ItemProperty @HT
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\No non-GPO audit policy settings.ps1')
        $XmlWriter.WriteString(${File No non-GPO audit policy settings.ps1 Here-String})
      $XmlWriter.WriteEndElement()

    #endregion
    #region | "WSMan Envelope Size.ps1" Here-String and XML Element | DSC fails if the WSMan protocol isn't configured to transmit content in a sufficiently large 'envelope' |
    ${File WSMan Envelope Size.ps1 Here-String} = $(
      "`n"
      "`t`t`tSet-Item -Path $([System.Char]39)WSMan:\localhost\MaxEnvelopeSizeKb$([System.Char]39) -Value $([System.Char]39)24576$([System.Char]39) -Force`n"
      "`t`t"
      {
        Set-Item -Path 'WSMan:\localhost\MaxEnvelopeSizeKb' -Value '24576' -Force
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\WSMan Envelope Size.ps1')
        $XmlWriter.WriteString(${File WSMan Envelope Size.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion
    #region | "Environment Variables-System Scope.ps1" Here-String and XML Element |
    ${File Environment Variables-System Scope.ps1 Here-String} = $(
      "`n"
      "`t`t`t`${04f1in3 path} = $([System.Char]34)`$env:SystemDrive\$__DirectoryForDscConfigs\Instant-ADCS$([System.Char]34)`n"
      "`t`t`t`${HKLM Sess Mgr Env} = $([System.Char]39)HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment$([System.Char]39)`n"
      "`t`t`t`$HT = @{`n"
      "`t`t`t  $([System.Char]39)DSC_CFG_ROOT$([System.Char]39)   = $([System.Char]34)`$env:SystemDrive\$__DirectoryForDscConfigs$([System.Char]34)`n"
      "`t`t`t  $([System.Char]39)04f1in3$([System.Char]39)        = `${04f1in3 path}`n"
      "`t`t`t  $([System.Char]39)SystemModules$([System.Char]39)  = $([System.Char]34)`$env:WinDir\System32\WindowsPowerShell\v1.0\Modules$([System.Char]34)`n"
      "`t`t`t  $([System.Char]39)SysMods$([System.Char]39)        = $([System.Char]34)`$env:WinDir\System32\WindowsPowerShell\v1.0\Modules$([System.Char]34)`n"
      "`t`t`t  $([System.Char]39)SMs$([System.Char]39)            = $([System.Char]34)`$env:WinDir\System32\WindowsPowerShell\v1.0\Modules$([System.Char]34)`n"
      "`t`t`t  $([System.Char]39)ProgramModules$([System.Char]39) = $([System.Char]34)`$env:ProgramFiles\WindowsPowerShell\Modules$([System.Char]34)`n"
      "`t`t`t  $([System.Char]39)ProgMods$([System.Char]39)       = $([System.Char]34)`$env:ProgramFiles\WindowsPowerShell\Modules$([System.Char]34)`n"
      "`t`t`t  $([System.Char]39)PMs$([System.Char]39)            = $([System.Char]34)`$env:ProgramFiles\WindowsPowerShell\Modules$([System.Char]34)`n"
      "`t`t`t}`n"
      "`t`t`t`$DictionaryEntrySet = `$HT.GetEnumerator() | Write-Output`n"
      "`t`t`tforeach (`$DictionaryEntry in `$DictionaryEntrySet) {`n"
      "`t`t`t  try {`n"
      "`t`t`t    Get-ItemProperty -Path `${HKLM Sess Mgr Env} -Name `$DictionaryEntry.Name -ErrorAction $([System.Char]39)Stop$([System.Char]39) | Out-Null`n"
      "`t`t`t  } catch {`n"
      "`t`t`t    New-ItemProperty -Path `${HKLM Sess Mgr Env} -Name `$DictionaryEntry.Name -Value `$DictionaryEntry.Value | Out-Null`n"
      "`t`t`t  }`n"
      "`t`t`t}`n"
      "`t`t"
      {
        ${04f1in3 path} = "$env:SystemDrive\$__DirectoryForDscConfigs\Instant-ADCS"
        ${HKLM Sess Mgr Env} = 'HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment'
        $HT = @{
          'DSC_CFG_ROOT'   = "$env:SystemDrive\$__DirectoryForDscConfigs"
          '04f1in3'        = ${04f1in3 path}
          'SystemModules'  = "$env:WinDir\System32\WindowsPowerShell\v1.0\Modules"
          'SysMods'        = "$env:WinDir\System32\WindowsPowerShell\v1.0\Modules"
          'SMs'            = "$env:WinDir\System32\WindowsPowerShell\v1.0\Modules"
          'ProgramModules' = "$env:ProgramFiles\WindowsPowerShell\Modules"
          'ProgMods'       = "$env:ProgramFiles\WindowsPowerShell\Modules"
          'PMs'            = "$env:ProgramFiles\WindowsPowerShell\Modules"
        }
        $DictionaryEntrySet = $HT.GetEnumerator() | Write-Output
        foreach ($DictionaryEntry in $DictionaryEntrySet) {
          try {
            Get-ItemProperty -Path ${HKLM Sess Mgr Env} -Name $DictionaryEntry.Name -ErrorAction 'Stop' | Out-Null
          } catch {
            New-ItemProperty -Path ${HKLM Sess Mgr Env} -Name $DictionaryEntry.Name -Value $DictionaryEntry.Value | Out-Null
          }
        }
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\Environment Variables-System Scope.ps1')
        $XmlWriter.WriteString(${File Environment Variables-System Scope.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion
    #region | "DSC Structural-Environmental Data Copy Operation.ps1" Here-String and XML Element |
    ${File DSC Structural-Environmental Data Copy Operation.ps1 Here-String} = $(
      "`n"
      "`t`t`t# Copy files of DSC structural and environmental data from external storage to local drive`n"
      "`t`t`t`$folder = try {`n"
      "`t`t`t  Get-Item -Path $([System.Char]34)`$env:SystemDrive\$__DirectoryForDscConfigs$([System.Char]34) -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  New-Item -Path $([System.Char]34)`$env:SystemDrive\$__DirectoryForDscConfigs$([System.Char]34) -ItemType $([System.Char]39)Directory$([System.Char]39) -Force`n"
      "`t`t`t}`n"
      "`t`t`tCopy-Item -Path $([System.Char]34)`$usb1\Instant-ADCS$([System.Char]34) -Destination `$folder.FullName -Recurse`n"
      "`t`t"
      {
        # Copy files of DSC structural and environmental data from external storage to local drive
        $folder = try {
          Get-Item -Path "$env:SystemDrive\$__DirectoryForDscConfigs" -ErrorAction 'Stop'
        } catch {
          New-Item -Path "$env:SystemDrive\$__DirectoryForDscConfigs" -ItemType 'Directory' -Force
        }
        Copy-Item -Path "$usb1\Instant-ADCS" -Destination $folder.FullName -Recurse
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\DSC Structural-Environmental Data Copy Operation.ps1')
        $XmlWriter.WriteString(${File DSC Structural-Environmental Data Copy Operation.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion
    #region | "Module Extraction-Installation.ps1" Here-String and XML Element |
    ${File Module Extraction-Installation.ps1 Here-String} = $(
      "`n"
      "`t`t`t# Extract all Windows PowerShell non-DSC Resource modules`n"
      "`t`t`tGet-ChildItem -Path $([System.Char]34)`$env:SystemDrive\$__DirectoryForDscConfigs\Installs\Modules\5.1$([System.Char]34) -Filter $([System.Char]34)*.zip$([System.Char]34) -PipelineVariable $([System.Char]39)file$([System.Char]39) -Recurse | ForEach-Object -Process {Expand-Archive -Path `$file.FullName -DestinationPath $([System.Char]34)`$env:ProgramFiles\WindowsPowerShell\Modules$([System.Char]34) -Verbose -Force}`n"
      "`t`t`t# Extract all DSC Resource modules`n"
      "`t`t`tGet-ChildItem -Path $([System.Char]34)`$env:SystemDrive\$__DirectoryForDscConfigs\DSC Resource Modules$([System.Char]34) -Filter $([System.Char]34)*.zip$([System.Char]34) -PipelineVariable $([System.Char]39)file$([System.Char]39) -Recurse | ForEach-Object -Process {Expand-Archive -Path `$file.FullName -DestinationPath $([System.Char]34)`$env:ProgramFiles\WindowsPowerShell\Modules$([System.Char]34) -Verbose -Force}`n"
      "`t`t"
      {
        # Extract all Windows PowerShell non-DSC Resource modules
        Get-ChildItem -Path "$env:SystemDrive\$__DirectoryForDscConfigs\Installs\Modules\5.1" -Filter "*.zip" -PipelineVariable 'file' -Recurse | ForEach-Object -Process {Expand-Archive -Path $file.FullName -DestinationPath "$env:ProgramFiles\WindowsPowerShell\Modules" -Verbose -Force}
        # Extract all DSC Resource modules
        Get-ChildItem -Path "$env:SystemDrive\$__DirectoryForDscConfigs\DSC Resource Modules" -Filter "*.zip" -PipelineVariable 'file' -Recurse | ForEach-Object -Process {Expand-Archive -Path $file.FullName -DestinationPath "$env:ProgramFiles\WindowsPowerShell\Modules" -Verbose -Force}
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\Module Extraction-Installation.ps1')
        $XmlWriter.WriteString(${File Module Extraction-Installation.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion
    #region | "Password Length-Unlimited.ps1" Here-String and XML Element |
    ${File Password Length-Unlimited.ps1 Here-String} = $(
      "`n"
      "`t`t`tnet.exe accounts /maxpwage:UNLIMITED`n"
      "`t`t"
      {
        net.exe accounts /maxpwage:UNLIMITED
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\Password Length-Unlimited.ps1')
        $XmlWriter.WriteString(${File Password Length-Unlimited.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion
    #region | "Long File-System Path Support-ENABLED.ps1" Here-String and XML Element |
    ${File Long File-System Path Support-ENABLED.ps1 Here-String} = $(
      "`n"
      "`t`t`t# allow very long paths in the file system |`n"
      "`t`t`treg.exe add $([System.Char]34)HKLM\SYSTEM\CurrentControlSet\Control\FileSystem$([System.Char]34) /v $([System.Char]34)LongPathsEnabled$([System.Char]34) /t $([System.Char]34)REG_DWORD$([System.Char]34) /d $([System.Char]34)1$([System.Char]34) /f`n"
      "`t`t"
      {
        # allow very long paths in the file system |
        reg.exe add "HKLM\SYSTEM\CurrentControlSet\Control\FileSystem" /v "LongPathsEnabled" /t "REG_DWORD" /d "1" /f
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\Long File-System Path Support-ENABLED.ps1')
        $XmlWriter.WriteString(${File Long File-System Path Support-ENABLED.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion
    #region | "Cloud-Optimized Content-DISABLED.ps1" Here-String and XML Element |
    ${File Cloud-Optimized Content-DISABLED.ps1 Here-String} = $(
      "`n"
      "`t`t`treg.exe add $([System.Char]34)HKLM\Software\Policies\Microsoft\Windows\CloudContent$([System.Char]34) /v $([System.Char]34)DisableCloudOptimizedContent$([System.Char]34) /t $([System.Char]34)REG_DWORD$([System.Char]34) /d $([System.Char]34)1$([System.Char]34) /f`n"
      "`t`t`t[System.Diagnostics.EventLog]::CreateEventSource($([System.Char]39)UnattendGenerator$([System.Char]39),$([System.Char]39)Application$([System.Char]39))`n"
      "`t`t"
      {
        reg.exe add "HKLM\Software\Policies\Microsoft\Windows\CloudContent" /v "DisableCloudOptimizedContent" /t "REG_DWORD" /d "1" /f
        [System.Diagnostics.EventLog]::CreateEventSource('UnattendGenerator','Application')
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\Cloud-Optimized Content-DISABLED.ps1')
        $XmlWriter.WriteString(${File Cloud-Optimized Content-DISABLED.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion
    #region | "Register Scheduled Task to Unlock Start Layout.ps1" Here-String and XML Element |
    ${File Register Scheduled Task to Unlock Start Layout.ps1 Here-String} = $(
      "`n"
      "`t`t`t`$InputHT = @{`n"
      "`t`t`t  TaskName = $([System.Char]39)UnlockStartLayout$([System.Char]39)`n"
      "`t`t`t  Xml      = `$(Get-Content -LiteralPath $([System.Char]39)C:\Windows\Setup\Scripts\UnlockStartLayout.xml$([System.Char]39) -Raw)`n"
      "`t`t`t  Verbose  = `$true`n"
      "`t`t`t}`n"
      "`t`t`tRegister-ScheduledTask @InputHT`n"
      "`t`t"
      {
        $InputHT = @{
          TaskName = 'UnlockStartLayout'
          Xml      = $(Get-Content -LiteralPath 'C:\Windows\Setup\Scripts\UnlockStartLayout.xml' -Raw)
          Verbose  = $true
        }
        Register-ScheduledTask @InputHT
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\Register Scheduled Task to Unlock Start Layout.ps1')
        $XmlWriter.WriteString(${File Register Scheduled Task to Unlock Start Layout.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion
    #region | "Audit Process Launch-ENABLED.ps1" Here-String and XML Element |
    ${File Audit Process Launch-ENABLED.ps1 Here-String} = $(
      "`n"
      "`t`t`t# The GUID $([System.Char]34){0CCE922B-69AE-11D9-BED3-505054503030}$([System.Char]34) identifies the $([System.Char]39)Process Creation$([System.Char]39) audit subcategory.`n"
      "`t`t`t# The $([System.Char]39)Process Creation$([System.Char]39) subcategory audits events generated when a process is created or starts.`n"
      "`t`t`t# The name of the user/app that launched the process is also audited.`n"
      "`t`t`tauditpol.exe /set /subcategory:$([System.Char]34){0CCE922B-69AE-11D9-BED3-505054503030}$([System.Char]34) /success:enable /failure:enable`n"
      "`t`t`treg.exe add $([System.Char]34)HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Audit$([System.Char]34) /v $([System.Char]34)ProcessCreationIncludeCmdLine_Enabled$([System.Char]34) /t $([System.Char]34)REG_DWORD$([System.Char]34) /d $([System.Char]34)1$([System.Char]34) /f`n"
      "`t`t"
      {
        # The GUID "{0CCE922B-69AE-11D9-BED3-505054503030}" identifies the 'Process Creation' audit subcategory.
        # The 'Process Creation' subcategory audits events generated when a process is created or starts.
        # The name of the user/app that launched the process is also audited.
        auditpol.exe /set /subcategory:"{0CCE922B-69AE-11D9-BED3-505054503030}" /success:enable /failure:enable
        reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Audit" /v "ProcessCreationIncludeCmdLine_Enabled" /t "REG_DWORD" /d "1" /f
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\Audit Process Launch-ENABLED.ps1')
        $XmlWriter.WriteString(${File Audit Process Launch-ENABLED.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion
    #region | "Status Messages Highly Detailed.ps1" Here-String and XML Element |
    ${File Status Messages Highly Detailed.ps1 Here-String} = $(
      "`n"
      "`t`t`t# Display highly detailed status messages | gpedit.msc com adm sys |`n"
      "`t`t`ttry {`n"
      "`t`t`t  Get-ItemProperty -Path $([System.Char]34)HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System$([System.Char]34) -Name $([System.Char]39)VerboseStatus$([System.Char]39) -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  New-ItemProperty -Path $([System.Char]34)HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System$([System.Char]34) -Name $([System.Char]39)VerboseStatus$([System.Char]39) -Type $([System.Char]39)DWORD$([System.Char]39) -Value $([System.Char]39)1$([System.Char]39)`n"
      "`t`t`t}`n"
      "`t`t"
      {
        # Display highly detailed status messages | gpedit.msc com adm sys |
        try {
          Get-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name 'VerboseStatus' -ErrorAction 'Stop'
        } catch {
          New-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name 'VerboseStatus' -Type 'DWORD' -Value '1'
        }
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\Status Messages Highly Detailed.ps1')
        $XmlWriter.WriteString(${File Status Messages Highly Detailed.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion
    #region | "SetStartPins.ps1" Here-String and XML Element |
    ${File SetStartPins.ps1 Here-String} = $(
      "`n"
      "`t`t`t`$json = $([System.Char]39)`n"
      "`t`t`t  {`n"
      "`t`t`t    $([System.Char]34)pinnedList$([System.Char]34):[`n"
      "`t`t`t      {$([System.Char]34)desktopAppLink$([System.Char]34):$([System.Char]34)%APPDATA%\\Microsoft\\Windows\\Start Menu\\Programs\\Windows PowerShell\\Windows PowerShell.lnk$([System.Char]34)},`n"
      "`t`t`t      {$([System.Char]34)desktopAppLink$([System.Char]34):$([System.Char]34)%ALLUSERSPROFILE%\\Microsoft\\Windows\\Start Menu\\Programs\\Visual Studio Code\\Visual Studio Code.lnk$([System.Char]34)},`n"
      "`t`t`t      {$([System.Char]34)desktopAppLink$([System.Char]34):$([System.Char]34)%ALLUSERSPROFILE%\\Microsoft\\Windows\\Start Menu\\Programs\\PowerShell\\PowerShell 7 (x64).lnk$([System.Char]34)},`n"
      "`t`t`t      {$([System.Char]34)desktopAppLink$([System.Char]34):$([System.Char]34)%ALLUSERSPROFILE%\\Microsoft\\Windows\\Start Menu\\Programs\\OneDrive.lnk$([System.Char]34)}`n"
      "`t`t`t    ]`n"
      "`t`t`t  }`n"
      "`t`t`t$([System.Char]39)`n"
      "`t`t`t`$key = $([System.Char]39)Registry::HKLM\SOFTWARE\Microsoft\PolicyManager\current\device$([System.Char]39)`n"
      "`t`t`tNew-Item -Path `$key -ItemType $([System.Char]39)Directory$([System.Char]39) -ErrorAction $([System.Char]39)SilentlyContinue$([System.Char]39)`n"
      "`t`t`t`$key = $([System.Char]39)Registry::HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\Start$([System.Char]39)`n"
      "`t`t`tNew-Item -Path `$key -ItemType $([System.Char]39)Directory$([System.Char]39) -ErrorAction $([System.Char]39)SilentlyContinue$([System.Char]39)`n"
      "`t`t`tSet-ItemProperty -LiteralPath `$key -Name $([System.Char]39)ConfigureStartPins$([System.Char]39) -Value `$json -Type $([System.Char]39)String$([System.Char]39)`n"
      "`t`t"

      { # SetStartPins.ps1 Plain-Text | Converted to ${File SetStartPins.ps1 Here-String} with 'ConvertTo-HereStringCompatible' |
        $json = '
          {
            "pinnedList":[
              {"desktopAppLink":"%APPDATA%\\Microsoft\\Windows\\Start Menu\\Programs\\Windows PowerShell\\Windows PowerShell.lnk"},
              {"desktopAppLink":"%ALLUSERSPROFILE%\\Microsoft\\Windows\\Start Menu\\Programs\\Visual Studio Code\\Visual Studio Code.lnk"},
              {"desktopAppLink":"%ALLUSERSPROFILE%\\Microsoft\\Windows\\Start Menu\\Programs\\PowerShell\\PowerShell 7 (x64).lnk"},
              {"desktopAppLink":"%ALLUSERSPROFILE%\\Microsoft\\Windows\\Start Menu\\Programs\\OneDrive.lnk"}
            ]
          }
        '
        $key = 'Registry::HKLM\SOFTWARE\Microsoft\PolicyManager\current\device'
        New-Item -Path $key -ItemType 'Directory' -ErrorAction 'SilentlyContinue'
        $key = 'Registry::HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\Start'
        New-Item -Path $key -ItemType 'Directory' -ErrorAction 'SilentlyContinue'
        Set-ItemProperty -LiteralPath $key -Name 'ConfigureStartPins' -Value $json -Type 'String'
      } | Out-Null
    ) -join ''
    <#
      Export-StartLayout -Path "$env:NoSync\startpinlayout.json"
      $json = Get-Content "$env:NoSync\startpinlayout.json" -Raw
    #>
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\SetStartPins.ps1')
        $XmlWriter.WriteString(${File SetStartPins.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion
    #region | "Graphical Settings Part 1.ps1" Here-String and XML Element |
    ${File Graphical Settings Part 1.ps1 Here-String} = $(
      #region |  |
      "`n"
      "`t`t`t`$VisualEffects = @(`n"
      "`t`t`t  $([System.Char]39)ControlAnimations$([System.Char]39)`n"
      "`t`t`t  $([System.Char]39)AnimateMinMax$([System.Char]39)`n"
      "`t`t`t  $([System.Char]39)TaskbarAnimations$([System.Char]39)`n"
      "`t`t`t  $([System.Char]39)DWMAeroPeekEnabled$([System.Char]39)`n"
      "`t`t`t  $([System.Char]39)MenuAnimation$([System.Char]39)`n"
      "`t`t`t  $([System.Char]39)TooltipAnimation$([System.Char]39)`n"
      "`t`t`t  $([System.Char]39)SelectionFade$([System.Char]39)`n"
      "`t`t`t  $([System.Char]39)DWMSaveThumbnailEnabled$([System.Char]39)`n"
      "`t`t`t  $([System.Char]39)CursorShadow$([System.Char]39)`n"
      "`t`t`t  $([System.Char]39)ListviewShadow$([System.Char]39)`n"
      "`t`t`t  $([System.Char]39)ThumbnailsOrIcon$([System.Char]39)`n"
      "`t`t`t  $([System.Char]39)ListviewAlphaSelect$([System.Char]39)`n"
      "`t`t`t  $([System.Char]39)DragFullWindows$([System.Char]39)`n"
      "`t`t`t  $([System.Char]39)ComboBoxAnimation$([System.Char]39)`n"
      "`t`t`t  $([System.Char]39)FontSmoothing$([System.Char]39)`n"
      "`t`t`t  $([System.Char]39)ListBoxSmoothScrolling$([System.Char]39)`n"
      "`t`t`t  $([System.Char]39)DropShadow$([System.Char]39)`n"
      "`t`t`t)`n"
      "`t`t`tforeach (`$VisualEffect in `$VisualEffects) {`n"
      "`t`t`t  `$InputHT = @{`n"
      "`t`t`t    LiteralPath = $([System.Char]34)Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\`$VisualEffect$([System.Char]34)`n"
      "`t`t`t    Name        = $([System.Char]39)DefaultValue$([System.Char]39)`n"
      "`t`t`t    Value       = $([System.Char]39)0$([System.Char]39)`n"
      "`t`t`t    Type        = $([System.Char]39)DWord$([System.Char]39)`n"
      "`t`t`t    Force       = `$true`n"
      "`t`t`t    Verbose     = `$true`n"
      "`t`t`t  }`n"
      "`t`t`t  Set-ItemProperty @InputHT`n"
      "`t`t`t}`n"
      "`t`t"
      #endregion
      {
        $VisualEffects = @(
          'ControlAnimations'
          'AnimateMinMax'
          'TaskbarAnimations'
          'DWMAeroPeekEnabled'
          'MenuAnimation'
          'TooltipAnimation'
          'SelectionFade'
          'DWMSaveThumbnailEnabled'
          'CursorShadow'
          'ListviewShadow'
          'ThumbnailsOrIcon'
          'ListviewAlphaSelect'
          'DragFullWindows'
          'ComboBoxAnimation'
          'FontSmoothing'
          'ListBoxSmoothScrolling'
          'DropShadow'
        )
        foreach ($VisualEffect in $VisualEffects) {
          $InputHT = @{
            LiteralPath = "Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\$VisualEffect"
            Name        = 'DefaultValue'
            Value       = '0'
            Type        = 'DWord'
            Force       = $true
            Verbose     = $true
          }
          Set-ItemProperty @InputHT
        }
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\Graphical Settings Part 1.ps1')
        $XmlWriter.WriteString(${File Graphical Settings Part 1.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion
    #region | "Disable Automatic Restart SignOn-DISABLED.ps1" Here-String and XML Element |
    ${File Disable Automatic Restart SignOn-DISABLED.ps1 Here-String} = $(
      "`n"
      "`t`t`t# Leave automatic restart sign-on ENABLED`n"
      "`t`t`treg.exe add $([System.Char]34)HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System$([System.Char]34) /v $([System.Char]34)DisableAutomaticRestartSignOn$([System.Char]34) /t $([System.Char]34)REG_DWORD$([System.Char]34) /d $([System.Char]34)1$([System.Char]34) /f`n"
      "`t`t"
      {
        # Leave automatic restart sign-on ENABLED
        reg.exe add "HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System" /v "DisableAutomaticRestartSignOn" /t "REG_DWORD" /d "1" /f
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\Disable Automatic Restart SignOn-DISABLED.ps1')
        $XmlWriter.WriteString(${File Disable Automatic Restart SignOn-DISABLED.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion
    #region | "GetLockScreenImage.ps1" Here-String | Returns an image as a byte array | Doesn't actually set the lockscreen image |
    ${File GetLockScreenImage.ps1 Here-String} = $(
      <# Original |
        foreach ($drive in [System.IO.DriveInfo]::GetDrives()) {
          if ($found = Join-Path -Path $drive.RootDirectory -ChildPath 'lockscreen.png' -Resolve -ErrorAction 'SilentlyContinue') {
            return [System.IO.File]::ReadAllBytes($found)
          }
        }
        'Cannot find any files that match pattern.' | Write-Warning
      #>
      <# New |
        foreach ($drive in [System.IO.DriveInfo]::GetDrives()) {
          $HT = @{
            Path        = $drive.RootDirectory
            ChildPath   = 'lockscreen.png'
            Resolve     = $true
            ErrorAction = 'SilentlyContinue'
          }
          $found = Join-Path @HT
          if ($found) {
            return [System.IO.File]::ReadAllBytes($found)
          }
        }
        # 'Cannot find any files that match pattern.' | Write-Warning
        return [System.IO.File]::ReadAllBytes("$env:DSC_CFG_ROOT\OfflineDSC\lockscreen.png")
      #>


      "`n"
      "`t`t`tforeach (`$drive in [System.IO.DriveInfo]::GetDrives()) {`n"
      "`t`t`t  `$HT = @{`n"
      "`t`t`t    Path        = `$drive.RootDirectory`n"
      "`t`t`t    ChildPath   = $([System.Char]39)lockscreen.png$([System.Char]39)`n"
      "`t`t`t    Resolve     = `$true`n"
      "`t`t`t    ErrorAction = $([System.Char]39)SilentlyContinue$([System.Char]39)`n"
      "`t`t`t  }`n"
      "`t`t`t`n"
      "`t`t`t  `$found = Join-Path @HT`n"
      "`t`t`t  if (`$found) {`n"
      "`t`t`t    return [System.IO.File]::ReadAllBytes(`$found)`n"
      "`t`t`t  }`n"
      "`t`t`t}`n"
      "`t`t`t## Write-Warning -Message $([System.Char]39)Cannot find any files that match pattern.$([System.Char]39)`n"
      "`t`t`t## return [System.IO.File]::ReadAllBytes($([System.Char]34)\OfflineDSC\lockscreen.png$([System.Char]34))`n"
      "`t`t"

      { # GetLockScreenImage.ps1 Plain-Text | Converted to ${File GetLockScreenImage.ps1 Here-String} with 'ConvertTo-HereStringCompatible' |
        foreach ($drive in [System.IO.DriveInfo]::GetDrives()) {
          $HT = @{
            Path        = $drive.RootDirectory
            ChildPath   = 'lockscreen.png'
            Resolve     = $true
            ErrorAction = 'SilentlyContinue'
          }

          $found = Join-Path @HT
          if ($found) {
            return [System.IO.File]::ReadAllBytes($found)
          }
        }
        ## Write-Warning -Message 'Cannot find any files that match pattern.'
        ## return [System.IO.File]::ReadAllBytes("\OfflineDSC\lockscreen.png")
      } | Out-Null
    ) -join ''
    $XmlWriter.WriteStartElement('File')
      $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\GetLockScreenImage.ps1')
      $XmlWriter.WriteString(${File GetLockScreenImage.ps1 Here-String})
    $XmlWriter.WriteEndElement()        
    #endregion
    #region | "Lock Screen Image.ps1" Here-String and XML Element |
    ${File Lock Screen Image.ps1 Here-String} = $(
      "`n"
      "`t`t`ttry {`n"
      "`t`t`t  `$bytes = & $([System.Char]39)C:\Windows\Setup\Scripts\GetLockScreenImage.ps1$([System.Char]39)`n"
      "`t`t`t  [System.IO.File]::WriteAllBytes($([System.Char]39)C:\Windows\Setup\Scripts\LockScreenImage.png$([System.Char]39),`$bytes)`n"
      "`t`t`t  reg.exe add $([System.Char]34)HKLM\Software\Microsoft\Windows\CurrentVersion\PersonalizationCSP$([System.Char]34) /v $([System.Char]34)LockScreenImagePath$([System.Char]34) /t $([System.Char]34)REG_SZ$([System.Char]34) /d $([System.Char]34)C:\Windows\Setup\Scripts\LockScreenImage.png$([System.Char]34) /f`n"
      "`t`t`t} catch {`$_}`n"
      "`t`t"
      {
        try {
          $bytes = & 'C:\Windows\Setup\Scripts\GetLockScreenImage.ps1'
          [System.IO.File]::WriteAllBytes('C:\Windows\Setup\Scripts\LockScreenImage.png',$bytes)
          reg.exe add "HKLM\Software\Microsoft\Windows\CurrentVersion\PersonalizationCSP" /v "LockScreenImagePath" /t "REG_SZ" /d "C:\Windows\Setup\Scripts\LockScreenImage.png" /f
        } catch {$_}
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\Lock Screen Image.ps1')
        $XmlWriter.WriteString(${File Lock Screen Image.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion
    #region | "Shortcuts-Microsoft Edge-DELETE.ps1" Here-String and XML Element |
    ${File Shortcuts-Microsoft Edge-DELETE.ps1 Here-String} = $(
      "`n"
      "`t`t`t`$InputHT = @{`n"
      "`t`t`t  LiteralPath = $([System.Char]39)C:\Users\Public\Desktop\Microsoft Edge.lnk$([System.Char]39)`n"
      "`t`t`t  ErrorAction = $([System.Char]39)SilentlyContinue$([System.Char]39)`n"
      "`t`t`t  Verbose     = `$true`n"
      "`t`t`t}`n"
      "`t`t`tRemove-Item @InputHT`n"
      "`t`t"
      {
        $InputHT = @{
          LiteralPath = 'C:\Users\Public\Desktop\Microsoft Edge.lnk'
          ErrorAction = 'SilentlyContinue'
          Verbose     = $true
        }
        Remove-Item @InputHT
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\Shortcuts-Microsoft Edge-DELETE.ps1')
        $XmlWriter.WriteString(${File Shortcuts-Microsoft Edge-DELETE.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion
    #region | "UScheduler_Oobe DevHomeUpdate-REMOVE.ps1" Here-String and XML Element |
    ${File UScheduler_Oobe DevHomeUpdate-REMOVE.ps1 Here-String} = $(
      "`n"
      "`t`t`t`$HT = @{`n"
      "`t`t`t  LiteralPath = $([System.Char]39)Registry::HKLM\Software\Microsoft\WindowsUpdate\Orchestrator\UScheduler_Oobe\DevHomeUpdate$([System.Char]39)`n"
      "`t`t`t  ErrorAction = $([System.Char]39)SilentlyContinue$([System.Char]39)`n"
      "`t`t`t  Verbose     = `$true`n"
      "`t`t`t  Force       = `$true`n"
      "`t`t`t}`n"
      "`t`t`tRemove-Item @HT`n"
      "`t`t"
      {
        $HT = @{
          LiteralPath = 'Registry::HKLM\Software\Microsoft\WindowsUpdate\Orchestrator\UScheduler_Oobe\DevHomeUpdate'
          ErrorAction = 'SilentlyContinue'
          Verbose     = $true
          Force       = $true
        }
        Remove-Item @HT
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\UScheduler_Oobe DevHomeUpdate-REMOVE.ps1')
        $XmlWriter.WriteString(${File UScheduler_Oobe DevHomeUpdate-REMOVE.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion
    #region | "UScheduler_Oobe OutlookUpdate-REMOVE.ps1" Here-String and XML Element |
    ${File UScheduler_Oobe OutlookUpdate-REMOVE.ps1 Here-String} = $(
      "`n"
      "`t`t`t`$HT = @{`n"
      "`t`t`t  LiteralPath = $([System.Char]39)Registry::HKLM\Software\Microsoft\WindowsUpdate\Orchestrator\UScheduler_Oobe\OutlookUpdate$([System.Char]39)`n"
      "`t`t`t  ErrorAction = $([System.Char]39)SilentlyContinue$([System.Char]39)`n"
      "`t`t`t  Verbose     = `$true`n"
      "`t`t`t  Force       = `$true`n"
      "`t`t`t}`n"
      "`t`t`tRemove-Item @HT`n"
      "`t`t"
      {
        $HT = @{
          LiteralPath = 'Registry::HKLM\Software\Microsoft\WindowsUpdate\Orchestrator\UScheduler_Oobe\OutlookUpdate'
          ErrorAction = 'SilentlyContinue'
          Verbose     = $true
          Force       = $true
        }
        Remove-Item @HT
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\UScheduler_Oobe OutlookUpdate-REMOVE.ps1')
        $XmlWriter.WriteString(${File UScheduler_Oobe OutlookUpdate-REMOVE.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion
    #region | "Sticky Keys-DISABLED SpEcialiZe version.ps1" Here-String and XML Element |
    ${File Sticky Keys-DISABLED SpEcialiZe version.ps1 Here-String} = $(
      "`n"
      "`t`t`treg.exe add $([System.Char]34)HKU\.DEFAULT\Control Panel\Accessibility\StickyKeys$([System.Char]34) /v $([System.Char]34)Flags$([System.Char]34) /t $([System.Char]34)REG_SZ$([System.Char]34) /d $([System.Char]34)10$([System.Char]34) /f`n"
      "`t`t"
      {
        reg.exe add "HKU\.DEFAULT\Control Panel\Accessibility\StickyKeys" /v "Flags" /t "REG_SZ" /d "10" /f
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\Sticky Keys-DISABLED SpEcialiZe version.ps1')
        $XmlWriter.WriteString(${File Sticky Keys-DISABLED SpEcialiZe version.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion
    #region | "Chat AutoInstall-DISABLED.ps1" Here-String and XML Element |
    ${File Chat AutoInstall-DISABLED.ps1 Here-String} = $(
      "`n"
      "`t`t`treg.exe add $([System.Char]34)HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Communications$([System.Char]34) /v $([System.Char]34)ConfigureChatAutoInstall$([System.Char]34) /t $([System.Char]34)REG_DWORD$([System.Char]34) /d $([System.Char]34)0$([System.Char]34) /f`n"
      "`t`t"
      {
        reg.exe add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Communications" /v "ConfigureChatAutoInstall" /t "REG_DWORD" /d "0" /f
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\Chat AutoInstall-DISABLED.ps1')
        $XmlWriter.WriteString(${File Chat AutoInstall-DISABLED.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion
    #region | "News And Interests-DISALLOW.ps1" Here-String and XML Element |
    ${File News And Interests-DISALLOW.ps1 Here-String} = $(
      "`n"
      "`t`t`treg.exe add $([System.Char]34)HKLM\SOFTWARE\Policies\Microsoft\Dsh$([System.Char]34) /v $([System.Char]34)AllowNewsAndInterests$([System.Char]34) /t $([System.Char]34)REG_DWORD$([System.Char]34) /d $([System.Char]34)0$([System.Char]34) /f`n"
      "`t`t"
      {
        reg.exe add "HKLM\SOFTWARE\Policies\Microsoft\Dsh" /v "AllowNewsAndInterests" /t "REG_DWORD" /d "0" /f
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\News And Interests-DISALLOW.ps1')
        $XmlWriter.WriteString(${File News And Interests-DISALLOW.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion
    #region | "Windows Consumer Features-DISABLE.ps1" Here-String and XML Element |
    ${File Windows Consumer Features-DISABLE.ps1 Here-String} = $(
      "`n"
      "`t`t`treg.exe add $([System.Char]34)HKLM\Software\Policies\Microsoft\Windows\CloudContent$([System.Char]34) /v $([System.Char]34)DisableWindowsConsumerFeatures$([System.Char]34) /t $([System.Char]34)REG_DWORD$([System.Char]34) /d $([System.Char]34)1$([System.Char]34) /f`n"
      "`t`t"
      {
        reg.exe add "HKLM\Software\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsConsumerFeatures" /t "REG_DWORD" /d "1" /f
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\Windows Consumer Features-DISABLE.ps1')
        $XmlWriter.WriteString(${File Windows Consumer Features-DISABLE.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion
    #region | "Microsoft Edge-Prompt for MSA-DISABLED.ps1" Here-String and XML Element |
    ${File Microsoft Edge-Prompt for MSA-DISABLED.ps1 Here-String} = $(
      "`n"
      "`t`t`treg.exe add $([System.Char]34)HKLM\Software\Policies\Microsoft\Edge$([System.Char]34) /v $([System.Char]34)HideFirstRunExperience$([System.Char]34) /t $([System.Char]34)REG_DWORD$([System.Char]34) /d $([System.Char]34)1$([System.Char]34) /f`n"
      "`t`t"
      {
        reg.exe add "HKLM\Software\Policies\Microsoft\Edge" /v "HideFirstRunExperience" /t "REG_DWORD" /d "1" /f
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\Microsoft Edge-Prompt for MSA-DISABLED.ps1')
        $XmlWriter.WriteString(${File Microsoft Edge-Prompt for MSA-DISABLED.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion
    #region | "Microsoft Edge-Background Mode-DISABLED.ps1" Here-String and XML Element |
    ${File Microsoft Edge-Background Mode-DISABLED.ps1 Here-String} = $(
      "`n"
      "`t`t`treg.exe add $([System.Char]34)HKLM\Software\Policies\Microsoft\Edge\Recommended$([System.Char]34) /v $([System.Char]34)BackgroundModeEnabled$([System.Char]34) /t $([System.Char]34)REG_DWORD$([System.Char]34) /d $([System.Char]34)0$([System.Char]34) /f`n"
      "`t`t"
      {
        reg.exe add "HKLM\Software\Policies\Microsoft\Edge\Recommended" /v "BackgroundModeEnabled" /t "REG_DWORD" /d "0" /f
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\Microsoft Edge-Background Mode-DISABLED.ps1')
        $XmlWriter.WriteString(${File Microsoft Edge-Background Mode-DISABLED.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion
    #region | "Microsoft Edge-Startup Boost-DISABLED.ps1" Here-String and XML Element |
    ${File Microsoft Edge-Startup Boost-DISABLED.ps1 Here-String} = $(
      "`n"
      "`t`t`treg.exe add $([System.Char]34)HKLM\Software\Policies\Microsoft\Edge\Recommended$([System.Char]34) /v $([System.Char]34)StartupBoostEnabled$([System.Char]34) /t $([System.Char]34)REG_DWORD$([System.Char]34) /d $([System.Char]34)0$([System.Char]34) /f`n"
      "`t`t"
      {
        reg.exe add "HKLM\Software\Policies\Microsoft\Edge\Recommended" /v "StartupBoostEnabled" /t "REG_DWORD" /d "0" /f
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\Microsoft Edge-Startup Boost-DISABLED.ps1')
        $XmlWriter.WriteString(${File Microsoft Edge-Startup Boost-DISABLED.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion
    #region | "Lock Screen-Do Not Require Ctrl+Alt+Del.ps1" Here-String and XML Element |
    ${File Lock Screen-Do Not Require Ctrl+Alt+Del.ps1 Here-String} = $(
      "`n"
      "`t`t`ttry {`n"
      "`t`t`t  Get-Item -Path $([System.Char]34)HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization$([System.Char]34) -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  New-Item -Path $([System.Char]34)HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization$([System.Char]34)`n"
      "`t`t`t}`n"
      "`t`t`ttry {`n"
      "`t`t`t  Get-ItemProperty -Path $([System.Char]34)HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization$([System.Char]34) -Name $([System.Char]39)NoLockScreen$([System.Char]39) -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  New-ItemProperty -Path $([System.Char]34)HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization$([System.Char]34) -Name $([System.Char]39)NoLockScreen$([System.Char]39) -PropertyType $([System.Char]39)DWORD$([System.Char]39) -Value $([System.Char]39)1$([System.Char]39)`n"
      "`t`t`t}`n"
      "`t`t"
      {
        try {
          Get-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" -ErrorAction 'Stop'
        } catch {
          New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization"
        }
        try {
          Get-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" -Name 'NoLockScreen' -ErrorAction 'Stop'
        } catch {
          New-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" -Name 'NoLockScreen' -PropertyType 'DWORD' -Value '1'
        }
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\Lock Screen-Do Not Require Ctrl+Alt+Del.ps1')
        $XmlWriter.WriteString(${File Lock Screen-Do Not Require Ctrl+Alt+Del.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion
    #region | "Windows Command Processor Default Location.ps1" Here-String and XML Element |
    ${File Windows Command Processor Default Location.ps1 Here-String} = $(
      "`n"
      "`t`t`ttry {`n"
      "`t`t`t  Get-ItemProperty -Path $([System.Char]34)HKLM:\Software\Microsoft\Command Processor$([System.Char]34) -Name $([System.Char]39)AutoRun$([System.Char]39) -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  New-ItemProperty -Path $([System.Char]34)HKLM:\Software\Microsoft\Command Processor$([System.Char]34) -Name $([System.Char]39)AutoRun$([System.Char]39) -PropertyType $([System.Char]39)STRING$([System.Char]39) -Value $([System.Char]34)cd\ && cls$([System.Char]34)`n"
      "`t`t`t}`n"
      "`t`t"
      {
        try {
          Get-ItemProperty -Path "HKLM:\Software\Microsoft\Command Processor" -Name 'AutoRun' -ErrorAction 'Stop'
        } catch {
          New-ItemProperty -Path "HKLM:\Software\Microsoft\Command Processor" -Name 'AutoRun' -PropertyType 'STRING' -Value "cd\ && cls"
        }
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\Windows Command Processor Default Location.ps1')
        $XmlWriter.WriteString(${File Windows Command Processor Default Location.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion


    #region | "___.ps1" Here-String and XML Element |
    <#
      ${File ___.ps1 Here-String} = $(

        {

        } | Out-Null
      ) -join ''
        $XmlWriter.WriteStartElement('File')
          $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\___.ps1')
          $XmlWriter.WriteString(${File ___.ps1 Here-String})
        $XmlWriter.WriteEndElement()
    #>
    #endregion
    #region | "___.ps1" Here-String and XML Element |
    <#
      ${File ___.ps1 Here-String} = $(

        {

        } | Out-Null
      ) -join ''
        $XmlWriter.WriteStartElement('File')
          $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\___.ps1')
          $XmlWriter.WriteString(${File ___.ps1 Here-String})
        $XmlWriter.WriteEndElement()
    #>
    #endregion
    #region | "___.ps1" Here-String and XML Element |
    <#
      ${File ___.ps1 Here-String} = $(

        {

        } | Out-Null
      ) -join ''
        $XmlWriter.WriteStartElement('File')
          $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\___.ps1')
          $XmlWriter.WriteString(${File ___.ps1 Here-String})
        $XmlWriter.WriteEndElement()
    #>
    #endregion

    ${File SpEcialiZe.ps1 Here-String} = $(

      #region |  |
      "`n"
      "`t`t`t`$SpEcialiZeScriptBlocks = `$(`n"
      "`t`t`t  {& $([System.Char]39)C:\Windows\Setup\Scripts\Windows Update-PAUSE.ps1$([System.Char]39)}`n"
      "`t`t`t  {& $([System.Char]39)C:\Windows\Setup\Scripts\No non-GPO audit policy settings.ps1$([System.Char]39)}`n"
      "`t`t`t  {& $([System.Char]39)C:\Windows\Setup\Scripts\WSMan Envelope Size.ps1$([System.Char]39)}`n"
      "`t`t`t  {& $([System.Char]39)C:\Windows\Setup\Scripts\Environment Variables-System Scope.ps1$([System.Char]39)}`n"
      "`t`t`t  #{& $([System.Char]39)C:\Windows\Setup\Scripts\DSC Structural-Environmental Data Copy Operation.ps1$([System.Char]39)}`n"
      "`t`t`t  {& $([System.Char]39)C:\Windows\Setup\Scripts\Module Extraction-Installation.ps1$([System.Char]39)}`n"
      "`t`t`t  {& $([System.Char]39)C:\Windows\Setup\Scripts\Password Length-Unlimited.ps1$([System.Char]39)}`n"
      "`t`t`t  {& $([System.Char]39)C:\Windows\Setup\Scripts\Cloud-Optimized Content-DISABLED.ps1$([System.Char]39)}`n"
      "`t`t`t  {& $([System.Char]39)C:\Windows\Setup\Scripts\Register Scheduled Task to Unlock Start Layout.ps1$([System.Char]39)}`n"
      "`t`t`t  {& $([System.Char]39)C:\Windows\Setup\Scripts\Audit Process Launch-ENABLED.ps1$([System.Char]39)}`n"
      "`t`t`t  {& $([System.Char]39)C:\Windows\Setup\Scripts\Status Messages Highly Detailed.ps1$([System.Char]39)}`n"
      "`t`t`t  {& $([System.Char]39)C:\Windows\Setup\Scripts\SetStartPins.ps1$([System.Char]39)}`n"
      "`t`t`t  {& $([System.Char]39)C:\Windows\Setup\Scripts\Graphical Settings Part 1.ps1$([System.Char]39)}`n"
      "`t`t`t  {& $([System.Char]39)C:\Windows\Setup\Scripts\Disable Automatic Restart SignOn-DISABLED.ps1$([System.Char]39)}`n"
      "`t`t`t  {& $([System.Char]39)C:\Windows\Setup\Scripts\Lock Screen Image.ps1$([System.Char]39)}`n"
      "`t`t`t  {& $([System.Char]39)C:\Windows\Setup\Scripts\Shortcuts-Microsoft Edge-DELETE.ps1$([System.Char]39)}`n"
      "`t`t`t  {& $([System.Char]39)C:\Windows\Setup\Scripts\UScheduler_Oobe DevHomeUpdate-REMOVE.ps1$([System.Char]39)}`n"
      "`t`t`t  {& $([System.Char]39)C:\Windows\Setup\Scripts\UScheduler_Oobe OutlookUpdate-REMOVE.ps1$([System.Char]39)}`n"
      "`t`t`t  {& $([System.Char]39)C:\Windows\Setup\Scripts\Sticky Keys-DISABLED SpEcialiZe version.ps1$([System.Char]39)}`n"
      "`t`t`t  {& $([System.Char]39)C:\Windows\Setup\Scripts\Chat AutoInstall-DISABLED.ps1$([System.Char]39)}`n"
      "`t`t`t  {& $([System.Char]39)C:\Windows\Setup\Scripts\News And Interests-DISALLOW.ps1$([System.Char]39)}`n"
      "`t`t`t  {& $([System.Char]39)C:\Windows\Setup\Scripts\Windows Consumer Features-DISABLE.ps1$([System.Char]39)}`n"
      "`t`t`t  {& $([System.Char]39)C:\Windows\Setup\Scripts\Microsoft Edge-Prompt for MSA-DISABLED.ps1$([System.Char]39)}`n"
      "`t`t`t  {& $([System.Char]39)C:\Windows\Setup\Scripts\Microsoft Edge-Background Mode-DISABLED.ps1$([System.Char]39)}`n"
      "`t`t`t  {& $([System.Char]39)C:\Windows\Setup\Scripts\Microsoft Edge-Startup Boost-DISABLED.ps1$([System.Char]39)}`n"
      "`t`t`t  {& $([System.Char]39)C:\Windows\Setup\Scripts\Lock Screen-Do Not Require Ctrl+Alt+Del.ps1$([System.Char]39)}`n"
      "`t`t`t  {& $([System.Char]39)C:\Windows\Setup\Scripts\Windows Command Processor Default Location.ps1$([System.Char]39)}`n"
      "`t`t`t)`n"
      "`t`t`t& {`n"
      "`t`t`t  [System.Single] `$Complete = 0`n"
      "`t`t`t  [System.Single] `$Increment = 100 / `$SpEcialiZeScriptBlocks.Count`n"
      "`t`t`t  foreach (`$script in `$SpEcialiZeScriptBlocks) {`n"
      "`t`t`t    Write-Progress -Activity $([System.Char]39)Running scriptblocks in SpEcialiZe.ps1. Do not close this window.$([System.Char]39) -PercentComplete `$Complete`n"
      "`t`t`t    $([System.Char]34)*** Will now execute command «{0}»$([System.Char]34) -f `$(`n"
      "`t`t`t      `$script.ToString().Trim() -replace $([System.Char]39)\s+$([System.Char]39), $([System.Char]39) $([System.Char]39) -replace $([System.Char]39)^(.{99})(.+)`$$([System.Char]39), $([System.Char]39)`$1……$([System.Char]39)`n"
      "`t`t`t    )`n"
      "`t`t`t    `$start = [System.DateTime]::Now`n"
      "`t`t`t    & `$script`n"
      "`t`t`t    $([System.Char]39)*** Finished executing command after {0:0} ms.$([System.Char]39) -f [System.DateTime]::Now.Subtract(`$start).TotalMilliseconds`n"
      "`t`t`t    `$Complete += `$Increment`n"
      "`t`t`t  }`n"
      "`t`t`t} *>&1 | Out-String -Width 1KB -Stream >> $([System.Char]34)C:\Windows\Setup\Scripts\SpEcialiZe.log$([System.Char]34)`n"
      "`t`t"
      #endregion

      {
        $SpEcialiZeScriptBlocks = $(
          {& 'C:\Windows\Setup\Scripts\Windows Update-PAUSE.ps1'}
          {& 'C:\Windows\Setup\Scripts\No non-GPO audit policy settings.ps1'}
          {& 'C:\Windows\Setup\Scripts\WSMan Envelope Size.ps1'}
          {& 'C:\Windows\Setup\Scripts\Environment Variables-System Scope.ps1'}
          #{& 'C:\Windows\Setup\Scripts\DSC Structural-Environmental Data Copy Operation.ps1'}
          {& 'C:\Windows\Setup\Scripts\Module Extraction-Installation.ps1'}
          {& 'C:\Windows\Setup\Scripts\Password Length-Unlimited.ps1'}
          {& 'C:\Windows\Setup\Scripts\Cloud-Optimized Content-DISABLED.ps1'}
          {& 'C:\Windows\Setup\Scripts\Register Scheduled Task to Unlock Start Layout.ps1'}
          {& 'C:\Windows\Setup\Scripts\Audit Process Launch-ENABLED.ps1'}
          {& 'C:\Windows\Setup\Scripts\Status Messages Highly Detailed.ps1'}
          {& 'C:\Windows\Setup\Scripts\SetStartPins.ps1'}
          {& 'C:\Windows\Setup\Scripts\Graphical Settings Part 1.ps1'}
          {& 'C:\Windows\Setup\Scripts\Disable Automatic Restart SignOn-DISABLED.ps1'}
          {& 'C:\Windows\Setup\Scripts\Lock Screen Image.ps1'}
          {& 'C:\Windows\Setup\Scripts\Shortcuts-Microsoft Edge-DELETE.ps1'}
          {& 'C:\Windows\Setup\Scripts\UScheduler_Oobe DevHomeUpdate-REMOVE.ps1'}
          {& 'C:\Windows\Setup\Scripts\UScheduler_Oobe OutlookUpdate-REMOVE.ps1'}
          {& 'C:\Windows\Setup\Scripts\Sticky Keys-DISABLED SpEcialiZe version.ps1'}
          {& 'C:\Windows\Setup\Scripts\Chat AutoInstall-DISABLED.ps1'}
          {& 'C:\Windows\Setup\Scripts\News And Interests-DISALLOW.ps1'}
          {& 'C:\Windows\Setup\Scripts\Windows Consumer Features-DISABLE.ps1'}
          {& 'C:\Windows\Setup\Scripts\Microsoft Edge-Prompt for MSA-DISABLED.ps1'}
          {& 'C:\Windows\Setup\Scripts\Microsoft Edge-Background Mode-DISABLED.ps1'}
          {& 'C:\Windows\Setup\Scripts\Microsoft Edge-Startup Boost-DISABLED.ps1'}
          {& 'C:\Windows\Setup\Scripts\Lock Screen-Do Not Require Ctrl+Alt+Del.ps1'}
          {& 'C:\Windows\Setup\Scripts\Windows Command Processor Default Location.ps1'}
        )
        & {
          [System.Single] $Complete = 0
          [System.Single] $Increment = 100 / $SpEcialiZeScriptBlocks.Count
          foreach ($script in $SpEcialiZeScriptBlocks) {
            Write-Progress -Activity 'Running scriptblocks in SpEcialiZe.ps1. Do not close this window.' -PercentComplete $Complete
            "*** Will now execute command «{0}»" -f $(
              $script.ToString().Trim() -replace '\s+', ' ' -replace '^(.{99})(.+)$', '$1……'
            )
            $start = [System.DateTime]::Now
            & $script
            '*** Finished executing command after {0:0} ms.' -f [System.DateTime]::Now.Subtract($start).TotalMilliseconds
            $Complete += $Increment
          }
        } *>&1 | Out-String -Width 1KB -Stream >> "C:\Windows\Setup\Scripts\SpEcialiZe.log"
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\SpEcialiZe.ps1')
        $XmlWriter.WriteString(${File SpEcialiZe.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion

    #region | DefaultUser.ps1 Here-String | D-Scripts | D-Scripts run during the Specialize configuration pass, after the 'SpEcialiZe.ps1' script |
    #region | "TaskbarLayoutModification.xml" XML Element |
    ${file TaskbarLayoutModification.xml} = New-TemporaryFile
    ${XmlFile TaskbarLayoutModification.xml} = Rename-Item -Path "${file TaskbarLayoutModification.xml}" -NewName $(${file TaskbarLayoutModification.xml}.BaseName + '.xml') -PassThru
    ${XmlWriterSettings TaskbarLayoutModification.xml} = [System.Xml.XmlWriterSettings]::New()
    ${XmlWriterSettings TaskbarLayoutModification.xml}.OmitXmlDeclaration = $true
    ${XmlWriterSettings TaskbarLayoutModification.xml}.NewLineOnAttributes = $false
    ${XmlWriterSettings TaskbarLayoutModification.xml}.Indent = $true
    ${XmlWriter TaskbarLayoutModification.xml} = [System.Xml.XmlWriter]::Create(${XmlFile TaskbarLayoutModification.xml}.FullName,${XmlWriterSettings TaskbarLayoutModification.xml})

    ${XmlWriter TaskbarLayoutModification.xml}.WriteStartDocument()
      ${XmlWriter TaskbarLayoutModification.xml}.WriteStartElement('LayoutModificationTemplate','http://schemas.microsoft.com/Start/2014/LayoutModification')
        ${XmlWriter TaskbarLayoutModification.xml}.WriteAttributeString("xmlns",'defaultlayout',$null,'http://schemas.microsoft.com/Start/2014/FullDefaultLayout')
        ${XmlWriter TaskbarLayoutModification.xml}.WriteAttributeString("xmlns",'start',$null,'http://schemas.microsoft.com/Start/2014/StartLayout')
        ${XmlWriter TaskbarLayoutModification.xml}.WriteAttributeString("xmlns",'taskbar',$null,'http://schemas.microsoft.com/Start/2014/TaskbarLayout')
        ${XmlWriter TaskbarLayoutModification.xml}.WriteAttributeString('Version','1')
        ${XmlWriter TaskbarLayoutModification.xml}.WriteStartElement('CustomTaskbarLayoutCollection')
          ${XmlWriter TaskbarLayoutModification.xml}.WriteAttributeString('PinListPlacement','Replace')
          ${XmlWriter TaskbarLayoutModification.xml}.WriteStartElement('TaskbarLayout','http://schemas.microsoft.com/Start/2014/FullDefaultLayout')
            ${XmlWriter TaskbarLayoutModification.xml}.WriteStartElement('TaskbarPinList','http://schemas.microsoft.com/Start/2014/TaskbarLayout')
              ${XmlWriter TaskbarLayoutModification.xml}.WriteStartElement('DesktopApp','http://schemas.microsoft.com/Start/2014/TaskbarLayout')
                ${XmlWriter TaskbarLayoutModification.xml}.WriteAttributeString('DesktopApplicationLinkPath','#leaveempty')
              ${XmlWriter TaskbarLayoutModification.xml}.WriteEndElement()
            ${XmlWriter TaskbarLayoutModification.xml}.WriteEndElement()
          ${XmlWriter TaskbarLayoutModification.xml}.WriteEndElement()
        ${XmlWriter TaskbarLayoutModification.xml}.WriteEndElement()
      ${XmlWriter TaskbarLayoutModification.xml}.WriteEndElement()
    ${XmlWriter TaskbarLayoutModification.xml}.WriteEndDocument()
    ${XmlWriter TaskbarLayoutModification.xml}.Close()
    Remove-Variable -Name 'XmlWriter TaskbarLayoutModification.xml'
    Remove-Variable -Name 'XmlWriterSettings TaskbarLayoutModification.xml'

    ${File TaskbarLayoutModification.xml Here-String} = $(
      $([System.Char]10)
      (
        Get-Content -Path ${XmlFile TaskbarLayoutModification.xml}.FullName | ForEach-Object -Process {"`t`t`t" + $_}
      ) -join $([System.Char]10)
      $([System.Char]10) + $([System.Char]9) + $([System.Char]9)
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\TaskbarLayoutModification.xml')
        $XmlWriter.WriteString(${File TaskbarLayoutModification.xml Here-String})
      $XmlWriter.WriteEndElement()
    #endregion
    #region | "UnlockStartLayout.vbs" Here-String |
    ${File UnlockStartLayout.vbs Here-String} = $(

      "`n"
      "`t`t`tHKU = &H80000003`n"
      "`t`t`t  Set reg = GetObject($([System.Char]34)winmgmts://./root/default:StdRegProv$([System.Char]34))`n"
      "`t`t`t  Set fso = CreateObject($([System.Char]34)Scripting.FileSystemObject$([System.Char]34))`n"
      "`t`t`t  If reg.EnumKey(HKU, $([System.Char]34)$([System.Char]34), sids) = 0 Then`n"
      "`t`t`t    If Not IsNull(sids) Then`n"
      "`t`t`t      For Each sid In sids`n"
      "`t`t`t        key = sid + $([System.Char]34)\Software\Policies\Microsoft\Windows\Explorer$([System.Char]34)`n"
      "`t`t`t        name = $([System.Char]34)LockedStartLayout$([System.Char]34)`n"
      "`t`t`t        If reg.GetDWORDValue(HKU, key, name, existing) = 0 Then`n"
      "`t`t`t          reg.SetDWORDValue HKU, key, name, 0`n"
      "`t`t`t        End If`n"
      "`t`t`t      Next`n"
      "`t`t`t    End If`n"
      "`t`t`t  End If`n"
      "`t`t"
      { # UnlockStartLayout.vbs Plain-Text | Converted to ${File UnlockStartLayout.vbs Here-String} with 'ConvertTo-HereStringCompatible' |
        ${UnlockStartLayout.vbs Plain-Text} = 'HKU = &H80000003
          Set reg = GetObject("winmgmts://./root/default:StdRegProv")
          Set fso = CreateObject("Scripting.FileSystemObject")
          If reg.EnumKey(HKU, "", sids) = 0 Then
            If Not IsNull(sids) Then
              For Each sid In sids
                key = sid + "\Software\Policies\Microsoft\Windows\Explorer"
                name = "LockedStartLayout"
                If reg.GetDWORDValue(HKU, key, name, existing) = 0 Then
                  reg.SetDWORDValue HKU, key, name, 0
                End If
              Next
            End If
          End If'
        ${UnlockStartLayout.vbs Plain-Text} | Set-Clipboard;         ConvertTo-HereStringCompatible
        <#
          HKU = &H80000003
          Set reg = GetObject("winmgmts://./root/default:StdRegProv")
          Set fso = CreateObject("Scripting.FileSystemObject")
          If reg.EnumKey(HKU, "", sids) = 0 Then
            If Not IsNull(sids) Then
              For Each sid In sids
                key = sid + "\Software\Policies\Microsoft\Windows\Explorer"
                name = "LockedStartLayout"
                If reg.GetDWORDValue(HKU, key, name, existing) = 0 Then
                  reg.SetDWORDValue HKU, key, name, 0
                End If
              Next
            End If
          End If
        #>
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\UnlockStartLayout.vbs')
        $XmlWriter.WriteString(${File UnlockStartLayout.vbs Here-String})
      $XmlWriter.WriteEndElement()
    #endregion
    #region | "UnlockStartLayout.xml" Here-String |
    ${file UnlockStartLayout.xml} = New-TemporaryFile
    ${XmlFile UnlockStartLayout.xml} = Rename-Item -Path "${file UnlockStartLayout.xml}" -NewName $(${file UnlockStartLayout.xml}.BaseName + '.xml') -PassThru
    ${XmlWriterSettings UnlockStartLayout.xml} = [System.Xml.XmlWriterSettings]::New()
    ${XmlWriterSettings UnlockStartLayout.xml}.OmitXmlDeclaration = $true
    ${XmlWriterSettings UnlockStartLayout.xml}.NewLineOnAttributes = $false
    ${XmlWriterSettings UnlockStartLayout.xml}.Indent = $true
    ${XmlWriter UnlockStartLayout.xml} = [System.Xml.XmlWriter]::Create(${XmlFile UnlockStartLayout.xml}.FullName,${XmlWriterSettings UnlockStartLayout.xml})

    ${XmlWriter UnlockStartLayout.xml}.WriteStartDocument()
      ${XmlWriter UnlockStartLayout.xml}.WriteStartElement('Task','http://schemas.microsoft.com/windows/2004/02/mit/task')
        ${XmlWriter UnlockStartLayout.xml}.WriteAttributeString('version','1.2')
          ${XmlWriter UnlockStartLayout.xml}.WriteStartElement('Triggers')
            ${XmlWriter UnlockStartLayout.xml}.WriteStartElement('EventTrigger')
              ${XmlWriter UnlockStartLayout.xml}.WriteElementString('Enabled','true')
              ${XmlWriter UnlockStartLayout.xml}.WriteElementString('Subscription',"<QueryList><Query Id=$([System.Char]34)0$([System.Char]34) Path=$([System.Char]34)Application$([System.Char]34)><Select Path=$([System.Char]34)Application$([System.Char]34)>*[System[Provider[@Name='UnattendGenerator'] and EventID=1]]</Select></Query></QueryList>")
              <# work-in-progress - How can the XML Writer produce the entry directly above? |
                ${XmlWriter UnlockStartLayout.xml}.WriteElementString('Subscription',$(
                  ${file UnlockStartLayout-Subscription.xml} = New-TemporaryFile
                  ${XmlFile UnlockStartLayout-Subscription.xml} = Rename-Item -Path "${file UnlockStartLayout-Subscription.xml}" -NewName $(${file UnlockStartLayout-Subscription.xml}.BaseName + '.xml') -PassThru
                  ${XmlWriterSettings UnlockStartLayout-Subscription.xml} = [System.Xml.XmlWriterSettings]::New()
                  ${XmlWriterSettings UnlockStartLayout-Subscription.xml}.OmitXmlDeclaration = $true
                  ${XmlWriterSettings UnlockStartLayout-Subscription.xml}.NewLineOnAttributes = $false
                  ${XmlWriterSettings UnlockStartLayout-Subscription.xml}.Indent = $true
                  ${XmlWriter UnlockStartLayout-Subscription.xml} = [System.Xml.XmlWriter]::Create(${XmlFile UnlockStartLayout-Subscription.xml}.FullName,${XmlWriterSettings UnlockStartLayout-Subscription.xml})

                  ${XmlWriter UnlockStartLayout-Subscription.xml}.WriteStartDocument()
                    ${XmlWriter UnlockStartLayout-Subscription.xml}.WriteStartElement('QueryList')
                    ${XmlWriter UnlockStartLayout-Subscription.xml}.WriteEndElement()
                  ${XmlWriter UnlockStartLayout-Subscription.xml}.WriteEndDocument()

                  ${XmlWriter UnlockStartLayout-Subscription.xml}.Close()
                  Remove-Variable -Name 'XmlWriter UnlockStartLayout-Subscription.xml'
                  Remove-Variable -Name 'XmlWriterSettings UnlockStartLayout-Subscription.xml'
                ))
              #>
            ${XmlWriter UnlockStartLayout.xml}.WriteEndElement()
          ${XmlWriter UnlockStartLayout.xml}.WriteEndElement()

          ${XmlWriter UnlockStartLayout.xml}.WriteStartElement('Principals')
            ${XmlWriter UnlockStartLayout.xml}.WriteStartElement('Principal')
              ${XmlWriter UnlockStartLayout.xml}.WriteAttributeString('id','Author')
                ${XmlWriter UnlockStartLayout.xml}.WriteElementString('UserId','S-1-5-18')
                ${XmlWriter UnlockStartLayout.xml}.WriteElementString('RunLevel','LeastPrivilege')
            ${XmlWriter UnlockStartLayout.xml}.WriteEndElement()
          ${XmlWriter UnlockStartLayout.xml}.WriteEndElement()

          ${XmlWriter UnlockStartLayout.xml}.WriteStartElement('Settings')
            ${XmlWriter UnlockStartLayout.xml}.WriteElementString('MultipleInstancesPolicy','IgnoreNew')
            ${XmlWriter UnlockStartLayout.xml}.WriteElementString('DisallowStartIfOnBatteries','false')
            ${XmlWriter UnlockStartLayout.xml}.WriteElementString('StopIfGoingOnBatteries','false')
            ${XmlWriter UnlockStartLayout.xml}.WriteElementString('AllowHardTerminate','false')
            ${XmlWriter UnlockStartLayout.xml}.WriteElementString('StartWhenAvailable','false')
            ${XmlWriter UnlockStartLayout.xml}.WriteElementString('RunOnlyIfNetworkAvailable','false')
            ${XmlWriter UnlockStartLayout.xml}.WriteStartElement('IdleSettings')
              ${XmlWriter UnlockStartLayout.xml}.WriteElementString('StopOnIdleEnd','true')
              ${XmlWriter UnlockStartLayout.xml}.WriteElementString('RestartOnIdle','false')
            ${XmlWriter UnlockStartLayout.xml}.WriteEndElement()
            ${XmlWriter UnlockStartLayout.xml}.WriteElementString('AllowStartOnDemand','true')
            ${XmlWriter UnlockStartLayout.xml}.WriteElementString('Enabled','true')
            ${XmlWriter UnlockStartLayout.xml}.WriteElementString('Hidden','false')
            ${XmlWriter UnlockStartLayout.xml}.WriteElementString('RunOnlyIfIdle','false')
            ${XmlWriter UnlockStartLayout.xml}.WriteElementString('WakeToRun','false')
            ${XmlWriter UnlockStartLayout.xml}.WriteElementString('ExecutionTimeLimit','PT72H')
            ${XmlWriter UnlockStartLayout.xml}.WriteElementString('Priority','7')
          ${XmlWriter UnlockStartLayout.xml}.WriteEndElement()

          ${XmlWriter UnlockStartLayout.xml}.WriteStartElement('Actions')
            ${XmlWriter UnlockStartLayout.xml}.WriteAttributeString('Context','Author')
            ${XmlWriter UnlockStartLayout.xml}.WriteStartElement('Exec')
              ${XmlWriter UnlockStartLayout.xml}.WriteElementString('Command','C:\Windows\System32\wscript.exe')
              ${XmlWriter UnlockStartLayout.xml}.WriteElementString('Arguments','C:\Windows\Setup\Scripts\UnlockStartLayout.vbs')
            ${XmlWriter UnlockStartLayout.xml}.WriteEndElement()
          ${XmlWriter UnlockStartLayout.xml}.WriteEndElement()
      ${XmlWriter UnlockStartLayout.xml}.WriteEndElement()
    ${XmlWriter UnlockStartLayout.xml}.WriteEndDocument()
    ${XmlWriter UnlockStartLayout.xml}.Close()
    Remove-Variable -Name 'XmlWriter UnlockStartLayout.xml'
    Remove-Variable -Name 'XmlWriterSettings UnlockStartLayout.xml'

    ${File UnlockStartLayout.xml Here-String} = $(
      $([System.Char]10)
      (
        Get-Content -Path ${XmlFile UnlockStartLayout.xml}.FullName | ForEach-Object -Process {"`t`t`t" + $_}
      ) -join $([System.Char]10)
      $([System.Char]10) + $([System.Char]9) + $([System.Char]9)
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\UnlockStartLayout.xml')
        $XmlWriter.WriteString(${File UnlockStartLayout.xml Here-String})
      $XmlWriter.WriteEndElement()
    #endregion
    #region | "ShowAllTrayIcons.xml" Here-String |
    ${file ShowAllTrayIcons.xml} = New-TemporaryFile
    ${XmlFile ShowAllTrayIcons.xml} = Rename-Item -Path "${file ShowAllTrayIcons.xml}" -NewName $(${file ShowAllTrayIcons.xml}.BaseName + '.xml') -PassThru
    ${XmlWriterSettings ShowAllTrayIcons.xml} = [System.Xml.XmlWriterSettings]::New()
    ${XmlWriterSettings ShowAllTrayIcons.xml}.OmitXmlDeclaration = $true
    ${XmlWriterSettings ShowAllTrayIcons.xml}.NewLineOnAttributes = $false
    ${XmlWriterSettings ShowAllTrayIcons.xml}.Indent = $true
    ${XmlWriter ShowAllTrayIcons.xml} = [System.Xml.XmlWriter]::Create(${XmlFile ShowAllTrayIcons.xml}.FullName,${XmlWriterSettings ShowAllTrayIcons.xml})
    ${XmlWriter ShowAllTrayIcons.xml}.WriteStartDocument()
      ${XmlWriter ShowAllTrayIcons.xml}.WriteStartElement('Task','http://schemas.microsoft.com/windows/2004/02/mit/task')
        ${XmlWriter ShowAllTrayIcons.xml}.WriteAttributeString('version','1.2')

          ${XmlWriter ShowAllTrayIcons.xml}.WriteStartElement('Triggers')
            ${XmlWriter ShowAllTrayIcons.xml}.WriteStartElement('LogonTrigger')
              ${XmlWriter ShowAllTrayIcons.xml}.WriteStartElement('Repetition')
                ${XmlWriter ShowAllTrayIcons.xml}.WriteElementString('Interval','PT1M')
                ${XmlWriter ShowAllTrayIcons.xml}.WriteElementString('StopAtDurationEnd','false')
              ${XmlWriter ShowAllTrayIcons.xml}.WriteEndElement()
              ${XmlWriter ShowAllTrayIcons.xml}.WriteElementString('Enabled','true')
            ${XmlWriter ShowAllTrayIcons.xml}.WriteEndElement()
          ${XmlWriter ShowAllTrayIcons.xml}.WriteEndElement()

          ${XmlWriter ShowAllTrayIcons.xml}.WriteStartElement('Principals')
            ${XmlWriter ShowAllTrayIcons.xml}.WriteStartElement('Principal')
              ${XmlWriter ShowAllTrayIcons.xml}.WriteAttributeString('id','Author')
                ${XmlWriter ShowAllTrayIcons.xml}.WriteElementString('GroupId','S-1-5-32-545')
                ${XmlWriter ShowAllTrayIcons.xml}.WriteElementString('RunLevel','LeastPrivilege')
            ${XmlWriter ShowAllTrayIcons.xml}.WriteEndElement()
          ${XmlWriter ShowAllTrayIcons.xml}.WriteEndElement()

          ${XmlWriter ShowAllTrayIcons.xml}.WriteStartElement('Settings')
            ${XmlWriter ShowAllTrayIcons.xml}.WriteElementString('MultipleInstancesPolicy','IgnoreNew')
            ${XmlWriter ShowAllTrayIcons.xml}.WriteElementString('DisallowStartIfOnBatteries','false')
            ${XmlWriter ShowAllTrayIcons.xml}.WriteElementString('StopIfGoingOnBatteries','false')
            ${XmlWriter ShowAllTrayIcons.xml}.WriteElementString('AllowHardTerminate','true')
            ${XmlWriter ShowAllTrayIcons.xml}.WriteElementString('StartWhenAvailable','false')
            ${XmlWriter ShowAllTrayIcons.xml}.WriteElementString('RunOnlyIfNetworkAvailable','false')
            ${XmlWriter ShowAllTrayIcons.xml}.WriteStartElement('IdleSettings')
              ${XmlWriter ShowAllTrayIcons.xml}.WriteElementString('StopOnIdleEnd','true')
              ${XmlWriter ShowAllTrayIcons.xml}.WriteElementString('RestartOnIdle','false')
            ${XmlWriter ShowAllTrayIcons.xml}.WriteEndElement()
            ${XmlWriter ShowAllTrayIcons.xml}.WriteElementString('AllowStartOnDemand','true')
            ${XmlWriter ShowAllTrayIcons.xml}.WriteElementString('Enabled','true')
            ${XmlWriter ShowAllTrayIcons.xml}.WriteElementString('Hidden','false')
            ${XmlWriter ShowAllTrayIcons.xml}.WriteElementString('RunOnlyIfIdle','false')
            ${XmlWriter ShowAllTrayIcons.xml}.WriteElementString('WakeToRun','false')
            ${XmlWriter ShowAllTrayIcons.xml}.WriteElementString('ExecutionTimeLimit','PT72H')
            ${XmlWriter ShowAllTrayIcons.xml}.WriteElementString('Priority','7')
          ${XmlWriter ShowAllTrayIcons.xml}.WriteEndElement()

          ${XmlWriter ShowAllTrayIcons.xml}.WriteStartElement('Actions')
            ${XmlWriter ShowAllTrayIcons.xml}.WriteAttributeString('Context','Author')
            ${XmlWriter ShowAllTrayIcons.xml}.WriteStartElement('Exec')
              ${XmlWriter ShowAllTrayIcons.xml}.WriteElementString('Command','%windir%\System32\conhost.exe')
              ${XmlWriter ShowAllTrayIcons.xml}.WriteElementString('Arguments',-join $(
                "--headless "
                "%windir%\System32\WindowsPowerShell\v1.0\powershell.exe "
                #"-WindowStyle Hidden "
                "-WindowStyle $([System.Char]39)Hidden$([System.Char]39) "
                "-NoProfile "
                "-NonInteractive "
                "-Command $([System.Char]34)Set-ItemProperty -Path 'Registry::HKCU\Control Panel\NotifyIconSettings\*' -Name 'IsPromoted' -Value 1 -Type 'DWord';$([System.Char]34)"
              ))
            ${XmlWriter ShowAllTrayIcons.xml}.WriteEndElement()
          ${XmlWriter ShowAllTrayIcons.xml}.WriteEndElement()
      ${XmlWriter ShowAllTrayIcons.xml}.WriteEndElement()
    ${XmlWriter ShowAllTrayIcons.xml}.WriteEndDocument()
    ${XmlWriter ShowAllTrayIcons.xml}.Close()
    Remove-Variable -Name 'XmlWriter ShowAllTrayIcons.xml'
    Remove-Variable -Name 'XmlWriterSettings ShowAllTrayIcons.xml'

    ${File ShowAllTrayIcons.xml Here-String} = $(
      $([System.Char]10)
      (
        Get-Content -Path ${XmlFile ShowAllTrayIcons.xml}.FullName | ForEach-Object -Process {"`t`t`t" + $_}
      ) -join $([System.Char]10)
      $([System.Char]10) + $([System.Char]9) + $([System.Char]9)
    ) -join ''

      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\ShowAllTrayIcons.xml')
        $XmlWriter.WriteString(${File ShowAllTrayIcons.xml Here-String})
      $XmlWriter.WriteEndElement()
    #endregion
    #region | "ShowAllTrayIcons.vbs" Here-String | Can We Delete? |
    ${File ShowAllTrayIcons.vbs Here-String} = $(
      "`n"
      "`t`t`tHKCU = &H80000001`n"
      "`t`t`tkey = $([System.Char]34)Control Panel\NotifyIconSettings$([System.Char]34)`n"
      "`t`t`tSet reg = GetObject($([System.Char]34)winmgmts://./root/default:StdRegProv$([System.Char]34))`n"
      "`t`t`tIf reg.EnumKey(HKCU, key, names) = 0 Then`n"
      "`t`t`t  If Not IsNull(names) Then`n"
      "`t`t`t    For Each name In names`n"
      "`t`t`t      reg.SetDWORDValue HKCU, key + $([System.Char]34)\$([System.Char]34) + name, $([System.Char]34)IsPromoted$([System.Char]34), 1`n"
      "`t`t`t    Next`n"
      "`t`t`t  End If`n"
      "`t`t`tEnd If`n"
      "`t`t"
    ) -join ''

    <# 'C:\Windows\Setup\Scripts\ShowAllTrayIcons.vbs' |
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\ShowAllTrayIcons.vbs')
        $XmlWriter.WriteString(${File ShowAllTrayIcons.vbs Here-String})
      $XmlWriter.WriteEndElement()
    #>
    #endregion
    #region | "Taskbar System Tray Icons-Always Show.ps1" Here-String |
    ${File Taskbar System Tray Icons-Always Show.ps1 Here-String} = $(
      "`n"
      "`t`t`t`$RawXml = Get-Content -LiteralPath $([System.Char]34)C:\Windows\Setup\Scripts\ShowAllTrayIcons.xml$([System.Char]34) -Raw`n"
      "`t`t`tRegister-ScheduledTask -TaskName $([System.Char]39)ShowAllTrayIcons$([System.Char]39) -Xml `$RawXml`n"
      "`t`t"
      { # Taskbar System Tray Icons-Always Show.ps1 Plain-Text | Converted to ${File Taskbar System Tray Icons-Always Show.ps1 Here-String} with 'ConvertTo-HereStringCompatible' |
        $RawXml = Get-Content -LiteralPath "C:\Windows\Setup\Scripts\ShowAllTrayIcons.xml" -Raw
        Register-ScheduledTask -TaskName 'ShowAllTrayIcons' -Xml $RawXml
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\Taskbar System Tray Icons-Always Show.ps1')
        $XmlWriter.WriteString(${File Taskbar System Tray Icons-Always Show.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion

    #region | "Page Space Control Sizer.ps1" Here-String and XML Element |
    ${File Page Space Control Sizer.ps1 Here-String} = $(
      "`n"
      "`t`t`t`$path = $([System.Char]34)Registry::HKEY_USERS\DefaultUser\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Modules\GlobalSettings\Sizer$([System.Char]34)`n"
      "`t`t`t`$name = $([System.Char]39)PageSpaceControlSizer$([System.Char]39)`n"
      "`t`t`t`$RegItem = try {`n"
      "`t`t`t  Get-Item -Path `$path -Name `$name -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  New-Item -Path `$path -Name `$name -Force -Verbose`n"
      "`t`t`t}`n"
      "`t`t`t`n"
      "`t`t`t`$RegItemProp = try {`n"
      "`t`t`t  Get-ItemProperty -Path `$path -Name `$name -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  `$InputHT = @{`n"
      "`t`t`t    Path    = `$path`n"
      "`t`t`t    Name    = `$name`n"
      "`t`t`t    Type    = $([System.Char]39)Binary$([System.Char]39)`n"
      "`t`t`t    Value   = ([System.Byte[]]([System.String]::Format($([System.Char]34)0x{0:x}$([System.Char]34),160),[System.String]::Format($([System.Char]34)0x{0:x}$([System.Char]34),0),[System.String]::Format($([System.Char]34)0x{0:x}$([System.Char]34),0),[System.String]::Format($([System.Char]34)0x{0:x}$([System.Char]34),0),[System.String]::Format($([System.Char]34)0x{0:x}$([System.Char]34),0),[System.String]::Format($([System.Char]34)0x{0:x}$([System.Char]34),0),[System.String]::Format($([System.Char]34)0x{0:x}$([System.Char]34),0),[System.String]::Format($([System.Char]34)0x{0:x}$([System.Char]34),0),[System.String]::Format($([System.Char]34)0x{0:x}$([System.Char]34),0),[System.String]::Format($([System.Char]34)0x{0:x}$([System.Char]34),0),[System.String]::Format($([System.Char]34)0x{0:x}$([System.Char]34),0),[System.String]::Format($([System.Char]34)0x{0:x}$([System.Char]34),0),[System.String]::Format($([System.Char]34)0x{0:x}$([System.Char]34),82),[System.String]::Format($([System.Char]34)0x{0:x}$([System.Char]34),2),[System.String]::Format($([System.Char]34)0x{0:x}$([System.Char]34),0),[System.String]::Format($([System.Char]34)0x{0:x}$([System.Char]34),0)))`n"
      "`t`t`t    Force   = `$true`n"
      "`t`t`t    Verbose = `$true`n"
      "`t`t`t  }`n"
      "`t`t`t  New-ItemProperty @InputHT`n"
      "`t`t`t}`n"
      "`t`t"
      {
        $path = "Registry::HKEY_USERS\DefaultUser\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Modules\GlobalSettings\Sizer"
        $name = 'PageSpaceControlSizer'
        $RegItem = try {
          Get-Item -Path $path -Name $name -ErrorAction 'Stop'
        } catch {
          New-Item -Path $path -Name $name -Force -Verbose
        }

        $RegItemProp = try {
          Get-ItemProperty -Path $path -Name $name -ErrorAction 'Stop'
        } catch {
          $InputHT = @{
            Path    = $path
            Name    = $name
            Type    = 'Binary'
            Value   = ([System.Byte[]]([System.String]::Format("0x{0:x}",160),[System.String]::Format("0x{0:x}",0),[System.String]::Format("0x{0:x}",0),[System.String]::Format("0x{0:x}",0),[System.String]::Format("0x{0:x}",0),[System.String]::Format("0x{0:x}",0),[System.String]::Format("0x{0:x}",0),[System.String]::Format("0x{0:x}",0),[System.String]::Format("0x{0:x}",0),[System.String]::Format("0x{0:x}",0),[System.String]::Format("0x{0:x}",0),[System.String]::Format("0x{0:x}",0),[System.String]::Format("0x{0:x}",82),[System.String]::Format("0x{0:x}",2),[System.String]::Format("0x{0:x}",0),[System.String]::Format("0x{0:x}",0)))
            Force   = $true
            Verbose = $true
          }
          New-ItemProperty @InputHT
        }
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\Page Space Control Sizer.ps1')
        $XmlWriter.WriteString(${File Page Space Control Sizer.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion
    #region | "Underline Access Keys when Available.ps1" Here-String and XML Element |
    ${File Underline Access Keys when Available.ps1 Here-String} = $(
      "`n"
      "`t`t`tSet-ItemProperty -LiteralPath $([System.Char]34)Registry::HKEY_USERS\DefaultUser\Control Panel\Accessibility\Keyboard Preference$([System.Char]34) -Name $([System.Char]39)On$([System.Char]39) -Value $([System.Char]39)1$([System.Char]39) -Verbose`n"
      "`t`t"
      {
        Set-ItemProperty -LiteralPath "Registry::HKEY_USERS\DefaultUser\Control Panel\Accessibility\Keyboard Preference" -Name 'On' -Value '1' -Verbose
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\Underline Access Keys when Available.ps1')
        $XmlWriter.WriteString(${File Underline Access Keys when Available.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion
    #region | "Misc File Explorer Settings-Part 1.ps1" Here-String and XML Element |
    ${File Misc File Explorer Settings-Part 1.ps1 Here-String} = $(

      #region |  |
      "`n"
      "`t`t`t# This PC of File Explorer and not Home or Personal |`n"
      "`t`t`tSet-ItemProperty -LiteralPath $([System.Char]39)Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]39) -Name $([System.Char]39)LaunchTo$([System.Char]39) -Type $([System.Char]39)DWord$([System.Char]39) -Value $([System.Char]39)1$([System.Char]39) -Verbose`n"
      "`t`t`t`n"
      "`t`t`t# SHOW file extensions`n"
      "`t`t`t`$path = $([System.Char]34)Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34)`n"
      "`t`t`t`$name = $([System.Char]39)HideFileExt$([System.Char]39)`n"
      "`t`t`t`$RegItem = try {`n"
      "`t`t`t  Get-Item -Path `$path -Name `$name -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  New-Item -Path `$path -Name `$name -Force -Verbose`n"
      "`t`t`t}`n"
      "`t`t`t`$RegItemProp = try {`n"
      "`t`t`t  Get-ItemProperty -Path `$path -Name `$name -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  `$InputHT = @{`n"
      "`t`t`t    Path    = `$path`n"
      "`t`t`t    Name    = `$name`n"
      "`t`t`t    Type    = $([System.Char]39)Dword$([System.Char]39)`n"
      "`t`t`t    Value   = $([System.Char]39)0$([System.Char]39)`n"
      "`t`t`t    Force   = `$true`n"
      "`t`t`t    Verbose = `$true`n"
      "`t`t`t  }`n"
      "`t`t`t  New-ItemProperty @InputHT`n"
      "`t`t`t}`n"
      "`t`t`t`n"
      "`t`t`t# Disable Search box suggestions`n"
      "`t`t`t`$path = $([System.Char]34)Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer$([System.Char]34)`n"
      "`t`t`t`$name = $([System.Char]39)DisableSearchBoxSuggestions$([System.Char]39)`n"
      "`t`t`t`$RegItem = try {`n"
      "`t`t`t  Get-Item -Path `$path -Name `$name -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  New-Item -Path `$path -Name `$name -Force -Verbose`n"
      "`t`t`t}`n"
      "`t`t`t`$RegItemProp = try {`n"
      "`t`t`t  Get-ItemProperty -Path `$path -Name `$name -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  `$InputHT = @{`n"
      "`t`t`t    Path    = `$path`n"
      "`t`t`t    Name    = `$name`n"
      "`t`t`t    Type    = $([System.Char]39)Dword$([System.Char]39)`n"
      "`t`t`t    Value   = $([System.Char]39)1$([System.Char]39)`n"
      "`t`t`t    Force   = `$true`n"
      "`t`t`t    Verbose = `$true`n"
      "`t`t`t  }`n"
      "`t`t`t  New-ItemProperty @InputHT`n"
      "`t`t`t}`n"
      "`t`t`t`n"
      "`t`t`t# Disable Tooltips. I love having shit pop up in front of what I$([System.Char]39)m currently reading.`n"
      "`t`t`t`$path = $([System.Char]34)Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer$([System.Char]34)`n"
      "`t`t`t`$name = $([System.Char]39)ShowInfoTip$([System.Char]39)`n"
      "`t`t`t`$RegItem = try {`n"
      "`t`t`t  Get-Item -Path `$path -Name `$name -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  New-Item -Path `$path -Name `$name -Force -Verbose`n"
      "`t`t`t}`n"
      "`t`t`t`$RegItemProp = try {`n"
      "`t`t`t  Get-ItemProperty -Path `$path -Name `$name -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  `$InputHT = @{`n"
      "`t`t`t    Path    = `$path`n"
      "`t`t`t    Name    = `$name`n"
      "`t`t`t    Type    = $([System.Char]39)Dword$([System.Char]39)`n"
      "`t`t`t    Value   = $([System.Char]39)0$([System.Char]39)`n"
      "`t`t`t    Force   = `$true`n"
      "`t`t`t    Verbose = `$true`n"
      "`t`t`t  }`n"
      "`t`t`t  New-ItemProperty @InputHT`n"
      "`t`t`t}`n"
      "`t`t`t# reg.exe add $([System.Char]34)HKU\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3$([System.Char]34) /v $([System.Char]34)ShowInfoTip$([System.Char]34) /d 0 /t REG_DWORD /f`n"
      "`t`t`t`$path = $([System.Char]34)Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer$([System.Char]34)`n"
      "`t`t`t`$name = $([System.Char]39)StuckRects3$([System.Char]39)`n"
      "`t`t`t`$RegItem = try {`n"
      "`t`t`t  Get-Item -Path `$path -Name `$name -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  New-Item -Path `$path -Name `$name -Force -Verbose`n"
      "`t`t`t}`n"
      "`t`t`t`$path = $([System.Char]34)`$path\`$name$([System.Char]34)`n"
      "`t`t`t`$name = $([System.Char]39)ShowInfoTip$([System.Char]39)`n"
      "`t`t`t`$RegItemProp = try {`n"
      "`t`t`t  Get-ItemProperty -Path `$path -Name `$name -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  `$InputHT = @{`n"
      "`t`t`t    Path    = `$path`n"
      "`t`t`t    Name    = `$name`n"
      "`t`t`t    Type    = $([System.Char]39)Dword$([System.Char]39)`n"
      "`t`t`t    Value   = $([System.Char]39)0$([System.Char]39)`n"
      "`t`t`t    Force   = `$true`n"
      "`t`t`t    Verbose = `$true`n"
      "`t`t`t  }`n"
      "`t`t`t  New-ItemProperty @InputHT`n"
      "`t`t`t}`n"
      "`t`t`t`n"
      "`t`t`t# Enable taskbar developer settings, whatever that means...`n"
      "`t`t`t# reg.exe add $([System.Char]34)HKU\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings$([System.Char]34) /v TaskbarEndTask /t REG_DWORD /d 1 /f`n"
      "`t`t`t`$path = $([System.Char]34)Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34)`n"
      "`t`t`t`$name = $([System.Char]39)TaskbarDeveloperSettings$([System.Char]39)`n"
      "`t`t`t`$RegItem = try {`n"
      "`t`t`t  Get-Item -Path `$path -Name `$name -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  New-Item -Path `$path -Name `$name -Force -Verbose`n"
      "`t`t`t}`n"
      "`t`t`t`$path = $([System.Char]34)`$path\`$name$([System.Char]34)`n"
      "`t`t`t`$name = $([System.Char]39)TaskbarEndTask$([System.Char]39)`n"
      "`t`t`t`$RegItemProp = try {`n"
      "`t`t`t  Get-ItemProperty -Path `$path -Name `$name -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  `$InputHT = @{`n"
      "`t`t`t    Path    = `$path`n"
      "`t`t`t    Name    = `$name`n"
      "`t`t`t    Type    = $([System.Char]39)Dword$([System.Char]39)`n"
      "`t`t`t    Value   = $([System.Char]39)1$([System.Char]39)`n"
      "`t`t`t    Force   = `$true`n"
      "`t`t`t    Verbose = `$true`n"
      "`t`t`t  }`n"
      "`t`t`t  New-ItemProperty @InputHT`n"
      "`t`t`t}`n"
      "`t`t`t`n"
      "`t`t`t# Show hidden files?`n"
      "`t`t`t# reg.exe add $([System.Char]34)HKU\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34) /v $([System.Char]34)Hidden$([System.Char]34) /t REG_DWORD /d 1 /f`n"
      "`t`t`t`$path = $([System.Char]34)Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34)`n"
      "`t`t`t`$name = $([System.Char]39)Hidden$([System.Char]39)`n"
      "`t`t`t`$RegItem = try {`n"
      "`t`t`t  Get-Item -Path `$path -Name `$name -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  New-Item -Path `$path -Name `$name -Force -Verbose`n"
      "`t`t`t}`n"
      "`t`t`t`$RegItemProp = try {`n"
      "`t`t`t  Get-ItemProperty -Path `$path -Name `$name -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  `$InputHT = @{`n"
      "`t`t`t    Path    = `$path`n"
      "`t`t`t    Name    = `$name`n"
      "`t`t`t    Type    = $([System.Char]39)Dword$([System.Char]39)`n"
      "`t`t`t    Value   = $([System.Char]39)1$([System.Char]39)`n"
      "`t`t`t    Force   = `$true`n"
      "`t`t`t    Verbose = `$true`n"
      "`t`t`t  }`n"
      "`t`t`t  New-ItemProperty @InputHT`n"
      "`t`t`t}`n"
      "`t`t`t`n"
      "`t`t`t# Not sure what $([System.Char]39)TaskbarAl$([System.Char]39) is...`n"
      "`t`t`t# reg.exe add $([System.Char]34)HKU\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34) /v TaskbarAl /t REG_DWORD /d 0 /f`n"
      "`t`t`t`$path = $([System.Char]34)Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34)`n"
      "`t`t`t`$name = $([System.Char]39)TaskbarAl$([System.Char]39)`n"
      "`t`t`t`$RegItem = try {`n"
      "`t`t`t  Get-Item -Path `$path -Name `$name -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  New-Item -Path `$path -Name `$name -Force -Verbose`n"
      "`t`t`t}`n"
      "`t`t`t`$RegItemProp = try {`n"
      "`t`t`t  Get-ItemProperty -Path `$path -Name `$name -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  `$InputHT = @{`n"
      "`t`t`t    Path    = `$path`n"
      "`t`t`t    Name    = `$name`n"
      "`t`t`t    Type    = $([System.Char]39)Dword$([System.Char]39)`n"
      "`t`t`t    Value   = $([System.Char]39)0$([System.Char]39)`n"
      "`t`t`t    Force   = `$true`n"
      "`t`t`t    Verbose = `$true`n"
      "`t`t`t  }`n"
      "`t`t`t  New-ItemProperty @InputHT`n"
      "`t`t`t}`n"
      "`t`t`t`n"
      "`t`t`t# Checkmark $([System.Char]39)Decrease space between items (Compact View)$([System.Char]39)`n"
      "`t`t`t# Set-ItemProperty -LiteralPath $([System.Char]34)Registry::HKU\DefaultUser\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34) -Name $([System.Char]39)UseCompactMode$([System.Char]39) -Type DWORD -Value $([System.Char]34)0x1$([System.Char]34) -Verbose -Force`n"
      "`t`t`t`$path = $([System.Char]34)Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34)`n"
      "`t`t`t`$name = $([System.Char]39)UseCompactMode$([System.Char]39)`n"
      "`t`t`t`$RegItem = try {`n"
      "`t`t`t  Get-Item -Path `$path -Name `$name -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  New-Item -Path `$path -Name `$name -Force -Verbose`n"
      "`t`t`t}`n"
      "`t`t`t`$RegItemProp = try {`n"
      "`t`t`t  Get-ItemProperty -Path `$path -Name `$name -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  `$InputHT = @{`n"
      "`t`t`t    Path    = `$path`n"
      "`t`t`t    Name    = `$name`n"
      "`t`t`t    Type    = $([System.Char]39)Dword$([System.Char]39)`n"
      "`t`t`t    Value   = $([System.Char]39)0x1$([System.Char]39)`n"
      "`t`t`t    Force   = `$true`n"
      "`t`t`t    Verbose = `$true`n"
      "`t`t`t  }`n"
      "`t`t`t  Set-ItemProperty @InputHT`n"
      "`t`t`t}`n"
      "`t`t"

      #endregion

      {
        # This PC of File Explorer and not Home or Personal |
        Set-ItemProperty -LiteralPath 'Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name 'LaunchTo' -Type 'DWord' -Value '1' -Verbose

        # SHOW file extensions
        $path = "Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
        $name = 'HideFileExt'
        $RegItem = try {
          Get-Item -Path $path -Name $name -ErrorAction 'Stop'
        } catch {
          New-Item -Path $path -Name $name -Force -Verbose
        }
        $RegItemProp = try {
          Get-ItemProperty -Path $path -Name $name -ErrorAction 'Stop'
        } catch {
          $InputHT = @{
            Path    = $path
            Name    = $name
            Type    = 'Dword'
            Value   = '0'
            Force   = $true
            Verbose = $true
          }
          New-ItemProperty @InputHT
        }

        # Disable Search box suggestions
        $path = "Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer"
        $name = 'DisableSearchBoxSuggestions'
        $RegItem = try {
          Get-Item -Path $path -Name $name -ErrorAction 'Stop'
        } catch {
          New-Item -Path $path -Name $name -Force -Verbose
        }
        $RegItemProp = try {
          Get-ItemProperty -Path $path -Name $name -ErrorAction 'Stop'
        } catch {
          $InputHT = @{
            Path    = $path
            Name    = $name
            Type    = 'Dword'
            Value   = '1'
            Force   = $true
            Verbose = $true
          }
          New-ItemProperty @InputHT
        }

        # Disable Tooltips. I love having shit pop up in front of what I'm currently reading.
        $path = "Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer"
        $name = 'ShowInfoTip'
        $RegItem = try {
          Get-Item -Path $path -Name $name -ErrorAction 'Stop'
        } catch {
          New-Item -Path $path -Name $name -Force -Verbose
        }
        $RegItemProp = try {
          Get-ItemProperty -Path $path -Name $name -ErrorAction 'Stop'
        } catch {
          $InputHT = @{
            Path    = $path
            Name    = $name
            Type    = 'Dword'
            Value   = '0'
            Force   = $true
            Verbose = $true
          }
          New-ItemProperty @InputHT
        }
        # reg.exe add "HKU\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3" /v "ShowInfoTip" /d 0 /t REG_DWORD /f
        $path = "Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer"
        $name = 'StuckRects3'
        $RegItem = try {
          Get-Item -Path $path -Name $name -ErrorAction 'Stop'
        } catch {
          New-Item -Path $path -Name $name -Force -Verbose
        }
        $path = "$path\$name"
        $name = 'ShowInfoTip'
        $RegItemProp = try {
          Get-ItemProperty -Path $path -Name $name -ErrorAction 'Stop'
        } catch {
          $InputHT = @{
            Path    = $path
            Name    = $name
            Type    = 'Dword'
            Value   = '0'
            Force   = $true
            Verbose = $true
          }
          New-ItemProperty @InputHT
        }

        # Enable taskbar developer settings, whatever that means...
        # reg.exe add "HKU\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings" /v TaskbarEndTask /t REG_DWORD /d 1 /f
        $path = "Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
        $name = 'TaskbarDeveloperSettings'
        $RegItem = try {
          Get-Item -Path $path -Name $name -ErrorAction 'Stop'
        } catch {
          New-Item -Path $path -Name $name -Force -Verbose
        }
        $path = "$path\$name"
        $name = 'TaskbarEndTask'
        $RegItemProp = try {
          Get-ItemProperty -Path $path -Name $name -ErrorAction 'Stop'
        } catch {
          $InputHT = @{
            Path    = $path
            Name    = $name
            Type    = 'Dword'
            Value   = '1'
            Force   = $true
            Verbose = $true
          }
          New-ItemProperty @InputHT
        }

        # Show hidden files?
        # reg.exe add "HKU\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Hidden" /t REG_DWORD /d 1 /f
        $path = "Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
        $name = 'Hidden'
        $RegItem = try {
          Get-Item -Path $path -Name $name -ErrorAction 'Stop'
        } catch {
          New-Item -Path $path -Name $name -Force -Verbose
        }
        $RegItemProp = try {
          Get-ItemProperty -Path $path -Name $name -ErrorAction 'Stop'
        } catch {
          $InputHT = @{
            Path    = $path
            Name    = $name
            Type    = 'Dword'
            Value   = '1'
            Force   = $true
            Verbose = $true
          }
          New-ItemProperty @InputHT
        }

        # Not sure what 'TaskbarAl' is...
        # reg.exe add "HKU\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v TaskbarAl /t REG_DWORD /d 0 /f
        $path = "Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
        $name = 'TaskbarAl'
        $RegItem = try {
          Get-Item -Path $path -Name $name -ErrorAction 'Stop'
        } catch {
          New-Item -Path $path -Name $name -Force -Verbose
        }
        $RegItemProp = try {
          Get-ItemProperty -Path $path -Name $name -ErrorAction 'Stop'
        } catch {
          $InputHT = @{
            Path    = $path
            Name    = $name
            Type    = 'Dword'
            Value   = '0'
            Force   = $true
            Verbose = $true
          }
          New-ItemProperty @InputHT
        }

        # Checkmark 'Decrease space between items (Compact View)'
        # Set-ItemProperty -LiteralPath "Registry::HKU\DefaultUser\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name 'UseCompactMode' -Type DWORD -Value "0x1" -Verbose -Force
        $path = "Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
        $name = 'UseCompactMode'
        $RegItem = try {
          Get-Item -Path $path -Name $name -ErrorAction 'Stop'
        } catch {
          New-Item -Path $path -Name $name -Force -Verbose
        }
        $RegItemProp = try {
          Get-ItemProperty -Path $path -Name $name -ErrorAction 'Stop'
        } catch {
          $InputHT = @{
            Path    = $path
            Name    = $name
            Type    = 'Dword'
            Value   = '0x1'
            Force   = $true
            Verbose = $true
          }
          Set-ItemProperty @InputHT
        }
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\Misc File Explorer Settings-Part 1.ps1')
        $XmlWriter.WriteString(${File Misc File Explorer Settings-Part 1.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion
    #region | "Copilot-DISABLE.ps1" Here-String and XML Element |
    ${File Copilot-DISABLE.ps1 Here-String} = $(
      "`n"
      "`t`t`t#reg.exe add $([System.Char]34)HKU\DefaultUser\Software\Policies\Microsoft\Windows\WindowsCopilot$([System.Char]34) /v TurnOffWindowsCopilot /t REG_DWORD /d 1 /f`n"
      "`t`t`t`$path = $([System.Char]34)Registry::HKEY_USERS\DefaultUser\Software\Policies\Microsoft\Windows$([System.Char]34)`n"
      "`t`t`t`$name = $([System.Char]39)WindowsCopilot$([System.Char]39)`n"
      "`t`t`t`$RegItem = try {`n"
      "`t`t`t  Get-Item -Path `$path -Name `$name -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  New-Item -Path `$path -Name `$name -Force -Verbose`n"
      "`t`t`t}`n"
      "`t`t`t`$path = $([System.Char]34)`$path\`$name$([System.Char]34)`n"
      "`t`t`t`$name = $([System.Char]39)TurnOffWindowsCopilot$([System.Char]39)`n"
      "`t`t`t`$RegItemProp = try {`n"
      "`t`t`t  Get-ItemProperty -Path `$path -Name `$name -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  `$InputHT = @{`n"
      "`t`t`t    Path    = `$path`n"
      "`t`t`t    Name    = `$name`n"
      "`t`t`t    Type    = $([System.Char]39)Dword$([System.Char]39)`n"
      "`t`t`t    Value   = $([System.Char]39)1$([System.Char]39)`n"
      "`t`t`t    Force   = `$true`n"
      "`t`t`t    Verbose = `$true`n"
      "`t`t`t  }`n"
      "`t`t`t  New-ItemProperty @InputHT`n"
      "`t`t`t}`n"
      "`t`t"
      {
        #reg.exe add "HKU\DefaultUser\Software\Policies\Microsoft\Windows\WindowsCopilot" /v TurnOffWindowsCopilot /t REG_DWORD /d 1 /f
        $path = "Registry::HKEY_USERS\DefaultUser\Software\Policies\Microsoft\Windows"
        $name = 'WindowsCopilot'
        $RegItem = try {
          Get-Item -Path $path -Name $name -ErrorAction 'Stop'
        } catch {
          New-Item -Path $path -Name $name -Force -Verbose
        }
        $path = "$path\$name"
        $name = 'TurnOffWindowsCopilot'
        $RegItemProp = try {
          Get-ItemProperty -Path $path -Name $name -ErrorAction 'Stop'
        } catch {
          $InputHT = @{
            Path    = $path
            Name    = $name
            Type    = 'Dword'
            Value   = '1'
            Force   = $true
            Verbose = $true
          }
          New-ItemProperty @InputHT
        }

      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\Copilot-DISABLE.ps1')
        $XmlWriter.WriteString(${File Copilot-DISABLE.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion
    #region | "SetWallpaper-DefaultUser.ps1" Here-String |
    ${File SetWallpaper-DefaultUser.ps1 Here-String} = $(

      #region |  |
      "`n"
      "`t`t`tAdd-Type -TypeDefinition $([System.Char]39)`n"
      "`t`t`t  using System.Drawing;`n"
      "`t`t`t  using System.Runtime.InteropServices;`n"
      "`t`t`t  public static class WallpaperSetter {`n"
      "`t`t`t    [DllImport($([System.Char]34)user32.dll$([System.Char]34))]`n"
      "`t`t`t    private static extern bool SetSysColors(`n"
      "`t`t`t      int cElements,`n"
      "`t`t`t      int[] lpaElements,`n"
      "`t`t`t      int[] lpaRgbValues`n"
      "`t`t`t    );                                            `n"
      "`t`t`t    [DllImport($([System.Char]34)user32.dll$([System.Char]34))]`n"
      "`t`t`t    private static extern bool SystemParametersInfo(`n"
      "`t`t`t      uint uiAction,`n"
      "`t`t`t      uint uiParam,`n"
      "`t`t`t      string pvParam,`n"
      "`t`t`t      uint fWinIni`n"
      "`t`t`t    );`n"
      "`t`t`t    public static void SetDesktopBackground(Color color) {`n"
      "`t`t`t      SystemParametersInfo(20, 0, $([System.Char]34)$([System.Char]34), 0);`n"
      "`t`t`t      SetSysColors(1, new int[] { 1 }, new int[] { ColorTranslator.ToWin32(color) });`n"
      "`t`t`t    }`n"
      "`t`t`t    public static void SetDesktopImage(string file) {`n"
      "`t`t`t      SystemParametersInfo(20, 0, file, 0);`n"
      "`t`t`t    }`n"
      "`t`t`t  }`n"
      "`t`t`t$([System.Char]39) -ReferencedAssemblies $([System.Char]39)System.Drawing$([System.Char]39);`n"
      "`t`t`tfunction Set-DefaultUserWallpaperColor {`n"
      "`t`t`t  param(`n"
      "`t`t`t    [string]`n"
      "`t`t`t    `$HtmlColor`n"
      "`t`t`t  );`n"
      "`t`t`t`n"
      "`t`t`t  `$color = [System.Drawing.ColorTranslator]::FromHtml( `$HtmlColor );`n"
      "`t`t`t  [WallpaperSetter]::SetDesktopBackground( `$color );`n"
      "`t`t`t`n"
      "`t`t`t  # Set-ItemProperty -Path $([System.Char]39)Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Wallpapers$([System.Char]39) -Name $([System.Char]39)BackgroundType$([System.Char]39) -Type $([System.Char]39)DWord$([System.Char]39) -Value 1 -Force;`n"
      "`t`t`t  `$path = $([System.Char]34)Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer$([System.Char]34)`n"
      "`t`t`t  `$name = $([System.Char]39)Wallpapers$([System.Char]39)`n"
      "`t`t`t  `$RegItem = try {`n"
      "`t`t`t    Get-Item -Path `$path -Name `$name -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t  } catch {`n"
      "`t`t`t    New-Item -Path `$path -Name `$name -Force -Verbose`n"
      "`t`t`t  }`n"
      "`t`t`t  `$path = $([System.Char]34)`$path\`$name$([System.Char]34)`n"
      "`t`t`t  `$name = $([System.Char]39)BackgroundType$([System.Char]39)`n"
      "`t`t`t  `$RegItemProp = try {`n"
      "`t`t`t    Get-ItemProperty -Path `$path -Name `$name -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t  } catch {`n"
      "`t`t`t    `$InputHT = @{`n"
      "`t`t`t      Path    = `$path`n"
      "`t`t`t      Name    = `$name`n"
      "`t`t`t      Type    = $([System.Char]39)Dword$([System.Char]39)`n"
      "`t`t`t      Value   = $([System.Char]39)1$([System.Char]39)`n"
      "`t`t`t      Force   = `$true`n"
      "`t`t`t      Verbose = `$true`n"
      "`t`t`t    }`n"
      "`t`t`t    New-ItemProperty @InputHT`n"
      "`t`t`t  }`n"
      "`t`t`t  `n"
      "`t`t`t  Set-ItemProperty -Path $([System.Char]39)Registry::HKEY_USERS\DefaultUser\Control Panel\Desktop$([System.Char]39) -Name $([System.Char]39)WallPaper$([System.Char]39) -Type $([System.Char]39)String$([System.Char]39) -Value $([System.Char]39)$([System.Char]39) -Force;`n"
      "`t`t`t  Set-ItemProperty -Path $([System.Char]39)Registry::HKEY_USERS\DefaultUser\Control Panel\Colors$([System.Char]39) -Name $([System.Char]39)Background$([System.Char]39) -Type $([System.Char]39)String$([System.Char]39) -Value $([System.Char]34)`$(`$color.R) `$(`$color.G) `$(`$color.B)$([System.Char]34) -Force;`n"
      "`t`t`t}`n"
      "`t`t`tfunction Set-DefaultUserWallpaperImage {`n"
      "`t`t`t  param(`n"
      "`t`t`t    [string]`n"
      "`t`t`t    `$LiteralPath`n"
      "`t`t`t  );`n"
      "`t`t`t`n"
      "`t`t`t  if( `$LiteralPath | Test-Path ) {`n"
      "`t`t`t    [WallpaperSetter]::SetDesktopImage( `$LiteralPath );`n"
      "`t`t`t`n"
      "`t`t`t    #Set-ItemProperty -Path $([System.Char]39)Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Wallpapers$([System.Char]39) -Name $([System.Char]39)BackgroundType$([System.Char]39) -Type $([System.Char]39)DWord$([System.Char]39) -Value 0 -Force;`n"
      "`t`t`t    `$path = $([System.Char]34)Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer$([System.Char]34)`n"
      "`t`t`t    `$name = $([System.Char]39)Wallpapers$([System.Char]39)`n"
      "`t`t`t    `$RegItem = try {`n"
      "`t`t`t      Get-Item -Path `$path -Name `$name -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t    } catch {`n"
      "`t`t`t      New-Item -Path `$path -Name `$name -Force -Verbose`n"
      "`t`t`t    }`n"
      "`t`t`t    `$path = $([System.Char]34)`$path\`$name$([System.Char]34)`n"
      "`t`t`t    `$name = $([System.Char]39)BackgroundType$([System.Char]39)`n"
      "`t`t`t    `$RegItemProp = try {`n"
      "`t`t`t      Get-ItemProperty -Path `$path -Name `$name -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t    } catch {`n"
      "`t`t`t      `$InputHT = @{`n"
      "`t`t`t        Path    = `$path`n"
      "`t`t`t        Name    = `$name`n"
      "`t`t`t        Type    = $([System.Char]39)Dword$([System.Char]39)`n"
      "`t`t`t        Value   = $([System.Char]39)0$([System.Char]39)`n"
      "`t`t`t        Force   = `$true`n"
      "`t`t`t        Verbose = `$true`n"
      "`t`t`t      }`n"
      "`t`t`t      New-ItemProperty @InputHT`n"
      "`t`t`t    }`n"
      "`t`t`t  `n"
      "`t`t`t    Set-ItemProperty -Path $([System.Char]39)Registry::HKEY_USERS\DefaultUser\Control Panel\Desktop$([System.Char]39) -Name $([System.Char]39)WallPaper$([System.Char]39) -Type $([System.Char]39)String$([System.Char]39) -Value `$LiteralPath -Force;`n"
      "`t`t`t  } else {`n"
      "`t`t`t    $([System.Char]34)Cannot use $([System.Char]39)`$LiteralPath$([System.Char]39) as a desktop wallpaper because that file does not exist.$([System.Char]34);`n"
      "`t`t`t  }`n"
      "`t`t`t}`n"
      "`t`t`tSet-DefaultUserWallpaperColor -HtmlColor $([System.Char]39)#0A0F0F$([System.Char]39);`n"
      "`t`t"
      #endregion

      { # SetWallpaper-DefaultUser.ps1 Plain-Text | Converted to ${File SetWallpaper-DefaultUser.ps1 Here-String} with 'ConvertTo-HereStringCompatible' | Mysteries of PInvoke |
        Add-Type -TypeDefinition '
          using System.Drawing;
          using System.Runtime.InteropServices;
          public static class WallpaperSetter {
            [DllImport("user32.dll")]
            private static extern bool SetSysColors(
              int cElements,
              int[] lpaElements,
              int[] lpaRgbValues
            );                                            
            [DllImport("user32.dll")]
            private static extern bool SystemParametersInfo(
              uint uiAction,
              uint uiParam,
              string pvParam,
              uint fWinIni
            );
            public static void SetDesktopBackground(Color color) {
              SystemParametersInfo(20, 0, "", 0);
              SetSysColors(1, new int[] { 1 }, new int[] { ColorTranslator.ToWin32(color) });
            }
            public static void SetDesktopImage(string file) {
              SystemParametersInfo(20, 0, file, 0);
            }
          }
        ' -ReferencedAssemblies 'System.Drawing';
        function Set-DefaultUserWallpaperColor {
          param(
            [string]
            $HtmlColor
          );

          $color = [System.Drawing.ColorTranslator]::FromHtml( $HtmlColor );
          [WallpaperSetter]::SetDesktopBackground( $color );

          # Set-ItemProperty -Path 'Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Wallpapers' -Name 'BackgroundType' -Type 'DWord' -Value 1 -Force;
          $path = "Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer"
          $name = 'Wallpapers'
          $RegItem = try {
            Get-Item -Path $path -Name $name -ErrorAction 'Stop'
          } catch {
            New-Item -Path $path -Name $name -Force -Verbose
          }
          $path = "$path\$name"
          $name = 'BackgroundType'
          $RegItemProp = try {
            Get-ItemProperty -Path $path -Name $name -ErrorAction 'Stop'
          } catch {
            $InputHT = @{
              Path    = $path
              Name    = $name
              Type    = 'Dword'
              Value   = '1'
              Force   = $true
              Verbose = $true
            }
            New-ItemProperty @InputHT
          }
          
          Set-ItemProperty -Path 'Registry::HKEY_USERS\DefaultUser\Control Panel\Desktop' -Name 'WallPaper' -Type 'String' -Value '' -Force;
          Set-ItemProperty -Path 'Registry::HKEY_USERS\DefaultUser\Control Panel\Colors' -Name 'Background' -Type 'String' -Value "$($color.R) $($color.G) $($color.B)" -Force;
        }
        function Set-DefaultUserWallpaperImage {
          param(
            [string]
            $LiteralPath
          );

          if( $LiteralPath | Test-Path ) {
            [WallpaperSetter]::SetDesktopImage( $LiteralPath );

            #Set-ItemProperty -Path 'Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Wallpapers' -Name 'BackgroundType' -Type 'DWord' -Value 0 -Force;
            $path = "Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer"
            $name = 'Wallpapers'
            $RegItem = try {
              Get-Item -Path $path -Name $name -ErrorAction 'Stop'
            } catch {
              New-Item -Path $path -Name $name -Force -Verbose
            }
            $path = "$path\$name"
            $name = 'BackgroundType'
            $RegItemProp = try {
              Get-ItemProperty -Path $path -Name $name -ErrorAction 'Stop'
            } catch {
              $InputHT = @{
                Path    = $path
                Name    = $name
                Type    = 'Dword'
                Value   = '0'
                Force   = $true
                Verbose = $true
              }
              New-ItemProperty @InputHT
            }
          
            Set-ItemProperty -Path 'Registry::HKEY_USERS\DefaultUser\Control Panel\Desktop' -Name 'WallPaper' -Type 'String' -Value $LiteralPath -Force;
          } else {
            "Cannot use '$LiteralPath' as a desktop wallpaper because that file does not exist.";
          }
        }
        Set-DefaultUserWallpaperColor -HtmlColor '#0A0F0F';
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\SetWallpaper-DefaultUser.ps1')
        $XmlWriter.WriteString(${File SetWallpaper-DefaultUser.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion
    #region | "Taskbar Modifications-Part 2.ps1" Here-String and XML Element |
    ${File Taskbar Modifications-Part 2.ps1 Here-String} = $(
      "`n"
      "`t`t`t# reg.exe add $([System.Char]34)HKU\DefaultUser\Software\Policies\Microsoft\Windows\Explorer$([System.Char]34) /v $([System.Char]34)StartLayoutFile$([System.Char]34) /t $([System.Char]34)REG_SZ$([System.Char]34) /d $([System.Char]34)C:\Windows\Setup\Scripts\TaskbarLayoutModification.xml$([System.Char]34) /f`n"
      "`t`t`t`$path = $([System.Char]34)Registry::HKEY_USERS\DefaultUser\Software\Policies\Microsoft\Windows\Explorer$([System.Char]34)`n"
      "`t`t`t`$name = $([System.Char]39)StartLayoutFile$([System.Char]39)`n"
      "`t`t`t`$RegItem = try {`n"
      "`t`t`t  Get-Item -Path `$path -Name `$name -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  New-Item -Path `$path -Name `$name -Force -Verbose`n"
      "`t`t`t}`n"
      "`t`t`t`$path = $([System.Char]34)`$path\`$name$([System.Char]34)`n"
      "`t`t`t`$name = $([System.Char]39)C:\Windows\Setup\Scripts\TaskbarLayoutModification.xml$([System.Char]39)`n"
      "`t`t`t`$RegItemProp = try {`n"
      "`t`t`t  Get-ItemProperty -Path `$path -Name `$name -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  `$InputHT = @{`n"
      "`t`t`t    Path    = `$path`n"
      "`t`t`t    Name    = `$name`n"
      "`t`t`t    Type    = $([System.Char]39)String$([System.Char]39)`n"
      "`t`t`t    Value   = $([System.Char]39)1$([System.Char]39)`n"
      "`t`t`t    Force   = `$true`n"
      "`t`t`t    Verbose = `$true`n"
      "`t`t`t  }`n"
      "`t`t`t  New-ItemProperty @InputHT`n"
      "`t`t`t}`n"
      "`t`t`t`n"
      "`t`t`t# reg.exe add $([System.Char]34)HKU\DefaultUser\Software\Policies\Microsoft\Windows\Explorer$([System.Char]34) /v $([System.Char]34)LockedStartLayout$([System.Char]34) /t REG_DWORD /d 1 /f`n"
      "`t`t`t`$path = $([System.Char]34)Registry::HKEY_USERS\DefaultUser\Software\Policies\Microsoft\Windows\Explorer$([System.Char]34)`n"
      "`t`t`t`$name = $([System.Char]39)LockedStartLayout$([System.Char]39)`n"
      "`t`t`t`$RegItem = try {`n"
      "`t`t`t  Get-Item -Path `$path -Name `$name -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  New-Item -Path `$path -Name `$name -Force -Verbose`n"
      "`t`t`t}`n"
      "`t`t`t`$RegItemProp = try {`n"
      "`t`t`t  Get-ItemProperty -Path `$path -Name `$name -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  `$InputHT = @{`n"
      "`t`t`t    Path    = `$path`n"
      "`t`t`t    Name    = `$name`n"
      "`t`t`t    Type    = $([System.Char]39)Dword$([System.Char]39)`n"
      "`t`t`t    Value   = $([System.Char]39)1$([System.Char]39)`n"
      "`t`t`t    Force   = `$true`n"
      "`t`t`t    Verbose = `$true`n"
      "`t`t`t  }`n"
      "`t`t`t  New-ItemProperty @InputHT`n"
      "`t`t`t}`n"
      "`t`t"
      {
        ## Show all icons in the System Tray. Do not collapse system tray icons into a sub-menu

        # reg.exe add "HKU\DefaultUser\Software\Policies\Microsoft\Windows\Explorer" /v "StartLayoutFile" /t "REG_SZ" /d "C:\Windows\Setup\Scripts\TaskbarLayoutModification.xml" /f
        $path = "Registry::HKEY_USERS\DefaultUser\Software\Policies\Microsoft\Windows\Explorer"
        $name = 'StartLayoutFile'
        $RegItem = try {
          Get-Item -Path $path -Name $name -ErrorAction 'Stop'
        } catch {
          New-Item -Path $path -Name $name -Force -Verbose
        }
        $path = "$path\$name"
        $name = 'C:\Windows\Setup\Scripts\TaskbarLayoutModification.xml'
        $RegItemProp = try {
          Get-ItemProperty -Path $path -Name $name -ErrorAction 'Stop'
        } catch {
          $InputHT = @{
            Path    = $path
            Name    = $name
            Type    = 'String'
            Value   = '1'
            Force   = $true
            Verbose = $true
          }
          New-ItemProperty @InputHT
        }

        # reg.exe add "HKU\DefaultUser\Software\Policies\Microsoft\Windows\Explorer" /v "LockedStartLayout" /t REG_DWORD /d 1 /f
        $path = "Registry::HKEY_USERS\DefaultUser\Software\Policies\Microsoft\Windows\Explorer"
        $name = 'LockedStartLayout'
        $RegItem = try {
          Get-Item -Path $path -Name $name -ErrorAction 'Stop'
        } catch {
          New-Item -Path $path -Name $name -Force -Verbose
        }
        $RegItemProp = try {
          Get-ItemProperty -Path $path -Name $name -ErrorAction 'Stop'
        } catch {
          $InputHT = @{
            Path    = $path
            Name    = $name
            Type    = 'Dword'
            Value   = '1'
            Force   = $true
            Verbose = $true
          }
          New-ItemProperty @InputHT
        }
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\Taskbar Modifications-Part 2.ps1')
        $XmlWriter.WriteString(${File Taskbar Modifications-Part 2.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion

    #region | "Task View Button-HIDE.ps1" Here-String and XML Element |
    ${File Task View Button-HIDE.ps1 Here-String} = $(
      "`n"
      "`t`t`t# reg.exe add $([System.Char]34)HKU\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34) /v ShowTaskViewButton /t REG_DWORD /d 0 /f`n"
      "`t`t`t# Set-ItemProperty -LiteralPath $([System.Char]34)Registry::HKU\DefaultUser\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34) -Name $([System.Char]39)ShowTaskViewButton$([System.Char]39) -Type $([System.Char]39)DWORD$([System.Char]39) -Value $([System.Char]34)0x0$([System.Char]34) -Force -Verbose`n"
      "`t`t`t`$path = $([System.Char]34)Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34)`n"
      "`t`t`t`$name = $([System.Char]39)ShowTaskViewButton$([System.Char]39)`n"
      "`t`t`t`$RegItem = try {`n"
      "`t`t`t  Get-Item -Path `$path -Name `$name -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  New-Item -Path `$path -Name `$name -Force -Verbose`n"
      "`t`t`t}`n"
      "`t`t`t`$RegItemProp = try {`n"
      "`t`t`t  Get-ItemProperty -Path `$path -Name `$name -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  `$InputHT = @{`n"
      "`t`t`t    Path    = `$path`n"
      "`t`t`t    Name    = `$name`n"
      "`t`t`t    Type    = $([System.Char]39)Dword$([System.Char]39)`n"
      "`t`t`t    Value   = $([System.Char]39)0x0$([System.Char]39)`n"
      "`t`t`t    Force   = `$true`n"
      "`t`t`t    Verbose = `$true`n"
      "`t`t`t  }`n"
      "`t`t`t  Set-ItemProperty @InputHT`n"
      "`t`t`t}`n"
      "`t`t"
      {
        # reg.exe add "HKU\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v ShowTaskViewButton /t REG_DWORD /d 0 /f
        # Set-ItemProperty -LiteralPath "Registry::HKU\DefaultUser\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name 'ShowTaskViewButton' -Type 'DWORD' -Value "0x0" -Force -Verbose
        $path = "Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
        $name = 'ShowTaskViewButton'
        $RegItem = try {
          Get-Item -Path $path -Name $name -ErrorAction 'Stop'
        } catch {
          New-Item -Path $path -Name $name -Force -Verbose
        }
        $RegItemProp = try {
          Get-ItemProperty -Path $path -Name $name -ErrorAction 'Stop'
        } catch {
          $InputHT = @{
            Path    = $path
            Name    = $name
            Type    = 'Dword'
            Value   = '0x0'
            Force   = $true
            Verbose = $true
          }
          Set-ItemProperty @InputHT
        }
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\Task View Button-HIDE.ps1')
        $XmlWriter.WriteString(${File Task View Button-HIDE.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion
    #region | "Content Delivery Manager-Leave Preinstalled Apps DISABLED.ps1" Here-String and XML Element |
    ${File Content Delivery Manager-Leave Preinstalled Apps DISABLED.ps1 Here-String} = $(
      "`n"
      "`t`t`t`$names = @(`n"
      "`t`t`t  $([System.Char]39)ContentDeliveryAllowed$([System.Char]39)`n"
      "`t`t`t  $([System.Char]39)FeatureManagementEnabled$([System.Char]39)`n"
      "`t`t`t  $([System.Char]39)OEMPreInstalledAppsEnabled$([System.Char]39)`n"
      "`t`t`t  $([System.Char]39)PreInstalledAppsEnabled$([System.Char]39)`n"
      "`t`t`t  $([System.Char]39)PreInstalledAppsEverEnabled$([System.Char]39)`n"
      "`t`t`t  $([System.Char]39)SilentInstalledAppsEnabled$([System.Char]39)`n"
      "`t`t`t  $([System.Char]39)SoftLandingEnabled$([System.Char]39)`n"
      "`t`t`t  $([System.Char]39)SubscribedContent-310093Enabled$([System.Char]39)`n"
      "`t`t`t  $([System.Char]39)SubscribedContent-338387Enabled$([System.Char]39)`n"
      "`t`t`t  $([System.Char]39)SubscribedContent-338388Enabled$([System.Char]39)`n"
      "`t`t`t  $([System.Char]39)SubscribedContent-338389Enabled$([System.Char]39)`n"
      "`t`t`t  $([System.Char]39)SubscribedContent-338393Enabled$([System.Char]39)`n"
      "`t`t`t  $([System.Char]39)SubscribedContent-353694Enabled$([System.Char]39)`n"
      "`t`t`t  $([System.Char]39)SubscribedContent-353696Enabled$([System.Char]39)`n"
      "`t`t`t  $([System.Char]39)SubscribedContent-353698Enabled$([System.Char]39)`n"
      "`t`t`t  $([System.Char]39)SubscribedContentEnabled$([System.Char]39)`n"
      "`t`t`t  $([System.Char]39)SystemPaneSuggestionsEnabled$([System.Char]39)`n"
      "`t`t`t)`n"
      "`t`t`tforeach (`$name in `$names){`n"
      "`t`t`t  #reg.exe add $([System.Char]34)HKU\DefaultUser\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager$([System.Char]34) /v `$name /t REG_DWORD /d 0 /f`n"
      "`t`t`t  `$path = $([System.Char]34)Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows\CurrentVersion$([System.Char]34)`n"
      "`t`t`t  `$ParentName = $([System.Char]39)ContentDeliveryManager$([System.Char]39)`n"
      "`t`t`t  `$RegItem = try {`n"
      "`t`t`t    Get-Item -Path `$path -Name `$ParentName -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t  } catch {`n"
      "`t`t`t    New-Item -Path `$path -Name `$ParentName -Force -Verbose`n"
      "`t`t`t  }`n"
      "`t`t`t  `$path = $([System.Char]34)`$path\`$ParentName$([System.Char]34)`n"
      "`t`t`t  `$RegItemProp = try {`n"
      "`t`t`t    Get-ItemProperty -Path `$path -Name `$name -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t  } catch {`n"
      "`t`t`t    `$InputHT = @{`n"
      "`t`t`t      Path    = `$path`n"
      "`t`t`t      Name    = `$name`n"
      "`t`t`t      Type    = $([System.Char]39)Dword$([System.Char]39)`n"
      "`t`t`t      Value   = $([System.Char]39)0$([System.Char]39)`n"
      "`t`t`t      Force   = `$true`n"
      "`t`t`t      Verbose = `$true`n"
      "`t`t`t    }`n"
      "`t`t`t    New-ItemProperty @InputHT`n"
      "`t`t`t  }`n"
      "`t`t`t}`n"
      "`t`t"
      {
        $names = @(
          'ContentDeliveryAllowed'
          'FeatureManagementEnabled'
          'OEMPreInstalledAppsEnabled'
          'PreInstalledAppsEnabled'
          'PreInstalledAppsEverEnabled'
          'SilentInstalledAppsEnabled'
          'SoftLandingEnabled'
          'SubscribedContent-310093Enabled'
          'SubscribedContent-338387Enabled'
          'SubscribedContent-338388Enabled'
          'SubscribedContent-338389Enabled'
          'SubscribedContent-338393Enabled'
          'SubscribedContent-353694Enabled'
          'SubscribedContent-353696Enabled'
          'SubscribedContent-353698Enabled'
          'SubscribedContentEnabled'
          'SystemPaneSuggestionsEnabled'
        )
        foreach ($name in $names){
          #reg.exe add "HKU\DefaultUser\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v $name /t REG_DWORD /d 0 /f
          $path = "Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows\CurrentVersion"
          $ParentName = 'ContentDeliveryManager'
          $RegItem = try {
            Get-Item -Path $path -Name $ParentName -ErrorAction 'Stop'
          } catch {
            New-Item -Path $path -Name $ParentName -Force -Verbose
          }
          $path = "$path\$ParentName"
          $RegItemProp = try {
            Get-ItemProperty -Path $path -Name $name -ErrorAction 'Stop'
          } catch {
            $InputHT = @{
              Path    = $path
              Name    = $name
              Type    = 'Dword'
              Value   = '0'
              Force   = $true
              Verbose = $true
            }
            New-ItemProperty @InputHT
          }
        }
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\Content Delivery Manager-Leave Preinstalled Apps DISABLED.ps1')
        $XmlWriter.WriteString(${File Content Delivery Manager-Leave Preinstalled Apps DISABLED.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion
    #region | "Sticky Keys-DISABLED DefaultUser version.ps1" Here-String and XML Element |
    ${File Sticky Keys-DISABLED DefaultUser version.ps1 Here-String} = $(
      "`n"
      "`t`t`t# reg.exe add $([System.Char]34)HKU\DefaultUser\Control Panel\Accessibility\StickyKeys$([System.Char]34) /v Flags /t REG_SZ /d 10 /f`n"
      "`t`t`t`$path = $([System.Char]34)Registry::HKEY_USERS\DefaultUser\Control Panel\Accessibility\StickyKeys$([System.Char]34)`n"
      "`t`t`t`$name = $([System.Char]39)Flags$([System.Char]39)`n"
      "`t`t`t`$RegItem = try {`n"
      "`t`t`t  Get-Item -Path `$path -Name `$name -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  New-Item -Path `$path -Name `$name -Force -Verbose`n"
      "`t`t`t}`n"
      "`t`t`t`$RegItemProp = try {`n"
      "`t`t`t  Get-ItemProperty -Path `$path -Name `$name -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  `$InputHT = @{`n"
      "`t`t`t    Path    = `$path`n"
      "`t`t`t    Name    = `$name`n"
      "`t`t`t    Type    = $([System.Char]39)String$([System.Char]39)`n"
      "`t`t`t    Value   = $([System.Char]39)10$([System.Char]39)`n"
      "`t`t`t    Force   = `$true`n"
      "`t`t`t    Verbose = `$true`n"
      "`t`t`t  }`n"
      "`t`t`t  New-ItemProperty @InputHT`n"
      "`t`t`t}`n"
      "`t`t"
      {
        # reg.exe add "HKU\DefaultUser\Control Panel\Accessibility\StickyKeys" /v Flags /t REG_SZ /d 10 /f
        $path = "Registry::HKEY_USERS\DefaultUser\Control Panel\Accessibility\StickyKeys"
        $name = 'Flags'
        $RegItem = try {
          Get-Item -Path $path -Name $name -ErrorAction 'Stop'
        } catch {
          New-Item -Path $path -Name $name -Force -Verbose
        }
        $RegItemProp = try {
          Get-ItemProperty -Path $path -Name $name -ErrorAction 'Stop'
        } catch {
          $InputHT = @{
            Path    = $path
            Name    = $name
            Type    = 'String'
            Value   = '10'
            Force   = $true
            Verbose = $true
          }
          New-ItemProperty @InputHT
        }
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\Sticky Keys-DISABLED DefaultUser version.ps1')
        $XmlWriter.WriteString(${File Sticky Keys-DISABLED DefaultUser version.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion
    #region | "Taskbar System Tray Chevron Visibility-Always Show.ps1" Here-String and XML Element |
    ${File Taskbar System Tray Chevron Visibility-Always Show.ps1 Here-String} = $(
      #region |  |
      "`n"
      "`t`t`t# reg.exe add $([System.Char]34)HKU\DefaultUser\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify$([System.Char]34) /v $([System.Char]34)SystemTrayChevronVisibility$([System.Char]34) /d 1 /t REG_DWORD /f`n"
      "`t`t`t`$path = $([System.Char]34)Registry::HKEY_USERS\DefaultUser\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify$([System.Char]34)`n"
      "`t`t`t`$name = $([System.Char]39)SystemTrayChevronVisibility$([System.Char]39)`n"
      "`t`t`t`$RegItem = try {`n"
      "`t`t`t  Get-Item -Path `$path -Name `$name -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  New-Item -Path `$path -Name `$name -Force -Verbose`n"
      "`t`t`t}`n"
      "`t`t`t`$RegItemProp = try {`n"
      "`t`t`t  Get-ItemProperty -Path `$path -Name `$name -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  `$InputHT = @{`n"
      "`t`t`t    Path    = `$path`n"
      "`t`t`t    Name    = `$name`n"
      "`t`t`t    Value   = $([System.Char]39)1$([System.Char]39)`n"
      "`t`t`t    Force   = `$true`n"
      "`t`t`t    Verbose = `$true`n"
      "`t`t`t  }`n"
      "`t`t`t  Set-ItemProperty @InputHT`n"
      "`t`t`t}`n"
      "`t`t"
      #endregion
      {
        # Get-Item -Path "HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify"
        # Set-ItemProperty -Path "Registry::HKU\DefaultUser\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify" -Name 'SystemTrayChevronVisibility' -Value '1'
        # reg.exe add "HKU\DefaultUser\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify" /v "SystemTrayChevronVisibility" /d 1 /t REG_DWORD /f
        $path = "Registry::HKEY_USERS\DefaultUser\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify"
        $name = 'SystemTrayChevronVisibility'
        $RegItem = try {
          Get-Item -Path $path -Name $name -ErrorAction 'Stop'
        } catch {
          New-Item -Path $path -Name $name -Force -Verbose
        }
        $RegItemProp = try {
          Get-ItemProperty -Path $path -Name $name -ErrorAction 'Stop'
        } catch {
          $InputHT = @{
            Path    = $path
            Name    = $name
            Value   = '1'
            Force   = $true
            Verbose = $true
          }
          Set-ItemProperty @InputHT
        }
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\Taskbar System Tray Chevron Visibility-Always Show.ps1')
        $XmlWriter.WriteString(${File Taskbar System Tray Chevron Visibility-Always Show.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion

    #region | "Accent Color on Start, Taskbar, Action Center-NONE.ps1" Here-String and XML Element |
    ${File Accent Color on Start, Taskbar, Action Center-NONE.ps1 Here-String} = $(
      #region |  |
      "`n"
      "`t`t`t# reg.exe add $([System.Char]34)HKU\DefaultUser\Software\Microsoft\Windows\DWM$([System.Char]34) /v ColorPrevalence /t REG_DWORD /d 0 /f`n"
      "`t`t`t`$path = $([System.Char]34)Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows$([System.Char]34)`n"
      "`t`t`t`$name = $([System.Char]39)DWM$([System.Char]39)`n"
      "`t`t`t`$RegItem = try {`n"
      "`t`t`t  Get-Item -Path `$path -Name `$name -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  New-Item -Path `$path -Name `$name -Force -Verbose`n"
      "`t`t`t}`n"
      "`t`t`t`$path = $([System.Char]34)`$path\`$name$([System.Char]34)`n"
      "`t`t`t`$name = $([System.Char]39)ColorPrevalence$([System.Char]39)`n"
      "`t`t`t`$RegItemProp = try {`n"
      "`t`t`t  Get-ItemProperty -Path `$path -Name `$name -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  `$InputHT = @{`n"
      "`t`t`t    Path    = `$path`n"
      "`t`t`t    Name    = `$name`n"
      "`t`t`t    Value   = $([System.Char]39)0$([System.Char]39)`n"
      "`t`t`t    Type    = $([System.Char]39)Dword$([System.Char]39)`n"
      "`t`t`t    Force   = `$true`n"
      "`t`t`t    Verbose = `$true`n"
      "`t`t`t  }`n"
      "`t`t`t  New-ItemProperty @InputHT`n"
      "`t`t`t}`n"
      "`t`t"
      #endregion
      {
        # reg.exe add "HKU\DefaultUser\Software\Microsoft\Windows\DWM" /v ColorPrevalence /t REG_DWORD /d 0 /f
        $path = "Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows"
        $name = 'DWM'
        $RegItem = try {
          Get-Item -Path $path -Name $name -ErrorAction 'Stop'
        } catch {
          New-Item -Path $path -Name $name -Force -Verbose
        }
        $path = "$path\$name"
        $name = 'ColorPrevalence'
        $RegItemProp = try {
          Get-ItemProperty -Path $path -Name $name -ErrorAction 'Stop'
        } catch {
          $InputHT = @{
            Path    = $path
            Name    = $name
            Value   = '0'
            Type    = 'Dword'
            Force   = $true
            Verbose = $true
          }
          New-ItemProperty @InputHT
        }
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\Accent Color on Start, Taskbar, Action Center-NONE.ps1')
        $XmlWriter.WriteString(${File Accent Color on Start, Taskbar, Action Center-NONE.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion
    #region | "Set the UserOnce.ps1 File to Execute at Next Logon.ps1" Here-String and XML Element |
    ${File Set the UserOnce.ps1 File to Execute at Next Logon.ps1 Here-String} = $(
      #region |  |
      "`n"
      "`t`t`t#   reg.exe add $([System.Char]34)HKU\DefaultUser\Software\Microsoft\Windows\CurrentVersion\RunOnce$([System.Char]34) /v $([System.Char]34)UnattendedSetup$([System.Char]34) /t REG_SZ /d $([System.Char]34)powershell.exe -WindowStyle \$([System.Char]34)$([System.Char]34)Normal\$([System.Char]34)$([System.Char]34) -ExecutionPolicy \$([System.Char]34)$([System.Char]34)Unrestricted\$([System.Char]34)$([System.Char]34) -File \$([System.Char]34)$([System.Char]34)C:\Windows\Setup\Scripts\UserOnce.ps1\$([System.Char]34)$([System.Char]34)$([System.Char]34) /f`n"
      "`t`t`t`$path = $([System.Char]34)Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows\CurrentVersion$([System.Char]34)`n"
      "`t`t`t`$name = $([System.Char]39)RunOnce$([System.Char]39)`n"
      "`t`t`t`$RegItem = try {`n"
      "`t`t`t  Get-Item -Path `$path -Name `$name -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  New-Item -Path `$path -Name `$name -Force -Verbose`n"
      "`t`t`t}`n"
      "`t`t`t`$path = $([System.Char]34)`$path\`$name$([System.Char]34)`n"
      "`t`t`t`$name = $([System.Char]39)UnattendedSetup$([System.Char]39)`n"
      "`t`t`t`$RegItemProp = try {`n"
      "`t`t`t  Get-ItemProperty -Path `$path -Name `$name -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  `$InputHT = @{`n"
      "`t`t`t    Path    = `$path`n"
      "`t`t`t    Name    = `$name`n"
      "`t`t`t    #Value   = $([System.Char]34)powershell.exe -WindowStyle `$([System.Char]39)Maximized`$([System.Char]39) -ExecutionPolicy `$([System.Char]39)RemoteSigned`$([System.Char]39) -File `$([System.Char]39)C:\Windows\Setup\Scripts\UserOnce.ps1`$([System.Char]39)$([System.Char]34)`n"
      "`t`t`t    Value   = $([System.Char]34)powershell.exe -WindowStyle `$([System.Char]34)Maximized`$([System.Char]34) -ExecutionPolicy `$([System.Char]34)RemoteSigned`$([System.Char]34) -File `$([System.Char]34)C:\Windows\Setup\Scripts\UserOnce.ps1`$([System.Char]34)$([System.Char]34)`n"
      "`t`t`t    Type    = $([System.Char]39)String$([System.Char]39)`n"
      "`t`t`t    Force   = `$true`n"
      "`t`t`t    Verbose = `$true`n"
      "`t`t`t  }`n"
      "`t`t`t  New-ItemProperty @InputHT`n"
      "`t`t`t}`n"
      "`t`t"
      #endregion
      {
        #   reg.exe add "HKU\DefaultUser\Software\Microsoft\Windows\CurrentVersion\RunOnce" /v "UnattendedSetup" /t REG_SZ /d "powershell.exe -WindowStyle \""Normal\"" -ExecutionPolicy \""Unrestricted\"" -File \""C:\Windows\Setup\Scripts\UserOnce.ps1\""" /f
        $path = "Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows\CurrentVersion"
        $name = 'RunOnce'
        $RegItem = try {
          Get-Item -Path $path -Name $name -ErrorAction 'Stop'
        } catch {
          New-Item -Path $path -Name $name -Force -Verbose
        }
        $path = "$path\$name"
        $name = 'UnattendedSetup'
        $RegItemProp = try {
          Get-ItemProperty -Path $path -Name $name -ErrorAction 'Stop'
        } catch {
          $InputHT = @{
            Path    = $path
            Name    = $name
            #Value   = "powershell.exe -WindowStyle $([System.Char]39)Maximized$([System.Char]39) -ExecutionPolicy $([System.Char]39)RemoteSigned$([System.Char]39) -File $([System.Char]39)C:\Windows\Setup\Scripts\UserOnce.ps1$([System.Char]39)"
            Value   = "powershell.exe -WindowStyle $([System.Char]34)Maximized$([System.Char]34) -ExecutionPolicy $([System.Char]34)RemoteSigned$([System.Char]34) -File $([System.Char]34)C:\Windows\Setup\Scripts\UserOnce.ps1$([System.Char]34)"
            Type    = 'String'
            Force   = $true
            Verbose = $true
          }
          New-ItemProperty @InputHT
        }
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\Set the UserOnce.ps1 File to Execute at Next Logon.ps1')
        $XmlWriter.WriteString(${File Set the UserOnce.ps1 File to Execute at Next Logon.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion
    #region | "Display-Scale to 100 Percent (96 DPI)-DefaultUser.ps1" Here-String and XML Element |
    ${File Display-Scale to 100 Percent (96 DPI)-DefaultUser.ps1 Here-String} = $(
      #region |  |
      "`n"
      "`t`t`t# by Tracy Le`n"
      "`t`t`t# Reference: start msedge.exe $([System.Char]39)https://learn.microsoft.com/en-us/answers/questions/5577484/powershell-script-to-set-the-scale-of-all-the-conn$([System.Char]39)`n"
      "`t`t`t##`n"
      "`t`t`t# This script sets the display DPI scaling to 100% (96 DPI) for all users.`n"
      "`t`t`t# It must be run with elevated privileges (as Administrator or SYSTEM).`n"
      "`t`t`tfunction Set-DefaultUserDpiScaling {`n"
      "`t`t`t  param (`n"
      "`t`t`t    [string]`$RegistryPath,`n"
      "`t`t`t    [int]`$DpiValue = 96 # 96 DPI corresponds to 100% scaling`n"
      "`t`t`t  )`n"
      "`t`t`t  try {`n"
      "`t`t`t    `$desktopPath = Join-Path -Path `$RegistryPath -ChildPath $([System.Char]34)Control Panel\Desktop$([System.Char]34)`n"
      "`t`t`t    `$metricsPath = Join-Path -Path `$desktopPath -ChildPath $([System.Char]34)WindowMetrics$([System.Char]34)`n"
      "`t`t`t    # Ensure the registry paths exist before trying to set properties`n"
      "`t`t`t    if (Test-Path -Path `$desktopPath) {`n"
      "`t`t`t      # Set legacy scaling values for compatibility`n"
      "`t`t`t      Set-ItemProperty -Path `$desktopPath -Name $([System.Char]34)Win8DpiScaling$([System.Char]34) -Value 1 -Type DWord -Force -ErrorAction Stop`n"
      "`t`t`t      Set-ItemProperty -Path `$desktopPath -Name $([System.Char]34)LogPixels$([System.Char]34) -Value `$DpiValue -Type DWord -Force -ErrorAction Stop`n"
      "`t`t`t    }`n"
      "`t`t`t    if (Test-Path -Path `$metricsPath) {`n"
      "`t`t`t      # Set modern scaling value`n"
      "`t`t`t      Set-ItemProperty -Path `$metricsPath -Name $([System.Char]34)AppliedDPI$([System.Char]34) -Value `$DpiValue -Type DWord -Force -ErrorAction Stop`n"
      "`t`t`t    }`n"
      "`t`t`t    Write-Host $([System.Char]34)Successfully applied DPI settings to path: `$RegistryPath$([System.Char]34)`n"
      "`t`t`t  }`n"
      "`t`t`t  catch {`n"
      "`t`t`t    Write-Warning $([System.Char]34)Could not apply DPI settings to $([System.Char]39)`$RegistryPath$([System.Char]39). Error: `$(`$_.Exception.Message)$([System.Char]34)`n"
      "`t`t`t  }`n"
      "`t`t`t}`n"
      "`t`t`t#--No Need To Perform Before 1st Logon--# # --- Step 1: Apply to all currently logged-in users ---`n"
      "`t`t`t#--No Need To Perform Before 1st Logon--# Write-Host $([System.Char]34)Applying settings for currently loaded user profiles...$([System.Char]34)`n"
      "`t`t`t#--No Need To Perform Before 1st Logon--# `$loadedSids = Get-ChildItem $([System.Char]34)Registry::HKEY_USERS$([System.Char]34) | Where-Object { `$_.Name -like $([System.Char]34)*S-1-5-21-*$([System.Char]34) } | ForEach-Object { `$_.PSChildName }`n"
      "`t`t`t#--No Need To Perform Before 1st Logon--# foreach (`$sid in `$loadedSids) {`n"
      "`t`t`t#--No Need To Perform Before 1st Logon--#   `$userHivePath = $([System.Char]34)Registry::HKEY_USERS\`$sid$([System.Char]34)`n"
      "`t`t`t#--No Need To Perform Before 1st Logon--#   Set-DefaultUserDpiScaling -RegistryPath `$userHivePath`n"
      "`t`t`t#--No Need To Perform Before 1st Logon--# }`n"
      "`t`t`t# --- Step 2: Apply to the Default User Profile for all future users ---`n"
      "`t`t`tWrite-Host $([System.Char]34)Applying settings to the Default User Profile...$([System.Char]34)`n"
      "`t`t`ttry {`n"
      "`t`t`t  #--Already performed prior to script execution--# # Load the default user hive from its file location`n"
      "`t`t`t  #--Already performed prior to script execution--# reg load $([System.Char]34)HKU\DefaultUser$([System.Char]34) $([System.Char]34)C:\Users\Default\NTUSER.DAT$([System.Char]34) | Out-Null`n"
      "`t`t`t  Set-DefaultUserDpiScaling -RegistryPath $([System.Char]34)Registry::HKEY_USERS\DefaultUser$([System.Char]34)`n"
      "`t`t`t}`n"
      "`t`t`tcatch {`n"
      "`t`t`t  Write-Warning $([System.Char]34)Failed to load or modify the Default User registry hive. Error: `$(`$_.Exception.Message)$([System.Char]34)`n"
      "`t`t`t}`n"
      "`t`t`tfinally {`n"
      "`t`t`t  #--Will Be Performed Shortly--# # CRITICAL: Always unload the hive, regardless of success or failure`n"
      "`t`t`t  #--Will Be Performed Shortly--# reg unload $([System.Char]34)HKU\DefaultUser$([System.Char]34) | Out-Null`n"
      "`t`t`t}`n"
      "`t`t`tWrite-Host $([System.Char]34)Script execution complete. A reboot or user logoff/logon is required for the changes to take effect.$([System.Char]34)`n"
      "`t`t"
      #endregion
      {
        # by Tracy Le
        # Reference: start msedge.exe 'https://learn.microsoft.com/en-us/answers/questions/5577484/powershell-script-to-set-the-scale-of-all-the-conn'
        ##
        # This script sets the display DPI scaling to 100% (96 DPI) for all users.
        # It must be run with elevated privileges (as Administrator or SYSTEM).
        function Set-DefaultUserDpiScaling {
          param (
            [string]$RegistryPath,
            [int]$DpiValue = 96 # 96 DPI corresponds to 100% scaling
          )
          try {
            $desktopPath = Join-Path -Path $RegistryPath -ChildPath "Control Panel\Desktop"
            $metricsPath = Join-Path -Path $desktopPath -ChildPath "WindowMetrics"
            # Ensure the registry paths exist before trying to set properties
            if (Test-Path -Path $desktopPath) {
              # Set legacy scaling values for compatibility
              Set-ItemProperty -Path $desktopPath -Name "Win8DpiScaling" -Value 1 -Type DWord -Force -ErrorAction Stop
              Set-ItemProperty -Path $desktopPath -Name "LogPixels" -Value $DpiValue -Type DWord -Force -ErrorAction Stop
            }
            if (Test-Path -Path $metricsPath) {
              # Set modern scaling value
              Set-ItemProperty -Path $metricsPath -Name "AppliedDPI" -Value $DpiValue -Type DWord -Force -ErrorAction Stop
            }
            Write-Host "Successfully applied DPI settings to path: $RegistryPath"
          }
          catch {
            Write-Warning "Could not apply DPI settings to '$RegistryPath'. Error: $($_.Exception.Message)"
          }
        }
        #--No Need To Perform Before 1st Logon--# # --- Step 1: Apply to all currently logged-in users ---
        #--No Need To Perform Before 1st Logon--# Write-Host "Applying settings for currently loaded user profiles..."
        #--No Need To Perform Before 1st Logon--# $loadedSids = Get-ChildItem "Registry::HKEY_USERS" | Where-Object { $_.Name -like "*S-1-5-21-*" } | ForEach-Object { $_.PSChildName }
        #--No Need To Perform Before 1st Logon--# foreach ($sid in $loadedSids) {
        #--No Need To Perform Before 1st Logon--#   $userHivePath = "Registry::HKEY_USERS\$sid"
        #--No Need To Perform Before 1st Logon--#   Set-DefaultUserDpiScaling -RegistryPath $userHivePath
        #--No Need To Perform Before 1st Logon--# }
        # --- Step 2: Apply to the Default User Profile for all future users ---
        Write-Host "Applying settings to the Default User Profile..."
        try {
          #--Already performed prior to script execution--# # Load the default user hive from its file location
          #--Already performed prior to script execution--# reg load "HKU\DefaultUser" "C:\Users\Default\NTUSER.DAT" | Out-Null
          Set-DefaultUserDpiScaling -RegistryPath "Registry::HKEY_USERS\DefaultUser"
        }
        catch {
          Write-Warning "Failed to load or modify the Default User registry hive. Error: $($_.Exception.Message)"
        }
        finally {
          #--Will Be Performed Shortly--# # CRITICAL: Always unload the hive, regardless of success or failure
          #--Will Be Performed Shortly--# reg unload "HKU\DefaultUser" | Out-Null
        }
        Write-Host "Script execution complete. A reboot or user logoff/logon is required for the changes to take effect."
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\Display-Scale to 100 Percent (96 DPI)-DefaultUser.ps1')
        $XmlWriter.WriteString(${File Display-Scale to 100 Percent (96 DPI)-DefaultUser.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion

    #region | "Multitasking Reduction-DefaultUser.ps1" Here-String and XML Element |
    ${File Multitasking Reduction-DefaultUser.ps1 Here-String} = $(
      #region |  |
      "`n"
      "`t`t`t`$RegItem = try { # Uncheck the box at ms-settings:multitasking, Snap windows, $([System.Char]34)When I snap a window, suggest what I can snap next to it$([System.Char]34) |`n"
      "`t`t`t  Get-ItemProperty -Path $([System.Char]34)Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34) -Name $([System.Char]39)SnapAssist$([System.Char]39) -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  New-ItemProperty -Path $([System.Char]34)Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34) -Name $([System.Char]39)SnapAssist$([System.Char]39) -Type $([System.Char]39)DWORD$([System.Char]39) -Value $([System.Char]39)0$([System.Char]39)`n"
      "`t`t`t}`n"
      "`t`t`t`$RegItem = try { # Uncheck the box at ms-settings:multitasking, Snap windows, $([System.Char]34)Show snap layouts when I hover over a window$([System.Char]39)s maximize button$([System.Char]34) |`n"
      "`t`t`t  Get-ItemProperty -Path $([System.Char]34)Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34) -Name $([System.Char]39)EnableSnapAssistFlyout$([System.Char]39) -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  New-ItemProperty -Path $([System.Char]34)Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34) -Name $([System.Char]39)EnableSnapAssistFlyout$([System.Char]39) -Type $([System.Char]39)DWORD$([System.Char]39) -Value $([System.Char]39)0$([System.Char]39)`n"
      "`t`t`t}`n"
      "`t`t`t`$RegItem = try { # Uncheck the box at ms-settings:multitasking, Snap windows, $([System.Char]34)Show snap layouts when I drag a window to the top of my screen$([System.Char]34) |`n"
      "`t`t`t  Get-ItemProperty -Path $([System.Char]34)Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34) -Name $([System.Char]39)EnableSnapBar$([System.Char]39) -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  New-ItemProperty -Path $([System.Char]34)Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34) -Name $([System.Char]39)EnableSnapBar$([System.Char]39) -Type $([System.Char]39)DWORD$([System.Char]39) -Value $([System.Char]39)0$([System.Char]39)`n"
      "`t`t`t}`n"
      "`t`t`t`$RegItem = try { # Uncheck the box at ms-settings:multitasking, Snap windows, $([System.Char]34)Show my snapped windows when I hover over taskbar apps, in Task View, and when I press Alt+Tab$([System.Char]34) |`n"
      "`t`t`t  Get-ItemProperty -Path $([System.Char]34)Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34) -Name $([System.Char]39)EnableTaskGroups$([System.Char]39) -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  New-ItemProperty -Path $([System.Char]34)Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34) -Name $([System.Char]39)EnableTaskGroups$([System.Char]39) -Type $([System.Char]39)DWORD$([System.Char]39) -Value $([System.Char]39)0$([System.Char]39)`n"
      "`t`t`t}`n"
      "`t`t`t`$RegItem = try { # Uncheck the box at ms-settings:multitasking, Snap windows, $([System.Char]34)When I drag a window, let me snap it without dragging all the way to the screen edge$([System.Char]34) |`n"
      "`t`t`t  Get-ItemProperty -Path $([System.Char]34)Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34) -Name $([System.Char]39)DITest$([System.Char]39) -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  New-ItemProperty -Path $([System.Char]34)Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34) -Name $([System.Char]39)DITest$([System.Char]39) -Type $([System.Char]39)DWORD$([System.Char]39) -Value $([System.Char]39)0$([System.Char]39)`n"
      "`t`t`t}`n"
      "`t`t`t`$RegItem = try { # Adjust dropdown box at ms-settings:multitasking, $([System.Char]34)Show tabs from apps when snapping or pressing Alt+Tab$([System.Char]34) to $([System.Char]34)Don$([System.Char]39)t show tabs$([System.Char]34) |`n"
      "`t`t`t  Get-ItemProperty -Path $([System.Char]34)Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34) -Name $([System.Char]39)MultiTaskingAltTabFilter$([System.Char]39) -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  New-ItemProperty -Path $([System.Char]34)Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34) -Name $([System.Char]39)MultiTaskingAltTabFilter$([System.Char]39) -Type $([System.Char]39)DWORD$([System.Char]39) -Value $([System.Char]39)3$([System.Char]39)`n"
      "`t`t`t}`n"
      "`t`t`t`$RegItem = try { # Adjust dropdown box at ms-settings:multitasking, $([System.Char]34)Show tabs from apps when snapping or pressing Alt+Tab$([System.Char]34) to $([System.Char]34)Don$([System.Char]39)t show tabs$([System.Char]34) |`n"
      "`t`t`t  Get-ItemProperty -Path $([System.Char]34)Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34) -Name $([System.Char]39)MultiTaskingAltTabFilter$([System.Char]39) -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  New-ItemProperty -Path $([System.Char]34)Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34) -Name $([System.Char]39)MultiTaskingAltTabFilter$([System.Char]39) -Type $([System.Char]39)DWORD$([System.Char]39) -Value $([System.Char]39)3$([System.Char]39)`n"
      "`t`t`t}`n"
      "`t`t"
      #endregion

      { # Multitasking Reduction-DefaultUser.ps1 Plain-Text | Converted to ${File Multitasking Reduction-DefaultUser.ps1 Here-String} with 'ConvertTo-HereStringCompatible' |
        $RegItem = try { # Uncheck the box at ms-settings:multitasking, Snap windows, "When I snap a window, suggest what I can snap next to it" |
          Get-ItemProperty -Path "Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name 'SnapAssist' -ErrorAction 'Stop'
        } catch {
          New-ItemProperty -Path "Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name 'SnapAssist' -Type 'DWORD' -Value '0'
        }
        $RegItem = try { # Uncheck the box at ms-settings:multitasking, Snap windows, "Show snap layouts when I hover over a window's maximize button" |
          Get-ItemProperty -Path "Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name 'EnableSnapAssistFlyout' -ErrorAction 'Stop'
        } catch {
          New-ItemProperty -Path "Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name 'EnableSnapAssistFlyout' -Type 'DWORD' -Value '0'
        }
        $RegItem = try { # Uncheck the box at ms-settings:multitasking, Snap windows, "Show snap layouts when I drag a window to the top of my screen" |
          Get-ItemProperty -Path "Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name 'EnableSnapBar' -ErrorAction 'Stop'
        } catch {
          New-ItemProperty -Path "Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name 'EnableSnapBar' -Type 'DWORD' -Value '0'
        }
        $RegItem = try { # Uncheck the box at ms-settings:multitasking, Snap windows, "Show my snapped windows when I hover over taskbar apps, in Task View, and when I press Alt+Tab" |
          Get-ItemProperty -Path "Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name 'EnableTaskGroups' -ErrorAction 'Stop'
        } catch {
          New-ItemProperty -Path "Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name 'EnableTaskGroups' -Type 'DWORD' -Value '0'
        }
        $RegItem = try { # Uncheck the box at ms-settings:multitasking, Snap windows, "When I drag a window, let me snap it without dragging all the way to the screen edge" |
          Get-ItemProperty -Path "Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name 'DITest' -ErrorAction 'Stop'
        } catch {
          New-ItemProperty -Path "Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name 'DITest' -Type 'DWORD' -Value '0'
        }
        $RegItem = try { # Adjust dropdown box at ms-settings:multitasking, "Show tabs from apps when snapping or pressing Alt+Tab" to "Don't show tabs" |
          Get-ItemProperty -Path "Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name 'MultiTaskingAltTabFilter' -ErrorAction 'Stop'
        } catch {
          New-ItemProperty -Path "Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name 'MultiTaskingAltTabFilter' -Type 'DWORD' -Value '3'
        }
        $RegItem = try { # Adjust dropdown box at ms-settings:multitasking, "Show tabs from apps when snapping or pressing Alt+Tab" to "Don't show tabs" |
          Get-ItemProperty -Path "Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name 'MultiTaskingAltTabFilter' -ErrorAction 'Stop'
        } catch {
          New-ItemProperty -Path "Registry::HKEY_USERS\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name 'MultiTaskingAltTabFilter' -Type 'DWORD' -Value '3'
        }
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\Multitasking Reduction-DefaultUser.ps1')
        $XmlWriter.WriteString(${File Multitasking Reduction-DefaultUser.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion




    #region | "___.ps1" Here-String and XML Element |
    <#
      ${File ___.ps1 Here-String} = $(

        {

        } | Out-Null
      ) -join ''
        $XmlWriter.WriteStartElement('File')
          $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\___.ps1')
          $XmlWriter.WriteString(${File ___.ps1 Here-String})
        $XmlWriter.WriteEndElement()
    #>
    #endregion


    ${File DefaultUser.ps1 Here-String} = $(

      #region |  |
      "`n"
      "`t`t`t`$DefaultUserScriptBlocks = `$(`n"
      "`t`t`t  {& $([System.Char]39)C:\Windows\Setup\Scripts\Copilot-DISABLE.ps1$([System.Char]39)}`n"
      "`t`t`t  {& $([System.Char]39)C:\Windows\Setup\Scripts\Taskbar Modifications-Part 2.ps1$([System.Char]39)}`n"
      "`t`t`t  {& $([System.Char]39)C:\Windows\Setup\Scripts\Taskbar System Tray Icons-Always Show.ps1$([System.Char]39)}  #{Get-Content -LiteralPath $([System.Char]39)C:\Windows\Setup\Scripts\Taskbar System Tray Icons-Always Show.ps1$([System.Char]39) -Raw | Invoke-Expression -Verbose}`n"
      "`t`t`t  {& $([System.Char]39)C:\Windows\Setup\Scripts\Task View Button-HIDE.ps1$([System.Char]39)}`n"
      "`t`t`t  {& $([System.Char]39)C:\Windows\Setup\Scripts\Content Delivery Manager-Leave Preinstalled Apps DISABLED.ps1$([System.Char]39)}`n"
      "`t`t`t  {& $([System.Char]39)C:\Windows\Setup\Scripts\Sticky Keys-DISABLED DefaultUser version.ps1$([System.Char]39)}`n"
      "`t`t`t  {& $([System.Char]39)C:\Windows\Setup\Scripts\Taskbar System Tray Chevron Visibility-Always Show.ps1$([System.Char]39)}`n"
      "`t`t`t  {& $([System.Char]39)C:\Windows\Setup\Scripts\Accent Color on Start, Taskbar, Action Center-NONE.ps1$([System.Char]39)}`n"
      "`t`t`t  {& $([System.Char]39)C:\Windows\Setup\Scripts\Set the UserOnce.ps1 File to Execute at Next Logon.ps1$([System.Char]39)}`n"
      "`t`t`t  # ??? # {reg.exe add $([System.Char]34)HKU\DefaultUser\Software\Microsoft\Internet Explorer\LowRegistry\Audio\PolicyConfig\PropertyStore$([System.Char]34) /f}`n"
      "`t`t`t  {& $([System.Char]39)C:\Windows\Setup\Scripts\Page Space Control Sizer.ps1$([System.Char]39)}               #{Get-Content -LiteralPath $([System.Char]39)C:\Windows\Setup\Scripts\Page Space Control Sizer.ps1$([System.Char]39) -Raw | Invoke-Expression -Verbose}`n"
      "`t`t`t  {& $([System.Char]39)C:\Windows\Setup\Scripts\Underline Access Keys when Available.ps1$([System.Char]39)}   #{Get-Content -LiteralPath $([System.Char]39)C:\Windows\Setup\Scripts\Underline Access Keys when Available.ps1$([System.Char]39) -Raw | Invoke-Expression -Verbose}`n"
      "`t`t`t  {& $([System.Char]39)C:\Windows\Setup\Scripts\Misc File Explorer Settings-Part 1.ps1$([System.Char]39)}`n"
      "`t`t`t  {& $([System.Char]39)C:\Windows\Setup\Scripts\Display-Scale to 100 Percent (96 DPI)-DefaultUser.ps1$([System.Char]39)}`n"
      "`t`t`t  {& $([System.Char]39)C:\Windows\Setup\Scripts\SetWallpaper-DefaultUser.ps1$([System.Char]39)}`n"
      "`t`t`t  {& $([System.Char]39)C:\Windows\Setup\Scripts\Multitasking Reduction-DefaultUser.ps1$([System.Char]39)}`n"
      "`t`t`t)`n"
      "`t`t`t& { # Default User ScriptBlocks Logging |`n"
      "`t`t`t  [System.Single] `$Complete = 0`n"
      "`t`t`t  [System.Single] `$Increment = 100 / `$DefaultUserScriptBlocks.Count`n"
      "`t`t`t  foreach (`$script in `$DefaultUserScriptBlocks) {`n"
      "`t`t`t    Write-Progress -Activity $([System.Char]39)Running scriptblocks in DefaultUser.ps1. Do not close this window.$([System.Char]39) -PercentComplete `$Complete`n"
      "`t`t`t    $([System.Char]34)*** Will now execute command «{0}»$([System.Char]34) -f `$(`n"
      "`t`t`t      `$script.ToString().Trim() -replace $([System.Char]39)\s+$([System.Char]39), $([System.Char]39) $([System.Char]39) -replace $([System.Char]39)^(.{99})(.+)`$$([System.Char]39), $([System.Char]39)`$1……$([System.Char]39)`n"
      "`t`t`t    )`n"
      "`t`t`t    `$start = [System.DateTime]::Now`n"
      "`t`t`t    & `$script`n"
      "`t`t`t    $([System.Char]39)*** Finished executing command after {0:0} ms.$([System.Char]39) -f [System.DateTime]::Now.Subtract(`$start).TotalMilliseconds`n"
      "`t`t`t    `$Complete += `$Increment`n"
      "`t`t`t  }`n"
      "`t`t`t} *>&1 | Out-String -Width 1KB -Stream >> $([System.Char]34)C:\Windows\Setup\Scripts\DefaultUser.log$([System.Char]34)`n"
      "`t`t"
      #endregion

      {
        $DefaultUserScriptBlocks = $(
          {& 'C:\Windows\Setup\Scripts\Copilot-DISABLE.ps1'}
          {& 'C:\Windows\Setup\Scripts\Taskbar Modifications-Part 2.ps1'}
          {& 'C:\Windows\Setup\Scripts\Taskbar System Tray Icons-Always Show.ps1'}  #{Get-Content -LiteralPath 'C:\Windows\Setup\Scripts\Taskbar System Tray Icons-Always Show.ps1' -Raw | Invoke-Expression -Verbose}
          {& 'C:\Windows\Setup\Scripts\Task View Button-HIDE.ps1'}
          {& 'C:\Windows\Setup\Scripts\Content Delivery Manager-Leave Preinstalled Apps DISABLED.ps1'}
          {& 'C:\Windows\Setup\Scripts\Sticky Keys-DISABLED DefaultUser version.ps1'}
          {& 'C:\Windows\Setup\Scripts\Taskbar System Tray Chevron Visibility-Always Show.ps1'}
          {& 'C:\Windows\Setup\Scripts\Accent Color on Start, Taskbar, Action Center-NONE.ps1'}
          {& 'C:\Windows\Setup\Scripts\Set the UserOnce.ps1 File to Execute at Next Logon.ps1'}
          # ??? # {reg.exe add "HKU\DefaultUser\Software\Microsoft\Internet Explorer\LowRegistry\Audio\PolicyConfig\PropertyStore" /f}
          {& 'C:\Windows\Setup\Scripts\Page Space Control Sizer.ps1'}               #{Get-Content -LiteralPath 'C:\Windows\Setup\Scripts\Page Space Control Sizer.ps1' -Raw | Invoke-Expression -Verbose}
          {& 'C:\Windows\Setup\Scripts\Underline Access Keys when Available.ps1'}   #{Get-Content -LiteralPath 'C:\Windows\Setup\Scripts\Underline Access Keys when Available.ps1' -Raw | Invoke-Expression -Verbose}
          {& 'C:\Windows\Setup\Scripts\Misc File Explorer Settings-Part 1.ps1'}
          {& 'C:\Windows\Setup\Scripts\Display-Scale to 100 Percent (96 DPI)-DefaultUser.ps1'}
          {& 'C:\Windows\Setup\Scripts\SetWallpaper-DefaultUser.ps1'}
          {& 'C:\Windows\Setup\Scripts\Multitasking Reduction-DefaultUser.ps1'}
        )
        & { # Default User ScriptBlocks Logging |
          [System.Single] $Complete = 0
          [System.Single] $Increment = 100 / $DefaultUserScriptBlocks.Count
          foreach ($script in $DefaultUserScriptBlocks) {
            Write-Progress -Activity 'Running scriptblocks in DefaultUser.ps1. Do not close this window.' -PercentComplete $Complete
            "*** Will now execute command «{0}»" -f $(
              $script.ToString().Trim() -replace '\s+', ' ' -replace '^(.{99})(.+)$', '$1……'
            )
            $start = [System.DateTime]::Now
            & $script
            '*** Finished executing command after {0:0} ms.' -f [System.DateTime]::Now.Subtract($start).TotalMilliseconds
            $Complete += $Increment
          }
        } *>&1 | Out-String -Width 1KB -Stream >> "C:\Windows\Setup\Scripts\DefaultUser.log"
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\DefaultUser.ps1')
        $XmlWriter.WriteString(${File DefaultUser.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion

    #region | UserOnce.ps1 Here-String | C-Scripts | C-Scripts run whenever a user, any user, logs on for the first time |
    #region | "RunMRU Run Box Cache.ps1" Here-String and XML Element |
    ${File RunMRU Run Box Cache.ps1 Here-String} = $(
      #region |  |
      "`n"
      "`t`t`t#`$RunMRU = $([System.Char]34)HKU:\`$((Get-LocalUser `${explorer.exe Owner} -ErrorAction Stop).sid.value)\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU$([System.Char]34)`n"
      "`t`t`t#`$RunMRU = $([System.Char]34)HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\RunMRU$([System.Char]34)`n"
      "`t`t`t`$RunMRU = $([System.Char]34)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU$([System.Char]34)`n"
      "`t`t`t`$AllNumLett = `$(`n"
      "`t`t`t  0..25 | ForEach-Object -Process {`n"
      "`t`t`t    [System.Char]([System.Int32][System.Char]$([System.Char]39)z$([System.Char]39) - `$_)`n"
      "`t`t`t  }`n"
      "`t`t`t) -join $([System.Char]39)$([System.Char]39)`n"
      "`t`t`t`$path = `$RunMRU`n"
      "`t`t`ttry {`n"
      "`t`t`t  Get-Item -Path `$path -Name $([System.Char]39)MRUList$([System.Char]39) -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  New-Item -Path `$path -Name $([System.Char]39)MRUList$([System.Char]39) -Force`n"
      "`t`t`t}`n"
      "`t`t`tSet-ItemProperty -Name $([System.Char]39)MRUList$([System.Char]39) -Path `$path -Value $([System.Char]34)`$AllNumLett$([System.Char]34)`n"
      "`t`t`t`$RunMRU_HT = [System.Collections.Hashtable]@{`n"
      "`t`t`t  a = $([System.Char]39)ms-settings:windowsupdate$([System.Char]39)`n"
      "`t`t`t  b = $([System.Char]39)ms-settings:display$([System.Char]39)`n"
      "`t`t`t  c = $([System.Char]39)ms-settings:easeofaccess-mousepointer$([System.Char]39)`n"
      "`t`t`t  d = $([System.Char]39)%PMs%$([System.Char]39)`n"
      "`t`t`t  e = $([System.Char]39)ms-settings:personalization-colors$([System.Char]39)`n"
      "`t`t`t  f = $([System.Char]39)cmd.exe /c powershell.exe; Start pwsh -Verb RunAs$([System.Char]39)`n"
      "`t`t`t  g = $([System.Char]39)cmd.exe /c powershell.exe; Start-process PowerShell.exe -Verb RunAs$([System.Char]39)`n"
      "`t`t`t  k = $([System.Char]39)ms-settings:taskbar$([System.Char]39)`n"
      "`t`t`t  l = $([System.Char]39)shutdown -p$([System.Char]39)`n"
      "`t`t`t  m = $([System.Char]39)control.exe /Name Microsoft.CredentialManager$([System.Char]39)`n"
      "`t`t`t  n = $([System.Char]39)ms-settings:about$([System.Char]39)`n"
      "`t`t`t  o = $([System.Char]39)appwiz.cpl$([System.Char]39)`n"
      "`t`t`t  q = $([System.Char]39)windowsdefender://coreisolation/$([System.Char]39)`n"
      "`t`t`t  r = $([System.Char]39)windowsdefender://securityprocessor/$([System.Char]39)`n"
      "`t`t`t  s = $([System.Char]39)ms-settings:accounts$([System.Char]39)`n"
      "`t`t`t  t = $([System.Char]39)ms-settings:defaultapps$([System.Char]39)`n"
      "`t`t`t  w = $([System.Char]39)taskschd.msc$([System.Char]39)`n"
      "`t`t`t  x = $([System.Char]39)eventvwr.msc$([System.Char]39)`n"
      "`t`t`t  y = $([System.Char]39)chrome /incognito https://mysignins.microsoft.com/security-info$([System.Char]39)`n"
      "`t`t`t  z = $([System.Char]39)$([System.Char]34)%ProgramFiles%\Microsoft OneDrive\OneDrive.exe$([System.Char]34) /reset$([System.Char]39)`n"
      "`t`t`t}`n"
      "`t`t`tforeach (`$Ea in `$RunMRU_HT.GetEnumerator() | Write-Output) {`n"
      "`t`t`t  Set-ItemProperty -Name `$Ea.Name -Value `$Ea.Value -Path `$path`n"
      "`t`t`t}`n"
      "`t`t`tforeach (`$Ea in `$RunMRU_HT.GetEnumerator() | Write-Output) {`n"
      "`t`t`t  Get-ItemProperty -Name `$Ea.Name -Path `$path`n"
      "`t`t`t}`n"
      "`t`t"
      #endregion
      {
        #$RunMRU = "HKU:\$((Get-LocalUser ${explorer.exe Owner} -ErrorAction Stop).sid.value)\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU"
        #$RunMRU = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\RunMRU"
        $RunMRU = "Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU"
        $AllNumLett = $(
          0..25 | ForEach-Object -Process {
            [System.Char]([System.Int32][System.Char]'z' - $_)
          }
        ) -join ''
        $path = $RunMRU
        try {
          Get-Item -Path $path -Name 'MRUList' -ErrorAction 'Stop'
        } catch {
          New-Item -Path $path -Name 'MRUList' -Force
        }
        Set-ItemProperty -Name 'MRUList' -Path $path -Value "$AllNumLett"
        $RunMRU_HT = [System.Collections.Hashtable]@{
          a = 'ms-settings:windowsupdate'
          b = 'ms-settings:display'
          c = 'ms-settings:easeofaccess-mousepointer'
          d = '%PMs%'
          e = 'ms-settings:personalization-colors'
          f = 'cmd.exe /c powershell.exe; Start pwsh -Verb RunAs'
          g = 'cmd.exe /c powershell.exe; Start-process PowerShell.exe -Verb RunAs'
          k = 'ms-settings:taskbar'
          l = 'shutdown -p'
          m = 'control.exe /Name Microsoft.CredentialManager'
          n = 'ms-settings:about'
          o = 'appwiz.cpl'
          q = 'windowsdefender://coreisolation/'
          r = 'windowsdefender://securityprocessor/'
          s = 'ms-settings:accounts'
          t = 'ms-settings:defaultapps'
          w = 'taskschd.msc'
          x = 'eventvwr.msc'
          y = 'chrome /incognito https://mysignins.microsoft.com/security-info'
          z = '"%ProgramFiles%\Microsoft OneDrive\OneDrive.exe" /reset'
        }
        foreach ($Ea in $RunMRU_HT.GetEnumerator() | Write-Output) {
          Set-ItemProperty -Name $Ea.Name -Value $Ea.Value -Path $path
        }
        foreach ($Ea in $RunMRU_HT.GetEnumerator() | Write-Output) {
          Get-ItemProperty -Name $Ea.Name -Path $path
        }
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\RunMRU Run Box Cache.ps1')
        $XmlWriter.WriteString(${File RunMRU Run Box Cache.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion
    #region | "Chat-Hide.ps1" Here-String and XML Element |
    # Hide Chat - THIS IS BOMBING OUT. Remove from Specialized |
    # Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name 'TaskbarMn' -Value '0'
    ${File Chat-Hide.ps1 Here-String} = $(
      "`n"
      "`t`t`t`$path = $([System.Char]34)HKU:\`$((Get-LocalUser `${explorer.exe Owner} -ErrorAction $([System.Char]39)Stop$([System.Char]39)).sid.value)\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34)`n"
      "`t`t`ttry {`n"
      "`t`t`t  Get-Item -Path `$path -Name $([System.Char]39)TaskbarMn$([System.Char]39) -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  New-Item -Path `$path -Name $([System.Char]39)TaskbarMn$([System.Char]39) -Force`n"
      "`t`t`t}`n"
      "`t`t`tSet-ItemProperty -Path `$path -Name $([System.Char]39)TaskbarMn$([System.Char]39) -Value $([System.Char]39)0$([System.Char]39)`n"
      "`t`t"
      {
        $path = "HKU:\$((Get-LocalUser ${explorer.exe Owner} -ErrorAction 'Stop').sid.value)\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
        try {
          Get-Item -Path $path -Name 'TaskbarMn' -ErrorAction 'Stop'
        } catch {
          New-Item -Path $path -Name 'TaskbarMn' -Force
        }
        Set-ItemProperty -Path $path -Name 'TaskbarMn' -Value '0'
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\Chat-Hide.ps1')
        $XmlWriter.WriteString(${File Chat-Hide.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion
    #region | "UWP Copilot Application-REMOVE.ps1" Here-String and XML Element |
    ${File UWP Copilot Application-REMOVE.ps1 Here-String} = $(
      "`n"
      "`t`t`tGet-AppxPackage -Name $([System.Char]39)Microsoft.Windows.Ai.Copilot.Provider$([System.Char]39) -Verbose | Remove-AppxPackage -Verbose`n"
      "`t`t"
      {
        Get-AppxPackage -Name 'Microsoft.Windows.Ai.Copilot.Provider' -Verbose | Remove-AppxPackage -Verbose
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\UWP Copilot Application-REMOVE.ps1')
        $XmlWriter.WriteString(${File UWP Copilot Application-REMOVE.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion
    #region | "Unlock Taskbar Layout.ps1" Here-String and XML Element |
    ${File Unlock Taskbar Layout.ps1 Here-String} = $(
      "`n"
      "`t`t`t[System.Diagnostics.EventLog]::WriteEntry( $([System.Char]39)UnattendGenerator$([System.Char]39), $([System.Char]34)User $([System.Char]39)`$env:USERNAME$([System.Char]39) has requested to unlock the Start menu layout.$([System.Char]34), [System.Diagnostics.EventLogEntryType]::Information, 1 )`n"
      "`t`t"
      {
        [System.Diagnostics.EventLog]::WriteEntry( 'UnattendGenerator', "User '$env:USERNAME' has requested to unlock the Start menu layout.", [System.Diagnostics.EventLogEntryType]::Information, 1 )
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\Unlock Taskbar Layout.ps1')
        $XmlWriter.WriteString(${File Unlock Taskbar Layout.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion
    #region | "NTFS Reparse Points-Remove from UserProfile Scope at Depth 2.ps1" Here-String and XML Element |
    ${File NTFS Reparse Points-Remove from UserProfile Scope at Depth 2.ps1 Here-String} = $(
      { # NTFS Reparse Points explained: 'https://en.wikipedia.org/wiki/NTFS_reparse_point' | Just don't mess with this |
        @(
          Get-ChildItem -LiteralPath $env:USERPROFILE -Force -Recurse -Depth 2
        ) | Where-Object -FilterScript {
          $_.Attributes.HasFlag( [System.IO.FileAttributes]::ReparsePoint )
        } | Remove-Item -Force -Recurse -Verbose
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\NTFS Reparse Points-Remove from UserProfile Scope at Depth 2.ps1')
        $XmlWriter.WriteString(${File NTFS Reparse Points-Remove from UserProfile Scope at Depth 2.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion
    #region | "Shortcuts-msedge-DELETE.ps1" Here-String and XML Element |
    ${File Shortcuts-msedge-DELETE.ps1 Here-String} = $(
      "`n"
      "`t`t`t`$paths = @(`n"
      "`t`t`t  $([System.Char]34)`$env:SystemDrive\Users\`${explorer.exe Owner}\Desktop\Microsoft Edge.lnk$([System.Char]34)`n"
      "`t`t`t  $([System.Char]34)`$env:SystemDrive\Users\`${explorer.exe Owner}\OneDrive\Desktop\Microsoft Edge.lnk$([System.Char]34)`n"
      "`t`t`t)`n"
      "`t`t`tforeach (`$path in `$paths) {`n"
      "`t`t`t  `$IsPresent = Test-Path -Path `$path`n"
      "`t`t`t  if (`$IsPresent) {`n"
      "`t`t`t    Remove-Item -Path `$path -Verbose`n"
      "`t`t`t  }`n"
      "`t`t`t}`n"
      "`t`t"
      {
        $paths = @(
          "$env:SystemDrive\Users\${explorer.exe Owner}\Desktop\Microsoft Edge.lnk"
          "$env:SystemDrive\Users\${explorer.exe Owner}\OneDrive\Desktop\Microsoft Edge.lnk"
        )
        foreach ($path in $paths) {
          $IsPresent = Test-Path -Path $path
          if ($IsPresent) {
            Remove-Item -Path $path -Verbose
          }
        }
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\Shortcuts-msedge-DELETE.ps1')
        $XmlWriter.WriteString(${File Shortcuts-msedge-DELETE.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion
    #region | "Classic Context-Sensitive Menu.ps1" Here-String and XML Element |
    ${File Classic Context-Sensitive Menu.ps1 Here-String} = $(
      "`n"
      "`t`t`t`$InputHT = @{`n"
      "`t`t`t  Path        = $([System.Char]39)Registry::HKEY_CURRENT_USER\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32$([System.Char]39)`n"
      "`t`t`t  ErrorAction = $([System.Char]39)SilentlyContinue$([System.Char]39)`n"
      "`t`t`t  Verbose     = `$true`n"
      "`t`t`t  Force       = `$true`n"
      "`t`t`t}`n"
      "`t`t`tNew-Item @InputHT`n"
      "`t`t`tSet-ItemProperty @InputHT -Name $([System.Char]39)(Default)$([System.Char]39) -Value $([System.Char]39)$([System.Char]39) -Type $([System.Char]39)String$([System.Char]39)`n"
      "`t`t`t# reg.exe add $([System.Char]34)HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32$([System.Char]34) /ve /f;`n"
      "`t`t"
      {
        $InputHT = @{
          Path        = 'Registry::HKEY_CURRENT_USER\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32'
          ErrorAction = 'SilentlyContinue'
          Verbose     = $true
          Force       = $true
        }
        New-Item @InputHT
        Set-ItemProperty @InputHT -Name '(Default)' -Value '' -Type 'String'
        # reg.exe add "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /ve /f;
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\Classic Context-Sensitive Menu.ps1')
        $XmlWriter.WriteString(${File Classic Context-Sensitive Menu.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion
    #region | "Taskbar-Search Box-REMOVE.ps1" Here-String and XML Element |
    ${File Taskbar-Search Box-REMOVE.ps1 Here-String} = $(
      "`n"
      "`t`t`tSet-ItemProperty -LiteralPath $([System.Char]39)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Search$([System.Char]39) -Name $([System.Char]39)SearchboxTaskbarMode$([System.Char]39) -Type $([System.Char]39)DWord$([System.Char]39) -Value $([System.Char]39)0$([System.Char]39) -Verbose`n"
      "`t`t"
      {
        Set-ItemProperty -LiteralPath 'Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Search' -Name 'SearchboxTaskbarMode' -Type 'DWord' -Value '0' -Verbose
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\Taskbar-Search Box-REMOVE.ps1')
        $XmlWriter.WriteString(${File Taskbar-Search Box-REMOVE.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion
    #region | "Start Menu Icons-HIDE.ps1" Here-String and XML Element |
    ${File Start Menu Icons-HIDE.ps1 Here-String} = $(
      "`n"
      "`t`t`t`$path = $([System.Char]39)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu$([System.Char]39)`n"
      "`t`t`tNew-Item -Path `$path -Force`n"
      "`t`t`t`$guids = @(`n"
      "`t`t`t  $([System.Char]39){5399e694-6ce5-4d6c-8fce-1d8870fdcba0}$([System.Char]39)`n"
      "`t`t`t  $([System.Char]39){b4bfcc3a-db2c-424c-b029-7fe99a87c641}$([System.Char]39)`n"
      "`t`t`t  $([System.Char]39){a8cdff1c-4878-43be-b5fd-f8091c1c60d0}$([System.Char]39)`n"
      "`t`t`t  $([System.Char]39){374de290-123f-4565-9164-39c4925e467b}$([System.Char]39)`n"
      "`t`t`t  $([System.Char]39){e88865ea-0e1c-4e20-9aa6-edcd0212c87c}$([System.Char]39)`n"
      "`t`t`t  $([System.Char]39){f874310e-b6b7-47dc-bc84-b9e6b38f5903}$([System.Char]39)`n"
      "`t`t`t  $([System.Char]39){1cf1260c-4dd0-4ebb-811f-33c572699fde}$([System.Char]39)`n"
      "`t`t`t  $([System.Char]39){f02c1a0d-be21-4350-88b0-7367fc96ef3c}$([System.Char]39)`n"
      "`t`t`t  $([System.Char]39){3add1653-eb32-4cb0-bbd7-dfa0abb5acca}$([System.Char]39)`n"
      "`t`t`t  $([System.Char]39){20d04fe0-3aea-1069-a2d8-08002b30309d}$([System.Char]39)`n"
      "`t`t`t  $([System.Char]39){59031a47-3f72-44a7-89c5-5595fe6b30ee}$([System.Char]39)`n"
      "`t`t`t  $([System.Char]39){a0953c92-50dc-43bf-be83-3742fed03c9c}$([System.Char]39)`n"
      "`t`t`t)`n"
      "`t`t`tforeach (`$guid in `$guids) {Set-ItemProperty -Path `$path -Name `$guid -Value $([System.Char]39)1$([System.Char]39) -Type $([System.Char]39)DWord$([System.Char]39) -Verbose}`n"
      "`t`t`tSet-ItemProperty -Path `$path -Name $([System.Char]39){645ff040-5081-101b-9f08-00aa002f954e}$([System.Char]39) -Value $([System.Char]39)0$([System.Char]39) -Type $([System.Char]39)DWord$([System.Char]39) -Verbose`n"
      "`t`t`t`n"
      "`t`t`t`$path = $([System.Char]39)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel$([System.Char]39)`n"
      "`t`t`tNew-Item -Path `$path -Force`n"
      "`t`t`t`$guids = @(`n"
      "`t`t`t  $([System.Char]39){5399e694-6ce5-4d6c-8fce-1d8870fdcba0}$([System.Char]39)`n"
      "`t`t`t  $([System.Char]39){b4bfcc3a-db2c-424c-b029-7fe99a87c641}$([System.Char]39)`n"
      "`t`t`t  $([System.Char]39){a8cdff1c-4878-43be-b5fd-f8091c1c60d0}$([System.Char]39)`n"
      "`t`t`t  $([System.Char]39){374de290-123f-4565-9164-39c4925e467b}$([System.Char]39)`n"
      "`t`t`t  $([System.Char]39){e88865ea-0e1c-4e20-9aa6-edcd0212c87c}$([System.Char]39)`n"
      "`t`t`t  $([System.Char]39){f874310e-b6b7-47dc-bc84-b9e6b38f5903}$([System.Char]39)`n"
      "`t`t`t  $([System.Char]39){1cf1260c-4dd0-4ebb-811f-33c572699fde}$([System.Char]39)`n"
      "`t`t`t  $([System.Char]39){f02c1a0d-be21-4350-88b0-7367fc96ef3c}$([System.Char]39)`n"
      "`t`t`t  $([System.Char]39){3add1653-eb32-4cb0-bbd7-dfa0abb5acca}$([System.Char]39)`n"
      "`t`t`t  $([System.Char]39){20d04fe0-3aea-1069-a2d8-08002b30309d}$([System.Char]39)`n"
      "`t`t`t  $([System.Char]39){59031a47-3f72-44a7-89c5-5595fe6b30ee}$([System.Char]39)`n"
      "`t`t`t  $([System.Char]39){a0953c92-50dc-43bf-be83-3742fed03c9c}$([System.Char]39)`n"
      "`t`t`t)`n"
      "`t`t`tforeach (`$guid in `$guids) {Set-ItemProperty -Path `$path -Name `$guid -Value $([System.Char]39)1$([System.Char]39) -Type $([System.Char]39)DWord$([System.Char]39) -Verbose}`n"
      "`t`t`tSet-ItemProperty -Path `$path -Name $([System.Char]39){645ff040-5081-101b-9f08-00aa002f954e}$([System.Char]39) -Value $([System.Char]39)0$([System.Char]39) -Type $([System.Char]39)DWord$([System.Char]39) -Verbose`n"
      "`t`t"
      {
        $path = 'Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu'
        New-Item -Path $path -Force
        $guids = @(
          '{5399e694-6ce5-4d6c-8fce-1d8870fdcba0}'
          '{b4bfcc3a-db2c-424c-b029-7fe99a87c641}'
          '{a8cdff1c-4878-43be-b5fd-f8091c1c60d0}'
          '{374de290-123f-4565-9164-39c4925e467b}'
          '{e88865ea-0e1c-4e20-9aa6-edcd0212c87c}'
          '{f874310e-b6b7-47dc-bc84-b9e6b38f5903}'
          '{1cf1260c-4dd0-4ebb-811f-33c572699fde}'
          '{f02c1a0d-be21-4350-88b0-7367fc96ef3c}'
          '{3add1653-eb32-4cb0-bbd7-dfa0abb5acca}'
          '{20d04fe0-3aea-1069-a2d8-08002b30309d}'
          '{59031a47-3f72-44a7-89c5-5595fe6b30ee}'
          '{a0953c92-50dc-43bf-be83-3742fed03c9c}'
        )
        foreach ($guid in $guids) {Set-ItemProperty -Path $path -Name $guid -Value '1' -Type 'DWord' -Verbose}
        Set-ItemProperty -Path $path -Name '{645ff040-5081-101b-9f08-00aa002f954e}' -Value '0' -Type 'DWord' -Verbose

        $path = 'Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel'
        New-Item -Path $path -Force
        $guids = @(
          '{5399e694-6ce5-4d6c-8fce-1d8870fdcba0}'
          '{b4bfcc3a-db2c-424c-b029-7fe99a87c641}'
          '{a8cdff1c-4878-43be-b5fd-f8091c1c60d0}'
          '{374de290-123f-4565-9164-39c4925e467b}'
          '{e88865ea-0e1c-4e20-9aa6-edcd0212c87c}'
          '{f874310e-b6b7-47dc-bc84-b9e6b38f5903}'
          '{1cf1260c-4dd0-4ebb-811f-33c572699fde}'
          '{f02c1a0d-be21-4350-88b0-7367fc96ef3c}'
          '{3add1653-eb32-4cb0-bbd7-dfa0abb5acca}'
          '{20d04fe0-3aea-1069-a2d8-08002b30309d}'
          '{59031a47-3f72-44a7-89c5-5595fe6b30ee}'
          '{a0953c92-50dc-43bf-be83-3742fed03c9c}'
        )
        foreach ($guid in $guids) {Set-ItemProperty -Path $path -Name $guid -Value '1' -Type 'DWord' -Verbose}
        Set-ItemProperty -Path $path -Name '{645ff040-5081-101b-9f08-00aa002f954e}' -Value '0' -Type 'DWord' -Verbose
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\Start Menu Icons-HIDE.ps1')
        $XmlWriter.WriteString(${File Start Menu Icons-HIDE.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion
    #region | "VisualFX-Optimize Speed.ps1" Here-String and XML Element |
    ${File VisualFX-Optimize Speed.ps1 Here-String} = $(
      #region |  |
      "`n"
      "`t`t`t#  Set-ItemProperty -LiteralPath $([System.Char]39)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects$([System.Char]39) -Name $([System.Char]39)VisualFXSetting$([System.Char]39) -Type $([System.Char]39)DWord$([System.Char]39) -Value $([System.Char]39)2$([System.Char]39) -Force -Verbose`n"
      "`t`t`t`$path = $([System.Char]39)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer$([System.Char]39)`n"
      "`t`t`t`$name = $([System.Char]39)VisualEffects$([System.Char]39)`n"
      "`t`t`t`$RegItem = try {`n"
      "`t`t`t  Get-Item -Path `$path -Name `$name -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  New-Item -Path `$path -Name `$name -Force`n"
      "`t`t`t}`n"
      "`t`t`t`n"
      "`t`t`t`$path = $([System.Char]34)`$path\`$name$([System.Char]34)`n"
      "`t`t`t`$name = $([System.Char]39)VisualFXSetting$([System.Char]39)`n"
      "`t`t`tSet-ItemProperty -Path $([System.Char]34)`$path\`$name$([System.Char]34) -Name `$name -Value $([System.Char]39)2$([System.Char]39) -Type $([System.Char]39)DWord$([System.Char]39) -Verbose -Force`n"
      "`t`t"
      #endregion
      {
        #  Set-ItemProperty -LiteralPath 'Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects' -Name 'VisualFXSetting' -Type 'DWord' -Value '2' -Force -Verbose
        $path = 'Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer'
        $name = 'VisualEffects'
        $RegItem = try {
          Get-Item -Path $path -Name $name -ErrorAction 'Stop'
        } catch {
          New-Item -Path $path -Name $name -Force
        }
        $path = "$path\$name"
        $name = 'VisualFXSetting'
        Set-ItemProperty -Path "$path\$name" -Name $name -Value '2' -Type 'DWord' -Verbose -Force
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\VisualFX-Optimize Speed.ps1')
        $XmlWriter.WriteString(${File VisualFX-Optimize Speed.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion
    #region | "Start Menu Visible Places-NONE.ps1" Here-String and XML Element |
    ${File Start Menu Visible Places-NONE.ps1 Here-String} = $(
      #region |  |
      "`n"
      "`t`t`t#  Set-ItemProperty -Path $([System.Char]39)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Start$([System.Char]39) -Name $([System.Char]39)VisiblePlaces$([System.Char]39) -Value `$([System.Convert]::FromBase64String($([System.Char]39)$([System.Char]39))) -Type $([System.Char]39)Binary$([System.Char]39) -Verbose`n"
      "`t`t`t`$path = $([System.Char]39)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Start$([System.Char]39)`n"
      "`t`t`t`$name = $([System.Char]39)VisiblePlaces$([System.Char]39)`n"
      "`t`t`t`$RegItem = try {`n"
      "`t`t`t  Get-Item -Path `$path -Name `$name -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  New-Item -Path `$path -Name `$name -Force`n"
      "`t`t`t}`n"
      "`t`t`t`$InputHT = @{`n"
      "`t`t`t  Path    = $([System.Char]34)`$path\`$name$([System.Char]34)`n"
      "`t`t`t  Name    = $([System.Char]39)VisiblePlaces$([System.Char]39)`n"
      "`t`t`t  Value   = `$([System.Convert]::FromBase64String($([System.Char]39)$([System.Char]39)))`n"
      "`t`t`t  Type    = $([System.Char]39)Binary$([System.Char]39)`n"
      "`t`t`t  Force   = `$true`n"
      "`t`t`t  Verbose = `$true`n"
      "`t`t`t}`n"
      "`t`t`tSet-ItemProperty @InputHT`n"
      "`t`t"
      #endregion
      {
        #  Set-ItemProperty -Path 'Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Start' -Name 'VisiblePlaces' -Value $([System.Convert]::FromBase64String('')) -Type 'Binary' -Verbose
        $path = 'Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Start'
        $name = 'VisiblePlaces'
        $RegItem = try {
          Get-Item -Path $path -Name $name -ErrorAction 'Stop'
        } catch {
          New-Item -Path $path -Name $name -Force
        }
        $InputHT = @{
          Path    = "$path\$name"
          Name    = 'VisiblePlaces'
          Value   = $([System.Convert]::FromBase64String(''))
          Type    = 'Binary'
          Force   = $true
          Verbose = $true
        }
        Set-ItemProperty @InputHT
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\Start Menu Visible Places-NONE.ps1')
        $XmlWriter.WriteString(${File Start Menu Visible Places-NONE.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion
    #region | "SetWallpaper-UserOnce.ps1" Here-String |
    ${File SetWallpaper-UserOnce.ps1 Here-String} = $(

      #region |  |
      "`n"
      "`t`t`tAdd-Type -TypeDefinition $([System.Char]39)`n"
      "`t`t`t  using System.Drawing;`n"
      "`t`t`t  using System.Runtime.InteropServices;`n"
      "`t`t`t  public static class WallpaperSetter {`n"
      "`t`t`t    [DllImport($([System.Char]34)user32.dll$([System.Char]34))]`n"
      "`t`t`t    private static extern bool SetSysColors(`n"
      "`t`t`t      int cElements,`n"
      "`t`t`t      int[] lpaElements,`n"
      "`t`t`t      int[] lpaRgbValues`n"
      "`t`t`t    );                                            `n"
      "`t`t`t    [DllImport($([System.Char]34)user32.dll$([System.Char]34))]`n"
      "`t`t`t    private static extern bool SystemParametersInfo(`n"
      "`t`t`t      uint uiAction,`n"
      "`t`t`t      uint uiParam,`n"
      "`t`t`t      string pvParam,`n"
      "`t`t`t      uint fWinIni`n"
      "`t`t`t    );`n"
      "`t`t`t    public static void SetDesktopBackground(Color color) {`n"
      "`t`t`t      SystemParametersInfo(20, 0, $([System.Char]34)$([System.Char]34), 0);`n"
      "`t`t`t      SetSysColors(1, new int[] { 1 }, new int[] { ColorTranslator.ToWin32(color) });`n"
      "`t`t`t    }`n"
      "`t`t`t    public static void SetDesktopImage(string file) {`n"
      "`t`t`t      SystemParametersInfo(20, 0, file, 0);`n"
      "`t`t`t    }`n"
      "`t`t`t  }`n"
      "`t`t`t$([System.Char]39) -ReferencedAssemblies $([System.Char]39)System.Drawing$([System.Char]39);`n"
      "`t`t`tfunction Set-UserOnceWallpaperColor {`n"
      "`t`t`t  param(`n"
      "`t`t`t    [string]`n"
      "`t`t`t    `$HtmlColor`n"
      "`t`t`t  );`n"
      "`t`t`t`n"
      "`t`t`t  `$color = [System.Drawing.ColorTranslator]::FromHtml( `$HtmlColor );`n"
      "`t`t`t  [WallpaperSetter]::SetDesktopBackground( `$color );`n"
      "`t`t`t`n"
      "`t`t`t  # Set-ItemProperty -Path $([System.Char]39)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Wallpapers$([System.Char]39) -Name $([System.Char]39)BackgroundType$([System.Char]39) -Type $([System.Char]39)DWord$([System.Char]39) -Value 1 -Force;`n"
      "`t`t`t  `$path = $([System.Char]34)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer$([System.Char]34)`n"
      "`t`t`t  `$name = $([System.Char]39)Wallpapers$([System.Char]39)`n"
      "`t`t`t  `$RegItem = try {`n"
      "`t`t`t    Get-Item -Path `$path -Name `$name -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t  } catch {`n"
      "`t`t`t    New-Item -Path `$path -Name `$name -Force -Verbose`n"
      "`t`t`t  }`n"
      "`t`t`t  `$path = $([System.Char]34)`$path\`$name$([System.Char]34)`n"
      "`t`t`t  `$name = $([System.Char]39)BackgroundType$([System.Char]39)`n"
      "`t`t`t  `$RegItemProp = try {`n"
      "`t`t`t    Get-ItemProperty -Path `$path -Name `$name -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t  } catch {`n"
      "`t`t`t    `$InputHT = @{`n"
      "`t`t`t      Path    = `$path`n"
      "`t`t`t      Name    = `$name`n"
      "`t`t`t      Type    = $([System.Char]39)Dword$([System.Char]39)`n"
      "`t`t`t      Value   = $([System.Char]39)1$([System.Char]39)`n"
      "`t`t`t      Force   = `$true`n"
      "`t`t`t      Verbose = `$true`n"
      "`t`t`t    }`n"
      "`t`t`t    New-ItemProperty @InputHT`n"
      "`t`t`t  }`n"
      "`t`t`t  `n"
      "`t`t`t  Set-ItemProperty -Path $([System.Char]39)Registry::HKEY_CURRENT_USER\Control Panel\Desktop$([System.Char]39) -Name $([System.Char]39)WallPaper$([System.Char]39) -Type $([System.Char]39)String$([System.Char]39) -Value $([System.Char]39)$([System.Char]39) -Force;`n"
      "`t`t`t  Set-ItemProperty -Path $([System.Char]39)Registry::HKEY_CURRENT_USER\Control Panel\Colors$([System.Char]39) -Name $([System.Char]39)Background$([System.Char]39) -Type $([System.Char]39)String$([System.Char]39) -Value $([System.Char]34)`$(`$color.R) `$(`$color.G) `$(`$color.B)$([System.Char]34) -Force;`n"
      "`t`t`t}`n"
      "`t`t`tfunction Set-UserOnceWallpaperImage {`n"
      "`t`t`t  param(`n"
      "`t`t`t    [string]`n"
      "`t`t`t    `$LiteralPath`n"
      "`t`t`t  );`n"
      "`t`t`t`n"
      "`t`t`t  if( `$LiteralPath | Test-Path ) {`n"
      "`t`t`t    [WallpaperSetter]::SetDesktopImage( `$LiteralPath );`n"
      "`t`t`t`n"
      "`t`t`t    #Set-ItemProperty -Path $([System.Char]39)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Wallpapers$([System.Char]39) -Name $([System.Char]39)BackgroundType$([System.Char]39) -Type $([System.Char]39)DWord$([System.Char]39) -Value 0 -Force;`n"
      "`t`t`t    `$path = $([System.Char]34)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer$([System.Char]34)`n"
      "`t`t`t    `$name = $([System.Char]39)Wallpapers$([System.Char]39)`n"
      "`t`t`t    `$RegItem = try {`n"
      "`t`t`t      Get-Item -Path `$path -Name `$name -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t    } catch {`n"
      "`t`t`t      New-Item -Path `$path -Name `$name -Force -Verbose`n"
      "`t`t`t    }`n"
      "`t`t`t    `$path = $([System.Char]34)`$path\`$name$([System.Char]34)`n"
      "`t`t`t    `$name = $([System.Char]39)BackgroundType$([System.Char]39)`n"
      "`t`t`t    `$RegItemProp = try {`n"
      "`t`t`t      Get-ItemProperty -Path `$path -Name `$name -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t    } catch {`n"
      "`t`t`t      `$InputHT = @{`n"
      "`t`t`t        Path    = `$path`n"
      "`t`t`t        Name    = `$name`n"
      "`t`t`t        Type    = $([System.Char]39)Dword$([System.Char]39)`n"
      "`t`t`t        Value   = $([System.Char]39)0$([System.Char]39)`n"
      "`t`t`t        Force   = `$true`n"
      "`t`t`t        Verbose = `$true`n"
      "`t`t`t      }`n"
      "`t`t`t      New-ItemProperty @InputHT`n"
      "`t`t`t    }`n"
      "`t`t`t  `n"
      "`t`t`t    Set-ItemProperty -Path $([System.Char]39)Registry::HKEY_CURRENT_USER\Control Panel\Desktop$([System.Char]39) -Name $([System.Char]39)WallPaper$([System.Char]39) -Type $([System.Char]39)String$([System.Char]39) -Value `$LiteralPath -Force;`n"
      "`t`t`t  } else {`n"
      "`t`t`t    $([System.Char]34)Cannot use $([System.Char]39)`$LiteralPath$([System.Char]39) as a desktop wallpaper because that file does not exist.$([System.Char]34);`n"
      "`t`t`t  }`n"
      "`t`t`t}`n"
      "`t`t`tSet-UserOnceWallpaperColor -HtmlColor $([System.Char]39)#0A0F0F$([System.Char]39);`n"
      "`t`t"
      #endregion

      { # SetWallpaper-UserOnce.ps1 Plain-Text | Converted to ${File SetWallpaper-UserOnce.ps1 Here-String} with 'ConvertTo-HereStringCompatible' | Mysteries of PInvoke |
        Add-Type -TypeDefinition '
          using System.Drawing;
          using System.Runtime.InteropServices;
          public static class WallpaperSetter {
            [DllImport("user32.dll")]
            private static extern bool SetSysColors(
              int cElements,
              int[] lpaElements,
              int[] lpaRgbValues
            );                                            
            [DllImport("user32.dll")]
            private static extern bool SystemParametersInfo(
              uint uiAction,
              uint uiParam,
              string pvParam,
              uint fWinIni
            );
            public static void SetDesktopBackground(Color color) {
              SystemParametersInfo(20, 0, "", 0);
              SetSysColors(1, new int[] { 1 }, new int[] { ColorTranslator.ToWin32(color) });
            }
            public static void SetDesktopImage(string file) {
              SystemParametersInfo(20, 0, file, 0);
            }
          }
        ' -ReferencedAssemblies 'System.Drawing';
        function Set-UserOnceWallpaperColor {
          param(
            [string]
            $HtmlColor
          );

          $color = [System.Drawing.ColorTranslator]::FromHtml( $HtmlColor );
          [WallpaperSetter]::SetDesktopBackground( $color );

          # Set-ItemProperty -Path 'Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Wallpapers' -Name 'BackgroundType' -Type 'DWord' -Value 1 -Force;
          $path = "Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer"
          $name = 'Wallpapers'
          $RegItem = try {
            Get-Item -Path $path -Name $name -ErrorAction 'Stop'
          } catch {
            New-Item -Path $path -Name $name -Force -Verbose
          }
          $path = "$path\$name"
          $name = 'BackgroundType'
          $RegItemProp = try {
            Get-ItemProperty -Path $path -Name $name -ErrorAction 'Stop'
          } catch {
            $InputHT = @{
              Path    = $path
              Name    = $name
              Type    = 'Dword'
              Value   = '1'
              Force   = $true
              Verbose = $true
            }
            New-ItemProperty @InputHT
          }
          
          Set-ItemProperty -Path 'Registry::HKEY_CURRENT_USER\Control Panel\Desktop' -Name 'WallPaper' -Type 'String' -Value '' -Force;
          Set-ItemProperty -Path 'Registry::HKEY_CURRENT_USER\Control Panel\Colors' -Name 'Background' -Type 'String' -Value "$($color.R) $($color.G) $($color.B)" -Force;
        }
        function Set-UserOnceWallpaperImage {
          param(
            [string]
            $LiteralPath
          );

          if( $LiteralPath | Test-Path ) {
            [WallpaperSetter]::SetDesktopImage( $LiteralPath );

            #Set-ItemProperty -Path 'Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Wallpapers' -Name 'BackgroundType' -Type 'DWord' -Value 0 -Force;
            $path = "Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer"
            $name = 'Wallpapers'
            $RegItem = try {
              Get-Item -Path $path -Name $name -ErrorAction 'Stop'
            } catch {
              New-Item -Path $path -Name $name -Force -Verbose
            }
            $path = "$path\$name"
            $name = 'BackgroundType'
            $RegItemProp = try {
              Get-ItemProperty -Path $path -Name $name -ErrorAction 'Stop'
            } catch {
              $InputHT = @{
                Path    = $path
                Name    = $name
                Type    = 'Dword'
                Value   = '0'
                Force   = $true
                Verbose = $true
              }
              New-ItemProperty @InputHT
            }
          
            Set-ItemProperty -Path 'Registry::HKEY_CURRENT_USER\Control Panel\Desktop' -Name 'WallPaper' -Type 'String' -Value $LiteralPath -Force;
          } else {
            "Cannot use '$LiteralPath' as a desktop wallpaper because that file does not exist.";
          }
        }
        Set-UserOnceWallpaperColor -HtmlColor '#0A0F0F';
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\SetWallpaper-UserOnce.ps1')
        $XmlWriter.WriteString(${File SetWallpaper-UserOnce.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion
    #region | "HideTaskBar-UserOnce.ps1" Here-String |
    ${File HideTaskBar-UserOnce.ps1 Here-String} = $(
      #region |  |
      "`n"
      "`t`t`t`$path = $([System.Char]34)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer$([System.Char]34)`n"
      "`t`t`t`$name = $([System.Char]39)StuckRects3$([System.Char]39)`n"
      "`t`t`t`$RegItem = try {`n"
      "`t`t`t  Get-Item -Path `$path -Name `$name -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  New-Item -Path `$path -Name `$name -Force -Verbose`n"
      "`t`t`t}`n"
      "`t`t`t`$path = $([System.Char]34)`$path\`$name$([System.Char]34)`n"
      "`t`t`t`$name = $([System.Char]39)Settings$([System.Char]39)`n"
      "`t`t`t`$Value = (Get-ItemProperty -Path `$path).`$name`n"
      "`t`t`t`$Value[8] = 0x7b`n"
      "`t`t`tSet-ItemProperty -Path `$path -Name `$name -Value `$Value`n"
      "`t`t`tGet-Process -Name explorer | Stop-Process -Force | Start-Process -FilePath $([System.Char]34)`$env:windir\explorer.exe$([System.Char]34)`n"
      "`t`t`t`n"
      "`t`t`t# `$Path = $([System.Char]39)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3$([System.Char]39)`n"
      "`t`t`t# `$Value = (Get-ItemProperty -Path `$Path).Settings`n"
      "`t`t`t# `$Value[8] = 0x7b`n"
      "`t`t`t# Set-ItemProperty -Path `$Path -Name $([System.Char]39)Settings$([System.Char]39) -Value `$Value`n"
      "`t`t`t# Get-Process -Name explorer | Stop-Process -Force | Start-Process -FilePath $([System.Char]34)`$env:windir\explorer.exe$([System.Char]34)`n"
      "`t`t"
      #endregion
      { # HideTaskBar-UserOnce.ps1 Plain-Text | Converted to ${File HideTaskBar-UserOnce.ps1 Here-String} with 'ConvertTo-HereStringCompatible' |
        $path = "Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer"
        $name = 'StuckRects3'
        $RegItem = try {
          Get-Item -Path $path -Name $name -ErrorAction 'Stop'
        } catch {
          New-Item -Path $path -Name $name -Force -Verbose
        }
        $path = "$path\$name"
        $name = 'Settings'
        $Value = (Get-ItemProperty -Path $path).$name
        $Value[8] = 0x7b
        Set-ItemProperty -Path $path -Name $name -Value $Value
        Get-Process -Name explorer | Stop-Process -Force | Start-Process -FilePath "$env:windir\explorer.exe"

        # $Path = 'Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3'
        # $Value = (Get-ItemProperty -Path $Path).Settings
        # $Value[8] = 0x7b
        # Set-ItemProperty -Path $Path -Name 'Settings' -Value $Value
        # Get-Process -Name explorer | Stop-Process -Force | Start-Process -FilePath "$env:windir\explorer.exe"
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\HideTaskBar-UserOnce.ps1')
        $XmlWriter.WriteString(${File HideTaskBar-UserOnce.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion

    ${File UserOnce.ps1 Here-String} = $(
      #region |  |
      "`n"
      "`t`t`t`$UserOnceScriptBlocks = `$(`n"
      "`t`t`t  {& $([System.Char]39)C:\Windows\Setup\Scripts\RunMRU Run Box Cache.ps1$([System.Char]39)}`n"
      "`t`t`t  {& $([System.Char]39)C:\Windows\Setup\Scripts\Chat-Hide.ps1$([System.Char]39)}`n"
      "`t`t`t  {& $([System.Char]39)C:\Windows\Setup\Scripts\UWP Copilot Application-REMOVE.ps1$([System.Char]39)}`n"
      "`t`t`t  {& $([System.Char]39)C:\Windows\Setup\Scripts\Unlock Taskbar Layout.ps1$([System.Char]39)}`n"
      "`t`t`t  #{& $([System.Char]39)C:\Windows\Setup\Scripts\NTFS Reparse Points-Remove from UserProfile Scope at Depth 2.ps1$([System.Char]39)}`n"
      "`t`t`t  {& $([System.Char]39)C:\Windows\Setup\Scripts\Shortcuts-msedge-DELETE.ps1$([System.Char]39)}`n"
      "`t`t`t  {& $([System.Char]39)C:\Windows\Setup\Scripts\Classic Context-Sensitive Menu.ps1$([System.Char]39)}`n"
      "`t`t`t  {& $([System.Char]39)C:\Windows\Setup\Scripts\Taskbar-Search Box-REMOVE.ps1$([System.Char]39)}`n"
      "`t`t`t  {& $([System.Char]39)C:\Windows\Setup\Scripts\VisualFX-Optimize Speed.ps1$([System.Char]39)}`n"
      "`t`t`t  {& $([System.Char]39)C:\Windows\Setup\Scripts\Start Menu Icons-HIDE.ps1$([System.Char]39)}`n"
      "`t`t`t  {& $([System.Char]39)C:\Windows\Setup\Scripts\Start Menu Visible Places-NONE.ps1$([System.Char]39)}`n"
      "`t`t`t  {& $([System.Char]39)C:\Windows\Setup\Scripts\SetColorTheme.ps1$([System.Char]39)}          # {Get-Content -LiteralPath $([System.Char]39)C:\Windows\Setup\Scripts\SetColorTheme.ps1$([System.Char]39) -Raw | Invoke-Expression -Verbose}`n"
      "`t`t`t  {& $([System.Char]39)C:\Windows\Setup\Scripts\SetWallpaper-UserOnce.ps1$([System.Char]39)}  # {Get-Content -LiteralPath $([System.Char]39)C:\Windows\Setup\Scripts\SetWallpaper-UserOnce.ps1$([System.Char]39) -Raw | Invoke-Expression -Verbose}`n"
      "`t`t`t  {& $([System.Char]39)C:\Windows\Setup\Scripts\HideTaskBar-UserOnce.ps1$([System.Char]39)}`n"
      "`t`t`t)`n"
      "`t`t`t& {`n"
      "`t`t`t  [System.Single] `$Complete = 0`n"
      "`t`t`t  [System.Single] `$Increment = 100 / `$UserOnceScriptBlocks.Count`n"
      "`t`t`t  foreach (`$script in `$UserOnceScriptBlocks) {`n"
      "`t`t`t    Write-Progress -Activity $([System.Char]39)Running scriptblocks in UserOnce.ps1. Do not close this window.$([System.Char]39) -PercentComplete `$complete`n"
      "`t`t`t    $([System.Char]34)*** Will now execute command «{0}»$([System.Char]34) -f `$(`n"
      "`t`t`t      `$script.ToString().Trim() -replace $([System.Char]39)\s+$([System.Char]39), $([System.Char]39) $([System.Char]39) -replace $([System.Char]39)^(.{99})(.+)`$$([System.Char]39), $([System.Char]39)`$1……$([System.Char]39)`n"
      "`t`t`t    )`n"
      "`t`t`t    `$start = [System.DateTime]::Now`n"
      "`t`t`t    & `$script`n"
      "`t`t`t    $([System.Char]39)*** Finished executing command after {0:0} ms.$([System.Char]39) -f [System.DateTime]::Now.Subtract(`$start).TotalMilliseconds`n"
      "`t`t`t    `$Complete += `$Increment`n"
      "`t`t`t  }`n"
      "`t`t`t} *>&1 | Out-String -Width 1KB -Stream >> $([System.Char]34)`$env:UserProfile\UserOnce.log$([System.Char]34)`n"
      "`t`t"
      #endregion
      {
        $UserOnceScriptBlocks = $(
          {& 'C:\Windows\Setup\Scripts\RunMRU Run Box Cache.ps1'}
          {& 'C:\Windows\Setup\Scripts\Chat-Hide.ps1'}
          {& 'C:\Windows\Setup\Scripts\UWP Copilot Application-REMOVE.ps1'}
          {& 'C:\Windows\Setup\Scripts\Unlock Taskbar Layout.ps1'}
          #{& 'C:\Windows\Setup\Scripts\NTFS Reparse Points-Remove from UserProfile Scope at Depth 2.ps1'}
          {& 'C:\Windows\Setup\Scripts\Shortcuts-msedge-DELETE.ps1'}
          {& 'C:\Windows\Setup\Scripts\Classic Context-Sensitive Menu.ps1'}
          {& 'C:\Windows\Setup\Scripts\Taskbar-Search Box-REMOVE.ps1'}
          {& 'C:\Windows\Setup\Scripts\VisualFX-Optimize Speed.ps1'}
          {& 'C:\Windows\Setup\Scripts\Start Menu Icons-HIDE.ps1'}
          {& 'C:\Windows\Setup\Scripts\Start Menu Visible Places-NONE.ps1'}
          {& 'C:\Windows\Setup\Scripts\SetColorTheme.ps1'}          # {Get-Content -LiteralPath 'C:\Windows\Setup\Scripts\SetColorTheme.ps1' -Raw | Invoke-Expression -Verbose}
          {& 'C:\Windows\Setup\Scripts\SetWallpaper-UserOnce.ps1'}  # {Get-Content -LiteralPath 'C:\Windows\Setup\Scripts\SetWallpaper-UserOnce.ps1' -Raw | Invoke-Expression -Verbose}
          {& 'C:\Windows\Setup\Scripts\HideTaskBar-UserOnce.ps1'}
        )
        & {
          [System.Single] $Complete = 0
          [System.Single] $Increment = 100 / $UserOnceScriptBlocks.Count
          foreach ($script in $UserOnceScriptBlocks) {
            Write-Progress -Activity 'Running scriptblocks in UserOnce.ps1. Do not close this window.' -PercentComplete $complete
            "*** Will now execute command «{0}»" -f $(
              $script.ToString().Trim() -replace '\s+', ' ' -replace '^(.{99})(.+)$', '$1……'
            )
            $start = [System.DateTime]::Now
            & $script
            '*** Finished executing command after {0:0} ms.' -f [System.DateTime]::Now.Subtract($start).TotalMilliseconds
            $Complete += $Increment
          }
        } *>&1 | Out-String -Width 1KB -Stream >> "$env:UserProfile\UserOnce.log"
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\UserOnce.ps1')
        $XmlWriter.WriteString(${File UserOnce.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion

    #region | FirstLogon.ps1 Here-String | B-Scripts |
    #region | "NTFS Reparse Points-Partial Removal.ps1" Here-String and XML Element |
    ${File NTFS Reparse Points-Partial Removal.ps1 Here-String} = $(
      #region |  |
      "`n"
      "`t`t`t@(`n"
      "`t`t`t  Get-ChildItem -LiteralPath $([System.Char]34)`$env:SystemDrive\$([System.Char]34) -Force`n"
      "`t`t`t  Get-ChildItem -LiteralPath $([System.Char]34)`$env:SystemDrive\Users$([System.Char]34) -Force`n"
      "`t`t`t  Get-ChildItem -LiteralPath $([System.Char]34)`$env:SystemDrive\Users\Default$([System.Char]34) -Force -Recurse -Depth 2`n"
      "`t`t`t  Get-ChildItem -LiteralPath $([System.Char]34)`$env:SystemDrive\Users\Public$([System.Char]34) -Force -Recurse -Depth 2`n"
      "`t`t`t  Get-ChildItem -LiteralPath $([System.Char]34)`$env:ProgramData$([System.Char]34) -Force`n"
      "`t`t`t) | Where-Object -FilterScript {`n"
      "`t`t`t  `$_.Attributes.HasFlag([System.IO.FileAttributes]::ReparsePoint)`n"
      "`t`t`t} | Remove-Item -Force -Recurse -Verbose`n"
      "`t`t"
      #endregion
      { # NTFS Reparse Points explained: 'https://en.wikipedia.org/wiki/NTFS_reparse_point' |
        @(
          Get-ChildItem -LiteralPath "$env:SystemDrive\" -Force
          Get-ChildItem -LiteralPath "$env:SystemDrive\Users" -Force
          Get-ChildItem -LiteralPath "$env:SystemDrive\Users\Default" -Force -Recurse -Depth 2
          Get-ChildItem -LiteralPath "$env:SystemDrive\Users\Public" -Force -Recurse -Depth 2
          Get-ChildItem -LiteralPath "$env:ProgramData" -Force
        ) | Where-Object -FilterScript {
          $_.Attributes.HasFlag([System.IO.FileAttributes]::ReparsePoint)
        } | Remove-Item -Force -Recurse -Verbose
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\NTFS Reparse Points-Partial Removal.ps1')
        $XmlWriter.WriteString(${File NTFS Reparse Points-Partial Removal.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion


    #region | SetColorTheme.ps1 Here-String |
    ${File SetColorTheme.ps1 Here-String} = $(
      <#
        "`n"
        "`t`t`t`$lightThemeSystem = 0;`n"
        "`t`t`t`$lightThemeApps = 0;`n"
        "`t`t`t`$accentColorOnStart = 0;`n"
        "`t`t`t`$enableTransparency = 0;`n"
        "`t`t`t`$htmlAccentColor = $([System.Char]39)#0078D4$([System.Char]39);`n"
        "`t`t`t& {`n"
        "`t`t`t  `$params = @{`n"
        "`t`t`t    LiteralPath = $([System.Char]39)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize$([System.Char]39);`n"
        "`t`t`t    Force = `$true;`n"
        "`t`t`t    Type = $([System.Char]39)DWord$([System.Char]39);`n"
        "`t`t`t  };`n"
        "`t`t`t  Set-ItemProperty @params -Name $([System.Char]39)SystemUsesLightTheme$([System.Char]39) -Value `$lightThemeSystem;`n"
        "`t`t`t  Set-ItemProperty @params -Name $([System.Char]39)AppsUseLightTheme$([System.Char]39) -Value `$lightThemeApps;`n"
        "`t`t`t  Set-ItemProperty @params -Name $([System.Char]39)ColorPrevalence$([System.Char]39) -Value `$accentColorOnStart;`n"
        "`t`t`t  Set-ItemProperty @params -Name $([System.Char]39)EnableTransparency$([System.Char]39) -Value `$enableTransparency;`n"
        "`t`t`t};`n"
        "`t`t`t& {`n"
        "`t`t`t  Add-Type -AssemblyName $([System.Char]39)System.Drawing$([System.Char]39);`n"
        "`t`t`t  `$accentColor = [System.Drawing.ColorTranslator]::FromHtml( `$htmlAccentColor );`n"
        "`t`t`t  function ConvertTo-DWord {`n"
        "`t`t`t    param(`n"
        "`t`t`t      [System.Drawing.Color]`n"
        "`t`t`t      `$Color`n"
        "`t`t`t    );`n"
        "`t`t`t            `n"
        "`t`t`t    [byte[]] `$bytes = @(`n"
        "`t`t`t      `$Color.R;`n"
        "`t`t`t      `$Color.G;`n"
        "`t`t`t      `$Color.B;`n"
        "`t`t`t      `$Color.A;`n"
        "`t`t`t    );`n"
        "`t`t`t    return [System.BitConverter]::ToUInt32( `$bytes, 0); `n"
        "`t`t`t  }`n"
        "`t`t`t  `$startColor = [System.Drawing.Color]::FromArgb( 0xD2, `$accentColor );`n"
        "`t`t`t  Set-ItemProperty -LiteralPath $([System.Char]39)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent$([System.Char]39) -Name $([System.Char]39)StartColorMenu$([System.Char]39) -Value( ConvertTo-DWord -Color `$accentColor ) -Type $([System.Char]39)DWord$([System.Char]39) -Force;`n"
        "`t`t`t  Set-ItemProperty -LiteralPath $([System.Char]39)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent$([System.Char]39) -Name $([System.Char]39)AccentColorMenu$([System.Char]39) -Value( ConvertTo-DWord -Color `$accentColor ) -Type $([System.Char]39)DWord$([System.Char]39) -Force;`n"
        "`t`t`t  Set-ItemProperty -LiteralPath $([System.Char]39)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\DWM$([System.Char]39) -Name $([System.Char]39)AccentColor$([System.Char]39) -Value( ConvertTo-DWord -Color `$accentColor ) -Type $([System.Char]39)DWord$([System.Char]39) -Force;`n"
        "`t`t`t  `$params = @{`n"
        "`t`t`t    LiteralPath = $([System.Char]39)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent$([System.Char]39);`n"
        "`t`t`t    Name = $([System.Char]39)AccentPalette$([System.Char]39);`n"
        "`t`t`t  };`n"
        "`t`t`t  `$palette = Get-ItemPropertyValue @params;`n"
        "`t`t`t  `$index = 20;`n"
        "`t`t`t  `$palette[ `$index++ ] = `$accentColor.R;`n"
        "`t`t`t  `$palette[ `$index++ ] = `$accentColor.G;`n"
        "`t`t`t  `$palette[ `$index++ ] = `$accentColor.B;`n"
        "`t`t`t  `$palette[ `$index++ ] = `$accentColor.A;`n"
        "`t`t`t  Set-ItemProperty @params -Value `$palette -Type $([System.Char]39)Binary$([System.Char]39) -Force;`n"
        "`t`t`t};`n"
        "`t`t"
      #>

      "`n"
      "`t`t`t`$lightThemeSystem = 0;`n"
      "`t`t`t`$lightThemeApps = 0;`n"
      "`t`t`t`$accentColorOnStart = 0;`n"
      "`t`t`t`$enableTransparency = 0;`n"
      "`t`t`t`$htmlAccentColor = $([System.Char]39)#0078D4$([System.Char]39);`n"
      "`t`t`t& {`n"
      "`t`t`t  `$params = @{`n"
      "`t`t`t    LiteralPath = $([System.Char]39)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize$([System.Char]39);`n"
      "`t`t`t    Force = `$true;`n"
      "`t`t`t    Type = $([System.Char]39)DWord$([System.Char]39);`n"
      "`t`t`t  };`n"
      "`t`t`t  Set-ItemProperty @params -Name $([System.Char]39)SystemUsesLightTheme$([System.Char]39) -Value `$lightThemeSystem;`n"
      "`t`t`t  Set-ItemProperty @params -Name $([System.Char]39)AppsUseLightTheme$([System.Char]39) -Value `$lightThemeApps;`n"
      "`t`t`t  Set-ItemProperty @params -Name $([System.Char]39)ColorPrevalence$([System.Char]39) -Value `$accentColorOnStart;`n"
      "`t`t`t  Set-ItemProperty @params -Name $([System.Char]39)EnableTransparency$([System.Char]39) -Value `$enableTransparency;`n"
      "`t`t`t};`n"
      "`t`t`t`n"
      "`t`t`t& {`n"
      "`t`t`t  Add-Type -AssemblyName $([System.Char]39)System.Drawing$([System.Char]39);`n"
      "`t`t`t  `$accentColor = [System.Drawing.ColorTranslator]::FromHtml( `$htmlAccentColor );`n"
      "`t`t`t  function ConvertTo-DWord {`n"
      "`t`t`t    param(`n"
      "`t`t`t      [System.Drawing.Color]`n"
      "`t`t`t      `$Color`n"
      "`t`t`t    );`n"
      "`t`t`t`n"
      "`t`t`t    [byte[]] `$bytes = @(`n"
      "`t`t`t      `$Color.R;`n"
      "`t`t`t      `$Color.G;`n"
      "`t`t`t      `$Color.B;`n"
      "`t`t`t      `$Color.A;`n"
      "`t`t`t    );`n"
      "`t`t`t`n"
      "`t`t`t    return [System.BitConverter]::ToUInt32( `$bytes, 0);`n"
      "`t`t`t  }`n"
      "`t`t`t`n"
      "`t`t`t  `$startColor = [System.Drawing.Color]::FromArgb( 0xD2, `$accentColor );`n"
      "`t`t`t  Set-ItemProperty -LiteralPath $([System.Char]39)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent$([System.Char]39) -Name $([System.Char]39)StartColorMenu$([System.Char]39) -Value( ConvertTo-DWord -Color `$accentColor ) -Type $([System.Char]39)DWord$([System.Char]39) -Force;`n"
      "`t`t`t  Set-ItemProperty -LiteralPath $([System.Char]39)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent$([System.Char]39) -Name $([System.Char]39)AccentColorMenu$([System.Char]39) -Value( ConvertTo-DWord -Color `$accentColor ) -Type $([System.Char]39)DWord$([System.Char]39) -Force;`n"
      "`t`t`t  Set-ItemProperty -LiteralPath $([System.Char]39)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\DWM$([System.Char]39) -Name $([System.Char]39)AccentColor$([System.Char]39) -Value( ConvertTo-DWord -Color `$accentColor ) -Type $([System.Char]39)DWord$([System.Char]39) -Force;`n"
      "`t`t`t  `$params = @{`n"
      "`t`t`t    LiteralPath = $([System.Char]39)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent$([System.Char]39);`n"
      "`t`t`t    Name = $([System.Char]39)AccentPalette$([System.Char]39);`n"
      "`t`t`t  };`n"
      "`t`t`t`n"
      "`t`t`t  `$palette = Get-ItemPropertyValue @params;`n"
      "`t`t`t  `$index = 20;`n"
      "`t`t`t  `$palette[ `$index++ ] = `$accentColor.R;`n"
      "`t`t`t  `$palette[ `$index++ ] = `$accentColor.G;`n"
      "`t`t`t  `$palette[ `$index++ ] = `$accentColor.B;`n"
      "`t`t`t  `$palette[ `$index++ ] = `$accentColor.A;`n"
      "`t`t`t  Set-ItemProperty @params -Value `$palette -Type $([System.Char]39)Binary$([System.Char]39) -Force;`n"
      "`t`t`t};`n"
      "`t`t"


      { # SetColorTheme.ps1 Plain-Text | Converted to ${File SetColorTheme.ps1 Here-String} with 'ConvertTo-HereStringCompatible' |
        $lightThemeSystem = 0;
        $lightThemeApps = 0;
        $accentColorOnStart = 0;
        $enableTransparency = 0;
        $htmlAccentColor = '#0078D4';
        & {
          $params = @{
            LiteralPath = 'Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize';
            Force = $true;
            Type = 'DWord';
          };
          Set-ItemProperty @params -Name 'SystemUsesLightTheme' -Value $lightThemeSystem;
          Set-ItemProperty @params -Name 'AppsUseLightTheme' -Value $lightThemeApps;
          Set-ItemProperty @params -Name 'ColorPrevalence' -Value $accentColorOnStart;
          Set-ItemProperty @params -Name 'EnableTransparency' -Value $enableTransparency;
        };

        & {
          Add-Type -AssemblyName 'System.Drawing';
          $accentColor = [System.Drawing.ColorTranslator]::FromHtml( $htmlAccentColor );
          function ConvertTo-DWord {
            param(
              [System.Drawing.Color]
              $Color
            );

            [byte[]] $bytes = @(
              $Color.R;
              $Color.G;
              $Color.B;
              $Color.A;
            );

            return [System.BitConverter]::ToUInt32( $bytes, 0);
          }

          $startColor = [System.Drawing.Color]::FromArgb( 0xD2, $accentColor );
          Set-ItemProperty -LiteralPath 'Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent' -Name 'StartColorMenu' -Value( ConvertTo-DWord -Color $accentColor ) -Type 'DWord' -Force;
          Set-ItemProperty -LiteralPath 'Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent' -Name 'AccentColorMenu' -Value( ConvertTo-DWord -Color $accentColor ) -Type 'DWord' -Force;
          Set-ItemProperty -LiteralPath 'Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\DWM' -Name 'AccentColor' -Value( ConvertTo-DWord -Color $accentColor ) -Type 'DWord' -Force;
          $params = @{
            LiteralPath = 'Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent';
            Name = 'AccentPalette';
          };

          $palette = Get-ItemPropertyValue @params;
          $index = 20;
          $palette[ $index++ ] = $accentColor.R;
          $palette[ $index++ ] = $accentColor.G;
          $palette[ $index++ ] = $accentColor.B;
          $palette[ $index++ ] = $accentColor.A;
          Set-ItemProperty @params -Value $palette -Type 'Binary' -Force;
        };
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\SetColorTheme.ps1')
        $XmlWriter.WriteAttributeString('transformation','Text')
        $XmlWriter.WriteString(${File SetColorTheme.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion
    #region | HideTaskBar-FirstLogon.ps1 Here-String |
    ${File HideTaskBar-FirstLogon.ps1 Here-String} = $(
      "`n"
      "`t`t`t`$Path = $([System.Char]39)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3$([System.Char]39)`n"
      "`t`t`t`$Value = (Get-ItemProperty -Path `$Path).Settings`n"
      "`t`t`t`$Value[8] = 0x7b`n"
      "`t`t`tSet-ItemProperty -Path `$Path -Name $([System.Char]39)Settings$([System.Char]39) -Value `$Value`n"
      "`t`t`tGet-Process -Name explorer | Stop-Process -Force | Start-Process -FilePath $([System.Char]34)`$env:windir\explorer.exe$([System.Char]34)`n"
      "`t`t"
      { # HideTaskBar-FirstLogon.ps1 Plain-Text | Converted to ${File HideTaskBar-FirstLogon.ps1 Here-String} with 'ConvertTo-HereStringCompatible' |
        $Path = 'Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3'
        $Value = (Get-ItemProperty -Path $Path).Settings
        $Value[8] = 0x7b
        Set-ItemProperty -Path $Path -Name 'Settings' -Value $Value
        Get-Process -Name explorer | Stop-Process -Force | Start-Process -FilePath "$env:windir\explorer.exe"
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\HideTaskBar-FirstLogon.ps1')
        $XmlWriter.WriteString(${File HideTaskBar-FirstLogon.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion

    #region | "Visual Studio Code Install.ps1" Here-String and XML Element |
    ${File Visual Studio Code Install.ps1 Here-String} = $(
      #region |  |
      "`n"
      "`t`t`t# Install Visual Studio Code`n"
      "`t`t`tWrite-Host -Object $([System.Char]34)Script to run when the first user logs on after Windows has been installed.$([System.Char]34)`n"
      "`t`t`tWrite-Host -Object $([System.Char]34)First user to log on is typically an administrator. Script would run with elevated privileges.$([System.Char]34)`n"
      "`t`t`t`$VSCodeExe = Get-ChildItem -Path $([System.Char]34)`$env:SystemDrive\$__DirectoryForDscConfigs\Installs\Visual Studio Code\##$([System.Char]34) -Filter $([System.Char]34)VSCodeSetup-x64-*.exe$([System.Char]34) -Recurse $([System.Char]96)`n"
      "`t`t`t| Sort-Object -Property $([System.Char]39)LastWriteTime$([System.Char]39) $([System.Char]96)`n"
      "`t`t`t| Select-Object -Last 1`n"
      "`t`t`tStart-Process -FilePath `$VSCodeExe.FullName -ArgumentList @($([System.Char]34)/VERYSILENT$([System.Char]34),$([System.Char]34)/MERGETASKS=!runcode$([System.Char]34))`n"
      "`t`t"
      #endregion

      {
        # Install Visual Studio Code
        Write-Host -Object "Script to run when the first user logs on after Windows has been installed."
        Write-Host -Object "First user to log on is typically an administrator. Script would run with elevated privileges."
        $VSCodeExe = Get-ChildItem -Path "$env:SystemDrive\$__DirectoryForDscConfigs\Installs\Visual Studio Code\##" -Filter "VSCodeSetup-x64-*.exe" -Recurse `
        | Sort-Object -Property 'LastWriteTime' `
        | Select-Object -Last 1
        Start-Process -FilePath $VSCodeExe.FullName -ArgumentList @("/VERYSILENT","/MERGETASKS=!runcode")
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\Visual Studio Code Install.ps1')
        $XmlWriter.WriteString(${File Visual Studio Code Install.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion
    #region | "Multitasking Reduction-FirstLogon.ps1" Here-String and XML Element |
    ${File Multitasking Reduction-FirstLogon.ps1 Here-String} = $(
      #region |  |
      "`n"
      "`t`t`t`$RegItem = try { # Uncheck the box at ms-settings:multitasking, Snap windows, $([System.Char]34)When I snap a window, suggest what I can snap next to it$([System.Char]34) |`n"
      "`t`t`t  Get-ItemProperty -Path $([System.Char]34)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34) -Name $([System.Char]39)SnapAssist$([System.Char]39) -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  New-ItemProperty -Path $([System.Char]34)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34) -Name $([System.Char]39)SnapAssist$([System.Char]39) -Type $([System.Char]39)DWORD$([System.Char]39) -Value $([System.Char]39)0$([System.Char]39)`n"
      "`t`t`t}`n"
      "`t`t`t`$RegItem = try { # Uncheck the box at ms-settings:multitasking, Snap windows, $([System.Char]34)Show snap layouts when I hover over a window$([System.Char]39)s maximize button$([System.Char]34) |`n"
      "`t`t`t  Get-ItemProperty -Path $([System.Char]34)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34) -Name $([System.Char]39)EnableSnapAssistFlyout$([System.Char]39) -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  New-ItemProperty -Path $([System.Char]34)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34) -Name $([System.Char]39)EnableSnapAssistFlyout$([System.Char]39) -Type $([System.Char]39)DWORD$([System.Char]39) -Value $([System.Char]39)0$([System.Char]39)`n"
      "`t`t`t}`n"
      "`t`t`t`$RegItem = try { # Uncheck the box at ms-settings:multitasking, Snap windows, $([System.Char]34)Show snap layouts when I drag a window to the top of my screen$([System.Char]34) |`n"
      "`t`t`t  Get-ItemProperty -Path $([System.Char]34)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34) -Name $([System.Char]39)EnableSnapBar$([System.Char]39) -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  New-ItemProperty -Path $([System.Char]34)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34) -Name $([System.Char]39)EnableSnapBar$([System.Char]39) -Type $([System.Char]39)DWORD$([System.Char]39) -Value $([System.Char]39)0$([System.Char]39)`n"
      "`t`t`t}`n"
      "`t`t`t`$RegItem = try { # Uncheck the box at ms-settings:multitasking, Snap windows, $([System.Char]34)Show my snapped windows when I hover over taskbar apps, in Task View, and when I press Alt+Tab$([System.Char]34) |`n"
      "`t`t`t  Get-ItemProperty -Path $([System.Char]34)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34) -Name $([System.Char]39)EnableTaskGroups$([System.Char]39) -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  New-ItemProperty -Path $([System.Char]34)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34) -Name $([System.Char]39)EnableTaskGroups$([System.Char]39) -Type $([System.Char]39)DWORD$([System.Char]39) -Value $([System.Char]39)0$([System.Char]39)`n"
      "`t`t`t}`n"
      "`t`t`t`$RegItem = try { # Uncheck the box at ms-settings:multitasking, Snap windows, $([System.Char]34)When I drag a window, let me snap it without dragging all the way to the screen edge$([System.Char]34) |`n"
      "`t`t`t  Get-ItemProperty -Path $([System.Char]34)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34) -Name $([System.Char]39)DITest$([System.Char]39) -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  New-ItemProperty -Path $([System.Char]34)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34) -Name $([System.Char]39)DITest$([System.Char]39) -Type $([System.Char]39)DWORD$([System.Char]39) -Value $([System.Char]39)0$([System.Char]39)`n"
      "`t`t`t}`n"
      "`t`t`t`$RegItem = try { # Adjust dropdown box at ms-settings:multitasking, $([System.Char]34)Show tabs from apps when snapping or pressing Alt+Tab$([System.Char]34) to $([System.Char]34)Don$([System.Char]39)t show tabs$([System.Char]34) |`n"
      "`t`t`t  Get-ItemProperty -Path $([System.Char]34)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34) -Name $([System.Char]39)MultiTaskingAltTabFilter$([System.Char]39) -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  New-ItemProperty -Path $([System.Char]34)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34) -Name $([System.Char]39)MultiTaskingAltTabFilter$([System.Char]39) -Type $([System.Char]39)DWORD$([System.Char]39) -Value $([System.Char]39)3$([System.Char]39)`n"
      "`t`t`t}`n"
      "`t`t`t`$RegItem = try { # Adjust dropdown box at ms-settings:multitasking, $([System.Char]34)Show tabs from apps when snapping or pressing Alt+Tab$([System.Char]34) to $([System.Char]34)Don$([System.Char]39)t show tabs$([System.Char]34) |`n"
      "`t`t`t  Get-ItemProperty -Path $([System.Char]34)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34) -Name $([System.Char]39)MultiTaskingAltTabFilter$([System.Char]39) -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  New-ItemProperty -Path $([System.Char]34)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34) -Name $([System.Char]39)MultiTaskingAltTabFilter$([System.Char]39) -Type $([System.Char]39)DWORD$([System.Char]39) -Value $([System.Char]39)3$([System.Char]39)`n"
      "`t`t`t}`n"
      "`t`t"
      #endregion

      { # Multitasking Reduction-FirstLogon.ps1 Plain-Text | Converted to ${File Multitasking Reduction-FirstLogon.ps1 Here-String} with 'ConvertTo-HereStringCompatible' |
        $RegItem = try { # Uncheck the box at ms-settings:multitasking, Snap windows, "When I snap a window, suggest what I can snap next to it" |
          Get-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name 'SnapAssist' -ErrorAction 'Stop'
        } catch {
          New-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name 'SnapAssist' -Type 'DWORD' -Value '0'
        }
        $RegItem = try { # Uncheck the box at ms-settings:multitasking, Snap windows, "Show snap layouts when I hover over a window's maximize button" |
          Get-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name 'EnableSnapAssistFlyout' -ErrorAction 'Stop'
        } catch {
          New-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name 'EnableSnapAssistFlyout' -Type 'DWORD' -Value '0'
        }
        $RegItem = try { # Uncheck the box at ms-settings:multitasking, Snap windows, "Show snap layouts when I drag a window to the top of my screen" |
          Get-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name 'EnableSnapBar' -ErrorAction 'Stop'
        } catch {
          New-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name 'EnableSnapBar' -Type 'DWORD' -Value '0'
        }
        $RegItem = try { # Uncheck the box at ms-settings:multitasking, Snap windows, "Show my snapped windows when I hover over taskbar apps, in Task View, and when I press Alt+Tab" |
          Get-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name 'EnableTaskGroups' -ErrorAction 'Stop'
        } catch {
          New-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name 'EnableTaskGroups' -Type 'DWORD' -Value '0'
        }
        $RegItem = try { # Uncheck the box at ms-settings:multitasking, Snap windows, "When I drag a window, let me snap it without dragging all the way to the screen edge" |
          Get-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name 'DITest' -ErrorAction 'Stop'
        } catch {
          New-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name 'DITest' -Type 'DWORD' -Value '0'
        }
        $RegItem = try { # Adjust dropdown box at ms-settings:multitasking, "Show tabs from apps when snapping or pressing Alt+Tab" to "Don't show tabs" |
          Get-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name 'MultiTaskingAltTabFilter' -ErrorAction 'Stop'
        } catch {
          New-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name 'MultiTaskingAltTabFilter' -Type 'DWORD' -Value '3'
        }
        $RegItem = try { # Adjust dropdown box at ms-settings:multitasking, "Show tabs from apps when snapping or pressing Alt+Tab" to "Don't show tabs" |
          Get-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name 'MultiTaskingAltTabFilter' -ErrorAction 'Stop'
        } catch {
          New-ItemProperty -Path "Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name 'MultiTaskingAltTabFilter' -Type 'DWORD' -Value '3'
        }
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\Multitasking Reduction-FirstLogon.ps1')
        $XmlWriter.WriteString(${File Multitasking Reduction-FirstLogon.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion
    #region | "OneDrive Install.ps1" Here-String and XML Element |
    ${File OneDrive Install.ps1 Here-String} = $(
      #region |  |
      "`n"
      "`t`t`t# Install OneDrive`n"
      "`t`t`tWrite-Host -Object $([System.Char]34)Script to run when the first user logs on after Windows has been installed.$([System.Char]34)`n"
      "`t`t`tWrite-Host -Object $([System.Char]34)First user to log on is typically an administrator. Script would run with elevated privileges.$([System.Char]34)`n"
      "`t`t`tStart-Process -FilePath $([System.Char]34)`$env:SystemDrive\$__DirectoryForDscConfigs\Installs\OneDrive\##\OneDriveSetup.exe$([System.Char]34) -ArgumentList @($([System.Char]34)/silent$([System.Char]34),$([System.Char]34)/allusers$([System.Char]34))`n"
      "`t`t"
      #endregion

      {
        # Install OneDrive
        Write-Host -Object "Script to run when the first user logs on after Windows has been installed."
        Write-Host -Object "First user to log on is typically an administrator. Script would run with elevated privileges."
        Start-Process -FilePath "$env:SystemDrive\$__DirectoryForDscConfigs\Installs\OneDrive\##\OneDriveSetup.exe" -ArgumentList @("/silent","/allusers")
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\OneDrive Install.ps1')
        $XmlWriter.WriteString(${File OneDrive Install.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion

    #region | "SetWallpaper-FirstLogon.ps1" Here-String |
    ${File SetWallpaper-FirstLogon.ps1 Here-String} = $(

      #region |  |
      "`n"
      "`t`t`tAdd-Type -TypeDefinition $([System.Char]39)`n"
      "`t`t`t  using System.Drawing;`n"
      "`t`t`t  using System.Runtime.InteropServices;`n"
      "`t`t`t  public static class WallpaperSetter {`n"
      "`t`t`t    [DllImport($([System.Char]34)user32.dll$([System.Char]34))]`n"
      "`t`t`t    private static extern bool SetSysColors(`n"
      "`t`t`t      int cElements,`n"
      "`t`t`t      int[] lpaElements,`n"
      "`t`t`t      int[] lpaRgbValues`n"
      "`t`t`t    );                                            `n"
      "`t`t`t    [DllImport($([System.Char]34)user32.dll$([System.Char]34))]`n"
      "`t`t`t    private static extern bool SystemParametersInfo(`n"
      "`t`t`t      uint uiAction,`n"
      "`t`t`t      uint uiParam,`n"
      "`t`t`t      string pvParam,`n"
      "`t`t`t      uint fWinIni`n"
      "`t`t`t    );`n"
      "`t`t`t    public static void SetDesktopBackground(Color color) {`n"
      "`t`t`t      SystemParametersInfo(20, 0, $([System.Char]34)$([System.Char]34), 0);`n"
      "`t`t`t      SetSysColors(1, new int[] { 1 }, new int[] { ColorTranslator.ToWin32(color) });`n"
      "`t`t`t    }`n"
      "`t`t`t    public static void SetDesktopImage(string file) {`n"
      "`t`t`t      SystemParametersInfo(20, 0, file, 0);`n"
      "`t`t`t    }`n"
      "`t`t`t  }`n"
      "`t`t`t$([System.Char]39) -ReferencedAssemblies $([System.Char]39)System.Drawing$([System.Char]39);`n"
      "`t`t`tfunction Set-FirstLogonWallpaperColor {`n"
      "`t`t`t  param(`n"
      "`t`t`t    [string]`n"
      "`t`t`t    `$HtmlColor`n"
      "`t`t`t  );`n"
      "`t`t`t`n"
      "`t`t`t  `$color = [System.Drawing.ColorTranslator]::FromHtml( `$HtmlColor );`n"
      "`t`t`t  [WallpaperSetter]::SetDesktopBackground( `$color );`n"
      "`t`t`t`n"
      "`t`t`t  # Set-ItemProperty -Path $([System.Char]39)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Wallpapers$([System.Char]39) -Name $([System.Char]39)BackgroundType$([System.Char]39) -Type $([System.Char]39)DWord$([System.Char]39) -Value 1 -Force;`n"
      "`t`t`t  `$path = $([System.Char]34)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer$([System.Char]34)`n"
      "`t`t`t  `$name = $([System.Char]39)Wallpapers$([System.Char]39)`n"
      "`t`t`t  `$RegItem = try {`n"
      "`t`t`t    Get-Item -Path `$path -Name `$name -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t  } catch {`n"
      "`t`t`t    New-Item -Path `$path -Name `$name -Force -Verbose`n"
      "`t`t`t  }`n"
      "`t`t`t  `$path = $([System.Char]34)`$path\`$name$([System.Char]34)`n"
      "`t`t`t  `$name = $([System.Char]39)BackgroundType$([System.Char]39)`n"
      "`t`t`t  `$RegItemProp = try {`n"
      "`t`t`t    Get-ItemProperty -Path `$path -Name `$name -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t  } catch {`n"
      "`t`t`t    `$InputHT = @{`n"
      "`t`t`t      Path    = `$path`n"
      "`t`t`t      Name    = `$name`n"
      "`t`t`t      Type    = $([System.Char]39)Dword$([System.Char]39)`n"
      "`t`t`t      Value   = $([System.Char]39)1$([System.Char]39)`n"
      "`t`t`t      Force   = `$true`n"
      "`t`t`t      Verbose = `$true`n"
      "`t`t`t    }`n"
      "`t`t`t    New-ItemProperty @InputHT`n"
      "`t`t`t  }`n"
      "`t`t`t  `n"
      "`t`t`t  Set-ItemProperty -Path $([System.Char]39)Registry::HKEY_CURRENT_USER\Control Panel\Desktop$([System.Char]39) -Name $([System.Char]39)WallPaper$([System.Char]39) -Type $([System.Char]39)String$([System.Char]39) -Value $([System.Char]39)$([System.Char]39) -Force;`n"
      "`t`t`t  Set-ItemProperty -Path $([System.Char]39)Registry::HKEY_CURRENT_USER\Control Panel\Colors$([System.Char]39) -Name $([System.Char]39)Background$([System.Char]39) -Type $([System.Char]39)String$([System.Char]39) -Value $([System.Char]34)`$(`$color.R) `$(`$color.G) `$(`$color.B)$([System.Char]34) -Force;`n"
      "`t`t`t}`n"
      "`t`t`tfunction Set-FirstLogonWallpaperImage {`n"
      "`t`t`t  param(`n"
      "`t`t`t    [string]`n"
      "`t`t`t    `$LiteralPath`n"
      "`t`t`t  );`n"
      "`t`t`t`n"
      "`t`t`t  if( `$LiteralPath | Test-Path ) {`n"
      "`t`t`t    [WallpaperSetter]::SetDesktopImage( `$LiteralPath );`n"
      "`t`t`t`n"
      "`t`t`t    #Set-ItemProperty -Path $([System.Char]39)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Wallpapers$([System.Char]39) -Name $([System.Char]39)BackgroundType$([System.Char]39) -Type $([System.Char]39)DWord$([System.Char]39) -Value 0 -Force;`n"
      "`t`t`t    `$path = $([System.Char]34)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer$([System.Char]34)`n"
      "`t`t`t    `$name = $([System.Char]39)Wallpapers$([System.Char]39)`n"
      "`t`t`t    `$RegItem = try {`n"
      "`t`t`t      Get-Item -Path `$path -Name `$name -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t    } catch {`n"
      "`t`t`t      New-Item -Path `$path -Name `$name -Force -Verbose`n"
      "`t`t`t    }`n"
      "`t`t`t    `$path = $([System.Char]34)`$path\`$name$([System.Char]34)`n"
      "`t`t`t    `$name = $([System.Char]39)BackgroundType$([System.Char]39)`n"
      "`t`t`t    `$RegItemProp = try {`n"
      "`t`t`t      Get-ItemProperty -Path `$path -Name `$name -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t    } catch {`n"
      "`t`t`t      `$InputHT = @{`n"
      "`t`t`t        Path    = `$path`n"
      "`t`t`t        Name    = `$name`n"
      "`t`t`t        Type    = $([System.Char]39)Dword$([System.Char]39)`n"
      "`t`t`t        Value   = $([System.Char]39)0$([System.Char]39)`n"
      "`t`t`t        Force   = `$true`n"
      "`t`t`t        Verbose = `$true`n"
      "`t`t`t      }`n"
      "`t`t`t      New-ItemProperty @InputHT`n"
      "`t`t`t    }`n"
      "`t`t`t  `n"
      "`t`t`t    Set-ItemProperty -Path $([System.Char]39)Registry::HKEY_CURRENT_USER\Control Panel\Desktop$([System.Char]39) -Name $([System.Char]39)WallPaper$([System.Char]39) -Type $([System.Char]39)String$([System.Char]39) -Value `$LiteralPath -Force;`n"
      "`t`t`t  } else {`n"
      "`t`t`t    $([System.Char]34)Cannot use $([System.Char]39)`$LiteralPath$([System.Char]39) as a desktop wallpaper because that file does not exist.$([System.Char]34);`n"
      "`t`t`t  }`n"
      "`t`t`t}`n"
      "`t`t`tSet-FirstLogonWallpaperColor -HtmlColor $([System.Char]39)#0A0F0F$([System.Char]39);`n"
      "`t`t"
      #endregion

      { # SetWallpaper-FirstLogon.ps1 Plain-Text | Converted to ${File SetWallpaper-FirstLogon.ps1 Here-String} with 'ConvertTo-HereStringCompatible' | Mysteries of PInvoke |
        Add-Type -TypeDefinition '
          using System.Drawing;
          using System.Runtime.InteropServices;
          public static class WallpaperSetter {
            [DllImport("user32.dll")]
            private static extern bool SetSysColors(
              int cElements,
              int[] lpaElements,
              int[] lpaRgbValues
            );                                            
            [DllImport("user32.dll")]
            private static extern bool SystemParametersInfo(
              uint uiAction,
              uint uiParam,
              string pvParam,
              uint fWinIni
            );
            public static void SetDesktopBackground(Color color) {
              SystemParametersInfo(20, 0, "", 0);
              SetSysColors(1, new int[] { 1 }, new int[] { ColorTranslator.ToWin32(color) });
            }
            public static void SetDesktopImage(string file) {
              SystemParametersInfo(20, 0, file, 0);
            }
          }
        ' -ReferencedAssemblies 'System.Drawing';
        function Set-FirstLogonWallpaperColor {
          param(
            [string]
            $HtmlColor
          );

          $color = [System.Drawing.ColorTranslator]::FromHtml( $HtmlColor );
          [WallpaperSetter]::SetDesktopBackground( $color );

          # Set-ItemProperty -Path 'Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Wallpapers' -Name 'BackgroundType' -Type 'DWord' -Value 1 -Force;
          $path = "Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer"
          $name = 'Wallpapers'
          $RegItem = try {
            Get-Item -Path $path -Name $name -ErrorAction 'Stop'
          } catch {
            New-Item -Path $path -Name $name -Force -Verbose
          }
          $path = "$path\$name"
          $name = 'BackgroundType'
          $RegItemProp = try {
            Get-ItemProperty -Path $path -Name $name -ErrorAction 'Stop'
          } catch {
            $InputHT = @{
              Path    = $path
              Name    = $name
              Type    = 'Dword'
              Value   = '1'
              Force   = $true
              Verbose = $true
            }
            New-ItemProperty @InputHT
          }
          
          Set-ItemProperty -Path 'Registry::HKEY_CURRENT_USER\Control Panel\Desktop' -Name 'WallPaper' -Type 'String' -Value '' -Force;
          Set-ItemProperty -Path 'Registry::HKEY_CURRENT_USER\Control Panel\Colors' -Name 'Background' -Type 'String' -Value "$($color.R) $($color.G) $($color.B)" -Force;
        }
        function Set-FirstLogonWallpaperImage {
          param(
            [string]
            $LiteralPath
          );

          if( $LiteralPath | Test-Path ) {
            [WallpaperSetter]::SetDesktopImage( $LiteralPath );

            #Set-ItemProperty -Path 'Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Wallpapers' -Name 'BackgroundType' -Type 'DWord' -Value 0 -Force;
            $path = "Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer"
            $name = 'Wallpapers'
            $RegItem = try {
              Get-Item -Path $path -Name $name -ErrorAction 'Stop'
            } catch {
              New-Item -Path $path -Name $name -Force -Verbose
            }
            $path = "$path\$name"
            $name = 'BackgroundType'
            $RegItemProp = try {
              Get-ItemProperty -Path $path -Name $name -ErrorAction 'Stop'
            } catch {
              $InputHT = @{
                Path    = $path
                Name    = $name
                Type    = 'Dword'
                Value   = '0'
                Force   = $true
                Verbose = $true
              }
              New-ItemProperty @InputHT
            }
          
            Set-ItemProperty -Path 'Registry::HKEY_CURRENT_USER\Control Panel\Desktop' -Name 'WallPaper' -Type 'String' -Value $LiteralPath -Force;
          } else {
            "Cannot use '$LiteralPath' as a desktop wallpaper because that file does not exist.";
          }
        }
        Set-FirstLogonWallpaperColor -HtmlColor '#0A0F0F';
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\SetWallpaper-FirstLogon.ps1')
        $XmlWriter.WriteString(${File SetWallpaper-FirstLogon.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion

    #region | "Credential Manager-RESTOREps1" Here-String and XML Element |
    ${File Credential Manager-RESTORE.ps1 Here-String} = $(

      {
        # Restore Credential Manager data |
        "$usb0\sec\$FolderFQN.crd" | Set-Clipboard
        control.exe /Name Microsoft.CredentialManager
        pause
        Start-Sleep 20
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\Credential Manager-RESTORE.ps1')
        $XmlWriter.WriteString(${File Credential Manager-RESTORE.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion


    #region | "___.ps1" Here-String and XML Element |
    <#
      ${File ___.ps1 Here-String} = $(

        {

        } | Out-Null
      ) -join ''
        $XmlWriter.WriteStartElement('File')
          $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\___.ps1')
          $XmlWriter.WriteString(${File ___.ps1 Here-String})
        $XmlWriter.WriteEndElement()
    #>
    #endregion
    #region | "___.ps1" Here-String and XML Element |
    <#
      ${File ___.ps1 Here-String} = $(

        {

        } | Out-Null
      ) -join ''
        $XmlWriter.WriteStartElement('File')
          $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\___.ps1')
          $XmlWriter.WriteString(${File ___.ps1 Here-String})
        $XmlWriter.WriteEndElement()
    #>
    #endregion


    ${File FirstLogon.ps1 Here-String} = $(

      #region |  |
      "`n"
      "`t`t`t`$FirstLogonScriptBlocks = `$(`n"
      "`t`t`t  #{& $([System.Char]39)C:\Windows\Setup\Scripts\NTFS Reparse Points-Partial Removal.ps1$([System.Char]39)}`n"
      "`t`t`t  # Delete Windows.old with sdelete.exe |`n"
      "`t`t`t  # {`$path = $([System.Char]34)`$env:SystemDrive\Windows.old$([System.Char]34); if (Test-Path -Path `$path) {Remove-Item -Path `$path -Force -Recurse -Verbose}}`n"
      "`t`t`t  {& $([System.Char]39)C:\Windows\Setup\Scripts\Visual Studio Code Install.ps1$([System.Char]39)}`n"
      "`t`t`t  {& $([System.Char]39)C:\Windows\Setup\Scripts\OneDrive Install.ps1$([System.Char]39)}`n"
      "`t`t`t  {& $([System.Char]39)C:\Windows\Setup\Scripts\Multitasking Reduction-FirstLogon.ps1$([System.Char]39)}`n"
      "`t`t`t  {& $([System.Char]39)C:\Windows\Setup\Scripts\SetColorTheme.ps1$([System.Char]39)}`n"
      "`t`t`t  {& $([System.Char]39)C:\Windows\Setup\Scripts\SetWallpaper-FirstLogon.ps1$([System.Char]39)}`n"
      "`t`t`t  {& $([System.Char]39)C:\Windows\Setup\Scripts\HideTaskBar-FirstLogon.ps1$([System.Char]39)}`n"
      "`t`t`t  # Mess with this some other time `n"
      "`t`t`t  #{& $([System.Char]39)C:\Windows\Setup\Scripts\Credential Manager-RESTORE.ps1$([System.Char]39)}`n"
      "`t`t`t)`n"
      "`t`t`t& {`n"
      "`t`t`t  [System.Single] `$Complete = 0`n"
      "`t`t`t  [System.Single] `$Increment = 100 / `$FirstLogonScriptBlocks.Count`n"
      "`t`t`t  foreach (`$script in `$FirstLogonScriptBlocks) {`n"
      "`t`t`t    Write-Progress -Activity $([System.Char]39)Running scriptblocks in FirstLogon.ps1. Do not close this window.$([System.Char]39) -PercentComplete `$Complete`n"
      "`t`t`t    $([System.Char]34)*** Will now execute command «{0}»$([System.Char]34) -f `$(`n"
      "`t`t`t      `$script.ToString().Trim() -replace $([System.Char]39)\s+$([System.Char]39), $([System.Char]39) $([System.Char]39) -replace $([System.Char]39)^(.{99})(.+)`$$([System.Char]39), $([System.Char]39)`$1……$([System.Char]39)`n"
      "`t`t`t    )`n"
      "`t`t`t    `$start = [System.DateTime]::Now`n"
      "`t`t`t    & `$script`n"
      "`t`t`t    $([System.Char]39)*** Finished executing command after {0:0} ms.$([System.Char]39) -f [System.DateTime]::Now.Subtract(`$start).TotalMilliseconds`n"
      "`t`t`t    `$Complete += `$Increment`n"
      "`t`t`t  }`n"
      "`t`t`t} *>&1 | Out-String -Width 1KB -Stream >> $([System.Char]34)`$env:UserProfile\FirstLogon.log$([System.Char]34) # $([System.Char]34)C:\Windows\Setup\Scripts\FirstLogon.log$([System.Char]34)`n"
      "`t`t"
      #endregion

      {
        $FirstLogonScriptBlocks = $(
          #{& 'C:\Windows\Setup\Scripts\NTFS Reparse Points-Partial Removal.ps1'}
          # Delete Windows.old with sdelete.exe |
          # {$path = "$env:SystemDrive\Windows.old"; if (Test-Path -Path $path) {Remove-Item -Path $path -Force -Recurse -Verbose}}
          {& 'C:\Windows\Setup\Scripts\Visual Studio Code Install.ps1'}
          {& 'C:\Windows\Setup\Scripts\OneDrive Install.ps1'}
          {& 'C:\Windows\Setup\Scripts\Multitasking Reduction-FirstLogon.ps1'}
          {& 'C:\Windows\Setup\Scripts\SetColorTheme.ps1'}
          {& 'C:\Windows\Setup\Scripts\SetWallpaper-FirstLogon.ps1'}
          {& 'C:\Windows\Setup\Scripts\HideTaskBar-FirstLogon.ps1'}
          # Mess with this some other time 
          #{& 'C:\Windows\Setup\Scripts\Credential Manager-RESTORE.ps1'}
        )
        & {
          [System.Single] $Complete = 0
          [System.Single] $Increment = 100 / $FirstLogonScriptBlocks.Count
          foreach ($script in $FirstLogonScriptBlocks) {
            Write-Progress -Activity 'Running scriptblocks in FirstLogon.ps1. Do not close this window.' -PercentComplete $Complete
            "*** Will now execute command «{0}»" -f $(
              $script.ToString().Trim() -replace '\s+', ' ' -replace '^(.{99})(.+)$', '$1……'
            )
            $start = [System.DateTime]::Now
            & $script
            '*** Finished executing command after {0:0} ms.' -f [System.DateTime]::Now.Subtract($start).TotalMilliseconds
            $Complete += $Increment
          }
        } *>&1 | Out-String -Width 1KB -Stream >> "$env:UserProfile\FirstLogon.log" # "C:\Windows\Setup\Scripts\FirstLogon.log"
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\FirstLogon.ps1')
        $XmlWriter.WriteString(${File FirstLogon.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion

    #region | HadeanDscConfigurationDocument.ps1 Here-String |
    #region | "___.ps1" Here-String and XML Element |
    <#
      ${File ___.ps1 Here-String} = $(

        {

        } | Out-Null
      ) -join ''
        $XmlWriter.WriteStartElement('File')
          $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\___.ps1')
          $XmlWriter.WriteString(${File ___.ps1 Here-String})
        $XmlWriter.WriteEndElement()
    #>
    #endregion
    #region | "___.ps1" Here-String and XML Element |
    <#
      ${File ___.ps1 Here-String} = $(

        {

        } | Out-Null
      ) -join ''
        $XmlWriter.WriteStartElement('File')
          $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\___.ps1')
          $XmlWriter.WriteString(${File ___.ps1 Here-String})
        $XmlWriter.WriteEndElement()
    #>
    #endregion
    #region | "___.ps1" Here-String and XML Element |
    <#
      ${File ___.ps1 Here-String} = $(

        {

        } | Out-Null
      ) -join ''
        $XmlWriter.WriteStartElement('File')
          $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\___.ps1')
          $XmlWriter.WriteString(${File ___.ps1 Here-String})
        $XmlWriter.WriteEndElement()
    #>
    #endregion
    #region | "___.ps1" Here-String and XML Element |
    <#
      ${File ___.ps1 Here-String} = $(

        {

        } | Out-Null
      ) -join ''
        $XmlWriter.WriteStartElement('File')
          $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\___.ps1')
          $XmlWriter.WriteString(${File ___.ps1 Here-String})
        $XmlWriter.WriteEndElement()
    #>
    #endregion

    ${File HadeanDscConfigurationDocument.ps1 Here-String} = $(
      #region |  |
      "`n"
      "`t`t`t`$WaveIndex = $([System.Char]39)00$([System.Char]39)`n"
      "`t`t`t`$EpochIndex = $([System.Char]39)A$([System.Char]39)`n"
      "`t`t`t`$EpochLabel = $([System.Char]34)PreDocument_Encryption$([System.Char]34)`n"
      "`t`t`t`$InstanceName = $([System.Char]34)Epoch_`$(`$EpochIndex)__`$(`$EpochLabel)__Wave_`$(`$WaveIndex)$([System.Char]34)`n"
      "`t`t`t`$LCM_InstanceName = $([System.Char]34)LCM_$([System.Char]34) + `$InstanceName`n"
      "`t`t`t`n"
      "`t`t`t[System.Management.Automation.DscLocalConfigurationManagerAttribute()]`n"
      "`t`t`tConfiguration `$LCM_InstanceName {`n"
      "`t`t`t  Node $([System.Char]39)localhost$([System.Char]39) {`n"
      "`t`t`t    Settings {`n"
      "`t`t`t      ActionAfterReboot              = [System.String]$([System.Char]39)ContinueConfiguration$([System.Char]39)`n"
      "`t`t`t      AllowModuleOverwrite           = [System.Boolean]`$true`n"
      "`t`t`t      ConfigurationMode              = [System.String]$([System.Char]39)ApplyAndAutoCorrect$([System.Char]39)`n"
      "`t`t`t      ConfigurationModeFrequencyMins = [System.UInt32]15`n"
      "`t`t`t      RefreshFrequencyMins           = [System.UInt32]30`n"
      "`t`t`t      RebootNodeIfNeeded             = [System.Boolean]`$true`n"
      "`t`t`t      RefreshMode                    = [System.String]$([System.Char]39)Push$([System.Char]39)`n"
      "`t`t`t      StatusRetentionTimeInDays      = [System.UInt32]20`n"
      "`t`t`t    }`n"
      "`t`t`t  }`n"
      "`t`t`t}`n"
      "`t`t`t`$lcmHT = @{`n"
      "`t`t`t  InstanceName = `$LCM_InstanceName`n"
      "`t`t`t  OutputPath   = $([System.Char]34)`$MOFs\Epoch_`$(`$EpochIndex)__`$(`$EpochLabel)\Wave_`$WaveIndex$([System.Char]34)`n"
      "`t`t`t  Verbose      = `$true`n"
      "`t`t`t}`n"
      "`t`t`tInvoke-Expression -Verbose:`$true -Command $([System.Char]34)`$LCM_InstanceName @lcmHT$([System.Char]34)`n"
      "`t`t`tSet-DscLocalConfigurationManager -ComputerName $([System.Char]39)localhost$([System.Char]39) -Path `$lcmHT[$([System.Char]39)OutputPath$([System.Char]39)] -Force`n"
      "`t`t`t`n"
      "`t`t`tConfiguration `$InstanceName {`n"
      "`t`t`t  #region | Import DSC Resources into the Configuration Document |`n"
      "`t`t`t  Import-DscResource -ModuleName $([System.Char]39)PSDesiredStateConfiguration$([System.Char]39)  -ModuleVersion 1.1`n"
      "`t`t`t  Import-DscResource -ModuleName $([System.Char]39)xPSDesiredStateConfiguration$([System.Char]39) -ModuleVersion 9.2.2`n"
      "`t`t`t  # #Import-DscResource -ModuleName $([System.Char]39)AdHocDsc$([System.Char]39)                     -ModuleVersion 0.77.13.8`n"
      "`t`t`t  #  Import-DscResource -ModuleName $([System.Char]39)AdHocCertsDsc$([System.Char]39)                -ModuleVersion`n"
      "`t`t`t  #  Import-DscResource -ModuleName $([System.Char]39)AdHocNetsDsc$([System.Char]39)                 -ModuleVersion`n"
      "`t`t`t  #  Import-DscResource -ModuleName $([System.Char]39)AdHocPkiDsc$([System.Char]39)                  -ModuleVersion`n"
      "`t`t`t  #  Import-DscResource -ModuleName $([System.Char]39)AdHocUtilsDsc$([System.Char]39)                -ModuleVersion`n"
      "`t`t`t  Import-DscResource -ModuleName $([System.Char]39)ComputerManagementDsc$([System.Char]39)        -ModuleVersion 10.0.1`n"
      "`t`t`t  Import-DscResource -ModuleName $([System.Char]39)CertificateDsc$([System.Char]39)               -ModuleVersion 6.1.0`n"
      "`t`t`t  #endregion`n"
      "`t`t`t`n"
      "`t`t`t  Node $([System.Char]39)localhost$([System.Char]39) {`n"
      "`t`t`t    #region | Strictest Level of Windows PowerShell ScriptBlock and Module Logging |`n"
      "`t`t`t    xRegistry $([System.Char]39)PowerShell 5.1 ScriptBlock Logging$([System.Char]39) {`n"
      "`t`t`t      ValueName = $([System.Char]39)EnableScriptBlockLogging$([System.Char]39)`n"
      "`t`t`t      Key       = $([System.Char]39)HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging$([System.Char]39)`n"
      "`t`t`t      ValueData = $([System.Char]39)1$([System.Char]39)`n"
      "`t`t`t      ValueType = $([System.Char]39)String$([System.Char]39)`n"
      "`t`t`t      Force     = `$true`n"
      "`t`t`t      Ensure    = $([System.Char]39)Present$([System.Char]39)`n"
      "`t`t`t`n"
      "`t`t`t    }`n"
      "`t`t`t    xRegistry $([System.Char]39)PowerShell 5.1 Module Logging$([System.Char]39) {`n"
      "`t`t`t      ValueName = $([System.Char]39)EnableModuleLogging$([System.Char]39)`n"
      "`t`t`t      Key       = $([System.Char]39)HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ModuleLogging$([System.Char]39)`n"
      "`t`t`t      ValueData = $([System.Char]39)1$([System.Char]39)`n"
      "`t`t`t      ValueType = $([System.Char]39)String$([System.Char]39)`n"
      "`t`t`t      Force     = `$true`n"
      "`t`t`t      Ensure    = $([System.Char]39)Present$([System.Char]39)`n"
      "`t`t`t      DependsOn = [System.String[]]@(`n"
      "`t`t`t        $([System.Char]34)[xRegistry]PowerShell 5.1 ScriptBlock Logging$([System.Char]34)`n"
      "`t`t`t      )`n"
      "`t`t`t    }`n"
      "`t`t`t    xRegistry $([System.Char]39)PowerShell 5.1 Transcription 1$([System.Char]39) {`n"
      "`t`t`t      ValueName = $([System.Char]39)EnableTranscribing$([System.Char]39)`n"
      "`t`t`t      Key       = $([System.Char]39)HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\Transcription$([System.Char]39)`n"
      "`t`t`t      ValueData = $([System.Char]39)1$([System.Char]39)`n"
      "`t`t`t      ValueType = $([System.Char]39)String$([System.Char]39)`n"
      "`t`t`t      Force     = `$true`n"
      "`t`t`t      Ensure    = $([System.Char]39)Present$([System.Char]39)`n"
      "`t`t`t      DependsOn = [System.String[]]@(`n"
      "`t`t`t        $([System.Char]34)[xRegistry]PowerShell 5.1 Module Logging$([System.Char]34)`n"
      "`t`t`t      )`n"
      "`t`t`t    }`n"
      "`t`t`t    xRegistry $([System.Char]39)PowerShell 5.1 Transcription 2$([System.Char]39) {`n"
      "`t`t`t      ValueName = $([System.Char]39)EnableInvocationHeader$([System.Char]39)`n"
      "`t`t`t      Key       = $([System.Char]39)HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\Transcription$([System.Char]39)`n"
      "`t`t`t      ValueData = $([System.Char]39)1$([System.Char]39)`n"
      "`t`t`t      ValueType = $([System.Char]39)String$([System.Char]39)`n"
      "`t`t`t      Force     = `$true`n"
      "`t`t`t      Ensure    = $([System.Char]39)Present$([System.Char]39)`n"
      "`t`t`t      DependsOn = [System.String[]]@(`n"
      "`t`t`t        $([System.Char]34)[xRegistry]PowerShell 5.1 Transcription 1$([System.Char]34)`n"
      "`t`t`t      )`n"
      "`t`t`t    }`n"
      "`t`t`t    #endregion`n"
      "`t`t`t`n"
      "`t`t`t    #region | Diagnostics-Enable channels in the Microsoft-Windows-Dsc Event Log Provider |`n"
      "`t`t`t    <#`n"
      "`t`t`t      TrackDscEvents $([System.Char]39)Status of Operational channel for the Microsoft-Windows-Dsc event log provider$([System.Char]39) {`n"
      "`t`t`t        Channel   = $([System.Char]39)Operational$([System.Char]39)`n"
      "`t`t`t        Status    = $([System.Char]39)Enabled$([System.Char]39)`n"
      "`t`t`t        Ensure    = $([System.Char]39)Present$([System.Char]39)`n"
      "`t`t`t        DependsOn = [System.String[]]@(`n"
      "`t`t`t          $([System.Char]34)[xRegistry]PowerShell 5.1 Transcription 2$([System.Char]34)`n"
      "`t`t`t        )`n"
      "`t`t`t      }`n"
      "`t`t`t      TrackDscEvents $([System.Char]39)Status of Analytic channel for the Microsoft-Windows-Dsc event log provider$([System.Char]39) {`n"
      "`t`t`t        Channel   = $([System.Char]39)Analytic$([System.Char]39)`n"
      "`t`t`t        Status    = $([System.Char]39)Enabled$([System.Char]39)`n"
      "`t`t`t        Ensure    = $([System.Char]39)Present$([System.Char]39)`n"
      "`t`t`t        DependsOn = [System.String[]]@(`n"
      "`t`t`t          $([System.Char]34)[TrackDscEvents]Status of Operational channel for the Microsoft-Windows-Dsc event log provider$([System.Char]34)`n"
      "`t`t`t        )`n"
      "`t`t`t      }`n"
      "`t`t`t      TrackDscEvents $([System.Char]39)Status of Debug channel for the Microsoft-Windows-Dsc event log provider$([System.Char]39) {`n"
      "`t`t`t        Channel   = $([System.Char]39)Debug$([System.Char]39)`n"
      "`t`t`t        Status    = $([System.Char]39)Disabled$([System.Char]39)`n"
      "`t`t`t        Ensure    = $([System.Char]39)Present$([System.Char]39)`n"
      "`t`t`t        DependsOn = [System.String[]]@(`n"
      "`t`t`t          $([System.Char]34)[TrackDscEvents]Status of Analytic channel for the Microsoft-Windows-Dsc event log provider$([System.Char]34)`n"
      "`t`t`t        )`n"
      "`t`t`t      }`n"
      "`t`t`t    #>`n"
      "`t`t`t    #endregion`n"
      "`t`t`t`n"
      "`t`t`t    #region | One-time Generation of New Random %ComputerNames% |`n"
      "`t`t`t    `${Is file with new random %ComputerNames% present at time of MOF compilation} = Test-Path -Path $([System.Char]34)`$Statics\PMs\`${DSC Authoring Station Mgmt Cname} ComputerName.txt$([System.Char]34)`n"
      "`t`t`t    if (-not `${Is file with new random %ComputerNames% present at time of MOF compilation}) {`n"
      "`t`t`t      File $([System.Char]34)New Random ComputerName for primordial Unclustered Hyper-V Host$([System.Char]34) {`n"
      "`t`t`t        DestinationPath = $([System.Char]34)`$Statics\PMs\`${DSC Authoring Station Mgmt Cname} ComputerName.txt$([System.Char]34)`n"
      "`t`t`t        Attributes      = @($([System.Char]39)ReadOnly$([System.Char]39))`n"
      "`t`t`t        Contents        = `$(($([System.Char]39)WIN-$([System.Char]39) + ([System.IO.Path]::GetRandomFileName()) -replace $([System.Char]39)\.$([System.Char]39),$([System.Char]39)$([System.Char]39) -join $([System.Char]39)$([System.Char]39)).ToUpper())`n"
      "`t`t`t        Force           = `$true`n"
      "`t`t`t        Type            = $([System.Char]39)File$([System.Char]39)`n"
      "`t`t`t        Ensure          = $([System.Char]39)Present$([System.Char]39)`n"
      "`t`t`t        DependsOn       = [System.String[]]@(`n"
      "`t`t`t          #$([System.Char]34)[TrackDscEvents]Status of Debug channel for the Microsoft-Windows-Dsc event log provider$([System.Char]34)`n"
      "`t`t`t          $([System.Char]34)[xRegistry]PowerShell 5.1 Transcription 2$([System.Char]34)`n"
      "`t`t`t        )`n"
      "`t`t`t      }`n"
      "`t`t`t    }`n"
      "`t`t`t    #region | Rename Computer and Reboot |`n"
      "`t`t`t    if (`${Is file with new random %ComputerNames% present at time of MOF compilation}) {`n"
      "`t`t`t      Computer $([System.Char]34)New Random ComputerName for primordial Unclustered Hyper-V Host$([System.Char]34) {`n"
      "`t`t`t        Name                  = `$(Get-Content -Path $([System.Char]34)`$Statics\PMs\`${DSC Authoring Station Mgmt Cname} ComputerName.txt$([System.Char]34))`n"
      "`t`t`t        Description           = $([System.Char]39)Description TBD$([System.Char]39)`n"
      "`t`t`t        WorkGroupName         = $([System.Char]39)NoNetwork$([System.Char]39)`n"
      "`t`t`t        DependsOn             = [System.String[]]@(`n"
      "`t`t`t          #$([System.Char]34)[TrackDscEvents]Status of Debug channel for the Microsoft-Windows-Dsc event log provider$([System.Char]34)`n"
      "`t`t`t          $([System.Char]34)[xRegistry]PowerShell 5.1 Transcription 2$([System.Char]34)`n"
      "`t`t`t        )`n"
      "`t`t`t      }`n"
      "`t`t`t      PendingReboot $([System.Char]34)New Random ComputerName for primordial Unclustered Hyper-V Host$([System.Char]34) {`n"
      "`t`t`t        Name                        = $([System.Char]34)Hostname change on `${DSC Authoring Station Mgmt Cname} leads to Pending Reboot$([System.Char]34)`n"
      "`t`t`t        SkipPendingComputerRename   = `$false`n"
      "`t`t`t        SkipCcmClientSDK            = `$false`n"
      "`t`t`t        SkipComponentBasedServicing = `$false`n"
      "`t`t`t        SkipPendingFileRename       = `$false`n"
      "`t`t`t        SkipWindowsUpdate           = `$false`n"
      "`t`t`t        DependsOn                   = [System.String[]]@(`n"
      "`t`t`t          $([System.Char]34)[Computer]New Random ComputerName for primordial Unclustered Hyper-V Host$([System.Char]34)`n"
      "`t`t`t        )`n"
      "`t`t`t      }`n"
      "`t`t`t    }`n"
      "`t`t`t    #endregion`n"
      "`t`t`t    #endregion                            `n"
      "`t`t`t`n"
      "`t`t`t    #region | Essential Directory Structure |`n"
      "`t`t`t    File $([System.Char]39)Epoch_A__PreDocument_Encryption\Wave_00$([System.Char]39) {`n"
      "`t`t`t      DestinationPath = $([System.Char]34)`$MOFs\Epoch_A__PreDocument_Encryption\Wave_00$([System.Char]34)`n"
      "`t`t`t      Force           = `$true`n"
      "`t`t`t      Type            = $([System.Char]39)Directory$([System.Char]39)`n"
      "`t`t`t      Ensure          = $([System.Char]39)Present$([System.Char]39)`n"
      "`t`t`t      DependsOn       = [System.String[]]@(`n"
      "`t`t`t        #$([System.Char]34)[PendingReboot]New Random ComputerName for primordial Unclustered Hyper-V Host$([System.Char]34)`n"
      "`t`t`t        #$([System.Char]34)[TrackDscEvents]Status of Debug channel for the Microsoft-Windows-Dsc event log provider$([System.Char]34)`n"
      "`t`t`t        $([System.Char]34)[xRegistry]PowerShell 5.1 Transcription 2$([System.Char]34)`n"
      "`t`t`t      )`n"
      "`t`t`t    }`n"
      "`t`t`t    `${Dependency Epoch_A__PreDocument_Encryption Wave_00} = [System.String[]]@(`n"
      "`t`t`t      $([System.Char]34)[File]Epoch_A__PreDocument_Encryption\Wave_00$([System.Char]34)`n"
      "`t`t`t    )`n"
      "`t`t`t`n"
      "`t`t`t    File $([System.Char]39)Epoch_B__HvH_with_VMs\Wave_00$([System.Char]39) {`n"
      "`t`t`t      DestinationPath = $([System.Char]34)`$MOFs\Epoch_B__HvH_with_VMs\Wave_00$([System.Char]34)`n"
      "`t`t`t      Force           = `$true`n"
      "`t`t`t      Type            = $([System.Char]39)Directory$([System.Char]39)`n"
      "`t`t`t      Ensure          = $([System.Char]39)Present$([System.Char]39)`n"
      "`t`t`t      DependsOn       = `${Dependency Epoch_A__PreDocument_Encryption Wave_00}`n"
      "`t`t`t    }`n"
      "`t`t`t    `${Dependency Epoch_B__HvH_with_VMs Wave_00} = [System.String[]]@(`n"
      "`t`t`t      $([System.Char]34)[File]Epoch_B__HvH_with_VMs\Wave_00$([System.Char]34)`n"
      "`t`t`t    )`n"
      "`t`t`t`n"
      "`t`t`t    File $([System.Char]39)EarlyShare\Self-Signed Certs$([System.Char]39) {`n"
      "`t`t`t      DestinationPath = $([System.Char]34)`$env:DSC_CFG_ROOT\EarlyShare\Self-Signed Certs$([System.Char]34)`n"
      "`t`t`t      Force           = `$true`n"
      "`t`t`t      Type            = $([System.Char]39)Directory$([System.Char]39)`n"
      "`t`t`t      Ensure          = $([System.Char]39)Present$([System.Char]39)`n"
      "`t`t`t      DependsOn       = `${Dependency Epoch_B__HvH_with_VMs Wave_00}`n"
      "`t`t`t    }`n"
      "`t`t`t    `${Dependency EarlyShare Self-Signed Certs} = [System.String[]]@(`n"
      "`t`t`t      $([System.Char]34)[File]EarlyShare\Self-Signed Certs$([System.Char]34)`n"
      "`t`t`t    )`n"
      "`t`t`t    #endregion`n"
      "`t`t`t`n"
      "`t`t`t    #region | Write MACs of detected non-USB NICs to .txt file |`n"
      "`t`t`t    File $([System.Char]34)Physical Non-Removable PCIe Adapter MACs Directory$([System.Char]34) {`n"
      "`t`t`t      DestinationPath = $([System.Char]34)`$Statics\MaxIP\Physical Non-Removable PCIe Adapter MACs$([System.Char]34)`n"
      "`t`t`t      #Attributes      = @($([System.Char]39)Hidden$([System.Char]39))`n"
      "`t`t`t      Force           = `$true`n"
      "`t`t`t      Type            = $([System.Char]39)Directory$([System.Char]39)`n"
      "`t`t`t      Ensure          = $([System.Char]39)Present$([System.Char]39)`n"
      "`t`t`t      DependsOn       = `${Dependency EarlyShare Self-Signed Certs}`n"
      "`t`t`t    }`n"
      "`t`t`t    `${Dependency Physical Non-Removable PCIe Adapter MACs Directory} = [System.String[]]@(`n"
      "`t`t`t      $([System.Char]34)[File]Physical Non-Removable PCIe Adapter MACs Directory$([System.Char]34)`n"
      "`t`t`t    )`n"
      "`t`t`t    `${Is MaxIP child Directory present at time of MOF compilation} = Test-Path -Path $([System.Char]34)`$Statics\MaxIP\Physical Non-Removable PCIe Adapter MACs$([System.Char]34)`n"
      "`t`t`t    if (-not `${Is MaxIP child Directory present at time of MOF compilation}) {`n"
      "`t`t`t      Get-CimInstance -ClassName $([System.Char]39)Win32_NetworkAdapter$([System.Char]39) $([System.Char]96)`n"
      "`t`t`t      | Where-Object -FilterScript {`$_.PNPDeviceID -cmatch $([System.Char]39)^PCI\\$([System.Char]39)} $([System.Char]96)`n"
      "`t`t`t      | ForEach-Object -Process {Get-NetAdapter -InterfaceDescription `$_.Name} $([System.Char]96)`n"
      "`t`t`t      | Select-Object -ExpandProperty $([System.Char]39)MacAddress$([System.Char]39) -PipelineVariable $([System.Char]39)MacAddress$([System.Char]39) $([System.Char]96)`n"
      "`t`t`t      | ForEach-Object -Process {`n"
      "`t`t`t        `$MacAddrNoHyperLowerCase = (`$MacAddress -replace $([System.Char]39)-$([System.Char]39),$([System.Char]39)$([System.Char]39)).ToLower()`n"
      "`t`t`t        `${Guid Value} = [System.Guid]::NewGuid().Guid`n"
      "`t`t`t        File $([System.Char]34)Write MAC Address to `${Guid Value}.txt File$([System.Char]34) {`n"
      "`t`t`t          DestinationPath = $([System.Char]34)`$Statics\MaxIP\Physical Non-Removable PCIe Adapter MACs\`${Guid Value}.txt$([System.Char]34)`n"
      "`t`t`t          #Attributes      = @($([System.Char]39)Hidden$([System.Char]39),$([System.Char]39)ReadOnly$([System.Char]39))`n"
      "`t`t`t          Attributes      = @($([System.Char]39)ReadOnly$([System.Char]39))`n"
      "`t`t`t          Contents        = `$MacAddrNoHyperLowerCase`n"
      "`t`t`t          Force           = `$false`n"
      "`t`t`t          Type            = $([System.Char]39)File$([System.Char]39)`n"
      "`t`t`t          Ensure          = $([System.Char]39)Present$([System.Char]39)`n"
      "`t`t`t          DependsOn       = `${Dependency Physical Non-Removable PCIe Adapter MACs Directory}`n"
      "`t`t`t        }`n"
      "`t`t`t      }`n"
      "`t`t`t    }`n"
      "`t`t`t    #endregion`n"
      "`t`t`t`n"
      "`t`t`t    #region | Global Cert Signer |`n"
      "`t`t`t    <#`n"
      "`t`t`t      `${Is CertFSOs Directory present at time of MOF compilation} = Test-Path -Path $([System.Char]34)`$env:DSC_CFG_ROOT\EarlyShare\Self-Signed Certs$([System.Char]34)`n"
      "`t`t`t      if (`${Is CertFSOs Directory present at time of MOF compilation}) {`n"
      "`t`t`t        GlobalCertificateSignerSequence0 $([System.Char]39)Global Cert Signer$([System.Char]39) {`n"
      "`t`t`t          FriendlyName      =      [System.String]$([System.Char]39)Global Cert Signer$([System.Char]39)`n"
      "`t`t`t          AltSigAlg         =      [System.Boolean]`$true`n"
      "`t`t`t          Ensure            =      [System.String]$([System.Char]39)Present$([System.Char]39)`n"
      "`t`t`t        }`n"
      "`t`t`t        `${Dependency GlobalCertificateSignerSequence0} = [System.String[]]@(`n"
      "`t`t`t          $([System.Char]34)[GlobalCertificateSignerSequence0]`$($([System.Char]39)Global Cert Signer$([System.Char]39))$([System.Char]34)`n"
      "`t`t`t        )`n"
      "`t`t`t        #region | Document Encryption Certificate for primordial unclustered Hyper-V host |`n"
      "`t`t`t        `${All Certs in Personal LocalMachine Store} = Get-ChildItem -Path $([System.Char]39)Cert:\LocalMachine\My$([System.Char]39) -Recurse`n"
      "`t`t`t        `${Global Certificate Signing Certificate} = `${All Certs in Personal LocalMachine Store} | Where-Object -FilterScript {`n"
      "`t`t`t          `$_.FriendlyName -eq $([System.Char]39)Global Cert Signer$([System.Char]39)`n"
      "`t`t`t        }`n"
      "`t`t`t        if (`$null -ne `${Global Certificate Signing Certificate}) {`n"
      "`t`t`t          GlobalCodeSignerSeq0 $([System.Char]39)Global Code Signer$([System.Char]39) {`n"
      "`t`t`t            FriendlyName      =      [System.String]$([System.Char]39)Global Code Signer$([System.Char]39)`n"
      "`t`t`t            AltSigAlg         =      [System.Boolean]`$true`n"
      "`t`t`t            Ensure            =      [System.String]$([System.Char]39)Present$([System.Char]39)`n"
      "`t`t`t            DependsOn         =      `${Dependency GlobalCertificateSignerSequence0}`n"
      "`t`t`t          }`n"
      "`t`t`t          `${Dependency GlobalCodeSignerSeq0} = [System.String[]]@(`n"
      "`t`t`t            $([System.Char]34)[GlobalCodeSignerSeq0]`$($([System.Char]39)Global Code Signer$([System.Char]39))$([System.Char]34)`n"
      "`t`t`t          )`n"
      "`t`t`t          GlobalCertificateSignerSequence1 $([System.Char]39)Global Cert Signer$([System.Char]39) {`n"
      "`t`t`t            FriendlyName = [System.String]$([System.Char]39)Global Cert Signer$([System.Char]39)`n"
      "`t`t`t            Ensure       = [System.String]$([System.Char]39)Present$([System.Char]39)`n"
      "`t`t`t            DependsOn    = `${Dependency GlobalCertificateSignerSequence0}`n"
      "`t`t`t          }`n"
      "`t`t`t          `${Dependency GlobalCertificateSignerSequence1} = [System.String[]]@(`n"
      "`t`t`t            $([System.Char]34)[GlobalCertificateSignerSequence1]`$($([System.Char]39)Global Cert Signer$([System.Char]39))$([System.Char]34)`n"
      "`t`t`t          )`n"
      "`t`t`t          MofPasswordProtectionSeq0 $([System.Char]34)Encrypt Passwords in MOF for LCM on `${DSC Authoring Station Mgmt Cname}$([System.Char]34) {`n"
      "`t`t`t            FriendlyName      =      [System.String]$([System.Char]34)Encrypt Passwords in MOF for LCM on `${DSC Authoring Station Mgmt Cname}$([System.Char]34)`n"
      "`t`t`t            AltSigAlg         =      [System.Boolean]`$true`n"
      "`t`t`t            Ensure            =      [System.String]$([System.Char]39)Present$([System.Char]39)`n"
      "`t`t`t            DependsOn         =      `${Dependency GlobalCertificateSignerSequence0}`n"
      "`t`t`t          }`n"
      "`t`t`t        }`n"
      "`t`t`t        #endregion`n"
      "`t`t`t      }`n"
      "`t`t`t    #>`n"
      "`t`t`t    #endregion`n"
      "`t`t`t  }`n"
      "`t`t`t}`n"
      "`t`t`t`$HT = @{`n"
      "`t`t`t  InstanceName = `$InstanceName`n"
      "`t`t`t  OutputPath   = `$lcmHT[$([System.Char]39)OutputPath$([System.Char]39)]`n"
      "`t`t`t  Verbose      = `$true`n"
      "`t`t`t}`n"
      "`t`t`t`n"
      "`t`t`tInvoke-Expression -Verbose:`$true -Command $([System.Char]34)`$InstanceName @HT$([System.Char]34)`n"
      "`t`t`tPublish-DscConfiguration -ComputerName $([System.Char]39)localhost$([System.Char]39) -Path `$lcmHT[$([System.Char]39)OutputPath$([System.Char]39)] -Force -Verbose:`$true`n"
      "`t`t`tStart-DscConfiguration -UseExisting -Force -Wait:`$true -Verbose:`$true`n"
      "`t`t"
      #endregion
      {
        $WaveIndex = '00'
        $EpochIndex = 'A'
        $EpochLabel = "PreDocument_Encryption"
        $InstanceName = "Epoch_$($EpochIndex)__$($EpochLabel)__Wave_$($WaveIndex)"
        $LCM_InstanceName = "LCM_" + $InstanceName

        [System.Management.Automation.DscLocalConfigurationManagerAttribute()]
        Configuration $LCM_InstanceName {
          Node 'localhost' {
            Settings {
              ActionAfterReboot              = [System.String]'ContinueConfiguration'
              AllowModuleOverwrite           = [System.Boolean]$true
              ConfigurationMode              = [System.String]'ApplyAndAutoCorrect'
              ConfigurationModeFrequencyMins = [System.UInt32]15
              RefreshFrequencyMins           = [System.UInt32]30
              RebootNodeIfNeeded             = [System.Boolean]$true
              RefreshMode                    = [System.String]'Push'
              StatusRetentionTimeInDays      = [System.UInt32]20
            }
          }
        }
        $lcmHT = @{
          InstanceName = $LCM_InstanceName
          OutputPath   = "$MOFs\Epoch_$($EpochIndex)__$($EpochLabel)\Wave_$WaveIndex"
          Verbose      = $true
        }
        Invoke-Expression -Verbose:$true -Command "$LCM_InstanceName @lcmHT"
        Set-DscLocalConfigurationManager -ComputerName 'localhost' -Path $lcmHT['OutputPath'] -Force

        Configuration $InstanceName {
          #region | Import DSC Resources into the Configuration Document |
          Imp0rt-DscResource -ModuleName 'PSDesiredStateConfiguration'  -ModuleVersion 1.1
          Imp0rt-DscResource -ModuleName 'xPSDesiredStateConfiguration' -ModuleVersion 9.2.2
          # #Imp0rt-DscResource -ModuleName 'AdHocDsc'                     -ModuleVersion 0.77.13.8
          #  Imp0rt-DscResource -ModuleName 'AdHocCertsDsc'                -ModuleVersion
          #  Imp0rt-DscResource -ModuleName 'AdHocNetsDsc'                 -ModuleVersion
          #  Imp0rt-DscResource -ModuleName 'AdHocPkiDsc'                  -ModuleVersion
          #  Imp0rt-DscResource -ModuleName 'AdHocUtilsDsc'                -ModuleVersion
          Imp0rt-DscResource -ModuleName 'ComputerManagementDsc'        -ModuleVersion 10.0.1
          Imp0rt-DscResource -ModuleName 'CertificateDsc'               -ModuleVersion 6.1.0
          #endregion

          Node 'localhost' {
            #region | Strictest Level of Windows PowerShell ScriptBlock and Module Logging |
            xRegistry 'PowerShell 5.1 ScriptBlock Logging' {
              ValueName = 'EnableScriptBlockLogging'
              Key       = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging'
              ValueData = '1'
              ValueType = 'String'
              Force     = $true
              Ensure    = 'Present'

            }
            xRegistry 'PowerShell 5.1 Module Logging' {
              ValueName = 'EnableModuleLogging'
              Key       = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ModuleLogging'
              ValueData = '1'
              ValueType = 'String'
              Force     = $true
              Ensure    = 'Present'
              DependsOn = [System.String[]]@(
                "[xRegistry]PowerShell 5.1 ScriptBlock Logging"
              )
            }
            xRegistry 'PowerShell 5.1 Transcription 1' {
              ValueName = 'EnableTranscribing'
              Key       = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\Transcription'
              ValueData = '1'
              ValueType = 'String'
              Force     = $true
              Ensure    = 'Present'
              DependsOn = [System.String[]]@(
                "[xRegistry]PowerShell 5.1 Module Logging"
              )
            }
            xRegistry 'PowerShell 5.1 Transcription 2' {
              ValueName = 'EnableInvocationHeader'
              Key       = 'HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\Transcription'
              ValueData = '1'
              ValueType = 'String'
              Force     = $true
              Ensure    = 'Present'
              DependsOn = [System.String[]]@(
                "[xRegistry]PowerShell 5.1 Transcription 1"
              )
            }
            #endregion

            #region | Diagnostics-Enable channels in the Microsoft-Windows-Dsc Event Log Provider |
            <#
              TrackDscEvents 'Status of Operational channel for the Microsoft-Windows-Dsc event log provider' {
                Channel   = 'Operational'
                Status    = 'Enabled'
                Ensure    = 'Present'
                DependsOn = [System.String[]]@(
                  "[xRegistry]PowerShell 5.1 Transcription 2"
                )
              }
              TrackDscEvents 'Status of Analytic channel for the Microsoft-Windows-Dsc event log provider' {
                Channel   = 'Analytic'
                Status    = 'Enabled'
                Ensure    = 'Present'
                DependsOn = [System.String[]]@(
                  "[TrackDscEvents]Status of Operational channel for the Microsoft-Windows-Dsc event log provider"
                )
              }
              TrackDscEvents 'Status of Debug channel for the Microsoft-Windows-Dsc event log provider' {
                Channel   = 'Debug'
                Status    = 'Disabled'
                Ensure    = 'Present'
                DependsOn = [System.String[]]@(
                  "[TrackDscEvents]Status of Analytic channel for the Microsoft-Windows-Dsc event log provider"
                )
              }
            #>
            #endregion

            #region | One-time Generation of New Random %ComputerNames% |
            ${Is file with new random %ComputerNames% present at time of MOF compilation} = Test-Path -Path "$Statics\PMs\${DSC Authoring Station Mgmt Cname} ComputerName.txt"
            if (-not ${Is file with new random %ComputerNames% present at time of MOF compilation}) {
              File "New Random ComputerName for primordial Unclustered Hyper-V Host" {
                DestinationPath = "$Statics\PMs\${DSC Authoring Station Mgmt Cname} ComputerName.txt"
                Attributes      = @('ReadOnly')
                Contents        = $(('WIN-' + ([System.IO.Path]::GetRandomFileName()) -replace '\.','' -join '').ToUpper())
                Force           = $true
                Type            = 'File'
                Ensure          = 'Present'
                DependsOn       = [System.String[]]@(
                  #"[TrackDscEvents]Status of Debug channel for the Microsoft-Windows-Dsc event log provider"
                  "[xRegistry]PowerShell 5.1 Transcription 2"
                )
              }
            }
            #region | Rename Computer and Reboot |
            if (${Is file with new random %ComputerNames% present at time of MOF compilation}) {
              Computer "New Random ComputerName for primordial Unclustered Hyper-V Host" {
                Name                  = $(Get-Content -Path "$Statics\PMs\${DSC Authoring Station Mgmt Cname} ComputerName.txt")
                Description           = 'Description TBD'
                WorkGroupName         = 'NoNetwork'
                DependsOn             = [System.String[]]@(
                  #"[TrackDscEvents]Status of Debug channel for the Microsoft-Windows-Dsc event log provider"
                  "[xRegistry]PowerShell 5.1 Transcription 2"
                )
              }
              PendingReboot "New Random ComputerName for primordial Unclustered Hyper-V Host" {
                Name                        = "Hostname change on ${DSC Authoring Station Mgmt Cname} leads to Pending Reboot"
                SkipPendingComputerRename   = $false
                SkipCcmClientSDK            = $false
                SkipComponentBasedServicing = $false
                SkipPendingFileRename       = $false
                SkipWindowsUpdate           = $false
                DependsOn                   = [System.String[]]@(
                  "[Computer]New Random ComputerName for primordial Unclustered Hyper-V Host"
                )
              }
            }
            #endregion
            #endregion                            

            #region | Essential Directory Structure |
            File 'Epoch_A__PreDocument_Encryption\Wave_00' {
              DestinationPath = "$MOFs\Epoch_A__PreDocument_Encryption\Wave_00"
              Force           = $true
              Type            = 'Directory'
              Ensure          = 'Present'
              DependsOn       = [System.String[]]@(
                #"[PendingReboot]New Random ComputerName for primordial Unclustered Hyper-V Host"
                #"[TrackDscEvents]Status of Debug channel for the Microsoft-Windows-Dsc event log provider"
                "[xRegistry]PowerShell 5.1 Transcription 2"
              )
            }
            ${Dependency Epoch_A__PreDocument_Encryption Wave_00} = [System.String[]]@(
              "[File]Epoch_A__PreDocument_Encryption\Wave_00"
            )

            File 'Epoch_B__HvH_with_VMs\Wave_00' {
              DestinationPath = "$MOFs\Epoch_B__HvH_with_VMs\Wave_00"
              Force           = $true
              Type            = 'Directory'
              Ensure          = 'Present'
              DependsOn       = ${Dependency Epoch_A__PreDocument_Encryption Wave_00}
            }
            ${Dependency Epoch_B__HvH_with_VMs Wave_00} = [System.String[]]@(
              "[File]Epoch_B__HvH_with_VMs\Wave_00"
            )

            File 'EarlyShare\Self-Signed Certs' {
              DestinationPath = "$env:DSC_CFG_ROOT\EarlyShare\Self-Signed Certs"
              Force           = $true
              Type            = 'Directory'
              Ensure          = 'Present'
              DependsOn       = ${Dependency Epoch_B__HvH_with_VMs Wave_00}
            }
            ${Dependency EarlyShare Self-Signed Certs} = [System.String[]]@(
              "[File]EarlyShare\Self-Signed Certs"
            )
            #endregion

            #region | Write MACs of detected non-USB NICs to .txt file |
            File "Physical Non-Removable PCIe Adapter MACs Directory" {
              DestinationPath = "$Statics\MaxIP\Physical Non-Removable PCIe Adapter MACs"
              #Attributes      = @('Hidden')
              Force           = $true
              Type            = 'Directory'
              Ensure          = 'Present'
              DependsOn       = ${Dependency EarlyShare Self-Signed Certs}
            }
            ${Dependency Physical Non-Removable PCIe Adapter MACs Directory} = [System.String[]]@(
              "[File]Physical Non-Removable PCIe Adapter MACs Directory"
            )
            ${Is MaxIP child Directory present at time of MOF compilation} = Test-Path -Path "$Statics\MaxIP\Physical Non-Removable PCIe Adapter MACs"
            if (-not ${Is MaxIP child Directory present at time of MOF compilation}) {
              Get-CimInstance -ClassName 'Win32_NetworkAdapter' `
              | Where-Object -FilterScript {$_.PNPDeviceID -cmatch '^PCI\\'} `
              | ForEach-Object -Process {Get-NetAdapter -InterfaceDescription $_.Name} `
              | Select-Object -ExpandProperty 'MacAddress' -PipelineVariable 'MacAddress' `
              | ForEach-Object -Process {
                $MacAddrNoHyperLowerCase = ($MacAddress -replace '-','').ToLower()
                ${Guid Value} = [System.Guid]::NewGuid().Guid
                File "Write MAC Address to ${Guid Value}.txt File" {
                  DestinationPath = "$Statics\MaxIP\Physical Non-Removable PCIe Adapter MACs\${Guid Value}.txt"
                  #Attributes      = @('Hidden','ReadOnly')
                  Attributes      = @('ReadOnly')
                  Contents        = $MacAddrNoHyperLowerCase
                  Force           = $false
                  Type            = 'File'
                  Ensure          = 'Present'
                  DependsOn       = ${Dependency Physical Non-Removable PCIe Adapter MACs Directory}
                }
              }
            }
            #endregion

            #region | Global Cert Signer |
            <#
              ${Is CertFSOs Directory present at time of MOF compilation} = Test-Path -Path "$env:DSC_CFG_ROOT\EarlyShare\Self-Signed Certs"
              if (${Is CertFSOs Directory present at time of MOF compilation}) {
                GlobalCertificateSignerSequence0 'Global Cert Signer' {
                  FriendlyName      =      [System.String]'Global Cert Signer'
                  AltSigAlg         =      [System.Boolean]$true
                  Ensure            =      [System.String]'Present'
                }
                ${Dependency GlobalCertificateSignerSequence0} = [System.String[]]@(
                  "[GlobalCertificateSignerSequence0]$('Global Cert Signer')"
                )
                #region | Document Encryption Certificate for primordial unclustered Hyper-V host |
                ${All Certs in Personal LocalMachine Store} = Get-ChildItem -Path 'Cert:\LocalMachine\My' -Recurse
                ${Global Certificate Signing Certificate} = ${All Certs in Personal LocalMachine Store} | Where-Object -FilterScript {
                  $_.FriendlyName -eq 'Global Cert Signer'
                }
                if ($null -ne ${Global Certificate Signing Certificate}) {
                  GlobalCodeSignerSeq0 'Global Code Signer' {
                    FriendlyName      =      [System.String]'Global Code Signer'
                    AltSigAlg         =      [System.Boolean]$true
                    Ensure            =      [System.String]'Present'
                    DependsOn         =      ${Dependency GlobalCertificateSignerSequence0}
                  }
                  ${Dependency GlobalCodeSignerSeq0} = [System.String[]]@(
                    "[GlobalCodeSignerSeq0]$('Global Code Signer')"
                  )
                  GlobalCertificateSignerSequence1 'Global Cert Signer' {
                    FriendlyName = [System.String]'Global Cert Signer'
                    Ensure       = [System.String]'Present'
                    DependsOn    = ${Dependency GlobalCertificateSignerSequence0}
                  }
                  ${Dependency GlobalCertificateSignerSequence1} = [System.String[]]@(
                    "[GlobalCertificateSignerSequence1]$('Global Cert Signer')"
                  )
                  MofPasswordProtectionSeq0 "Encrypt Passwords in MOF for LCM on ${DSC Authoring Station Mgmt Cname}" {
                    FriendlyName      =      [System.String]"Encrypt Passwords in MOF for LCM on ${DSC Authoring Station Mgmt Cname}"
                    AltSigAlg         =      [System.Boolean]$true
                    Ensure            =      [System.String]'Present'
                    DependsOn         =      ${Dependency GlobalCertificateSignerSequence0}
                  }
                }
                #endregion
              }
            #>
            #endregion
          }
        }
        $HT = @{
          InstanceName = $InstanceName
          OutputPath   = $lcmHT['OutputPath']
          Verbose      = $true
        }

        Invoke-Expression -Verbose:$true -Command "$InstanceName @HT"
        Publish-DscConfiguration -ComputerName 'localhost' -Path $lcmHT['OutputPath'] -Force -Verbose:$true
        Start-DscConfiguration -UseExisting -Force -Wait:$true -Verbose:$true
      } | Out-Null
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\HadeanDscConfigurationDocument.ps1')
        $XmlWriter.WriteString(${File HadeanDscConfigurationDocument.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion

  $XmlWriter.WriteEndElement()
  #endregion

  #region | offlineImage |
  $namespace = "urn:schemas-microsoft-com:cpi"
  $XmlWriter.WriteStartElement('cpi','offlineImage',$namespace)
    $XmlWriter.WriteAttributeString('cpi','source',$null,${offlineImage cpi source})
  $XmlWriter.WriteEndElement()
  #endregion

  $XmlWriter.WriteEndElement()
$XmlWriter.WriteEndDocument()
$XmlWriter.Close()
Remove-Variable -Name 'XmlWriter'
Remove-Variable -Name 'XmlWriterSettings'
#endregion

#region | "___.ps1" Here-String and XML Element |
<#
  ${File ___.ps1 Here-String} = $(

    {

    } | Out-Null
  ) -join ''
    $XmlWriter.WriteStartElement('File')
      $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\___.ps1')
      $XmlWriter.WriteString(${File ___.ps1 Here-String})
    $XmlWriter.WriteEndElement()
#>
#endregion
#region | "___.ps1" Here-String and XML Element |
<#
  ${File ___.ps1 Here-String} = $(

    {

    } | Out-Null
  ) -join ''
    $XmlWriter.WriteStartElement('File')
      $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\___.ps1')
      $XmlWriter.WriteString(${File ___.ps1 Here-String})
    $XmlWriter.WriteEndElement()
#>
#endregion
#region | "___.ps1" Here-String and XML Element |
<#
  ${File ___.ps1 Here-String} = $(

    {

    } | Out-Null
  ) -join ''
    $XmlWriter.WriteStartElement('File')
      $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\___.ps1')
      $XmlWriter.WriteString(${File ___.ps1 Here-String})
    $XmlWriter.WriteEndElement()
#>
#endregion



#region | Set the (wcm:action="add") or (wcm:action="remove") attributes on the relevant elements | Loop through the 'Order' elements |
#  code $XmlFile.FullName
$XmlDocument = [System.Xml.XmlDocument](Get-Content -Path $XmlFile.FullName -Raw)

$HT = @{
  Xml       = $XmlDocument
  Namespace = @{un = 'urn:schemas-microsoft-com:unattend'}
  XPath     = "/un:unattend/un:settings[@pass='windowsPE']/un:component[@name='Microsoft-Windows-Setup']/un:RunSynchronous/un:RunSynchronousCommand"
}
${RunSynchronousCommand Set} = Select-Xml @HT # | Select-Object -ExpandProperty 'Node'
for ($i = 0; $i -lt ${RunSynchronousCommand Set}.Count; $i++) {
  [System.String]$OrderIndex = $i + 1
  ${RunSynchronousCommand} = ${RunSynchronousCommand Set}[$i] | Select-Object -ExpandProperty 'Node'
  ${RunSynchronousCommand}.SetAttribute('action', $wcmNamespaceUrl, 'add') | Out-Null
  ${RunSynchronousCommand}.Order = $OrderIndex
}

$HT = @{
  Xml       = $XmlDocument
  Namespace = @{un = 'urn:schemas-microsoft-com:unattend'}
  XPath     = "/un:unattend/un:settings[@pass='specialize']/un:component[@name='Microsoft-Windows-Deployment']/un:RunSynchronous/un:RunSynchronousCommand"
}
${RunSynchronousCommand Set} = Select-Xml @HT # | Select-Object -ExpandProperty 'Node'
for ($i = 0; $i -lt ${RunSynchronousCommand Set}.Count; $i++) {
  [System.String]$OrderIndex = $i + 1
  ${RunSynchronousCommand} = ${RunSynchronousCommand Set}[$i] | Select-Object -ExpandProperty 'Node'
  ${RunSynchronousCommand}.SetAttribute('action', $wcmNamespaceUrl, 'add') | Out-Null
  ${RunSynchronousCommand}.Order = $OrderIndex
}

$HT = @{
  Xml       = $XmlDocument
  Namespace = @{un = 'urn:schemas-microsoft-com:unattend'}
  XPath     = "/un:unattend/un:settings[@pass='oobeSystem']/un:component[@name='Microsoft-Windows-Shell-Setup']/un:FirstLogonCommands/un:SynchronousCommand"
}
${SynchronousCommand Set} = Select-Xml @HT # | Select-Object -ExpandProperty 'Node'
for ($i = 0; $i -lt ${SynchronousCommand Set}.Count; $i++) {
  [System.String]$OrderIndex = $i + 1
  ${SynchronousCommand} = ${SynchronousCommand Set}[$i] | Select-Object -ExpandProperty 'Node'
  ${SynchronousCommand}.SetAttribute('action', $wcmNamespaceUrl, 'add') | Out-Null
  ${SynchronousCommand}.Order = $OrderIndex
}

$HT = @{
  Xml       = $XmlDocument
  Namespace = @{un = 'urn:schemas-microsoft-com:unattend'}
  XPath     = '//un:LocalAccount'
}
${LocalAccount Node} = (Select-Xml @HT).Node
${LocalAccount Node}.SetAttribute('action', $wcmNamespaceUrl, 'add') | Out-Null
#endregion

#region | Save to removable external storage media |
$XmlDocument.ChildNodes[0].Encoding = $null

# autounattend.xml belongs on $OSDeploy but will put in 'output\$FolderFQN\usb1' for the moment
# Rename current autounattend.xml, if present |
if (Test-Path -Path "$usb1\autounattend.xml") {
  Rename-Item -Path "$usb1\autounattend.xml" -NewName "autounattend-$(Call-DateVar).xml"
}
# # Save XML file to bootable media
# #$XmlDocument.Save("$OSDeploy\autounattend.xml")
if ($null -ne $usb1) {
  $XmlDocument.Save("$usb1\autounattend.xml")
  $XmlDocument.Save("$PSScriptRoot\..\..\output\$FolderFQN\usb1\autounattend.xml")
}

if ($null -ne $usb0) {
  if (Test-Path -Path "$usb0\autounattend.xml") {Rename-Item -Path "$usb0\autounattend.xml" -NewName "autounattend-$(Call-DateVar).xml"}
  $XmlDocument.Save("$usb0\autounattend.xml")
}

$IsPresent = Test-Path -Path "$PSScriptRoot\..\..\..\.CommonItems\usb0\autounattend.xml"
if (-not $IsPresent) {
  $XmlDocument.Save("$PSScriptRoot\..\..\..\.CommonItems\usb0\autounattend.xml")
} else {
  Rename-Item -Path "$PSScriptRoot\..\..\..\.CommonItems\usb0\autounattend.xml" -NewName "autounattend-$(Call-DateVar).xml"
  $XmlDocument.Save("$PSScriptRoot\..\..\..\.CommonItems\usb0\autounattend.xml")
}
#endregion