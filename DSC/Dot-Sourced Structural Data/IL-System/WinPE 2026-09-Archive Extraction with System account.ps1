${WinPE 2026-09-Archive Extraction} = $Node.'WinPE 2026-09-Archive Extraction'
if ($null -ne ${WinPE 2026-09-Archive Extraction}) {
  if (
    $null -ne ${WinPE 2026-09-Archive Extraction}.Destination -and `
    $null -ne ${WinPE 2026-09-Archive Extraction}.Path
  ) {
    <#
      start msedge.exe 'https://github.com/dsccommunity/xPSDesiredStateConfiguration/wiki/xArchive'
      Get-DscResourceProperty.ps1 -ModuleName 'xPSDesiredStateConfiguration' -ResourceName 'xArchive' | clip.exe

      Name                 IsKey Mandatory TypeConstraint  Values
      ----                 ----- --------- --------------  ------
      Destination           True      True String          {}
      Path                  True      True String          {}

      Checksum             False     False String          {CreatedDate | ModifiedDate | SHA-1 | SHA-256 | SHA-512}
      Force                False     False Boolean         {}
      Validate             False     False Boolean         {}

      Credentia1           False     False MSFT_Credential {}
      Ensure               False     False String          {Present | Absent}
      PsDscRunAsCredentia1 False     False MSFT_Credential {}
      DependsOn            False     False StringArray     {}
    #>

    xArchive ${WinPE 2026-09-Archive Extraction}.Resource_Title {
      Destination                 =        [System.String]${WinPE 2026-09-Archive Extraction}.Destination
      Path                        =        [System.String]${WinPE 2026-09-Archive Extraction}.Path
      Checksum                    =        [System.String]${WinPE 2026-09-Archive Extraction}.Checksum   # Omitted because of time constraints
      Force                       =        [System.Boolean]${WinPE 2026-09-Archive Extraction}.Force
      Validate                    =        [System.Boolean]${WinPE 2026-09-Archive Extraction}.Validate  # Omitted because of time constraints
      #Credential                 =        [PSCredential]${WinPE 2026-09-Archive Extraction}.Credential
      Ensure                      =        [System.String]${WinPE 2026-09-Archive Extraction}.Ensure
      #PsDscRunAsCredential       =        [PSCredential]${WinPE 2026-09-Archive Extraction}.PsDscRunAsCredential
      DependsOn                   =        ${Dependencys Event Log Channel Status}
    }


    ${Dependency Extract WinPE Installation Files} = [System.String[]]@(
      "[xArchive]$(${WinPE 2026-09-Archive Extraction}.Resource_Title)"
    )
  }
}