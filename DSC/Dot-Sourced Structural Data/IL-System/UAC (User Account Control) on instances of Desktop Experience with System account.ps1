<# NOTES |
  The concept of "User Account Control" only applies when the OS instance 
  (on which an elevated security context for a process is being attempted)
  has a GUI. CLI-based instances of Windows Server, like Standard Server 
  Core and Datacenter Server Core, do not offer the additional layer of 
  protection (on top of Mandatory Integrity Control) that UAC delivers. 
#>
${Windows Server Image Index} = $Node.'Windows Server Image Index'
if ( # If the configuration target runs an edition of Desktop Experience... |
  -not (${Windows Server Image Index} % 2)
) { # then set the UAC notification level. |
  ${User Account Control} = $Node.'User Account Control'
  if ($null -ne ${User Account Control}) {
    if (
      $null -ne ${User Account Control}.IsSingleInstance
    ) {
      <#
        start msedge.exe 'https://github.com/dsccommunity/ComputerManagementDsc/wiki/UserAccountControl'
        Get-DscResourceProperty.ps1 -ModuleName 'ComputerManagementDsc' -ResourceName 'UserAccountControl' | clip.exe

        Name                        IsKey Mandatory TypeConstraint  Values
        ----                        ----- --------- --------------  ------
        IsSingleInstance             True      True String          {Yes}

        # Default = 5
        # start msedge.exe 'https://learn.microsoft.com/en-us/openspecs/windows_protocols/ms-gpsb/341747f5-6b5d-4d30-85fc-fa1cc04038d4'
        ConsentPromptBehaviorAdmin  False     False UInt16          { 0 | 1 | 2 | 3 | 4 | 5 } 

        ConsentPromptBehaviorUser   False     False UInt16          {0, 1, 3}
        EnableInstallerDetection    False     False UInt16          {0, 1}
        EnableLua                   False     False UInt16          {0, 1}
        EnableVirtualization        False     False UInt16          {0, 1}
        FilterAdministratorToken    False     False UInt16          {0, 1}


        # Supported values in alphabetical order: 
        ## AlwaysNotify / AlwaysNotifyAndAskForCredentials / NeverNotify / NeverNotifyAndDisableAll / NotifyChanges / NotifyChangesWithoutDimming
        # Least secure but most convenient = 'NeverNotifyAndDisableAll'
        # Most secure but least convenient = 'AlwaysNotifyAndAskForCredentials'
        # Default = NotifyChanges
        NotificationLevel           False     False String          {AlwaysNotify | AlwaysNotifyAndAskForCredentials | NeverNotify | NeverNotifyAndDisableAll | NotifyChanges | NotifyChangesWithoutDimming}
        PromptOnSecureDesktop       False     False UInt16          {0 | 1}
        SuppressRestart             False     False Boolean         {}
        ValidateAdminCodeSignatures False     False UInt16          {0 | 1}

        PsDscRunAsCredentia1        False     False MSFT_Credential {}
        DependsOn                   False     False StringArray     {}
      #>

      UserAccountControl ${User Account Control}.Resource_Title {
        IsSingleInstance            =     [System.String]${User Account Control}.IsSingleInstance
        NotificationLevel           =     [System.String]${User Account Control}.NotificationLevel
        SuppressRestart             =     [System.Boolean]${User Account Control}.SuppressRestart
        #PsDscRunAsCredential       =     [PSCredential]${User Account Control}.PsDscRunAsCredential
        DependsOn                   =     ${Dependencys Event Log Channel Status}
      }

      ${Dependency User Account Control} = [System.String[]]@(
        "[UserAccountControl]$(${User Account Control}.Resource_Title)"
      )
    }
  }
}

<# Misc Notes | From the ComputerManagementDsc resource module |
  # "$env:PMs\ComputerManagementDsc\10.0.0\Modules\ComputerManagementDsc.Common\ComputerManagementDsc.Common.psm1"
  function Get-RegistryPropertyValue {
      [CmdletBinding()]
      [OutputType([System.String])]
      param
      (
          [Parameter(Mandatory = $true)]
          [System.String]
          $Path,

          [Parameter(Mandatory = $true)]
          [System.String]
          $Name
      )

      $getItemPropertyParameters = @{
          Path = $Path
          Name = $Name
      }

      # Using a try/catch block instead of 'SilentlyContinue' to be
      # able to unit test a failing registry path.
      try
      {
          $getItemPropertyResult = (Get-ItemProperty @getItemPropertyParameters -ErrorAction Stop).$Name
      }
      catch
      {
          $getItemPropertyResult = $null
      }

      return $getItemPropertyResult
  }
  # "$env:PMs\ComputerManagementDsc\10.0.0\DSCResources\DSC_UserAccountControl\DSC_UserAccountControl.psm1"
  function Get-UserAccountControl {
    [CmdletBinding()]
    [OutputType([System.Collections.Hashtable])]
    param (
      $RegistryKey = 'HKLM:\HKEY_LOCAL_MACHINE\Software\Microsoft\Windows\CurrentVersion\Policies\System'
    )

    return @{
      FilterAdministratorToken    = Get-RegistryPropertyValue -Path $RegistryKey -Name 'FilterAdministratorToken'
      ConsentPromptBehaviorAdmin  = Get-RegistryPropertyValue -Path $RegistryKey -Name 'ConsentPromptBehaviorAdmin'
      ConsentPromptBehaviorUser   = Get-RegistryPropertyValue -Path $RegistryKey -Name 'ConsentPromptBehaviorUser'
      EnableInstallerDetection    = Get-RegistryPropertyValue -Path $RegistryKey -Name 'EnableInstallerDetection'
      ValidateAdminCodeSignatures = Get-RegistryPropertyValue -Path $RegistryKey -Name 'ValidateAdminCodeSignatures'
      EnableLua                   = Get-RegistryPropertyValue -Path $RegistryKey -Name 'EnableLUA'
      PromptOnSecureDesktop       = Get-RegistryPropertyValue -Path $RegistryKey -Name 'PromptOnSecureDesktop'
      EnableVirtualization        = Get-RegistryPropertyValue -Path $RegistryKey -Name 'EnableVirtualization'
    }
  }

  Get-UserAccountControl
#>