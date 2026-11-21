${%ComputerName% Update} = $Node.'%ComputerName% Update'
if ($null -ne ${%ComputerName% Update}) {
  if (
    $null -ne ${%ComputerName% Update}.Name
  ) {
    <#
      Get-DscResourceProperty -ModuleName 'xComputerManagement' -ResourceName 'xComputer' | clip.exe

      Name                 Mandatory IsKey TypeConstraint
      ----                 --------- ----- --------------
      Name                      True  True String
      Description              False False String
      DomainName               False False String
      JoinOU                   False False String
      UnjoinCredential         False False MSFT_Credential
      WorkGroupName            False False String

      Credentia1               False False MSFT_Credential
      PsDscRunAsCredentia1     False False MSFT_Credential
      DependsOn                False False StringArray
    #>

    xComputer ${%ComputerName% Update}.Resource_Title {
      Name                        =       [System.String]${%ComputerName% Update}.Name
      Description                 =       [System.String]${%ComputerName% Update}.Description
      WorkGroupName               =       [System.String]'NETW0RK'
      #Credential                 =       [PSCredential]${%ComputerName% Update}.Credential
      #PsDscRunAsCredential       =       [PSCredential]${%ComputerName% Update}.PsDscRunAsCredential
      DependsOn                   =       ${Dependencys Event Log Channel Status}
    }

    ${Dependency %ComputerName% Update} = [System.String[]]@(
      "[xComputer]$(${%ComputerName% Update}.Resource_Title)"
    )
  }
}