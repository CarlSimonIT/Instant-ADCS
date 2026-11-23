${WinPE 2026-09-Offline Installation} = $Node.'WinPE 2026-09-Offline Installation'
if ($null -ne ${WinPE 2026-09-Offline Installation}) {
  <#
    Get-DscResourceProperty -ModuleName 'xPSDesiredStateConfiguration' -ResourceName 'xPackage' | clip.exe

    Name                                IsKey Mandatory TypeConstraint  Values
    ----                                ----- --------- --------------  ------
    Name                                 True      True String          {}
    ProductId                            True      True String          {}
    Path                                False      True String          {}
  
    Arguments                           False     False String          {}
    CreateCheckRegValue                 False     False Boolean         {}
    FileHash                            False     False String          {}
    HashAlgorithm                       False     False String          {MD5 | RIPEMD160 | SHA1 | SHA256 | SHA384 | SHA512}
    IgnoreReboot                        False     False Boolean         {}
    InstalledCheckRegHive               False     False String          {LocalMachine | CurrentUser}
    InstalledCheckRegKey                False     False String          {}
    InstalledCheckRegValueData          False     False String          {}
    InstalledCheckRegValueName          False     False String          {}
    LogPath                             False     False String          {}
    ReturnCode                          False     False UInt32Array     {}
    RunAsCredentia1                     False     False MSFT_Credential {}
    ServerCertificateValidationCallback False     False String          {}
    SignerSubject                       False     False String          {}
    SignerThumbprint                    False     False String          {}

    Credentia1                          False     False MSFT_Credential {}
    Ensure                              False     False String          {Present | Absent}
    PsDscRunAsCredentia1                False     False MSFT_Credential {}
    DependsOn                           False     False StringArray     {}
  #>

  <#
    Get-DscResourceProperty -ModuleName 'xPSDesiredStateConfiguration' -ResourceName 'xMsiPackage' | clip.exe

    Name                                IsKey Mandatory TypeConstraint  Values
    ----                                ----- --------- --------------  ------
    ProductId                            True      True String          {}
    Path                                False      True String          {}
    Arguments                           False     False String          {}
    FileHash                            False     False String          {}
    HashAlgorithm                       False     False String          {MD5 | RIPEMD160 | SHA1 | SHA256 | SHA384 | SHA512}
    IgnoreReboot                        False     False Boolean         {}
    LogPath                             False     False String          {}
    RunAsCredentia1                     False     False MSFT_Credential {}
    ServerCertificateValidationCallback False     False String          {}
    SignerSubject                       False     False String          {}
    SignerThumbprint                    False     False String          {}

    Credentia1                          False     False MSFT_Credential {}
    Ensure                              False     False String          {Present | Absent}
    PsDscRunAsCredentia1                False     False MSFT_Credential {}
    DependsOn                           False     False StringArray     {}
  #>

  <#
    Get-DscResourceProperty -ModuleName 'PSDesiredStateConfiguration' -ResourceName 'Package' | clip.exe

    Name                 IsKey Mandatory TypeConstraint  Values
    ----                 ----- --------- --------------  ------
    Name                  True      True String          {}
    ProductId             True      True String          {}
    Path                 False      True String          {}
    Arguments            False     False String          {}
    LogPath              False     False String          {}
    ReturnCode           False     False UInt32Array     {}
    Credentia1           False     False MSFT_Credential {}
    Ensure               False     False String          {Present | Absent}
    PsDscRunAsCredentia1 False     False MSFT_Credential {}
    DependsOn            False     False StringArray     {}
  #>

  xPackage ${WinPE 2026-09-Offline Installation}.Resource_Title {
    Name                            =          [System.String]${WinPE 2026-09-Offline Installation}.Name
    ProductId                       =          [System.String]${WinPE 2026-09-Offline Installation}.ProductId
    Path                            =          [System.String]${WinPE 2026-09-Offline Installation}.Path
    Arguments                       =          [System.String]${WinPE 2026-09-Offline Installation}.Arguments
    #Credential                     =          [PSCredential]${WinPE 2026-09-Offline Installation}.Credential
    Ensure                          =          [System.String]${WinPE 2026-09-Offline Installation}.Ensure
    #PsDscRunAsCredential           =          [PSCredential]${WinPE 2026-09-Offline Installation}.PsDscRunAsCredential
    DependsOn                       =          ${Dependencys Event Log Channel Status}
  }
}