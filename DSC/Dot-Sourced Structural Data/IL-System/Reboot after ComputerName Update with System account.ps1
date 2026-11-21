${Reboot After Updating %ComputerName%} = $Node.'Reboot After Updating %ComputerName%'
if ($null -ne ${Reboot After Updating %ComputerName%}) {
  if (
    $null -ne ${Reboot After Updating %ComputerName%}.Name
  ) {
    <#
      # See Event Log records if DSC is causing machines to randomly reboot

      Get-DscResourceProperty -ModuleName 'ComputerManagementDsc' -ResourceName 'PendingReboot' | clip.exe    

      Name                        IsKey Mandatory TypeConstraint  Values Range
      ----                        ----- --------- --------------  ------ -----
      Name                         True      True String          {}
      start msedge.exe 'https://github.com/dsccommunity/xPendingReboot/issues/26#issuecomment-487346166'
      SkipCcmClientSDK            False     False Boolean         {}
      SkipComponentBasedServicing False     False Boolean         {}
      SkipPendingComputerRename   False     False Boolean         {}
      SkipPendingFileRename       False     False Boolean         {}
      SkipWindowsUpdate           False     False Boolean         {}

      PsDscRunAsCredentia1        False     False MSFT_Credential {}
      DependsOn                   False     False StringArray     {}
    #>

    PendingReboot ${Reboot After Updating %ComputerName%}.Resource_Title {
      Name                              =       [System.String]${Reboot After Updating %ComputerName%}.Name
      SkipPendingComputerRename         =       [System.Boolean]${Reboot After Updating %ComputerName%}.SkipPendingComputerRename
      SkipCcmClientSDK                  =       [System.Boolean]${Reboot After Updating %ComputerName%}.SkipCcmClientSDK
      SkipComponentBasedServicing       =       [System.Boolean]${Reboot After Updating %ComputerName%}.SkipComponentBasedServicing
      SkipPendingFileRename             =       [System.Boolean]${Reboot After Updating %ComputerName%}.SkipPendingFileRename
      SkipWindowsUpdate                 =       [System.Boolean]${Reboot After Updating %ComputerName%}.SkipWindowsUpdate
      #PsDscRunAsCredential             =       [PSCredential]${Reboot After Updating %ComputerName%}.PsDscRunAsCredential
      DependsOn                         =       ${Dependency ComputerName_Update}
    }

    ${Dependency Reboot After Updating %ComputerName%} = [System.String[]]@(
      "[PendingReboot]$(${Reboot After Updating %ComputerName%}.Resource_Title)"
    )
  }
}