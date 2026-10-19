#region | Detect Removable External Storage Media |
#region | Patterns |
${Pattern UniqueId Raw} = '^(?<Unique_ID>[^:]+)(?<Discarded>\:.*)?$'
#endregion
#region | Save to variable the volume letter of the external bootable media |
${OSDeploy FriendlyName} = '%_OSDeploy FriendlyName_%'
${OSDeploy UniqueId Raw} = '%_OSDeploy UniqueId Raw_%'
${OSDeploy UniqueId Raw} -match ${Pattern UniqueId Raw} | Out-Null
${OSDeploy UniqueId} = $Matches['Unique_ID']
${OSDeploy SerialNumber} = '%_OSDeploy SerialNumber_%'

${OSDeploy Disk CIM Instance} = Get-Disk | Where-Object -FilterScript {
  $_.FriendlyName -eq    ${OSDeploy FriendlyName}                                             -and `
  $_.UniqueId     -match [System.Text.RegularExpressions.Regex]::Escape(${OSDeploy UniqueId}) -and `
  $_.SerialNumber -eq    ${OSDeploy SerialNumber}
}



<#



  if ($null -ne ${OSDeploy Disk CIM Instance}) {
    ${Volume DriveLetters Precursor} = Get-Partition -DiskNumber ${OSDeploy Disk CIM Instance}.Number | Get-Volume | Select-Object -ExpandProperty 'DriveLetter'
    foreach (${Volume DriveLetter Precursor} in ${Volume DriveLetters Precursor}) {
      ${Volume DriveLetter} = [System.String]${Volume DriveLetter Precursor} + ':'
      $IsWindowsOS = Test-Path -Path "${Volume DriveLetter}\setup.exe"
      if ($IsWindowsOS) {
        $OSDeploy = ${Volume DriveLetter}
      }
    }
  }



#>



#endregion

#endregion

