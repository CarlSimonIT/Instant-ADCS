<# NOTES |
  ${Ultimate Performance power scheme} = 'e9a42b02-d5df-448d-aa00-03f14749eb61'
  ${High Performance power scheme}  = '8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c'
  We will assume that the 'PowerPlan' DSC Resource only applies when the OS instance has a GUI. 
#>

${Windows Server Image Index} = $Node.'Windows Server Image Index'
if ( # the configuration target runs an edition of Desktop Experience |
  #-not (${Windows Server Image Index} % 2)
  $true
) { # Then set the Power Plan |
  ${Power Plan} = $Node.'Power Plan'
  if ($null -ne ${Power Plan}) {
    if (
      $null -ne ${Power Plan}.IsSingleInstance -and `
      $null -ne ${Power Plan}.Name
    ) {
      <# 
        start msedge.exe 'https://github.com/dsccommunity/ComputerManagementDsc/wiki/PowerPlan'
        Get-DscResourceProperty.ps1 -ModuleName 'ComputerManagementDsc' -ResourceName 'PowerPlan' | clip.exe

        Name                 IsKey Mandatory TypeConstraint  Values
        ----                 ----- --------- --------------  ------
        IsSingleInstance      True      True String          {Yes} 
        Name                 False      True String          {}

        PsDscRunAsCredentia1 False     False MSFT_Credential {}
        DependsOn            False     False StringArray     {}
      #>

      PowerPlan ${Power Plan}.Resource_Title {
        IsSingleInstance              =        [System.String]${Power Plan}.IsSingleInstance
        Name                          =        [System.String]${Power Plan}.Name
        #PsDscRunAsCredential         =        [PSCredential]${Power Plan}.PsDscRunAsCredential
        DependsOn                     =        ${Dependencys Event Log Channel Status}
      }

      ${Dependency Power Plan} = [System.String[]]@(
        "[PowerPlan]$(${Power Plan}.Resource_Title)"
      )
    }
  }
}