#region | Detect Removable External Storage Media |
#region | Patterns |
#${Pattern UniqueId Raw-OLD} = '^(?<Unique_ID>.+)\:(?<Computer_Name>(?!(\d{1,15}|ANONYMOUS|BATCH|BUILTIN|DIALUP|DOMAIN|ENTERPRISE|INTERACTIVE|INTERNET|LOCAL|NETWORK|NULL|PROXY|RESTRICTED|SELF|SERVER|SERVICE|SYSTEM|USERS|WORLD)$)[a-z0-9][a-z0-9-]{1,13}[a-z0-9])$'
${Pattern UniqueId Raw} = '^(?<Unique_ID>.+)(\:)?$'
#endregion
#region | Save to variable the volume letter of the external bootable media |
${OSDeploy FriendlyName} = '%_OSDeploy FriendlyName_%'
${OSDeploy UniqueId Raw} = '%_OSDeploy UniqueId Raw_%'
${OSDeploy UniqueId Raw} -match ${Pattern UniqueId Raw} | Out-Null
${OSDeploy UniqueId} = $Matches['Unique_ID']
${OSDeploy SerialNumber} = '%_OSDeploy SerialNumber_%'

$disk = Get-Disk | Where-Object -FilterScript {
  $_.FriendlyName -eq    ${OSDeploy FriendlyName}                                             -and `
  $_.UniqueId     -match [System.Text.RegularExpressions.Regex]::Escape(${OSDeploy UniqueId}) -and `
  $_.SerialNumber -eq    ${OSDeploy SerialNumber}
}
if ($null -ne $disk) {
  $partition = Get-Partition -DiskNumber $disk.Number | Select-Object -First 1
  $OSDeploy = [System.String]$partition.DriveLetter + ":"
}
#endregion
#endregion

