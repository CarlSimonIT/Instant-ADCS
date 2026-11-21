$RemoteDesktopAdmin = $Node.'RDP-Ransomware Deployment Protocol'

if ($null -ne $RemoteDesktopAdmin) {
  if (
    $null -ne $RemoteDesktopAdmin.IsSingleInstance
  ) {
    <#
      Get-DscResourceProperty.ps1 -ModuleName 'ComputerManagementDsc' -ResourceName 'RemoteDesktopAdmin' | clip.exe

      Name                 IsKey Mandatory TypeConstraint  Values
      ----                 ----- --------- --------------  ------
      IsSingleInstance      True      True String          {Yes}
      UserAuthentication   False     False String          {Secure | NonSecure}
      Ensure               False     False String          {Present | Absent}
      PsDscRunAsCredential False     False MSFT_Credential {}
      DependsOn            False     False StringArray     {}
    #>

    RemoteDesktopAdmin $RemoteDesktopAdmin.Resource_Title {
      IsSingleInstance          =        [System.String]$RemoteDesktopAdmin.IsSingleInstance
      #UserAuthentication       =        [System.String]$RemoteDesktopAdmin.UserAuthentication
      Ensure                    =        [System.String]$RemoteDesktopAdmin.Ensure
      PsDscRunAsCredential      =        [PSCredential]$RemoteDesktopAdmin.PsDscRunAsCredential
      DependsOn                 =        ${Dependencys Event Log Channel Status}
    }

    <#
      This configuration will enable Remote Desktop for Administration 
      and set the User Authentication to secure, i.e. to require 
      Network Level Authentication. 

      RemoteDesktopAdmin RemoteDesktopSettings {
        IsSingleInstance   = 'yes'
        Ensure             = 'Present'
        UserAuthentication = 'Secure'
      }
    #>

    ${Dependencys Execution Policy Collection} = [System.String[]]@(
      [System.String]"[RemoteDesktopAdmin]$($RemoteDesktopAdmin.Resource_Title)"
    )
  }
}