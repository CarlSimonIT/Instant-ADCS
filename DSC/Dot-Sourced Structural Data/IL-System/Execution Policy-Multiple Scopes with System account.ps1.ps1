${Execution Policy Collection} = $Node.'Execution Policy Collection'
${Dependencys Execution Policy Collection} = [System.Collections.ArrayList]::New()

foreach (${Execution Policy} in ${Execution Policy Collection}) {
  if (
    $null -ne ${Execution Policy}.ExecutionPolicyScope -and `
    $null -ne ${Execution Policy}.ExecutionPolicy
  ) {
    <#
      Get-DscResourceProperty.ps1 -ModuleName 'ComputerManagementDsc' -ResourceName 'PowerShellExecutionPolicy' | clip.exe

      Name                 IsKey Mandatory TypeConstraint  Values
      ----                 ----- --------- --------------  ------
      ExecutionPolicyScope  True      True String          {CurrentUser | LocalMachine | MachinePolicy | Process | UserPolicy}
      ExecutionPolicy      False      True String          {AllSigned | Bypass | RemoteSigned | Restricted | Unrestricted}
      PsDscRunAsCredentia1 False     False MSFT_Credential {}
      DependsOn            False     False StringArray     {}
    #>

    PowerShellExecutionPolicy ${Execution Policy}.Resource_Title {
      ExecutionPolicyScope      =       [System.String]${Execution Policy}.ExecutionPolicyScope
      ExecutionPolicy           =       [System.String]${Execution Policy}.ExecutionPolicy
      #PsDscRunAsCredential     =       [PSCredential]${Execution Policy}.PsDscRunAsCredential
      DependsOn                 =       ${Dependencys Event Log Channel Status}
    }

    <#
      # Example 1
      PowerShellExecutionPolicy ExecutionPolicy {
        ExecutionPolicyScope = 'CurrentUser'
        ExecutionPolicy      = 'RemoteSigned'
      }
      # Example 2
      PowerShellExecutionPolicy ExecutionPolicyCurrentUser {
        ExecutionPolicyScope = 'CurrentUser'
        ExecutionPolicy      = 'RemoteSigned'
      }
      PowerShellExecutionPolicy ExecutionPolicyLocalMachine {
        ExecutionPolicyScope = 'LocalMachine'
        ExecutionPolicy      = 'RemoteSigned'
      }
    #>

    ${Dependencys Execution Policy Collection}.Add(
      [System.String]"[PowerShellExecutionPolicy]$(${Execution Policy}.Resource_Title)"
    ) | Out-Null
  }
}
