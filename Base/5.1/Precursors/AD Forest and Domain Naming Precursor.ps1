#region | AD Forest and Domain Naming |
${NetBIOS Name of Root Domain in AD Forest} = '%_NetBIOS Name of Root Domain in AD Forest_%'
$AD_NetBIOS = ${NetBIOS Name of Root Domain in AD Forest}
${DNS Name of Root Domain in AD Forest} = '%_DNS Name of Root Domain in AD Forest_%'
$AD_DNS = ${DNS Name of Root Domain in AD Forest}
$AD_DN = [System.String]::Join(',',($AD_DNS -split '\.' | % {"DC=$_"}))
${AD Site Name} = '%_AD Site Name_%'
${AD Site A Name} = '%_AD Site A Name_%'
${AD Site B Name} = '%_AD Site B Name_%'
${AD Site C Name} = '%_AD Site C Name_%'
#endregion

