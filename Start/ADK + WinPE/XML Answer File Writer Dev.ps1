#region | Investigative Prepare_XML_Files |
${Node Configuration Hashtables} = $ConfigurationData.AllNodes.Where({$_.SubEmpire -eq 'Windows Server'})
foreach (${Node Configuration Hashtable} in ${Node Configuration Hashtables}) {
}
# ConvertTo-HereStringCompatible.ps1
#region | Password Removal: 'HyperV OS Deploy' |
<#
  $XmlDocument = [System.Xml.XmlDocument](Get-Content -Path "$OSDeploy\autounattend.xml" -ReadCount -1)
  $un = 'HyperV OS Deploy'
  $XmlDocument.unattend.settings `
  | Where-Object -FilterScript {$_.Pass -eq 'oobeSystem'} `
  | Select-Object -ExpandProperty 'component' `
  | Where-Object -FilterScript {$_.Name -eq "Microsoft-Windows-Shell-Setup"} `
  | Select-Object -ExpandProperty 'UserAccounts' `
  | Select-Object -ExpandProperty 'LocalAccounts' `
  | Select-Object -ExpandProperty 'LocalAccount' `
  | ForEach-Object -Process {
    $_.Password.Value = ''
  }

  $XmlDocument.unattend.settings `
  | Where-Object -FilterScript {$_.Pass -eq 'oobeSystem'} `
  | Select-Object -ExpandProperty 'component' `
  | Where-Object -FilterScript {$_.Name -eq "Microsoft-Windows-Shell-Setup"} `
  | Select-Object -ExpandProperty 'AutoLogon' `
  | ForEach-Object -Process {
    $_.Password.Value = ''
    $_.LogonCount     = '0'
  }

  $XmlDocument.ChildNodes[0].Encoding = $null
  ${Samsung BAR Plus 64 GB Disk Red} = (Get-Disk).Where({($_.FriendlyName -eq 'Samsung Flash Drive') -and ($_.SerialNumber -match 'AA00000000000489') -and ($_.UniqueId -match [System.Text.RegularExpressions.Regex]::Escape('USBSTOR\DISK&VEN_SAMSUNG&PROD_FLASH_DRIVE&REV_1100\0317923110003028&0'))}); if (${Samsung BAR Plus 64 GB Disk Red}.Count -ne 0) {${Samsung BAR Plus 64 GB Partition Red} = Get-Partition -DiskNumber ${Samsung BAR Plus 64 GB Disk Red}.Number | Sort-Object Size -Descending | Select-Object -First 1; ${Samsung BAR Plus 64 GB Vol Red} = [System.String]${Samsung BAR Plus 64 GB Partition Red}.DriveLetter + ":"; $global:OSDeploy = ${Samsung BAR Plus 64 GB Vol Red}}; ; Write-Host -Object "`r`n`t`$OSDeploy = $OSDeploy`r`n"
  $XmlDocument.Save("$OSDeploy\autounattend.xml")
#>
#endregion
#endregion




