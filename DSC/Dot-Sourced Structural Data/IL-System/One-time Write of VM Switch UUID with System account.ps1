${VM Switch UUID .txt Files} = $Node.'VM Switch UUID .txt Files'
if ($null -ne ${VM Switch UUID .txt Files}) {
  foreach (${VM Switch UUID .txt File} in ${VM Switch UUID .txt Files}) {
    ${Is vSwitch UUID Already Defined} = Test-Path -Path ${VM Switch UUID .txt File}.DestinationPath
    if (-not ${Is vSwitch UUID Already Defined}) {
      File ${VM Switch UUID .txt File}.Resource_Title {
        DestinationPath        =  [System.String]${VM Switch UUID .txt File}.DestinationPath
        Type                   =  [System.String]${VM Switch UUID .txt File}.Type
        Attributes             =  [System.String[]]${VM Switch UUID .txt File}.Attributes
        Contents               =  [System.String]$(
          [System.Guid]::NewGuid() | Select-Object -ExpandProperty 'Guid'
        )
        Force                  =  [System.Boolean]${VM Switch UUID .txt File}.Force
        #Credential            =  [PSCredential]${VM Switch UUID .txt File}.Credential
        Ensure                 =  [System.String]${VM Switch UUID .txt File}.Ensure
        #PsDscRunAsCredential  =  [PSCredential]${VM Switch UUID .txt File}.PsDscRunAsCredential
        DependsOn              =  ${Dependencys Event Log Channel Status}
      }
    }
  }
}