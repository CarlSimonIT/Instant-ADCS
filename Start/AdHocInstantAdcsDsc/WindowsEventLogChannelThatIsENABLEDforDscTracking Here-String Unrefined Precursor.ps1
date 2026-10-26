[DscResource()]
class WindowsEventLogChannelThatIsENABLEDforDscTracking {
  [DscProperty(Key)]
  [ValidateSet(
    'Operational','Analytic','Debug'
  )]
  [System.String]
  $Channel

  [DscProperty(Mandatory)]
  [Ensure]
  $Ensure

  #%_Test Explained Here-String_%
  [System.Boolean] Test () {
    #region | Test() Subphase A | Uncover the reality |
    Write-Verbose -Message "Test() Subphase A"
    <#
      For the 'WindowsEventLogChannelThatIsENABLEDforDscTracking' DSC Resource, an $Ensure variable that is to [Ensure]::Present means that 
      the real-world state of the DSC Resource instance is an Event Log Channel whose IsEnabled property is $true. 
      For the 'WindowsEventLogChannelThatIsENABLEDforDscTracking' DSC Resource, an $Ensure variable that is to [Ensure]::Absent means that 
      the real-world state of the DSC Resource instance is an Event Log Channel whose IsEnabled property is $false. 
      
      The above needs to be explicitly stated because prior versions of this resource, when it was called 'TrackDscEvents', included 
      an additional 'Key' property titled 'Status', which required '$Ensure = [Ensure]::Present' to indicate that action must be taken, 
      and '$Ensure = [Ensure]::Absent' to indicate that no action should be taken, regardless of any real-world 
      state that the Test() method uncovered.
    #>

    Import-Module -Name 'Microsoft.PowerShell.Diagnostics' -Cmdlet 'Get-WinEvent' -RequiredVersion '3.0.0.0'

    ${OBSERVED real-world state of the object which corresponds to this exact specific DSC Resource instance} = Get-WinEvent -ListLog "Microsoft-Windows-Dsc/$($this.Channel)" `
    | Select-Object -ExpandProperty 'IsEnabled'
    #endregion

    #region | Test() Subphase B | Consider whether this reality is desired |
    Write-Verbose -Message "Test() Subphase B"
    if (
      ${OBSERVED real-world state of the object which corresponds to this exact specific DSC Resource instance} -eq $true `
      -and `
      $this.Ensure -eq [Ensure]::Present
    ) {
      $Assessment = $true
    }

    if (
      ${OBSERVED real-world state of the object which corresponds to this exact specific DSC Resource instance} -eq $false `
      -and `
      $this.Ensure -eq [Ensure]::Absent
    ) {
      $Assessment = $true
    }

    if (
      ${OBSERVED real-world state of the object which corresponds to this exact specific DSC Resource instance} -eq $true `
      -and `
      $this.Ensure -eq [Ensure]::Absent
    ) {
      $Assessment = $false
    }

    if (
      ${OBSERVED real-world state of the object which corresponds to this exact specific DSC Resource instance} -eq $false `
      -and `
      $this.Ensure -eq [Ensure]::Present
    ) {
      $Assessment = $false
    }
    #endregion

    #region | Test() Subphase C | Return to Set() the $Assessment. If this reality is NOT desired, Set() will handle the details |
    Write-Verbose -Message "Test() Subphase C: `$Assessment = $($this.Assessment)"
    return $this.Assessment
    #endregion
  }

  #%_Set Explained Here-String_%
  [System.Void] Set () {
    Write-Verbose -Message "Set() method has been called"
    Import-Module -Name 'xDscDiagnostics' -Function 'Update-xDscEventLogStatus' -RequiredVersion '2.8.0'
    switch ($true) {
      ($this.Ensure -eq [Ensure]::Present) {
        Update-xDscEventLogStatus -Channel $this.Channel -Status 'Enabled'
      }
      ($this.Ensure -eq [Ensure]::Absent)  {
        Update-xDscEventLogStatus -Channel $this.Channel -Status 'Disabled'
      }
    }
  }

  #%_Get Explained Here-String_%
  [WindowsEventLogChannelThatIsENABLEDforDscTracking] Get () {
    Write-Verbose -Message "Get() real-world state of WindowsEventLogChannelThatIsENABLEDforDscTracking resource instance"
    Import-Module -Name 'Microsoft.PowerShell.Diagnostics' -Cmdlet 'Get-WinEvent' -RequiredVersion '3.0.0.0'

    $CurrentState = [System.Collections.Hashtable]::New()    

    ${OBSERVED real-world state of the object which corresponds to this exact specific DSC Resource instance} = Get-WinEvent -ListLog "Microsoft-Windows-Dsc/$($this.Channel)" `
    | Select-Object -ExpandProperty 'IsEnabled'

    if (${OBSERVED real-world state of the object which corresponds to this exact specific DSC Resource instance} -eq $true) {
      $CurrentState.Add('Channel',$this.Channel)
      $CurrentState.Add('Ensure',[Ensure]::Present)
    } 
    else {
      $CurrentState.Add('Channel',$this.Channel)
      $CurrentState.Add('Ensure',[Ensure]::Absent)
    }

    return $CurrentState
  }
}