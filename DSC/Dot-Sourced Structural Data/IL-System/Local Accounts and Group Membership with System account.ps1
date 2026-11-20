${Dependencys Local User Accounts} = [System.Collections.ArrayList]::New()
${Local User Accounts} = $Node.'Local User Accounts'
if ($null -ne ${Local User Accounts}) {
  foreach (${Local User Account} in ${Local User Accounts}) {

    <#
      start msedge.exe 'https://github.com/dsccommunity/xPSDesiredStateConfiguration/wiki/xUser'
      Get-DscResourceProperty.ps1 -ModuleName 'xPSDesiredStateConfiguration' -ResourceName 'xUser' | clip.exe

      Name                     IsKey Mandatory TypeConstraint  Values
      ----                     ----- --------- --------------  ------
      UserName                  True      True String          {}

      Description              False     False String          {}
      Disabled                 False     False Boolean         {}
      FullName                 False     False String          {}
      Passw0rd                 False     False MSFT_Credential {}
      Passw0rdChangeNotAllowed False     False Boolean         {}
      Passw0rdChangeRequired   False     False Boolean         {}
      Passw0rdNeverExpires     False     False Boolean         {}

      Ensure                   False     False String          {Present | Absent}
      PsDscRunAsCredentia1     False     False MSFT_Credential {}
      DependsOn                False     False StringArray     {}
    #>

    xUser ${Local User Account}.Resource_Title {
      UserName                 = [System.String]${Local User Account}.UserName
      FullName                 = [System.String]${Local User Account}.FullName
      Password                 = [PSCredential]${Local User Account}.Password
      Description              = [System.String]${Local User Account}.Description
      Disabled                 = [System.Boolean]${Local User Account}.Disabled
      PasswordChangeNotAllowed = [System.Boolean]${Local User Account}.PasswordChangeNotAllowed
      PasswordChangeRequired   = [System.Boolean]${Local User Account}.PasswordChangeRequired
      PasswordNeverExpires     = [System.Boolean]${Local User Account}.PasswordNeverExpires
      Ensure                   = [System.String]${Local User Account}.Ensure
      #PsDscRunAsCredential    = [PSCredential]${Local User Account}.PsDscRunAsCredential
      DependsOn                = ${Dependencys Strict PowerShell 5.1 Trackers}
    }

    ${Dependencys Local User Accounts}.Add(
      [System.String]"[xUser]$(${Local User Account}.Resource_Title)"
    ) > $null
  }
}

${Dependencys Local Groups} = [System.Collections.ArrayList]::New()
${Local Groups} = $Node.'Local Groups'
if ($null -ne ${Local Groups}) {
  foreach (${Local Group} in ${Local Groups}) {
    <#
      start msedge.exe 'https://github.com/dsccommunity/xPSDesiredStateConfiguration/wiki/xGroup'
      Get-DscResourceProperty.ps1 -ModuleName 'xPSDesiredStateConfiguration' -ResourceName 'xGroup' | clip.exe

      Name                 IsKey Mandatory TypeConstraint  Values
      ----                 ----- --------- --------------  ------
      GroupName             True      True String          {}

      Description          False     False String          {}
      Members              False     False StringArray     {}
      MembersToExclude     False     False StringArray     {}
      MembersToInclude     False     False StringArray     {}

      Credentia1           False     False MSFT_Credential {}
      Ensure               False     False String          {Present | Absent}
      PsDscRunAsCredentia1 False     False MSFT_Credential {}
      DependsOn            False     False StringArray     {}
    #>

    xGroup ${Local Group}.Resource_Title {
      GroupName                   =       [System.String]${Local Group}.GroupName
      Description                 =       [System.String]${Local Group}.Description
      #Members                    =       [System.String[]]${Local Group}.Members
      #MembersToExclude           =       [System.String[]]${Local Group}.MembersToExclude
      MembersToInclude            =       [System.String[]]${Local Group}.MembersToInclude
      #Credential                 =       [PSCredential]${Local Group}.Credential
      Ensure                      =       [System.String]${Local Group}.Ensure
      #PsDscRunAsCredential       =       [PSCredential]${Local Group}.PsDscRunAsCredential
      DependsOn                   =       ${Dependencys Local User Accounts}
    }

    ${Dependencys Local Groups}.Add(
      [System.String]"[xGroup]$(${Local Groups}.Resource_Title)"
    ) > $null
  }
}