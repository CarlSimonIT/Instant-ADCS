
#region | Download, but do not install, DSC Resource Modules |

#     ${DSC Resource Module HT ArrayList} = []
${DSC Resource Module} = @{
  Name = 'ActiveDirectoryCSDsc'
  Version = '5.1.0-preview0005'
}

$WebPath = "https://www.powershellgallery.com/packages/$(${DSC Resource Module}['Name'])/$(${DSC Resource Module}['Version'])"
$FilePath
Invoke-WebRequest -Uri $WebPath -OutFile $FilePath
start msedge.exe 'https://www.powershellgallery.com/packages/ActiveDirectoryCSDsc/5.1.0-preview0005#manual-download'

<#

  $CloningRepoPath = "$env:UserProfile\GitHub\CarlSimonIT"; $CloningRepoFolder = try {Get-Item -Path $CloningRepoPath -ErrorAction 'Stop'} catch {New-Item -Path $CloningRepoPath -ItemType 'Directory' -Force}; Set-Location -Path "$CloningRepoFolder"; $GitHubRepositoryName = 'Instant-ADCS'; Set-Location -Path ".\$GitHubRepositoryName"; 
  $path = '.\Base\5.1\Static\DSC Resource Module Downloads from PowerShell Gallery.ps1'; $file = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'File' -Force}


  'https://learn.microsoft.com/en-us/powershell/gallery/how-to/working-with-packages/manual-download?view=powershellget-3.x'
  'https://learn.microsoft.com/en-us/powershell/gallery/how-to/working-with-packages/manual-download?view=powershellget-3.x'

  . "C:\Users\lowpr\GitHub\CarlSimonIT\Instant-ADCS\output\Instant-ADCS\usb1\Instant-ADCS\Base\5.1\External Storage Media Drive Letters.ps1"
  Get-ChildItem -Path "D:\cfg\Preboots\dsc0\Modules" -File -Filter '*.zip' | ForEach-Object -Process {$_.BaseName} | Set-Clipboard
  ActiveDirectoryCSDsc
  ActiveDirectoryDsc
  AdHocCertsDsc
  AdHocNetsDsc
  AdHocPkiDsc
  AdHocUtilsDsc
  cDhcpServerDynamicUpdate
  CertificateDsc
  cHyper-V
  ComputerManagementDsc
  DhcpServerDsc
  DnsServerDsc
  DSCR_Shortcut
  GroupPolicyDsc
  HyperVDsc
  JeaDsc
  NetworkingDsc
  PolicyFileEditor
  PowerShellModule
  StorageDsc
  WdsDsc
  WebAdministrationDsc
  WmiNamespaceSecurity
  WSManDsc
  xCIMSecurity
  xComputerManagement
  xDscDiagnostics
  xPSDesiredStateConfiguration

  Save-Module
  
  $Path = ''
  Save-Module -Name ${DSC Resource Module Name} -Path  -Repository 'PSGallery' -MinimumVersion -MaximumVersion -RequiredVersion -Proxy -ProxyCredential -Credential -Force -WhatIf -Confirm

  $ModName = 'ActiveDirectoryCSDsc';         Safely-InstallModule -ModName $ModName
  # DOCUMENTATION IS COMPLETE SHIT. 
  # Visit 'https://www.powershellgallery.com/packages/ActiveDirectoryCSDsc/5.1.0-preview0005'
  # Hit Manual Download tab
  # Download the raw .nupkg file
  # Extract the .nupkg with 7-zip into "$env:ProgramFiles\WindowsPowerShell\Modules\ActiveDirectoryCSDsc\5.1.0"
  $path = "$env:ProgramFiles\WindowsPowerShell\Modules\$ModName\6.7.2"; $dir = try {Get-Item -Path $path -ErrorAction 'Stop'} catch {New-Item -Path $path -ItemType 'Directory' -Force}
  . "$env:ProgramFiles\7-Zip\7z.exe" x "$env:SystemDrive\Users\${explorer.exe Owner}\Downloads\activedirectorycsdsc.5.1.0-preview0005.nupkg" -o"$path"









  Get-ChildItem -Path "D:\cfg\Preboots\dsc0\Modules" -File -Filter '*.nupkg' | ForEach-Object -Process {$_.BaseName} | Set-Clipboard
  activedirectorycsdsc.5.1.0-preview0005
  ''
  @{

  }




  $ArgumentList = @(
    "https://www.powershellgallery.com/packages/ActiveDirectoryCSDsc/5.1.0-preview0005"
    "$folder\adkwinpesetup.exe"
    $ProgressPreference
  )

  Start-Job -Name $JobName -ArgumentList $ArgumentList -ScriptBlock {
    $WebPath                    = $args[0]
    $FilePath                   = $args[1]
    $OriginalProgressPreference = $args[2]

    $ProgressPreference = 'SilentlyContinue'
    Invoke-WebRequest -Uri $WebPath -OutFile $FilePath
    $ProgressPreference = $OriginalProgressPreference
  } | Out-Null






  activedirectorydsc.6.7.2-preview0001
  certificatedsc.6.1.0-preview0002
  hypervdsc.4.0.0-preview0005
  hypervdsc.4.0.0-preview0006
  jeadsc.4.0.0-preview0005
  webadministrationdsc.4.2.2-preview0001

  https://www.powershellgallery.com/packages/ComputerManagementDsc/10.0.1-preview0003








#>
#endregion

