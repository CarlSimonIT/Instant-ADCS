#Requires -Version 5.1
#Requires -PSEdition Desktop

Set-StrictMode -Version 'Latest'

<# Announcements! |
  VBScript is undergoing deprecation:
  start msedge.exe 'https://techcommunity.microsoft.com/blog/windows-itpro-blog/vbscript-deprecation-timelines-and-next-steps/4148301'

  Guide for converting code from VBScript to Windows PowerShell:  
  start msedge.exe 'https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-powershell-1.0/ee221101(v=msdn.10)'
#>

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

$__DirectoryForDscConfigs = '_Omicron'


${AdHocCertsDsc Version} = '0.0.2'
${AdHocNetsDsc Version}  = '0.0.2'
${AdHocPkiDsc Version}   = '0.0.2'
${AdHocUtilsDsc Version} = '0.0.2'

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

  #region | Extensions |
  $XmlWriter.WriteStartElement('Extensions','https://schneegans.de/windows/unattend-generator/')
    #region | ExtractScript here-string for PowerShell scriptblock |
    ${ExtractScript Here-String} = $(
      "`n"
      "`t`t`tparam (`n"
      "`t`t`t  [System.Xml.XmlDocument]`$XmlDocument`n"
      "`t`t`t)`n"
      "`t`t`t`n"
      "`t`t`tforeach (`$file in `$XmlDocument.unattend.Extensions.File) {`n"
      "`t`t`t  `$path = [System.Environment]::ExpandEnvironmentVariables(`n"
      "`t`t`t    `$file.GetAttribute($([System.Char]39)path$([System.Char]39))`n"
      "`t`t`t  )`n"
      "`t`t`t  mkdir -Path (`$path | Split-Path -Parent) -ErrorAction $([System.Char]39)SilentlyContinue$([System.Char]39)`n"
      "`t`t`t  `$content = `$file.InnerText.Trim()`n"
      "`t`t`t  if (`$file.GetAttribute($([System.Char]39)transformation$([System.Char]39)) -ieq $([System.Char]39)Base64$([System.Char]39)) {`n"
      "`t`t`t    [System.IO.File]::WriteAllBytes(`$path, [System.Convert]::FromBase64String(`$content))`n"
      "`t`t`t  }`n"
      "`t`t`t  else {`n"
      "`t`t`t    `$encoding = switch ([System.IO.Path]::GetExtension(`$path)) {`n"
      "`t`t`t      {`$_ -in $([System.Char]39).ps1$([System.Char]39),$([System.Char]39).xml$([System.Char]39)}       {[System.Text.Encoding]::UTF8}`n"
      "`t`t`t      {`$_ -in $([System.Char]39).reg$([System.Char]39),$([System.Char]39).vbs$([System.Char]39),$([System.Char]39).js$([System.Char]39)} {[System.Text.UnicodeEncoding]::New(`$false,`$true)}`n"
      "`t`t`t      default                      {[System.Text.Encoding]::Default}`n"
      "`t`t`t    }`n"
      "`t`t`t    [System.IO.File]::WriteAllBytes(`$path,(`$encoding.GetPreamble() + `$encoding.GetBytes(`$content)))`n"
      "`t`t`t  }`n"
      "`t`t`t}`n"
      "`t`t"

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
            [System.IO.File]::WriteAllBytes($path, [System.Convert]::FromBase64String($content))
          }
          else {
            $encoding = switch ([System.IO.Path]::GetExtension($path)) {
              {$_ -in '.ps1','.xml'}       {[System.Text.Encoding]::UTF8}
              {$_ -in '.reg','.vbs','.js'} {[System.Text.UnicodeEncoding]::New($false,$true)}
              default                      {[System.Text.Encoding]::Default}
            }
            [System.IO.File]::WriteAllBytes($path,($encoding.GetPreamble() + $encoding.GetBytes($content)))
          }
        }
      } | Out-Null
    ) -join ''
    $XmlWriter.WriteElementString('ExtractScript',${ExtractScript Here-String})
    #endregion

    #region | TaskbarLayoutModification.xml Here-String |
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

    #region | UnlockStartLayout.vbs Here-String |
    ${File UnlockStartLayout.vbs Here-String} = $(
      "`n"
      "`t`t`tHKU = &H80000003`n"
      "`t`t`tSet reg = GetObject($([System.Char]34)winmgmts://./root/default:StdRegProv$([System.Char]34))`n"
      "`t`t`tSet fso = CreateObject($([System.Char]34)Scripting.FileSystemObject$([System.Char]34))`n"
      "`n"
      "`t`t`tIf reg.EnumKey(HKU, $([System.Char]34)$([System.Char]34), sids) = 0 Then`n"
      "`t`t`t  If Not IsNull(sids) Then`n"
      "`t`t`t    For Each sid In sids`n"
      "`t`t`t      key = sid + $([System.Char]34)\Software\Policies\Microsoft\Windows\Explorer$([System.Char]34)`n"
      "`t`t`t      name = $([System.Char]34)LockedStartLayout$([System.Char]34)`n"
      "`t`t`t      If reg.GetDWORDValue(HKU, key, name, existing) = 0 Then`n"
      "`t`t`t        reg.SetDWORDValue HKU, key, name, 0`n"
      "`t`t`t      End If`n"
      "`t`t`t    Next`n"
      "`t`t`t  End If`n"
      "`t`t`tEnd If`n"
      "`t`t"
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\UnlockStartLayout.vbs')
        $XmlWriter.WriteString(${File UnlockStartLayout.vbs Here-String})
      $XmlWriter.WriteEndElement()
    #endregion

    #region | UnlockStartLayout.xml Here-String |
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
              ${XmlWriter UnlockStartLayout.xml}.WriteStartElement('Subscription')
                ${XmlWriter UnlockStartLayout.xml}.WriteStartElement('QueryList')
                  ${XmlWriter UnlockStartLayout.xml}.WriteStartElement('Query')
                    ${XmlWriter UnlockStartLayout.xml}.WriteAttributeString('Id','0')
                    ${XmlWriter UnlockStartLayout.xml}.WriteAttributeString('Path','Application')
                    ${XmlWriter UnlockStartLayout.xml}.WriteStartElement('Select')
                      ${XmlWriter UnlockStartLayout.xml}.WriteAttributeString('Path','Application')
                      ${XmlWriter UnlockStartLayout.xml}.WriteString("*[System[Provider[@Name='UnattendGenerator'] and EventID=1]]")
                    ${XmlWriter UnlockStartLayout.xml}.WriteEndElement()
                  ${XmlWriter UnlockStartLayout.xml}.WriteEndElement()
                ${XmlWriter UnlockStartLayout.xml}.WriteEndElement()
              ${XmlWriter UnlockStartLayout.xml}.WriteEndElement()
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

    #region | DO NOT pause Windows Update |
    #region | PauseWindowsUpdate.ps1 Here-String |
    ${File PauseWindowsUpdate.ps1 Here-String} = $(
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
    ) -join ''
    #endregion
      #$XmlWriter.WriteStartElement('File')
      #  $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\PauseWindowsUpdate.ps1')
      #  $XmlWriter.WriteString(${File PauseWindowsUpdate.ps1 Here-String})
      #$XmlWriter.WriteEndElement()

    #region | PauseWindowsUpdate.xml Here-String |
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
              ${XmlWriter PauseWindowsUpdate.xml}.WriteElementString('Arguments',"-Command $([System.Char]34)gc -raw -LiteralPath $([System.Char]39)C:\Windows\Setup\Scripts\PauseWindowsUpdate.ps1$([System.Char]39) | iex -Verbose$([System.Char]34)")
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
    #endregion
      #$XmlWriter.WriteStartElement('File')
      #  $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\PauseWindowsUpdate.xml')
      #  $XmlWriter.WriteString(${File PauseWindowsUpdate.xml Here-String})
      #$XmlWriter.WriteEndElement()
    #endregion

    #region | ShowAllTrayIcons.ps1 Here-String |
    ${File ShowAllTrayIcons.ps1 Here-String} = $(
      "`n"
      "`t`t`t`$RawXml = Get-Content -LiteralPath $([System.Char]34)C:\Windows\Setup\Scripts\ShowAllTrayIcons.xml$([System.Char]34) -Raw`n"
      "`t`t`tRegister-ScheduledTask -TaskName $([System.Char]39)ShowAllTrayIcons$([System.Char]39) -Xml `$RawXml`n"
      "`t`t"
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\ShowAllTrayIcons.ps1')
        $XmlWriter.WriteString(${File ShowAllTrayIcons.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion

    #region | ShowAllTrayIcons.xml Here-String |
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
                "-WindowStyle Hidden "
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

    #region | ShowAllTrayIcons.vbs Here-String |
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

    #region | SetStartPins.ps1 Here-String |
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
      "`t`t`t`$key = $([System.Char]39)Registry::HKLM\SOFTWARE\Microsoft\PolicyManager\current\device$([System.Char]39)$([System.Char]10)"
      "`t`t`tNew-Item -Path `$key -ItemType $([System.Char]39)Directory$([System.Char]39) -ErrorAction $([System.Char]39)SilentlyContinue$([System.Char]39)$([System.Char]10)"
      "`t`t`t`$key = $([System.Char]39)Registry::HKLM\SOFTWARE\Microsoft\PolicyManager\current\device\Start$([System.Char]39)$([System.Char]10)"
      "`t`t`tNew-Item -Path `$key -ItemType $([System.Char]39)Directory$([System.Char]39) -ErrorAction $([System.Char]39)SilentlyContinue$([System.Char]39)$([System.Char]10)"
      "`t`t`tSet-ItemProperty -LiteralPath `$key -Name $([System.Char]39)ConfigureStartPins$([System.Char]39) -Value `$json -Type $([System.Char]39)String$([System.Char]39)$([System.Char]10)"
      "`t`t"
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

    #region | SetColorTheme.ps1 Here-String |
    ${File SetColorTheme.ps1 Here-String} = $(
      "`n"
      "`t`t`t`$lightThemeSystem = 0;`n"
      "`t`t`t`$lightThemeApps = 0;`n"
      "`t`t`t`$accentColorOnStart = 0;`n"
      "`t`t`t`$enableTransparency = 0;`n"
      "`t`t`t`$htmlAccentColor = $([System.Char]39)#0078D4$([System.Char]39);`n"
      "`t`t`t& {`n"
      "`t`t`t  `$params = @{`n"
      "`t`t`t    LiteralPath = $([System.Char]39)Registry::HKCU\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize$([System.Char]39);`n"
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
      "`t`t`t  Set-ItemProperty -LiteralPath $([System.Char]39)Registry::HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent$([System.Char]39) -Name $([System.Char]39)StartColorMenu$([System.Char]39) -Value( ConvertTo-DWord -Color `$accentColor ) -Type $([System.Char]39)DWord$([System.Char]39) -Force;`n"
      "`t`t`t  Set-ItemProperty -LiteralPath $([System.Char]39)Registry::HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent$([System.Char]39) -Name $([System.Char]39)AccentColorMenu$([System.Char]39) -Value( ConvertTo-DWord -Color `$accentColor ) -Type $([System.Char]39)DWord$([System.Char]39) -Force;`n"
      "`t`t`t  Set-ItemProperty -LiteralPath $([System.Char]39)Registry::HKCU\Software\Microsoft\Windows\DWM$([System.Char]39) -Name $([System.Char]39)AccentColor$([System.Char]39) -Value( ConvertTo-DWord -Color `$accentColor ) -Type $([System.Char]39)DWord$([System.Char]39) -Force;`n"
      "`t`t`t  `$params = @{`n"
      "`t`t`t    LiteralPath = $([System.Char]39)Registry::HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent$([System.Char]39);`n"
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
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\SetColorTheme.ps1')
        $XmlWriter.WriteAttributeString('transformation','Text')
        $XmlWriter.WriteString(${File SetColorTheme.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion

    #region | SetWallpaper.ps1 Here-String |
    ${File SetWallpaper.ps1 Here-String} = $(
      "`n"
      "`t`t`tAdd-Type -TypeDefinition $([System.Char]39)`n"
      "`t`t`t  using System.Drawing;`n"
      "`t`t`t  using System.Runtime.InteropServices;`n"
      "`t`t`t  public static class WallpaperSetter {`n"
      "`t`t`t    [DllImport($([System.Char]34)user32.dll$([System.Char]34))]`n"
      "`t`t`t    private static extern bool SetSysColors(`n"
      "`t`t`t      int cElements, `n"
      "`t`t`t      int[] lpaElements,`n"
      "`t`t`t      int[] lpaRgbValues`n"
      "`t`t`t    );`n"
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
      "`t`t`tfunction Set-WallpaperColor {`n"
      "`t`t`t  param(`n"
      "`t`t`t    [string]`n"
      "`t`t`t    `$HtmlColor`n"
      "`t`t`t  );`n"
      "`t`t`t  `$color = [System.Drawing.ColorTranslator]::FromHtml( `$HtmlColor );`n"
      "`t`t`t  [WallpaperSetter]::SetDesktopBackground( `$color );`n"
      "`t`t`t  Set-ItemProperty -Path $([System.Char]39)Registry::HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Wallpapers$([System.Char]39) -Name $([System.Char]39)BackgroundType$([System.Char]39) -Type $([System.Char]39)DWord$([System.Char]39) -Value 1 -Force;`n"
      "`t`t`t  Set-ItemProperty -Path $([System.Char]39)Registry::HKCU\Control Panel\Desktop$([System.Char]39) -Name $([System.Char]39)WallPaper$([System.Char]39) -Type $([System.Char]39)String$([System.Char]39) -Value $([System.Char]39)$([System.Char]39) -Force;`n"
      "`t`t`t  Set-ItemProperty -Path $([System.Char]39)Registry::HKCU\Control Panel\Colors$([System.Char]39) -Name $([System.Char]39)Background$([System.Char]39) -Type $([System.Char]39)String$([System.Char]39) -Value $([System.Char]34)`$(`$color.R) `$(`$color.G) `$(`$color.B)$([System.Char]34) -Force;`n"
      "`t`t`t}`n"
      "`t`t`tfunction Set-WallpaperImage {`n"
      "`t`t`t  param(`n"
      "`t`t`t    [string]`n"
      "`t`t`t    `$LiteralPath`n"
      "`t`t`t  );`n"
      "`t`t`t  if( `$LiteralPath | Test-Path ) {`n"
      "`t`t`t    [WallpaperSetter]::SetDesktopImage( `$LiteralPath );`n"
      "`t`t`t    Set-ItemProperty -Path $([System.Char]39)Registry::HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Wallpapers$([System.Char]39) -Name $([System.Char]39)BackgroundType$([System.Char]39) -Type $([System.Char]39)DWord$([System.Char]39) -Value 0 -Force;`n"
      "`t`t`t    Set-ItemProperty -Path $([System.Char]39)Registry::HKCU\Control Panel\Desktop$([System.Char]39) -Name $([System.Char]39)WallPaper$([System.Char]39) -Type $([System.Char]39)String$([System.Char]39) -Value `$LiteralPath -Force;`n"
      "`t`t`t  } else {`n"
      "`t`t`t    $([System.Char]34)Cannot use $([System.Char]39)`$LiteralPath$([System.Char]39) as a desktop wallpaper because that file does not exist.$([System.Char]34);`n"
      "`t`t`t  }`n"
      "`t`t`t}`n"
      "`t`t`tSet-WallpaperColor -HtmlColor $([System.Char]39)#0A0F0F$([System.Char]39);`n"
      "`t`t"
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\SetWallpaper.ps1')
        $XmlWriter.WriteString(${File SetWallpaper.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion

    #region | HideTaskBar.ps1 Here-String |
    ${File HideTaskBar.ps1 Here-String} = $(
      "`n"
      "`t`t`t#& {`n"
      "`t`t`t#  `$p = $([System.Char]34)HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3$([System.Char]34)`n"
      "`t`t`t#  `$v = (Get-ItemProperty -Path `$p).Settings`n"
      "`t`t`t#  `$v[8] = 0x7b`n"
      "`t`t`t#  Set-ItemProperty -Path `$p -Name $([System.Char]39)Settings$([System.Char]39) -Value `$v`n"
      "`t`t`t#}`n"
      "`t`t`t# restart explorer.exe`n"
      "`t`t`t#Get-Process -Name explorer | Stop-Process -Force | Start-Process -FilePath `$env:windir\explorer.exe`n"
      "`t`t"
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\HideTaskBar.ps1')
        $XmlWriter.WriteString(${File HideTaskBar.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion

    #region | GetLockScreenImage.ps1 Here-String | Doesn't actually set the lockscreen image |
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
      "`t`t`t  `$found = Join-Path @HT`n"
      "`t`t`t  if (`$found) {`n"
      "`t`t`t    return [System.IO.File]::ReadAllBytes(`$found)`n"
      "`t`t`t  }`n"
      "`t`t`t}`n"
      "`t`t`t# $([System.Char]39)Cannot find any files that match pattern.$([System.Char]39) | Write-Warning`n"
      "`t`t`treturn [System.IO.File]::ReadAllBytes($([System.Char]34)$__DirectoryForDscConfigs\OfflineDSC\lockscreen.png$([System.Char]34))`n"
      "`t`t"
    ) -join ''
    $XmlWriter.WriteStartElement('File')
      $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\GetLockScreenImage.ps1')
      $XmlWriter.WriteString(${File GetLockScreenImage.ps1 Here-String})
    $XmlWriter.WriteEndElement()        
    #endregion

    #region | unattend_A00.ps1 Here-String and XML Element |
    ${File unattend_A00.ps1 Here-String} = $(
      "`n"
      "`t`t`tWrite-Host -Object $([System.Char]34)Script A00 to run in the system context, before user accounts are created.$([System.Char]34)`n"
      "`t`t"
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\unattend_A00.ps1')
        $XmlWriter.WriteString(${File unattend_A00.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion

    #region | unattend_A01.ps1 Here-String and XML Element |
    ${File unattend_A01.ps1 Here-String} = $(
      "`n"
      "`t`t`tWrite-Host -Object $([System.Char]34)Script A01 to run in the system context, before user accounts are created.$([System.Char]34)`n"
      "`t`t`t`n"
      "`t`t"
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\unattend_A01.ps1')
        $XmlWriter.WriteString(${File unattend_A01.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion

    #region | unattend_A02.ps1 Here-String and XML Element |
    ${File unattend_A02.ps1 Here-String} = $(
      "`n"
      "`t`t`tWrite-Host -Object $([System.Char]34)Script A02 to run in the system context, before user accounts are created.$([System.Char]34)`n"
      "`t`t`t`n"
      "`t`t"
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\unattend_A02.ps1')
        $XmlWriter.WriteString(${File unattend_A02.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion

    #region | unattend_B00.ps1 Here-String and XML Element |
    ${File unattend_B00.ps1 Here-String} = $(
      "`n"
      "`t`t`tWrite-Host -Object $([System.Char]34)Script B00 to run when the first user logs on after Windows has been installed.$([System.Char]34)`n"
      "`t`t`tWrite-Host -Object $([System.Char]34)First user to log on is typically an administrator. Script would run with elevated privileges.$([System.Char]34)`n"
      "`t`t`t`$path = $([System.Char]34)`$env:UserProfile\Unattend_B00 Canary.txt$([System.Char]34); `$dir = try {Get-Item -Path `$path -ErrorAction $([System.Char]39)Stop$([System.Char]39)} catch {New-Item -Path `$path -ItemType $([System.Char]39)Directory$([System.Char]39) -Force}`n"
      "`t`t`t# Install Visual Studio Code`n"
      "`t`t`t`$VSCodeExe = Get-ChildItem -Path $([System.Char]34)`$usb0\cfg\installs\Visual Studio Code\##$([System.Char]34) -Filter $([System.Char]34)VSCodeSetup-x64-*.exe$([System.Char]34) -Recurse | Sort-Object LastWriteTime | Select-Object -Last 1`n"
      "`t`t`tStart-Process -FilePath `$VSCodeExe.FullName -ArgumentList @($([System.Char]34)/VERYSILENT$([System.Char]34),$([System.Char]34)/MERGETASKS=!runcode$([System.Char]34))`n"
      "`t`t`t# Install OneDrive`n"
      "`t`t`tStart-Process -FilePath $([System.Char]34)`$usb0\cfg\installs\OneDrive\##\OneDriveSetup.exe$([System.Char]34) -ArgumentList @($([System.Char]34)/silent$([System.Char]34),$([System.Char]34)/allusers$([System.Char]34))`n"
      "`t`t`t`n"
      "`t`t"
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\unattend_B00.ps1')
        $XmlWriter.WriteString(${File unattend_B00.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion

    #region | unattend_C00.ps1 Here-String and XML Element |
    ${File unattend_C00.ps1 Here-String} = $(
      "`n"
      "`t`t`tWrite-Host -Object $([System.Char]34)Script unattend_C00.ps1 run whenever a user, any user, logs on for the first time$([System.Char]34)`n"
      "`t`t`t#`n"
      "`t`t`t# Multitasking Reduction`n"
      "`t`t`t## Uncheck the box at ms-settings:multitasking, Snap windows, $([System.Char]34)When I snap a window, suggest what I can snap next to it$([System.Char]34)`n"
      "`t`t`t`$RegItem = try {`n"
      "`t`t`t  Get-ItemProperty -Path $([System.Char]34)HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34) -Name $([System.Char]39)SnapAssist$([System.Char]39) -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  New-ItemProperty -Path $([System.Char]34)HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34) -Name $([System.Char]39)SnapAssist$([System.Char]39) -Type $([System.Char]39)DWORD$([System.Char]39) -Value $([System.Char]39)0$([System.Char]39)`n"
      "`t`t`t}`n"
      "`t`t`t#`n"
      "`t`t`t## Uncheck the box at ms-settings:multitasking, Snap windows, $([System.Char]34)Show snap layouts when I hover over a window$([System.Char]39)s maximize button$([System.Char]34)`n"
      "`t`t`t`$RegItem = try {`n"
      "`t`t`t  Get-ItemProperty -Path $([System.Char]34)HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34) -Name $([System.Char]39)EnableSnapAssistFlyout$([System.Char]39) -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  New-ItemProperty -Path $([System.Char]34)HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34) -Name $([System.Char]39)EnableSnapAssistFlyout$([System.Char]39) -Type $([System.Char]39)DWORD$([System.Char]39) -Value $([System.Char]39)0$([System.Char]39)`n"
      "`t`t`t}`n"
      "`t`t`t#`n"
      "`t`t`t## Uncheck the box at ms-settings:multitasking, Snap windows, $([System.Char]34)Show snap layouts when I drag a window to the top of my screen$([System.Char]34)`n"
      "`t`t`t`$RegItem = try {`n"
      "`t`t`t  Get-ItemProperty -Path $([System.Char]34)HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34) -Name $([System.Char]39)EnableSnapBar$([System.Char]39) -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  New-ItemProperty -Path $([System.Char]34)HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34) -Name $([System.Char]39)EnableSnapBar$([System.Char]39) -Type $([System.Char]39)DWORD$([System.Char]39) -Value $([System.Char]39)0$([System.Char]39)`n"
      "`t`t`t}`n"
      "`t`t`t#`n"
      "`t`t`t## Uncheck the box at ms-settings:multitasking, Snap windows, $([System.Char]34)Show my snapped windows when I hover over taskbar apps, in Task View, and when I press Alt+Tab$([System.Char]34)`n"
      "`t`t`t`$RegItem = try {`n"
      "`t`t`t  Get-ItemProperty -Path $([System.Char]34)HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34) -Name $([System.Char]39)EnableTaskGroups$([System.Char]39) -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  New-ItemProperty -Path $([System.Char]34)HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34) -Name $([System.Char]39)EnableTaskGroups$([System.Char]39) -Type $([System.Char]39)DWORD$([System.Char]39) -Value $([System.Char]39)0$([System.Char]39)`n"
      "`t`t`t}`n"
      "`t`t`t#`n"
      "`t`t`t## Uncheck the box at ms-settings:multitasking, Snap windows, $([System.Char]34)When I drag a window, let me snap it without dragging all the way to the screen edge$([System.Char]34)`n"
      "`t`t`t`$RegItem = try {`n"
      "`t`t`t  Get-ItemProperty -Path $([System.Char]34)HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34) -Name $([System.Char]39)DITest$([System.Char]39) -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  New-ItemProperty -Path $([System.Char]34)HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34) -Name $([System.Char]39)DITest$([System.Char]39) -Type $([System.Char]39)DWORD$([System.Char]39) -Value $([System.Char]39)0$([System.Char]39)`n"
      "`t`t`t}`n"
      "`t`t`t#`n"
      "`t`t`t## Adjust dropdown box at ms-settings:multitasking, $([System.Char]34)Show tabs from apps when snapping or pressing Alt+Tab$([System.Char]34) to $([System.Char]34)Don$([System.Char]39)t show tabs$([System.Char]34)`n"
      "`t`t`t`$RegItem = try {`n"
      "`t`t`t  Get-ItemProperty -Path $([System.Char]34)HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34) -Name $([System.Char]39)MultiTaskingAltTabFilter$([System.Char]39) -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  New-ItemProperty -Path $([System.Char]34)HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34) -Name $([System.Char]39)MultiTaskingAltTabFilter$([System.Char]39) -Type $([System.Char]39)DWORD$([System.Char]39) -Value $([System.Char]39)3$([System.Char]39)`n"
      "`t`t`t}`n"
      "`t`t`t#`n"
      "`t`t`t## Adjust dropdown box at ms-settings:multitasking, $([System.Char]34)Show tabs from apps when snapping or pressing Alt+Tab$([System.Char]34) to $([System.Char]34)Don$([System.Char]39)t show tabs$([System.Char]34)`n"
      "`t`t`t`$RegItem = try {`n"
      "`t`t`t  Get-ItemProperty -Path $([System.Char]34)HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34) -Name $([System.Char]39)MultiTaskingAltTabFilter$([System.Char]39) -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t} catch {`n"
      "`t`t`t  New-ItemProperty -Path $([System.Char]34)HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34) -Name $([System.Char]39)MultiTaskingAltTabFilter$([System.Char]39) -Type $([System.Char]39)DWORD$([System.Char]39) -Value $([System.Char]39)3$([System.Char]39)`n"
      "`t`t`t}`n"
      "`t`t`t#`n"
      "`t`t`t`$RunMRU = $([System.Char]34)HKU:\`$((Get-LocalUser `${explorer.exe Owner} -ErrorAction Stop).sid.value)\Software\Microsoft\Windows\CurrentVersion\Explorer\RunMRU$([System.Char]34)`n"
      "`t`t`t#`$RunMRU = $([System.Char]34)HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\RunMRU$([System.Char]34)`n"
      "`t`t`t`$AllNumLett = (0..25 | % {[System.Char]([System.Int32][System.Char]$([System.Char]39)z$([System.Char]39) - `$_)}) -join $([System.Char]39)$([System.Char]39)`n"
      "`t`t`t#`n"
      "`t`t`t`$path = `$RunMRU; try {Get-Item -Path `$RunMRU -Name $([System.Char]39)MRUList$([System.Char]39) -ErrorAction $([System.Char]39)Stop$([System.Char]39)} catch {New-Item -Path `$RunMRU -Name $([System.Char]39)MRUList$([System.Char]39) -Force}`n"
      "`t`t`t#New-Item -Path `$RunMRU -Name MRUList`n"
      "`t`t`tSet-ItemProperty -Name MRUList -Path `$RunMRU -Value $([System.Char]34)`$AllNumLett$([System.Char]34)`n"
      "`t`t`t#`n"
      "`t`t`t`$RunMRU_HT = [System.Collections.Hashtable]@{`n"
      "`t`t`t  a = $([System.Char]39)ms-settings:windowsupdate$([System.Char]39)`n"
      "`t`t`t  b = $([System.Char]39)ms-settings:display$([System.Char]39)`n"
      "`t`t`t  c = $([System.Char]39)ms-settings:easeofaccess-mousepointer$([System.Char]39)`n"
      "`t`t`t  d = $([System.Char]39)%PMs%$([System.Char]39)`n"
      "`t`t`t  e = $([System.Char]39)ms-settings:personalization-colors$([System.Char]39)`n"
      "`t`t`t  f = $([System.Char]39)cmd.exe /c powershell.exe; Start pwsh -Verb RunAs$([System.Char]39)`n"
      "`t`t`t  g = $([System.Char]39)cmd.exe /c powershell.exe; Start-process PowerShell.exe -Verb RunAs$([System.Char]39)`n"
      #"`t`t`t  h = $([System.Char]39)diskmgmt.msc$([System.Char]39)`n"
      #"`t`t`t  i = $([System.Char]39)msedge /inprivate onedrive.live.com/login$([System.Char]39)`n"
      #"`t`t`t  j = $([System.Char]39)ms-windows-store:$([System.Char]39)`n"
      "`t`t`t  k = $([System.Char]39)ms-settings:taskbar$([System.Char]39)`n"
      "`t`t`t  l = $([System.Char]39)shutdown -p$([System.Char]39)`n"
      "`t`t`t  m = $([System.Char]39)control.exe /Name Microsoft.CredentialManager$([System.Char]39)`n"
      "`t`t`t  n = $([System.Char]39)ms-settings:about$([System.Char]39)`n"
      "`t`t`t  o = $([System.Char]39)appwiz.cpl$([System.Char]39)`n"
      #"`t`t`t  p = $([System.Char]39)%ProgramData%$([System.Char]39)`n"
      "`t`t`t  q = $([System.Char]39)windowsdefender://coreisolation/$([System.Char]39)`n"
      "`t`t`t  r = $([System.Char]39)windowsdefender://securityprocessor/$([System.Char]39)`n"
      "`t`t`t  s = $([System.Char]39)ms-settings:accounts$([System.Char]39)`n"
      "`t`t`t  t = $([System.Char]39)ms-settings:defaultapps$([System.Char]39)`n"
      #"`t`t`t  u = $([System.Char]39)shutdown /r /t 0$([System.Char]39)`n"
      #"`t`t`t  v = $([System.Char]39)mstsc.exe /v:WIN-2MCMGCEOJCS /admin /w:3456 /h:1944$([System.Char]39)`n"
      "`t`t`t  w = $([System.Char]39)taskschd.msc$([System.Char]39)`n"
      "`t`t`t  x = $([System.Char]39)eventvwr.msc$([System.Char]39)`n"
      "`t`t`t  y = $([System.Char]39)chrome /incognito https://mysignins.microsoft.com/security-info$([System.Char]39)`n"
      "`t`t`t  z = $([System.Char]39)$([System.Char]34)%ProgramFiles%\Microsoft OneDrive\OneDrive.exe$([System.Char]34) /reset$([System.Char]39)`n"
      "`t`t`t}`n"
      "`t`t`t#`n"
      "`t`t`tforeach (`$Ea in `$RunMRU_HT.GetEnumerator() | Write-Output) {`n"
      "`t`t`t  Set-ItemProperty -Name `$Ea.Name -Value `$Ea.Value -Path `$RunMRU`n"
      "`t`t`t}`n"
      "`t`t`tforeach (`$Ea in `$RunMRU_HT.GetEnumerator() | Write-Output) {`n"
      "`t`t`t  Get-ItemProperty -Name `$Ea.Name -Path `$RunMRU`n"
      "`t`t`t}`n"
      "`t`t`t# Hide Chat - THIS IS BOMBING OUT. Remove from Specialized |`n"
      "`t`t`tSet-ItemProperty -Path $([System.Char]34)HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34) -Name $([System.Char]39)TaskbarMn$([System.Char]39) -Value $([System.Char]39)0$([System.Char]39)`n"
      "`t`t"
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\unattend_C00.ps1')
        $XmlWriter.WriteString(${File unattend_C00.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion

    #region | unattend_D00.ps1 Here-Strings and XML Element |
    ${File unattend_D00.ps1 Here-String} = $(
      "`n"
      "`t`t`tNew-Item -Path $([System.Char]34)Registry::HKU\DefaultUser\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Modules\GlobalSettings\Sizer$([System.Char]34) -Name $([System.Char]39)PageSpaceControlSizer$([System.Char]39) -Force -Verbose`n"
      "`t`t"
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\unattend_D00.ps1')
        $XmlWriter.WriteString(${File unattend_D00.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion

    #region | unattend_D01.ps1 Here-String and XML Element |
    ${File unattend_D01.ps1 Here-String} = $(
      "`n"
      "`t`t`tNew-ItemProperty -LiteralPath $([System.Char]34)Registry::HKU\DefaultUser\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Modules\GlobalSettings\Sizer$([System.Char]34) -Name $([System.Char]39)PageSpaceControlSizer$([System.Char]39) -Type $([System.Char]39)Binary$([System.Char]39) -Value ([byte[]]([System.String]::Format($([System.Char]34)0x{0:x}$([System.Char]34),160),[System.String]::Format($([System.Char]34)0x{0:x}$([System.Char]34),0),[System.String]::Format($([System.Char]34)0x{0:x}$([System.Char]34),0),[System.String]::Format($([System.Char]34)0x{0:x}$([System.Char]34),0),[System.String]::Format($([System.Char]34)0x{0:x}$([System.Char]34),0),[System.String]::Format($([System.Char]34)0x{0:x}$([System.Char]34),0),[System.String]::Format($([System.Char]34)0x{0:x}$([System.Char]34),0),[System.String]::Format($([System.Char]34)0x{0:x}$([System.Char]34),0),[System.String]::Format($([System.Char]34)0x{0:x}$([System.Char]34),0),[System.String]::Format($([System.Char]34)0x{0:x}$([System.Char]34),0),[System.String]::Format($([System.Char]34)0x{0:x}$([System.Char]34),0),[System.String]::Format($([System.Char]34)0x{0:x}$([System.Char]34),0),[System.String]::Format($([System.Char]34)0x{0:x}$([System.Char]34),82),[System.String]::Format($([System.Char]34)0x{0:x}$([System.Char]34),2),[System.String]::Format($([System.Char]34)0x{0:x}$([System.Char]34),0),[System.String]::Format($([System.Char]34)0x{0:x}$([System.Char]34),0))) -Force -Verbose`n"
      "`t`t"
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\unattend_D01.ps1')
        $XmlWriter.WriteString(${File unattend_D01.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion

    #region | unattend_D02.ps1 Here-String and XML Element |
    ${File unattend_D02.ps1 Here-String} = $(
      "`n"
      "`t`t`t# Always underline access keys when available: `n"
      "`t`t`tSet-ItemProperty -LiteralPath $([System.Char]34)Registry::HKU\DefaultUser\Control Panel\Accessibility\Keyboard Preference$([System.Char]34) -Name $([System.Char]39)On$([System.Char]39) -Value 1 -Verbose`n"
      "`t`t"
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\unattend_D02.ps1')
        $XmlWriter.WriteString(${File unattend_D02.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion

    #region | unattend_D04.ps1 Here-String and XML Element |
    ${File unattend_D04.ps1 Here-String} = $(
      "`n"
      #"`t`t`tNew-ItemProperty -LiteralPath $([System.Char]34)Registry::HKU\DefaultUser\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34) -Name TaskbarAl -PropertyType DWord -Value $([System.Char]34)0x0$([System.Char]34) -Verbose`n"
      "`t`t`tSet-ItemProperty -LiteralPath $([System.Char]34)Registry::HKU\DefaultUser\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34) -Name $([System.Char]39)ShowTaskViewButton$([System.Char]39) -Type DWORD -Value $([System.Char]34)0x0$([System.Char]34) -Force -Verbose`n"
      "`t`t"
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\unattend_D04.ps1')
        $XmlWriter.WriteString(${File unattend_D04.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion

    #region | Specialize.ps1 Here-String | A-Scripts |
    ${File Specialize.ps1 Here-String} = $(
      "`n"
      "`t`t`t`$SpecializeScriptBlocks = `$(`n"
      "`t`t`t  { # Execution policy is configured much earlier within the $([System.Char]39)ExtractScript$([System.Char]39) scriptblock? |`n"
      "`t`t`t    Set-ExecutionPolicy -Scope $([System.Char]39)LocalMachine$([System.Char]39) -ExecutionPolicy $([System.Char]39)RemoteSigned$([System.Char]39) -Force`n"
      "`t`t`t  }`n"
      "`t`t`t  { # Explicitly DISABLE the $([System.Char]34)Force audit policy subcategory settings to override audit policy category settings$([System.Char]34) policy setting |`n"
      "`t`t`t    # This project applies policy settings specific to audit policy through Group Policy Objects.`n"
      "`t`t`t    # Reference: $([System.Char]39)https://learn.microsoft.com/en-us/troubleshoot/windows-server/windows-security/security-auditing-settings-not-applied-when-deploy-domain-based-policy#symptoms$([System.Char]39)`n"
      "`t`t`t    `$HT = @{`n"
      "`t`t`t      Path  = $([System.Char]39)HKLM:\SYSTEM\CurrentControlSet\Control\Lsa$([System.Char]39)`n"
      "`t`t`t      Name  = $([System.Char]39)SCENoApplyLegacyAuditPolicy$([System.Char]39)`n"
      "`t`t`t      Value = $([System.Char]39)0$([System.Char]39)`n"
      "`t`t`t    }`n"
      "`t`t`t    Set-ItemProperty @HT`n"
      "`t`t`t  }`n"
      "`t`t`t  { # Save to variable the volume letters of the external storage media |`n"
      "`t`t`t    # Save to variable the volume letter of the external storage containing application installation files, VHDX files, and OS images |`n"
      "`t`t`t    `${Samsung 256GB Disk Blue} = Get-Disk | Where-Object -FilterScript {`n"
      "`t`t`t      `$_.FriendlyName -eq    $([System.Char]34)Samsung Flash Drive FIT$([System.Char]34)              -and $([System.Char]96)`n"
      "`t`t`t      `$_.UniqueId     -match [Regex]::Escape($([System.Char]34)USBSTOR\DISK&VEN_SAMSUNG&PROD_FLASH_DRIVE_FIT&REV_1100\0330123070003679&0$([System.Char]34)) -and $([System.Char]96)`n"
      "`t`t`t      `$_.SerialNumber -eq    $([System.Char]34)AA00000000000489$([System.Char]34)`n"
      "`t`t`t    }`n"
      "`t`t`t    if (-not (`$null -eq `${Samsung 256GB Disk Blue})) {`n"
      "`t`t`t      `${Samsung 256GB Partition Blue} = Get-Partition -DiskNumber `${Samsung 256GB Disk Blue}.Number | Select-Object -First 1`n"
      "`t`t`t      `$usb0 = [System.String]`${Samsung 256GB Partition Blue}.DriveLetter + $([System.Char]34):$([System.Char]34)`n"
      "`t`t`t    }`n"
      "`t`t`t    # Save to variable the volume letter of the external storage containing DSC files.`n"
      "`t`t`t    `${PNY 128GB Disk Black} = Get-Disk | Where-Object -FilterScript {`n"
      "`t`t`t      `$_.FriendlyName   -eq      $([System.Char]34)PNY USB 3.2.1 FD$([System.Char]34)              -and $([System.Char]96)`n"
      "`t`t`t      `$_.UniqueId       -match   [Regex]::Escape($([System.Char]34)USBSTOR\DISK&VEN_PNY&PROD_USB_3.2.1_FD&REV_PMAP\071C52B89D513C23&0$([System.Char]34)) -and $([System.Char]96)`n"
      "`t`t`t      `$_.SerialNumber   -eq      $([System.Char]34)037C12C35020$([System.Char]34)`n"
      "`t`t`t    }`n"
      "`t`t`t    if (-not (`$null -eq `${PNY 128GB Disk Black})) {`n"
      "`t`t`t      `${PNY 128GB Partition Black} = Get-Partition -DiskNumber `${PNY 128GB Disk Black}.Number | Select-Object -First 1`n"
      "`t`t`t      `$usb1 = [System.String]`${PNY 128GB Partition Black}.DriveLetter + $([System.Char]39):$([System.Char]39)`n"
      "`t`t`t    }`n"
      "`t`t`t   # Copy the All Users All Hosts profile.ps1 file from external storage to local drive.`n"
      "`t`t`t   `$HT = @{`n"
      "`t`t`t     Path        = $([System.Char]34)`$usb1\OfflineDSC\profiles\5.1\AUAH\profile.ps1$([System.Char]34)`n"
      "`t`t`t     Destination = $([System.Char]34)`$env:WinDir\System32\WindowsPowerShell\v1.0\profile.ps1$([System.Char]34)`n"
      "`t`t`t     Force       = `$true`n"
      "`t`t`t   }`n"
      "`t`t`t   Copy-Item @HT`n"
      "`t`t`t  }`n"
      "`t`t`t  { # DSC fails if the WSMan protocol isn$([System.Char]39)t configured to transmit a sufficiently large $([System.Char]39)envelope$([System.Char]39) |`n"
      "`t`t`t    Set-Item -Path $([System.Char]39)WSMan:\localhost\MaxEnvelopeSizeKb$([System.Char]39) -Value $([System.Char]39)24576$([System.Char]39) -Force`n"
      "`t`t`t  }`n"
      "`t`t`t  { # Set a system-level environment variable for the OfflineDSC directory as well. Helps prevent errors from propagating when loading profile.ps1 fails `n"
      "`t`t`t    `${04f1in3 path} = $([System.Char]34)$__DirectoryForDscConfigs\OfflineDSC$([System.Char]34)`n"
      "`t`t`t  }`n"
      "`t`t`t  { # One-time system-level Environment Variable definitions: `n"
      "`t`t`t    `${04f1in3 path} = $([System.Char]34)$__DirectoryForDscConfigs\OfflineDSC$([System.Char]34)`n"
      "`t`t`t    `${HKLM Sess Mgr Env} = $([System.Char]39)HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Environment$([System.Char]39)`n"
      "`t`t`t    `$HT = @{`n"
      "`t`t`t      $([System.Char]39)DSC_CFG_ROOT$([System.Char]39)   = $([System.Char]34)$__DirectoryForDscConfigs$([System.Char]34)`n"
      "`t`t`t      $([System.Char]39)04f1in3$([System.Char]39)        = `${04f1in3 path}`n"
      "`t`t`t      $([System.Char]39)SystemModules$([System.Char]39)  = $([System.Char]34)`$env:WinDir\System32\WindowsPowerShell\v1.0\Modules$([System.Char]34)`n"
      "`t`t`t      $([System.Char]39)SysMods$([System.Char]39)        = $([System.Char]34)`$env:WinDir\System32\WindowsPowerShell\v1.0\Modules$([System.Char]34)`n"
      "`t`t`t      $([System.Char]39)SMs$([System.Char]39)            = $([System.Char]34)`$env:WinDir\System32\WindowsPowerShell\v1.0\Modules$([System.Char]34)`n"
      "`t`t`t      $([System.Char]39)ProgramModules$([System.Char]39) = $([System.Char]34)`$env:ProgramFiles\WindowsPowerShell\Modules$([System.Char]34)`n"
      "`t`t`t      $([System.Char]39)ProgMods$([System.Char]39)       = $([System.Char]34)`$env:ProgramFiles\WindowsPowerShell\Modules$([System.Char]34)`n"
      "`t`t`t      $([System.Char]39)PMs$([System.Char]39)            = $([System.Char]34)`$env:ProgramFiles\WindowsPowerShell\Modules$([System.Char]34)`n"
      "`t`t`t    }`n"
      "`t`t`t    `$DictionaryEntrySet = `$HT.GetEnumerator() | Write-Output`n"
      "`t`t`t    foreach (`$DictionaryEntry in `$DictionaryEntrySet) {`n"
      "`t`t`t      try `n"
      "`t`t`t      {`n"
      "`t`t`t        Get-ItemProperty -Path `${HKLM Sess Mgr Env} -Name `$DictionaryEntry.Name -ErrorAction $([System.Char]39)Stop$([System.Char]39) | Out-Null`n"
      "`t`t`t      } `n"
      "`t`t`t      catch `n"
      "`t`t`t      {`n"
      "`t`t`t        New-ItemProperty -Path `${HKLM Sess Mgr Env} -Name `$DictionaryEntry.Name -Value `$DictionaryEntry.Value | Out-Null`n"
      "`t`t`t      }`n"
      "`t`t`t    }`n"
      #"`t`t`t  }`n"
      #"`t`t`t  { # Save to variable the volume letters of the external storage media |`n"
      "`t`t`t    # Save to variable the volume letter of the external storage containing application installation files, VHDX files, and OS images |`n"
      "`t`t`t    `${Samsung 256GB Disk Blue} = Get-Disk | Where-Object -FilterScript {`n"
      "`t`t`t      `$_.FriendlyName -eq    $([System.Char]34)Samsung Flash Drive FIT$([System.Char]34)              -and $([System.Char]96)`n"
      "`t`t`t      `$_.UniqueId     -match [Regex]::Escape($([System.Char]34)USBSTOR\DISK&VEN_SAMSUNG&PROD_FLASH_DRIVE_FIT&REV_1100\0330123070003679&0$([System.Char]34)) -and $([System.Char]96)`n"
      "`t`t`t      `$_.SerialNumber -eq    $([System.Char]34)AA00000000000489$([System.Char]34)`n"
      "`t`t`t    }`n"
      "`t`t`t    if (-not (`$null -eq `${Samsung 256GB Disk Blue})) {`n"
      "`t`t`t      `${Samsung 256GB Partition Blue} = Get-Partition -DiskNumber `${Samsung 256GB Disk Blue}.Number | Select-Object -First 1`n"
      "`t`t`t      `$usb0 = [System.String]`${Samsung 256GB Partition Blue}.DriveLetter + $([System.Char]34):$([System.Char]34)`n"
      "`t`t`t    }`n"
      "`t`t`t    # Save to variable the volume letter of the external storage containing DSC files.`n"
      "`t`t`t    `${PNY 128GB Disk Black} = Get-Disk | Where-Object -FilterScript {`n"
      "`t`t`t      `$_.FriendlyName   -eq      $([System.Char]34)PNY USB 3.2.1 FD$([System.Char]34)              -and $([System.Char]96)`n"
      "`t`t`t      `$_.UniqueId       -match   [Regex]::Escape($([System.Char]34)USBSTOR\DISK&VEN_PNY&PROD_USB_3.2.1_FD&REV_PMAP\071C52B89D513C23&0$([System.Char]34)) -and $([System.Char]96)`n"
      "`t`t`t      `$_.SerialNumber   -eq      $([System.Char]34)037C12C35020$([System.Char]34)`n"
      "`t`t`t    }`n"
      "`t`t`t    if (-not (`$null -eq `${PNY 128GB Disk Black})) {`n"
      "`t`t`t      `${PNY 128GB Partition Black} = Get-Partition -DiskNumber `${PNY 128GB Disk Black}.Number | Select-Object -First 1`n"
      "`t`t`t      `$usb1 = [System.String]`${PNY 128GB Partition Black}.DriveLetter + $([System.Char]39):$([System.Char]39)`n"
      "`t`t`t    }`n"
      "`t`t`t    # Copy files of DSC structural and environmental data from external storage to local drive: `n"
      "`t`t`t    `$dir = try {`n"
      "`t`t`t      Get-Item -Path $([System.Char]34)$__DirectoryForDscConfigs$([System.Char]34) -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t    } `n"
      "`t`t`t    catch {`n"
      "`t`t`t      New-Item -Path $([System.Char]34)$__DirectoryForDscConfigs$([System.Char]34) -ItemType $([System.Char]39)Directory$([System.Char]39) -Force`n"
      "`t`t`t    }`n"
      "`t`t`t    Copy-Item -Path $([System.Char]34)`$usb1\OfflineDSC$([System.Char]34) -Destination `$dir.FullName -Recurse`n"
      "`t`t`t  }`n"

      "`t`t`t  { # Im not sure whether the variables within profile.ps1 will load `n"
      "`t`t`t    # Save to variable the volume letter of the external storage containing application installation files, VHDX files, and OS images |`n"
      "`t`t`t    `${Samsung 256GB Disk Blue} = Get-Disk | Where-Object -FilterScript {`n"
      "`t`t`t      `$_.FriendlyName -eq    $([System.Char]34)Samsung Flash Drive FIT$([System.Char]34)              -and $([System.Char]96)`n"
      "`t`t`t      `$_.UniqueId     -match [Regex]::Escape($([System.Char]34)USBSTOR\DISK&VEN_SAMSUNG&PROD_FLASH_DRIVE_FIT&REV_1100\0330123070003679&0$([System.Char]34)) -and $([System.Char]96)`n"
      "`t`t`t      `$_.SerialNumber -eq    $([System.Char]34)AA00000000000489$([System.Char]34)`n"
      "`t`t`t    }`n"
      "`t`t`t    if (-not (`$null -eq `${Samsung 256GB Disk Blue})) {`n"
      "`t`t`t      `${Samsung 256GB Partition Blue} = Get-Partition -DiskNumber `${Samsung 256GB Disk Blue}.Number | Select-Object -First 1`n"
      "`t`t`t      `$usb0 = [System.String]`${Samsung 256GB Partition Blue}.DriveLetter + $([System.Char]34):$([System.Char]34)`n"
      "`t`t`t    }`n"
      "`t`t`t    # PSPKI is required by 1 or more DSC Resources in the custom DSC Resource modules ($([System.Char]39)CertFragments$([System.Char]39) and $([System.Char]39)AdHocDsc$([System.Char]39)) that I authored.`n"
      "`t`t`t    #Expand-Archive -Path $([System.Char]34)`$usb0\cfg\installs\Modules\5.1\PSPKI.zip$([System.Char]34) -DestinationPath $([System.Char]34)`$env:ProgramFiles\WindowsPowerShell\Modules$([System.Char]34)`n"
      "`t`t`t    #Expand-Archive -Path $([System.Char]34)`$usb0\cfg\Preboots\dsc0\Modules\CertFragments.zip$([System.Char]34) -DestinationPath $([System.Char]34)`$env:ProgramFiles\WindowsPowerShell\Modules$([System.Char]34)`n"
      "`t`t`t    # Just extract all Windows PowerShell non-DSC Resource modules`n"
      "`t`t`t    Get-ChildItem -Path $([System.Char]34)`$usb0\cfg\installs\Modules\5.1$([System.Char]34) -Filter $([System.Char]34)*.zip$([System.Char]34) -PipelineVariable $([System.Char]39)file$([System.Char]39) | ForEach-Object -Process {Expand-Archive -Path `$file.FullName -DestinationPath $([System.Char]34)`$env:ProgramFiles\WindowsPowerShell\Modules$([System.Char]34) -Verbose -Force}`n"
      "`t`t`t    #Expand-Archive -Path $([System.Char]34)`$usb0\cfg\Preboots\dsc0\Modules\AdHocDsc.zip$([System.Char]34) -DestinationPath $([System.Char]34)`$env:ProgramFiles\WindowsPowerShell\Modules$([System.Char]34)`n"
      "`t`t`t    # Just extract all DSC Resource modules`n"
      "`t`t`t    Get-ChildItem -Path $([System.Char]34)`$usb0\cfg\Preboots\dsc0\Modules$([System.Char]34) -Filter $([System.Char]34)*.zip$([System.Char]34) -PipelineVariable $([System.Char]39)file$([System.Char]39) | ForEach-Object -Process {Expand-Archive -Path `$file.FullName -DestinationPath $([System.Char]34)`$env:ProgramFiles\WindowsPowerShell\Modules$([System.Char]34) -Verbose -Force}`n"
      "`t`t`t    # CredentialManager is required for the `${Define ConfigurationData Variable} scriptblock to not produce an error.`n"
      "`t`t`t    #Expand-Archive -Path $([System.Char]34)`$usb0\cfg\installs\Modules\5.1\CredentialManager.zip$([System.Char]34) -Destination $([System.Char]34)`$env:ProgramFiles\WindowsPowerShell\Modules$([System.Char]34)`n"
      "`t`t`t  }`n"

      "`t`t`t  { # unattend_A00.ps1 is executed in System context and during Specialize pass |`n"
      "`t`t`t    #    `$unattend_A00 = Get-Content -LiteralPath $([System.Char]39)C:\Windows\Setup\Scripts\unattend_A00.ps1$([System.Char]39) -Raw`n"
      "`t`t`t    #    Invoke-Expression -Command `$unattend_A00 -Verbose`n"
      "`t`t`t    Get-Content -LiteralPath $([System.Char]39)C:\Windows\Setup\Scripts\unattend_A00.ps1$([System.Char]39) -Raw | Invoke-Expression -Verbose`n"
      "`t`t`t    # & $([System.Char]39)C:\Windows\Setup\Scripts\unattend_A00.ps1$([System.Char]39)`n"
      "`t`t`t  }`n"
      "`t`t`t  { # unattend_A01.ps1 is executed in System context and during Specialize pass |`n"
      "`t`t`t    #  `$unattend_A01 = Get-Content -LiteralPath $([System.Char]39)C:\Windows\Setup\Scripts\unattend_A01.ps1$([System.Char]39) -Raw`n"
      "`t`t`t    #  Invoke-Expression -Command `$unattend_A01 -Verbose`n"
      "`t`t`t    Get-Content -LiteralPath $([System.Char]39)C:\Windows\Setup\Scripts\unattend_A01.ps1$([System.Char]39) -Raw | Invoke-Expression -Verbose`n"
      "`t`t`t    # & $([System.Char]39)C:\Windows\Setup\Scripts\unattend_A01.ps1$([System.Char]39)`n"
      "`t`t`t  }`n"
      "`t`t`t  { # unattend_A02.ps1 is executed in System context and during Specialize pass |`n"
      "`t`t`t    #  `$unattend_A02 = Get-Content -LiteralPath $([System.Char]39)C:\Windows\Setup\Scripts\unattend_A02.ps1$([System.Char]39) -Raw`n"
      "`t`t`t    #  Invoke-Expression -Command `$unattend_A02 -Verbose`n"
      "`t`t`t    Get-Content -LiteralPath $([System.Char]39)C:\Windows\Setup\Scripts\unattend_A02.ps1$([System.Char]39) -Raw | Invoke-Expression -Verbose`n"
      "`t`t`t    # & $([System.Char]39)C:\Windows\Setup\Scripts\unattend_A02.ps1$([System.Char]39)`n"
      "`t`t`t  }`n"

      "`t`t`t  { # Unlimited password length |`n"
      "`t`t`t    net.exe accounts /maxpwage:UNLIMITED`n"
      "`t`t`t  }`n"
      "`t`t`t  { # allow very long paths in the file system |`n"
      "`t`t`t    reg.exe add $([System.Char]34)HKLM\SYSTEM\CurrentControlSet\Control\FileSystem$([System.Char]34) /v LongPathsEnabled /t REG_DWORD /d 1 /f`n"
      "`t`t`t  }`n"

      "`t`t`t  {`n"
      "`t`t`t    reg.exe add $([System.Char]34)HKLM\Software\Policies\Microsoft\Windows\CloudContent$([System.Char]34) /v $([System.Char]34)DisableCloudOptimizedContent$([System.Char]34) /t REG_DWORD /d 1 /f`n"
      "`t`t`t    [System.Diagnostics.EventLog]::CreateEventSource($([System.Char]39)UnattendGenerator$([System.Char]39), $([System.Char]39)Application$([System.Char]39))`n"
      "`t`t`t  }`n"
      "`t`t`t  {`n"
      "`t`t`t    `$HT = @{`n"
      "`t`t`t      TaskName = $([System.Char]39)UnlockStartLayout$([System.Char]39)`n"
      "`t`t`t      Xml      = `$(Get-Content -LiteralPath $([System.Char]39)C:\Windows\Setup\Scripts\UnlockStartLayout.xml$([System.Char]39) -Raw)`n"
      "`t`t`t      Verbose  = `$true`n"
      "`t`t`t    }`n"
      "`t`t`t    Register-ScheduledTask @HT`n"
      "`t`t`t  }`n"

      "`t`t`t  { # Audit Policy |`n"
      "`t`t`t    auditpol.exe /set /subcategory:$([System.Char]34){0CCE922B-69AE-11D9-BED3-505054503030}$([System.Char]34) /success:enable /failure:enable`n"
      "`t`t`t  }`n"
      "`t`t`t  { # Audit Policy? |`n"
      "`t`t`t    reg.exe add $([System.Char]34)HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System\Audit$([System.Char]34) /v ProcessCreationIncludeCmdLine_Enabled /t REG_DWORD /d 1 /f`n"
      "`t`t`t  }`n"
      "`t`t`t  { # Display highly detailed status messages | gpedit.msc com adm sys |`n"
      "`t`t`t    try {`n"
      "`t`t`t      Get-ItemProperty -Path $([System.Char]34)HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System$([System.Char]34) -Name $([System.Char]39)VerboseStatus$([System.Char]39) -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t    } `n"
      "`t`t`t    catch {`n"
      "`t`t`t      New-ItemProperty -Path $([System.Char]34)HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System$([System.Char]34) -Name $([System.Char]39)VerboseStatus$([System.Char]39) -Type $([System.Char]39)DWORD$([System.Char]39) -Value $([System.Char]39)1$([System.Char]39)`n"
      "`t`t`t    } `n"
      "`t`t`t  }`n"

      "`t`t`t  { # Set Start Pins |`n"
      "`t`t`t    & $([System.Char]39)C:\Windows\Setup\Scripts\SetStartPins.ps1$([System.Char]39)`n"
      "`t`t`t    # Get-Content -LiteralPath $([System.Char]39)C:\Windows\Setup\Scripts\SetStartPins.ps1$([System.Char]39) -Raw | Invoke-Expression`n"
      "`t`t`t  }`n"
      "`t`t`t  { # Misc Graphicals |`n"
      "`t`t`t    Set-ItemProperty -LiteralPath $([System.Char]34)Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\ControlAnimations$([System.Char]34) -Name $([System.Char]39)DefaultValue$([System.Char]39) -Value 0 -Type $([System.Char]39)DWord$([System.Char]39) -Force -Verbose`n"
      "`t`t`t    Set-ItemProperty -LiteralPath $([System.Char]34)Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\AnimateMinMax$([System.Char]34) -Name $([System.Char]39)DefaultValue$([System.Char]39) -Value 0 -Type $([System.Char]39)DWord$([System.Char]39) -Force -Verbose`n"
      "`t`t`t    Set-ItemProperty -LiteralPath $([System.Char]34)Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\TaskbarAnimations$([System.Char]34) -Name $([System.Char]39)DefaultValue$([System.Char]39) -Value 0 -Type $([System.Char]39)DWord$([System.Char]39) -Force -Verbose`n"
      "`t`t`t    Set-ItemProperty -LiteralPath $([System.Char]34)Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\DWMAeroPeekEnabled$([System.Char]34) -Name $([System.Char]39)DefaultValue$([System.Char]39) -Value 0 -Type $([System.Char]39)DWord$([System.Char]39) -Force -Verbose`n"
      "`t`t`t    Set-ItemProperty -LiteralPath $([System.Char]34)Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\MenuAnimation$([System.Char]34) -Name $([System.Char]39)DefaultValue$([System.Char]39) -Value 0 -Type $([System.Char]39)DWord$([System.Char]39) -Force -Verbose`n"
      "`t`t`t    Set-ItemProperty -LiteralPath $([System.Char]34)Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\TooltipAnimation$([System.Char]34) -Name $([System.Char]39)DefaultValue$([System.Char]39) -Value 0 -Type $([System.Char]39)DWord$([System.Char]39) -Force -Verbose`n"
      "`t`t`t    Set-ItemProperty -LiteralPath $([System.Char]34)Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\SelectionFade$([System.Char]34) -Name $([System.Char]39)DefaultValue$([System.Char]39) -Value 0 -Type $([System.Char]39)DWord$([System.Char]39) -Force -Verbose`n"
      "`t`t`t    Set-ItemProperty -LiteralPath $([System.Char]34)Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\DWMSaveThumbnailEnabled$([System.Char]34) -Name $([System.Char]39)DefaultValue$([System.Char]39) -Value 0 -Type $([System.Char]39)DWord$([System.Char]39) -Force -Verbose`n"
      "`t`t`t    Set-ItemProperty -LiteralPath $([System.Char]34)Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\CursorShadow$([System.Char]34) -Name $([System.Char]39)DefaultValue$([System.Char]39) -Value 0 -Type $([System.Char]39)DWord$([System.Char]39) -Force -Verbose`n"
      "`t`t`t    Set-ItemProperty -LiteralPath $([System.Char]34)Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\ListviewShadow$([System.Char]34) -Name $([System.Char]39)DefaultValue$([System.Char]39) -Value 0 -Type $([System.Char]39)DWord$([System.Char]39) -Force -Verbose`n"
      "`t`t`t    Set-ItemProperty -LiteralPath $([System.Char]34)Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\ThumbnailsOrIcon$([System.Char]34) -Name $([System.Char]39)DefaultValue$([System.Char]39) -Value 0 -Type $([System.Char]39)DWord$([System.Char]39) -Force -Verbose`n"
      "`t`t`t    Set-ItemProperty -LiteralPath $([System.Char]34)Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\ListviewAlphaSelect$([System.Char]34) -Name $([System.Char]39)DefaultValue$([System.Char]39) -Value 0 -Type $([System.Char]39)DWord$([System.Char]39) -Force -Verbose`n"
      "`t`t`t    Set-ItemProperty -LiteralPath $([System.Char]34)Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\DragFullWindows$([System.Char]34) -Name $([System.Char]39)DefaultValue$([System.Char]39) -Value 0 -Type $([System.Char]39)DWord$([System.Char]39) -Force -Verbose`n"
      "`t`t`t    Set-ItemProperty -LiteralPath $([System.Char]34)Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\ComboBoxAnimation$([System.Char]34) -Name $([System.Char]39)DefaultValue$([System.Char]39) -Value 0 -Type $([System.Char]39)DWord$([System.Char]39) -Force -Verbose`n"
      "`t`t`t    Set-ItemProperty -LiteralPath $([System.Char]34)Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\FontSmoothing$([System.Char]34) -Name $([System.Char]39)DefaultValue$([System.Char]39) -Value 0 -Type $([System.Char]39)DWord$([System.Char]39) -Force -Verbose`n"
      "`t`t`t    Set-ItemProperty -LiteralPath $([System.Char]34)Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\ListBoxSmoothScrolling$([System.Char]34) -Name $([System.Char]39)DefaultValue$([System.Char]39) -Value 0 -Type $([System.Char]39)DWord$([System.Char]39) -Force -Verbose`n"
      "`t`t`t    Set-ItemProperty -LiteralPath $([System.Char]34)Registry::HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects\DropShadow$([System.Char]34) -Name $([System.Char]39)DefaultValue$([System.Char]39) -Value 0 -Type $([System.Char]39)DWord$([System.Char]39) -Force -Verbose`n"
      "`t`t`t  }`n"

      "`t`t`t  {`n"
      "`t`t`t    reg.exe add $([System.Char]34)HKLM\Software\Microsoft\Windows\CurrentVersion\Policies\System$([System.Char]34) /v $([System.Char]34)DisableAutomaticRestartSignOn$([System.Char]34) /t REG_DWORD /d 1 /f`n"
      "`t`t`t  }`n"

      "`t`t`t  {`n"
      "`t`t`t    try {`n"
      "`t`t`t      `$bytes = & $([System.Char]39)C:\Windows\Setup\Scripts\GetLockScreenImage.ps1$([System.Char]39)`n"
      "`t`t`t      [System.IO.File]::WriteAllBytes( $([System.Char]39)C:\Windows\Setup\Scripts\LockScreenImage.png$([System.Char]39), `$bytes )`n"
      "`t`t`t      reg.exe add $([System.Char]34)HKLM\Software\Microsoft\Windows\CurrentVersion\PersonalizationCSP$([System.Char]34) /v LockScreenImagePath /t REG_SZ /d $([System.Char]34)C:\Windows\Setup\Scripts\LockScreenImage.png$([System.Char]34) /f`n"
      "`t`t`t    } `n"
      "`t`t`t    catch {`n"
      "`t`t`t      `$_`n"
      "`t`t`t    }`n"
      "`t`t`t  }`n"

      "`t`t`t  {`n"
      "`t`t`t    `$HT = @{`n"
      "`t`t`t      LiteralPath = $([System.Char]39)C:\Users\Public\Desktop\Microsoft Edge.lnk$([System.Char]39)`n"
      "`t`t`t      ErrorAction = $([System.Char]39)SilentlyContinue$([System.Char]39)`n"
      "`t`t`t      Verbose     = `$true`n"
      "`t`t`t    }    `n"
      "`t`t`t    Remove-Item @HT`n"
      "`t`t`t  }`n"
      "`t`t`t  {`n"
      "`t`t`t    `$HT = @{`n"
      "`t`t`t      LiteralPath = $([System.Char]39)Registry::HKLM\Software\Microsoft\WindowsUpdate\Orchestrator\UScheduler_Oobe\DevHomeUpdate$([System.Char]39)`n"
      "`t`t`t      ErrorAction = $([System.Char]39)SilentlyContinue$([System.Char]39)`n"
      "`t`t`t      Verbose     = `$true`n"
      "`t`t`t      Force       = `$true`n"
      "`t`t`t    }`n"
      "`t`t`t    Remove-Item @HT`n"
      "`t`t`t  }`n"
      "`t`t`t  {`n"
      "`t`t`t    `$HT = @{`n"
      "`t`t`t      LiteralPath = $([System.Char]39)Registry::HKLM\Software\Microsoft\WindowsUpdate\Orchestrator\UScheduler_Oobe\OutlookUpdate$([System.Char]39)`n"
      "`t`t`t      ErrorAction = $([System.Char]39)SilentlyContinue$([System.Char]39)`n"
      "`t`t`t      Verbose     = `$true`n"
      "`t`t`t      Force       = `$true`n"
      "`t`t`t    }`n"
      "`t`t`t    Remove-Item @HT`n"
      "`t`t`t  }`n"

      "`t`t`t  { # Disable Sticky Keys? |`n"
      "`t`t`t    reg.exe add $([System.Char]34)HKU\.DEFAULT\Control Panel\Accessibility\StickyKeys$([System.Char]34) /v Flags /t REG_SZ /d 10 /f`n"
      "`t`t`t  }`n"
      "`t`t`t  { # Do not configure Chat AutoInstall |`n"
      "`t`t`t    reg.exe add $([System.Char]34)HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Communications$([System.Char]34) /v ConfigureChatAutoInstall /t REG_DWORD /d 0 /f`n"
      "`t`t`t  }`n"
      "`t`t`t  { # Disallow News And Interests |`n"
      "`t`t`t    reg.exe add $([System.Char]34)HKLM\SOFTWARE\Policies\Microsoft\Dsh$([System.Char]34) /v AllowNewsAndInterests /t REG_DWORD /d 0 /f`n"
      "`t`t`t  }`n"
      "`t`t`t  { # Disable Windows Consumer Features |`n"
      "`t`t`t    reg.exe add $([System.Char]34)HKLM\Software\Policies\Microsoft\Windows\CloudContent$([System.Char]34) /v $([System.Char]34)DisableWindowsConsumerFeatures$([System.Char]34) /t REG_DWORD /d 1 /f`n"
      "`t`t`t  }`n"
      "`t`t`t  { # Prevent Edge from prompting for a Microsoft Account at first launch |`n"
      "`t`t`t    reg.exe add $([System.Char]34)HKLM\Software\Policies\Microsoft\Edge$([System.Char]34) /v HideFirstRunExperience /t REG_DWORD /d 1 /f`n"
      "`t`t`t  }`n"
      "`t`t`t  { # Disable Edge Background Mode |`n"
      "`t`t`t    reg.exe add $([System.Char]34)HKLM\Software\Policies\Microsoft\Edge\Recommended$([System.Char]34) /v BackgroundModeEnabled /t REG_DWORD /d 0 /f`n"
      "`t`t`t  }`n"
      "`t`t`t  { # Disable Edge Startup Boost |`n"
      "`t`t`t    reg.exe add $([System.Char]34)HKLM\Software\Policies\Microsoft\Edge\Recommended$([System.Char]34) /v StartupBoostEnabled /t REG_DWORD /d 0 /f`n"
      "`t`t`t  }`n"

      "`t`t`t)`n"
      "`t`t`t& {`n"
      "`t`t`t  [System.Single] `$Complete = 0`n"
      "`t`t`t  [System.Single] `$Increment = 100 / `$SpecializeScriptBlocks.Count`n"
      "`t`t`t  foreach (`$script in `$SpecializeScriptBlocks) {`n"
      "`t`t`t    Write-Progress -Activity $([System.Char]39)Running scriptblocks in Specialize.ps1. Do not close this window.$([System.Char]39) -PercentComplete `$Complete`n"
      "`t`t`t    $([System.Char]34)*** Will now execute command $([System.Char]171){0}$([System.Char]187)$([System.Char]34) -f `$(`n"
      "`t`t`t      `$script.ToString().Trim() -replace $([System.Char]39)\s+$([System.Char]39), $([System.Char]39) $([System.Char]39) -replace $([System.Char]39)^(.{99})(.+)`$$([System.Char]39), $([System.Char]39)`$1$([System.Char]8230)$([System.Char]39)`n"
      "`t`t`t    )`n"
      "`t`t`t    `$start = [System.DateTime]::Now`n"
      "`t`t`t    & `$script`n"
      "`t`t`t    $([System.Char]39)*** Finished executing command after {0:0} ms.$([System.Char]39) -f [System.DateTime]::Now.Subtract(`$start).TotalMilliseconds`n"
      "`t`t`t    `$Complete += `$Increment`n"
      "`t`t`t  }`n"
      "`t`t`t} *>&1 | Out-String -Width 1KB -Stream >> $([System.Char]34)C:\Windows\Setup\Scripts\Specialize.log$([System.Char]34);`n"
      "`t`t"
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\Specialize.ps1')
        $XmlWriter.WriteString(${File Specialize.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion

    #region | UserOnce.ps1 Here-String | C-Scripts |
    ${File UserOnce.ps1 Here-String} = $(
      "`n"
      "`t`t`t`$UserOnceScriptBlocks = `$(`n"
      "`t`t`t  { # Remove UWP Copilot Application |`n"
      "`t`t`t    Get-AppxPackage -Name $([System.Char]39)Microsoft.Windows.Ai.Copilot.Provider$([System.Char]39) -Verbose | Remove-AppxPackage -Verbose`n"
      "`t`t`t  }`n"
      "`t`t`t  { # Unlock Taskbar Layout |`n"
      "`t`t`t    [System.Diagnostics.EventLog]::WriteEntry( $([System.Char]39)UnattendGenerator$([System.Char]39), $([System.Char]34)User $([System.Char]39)`$env:USERNAME$([System.Char]39) has requested to unlock the Start menu layout.$([System.Char]34), [System.Diagnostics.EventLogEntryType]::Information, 1 )`n"
      "`t`t`t  }`n"

      "`t`t`t  { # I$([System.Char]39)m not sure what this does... |`n"
      "`t`t`t    @(`n"
      "`t`t`t      Get-ChildItem -LiteralPath `$env:USERPROFILE -Force -Recurse -Depth 2`n"
      "`t`t`t    ) | Where-Object -FilterScript {`n"
      "`t`t`t      `$_.Attributes.HasFlag( [System.IO.FileAttributes]::ReparsePoint )`n"
      "`t`t`t    } | Remove-Item -Force -Recurse -Verbose`n"
      "`t`t`t  }`n"
      "`t`t`t  { # Delete shortcut desktop icon for Microsoft Edge |`n"
      "`t`t`t    Remove-Item -LiteralPath $([System.Char]34)`${env:USERPROFILE}\Desktop\Microsoft Edge.lnk$([System.Char]34) -ErrorAction $([System.Char]39)SilentlyContinue$([System.Char]39) -Verbose`n"
      "`t`t`t  }`n"
      "`t`t`t  { # Force classic context-sensitive menu |`n"
      "`t`t`t    `$params = @{`n"
      "`t`t`t      Path        = $([System.Char]39)Registry::HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32$([System.Char]39)`n"
      "`t`t`t      ErrorAction = $([System.Char]39)SilentlyContinue$([System.Char]39)`n"
      "`t`t`t      Verbose     = `$true`n"
      "`t`t`t      Force       = `$true`n"
      "`t`t`t    }`n"
      "`t`t`t    New-Item @params`n"
      "`t`t`t    Set-ItemProperty @params -Name $([System.Char]39)(Default)$([System.Char]39) -Value $([System.Char]39)$([System.Char]39) -Type $([System.Char]39)String$([System.Char]39)`n"
      "`t`t`t    # reg.exe add $([System.Char]34)HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32$([System.Char]34) /ve /f;`n"
      "`t`t`t  }`n"
      "`t`t`t  { # This PC of File Explorer and not Home or Personal |`n"
      "`t`t`t    Set-ItemProperty -LiteralPath $([System.Char]39)Registry::HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]39) -Name $([System.Char]39)LaunchTo$([System.Char]39) -Type $([System.Char]39)DWord$([System.Char]39) -Value 1 -Verbose`n"
      "`t`t`t  }`n"
      "`t`t`t  { # Set Windows CLI default location as C:\ by running $([System.Char]34)cd\ && cls$([System.Char]34) each time cmd.exe starts |`n"
      "`t`t`t    try {`n"
      "`t`t`t      Get-ItemProperty -Path $([System.Char]34)HKLM:\Software\Microsoft\Command Processor$([System.Char]34) -Name $([System.Char]39)AutoRun$([System.Char]39) -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t    }`n"
      "`t`t`t    catch {`n"
      "`t`t`t      New-ItemProperty -Path $([System.Char]34)HKLM:\Software\Microsoft\Command Processor$([System.Char]34) -Name $([System.Char]39)AutoRun$([System.Char]39) -PropertyType STRING -Value $([System.Char]34)cd\ && cls$([System.Char]34)`n"
      "`t`t`t      # Alternative: Elect one or the other:`n"
      "`t`t`t      ## New-ItemProperty -Path $([System.Char]34)HKLM:\Software\Microsoft\Command Processor$([System.Char]34) -Name AutoRun -PropertyType STRING -Value $([System.Char]34)cd C:\Minecraft\Java\server01$([System.Char]34)`n"
      "`t`t`t    } `n"
      "`t`t`t  }`n"
      "`t`t`t  { # No Lock Screen. Saves you a quarter second when logging in. |`n"
      "`t`t`t    # in Windows 11 Aero shake to minimize and Lock Screen are disabled by default...? `n"
      "`t`t`t    try {`n"
      "`t`t`t      Get-Item -Path $([System.Char]34)HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization$([System.Char]34) -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t    }`n"
      "`t`t`t    catch {`n"
      "`t`t`t      New-Item -Path $([System.Char]34)HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization$([System.Char]34)`n"
      "`t`t`t    } `n"
      "`t`t`t  `n"
      "`t`t`t    ##STILL NEED TO TEST WHETHER THE $([System.Char]39)NoLockScreen$([System.Char]39) property on Personalization is present after OS install. `n"
      "`t`t`t    try{`n"
      "`t`t`t      Get-ItemProperty -Path $([System.Char]34)HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization$([System.Char]34) -Name $([System.Char]39)NoLockScreen$([System.Char]39) -ErrorAction $([System.Char]39)Stop$([System.Char]39)`n"
      "`t`t`t    }`n"
      "`t`t`t    catch{`n"
      "`t`t`t      New-ItemProperty -Path $([System.Char]34)HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization$([System.Char]34) -Name $([System.Char]39)NoLockScreen$([System.Char]39) -PropertyType $([System.Char]39)DWORD$([System.Char]39) -Value $([System.Char]39)1$([System.Char]39)`n"
      "`t`t`t    } `n"
      "`t`t`t  }`n"

      "`t`t`t  {`n"
      "`t`t`t    Set-ItemProperty -LiteralPath $([System.Char]39)Registry::HKCU\Software\Microsoft\Windows\CurrentVersion\Search$([System.Char]39) -Name $([System.Char]39)SearchboxTaskbarMode$([System.Char]39) -Type $([System.Char]39)DWord$([System.Char]39) -Value 0 -Verbose`n"
      "`t`t`t  }`n"
      "`t`t`t  {`n"
      "`t`t`t    Set-ItemProperty -LiteralPath $([System.Char]39)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects$([System.Char]39) -Name $([System.Char]39)VisualFXSetting$([System.Char]39) -Type $([System.Char]39)DWord$([System.Char]39) -Value 2 -Force -Verbose`n"
      "`t`t`t  }`n"
      "`t`t`t  {`n"
      "`t`t`t    New-Item -Path $([System.Char]39)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu$([System.Char]39) -Force;`n"
      "`t`t`t    Set-ItemProperty -Path $([System.Char]39)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu$([System.Char]39) -Name $([System.Char]39){5399e694-6ce5-4d6c-8fce-1d8870fdcba0}$([System.Char]39) -Value 1 -Type $([System.Char]39)DWord$([System.Char]39) -Verbose`n"
      "`t`t`t    Set-ItemProperty -Path $([System.Char]39)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu$([System.Char]39) -Name $([System.Char]39){b4bfcc3a-db2c-424c-b029-7fe99a87c641}$([System.Char]39) -Value 1 -Type $([System.Char]39)DWord$([System.Char]39) -Verbose`n"
      "`t`t`t    Set-ItemProperty -Path $([System.Char]39)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu$([System.Char]39) -Name $([System.Char]39){a8cdff1c-4878-43be-b5fd-f8091c1c60d0}$([System.Char]39) -Value 1 -Type $([System.Char]39)DWord$([System.Char]39) -Verbose`n"
      "`t`t`t    Set-ItemProperty -Path $([System.Char]39)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu$([System.Char]39) -Name $([System.Char]39){374de290-123f-4565-9164-39c4925e467b}$([System.Char]39) -Value 1 -Type $([System.Char]39)DWord$([System.Char]39) -Verbose`n"
      "`t`t`t    Set-ItemProperty -Path $([System.Char]39)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu$([System.Char]39) -Name $([System.Char]39){e88865ea-0e1c-4e20-9aa6-edcd0212c87c}$([System.Char]39) -Value 1 -Type $([System.Char]39)DWord$([System.Char]39) -Verbose`n"
      "`t`t`t    Set-ItemProperty -Path $([System.Char]39)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu$([System.Char]39) -Name $([System.Char]39){f874310e-b6b7-47dc-bc84-b9e6b38f5903}$([System.Char]39) -Value 1 -Type $([System.Char]39)DWord$([System.Char]39) -Verbose`n"
      "`t`t`t    Set-ItemProperty -Path $([System.Char]39)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu$([System.Char]39) -Name $([System.Char]39){1cf1260c-4dd0-4ebb-811f-33c572699fde}$([System.Char]39) -Value 1 -Type $([System.Char]39)DWord$([System.Char]39) -Verbose`n"
      "`t`t`t    Set-ItemProperty -Path $([System.Char]39)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu$([System.Char]39) -Name $([System.Char]39){f02c1a0d-be21-4350-88b0-7367fc96ef3c}$([System.Char]39) -Value 1 -Type $([System.Char]39)DWord$([System.Char]39) -Verbose`n"
      "`t`t`t    Set-ItemProperty -Path $([System.Char]39)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu$([System.Char]39) -Name $([System.Char]39){3add1653-eb32-4cb0-bbd7-dfa0abb5acca}$([System.Char]39) -Value 1 -Type $([System.Char]39)DWord$([System.Char]39) -Verbose`n"
      "`t`t`t    Set-ItemProperty -Path $([System.Char]39)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu$([System.Char]39) -Name $([System.Char]39){645ff040-5081-101b-9f08-00aa002f954e}$([System.Char]39) -Value 0 -Type $([System.Char]39)DWord$([System.Char]39) -Verbose`n"
      "`t`t`t    Set-ItemProperty -Path $([System.Char]39)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu$([System.Char]39) -Name $([System.Char]39){20d04fe0-3aea-1069-a2d8-08002b30309d}$([System.Char]39) -Value 1 -Type $([System.Char]39)DWord$([System.Char]39) -Verbose`n"
      "`t`t`t    Set-ItemProperty -Path $([System.Char]39)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu$([System.Char]39) -Name $([System.Char]39){59031a47-3f72-44a7-89c5-5595fe6b30ee}$([System.Char]39) -Value 1 -Type $([System.Char]39)DWord$([System.Char]39) -Verbose`n"
      "`t`t`t    Set-ItemProperty -Path $([System.Char]39)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\ClassicStartMenu$([System.Char]39) -Name $([System.Char]39){a0953c92-50dc-43bf-be83-3742fed03c9c}$([System.Char]39) -Value 1 -Type $([System.Char]39)DWord$([System.Char]39) -Verbose`n"
      "`t`t`t    New-Item -Path $([System.Char]39)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel$([System.Char]39) -Force -Verbose`n"
      "`t`t`t    Set-ItemProperty -Path $([System.Char]39)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel$([System.Char]39) -Name $([System.Char]39){5399e694-6ce5-4d6c-8fce-1d8870fdcba0}$([System.Char]39) -Value 1 -Type $([System.Char]39)DWord$([System.Char]39) -Verbose`n"
      "`t`t`t    Set-ItemProperty -Path $([System.Char]39)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel$([System.Char]39) -Name $([System.Char]39){b4bfcc3a-db2c-424c-b029-7fe99a87c641}$([System.Char]39) -Value 1 -Type $([System.Char]39)DWord$([System.Char]39) -Verbose`n"
      "`t`t`t    Set-ItemProperty -Path $([System.Char]39)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel$([System.Char]39) -Name $([System.Char]39){a8cdff1c-4878-43be-b5fd-f8091c1c60d0}$([System.Char]39) -Value 1 -Type $([System.Char]39)DWord$([System.Char]39) -Verbose`n"
      "`t`t`t    Set-ItemProperty -Path $([System.Char]39)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel$([System.Char]39) -Name $([System.Char]39){374de290-123f-4565-9164-39c4925e467b}$([System.Char]39) -Value 1 -Type $([System.Char]39)DWord$([System.Char]39) -Verbose`n"
      "`t`t`t    Set-ItemProperty -Path $([System.Char]39)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel$([System.Char]39) -Name $([System.Char]39){e88865ea-0e1c-4e20-9aa6-edcd0212c87c}$([System.Char]39) -Value 1 -Type $([System.Char]39)DWord$([System.Char]39) -Verbose`n"
      "`t`t`t    Set-ItemProperty -Path $([System.Char]39)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel$([System.Char]39) -Name $([System.Char]39){f874310e-b6b7-47dc-bc84-b9e6b38f5903}$([System.Char]39) -Value 1 -Type $([System.Char]39)DWord$([System.Char]39) -Verbose`n"
      "`t`t`t    Set-ItemProperty -Path $([System.Char]39)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel$([System.Char]39) -Name $([System.Char]39){1cf1260c-4dd0-4ebb-811f-33c572699fde}$([System.Char]39) -Value 1 -Type $([System.Char]39)DWord$([System.Char]39) -Verbose`n"
      "`t`t`t    Set-ItemProperty -Path $([System.Char]39)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel$([System.Char]39) -Name $([System.Char]39){f02c1a0d-be21-4350-88b0-7367fc96ef3c}$([System.Char]39) -Value 1 -Type $([System.Char]39)DWord$([System.Char]39) -Verbose`n"
      "`t`t`t    Set-ItemProperty -Path $([System.Char]39)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel$([System.Char]39) -Name $([System.Char]39){3add1653-eb32-4cb0-bbd7-dfa0abb5acca}$([System.Char]39) -Value 1 -Type $([System.Char]39)DWord$([System.Char]39) -Verbose`n"
      "`t`t`t    Set-ItemProperty -Path $([System.Char]39)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel$([System.Char]39) -Name $([System.Char]39){645ff040-5081-101b-9f08-00aa002f954e}$([System.Char]39) -Value 0 -Type $([System.Char]39)DWord$([System.Char]39) -Verbose`n"
      "`t`t`t    Set-ItemProperty -Path $([System.Char]39)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel$([System.Char]39) -Name $([System.Char]39){20d04fe0-3aea-1069-a2d8-08002b30309d}$([System.Char]39) -Value 1 -Type $([System.Char]39)DWord$([System.Char]39) -Verbose`n"
      "`t`t`t    Set-ItemProperty -Path $([System.Char]39)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel$([System.Char]39) -Name $([System.Char]39){59031a47-3f72-44a7-89c5-5595fe6b30ee}$([System.Char]39) -Value 1 -Type $([System.Char]39)DWord$([System.Char]39) -Verbose`n"
      "`t`t`t    Set-ItemProperty -Path $([System.Char]39)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\HideDesktopIcons\NewStartPanel$([System.Char]39) -Name $([System.Char]39){a0953c92-50dc-43bf-be83-3742fed03c9c}$([System.Char]39) -Value 1 -Type $([System.Char]39)DWord$([System.Char]39) -Verbose`n"
      "`t`t`t  }`n"
      "`t`t`t  {`n"
      "`t`t`t    Set-ItemProperty -Path $([System.Char]39)Registry::HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Start$([System.Char]39) -Name $([System.Char]39)VisiblePlaces$([System.Char]39) -Value `$( [convert]::FromBase64String($([System.Char]39)$([System.Char]39)) ) -Type $([System.Char]39)Binary$([System.Char]39) -Verbose`n"
      "`t`t`t  }`n"
      "`t`t`t  { # Set Color Theme |`n"
      "`t`t`t    & $([System.Char]39)C:\Windows\Setup\Scripts\SetColorTheme.ps1$([System.Char]39)`n"
      "`t`t`t    # Get-Content -LiteralPath $([System.Char]39)C:\Windows\Setup\Scripts\SetColorTheme.ps1$([System.Char]39) -Raw | Invoke-Expression -Verbose`n"
      "`t`t`t  }`n"
      "`t`t`t  { # Set Wallpaper |`n"
      "`t`t`t    & $([System.Char]39)C:\Windows\Setup\Scripts\SetWallpaper.ps1$([System.Char]39)`n"
      "`t`t`t    # Get-Content -LiteralPath $([System.Char]39)C:\Windows\Setup\Scripts\SetWallpaper.ps1$([System.Char]39) -Raw | Invoke-Expression -Verbose`n"
      "`t`t`t  }`n"
      "`t`t`t  { # Hide Taskbar |`n"
      "`t`t`t    # & $([System.Char]39)C:\Windows\Setup\Scripts\HideTaskbar.ps1$([System.Char]39)`n"
      "`t`t`t    `$p = $([System.Char]34)Registry::HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3$([System.Char]34)`n"
      "`t`t`t    `$v = (Get-ItemProperty -Path `$p).Settings`n"
      "`t`t`t    `$v[8] = 0x7b`n"
      "`t`t`t    Set-ItemProperty -Path `$p -Name $([System.Char]39)Settings$([System.Char]39) -Value `$v`n"
      "`t`t`t    # restart explorer.exe`n"
      "`t`t`t    Get-Process -Name explorer | Stop-Process -Force | Start-Process -FilePath $([System.Char]34)`$env:windir\explorer.exe$([System.Char]34)`n"
      "`t`t`t  }`n"

      "`t`t`t  {`n"
      "`t`t`t    Get-Content -LiteralPath $([System.Char]39)C:\Windows\Setup\Scripts\unattend_C00.ps1$([System.Char]39) -Raw | Invoke-Expression -Verbose`n"
      "`t`t`t  }`n"
      #"`t`t`t  {`n"
      #"`t`t`t    Get-Content -LiteralPath $([System.Char]39)C:\Windows\Setup\Scripts\unattend_C01.ps1$([System.Char]39) -Raw | Invoke-Expression -Verbose`n"
      #"`t`t`t  }`n"
      #"`t`t`t  {`n"
      #"`t`t`t    Get-Content -LiteralPath $([System.Char]39)C:\Windows\Setup\Scripts\unattend_C02.ps1$([System.Char]39) -Raw | Invoke-Expression -Verbose`n"
      #"`t`t`t  }`n"
      #"`t`t`t  {`n"
      #"`t`t`t    Get-Content -LiteralPath $([System.Char]39)C:\Windows\Setup\Scripts\unattend_C03.ps1$([System.Char]39) -Raw | Invoke-Expression -Verbose`n"
      #"`t`t`t  }`n"
      ## Restart explorer.exe process | Does restarting the explorer.exe process kill the current powershell processes? |
      # "`t`t`t  { `n"
      # "`t`t`t    Get-Process -Name $([System.Char]39)explorer$([System.Char]39) -ErrorAction $([System.Char]39)SilentlyContinue$([System.Char]39) $([System.Char]96)`n"
      # "`t`t`t    | Where-Object -FilterScript {`n"
      # "`t`t`t      `$_.SessionId -eq (Get-Process -Id `$PID).SessionId`n"
      # "`t`t`t    } | Stop-Process -Force`n"
      # "`t`t`t  }`n"
      "`t`t`t)`n"
      "`t`t`t& {`n"
      "`t`t`t  [System.Single] `$Complete = 0`n"
      "`t`t`t  [System.Single] `$Increment = 100 / `$UserOnceScriptBlocks.Count`n"
      "`t`t`t  foreach (`$script in `$UserOnceScriptBlocks) {`n"
      "`t`t`t    Write-Progress -Activity $([System.Char]39)Running scriptblocks in UserOnce.ps1. Do not close this window.$([System.Char]39) -PercentComplete `$complete`n"
      "`t`t`t    $([System.Char]34)*** Will now execute command $([System.Char]171){0}$([System.Char]187)$([System.Char]34) -f `$(`n"
      "`t`t`t      `$script.ToString().Trim() -replace $([System.Char]39)\s+$([System.Char]39), $([System.Char]39) $([System.Char]39) -replace $([System.Char]39)^(.{99})(.+)`$$([System.Char]39), $([System.Char]39)`$1$([System.Char]8230)…$([System.Char]39)`n"
      "`t`t`t    )`n"
      "`t`t`t    `$start = [System.DateTime]::Now`n"
      "`t`t`t    & `$script`n"
      "`t`t`t    $([System.Char]39)*** Finished executing command after {0:0} ms.$([System.Char]39) -f [System.DateTime]::Now.Subtract(`$start).TotalMilliseconds`n"
      "`t`t`t    `$Complete += `$Increment`n"
      "`t`t`t  }`n"
      "`t`t`t} *>&1 | Out-String -Width 1KB -Stream >> $([System.Char]34)`$env:UserProfile\UserOnce.log$([System.Char]34)`n"
      "`t`t"
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\UserOnce.ps1')
        $XmlWriter.WriteString(${File UserOnce.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion

    #region | DefaultUser.ps1 Here-String | D-Scripts |
    ${File DefaultUser.ps1 Here-String} = $(
      "`n"
      "`t`t`t`$DefaultUserScriptBlocks = `$(`n"
      "`t`t`t  #region | Desktop Experience |`n"
      "`t`t`t  { # Show file extensions |`n"
      "`t`t`t    reg.exe add $([System.Char]34)HKU\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34) /v $([System.Char]34)HideFileExt$([System.Char]34) /t REG_DWORD /d 0 /f`n"
      "`t`t`t  }  `n"
      "`t`t`t  { # Deactivate Copilot |`n"
      "`t`t`t    reg.exe add $([System.Char]34)HKU\DefaultUser\Software\Policies\Microsoft\Windows\WindowsCopilot$([System.Char]34) /v TurnOffWindowsCopilot /t REG_DWORD /d 1 /f`n"
      "`t`t`t  }`n"
      "`t`t`t  { # Enable taskbar developer settings, whatever that means... |`n"
      "`t`t`t    reg.exe add $([System.Char]34)HKU\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced\TaskbarDeveloperSettings$([System.Char]34) /v TaskbarEndTask /t REG_DWORD /d 1 /f`n"
      "`t`t`t  }`n"
      "`t`t`t  { # Modify Taskbar |`n"
      "`t`t`t    reg.exe add $([System.Char]34)HKU\DefaultUser\Software\Policies\Microsoft\Windows\Explorer$([System.Char]34) /v $([System.Char]34)StartLayoutFile$([System.Char]34) /t REG_SZ /d $([System.Char]34)C:\Windows\Setup\Scripts\TaskbarLayoutModification.xml$([System.Char]34) /f`n"
      "`t`t`t    reg.exe add $([System.Char]34)HKU\DefaultUser\Software\Policies\Microsoft\Windows\Explorer$([System.Char]34) /v $([System.Char]34)LockedStartLayout$([System.Char]34) /t REG_DWORD /d 1 /f`n"
      "`t`t`t  }`n"
      "`t`t`t  { # Show all icons in the System Tray. Do not collapse system tray icons into a sub-menu`n"
      "`t`t`t    & $([System.Char]39)C:\Windows\Setup\Scripts\ShowAllTrayIcons.ps1$([System.Char]39)`n"
      "`t`t`t    # Get-Content -LiteralPath $([System.Char]39)C:\Windows\Setup\Scripts\ShowAllTrayIcons.ps1$([System.Char]39) -Raw | Invoke-Expression -Verbose`n"
      "`t`t`t  }`n"
      "`t`t`t  { # Hide Task View button |`n"
      "`t`t`t    reg.exe add $([System.Char]34)HKU\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34) /v ShowTaskViewButton /t REG_DWORD /d 0 /f`n"
      "`t`t`t  }`n"
      "`t`t`t  { # Show hidden files? |`n"
      "`t`t`t    reg.exe add $([System.Char]34)HKU\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34) /v $([System.Char]34)Hidden$([System.Char]34) /t REG_DWORD /d 1 /f`n"
      "`t`t`t  }`n"
      "`t`t`t  { # Leave preinstalled apps disabled? |`n"
      "`t`t`t    `$names = @(`n"
      "`t`t`t      $([System.Char]39)ContentDeliveryAllowed$([System.Char]39)`n"
      "`t`t`t      $([System.Char]39)FeatureManagementEnabled$([System.Char]39)`n"
      "`t`t`t      $([System.Char]39)OEMPreInstalledAppsEnabled$([System.Char]39)`n"
      "`t`t`t      $([System.Char]39)PreInstalledAppsEnabled$([System.Char]39)`n"
      "`t`t`t      $([System.Char]39)PreInstalledAppsEverEnabled$([System.Char]39)`n"
      "`t`t`t      $([System.Char]39)SilentInstalledAppsEnabled$([System.Char]39)`n"
      "`t`t`t      $([System.Char]39)SoftLandingEnabled$([System.Char]39)`n"
      "`t`t`t      $([System.Char]39)SubscribedContent-310093Enabled$([System.Char]39)`n"
      "`t`t`t      $([System.Char]39)SubscribedContent-338387Enabled$([System.Char]39)`n"
      "`t`t`t      $([System.Char]39)SubscribedContent-338388Enabled$([System.Char]39)`n"
      "`t`t`t      $([System.Char]39)SubscribedContent-338389Enabled$([System.Char]39)`n"
      "`t`t`t      $([System.Char]39)SubscribedContent-338393Enabled$([System.Char]39)`n"
      "`t`t`t      $([System.Char]39)SubscribedContent-353694Enabled$([System.Char]39)`n"
      "`t`t`t      $([System.Char]39)SubscribedContent-353696Enabled$([System.Char]39)`n"
      "`t`t`t      $([System.Char]39)SubscribedContent-353698Enabled$([System.Char]39)`n"
      "`t`t`t      $([System.Char]39)SubscribedContentEnabled$([System.Char]39)`n"
      "`t`t`t      $([System.Char]39)SystemPaneSuggestionsEnabled$([System.Char]39)`n"
      "`t`t`t    )    `n"
      "`t`t`t    foreach (`$name in `$names){`n"
      "`t`t`t      reg.exe add $([System.Char]34)HKU\DefaultUser\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager$([System.Char]34) /v `$name /t REG_DWORD /d 0 /f`n"
      "`t`t`t    }`n"
      "`t`t`t  }`n"
      "`t`t`t  { # Not sure what $([System.Char]39)TaskbarAl$([System.Char]39) is... |`n"
      "`t`t`t    reg.exe add $([System.Char]34)HKU\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34) /v TaskbarAl /t REG_DWORD /d 0 /f`n"
      "`t`t`t  }`n"
      "`t`t`t  { # Yes, disable Search box suggestions |`n"
      "`t`t`t    reg.exe add $([System.Char]34)HKU\DefaultUser\Software\Policies\Microsoft\Windows\Explorer$([System.Char]34) /v DisableSearchBoxSuggestions /t REG_DWORD /d 1 /f`n"
      "`t`t`t  }`n"
      "`t`t`t  { # Halt StickyKeys |`n"
      "`t`t`t    reg.exe add $([System.Char]34)HKU\DefaultUser\Control Panel\Accessibility\StickyKeys$([System.Char]34) /v Flags /t REG_SZ /d 10 /f`n"
      "`t`t`t  }`n"
      "`t`t`t  { # Disable Tooltips. I love having shit pop up in front of what I'm currently reading.`n"
      "`t`t`t    reg.exe add $([System.Char]34)HKU\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34) /v $([System.Char]34)ShowInfoTip$([System.Char]34) /d 0 /t REG_DWORD /f`n"
      "`t`t`t  }`n"
      "`t`t`t  { # Disable Tooltips. I love having shit pop up in front of what I$([System.Char]39)m currently reading. |`n"
      "`t`t`t    Set-ItemProperty -Path $([System.Char]34)Registry::HKU\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34) -Name $([System.Char]39)ShowInfoTip$([System.Char]39) -Value $([System.Char]39)0$([System.Char]39)`n"
      "`t`t`t  }`n"
      "`t`t`t  { # Show all of the $([System.Char]39)Other system tray icons$([System.Char]39) |`n"
      "`t`t`t    #Get-Item -Path $([System.Char]34)HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify$([System.Char]34)`n"
      "`t`t`t    #Set-ItemProperty -Path $([System.Char]34)Registry::HKU\DefaultUser\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify$([System.Char]34) -Name $([System.Char]39)SystemTrayChevronVisibility$([System.Char]39) -Value $([System.Char]39)1$([System.Char]39)`n"
      "`t`t`t    reg.exe add $([System.Char]34)HKU\DefaultUser\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\TrayNotify$([System.Char]34) /v $([System.Char]34)SystemTrayChevronVisibility$([System.Char]34) /d 1 /t REG_DWORD /f`n"
      "`t`t`t  }`n"
      "`t`t`t  { # Disable Tooltips. I love having shit pop up in front of what I'm currently reading |`n"
      "`t`t`t    reg.exe add $([System.Char]34)HKU\DefaultUser\Software\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3$([System.Char]34) /v $([System.Char]34)ShowInfoTip$([System.Char]34) /d 0 /t REG_DWORD /f`n"
      "`t`t`t  }`n"
      "`t`t`t  { # Show accent color on Start, Taskbar, and Action Center |`n"
      "`t`t`t    reg.exe add $([System.Char]34)HKU\DefaultUser\Software\Microsoft\Windows\DWM$([System.Char]34) /v ColorPrevalence /t REG_DWORD /d 0 /f`n"
      "`t`t`t  }`n"
      "`t`t`t  { # Execute the UserOnce.ps1 file | Verify whether the complex escaping is necessary |`n"
      "`t`t`t    reg.exe add $([System.Char]34)HKU\DefaultUser\Software\Microsoft\Windows\CurrentVersion\RunOnce$([System.Char]34) /v $([System.Char]34)UnattendedSetup$([System.Char]34) /t REG_SZ /d $([System.Char]34)powershell.exe -WindowStyle \$([System.Char]34)$([System.Char]34)Normal\$([System.Char]34)$([System.Char]34) -ExecutionPolicy \$([System.Char]34)$([System.Char]34)Unrestricted\$([System.Char]34)$([System.Char]34) -File \$([System.Char]34)$([System.Char]34)C:\Windows\Setup\Scripts\UserOnce.ps1\$([System.Char]34)$([System.Char]34)$([System.Char]34) /f`n"
      "`t`t`t  }`n"
      "`t`t`t  { # ??? |`n"
      "`t`t`t    reg.exe add $([System.Char]34)HKU\DefaultUser\Software\Microsoft\Internet Explorer\LowRegistry\Audio\PolicyConfig\PropertyStore$([System.Char]34) /f`n"
      "`t`t`t  } `n"
      "`t`t`t  `n"
      "`t`t`t  { #  |`n"
      "`t`t`t    Get-Content -LiteralPath $([System.Char]39)C:\Windows\Setup\Scripts\unattend_D00.ps1$([System.Char]39) -Raw | Invoke-Expression -Verbose`n"
      "`t`t`t  }`n"
      "`t`t`t  { #  |`n"
      "`t`t`t    Get-Content -LiteralPath $([System.Char]39)C:\Windows\Setup\Scripts\unattend_D01.ps1$([System.Char]39) -Raw | Invoke-Expression -Verbose`n"
      "`t`t`t  }`n"
      "`t`t`t  { #  |`n"
      "`t`t`t    Get-Content -LiteralPath $([System.Char]39)C:\Windows\Setup\Scripts\unattend_D02.ps1$([System.Char]39) -Raw | Invoke-Expression -Verbose`n"
      "`t`t`t  }`n"
      "`t`t`t  { # Checkmark $([System.Char]39)Decrease space between items (Compact View)$([System.Char]39) | Formerly unattend_D03.ps1 |`n"
      "`t`t`t    Set-ItemProperty -LiteralPath $([System.Char]34)Registry::HKU\DefaultUser\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced$([System.Char]34) -Name $([System.Char]39)UseCompactMode$([System.Char]39) -Type DWORD -Value $([System.Char]34)0x1$([System.Char]34) -Verbose -Force`n"
      "`t`t`t  }`n"
      "`t`t`t  { # Set Taskbar to auto-hide | Requires restarting explorer.exe | $([System.Char]39)https://www.buildwindows.com/how-to-hide-taskbar-windows-11/$([System.Char]39) |`n"
      "`t`t`t    ## This just isnt happening... `n"
      "`t`t`t    #  # Auto-hide Taskbar:              &{`$p=$([System.Char]39)HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3$([System.Char]39);`$v=(Get-ItemProperty -Path `$p).Settings;`$v[8]=0x7b;&Set-ItemProperty -Path `$p -Name Settings -Value `$v;&Stop-Process -f -ProcessName explorer}`n"
      "`t`t`t    #  # Do not Auto-hide Taskbar:       &{`$p=$([System.Char]39)HKCU:SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3$([System.Char]39);`$v=(Get-ItemProperty -Path `$p).Settings;`$v[8]=0x7a;&Set-ItemProperty -Path `$p -Name Settings -Value `$v;&Stop-Process -f -ProcessName explorer}`n"
      "`t`t`t    #  `$p = $([System.Char]34)Registry::HKU\DefaultUser\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3$([System.Char]34)`n"
      "`t`t`t    #  `$v = (Get-ItemProperty -Path `$p).Settings`n"
      "`t`t`t    #  `$v[8] = 0x7b`n"
      "`t`t`t    #  `$BinaryData = [System.BitConverter]::ToString(`$v).Replace($([System.Char]34)-$([System.Char]34),$([System.Char]34)$([System.Char]34)).ToLower()`n"
      "`t`t`t    #  reg.exe add $([System.Char]39)HKU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3$([System.Char]39) /v $([System.Char]39)Settings$([System.Char]39) /d $([System.Char]34)`$BinaryData$([System.Char]34) /t $([System.Char]39)REG_BINARY$([System.Char]39) /f`n"
      "`t`t`t  }`n"
      "`t`t`t  { #  |`n"
      "`t`t`t    Get-Content -LiteralPath $([System.Char]39)C:\Windows\Setup\Scripts\unattend_D04.ps1$([System.Char]39) -Raw | Invoke-Expression -Verbose`n"
      "`t`t`t  }`n"
      "`t`t`t  #endregion`n"
      # Set the display DPI scaling to 100% (96 DPI) for all users |
      "`t`t`t  { # Set the display DPI scaling to 100% (96 DPI) for all users `n"
      "`t`t`t    # by Tracy Le`n"
      "`t`t`t    # Reference: start msedge.exe $([System.Char]39)https://learn.microsoft.com/en-us/answers/questions/5577484/powershell-script-to-set-the-scale-of-all-the-conn$([System.Char]39)`n"
      "`t`t`t    ##`n"
      "`t`t`t    # This script sets the display DPI scaling to 100% (96 DPI) for all users.`n"
      "`t`t`t    # It must be run with elevated privileges (as Administrator or SYSTEM).`n"
      "`t`t`t    function Set-DpiScaling {`n"
      "`t`t`t      param (`n"
      "`t`t`t        [string]`$RegistryPath,`n"
      "`t`t`t        [int]`$DpiValue = 96 # 96 DPI corresponds to 100% scaling`n"
      "`t`t`t      )`n"
      "`t`t`t      try {`n"
      "`t`t`t        `$desktopPath = Join-Path -Path `$RegistryPath -ChildPath $([System.Char]34)Control Panel\Desktop$([System.Char]34)`n"
      "`t`t`t        `$metricsPath = Join-Path -Path `$desktopPath -ChildPath $([System.Char]34)WindowMetrics$([System.Char]34)`n"
      "`t`t`t        # Ensure the registry paths exist before trying to set properties`n"
      "`t`t`t        if (Test-Path -Path `$desktopPath) {`n"
      "`t`t`t          # Set legacy scaling values for compatibility`n"
      "`t`t`t          Set-ItemProperty -Path `$desktopPath -Name $([System.Char]34)Win8DpiScaling$([System.Char]34) -Value 1 -Type DWord -Force -ErrorAction Stop`n"
      "`t`t`t          Set-ItemProperty -Path `$desktopPath -Name $([System.Char]34)LogPixels$([System.Char]34) -Value `$DpiValue -Type DWord -Force -ErrorAction Stop`n"
      "`t`t`t        }`n"
      "`t`t`t        if (Test-Path -Path `$metricsPath) {`n"
      "`t`t`t          # Set modern scaling value`n"
      "`t`t`t          Set-ItemProperty -Path `$metricsPath -Name $([System.Char]34)AppliedDPI$([System.Char]34) -Value `$DpiValue -Type DWord -Force -ErrorAction Stop`n"
      "`t`t`t        }`n"
      "`t`t`t        Write-Host $([System.Char]34)Successfully applied DPI settings to path: `$RegistryPath$([System.Char]34)`n"
      "`t`t`t      }`n"
      "`t`t`t      catch {`n"
      "`t`t`t        Write-Warning $([System.Char]34)Could not apply DPI settings to $([System.Char]39)`$RegistryPath$([System.Char]39). Error: `$(`$_.Exception.Message)$([System.Char]34)`n"
      "`t`t`t      }`n"
      "`t`t`t    }`n"
      "`t`t`t    #--No Need To Perform Before 1st Logon--# # --- Step 1: Apply to all currently logged-in users ---`n"
      "`t`t`t    #--No Need To Perform Before 1st Logon--# Write-Host $([System.Char]34)Applying settings for currently loaded user profiles...$([System.Char]34)`n"
      "`t`t`t    #--No Need To Perform Before 1st Logon--# `$loadedSids = Get-ChildItem $([System.Char]34)Registry::HKEY_USERS$([System.Char]34) | Where-Object { `$_.Name -like $([System.Char]34)*S-1-5-21-*$([System.Char]34) } | ForEach-Object { `$_.PSChildName }`n"
      "`t`t`t    #--No Need To Perform Before 1st Logon--# foreach (`$sid in `$loadedSids) {`n"
      "`t`t`t    #--No Need To Perform Before 1st Logon--#   `$userHivePath = $([System.Char]34)Registry::HKEY_USERS\`$sid$([System.Char]34)`n"
      "`t`t`t    #--No Need To Perform Before 1st Logon--#   Set-DpiScaling -RegistryPath `$userHivePath`n"
      "`t`t`t    #--No Need To Perform Before 1st Logon--# }`n"
      "`t`t`t    # --- Step 2: Apply to the Default User Profile for all future users ---`n"
      "`t`t`t    Write-Host $([System.Char]34)Applying settings to the Default User Profile...$([System.Char]34)`n"
      "`t`t`t    try {`n"
      "`t`t`t      #--Already performed prior to script execution--# # Load the default user hive from its file location`n"
      "`t`t`t      #--Already performed prior to script execution--# reg load $([System.Char]34)HKU\DefaultUser$([System.Char]34) $([System.Char]34)C:\Users\Default\NTUSER.DAT$([System.Char]34) | Out-Null`n"
      "`t`t`t      Set-DpiScaling -RegistryPath $([System.Char]34)Registry::HKEY_USERS\DefaultUser$([System.Char]34)`n"
      "`t`t`t    }`n"
      "`t`t`t    catch {`n"
      "`t`t`t      Write-Warning $([System.Char]34)Failed to load or modify the Default User registry hive. Error: `$(`$_.Exception.Message)$([System.Char]34)`n"
      "`t`t`t    }`n"
      "`t`t`t    finally {`n"
      "`t`t`t      #--Will Be Performed Shortly--# # CRITICAL: Always unload the hive, regardless of success or failure`n"
      "`t`t`t      #--Will Be Performed Shortly--# reg unload $([System.Char]34)HKU\DefaultUser$([System.Char]34) | Out-Null`n"
      "`t`t`t    }`n"
      "`t`t`t    Write-Host $([System.Char]34)Script execution complete. A reboot or user logoff/logon is required for the changes to take effect.$([System.Char]34)`n"
      "`t`t`t  }`n"
      "`t`t`t)`n"
      "`t`t`t& { # Default User ScriptBlocks Logging |`n"
      "`t`t`t  [System.Single] `$Complete = 0`n"
      "`t`t`t  [System.Single] `$Increment = 100 / `$DefaultUserScriptBlocks.Count`n"
      "`t`t`t  foreach (`$script in `$DefaultUserScriptBlocks) {`n"
      "`t`t`t    Write-Progress -Activity $([System.Char]39)Running scriptblocks in DefaultUser.ps1. Do not close this window.$([System.Char]39) -PercentComplete `$Complete`n"
      "`t`t`t    $([System.Char]34)*** Will now execute command $([System.Char]171){0}$([System.Char]187)$([System.Char]34) -f `$(`n"
      "`t`t`t      `$script.ToString().Trim() -replace $([System.Char]39)\s+$([System.Char]39), $([System.Char]39) $([System.Char]39) -replace $([System.Char]39)^(.{99})(.+)`$$([System.Char]39), $([System.Char]39)`$1$([System.Char]8230)…$([System.Char]39)`n"
      "`t`t`t    )`n"
      "`t`t`t    `$start = [System.DateTime]::Now`n"
      "`t`t`t    & `$script`n"
      "`t`t`t    $([System.Char]39)*** Finished executing command after {0:0} ms.$([System.Char]39) -f [System.DateTime]::Now.Subtract(`$start).TotalMilliseconds`n"
      "`t`t`t    `$Complete += `$Increment`n"
      "`t`t`t  }`n"
      "`t`t`t} *>&1 | Out-String -Width 1KB -Stream >> $([System.Char]34)C:\Windows\Setup\Scripts\DefaultUser.log$([System.Char]34)`n"
      "`t`t"
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\DefaultUser.ps1')
        $XmlWriter.WriteString(${File DefaultUser.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion

    #region | FirstLogon.ps1 Here-String | B-Scripts |
    ${File FirstLogon.ps1 Here-String} = $(
      "`n"
      "`t`t`t`$FirstLogonScriptBlocks = `$(`n"
      "`t`t`t  { # Not supported on Windows Server | `n"
      "`t`t`t    # Disable-ComputerRestore -Drive $([System.Char]39)C:\$([System.Char]39) -Verbose`n"
      "`t`t`t  }`n"
      "`t`t`t`n"
      "`t`t`t  { # I$([System.Char]39)ve got NO idea what this does.... `n"
      "`t`t`t    @(`n"
      "`t`t`t      Get-ChildItem -LiteralPath $([System.Char]39)C:\$([System.Char]39) -Force`n"
      "`t`t`t      Get-ChildItem -LiteralPath $([System.Char]39)C:\Users$([System.Char]39) -Force`n"
      "`t`t`t      Get-ChildItem -LiteralPath $([System.Char]39)C:\Users\Default$([System.Char]39) -Force -Recurse -Depth 2`n"
      "`t`t`t      Get-ChildItem -LiteralPath $([System.Char]39)C:\Users\Public$([System.Char]39) -Force -Recurse -Depth 2`n"
      "`t`t`t      Get-ChildItem -LiteralPath $([System.Char]39)C:\ProgramData$([System.Char]39) -Force`n"
      "`t`t`t    ) | Where-Object -FilterScript {`n"
      "`t`t`t      `$_.Attributes.HasFlag([System.IO.FileAttributes]::ReparsePoint)`n"
      "`t`t`t    } | Remove-Item -Force -Recurse -Verbose`n"
      "`t`t`t  }`n"
      "`t`t`t  { # Delete Windows.old with sdelete.exe |`n"
      "`t`t`t    # cmd.exe /c $([System.Char]34)rmdir C:\Windows.old$([System.Char]34)`n"
      "`t`t`t    `$path = $([System.Char]34)C:\Windows.old$([System.Char]34); if (Test-Path -Path `$path) {Remove-Item -Path `$path -Force -verbose}`n"
      "`t`t`t  }`n"
      "`t`t`t  {`n"
      "`t`t`t    Get-Content -LiteralPath $([System.Char]39)C:\Windows\Setup\Scripts\unattend_B00.ps1$([System.Char]39) -Raw | Invoke-Expression -Verbose`n"
      "`t`t`t  }`n"
      "`t`t`t  { # Set Color Theme |`n"
      "`t`t`t    & $([System.Char]39)C:\Windows\Setup\Scripts\SetColorTheme.ps1$([System.Char]39)`n"
      "`t`t`t  }`n"
      "`t`t`t  { # Set Wallpaper |`n"
      "`t`t`t    & $([System.Char]39)C:\Windows\Setup\Scripts\SetWallpaper.ps1$([System.Char]39)`n"
      "`t`t`t  }`n"
      "`t`t`t  { # Hide Taskbar |`n"
      "`t`t`t    # & $([System.Char]39)C:\Windows\Setup\Scripts\HideTaskbar.ps1$([System.Char]39)`n"
      "`t`t`t    `$p = $([System.Char]34)Registry::HKCU\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StuckRects3$([System.Char]34)`n"
      "`t`t`t    `$v = (Get-ItemProperty -Path `$p).Settings`n"
      "`t`t`t    `$v[8] = 0x7b`n"
      "`t`t`t    Set-ItemProperty -Path `$p -Name $([System.Char]39)Settings$([System.Char]39) -Value `$v`n"
      "`t`t`t    # restart explorer.exe`n"
      "`t`t`t    Get-Process -Name explorer | Stop-Process -Force | Start-Process -FilePath $([System.Char]34)`$env:windir\explorer.exe$([System.Char]34)`n"
      "`t`t`t  }`n"
      "`t`t`t  { # Restore Credential Manager data |`n"
      "`t`t`t    $([System.Char]34)`$usb0\sec\`${GitHub Repository Name}.crd$([System.Char]34) | Set-Clipboard`n"
      "`t`t`t    control.exe /Name Microsoft.CredentialManager`n"
      "`t`t`t    pause`n"
      "`t`t`t    Start-Sleep 5`n"
      "`t`t`t  }`n"
      "`t`t`t  { # Also define the directory for Wave 00 of Epoch A |`n"
      "`t`t`t  #  `$Path = $([System.Char]34)`$env:DSC_CFG_ROOT\DSC\MOFs\Epoch A_Pre-Credential\Wave__00$([System.Char]34)`n"
      "`t`t`t  #  `$IsPresent = Test-Path -Path `$Path`n"
      "`t`t`t  #  if (-not `$IsPresent) {`n"
      "`t`t`t  #    `$dir = New-Item -Path `$Path -ItemType $([System.Char]39)Directory$([System.Char]39) -Force`n"
      "`t`t`t  #  }`n"
      "`t`t`t  #  `$Path = $([System.Char]34)`$env:DSC_CFG_ROOT\DSC\MOFs\Epoch A_Pre-Document Encryption\Wave__00$([System.Char]34)`n"
      "`t`t`t  #  `$IsPresent = Test-Path -Path `$Path`n"
      "`t`t`t  #  if (-not `$IsPresent) {`n"
      "`t`t`t  #    `$dir = New-Item -Path `$Path -ItemType $([System.Char]39)Directory$([System.Char]39) -Force`n"
      "`t`t`t  #  }`n"
      "`t`t`t  #  `$Path = $([System.Char]34)`$env:DSC_CFG_ROOT\DSC\MOFs\Epoch_A__PreDocument_Encryption\Wave_00$([System.Char]34)`n"
      "`t`t`t  #  `$IsPresent = Test-Path -Path `$Path`n"
      "`t`t`t  #  if (-not `$IsPresent) {`n"
      "`t`t`t  #    `$dir = New-Item -Path `$Path -ItemType $([System.Char]39)Directory$([System.Char]39) -Force`n"
      "`t`t`t  #  }`n"
      "`t`t`t  #  `$Path = $([System.Char]34)`$env:DSC_CFG_ROOT\DSC\MOFs\Epoch_B__HvH_with_VMs\Wave_00$([System.Char]34)`n"
      "`t`t`t  #  `$IsPresent = Test-Path -Path `$Path`n"
      "`t`t`t  #  if (-not `$IsPresent) {`n"
      "`t`t`t  #    `$dir = New-Item -Path `$Path -ItemType $([System.Char]39)Directory$([System.Char]39) -Force`n"
      "`t`t`t  #  }`n"
      "`t`t`t  }`n"
      "`t`t`t  { # Configure CertFSOs directory |`n"
      "`t`t`t  #  `$Path = $([System.Char]34)`$env:DSC_CFG_ROOT\EarlyShare\Self-Signed Certs$([System.Char]34)`n"
      "`t`t`t  #  `$IsPresent = Test-Path -Path `$Path`n"
      "`t`t`t  #  if (-not `$IsPresent) {`n"
      "`t`t`t  #    `$dir = New-Item -Path `$Path -ItemType $([System.Char]39)Directory$([System.Char]39) -Force`n"
      "`t`t`t  #  }`n"
      "`t`t`t  }`n"
      "`t`t`t  { # Define ComputerName File and Rename Computer |`n"
      "`t`t`t  #  `$Path = $([System.Char]34)`$Statics\PMs\`$PushServerCname ComputerName.txt$([System.Char]34)`n"
      "`t`t`t  #  `$IsPresent = Test-Path -Path `$Path`n"
      "`t`t`t  #  if (-not `$IsPresent) {`n"
      "`t`t`t  #    `$file = New-Item -Path `$Path -ItemType $([System.Char]39)File$([System.Char]39) -Force`n"
      "`t`t`t  #    `$RandomComputerName = ($([System.Char]39)WIN-$([System.Char]39) + ([System.IO.Path]::GetRandomFileName()) -replace $([System.Char]39)\.$([System.Char]39),$([System.Char]39)$([System.Char]39) -join $([System.Char]39)$([System.Char]39)).ToUpper()`n"
      "`t`t`t  #    Set-Content -Path `$Path -Value (`$RandomComputerName)`n"
      "`t`t`t  #    Set-ItemProperty -Name $([System.Char]39)IsReadOnly$([System.Char]39) -Path `$file.FullName -Value `$true`n"
      "`t`t`t  #    if (`$env:ComputerName -ne `$RandomComputerName) {`n"
      "`t`t`t  #      Rename-Computer -NewName `$RandomComputerName -Force -Restart`n"
      "`t`t`t  #    }`n"
      "`t`t`t  #  }`n"
      "`t`t`t  }`n"
      "`t`t`t)`n"
      "`t`t`t& {`n"
      "`t`t`t  [System.Single] `$Complete = 0`n"
      "`t`t`t  [System.Single] `$Increment = 100 / `$FirstLogonScriptBlocks.Count`n"
      "`t`t`t  foreach (`$script in `$FirstLogonScriptBlocks) {`n"
      "`t`t`t    Write-Progress -Activity $([System.Char]39)Running scriptblocks in FirstLogon.ps1. Do not close this window.$([System.Char]39) -PercentComplete `$Complete`n"
      "`t`t`t    $([System.Char]34)*** Will now execute command $([System.Char]171){0}$([System.Char]187)$([System.Char]34) -f `$(`n"
      "`t`t`t      `$script.ToString().Trim() -replace $([System.Char]39)\s+$([System.Char]39), $([System.Char]39) $([System.Char]39) -replace $([System.Char]39)^(.{99})(.+)`$$([System.Char]39), $([System.Char]39)`$1$([System.Char]8230)…$([System.Char]39)`n"
      "`t`t`t    )`n"
      "`t`t`t    `$start = [System.DateTime]::Now`n"
      "`t`t`t    & `$script`n"
      "`t`t`t    $([System.Char]39)*** Finished executing command after {0:0} ms.$([System.Char]39) -f [System.DateTime]::Now.Subtract(`$start).TotalMilliseconds`n"
      "`t`t`t    `$Complete += `$Increment`n"
      "`t`t`t  }`n"
      "`t`t`t} *>&1 | Out-String -Width 1KB -Stream >> $([System.Char]34)`$env:UserProfile\FirstLogon.log$([System.Char]34) # $([System.Char]34)C:\Windows\Setup\Scripts\FirstLogon.log$([System.Char]34)`n"
      "`t`t"
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\FirstLogon.ps1')
        $XmlWriter.WriteString(${File FirstLogon.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion

    #region | HadeanDscConfigurationDocument.ps1 Here-String |
    ${File HadeanDscConfigurationDocument.ps1 Here-String} = $(
      "`n"
      "`t`t`t`$WaveIndex = $([System.Char]39)00$([System.Char]39)`n"
      "`t`t`t`$EpochIndex = $([System.Char]39)A$([System.Char]39)`n"
      "`t`t`t`$EpochLabel = $([System.Char]34)PreDocument_Encryption$([System.Char]34)`n"
      "`t`t`t`$InstanceName = $([System.Char]34)Epoch_`$(`$EpochIndex)__`$(`$EpochLabel)__Wave_`$(`$WaveIndex)$([System.Char]34)`n"
      "`t`t`t`$LCM_InstanceName = $([System.Char]34)LCM_$([System.Char]34) + `$InstanceName`n"
      "`t`t`t`n"
      "`t`t`t[System.Management.Automation.DscLocalConfigurationManagerAttribute()]`n"
      "`t`t`tConfiguration `$LCM_InstanceName {`n"
      "`t`t`t  Node $([System.Char]39)localhost$([System.Char]39) { # `$env:ComputerName`n"
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
      "`t`t`t#Set-DscLocalConfigurationManager -CN `$env:ComputerName -Path `$lcmHT[$([System.Char]39)OutputPath$([System.Char]39)] -Force`n"
      "`t`t`tSet-DscLocalConfigurationManager -ComputerName $([System.Char]39)localhost$([System.Char]39) -Path `$lcmHT[$([System.Char]39)OutputPath$([System.Char]39)] -Force`n"
      "`t`t`t`n"
      "`t`t`tConfiguration `$InstanceName {`n"
      "`t`t`t  Import-DscResource -ModuleName $([System.Char]39)PSDesiredStateConfiguration$([System.Char]39)  -ModuleVersion 1.1`n"
      "`t`t`t  Import-DscResource -ModuleName $([System.Char]39)xPSDesiredStateConfiguration$([System.Char]39) -ModuleVersion 9.2.2`n"
      "`t`t`t  #Import-DscResource -ModuleName $([System.Char]39)AdHocDsc$([System.Char]39)                     -ModuleVersion 0.77.13.8`n"
      "`t`t`t  Import-DscResource -ModuleName $([System.Char]39)AdHocCertsDsc$([System.Char]39)                -ModuleVersion ${AdHocCertsDsc Version}`n"
      "`t`t`t  Import-DscResource -ModuleName $([System.Char]39)AdHocNetsDsc$([System.Char]39)                 -ModuleVersion ${AdHocNetsDsc Version}`n"
      "`t`t`t  Import-DscResource -ModuleName $([System.Char]39)AdHocPkiDsc$([System.Char]39)                  -ModuleVersion ${AdHocPkiDsc Version}`n"
      "`t`t`t  Import-DscResource -ModuleName $([System.Char]39)AdHocUtilsDsc$([System.Char]39)                -ModuleVersion ${AdHocUtilsDsc Version}`n"
      "`t`t`t  Import-DscResource -ModuleName $([System.Char]39)ComputerManagementDsc$([System.Char]39)        -ModuleVersion 10.0.1`n"
      "`t`t`t  Import-DscResource -ModuleName $([System.Char]39)CertificateDsc$([System.Char]39)               -ModuleVersion 6.1.0`n"
      "`t`t`t`n"
      "`t`t`t  Node $([System.Char]39)localhost$([System.Char]39) { # `$env:ComputerName`n"
      "`t`t`t    #region | Strictest Level of Windows PowerShell ScriptBlock and Module Logging |`n"
      "`t`t`t    xRegistry $([System.Char]39)PowerShell 5.1 ScriptBlock Logging$([System.Char]39) {`n"
      "`t`t`t      ValueName = $([System.Char]39)EnableScriptBlockLogging$([System.Char]39)`n"
      "`t`t`t      Key       = $([System.Char]39)HKLM:\SOFTWARE\Policies\Microsoft\Windows\PowerShell\ScriptBlockLogging$([System.Char]39)`n"
      "`t`t`t      ValueData = $([System.Char]39)1$([System.Char]39)`n"
      "`t`t`t      ValueType = $([System.Char]39)String$([System.Char]39)`n"
      "`t`t`t      Force     = `$true`n"
      "`t`t`t      Ensure    = $([System.Char]39)Present$([System.Char]39)`n"
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
      "`t`t`t    #region | Diagnostics-Enable channels in the Microsoft-Windows-Dsc Event Log Provider |`n"
      "`t`t`t    TrackDscEvents $([System.Char]39)Status of Operational channel for the Microsoft-Windows-Dsc event log provider$([System.Char]39) {`n"
      "`t`t`t      Channel   = $([System.Char]39)Operational$([System.Char]39)`n"
      "`t`t`t      Status    = $([System.Char]39)Enabled$([System.Char]39)`n"
      "`t`t`t      Ensure    = $([System.Char]39)Present$([System.Char]39)`n"
      "`t`t`t      DependsOn = [System.String[]]@(`n"
      "`t`t`t        $([System.Char]34)[xRegistry]PowerShell 5.1 Transcription 2$([System.Char]34)`n"
      "`t`t`t      )`n"
      "`t`t`t    }`n"
      "`t`t`t    TrackDscEvents $([System.Char]39)Status of Analytic channel for the Microsoft-Windows-Dsc event log provider$([System.Char]39) {`n"
      "`t`t`t      Channel   = $([System.Char]39)Analytic$([System.Char]39)`n"
      "`t`t`t      Status    = $([System.Char]39)Enabled$([System.Char]39)`n"
      "`t`t`t      Ensure    = $([System.Char]39)Present$([System.Char]39)`n"
      "`t`t`t      DependsOn = [System.String[]]@(`n"
      "`t`t`t        $([System.Char]34)[TrackDscEvents]Status of Operational channel for the Microsoft-Windows-Dsc event log provider$([System.Char]34)`n"
      "`t`t`t      )`n"
      "`t`t`t    }`n"
      "`t`t`t    TrackDscEvents $([System.Char]39)Status of Debug channel for the Microsoft-Windows-Dsc event log provider$([System.Char]39) {`n"
      "`t`t`t      Channel   = $([System.Char]39)Debug$([System.Char]39)`n"
      "`t`t`t      Status    = $([System.Char]39)Disabled$([System.Char]39)`n"
      "`t`t`t      Ensure    = $([System.Char]39)Present$([System.Char]39)`n"
      "`t`t`t      DependsOn = [System.String[]]@(`n"
      "`t`t`t        $([System.Char]34)[TrackDscEvents]Status of Analytic channel for the Microsoft-Windows-Dsc event log provider$([System.Char]34)`n"
      "`t`t`t      )`n"
      "`t`t`t    }`n"
      "`t`t`t    #endregion`n"
      "`t`t`t    #region | One-time Generation of New Random %ComputerNames% |`n"
      "`t`t`t    `${Is file with new random %ComputerNames% present at time of MOF compilation} = Test-Path -Path $([System.Char]34)`$Statics\PMs\`$PushServerCname ComputerName.txt$([System.Char]34)`n"
      "`t`t`t    if (-not `${Is file with new random %ComputerNames% present at time of MOF compilation}) {`n"
      "`t`t`t      File $([System.Char]34)New Random ComputerName for primordial Unclustered Hyper-V Host$([System.Char]34) {`n"
      "`t`t`t        DestinationPath = $([System.Char]34)`$Statics\PMs\`$PushServerCname ComputerName.txt$([System.Char]34)`n"
      "`t`t`t        Attributes      = @($([System.Char]39)ReadOnly$([System.Char]39))`n"
      "`t`t`t        Contents        = `$(($([System.Char]39)WIN-$([System.Char]39) + ([System.IO.Path]::GetRandomFileName()) -replace $([System.Char]39)\.$([System.Char]39),$([System.Char]39)$([System.Char]39) -join $([System.Char]39)$([System.Char]39)).ToUpper())`n"
      "`t`t`t        Force           = `$true`n"
      "`t`t`t        Type            = $([System.Char]39)File$([System.Char]39)`n"
      "`t`t`t        Ensure          = $([System.Char]39)Present$([System.Char]39)`n"
      "`t`t`t        DependsOn       = [System.String[]]@(`n"
      "`t`t`t          $([System.Char]34)[TrackDscEvents]Status of Debug channel for the Microsoft-Windows-Dsc event log provider$([System.Char]34)`n"
      "`t`t`t        )`n"
      "`t`t`t      }`n"
      "`t`t`t    }`n"
      "`t`t`t    #region | Rename Computer and Reboot |`n"
      "`t`t`t    if (`${Is file with new random %ComputerNames% present at time of MOF compilation}) {`n"
      "`t`t`t      Computer $([System.Char]34)New Random ComputerName for primordial Unclustered Hyper-V Host$([System.Char]34) {`n"
      "`t`t`t        Name                  = `$(Get-Content -Path $([System.Char]34)`$Statics\PMs\`$PushServerCname ComputerName.txt$([System.Char]34))`n"
      "`t`t`t        Description           = $([System.Char]39)Description TBD$([System.Char]39)`n"
      "`t`t`t        WorkGroupName         = $([System.Char]39)NoNetwork$([System.Char]39)`n"
      "`t`t`t        DependsOn             = [System.String[]]@(`n"
      "`t`t`t          $([System.Char]34)[TrackDscEvents]Status of Debug channel for the Microsoft-Windows-Dsc event log provider$([System.Char]34)`n"
      "`t`t`t        )`n"
      "`t`t`t      }`n"
      "`t`t`t      PendingReboot $([System.Char]34)New Random ComputerName for primordial Unclustered Hyper-V Host$([System.Char]34) {`n"
      "`t`t`t        Name                        = $([System.Char]34)Hostname change on `$PushServerCname leads to Pending Reboot$([System.Char]34)`n"
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
      "`t`t`t    #endregion`n"
      "`t`t`t    #region | Essential Directory Structure |`n"
      "`t`t`t    File $([System.Char]39)Epoch_A__PreDocument_Encryption\Wave_00$([System.Char]39) {`n"
      "`t`t`t      DestinationPath = $([System.Char]34)`$MOFs\Epoch_A__PreDocument_Encryption\Wave_00$([System.Char]34)`n"
      "`t`t`t      Force           = `$true`n"
      "`t`t`t      Type            = $([System.Char]39)Directory$([System.Char]39)`n"
      "`t`t`t      Ensure          = $([System.Char]39)Present$([System.Char]39)`n"
      "`t`t`t      DependsOn       = [System.String[]]@(`n"
      "`t`t`t        #$([System.Char]34)[PendingReboot]New Random ComputerName for primordial Unclustered Hyper-V Host$([System.Char]34)`n"
      "`t`t`t       $([System.Char]34)[TrackDscEvents]Status of Debug channel for the Microsoft-Windows-Dsc event log provider$([System.Char]34)`n"
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
      "`t`t`t    #region | Global Cert Signer |`n"
      "`t`t`t    `${Is CertFSOs Directory present at time of MOF compilation} = Test-Path -Path $([System.Char]34)`$env:DSC_CFG_ROOT\EarlyShare\Self-Signed Certs$([System.Char]34)`n"
      "`t`t`t    if (`${Is CertFSOs Directory present at time of MOF compilation}) {`n"
      "`t`t`t      GlobalCertSignerSeq0 $([System.Char]39)Global Cert Signer$([System.Char]39) {`n"
      "`t`t`t        FriendlyName      =      [System.String]$([System.Char]39)Global Cert Signer$([System.Char]39)`n"
      "`t`t`t        AltSigAlg         =      [System.Boolean]`$true`n"
      "`t`t`t        Ensure            =      [System.String]$([System.Char]39)Present$([System.Char]39)`n"
      "`t`t`t      }`n"
      "`t`t`t      `${Dependency GlobalCertSignerSeq0} = [System.String[]]@(`n"
      "`t`t`t        $([System.Char]34)[GlobalCertSignerSeq0]`$($([System.Char]39)Global Cert Signer$([System.Char]39))$([System.Char]34)`n"
      "`t`t`t      )`n"
      "`t`t`t      #region | Document Encryption Certificate for primordial unclustered Hyper-V host |`n"
      "`t`t`t      `${All Certs in Personal LocalMachine Store} = Get-ChildItem -Path $([System.Char]39)Cert:\LocalMachine\My$([System.Char]39) -Recurse`n"
      "`t`t`t      `${Global Certificate Signing Certificate} = `${All Certs in Personal LocalMachine Store} | Where-Object -FilterScript {`n"
      "`t`t`t        `$_.FriendlyName -eq $([System.Char]39)Global Cert Signer$([System.Char]39)`n"
      "`t`t`t      }`n"
      "`t`t`t      if (`$null -ne `${Global Certificate Signing Certificate}) {`n"
      "`t`t`t        GlobalCodeSignerSeq0 $([System.Char]39)Global Code Signer$([System.Char]39) {`n"
      "`t`t`t          FriendlyName      =      [System.String]$([System.Char]39)Global Code Signer$([System.Char]39)`n"
      "`t`t`t          AltSigAlg         =      [System.Boolean]`$true`n"
      "`t`t`t          Ensure            =      [System.String]$([System.Char]39)Present$([System.Char]39)`n"
      "`t`t`t          DependsOn         =      `${Dependency GlobalCertSignerSeq0}`n"
      "`t`t`t        }`n"
      "`t`t`t        `${Dependency GlobalCodeSignerSeq0} = [System.String[]]@(`n"
      "`t`t`t          $([System.Char]34)[GlobalCodeSignerSeq0]`$($([System.Char]39)Global Code Signer$([System.Char]39))$([System.Char]34)`n"
      "`t`t`t        )`n"
      "`t`t`t        GlobalCertSignerSeq1 $([System.Char]39)Global Cert Signer$([System.Char]39) {`n"
      "`t`t`t          FriendlyName = [System.String]$([System.Char]39)Global Cert Signer$([System.Char]39)`n"
      "`t`t`t          Ensure       = [System.String]$([System.Char]39)Present$([System.Char]39)`n"
      "`t`t`t          DependsOn    = `${Dependency GlobalCertSignerSeq0}`n"
      "`t`t`t        }`n"
      "`t`t`t        `${Dependency GlobalCertSignerSeq1} = [System.String[]]@(`n"
      "`t`t`t          $([System.Char]34)[GlobalCertSignerSeq1]`$($([System.Char]39)Global Cert Signer$([System.Char]39))$([System.Char]34)`n"
      "`t`t`t        )`n"
      "`t`t`t        MofPasswordProtectionSeq0 $([System.Char]34)Encrypt Passwords in MOF for LCM on `$PushServerCname$([System.Char]34) {`n"
      "`t`t`t          FriendlyName      =      [System.String]$([System.Char]34)Encrypt Passwords in MOF for LCM on `$PushServerCname$([System.Char]34)`n"
      "`t`t`t          AltSigAlg         =      [System.Boolean]`$true`n"
      "`t`t`t          Ensure            =      [System.String]$([System.Char]39)Present$([System.Char]39)`n"
      "`t`t`t          DependsOn         =      `${Dependency GlobalCertSignerSeq0}`n"
      "`t`t`t        }`n"
      "`t`t`t      }`n"
      "`t`t`t      #endregion`n"
      "`t`t`t    }`n"
      "`t`t`t    #endregion`n"
      "`t`t`t  }`n"
      "`t`t`t}`n"
      "`t`t`t`$HT = @{`n"
      "`t`t`t  InstanceName = `$InstanceName`n"
      "`t`t`t  OutputPath   = `$lcmHT[$([System.Char]39)OutputPath$([System.Char]39)]`n"
      "`t`t`t  Verbose      = `$true`n"
      "`t`t`t}`n"
      "`t`t`tInvoke-Expression -Verbose:`$true -Command $([System.Char]34)`$InstanceName @HT$([System.Char]34)`n"
      "`t`t`t#Publish-DscConfiguration -CN `$env:ComputerName -Path `$lcmHT[$([System.Char]39)OutputPath$([System.Char]39)] -Force -Verbose:`$true`n"
      "`t`t`tPublish-DscConfiguration -ComputerName $([System.Char]39)localhost$([System.Char]39) -Path `$lcmHT[$([System.Char]39)OutputPath$([System.Char]39)] -Force -Verbose:`$true`n"
      "`t`t`tStart-DscConfiguration -UseExisting -Force -Wait:`$true -Verbose:`$true`n"
      "`t`t"
    ) -join ''
      $XmlWriter.WriteStartElement('File')
        $XmlWriter.WriteAttributeString('path','C:\Windows\Setup\Scripts\HadeanDscConfigurationDocument.ps1')
        $XmlWriter.WriteString(${File HadeanDscConfigurationDocument.ps1 Here-String})
      $XmlWriter.WriteEndElement()
    #endregion

  $XmlWriter.WriteEndElement()
  #endregion

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
                '-NoProfile '
                '-Command '
                [System.Char]34
                "Get-ChildItem"
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
            $XmlWriter.WriteElementString('Description',"set machine-wide execution policy. Why cant this go inside the ExtractScript here-string? Because not every OS instance makes use of ExtractScript!")
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
                "icm -ArgumentList `$xml -ScriptBlock `$sb; "
                $([System.Char]34)
              )
            ))
          $XmlWriter.WriteEndElement()            

          $XmlWriter.WriteStartElement('RunSynchronousCommand') # Scriptblocks within Specialize.ps1 are executed in System context.
            $XmlWriter.WriteElementString('Order',"%_Order_Index_%")
            $XmlWriter.WriteElementString('Description',"Scriptblocks within Specialize.ps1 are executed in System context.")
            $XmlWriter.WriteElementString('Path',$(
              -join @(
                "powershell.exe "
                "-WindowStyle $([System.Char]34)Normal$([System.Char]34) "
                "-NoProfile "
                "-Command "
                $([System.Char]34)
                "Get-Content "
                "-Raw "
                "-Path "
                "$([System.Char]39)C:\Windows\Setup\Scripts\Specialize.ps1$([System.Char]39) "
                "| "
                "Invoke-Expression "
                "-Verbose"
                $([System.Char]34)
              )
            ))
          $XmlWriter.WriteEndElement()

          $XmlWriter.WriteStartElement('RunSynchronousCommand') # Load the HKU\DefaultUser hive...?
            $XmlWriter.WriteElementString('Order',"%_Order_Index_%")
            $XmlWriter.WriteElementString('Description',"Load the HKU\DefaultUser hive. I dont quite know what that means...")
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
                "-WindowStyle $([System.Char]34)Normal$([System.Char]34) "
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
            $XmlWriter.WriteElementString('Description',"Unload the HKU\DefaultUser hive...?")
            $XmlWriter.WriteElementString('Path',$(
              -join @(
                "reg.exe "
                "unload "
                "$([System.Char]34)HKU\DefaultUser$([System.Char]34)"
              )
            ))
          $XmlWriter.WriteEndElement()

          $XmlWriter.WriteStartElement('RunSynchronousCommand') # Disable built-in Administrator account
            $XmlWriter.WriteElementString('Order',"%_Order_Index_%")
            $XmlWriter.WriteElementString('Description',"Disable built-in Administrator account")
            $XmlWriter.WriteElementString('Path',"cmd.exe /c net.exe user Administrator /active:no")
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
        $XmlWriter.WriteElementString('OEMName','ASRock')
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

          $XmlWriter.WriteStartElement('SynchronousCommand') # Wait 15 seconds
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
                "Start-Sleep 15"
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
                "-WindowStyle $([System.Char]34)Normal$([System.Char]34) "
                "-Command "
                $([System.Char]34)
                "Get-Content "
                "-Raw "
                "-Path "
                "$([System.Char]39)C:\Windows\Setup\Scripts\HadeanDscConfigurationDocument.ps1$([System.Char]39) "
                "| "
                "Invoke-Expression "
                "-Verbose"
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
                "-WindowStyle $([System.Char]34)Normal$([System.Char]34) "
                "-Command "
                $([System.Char]34)
                "Get-Content "
                "-Raw "
                "-Path "
                "$([System.Char]39)C:\Windows\Setup\Scripts\HadeanDscConfigurationDocument.ps1$([System.Char]39) "
                "| "
                "Invoke-Expression "
                "-Verbose"
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
                "-WindowStyle $([System.Char]34)Normal$([System.Char]34) "
                "-Command "
                $([System.Char]34)
                "Get-Content "
                "-Raw "
                "-Path "
                "$([System.Char]39)C:\Windows\Setup\Scripts\HadeanDscConfigurationDocument.ps1$([System.Char]39) "
                "| "
                "Invoke-Expression "
                "-Verbose"
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
                "-WindowStyle $([System.Char]34)Normal$([System.Char]34) "
                "-Command "
                $([System.Char]34)
                "Get-Content "
                "-Raw "
                "-Path "
                "$([System.Char]39)C:\Windows\Setup\Scripts\HadeanDscConfigurationDocument.ps1$([System.Char]39) "
                "| "
                "Invoke-Expression "
                "-Verbose"
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
                "-WindowStyle $([System.Char]34)Normal$([System.Char]34) "
                "-Command "
                $([System.Char]34)
                "Get-Content "
                "-Raw "
                "-Path "
                "$([System.Char]39)C:\Windows\Setup\Scripts\HadeanDscConfigurationDocument.ps1$([System.Char]39) "
                "| "
                "Invoke-Expression "
                "-Verbose"
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
                "-WindowStyle $([System.Char]34)Normal$([System.Char]34) "
                "-Command "
                $([System.Char]34)
                "Get-Content "
                "-Raw "
                "-Path "
                "$([System.Char]39)C:\Windows\Setup\Scripts\HadeanDscConfigurationDocument.ps1$([System.Char]39) "
                "| "
                "Invoke-Expression "
                "-Verbose"
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
                "-WindowStyle $([System.Char]34)Normal$([System.Char]34) "
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
                "-WindowStyle $([System.Char]34)Normal$([System.Char]34) "
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
                "-WindowStyle $([System.Char]34)Normal$([System.Char]34) "
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
                "-WindowStyle $([System.Char]34)Normal$([System.Char]34) "
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
                "-WindowStyle $([System.Char]34)Normal$([System.Char]34) "
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
                "-WindowStyle $([System.Char]34)Normal$([System.Char]34) "
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
                "-WindowStyle $([System.Char]34)Normal$([System.Char]34) "
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
                "-WindowStyle $([System.Char]34)Normal$([System.Char]34) "
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
                "-WindowStyle $([System.Char]34)Normal$([System.Char]34) "
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
                "-WindowStyle $([System.Char]34)Normal$([System.Char]34) "
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
                "-WindowStyle $([System.Char]34)Normal$([System.Char]34) "
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
                "-WindowStyle $([System.Char]34)Normal$([System.Char]34) "
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

          #region | pe.cmd investigation |
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
                "cmd.exe /c $([System.Char]34)C:\pe.cmd$([System.Char]34)"
              )
            )); 
          $XmlWriter.WriteEndElement()
          #endregion

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
  Rename-Item -Path "$usb1\autounattend.xml" -NewName "autounattend $(Call-DateVar).xml"
}
# Save XML file to bootable media
$XmlDocument.Save("$usb1\autounattend.xml")
$XmlDocument.Save("$PSScriptRoot\..\..\output\$FolderFQN\usb1\autounattend.xml")
#endregion
