#Requires -Version 5.1
#Requires -PSEdition Desktop



'https://go.microsoft.com/fwlink/?linkid=2268830&clcid=0x409&culture=en-us&country=us'
'https://www.microsoft.com/en-us/evalcenter/evaluate-windows-server-2025'
start msedge.exe 'https://go.microsoft.com/fwlink/?linkid=2345730&clcid=0x409&culture=en-us&country=us'
'https://www.microsoft.com/en-us/evalcenter/download-windows-server-2025?msockid=1dbd6c8bbd85672a1985788bbc2d66b4'

$ModName = 'CertificateDsc'
$path = "$NoSync\$ModName"; $dir = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
$WebPath = "https://raw.githubusercontent.com/dsccommunity/$ModName/refs/heads/main/build.ps1"
$FilePath = "$dir\build.ps1"
Invoke-WebRequest -Uri $WebPath -OutFile $FilePath -UseBasicParsing
code $FilePath
'https://gist.github.com/vinhjaxt/a774ac87b0313a34f4c445048d8e13cf?permalink_comment_id=5295475'

<#
  Here is the Windows Server 2025 direct ISO download links (from Microsoft evaluation site)
  start msedge.exe 'https://go.microsoft.com/fwlink/?linkid=2293312&clcid=0x409&culture=en-us&country=us'
  start msedge.exe 'https://software-static.download.prss.microsoft.com/dbazure/888969d5-f34g-4e03-ac9d-1f9786c66749/26100.1742.240906-0331.ge_release_svc_refresh_SERVER_EVAL_x64FRE_en-us.iso'
#>

start msedge.exe 'https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/invoke-webrequest?view=powershell-5.1'
start msedge.exe 'https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.utility/invoke-webrequest?view=powershell-7.6'

$FolderFQN = 'Instant-ADCS'
#   $FolderFQN = Import-CliXml -Path "$PSScriptRoot\..\..\..\.CommonItems\FolderFQN.clixml"
$path = "$env:UserProfile\GitHub\CarlSimonIT\.CommonItems\usb0\$FolderFQN\Microsoft\OS\Server 25\Original"
$folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
${Latest Server 2025} = '26100.32230.260111-0550.lt_release_svc_refresh_SERVER_EVAL_x64FRE_en-us'
$WebPath = 'https://go.microsoft.com/fwlink/?linkid=2293312&clcid=0x409&culture=en-us&country=us'
$FilePath = "$folder\${Latest Server 2025}.iso"
Invoke-WebRequest -Uri $WebPath -OutFile $FilePath






# Speed up slow Invoke-WebRequest: 
## Google Search:       Invoke-WebRequest slow download speed -noai
start msedge.exe 'https://rostacik.net/2022/07/28/how-to-speed-up-powershell-invoke-webrequest/'
$OriginalProgressPreference = $ProgressPreference
$ProgressPreference = 'SilentlyContinue'

$FolderFQN = 'Instant-ADCS'
$path = "$env:UserProfile\GitHub\CarlSimonIT\.CommonItems\usb0\$FolderFQN\cfg\installs\Windows ADK 2026-09"
$folder = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
$WebPath = ''
$FilePath = "$folder\adksetup.exe"
Invoke-WebRequest -Uri $WebPath -OutFile $FilePath



$ProgressPreference = $OriginalProgressPreference