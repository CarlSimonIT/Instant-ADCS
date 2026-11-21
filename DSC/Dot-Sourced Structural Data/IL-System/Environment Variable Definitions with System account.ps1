${Environment Variable Definitions} = $ConfigurationData.GCD.'Environment Variable Definitions'

if ($null -ne ${Environment Variable Definitions}) {
  ${Dependencys Environment Variable Definitions} = [System.Collections.ArrayList]::new()
  foreach ($i in 0..(${Environment Variable Definitions}.Count - 1)) {
    $Resource_Title_Precursor = [System.String]${Environment Variable Definitions}[$($foreach.Current)].Name + '__' + [System.String]$($foreach.Current)
    $Resource_Title = $Resource_Title_Precursor -replace '[^a-z0-9- _\.]','\'
    xEnvironment $Resource_Title {
      Name                        =      [System.String]${Environment Variable Definitions}[$($foreach.Current)].Name
      Ensure                      =      [System.String]${Environment Variable Definitions}[$($foreach.Current)].Ensure
      Path                        =      [System.Boolean]${Environment Variable Definitions}[$($foreach.Current)].IsPath
      Value                       =      [System.String]${Environment Variable Definitions}[$($foreach.Current)].Value
      #PsDscRunAsCredential       =      [PSCredential]$Node.'Environment Variable Definitions Credential'.PsDscRunAsCredential
      DependsOn                   =      ${Dependencys Event Log Channel Status}
    }
    # [System.Void]$foreach.MoveNext()
    ${Dependencys Environment Variable Definitions}.Add(
      [System.String]"[xEnvironment]$($Resource_Title)"
    ) | Out-Null
  }
}


<# xEnvironment | Environment |
  Name                 IsKey Mandatory TypeConstraint  Values
  ----                 ----- --------- --------------  ------
  Name                  True      True String          {}

  Path                 False     False Boolean         {}
  Target               False     False StringArray     {Process, Machine}
  Value                False     False String          {}

  Ensure               False     False String          {Present, Absent}
  PsDscRunAsCredentia1 False     False MSFT_Credential {}
  DependsOn            False     False StringArray     {}
#>