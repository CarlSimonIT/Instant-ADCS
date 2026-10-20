#Requires -Version 5.1
#Requires -PSEdition Desktop


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




$FolderFQN = Import-CliXml -Path "$PSScriptRoot\..\.CommonItems\FolderFQN.clixml"
. "$PSScriptRoot\output\$FolderFQN\usb1\$FolderFQN\Base\5.1\External Bootable Media Drive Letters.ps1"

${OSDeploy Disk CIM Instance} = Get-Disk | Where-Object -FilterScript {
  $_.FriendlyName -eq    ${OSDeploy FriendlyName}                                             -and `
  $_.UniqueId     -match [System.Text.RegularExpressions.Regex]::Escape(${OSDeploy UniqueId}) -and `
  $_.SerialNumber -eq    ${OSDeploy SerialNumber}
}
${OSDeploy Disk CIM Instance} | Get-Partition



# Dism.exe /Mount-Wim /WimFile:"$ns\reimages\${Windows 11 PreMount}\sources\install.wim" /Index:${Windows 11 Image Index} /MountDir:"$ns\reimages\m0un7ed_wlm"
# Dism.exe /Image:"$ns\reimages\m0un7ed_wlm" /Add-Package /PackagePath:$PackageDirectory

