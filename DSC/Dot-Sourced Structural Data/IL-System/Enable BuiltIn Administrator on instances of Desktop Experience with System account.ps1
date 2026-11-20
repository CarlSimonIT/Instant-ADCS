<# Explanations |
  Launching a process in an elevated security context on a remote computer via PowerShell Remoting is
  not possible if the target machine is running the Desktop Experience edition of Windows Server. Neither
  the Integrity Level of the local client PowerShell process, nor whether the account local to the remote 
  computer holds membership in that computer's local Administrators group affect this default behavior. 

  The full explanation is beyond my current understanding. Something about security tokens, and one gets
  stripped away, I don't know.  

  A frequently implemented but unacceptable workaround is to disable Admin Approval Mode on the remoting target.
  Disabling Admin Approval Mode is a system-wide change that bypasses the UAC security check whenever a member 
  of the '.\Administrators' group attempts to launch a process at Integrity Level-High or above. Online articles 
  and videos routinely present disabling Admin Approval Mode on the remote computer as the solution whenever a
  user at the local client computer is unable to run a program "As Admin". While this doesn't count as terrible 
  advice, a better choice is available. 
  
  The alternate pathway to running elevated commands on remote machines is to authenticate into the remoting target 
  with the username & password of the remote machine's Administrator account (e.g., 'SERVER01\Administrator'). 
  Windows OS exempts the built-in Administrator account from Admin Approval Mode, which is the reason a UAC chall-
  enge never appears when the user is logged in as Administrator and starts a program "As Admin".
  
  Considering the above, this project enables the built-in Administrator account on the AD Forest Creator (required
  for an Active Directory environment) and any instance of Windows Server running Desktop Experience. 

  NOTE: This restriction is not present on remote instances of Server Core. 
#>
${Windows Server Image Index} = $Node.'Windows Server Image Index'
if ( # the configuration target (is NOT the DC) -AND- (runs an edition of Desktop Experience) |
  (
    $Node.NodeMgmtCname -ne ${AD Forest Creator Mgmt Cname}
  ) -and `
  (
    -not (${Windows Server Image Index} % 2)
  )  
) { # Then enable the built-in Administrator account |
  ${Built-In Administrator Account} = $Node.'Built-In Administrator Account'
  if ($null -ne ${Built-In Administrator Account}) {
    xUser ${Built-In Administrator Account}.Resource_Title {
      UserName                    =    [System.String]${Built-In Administrator Account}.UserName
      FullName                    =    [System.String]${Built-In Administrator Account}.FullName
      Password                    =    [PSCredential]${Built-In Administrator Account}.Password
      Description                 =    [System.String]${Built-In Administrator Account}.Description
      Disabled                    =    [System.Boolean]${Built-In Administrator Account}.Disabled
      PasswordChangeNotAllowed    =    [System.Boolean]${Built-In Administrator Account}.PasswordChangeNotAllowed
      PasswordChangeRequired      =    [System.Boolean]${Built-In Administrator Account}.PasswordChangeRequired
      PasswordNeverExpires        =    [System.Boolean]${Built-In Administrator Account}.PasswordNeverExpires
      Ensure                      =    [System.String]${Built-In Administrator Account}.Ensure
      #PsDscRunAsCredential       =    [PSCredential]${Built-In Administrator Account}.PsDscRunAsCredential
      DependsOn                   =    ${Dependencys Event Log Channel Status}
    }

    <#
      start msedge.exe 'https://github.com/dsccommunity/xPSDesiredStateConfiguration/wiki/xUser'
      Get-DscResourceProperty -ModuleName 'xPSDesiredStateConfiguration' -ResourceName 'xUser' | clip.exe

      Name                     IsKey Mandatory TypeConstraint  Values
      ----                     ----- --------- --------------  ------
      UserName                  True      True String          {}

      Description              False     False String          {}
      Disabled                 False     False Boolean         {}
      FullName                 False     False String          {}
      Password                 False     False MSFT_Credential {}
      PasswordChangeNotAllowed False     False Boolean         {}
      PasswordChangeRequired   False     False Boolean         {}
      PasswordNeverExpires     False     False Boolean         {}

      Ensure                   False     False String          {Present, Absent}
      PsDscRunAsCredentia1     False     False MSFT_Credential {}
      DependsOn                False     False StringArray     {}
    #>
  }
}

if ($Node.NodeMgmtCname -eq ${AD Forest Creator Mgmt Cname}) {
  <#
    ALWAYS enable the default built-in domain Administrator
    account on the machine that creates the AD Forest, regardless
    of whether the OS instance is Server Core or Desktop Experience. 
  #>

  xUser $Node.'Built-In Administrator Account'.Resource_Title {
    UserName                      =       [System.String]$Node.'Built-In Administrator Account'.UserName
    FullName                      =       [System.String]$Node.'Built-In Administrator Account'.FullName
    Password                      =       [PSCredential]$Node.'Built-In Administrator Account'.Password
    Description                   =       [System.String]$Node.'Built-In Administrator Account'.Description
    Disabled                      =       [System.Boolean]$Node.'Built-In Administrator Account'.Disabled
    PasswordChangeNotAllowed      =       [System.Boolean]$Node.'Built-In Administrator Account'.PasswordChangeNotAllowed
    PasswordChangeRequired        =       [System.Boolean]$Node.'Built-In Administrator Account'.PasswordChangeRequired
    PasswordNeverExpires          =       [System.Boolean]$Node.'Built-In Administrator Account'.PasswordNeverExpires
    Ensure                        =       [System.String]$Node.'Built-In Administrator Account'.Ensure
    #PsDscRunAsCredential         =       [PSCredential]$Node.'Built-In Administrator Account'.PsDscRunAsCredential
    DependsOn                     =       ${Dependencys Event Log Channel Status}
  }
}