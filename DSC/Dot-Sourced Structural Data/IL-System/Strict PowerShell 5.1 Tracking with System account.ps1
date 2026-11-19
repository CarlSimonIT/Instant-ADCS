<# References |
  start msedge.exe 'https://www.tenable.com/audits/items/CIS_DC_SERVER_2012_Level_1_v3.0.0.audit:1560c42103528495b35566acd4c2dcfa'
  notepad.exe "C:\Windows\System32\WindowsPowerShell\v1.0\en-US\about_Logging.help.txt"
  notepad.exe "C:\Windows\System32\WindowsPowerShell\v1.0\en-US\about_Eventlogs.help.txt"
  start msedge.exe 'https://github.com/dsccommunity/SecurityPolicyDsc'
  start msedge.exe 'https://github.com/dsccommunity/AuditPolicyDsc'
  start msedge.exe 'https://gpedit.tplant.com.au/en-us/policy/Microsoft.Policies.PowerShell/EnableTranscripting/'
#>

${Strict PowerShell 5.1 Trackers} = $Node.'Strict PowerShell 5.1 Trackers'
if ($null -ne ${Strict PowerShell 5.1 Trackers}) {
  ${Dependencys Strict PowerShell 5.1 Trackers} = [System.Collections.ArrayList]::New()

  foreach (${Strict PowerShell 5.1 Tracker} in ${Strict PowerShell 5.1 Trackers}) {
    if (
      $null -ne ${Strict PowerShell 5.1 Tracker}.Key       -and `
      $null -ne ${Strict PowerShell 5.1 Tracker}.ValueName 
    ) {
      <#
        start msedge.exe 'https://github.com/dsccommunity/xPSDesiredStateConfiguration/wiki/xRegistry'
        Get-DscResourceProperty.ps1 -ModuleName xPSDesiredStateConfiguration -ResourceName xRegistry | clip.exe

        Name                 IsKey Mandatory TypeConstraint  Values
        ----                 ----- --------- --------------  ------
        Key                   True      True String          {}
        ValueName             True      True String          {}

        Force                False     False Boolean         {}
        Hex                  False     False Boolean         {}
        ValueData            False     False StringArray     {}
        ValueType            False     False String          { Binary | DWord | ExpandString | MultiString | QWord | String }

        Ensure               False     False String          {Present | Absent}
        PsDscRunAsCredential False     False MSFT_Credential {}
        DependsOn            False     False StringArray     {}
      #>

      xRegistry ${Strict PowerShell 5.1 Tracker}.Resource_Title {
        Key                         =        [System.String]${Strict PowerShell 5.1 Tracker}.Key
        ValueName                   =        [System.String]${Strict PowerShell 5.1 Tracker}.ValueName
        ValueData                   =        [System.String]${Strict PowerShell 5.1 Tracker}.ValueData
        ValueType                   =        [System.String]${Strict PowerShell 5.1 Tracker}.ValueType
        Force                       =        [System.Boolean]${Strict PowerShell 5.1 Tracker}.Force
        Ensure                      =        [System.String]${Strict PowerShell 5.1 Tracker}.Ensure
        #PsDscRunAsCredential       =        [PSCredential]${Strict PowerShell 5.1 Tracker}.PsDscRunAsCredential
      }

      ${Dependencys Strict PowerShell 5.1 Trackers}.Add(
        [System.String]"[xRegistry]$(${Strict PowerShell 5.1 Tracker}.Resource_Title)"
      ) | Out-Null
    }
  }
}