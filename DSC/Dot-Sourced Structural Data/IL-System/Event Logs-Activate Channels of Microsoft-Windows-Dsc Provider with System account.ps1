${Channels in the Event Log Provider Microsoft-Windows-Dsc} = $Node.'Channels in the Event Log Provider Microsoft-Windows-Dsc'
if ($null -ne ${Channels in the Event Log Provider Microsoft-Windows-Dsc}) {
  ${Dependencys Event Log Channel Status} = [System.Collections.ArrayList]::New()
  foreach (${Channel in the Event Log Provider Microsoft-Windows-Dsc} in ${Channels in the Event Log Provider Microsoft-Windows-Dsc}) {
    if (
      $null -ne ${Channel in the Event Log Provider Microsoft-Windows-Dsc}.Channel
    ) {
      WindowsEventLogChannelThatIsENABLEDforDscTracking ${Channel in the Event Log Provider Microsoft-Windows-Dsc}.Resource_Title {
        Channel                 =   [System.String]${Channel in the Event Log Provider Microsoft-Windows-Dsc}.Channel
        Ensure                  =   [System.String]${Channel in the Event Log Provider Microsoft-Windows-Dsc}.Ensure
        #PsDscRunAsCredential   =   [PSCredential]${Channel in the Event Log Provider Microsoft-Windows-Dsc}.PsDscRunAsCredential
        DependsOn               =   ${Dependencys Strict PowerShell 5.1 Trackers}
      }

      ${Dependencys Event Log Channel Status}.Add(
        [System.String]"[WindowsEventLogChannelThatIsENABLEDforDscTracking]$(${Channel in the Event Log Provider Microsoft-Windows-Dsc}.Resource_Title)"
      ) | Out-Null
    }
  }
}