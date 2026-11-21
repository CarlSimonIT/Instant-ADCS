<# NOTES |
  reg add HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Policies\Microsoft\FeatureManagement\Overrides /v 1176759950 /t REG_DWORD /d 1 /f
  Does the native NVMe driver work on Hyper-V VMs? 
#>

${Native NVME Storage Driver} = $Node.'Native NVME Storage Driver'

if ($null -ne ${Native NVME Storage Driver}) {
  if (
    ($null -ne ${Native NVME Storage Driver}.Key) -and ($null -ne ${Native NVME Storage Driver}.ValueName)
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

    <#
    #>
    xRegistry ${Native NVME Storage Driver}.Resource_Title {
      Key                       =      [System.String]${Native NVME Storage Driver}.Key
      ValueName                 =      [System.String]${Native NVME Storage Driver}.ValueName
      ValueData                 =      [System.String[]]${Native NVME Storage Driver}.ValueData
      ValueType                 =      [System.String]${Native NVME Storage Driver}.ValueType
      Force                     =      [System.Boolean]${Native NVME Storage Driver}.Force
      Ensure                    =      [System.String]${Native NVME Storage Driver}.Ensure
      #PsDscRunAsCredential     =      [PSCredential]${Native NVME Storage Driver}.PsDscRunAsCredential
      DependsOn                 =      ${Dependencys Event Log Channel Status}
    }

    ${Dependency Native NVME Storage Driver} = [System.String[]]@(
      "[xRegistry]$(${Native NVME Storage Driver}.Resource_Title)"
    )
  }
}