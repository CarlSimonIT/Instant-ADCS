<# NOTE |
  Keep in mind the difference between Time Zone and System Time. 
  Anything important that requires synchronization with other computers should
  use the System Time for calculations and decision making. 
  Time Zones are for human interpretation of data. 

  [System.TimeZoneInfo]::GetSystemTimeZones()
  [System.TimeZoneInfo]::Local.StandardName
#>

$TimeZone = $Node.TimeZone
if ($null -ne $TimeZone) {
  if (
    $null -ne $TimeZone.IsSingleInstance -and `
    $null -ne $TimeZone.TimeZone
  ) {
    <#
      start msedge.exe 'https://github.com/dsccommunity/ComputerManagementDsc/wiki/TimeZone'
      Get-DscResourceProperty.ps1 -ModuleName 'ComputerManagementDsc' -ResourceName 'TimeZone' | clip.exe

      Name                 IsKey Mandatory TypeConstraint  Values
      ----                 ----- --------- --------------  ------
      IsSingleInstance      True      True String          {Yes}
      TimeZone             False      True String          {}

      PsDscRunAsCredentia1 False     False MSFT_Credential {}
      DependsOn            False     False StringArray     {}
    #>

    TimeZone $TimeZone.Resource_Title {
      IsSingleInstance          =     [System.String]$TimeZone.IsSingleInstance
      TimeZone                  =     [System.String]$TimeZone.TimeZone
      #PsDscRunAsCredential     =     [PSCredential]$TimeZone.PsDscRunAsCredential
      DependsOn                 =     ${Dependency Power Plan}
    }

    ${Dependency TimeZone} = [System.String[]]@(
      "[TimeZone]$($TimeZone.Resource_Title)"
    )
  }
}