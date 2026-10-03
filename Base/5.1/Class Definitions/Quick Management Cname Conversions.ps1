#region | Quick Management Cname Conversions |
class QuickMgmtCnameConversion {
  # Convert between DNS canonical name of management Net IP Interface and corresponding %ComputerName%.
  # NOTE: a DNS lookup is NOT performed to resolve the reciprocal value. 
  static [System.String] CN ([System.String] $cname) {
    ${%ComputerName%-to-DNS Canonical Name Conversion} = [System.Collections.Specialized.OrderedDictionary]@{}
    #region | Ordered Dictionary |
    #region | DSC WebServer + DSC Authoring Station |
    $CanonicalName = ${script:DSC Authoring Station Mgmt Cname}
    ${Variable Representation String} = '${' + "$env:Statics\CNs\$CanonicalName ComputerName.txt" + '}'
    $ComputerName = Invoke-Expression -Command ${Variable Representation String}
    ${%ComputerName%-to-DNS Canonical Name Conversion} += @{$CanonicalName = $ComputerName}
    if ($null -ne $ComputerName) {${%ComputerName%-to-DNS Canonical Name Conversion} += @{$ComputerName = $CanonicalName}}

    $CanonicalName = ${script:DSC WebServer Mgmt Cname}
    ${Variable Representation String} = '${' + "$env:Statics\CNs\$CanonicalName ComputerName.txt" + '}'
    $ComputerName = Invoke-Expression -Command ${Variable Representation String}
    ${%ComputerName%-to-DNS Canonical Name Conversion} += @{$CanonicalName = $ComputerName}
    if ($null -ne $ComputerName) {${%ComputerName%-to-DNS Canonical Name Conversion} += @{$ComputerName = $CanonicalName}}
    #endregion
    #region | Domain Controllers |
    $CanonicalName = ${script:AD Forest Creator Mgmt Cname}
    ${Variable Representation String} = '${' + "$env:Statics\CNs\$CanonicalName ComputerName.txt" + '}'
    $ComputerName = Invoke-Expression -Command ${Variable Representation String}
    ${%ComputerName%-to-DNS Canonical Name Conversion} += @{$CanonicalName = $ComputerName}
    if ($null -ne $ComputerName) {${%ComputerName%-to-DNS Canonical Name Conversion} += @{$ComputerName = $CanonicalName}}

    $CanonicalName = ${script:Replica DC 00 Mgmt Cname}
    ${Variable Representation String} = '${' + "$env:Statics\CNs\$CanonicalName ComputerName.txt" + '}'
    $ComputerName = Invoke-Expression -Command ${Variable Representation String}
    ${%ComputerName%-to-DNS Canonical Name Conversion} += @{$CanonicalName = $ComputerName}
    if ($null -ne $ComputerName) {${%ComputerName%-to-DNS Canonical Name Conversion} += @{$ComputerName = $CanonicalName}}

    $CanonicalName = ${script:Replica DC 01 Mgmt Cname}
    ${Variable Representation String} = '${' + "$env:Statics\CNs\$CanonicalName ComputerName.txt" + '}'
    $ComputerName = Invoke-Expression -Command ${Variable Representation String}
    ${%ComputerName%-to-DNS Canonical Name Conversion} += @{$CanonicalName = $ComputerName}
    if ($null -ne $ComputerName) {${%ComputerName%-to-DNS Canonical Name Conversion} += @{$ComputerName = $CanonicalName}}

    $CanonicalName = ${script:Read-Only DC 00 Mgmt Cname}
    ${Variable Representation String} = '${' + "$env:Statics\CNs\$CanonicalName ComputerName.txt" + '}'
    $ComputerName = Invoke-Expression -Command ${Variable Representation String}
    ${%ComputerName%-to-DNS Canonical Name Conversion} += @{$CanonicalName = $ComputerName}
    if ($null -ne $ComputerName) {${%ComputerName%-to-DNS Canonical Name Conversion} += @{$ComputerName = $CanonicalName}}

    $CanonicalName = ${script:Read-Only DC 01 Mgmt Cname}
    ${Variable Representation String} = '${' + "$env:Statics\CNs\$CanonicalName ComputerName.txt" + '}'
    $ComputerName = Invoke-Expression -Command ${Variable Representation String}
    ${%ComputerName%-to-DNS Canonical Name Conversion} += @{$CanonicalName = $ComputerName}
    if ($null -ne $ComputerName) {${%ComputerName%-to-DNS Canonical Name Conversion} += @{$ComputerName = $CanonicalName}}
    #endregion
    #region | Dynamic Host Configuration Protocol (DHCP) Servers |
    $CanonicalName = ${script:DHCP Server 00 Mgmt Cname}
    ${Variable Representation String} = '${' + "$env:Statics\CNs\$CanonicalName ComputerName.txt" + '}'
    $ComputerName = Invoke-Expression -Command ${Variable Representation String}
    ${%ComputerName%-to-DNS Canonical Name Conversion} += @{$CanonicalName = $ComputerName}
    if ($null -ne $ComputerName) {${%ComputerName%-to-DNS Canonical Name Conversion} += @{$ComputerName = $CanonicalName}}

    $CanonicalName = ${script:DHCP Server 01 Mgmt Cname}
    ${Variable Representation String} = '${' + "$env:Statics\CNs\$CanonicalName ComputerName.txt" + '}'
    $ComputerName = Invoke-Expression -Command ${Variable Representation String}
    ${%ComputerName%-to-DNS Canonical Name Conversion} += @{$CanonicalName = $ComputerName}
    if ($null -ne $ComputerName) {${%ComputerName%-to-DNS Canonical Name Conversion} += @{$ComputerName = $CanonicalName}}
    #endregion
    #region | Public Key Infrastructure |
    $CanonicalName = ${script:Root CA Server Mgmt Cname}
    ${Variable Representation String} = '${' + "$env:Statics\CNs\$CanonicalName ComputerName.txt" + '}'
    $ComputerName = Invoke-Expression -Command ${Variable Representation String}
    ${%ComputerName%-to-DNS Canonical Name Conversion} += @{$CanonicalName = $ComputerName}
    if ($null -ne $ComputerName) {${%ComputerName%-to-DNS Canonical Name Conversion} += @{$ComputerName = $CanonicalName}}
    #region | Policy CA1 and associated subordinate CAs |
    $CanonicalName = ${script:Policy CA1 Server Mgmt Cname}
    ${Variable Representation String} = '${' + "$env:Statics\CNs\$CanonicalName ComputerName.txt" + '}'
    $ComputerName = Invoke-Expression -Command ${Variable Representation String}
    ${%ComputerName%-to-DNS Canonical Name Conversion} += @{$CanonicalName = $ComputerName}
    if ($null -ne $ComputerName) {${%ComputerName%-to-DNS Canonical Name Conversion} += @{$ComputerName = $CanonicalName}}

    $CanonicalName = ${script:Leaf CA1 Server Mgmt Cname}
    ${Variable Representation String} = '${' + "$env:Statics\CNs\$CanonicalName ComputerName.txt" + '}'
    $ComputerName = Invoke-Expression -Command ${Variable Representation String}
    ${%ComputerName%-to-DNS Canonical Name Conversion} += @{$CanonicalName = $ComputerName}
    if ($null -ne $ComputerName) {${%ComputerName%-to-DNS Canonical Name Conversion} += @{$ComputerName = $CanonicalName}}

    $CanonicalName = ${script:Leaf CA2 Server Mgmt Cname}
    ${Variable Representation String} = '${' + "$env:Statics\CNs\$CanonicalName ComputerName.txt" + '}'
    $ComputerName = Invoke-Expression -Command ${Variable Representation String}
    ${%ComputerName%-to-DNS Canonical Name Conversion} += @{$CanonicalName = $ComputerName}
    if ($null -ne $ComputerName) {${%ComputerName%-to-DNS Canonical Name Conversion} += @{$ComputerName = $CanonicalName}}

    $CanonicalName = ${script:Leaf CA3 Server Mgmt Cname}
    ${Variable Representation String} = '${' + "$env:Statics\CNs\$CanonicalName ComputerName.txt" + '}'
    $ComputerName = Invoke-Expression -Command ${Variable Representation String}
    ${%ComputerName%-to-DNS Canonical Name Conversion} += @{$CanonicalName = $ComputerName}
    if ($null -ne $ComputerName) {${%ComputerName%-to-DNS Canonical Name Conversion} += @{$ComputerName = $CanonicalName}}
    #endregion
    #region | Policy CA2 and associated subordinate CAs |
    $CanonicalName = ${script:Policy CA2 Server Mgmt Cname}
    ${Variable Representation String} = '${' + "$env:Statics\CNs\$CanonicalName ComputerName.txt" + '}'
    $ComputerName = Invoke-Expression -Command ${Variable Representation String}
    ${%ComputerName%-to-DNS Canonical Name Conversion} += @{$CanonicalName = $ComputerName}
    if ($null -ne $ComputerName) {${%ComputerName%-to-DNS Canonical Name Conversion} += @{$ComputerName = $CanonicalName}}

    $CanonicalName = ${script:End-Entity CA1 Server Mgmt Cname}
    ${Variable Representation String} = '${' + "$env:Statics\CNs\$CanonicalName ComputerName.txt" + '}'
    $ComputerName = Invoke-Expression -Command ${Variable Representation String}
    ${%ComputerName%-to-DNS Canonical Name Conversion} += @{$CanonicalName = $ComputerName}
    if ($null -ne $ComputerName) {${%ComputerName%-to-DNS Canonical Name Conversion} += @{$ComputerName = $CanonicalName}}

    $CanonicalName = ${script:End-Entity CA2 Server Mgmt Cname}
    ${Variable Representation String} = '${' + "$env:Statics\CNs\$CanonicalName ComputerName.txt" + '}'
    $ComputerName = Invoke-Expression -Command ${Variable Representation String}
    ${%ComputerName%-to-DNS Canonical Name Conversion} += @{$CanonicalName = $ComputerName}
    if ($null -ne $ComputerName) {${%ComputerName%-to-DNS Canonical Name Conversion} += @{$ComputerName = $CanonicalName}}
    #endregion
    #region | Web Servers providing support services to the PKI |
    $CanonicalName = ${script:Web PKI Support Mgmt Cname}
    ${Variable Representation String} = '${' + "$env:Statics\CNs\$CanonicalName ComputerName.txt" + '}'
    $ComputerName = Invoke-Expression -Command ${Variable Representation String}
    ${%ComputerName%-to-DNS Canonical Name Conversion} += @{$CanonicalName = $ComputerName}
    if ($null -ne $ComputerName) {${%ComputerName%-to-DNS Canonical Name Conversion} += @{$ComputerName = $CanonicalName}}

    $CanonicalName = ${script:Web PKI CRLDP Server Mgmt Cname}
    ${Variable Representation String} = '${' + "$env:Statics\CNs\$CanonicalName ComputerName.txt" + '}'
    $ComputerName = Invoke-Expression -Command ${Variable Representation String}
    ${%ComputerName%-to-DNS Canonical Name Conversion} += @{$CanonicalName = $ComputerName}
    if ($null -ne $ComputerName) {${%ComputerName%-to-DNS Canonical Name Conversion} += @{$ComputerName = $CanonicalName}}

    $CanonicalName = ${script:Web PKI OSCP Server Mgmt Cname}
    ${Variable Representation String} = '${' + "$env:Statics\CNs\$CanonicalName ComputerName.txt" + '}'
    $ComputerName = Invoke-Expression -Command ${Variable Representation String}
    ${%ComputerName%-to-DNS Canonical Name Conversion} += @{$CanonicalName = $ComputerName}
    if ($null -ne $ComputerName) {${%ComputerName%-to-DNS Canonical Name Conversion} += @{$ComputerName = $CanonicalName}}

    $CanonicalName = ${script:Web PKI CAWE Server Mgmt Cname}
    ${Variable Representation String} = '${' + "$env:Statics\CNs\$CanonicalName ComputerName.txt" + '}'
    $ComputerName = Invoke-Expression -Command ${Variable Representation String}
    ${%ComputerName%-to-DNS Canonical Name Conversion} += @{$CanonicalName = $ComputerName}
    if ($null -ne $ComputerName) {${%ComputerName%-to-DNS Canonical Name Conversion} += @{$ComputerName = $CanonicalName}}

    $CanonicalName = ${script:Web PKI NDES Server Mgmt Cname}
    ${Variable Representation String} = '${' + "$env:Statics\CNs\$CanonicalName ComputerName.txt" + '}'
    $ComputerName = Invoke-Expression -Command ${Variable Representation String}
    ${%ComputerName%-to-DNS Canonical Name Conversion} += @{$CanonicalName = $ComputerName}
    if ($null -ne $ComputerName) {${%ComputerName%-to-DNS Canonical Name Conversion} += @{$ComputerName = $CanonicalName}}
    #endregion
    #endregion
    #endregion
    return ${%ComputerName%-to-DNS Canonical Name Conversion}.$cname
  }
  static [System.String] VM ([System.String] $cname) {
    ${Hyper-V VM Name-to-Cname Conversion} = [System.Collections.Specialized.OrderedDictionary]@{}
    #region | Ordered Dictionary |
    #region | Unclustered DHCP servers |
    ${Hyper-V VM Name-to-Cname Conversion} += @{${script:DHCP Server 00 Mgmt Cname} = '11.00 Automated IPv4 Cfg'}
    ${Hyper-V VM Name-to-Cname Conversion} += @{'11.00 Automated IPv4 Cfg' = ${script:DHCP Server 00 Mgmt Cname}}
    #endregion
    #region | Domain Controllers |
    ${Hyper-V VM Name-to-Cname Conversion} += @{${script:AD Forest Creator Mgmt Cname} = '00.00 Domain Controller'}
    ${Hyper-V VM Name-to-Cname Conversion} += @{'00.00 Domain Controller' = ${script:AD Forest Creator Mgmt Cname}}
    #endregion
    #region | PKI |
    ${Hyper-V VM Name-to-Cname Conversion} += @{${script:Root CA Server Mgmt Cname} = '02.00 Standalone Root CA Host'}
    ${Hyper-V VM Name-to-Cname Conversion} += @{'02.00 Standalone Root CA Host' = ${script:Root CA Server Mgmt Cname}}
    #region | Policy CA1 + Issuings |
    ${Hyper-V VM Name-to-Cname Conversion} += @{${script:Policy CA1 Server Mgmt Cname} = '02.10 Gold Offline Policy CA'}
    ${Hyper-V VM Name-to-Cname Conversion} += @{'02.10 Gold Offline Policy CA' = ${script:Policy CA1 Server Mgmt Cname}}

    ${Hyper-V VM Name-to-Cname Conversion} += @{${script:Leaf CA1 Server Mgmt Cname} = '02.11 Issuing EntCA $Users$'}
    ${Hyper-V VM Name-to-Cname Conversion} += @{'02.11 Issuing EntCA $Users$' = ${script:Leaf CA1 Server Mgmt Cname}}

    ${Hyper-V VM Name-to-Cname Conversion} += @{${script:Web PKI Support Mgmt Cname} = '02.14 AIA & CDP + OSCP'}
    ${Hyper-V VM Name-to-Cname Conversion} += @{'02.14 AIA & CDP + OSCP' = ${script:Web PKI Support Mgmt Cname}}

    ${Hyper-V VM Name-to-Cname Conversion} += @{${script:Leaf CA2 Server Mgmt Cname} = '02.12 Issuing EntCA #OS Instances#'}
    ${Hyper-V VM Name-to-Cname Conversion} += @{'02.12 Issuing EntCA #OS Instances#' = ${script:Leaf CA2 Server Mgmt Cname}}

    ${Hyper-V VM Name-to-Cname Conversion} += @{${script:Leaf CA3 Server Mgmt Cname} = '02.13 Issuing EntCA %Network Devices%'}
    ${Hyper-V VM Name-to-Cname Conversion} += @{'02.13 Issuing EntCA %Network Devices%' = ${script:Leaf CA3 Server Mgmt Cname}}
    #endregion
    #region | Policy CA2 + Issuings |
    ${Hyper-V VM Name-to-Cname Conversion} += @{${script:Policy CA2 Server Mgmt Cname} = '02.20 Silver Offline Policy CA'}
    ${Hyper-V VM Name-to-Cname Conversion} += @{'02.20 Silver Offline Policy CA' = ${script:Policy CA2 Server Mgmt Cname}}

    ${Hyper-V VM Name-to-Cname Conversion} += @{${script:End-Entity CA1 Server Mgmt Cname} = '02.22 Netherite Leaf CA'}
    ${Hyper-V VM Name-to-Cname Conversion} += @{'02.22 Netherite Leaf CA' = ${script:End-Entity CA1 Server Mgmt Cname}}

    ${Hyper-V VM Name-to-Cname Conversion} += @{${script:End-Entity CA2 Server Mgmt Cname} = '02.28 Glowstone Leaf CA'}
    ${Hyper-V VM Name-to-Cname Conversion} += @{'02.28 Glowstone Leaf CA' = ${script:End-Entity CA2 Server Mgmt Cname}}
    #endregion
    #endregion
    #endregion
    return ${Hyper-V VM Name-to-Cname Conversion}.$cname
  }
  static [System.String] Un ([System.String] $cname) {
    $UnencryptedMofLocalUserNameCnameConversion = [System.Collections.Specialized.OrderedDictionary]@{}
    #region | Ordered Dictionary |
    $UnencryptedMofLocalUserNameCnameConversion += @{${script:DSC Authoring Station Mgmt Cname} = 'HyperV OS Deploy'}
    $UnencryptedMofLocalUserNameCnameConversion += @{'HyperV OS Deploy' = ${script:DSC Authoring Station Mgmt Cname}}

    $UnencryptedMofLocalUserNameCnameConversion += @{${script:AD Forest Creator Mgmt Cname} = 'DC OS Deploy'}
    $UnencryptedMofLocalUserNameCnameConversion += @{'DC OS Deploy' = ${script:AD Forest Creator Mgmt Cname}}

    $UnencryptedMofLocalUserNameCnameConversion += @{${script:DHCP Server 00 Mgmt Cname} = 'DHCP OS Deploy'}
    $UnencryptedMofLocalUserNameCnameConversion += @{'DHCP OS Deploy' = ${script:DHCP Server 00 Mgmt Cname}}

    $UnencryptedMofLocalUserNameCnameConversion += @{${script:Root CA Server Mgmt Cname} = 'RootCA OS Deploy'}
    $UnencryptedMofLocalUserNameCnameConversion += @{'RootCA OS Deploy' = ${script:Root CA Server Mgmt Cname}}

    $UnencryptedMofLocalUserNameCnameConversion += @{${script:Policy CA1 Server Mgmt Cname} = 'PolicyCA1 OS Deploy'}
    $UnencryptedMofLocalUserNameCnameConversion += @{'PolicyCA1 OS Deploy' = ${script:Policy CA1 Server Mgmt Cname}}

    $UnencryptedMofLocalUserNameCnameConversion += @{${script:Leaf CA1 Server Mgmt Cname} = 'LeafCA1 OS Deploy'}
    $UnencryptedMofLocalUserNameCnameConversion += @{'LeafCA1 OS Deploy' = ${script:Leaf CA1 Server Mgmt Cname}}

    $UnencryptedMofLocalUserNameCnameConversion += @{${script:Web PKI Support Mgmt Cname} = 'CertVerif OS Deploy'}
    $UnencryptedMofLocalUserNameCnameConversion += @{'CertVerif OS Deploy' = ${script:Web PKI Support Mgmt Cname}}

    $UnencryptedMofLocalUserNameCnameConversion += @{${script:Leaf CA2 Server Mgmt Cname} = 'LeafCA2 OS Deploy'}
    $UnencryptedMofLocalUserNameCnameConversion += @{'LeafCA2 OS Deploy' = ${script:Leaf CA2 Server Mgmt Cname}}

    $UnencryptedMofLocalUserNameCnameConversion += @{${script:Policy CA2 Server Mgmt Cname} = 'PolicyCA2 OS Deploy'}
    $UnencryptedMofLocalUserNameCnameConversion += @{'PolicyCA2 OS Deploy' = ${script:Policy CA2 Server Mgmt Cname}}

    $UnencryptedMofLocalUserNameCnameConversion += @{${script:End-Entity CA1 Server Mgmt Cname} = 'E-Ety CA1 OS Deploy'}
    $UnencryptedMofLocalUserNameCnameConversion += @{'E-Ety CA1 OS Deploy' = ${script:End-Entity CA1 Server Mgmt Cname}}

    $UnencryptedMofLocalUserNameCnameConversion += @{${script:End-Entity CA2 Server Mgmt Cname} = 'E-Ety CA2 OS Deploy'}
    $UnencryptedMofLocalUserNameCnameConversion += @{'E-Ety CA2 OS Deploy' = ${script:End-Entity CA2 Server Mgmt Cname}}

    $UnencryptedMofLocalUserNameCnameConversion += @{${script:DSC WebServer Mgmt Cname} = 'DSC Pull OS Deploy'}
    $UnencryptedMofLocalUserNameCnameConversion += @{'DSC Pull OS Deploy' = ${script:DSC WebServer Mgmt Cname}}
    #endregion
    return $UnencryptedMofLocalUserNameCnameConversion.$cname
  }
  static [System.String] Pw ([System.String] $cname) {
    $UserName = [QuickMgmtCnameConversion]::Un($cname)
    $ClearPw = Get-StoredCredential -Target $UserName -AsCredentialObject | Select-Object -ExpandProperty 'Password'
    $AdjustedClearPw = $ClearPw + "Password"
    $PwBytes = [System.Text.Encoding]::Unicode.GetBytes($AdjustedClearPw)
    $EncodedPw = [System.Convert]::ToBase64String($PwBytes)
    return $EncodedPw
  }
  static [System.String] UnDisp ([System.String] $cname) {
    ${Unencrypted Mof Local User DisplayName to Cname Conversion} = [System.Collections.Specialized.OrderedDictionary]@{}
    #region | Ordered Dictionary |
    ${Unencrypted Mof Local User DisplayName to Cname Conversion} += @{${script:DSC Authoring Station Mgmt Cname} = 'Hyper-V Local Administrator'}
    ${Unencrypted Mof Local User DisplayName to Cname Conversion} += @{'Hyper-V Local Administrator' = ${script:DSC Authoring Station Mgmt Cname}}

    ${Unencrypted Mof Local User DisplayName to Cname Conversion} += @{${script:AD Forest Creator Mgmt Cname} = 'Pre-domain Local Administrator'}
    ${Unencrypted Mof Local User DisplayName to Cname Conversion} += @{'Pre-domain Local Administrator' = ${script:AD Forest Creator Mgmt Cname}}

    ${Unencrypted Mof Local User DisplayName to Cname Conversion} += @{${script:DHCP Server 00 Mgmt Cname} = 'DHCP Local Admin'}
    ${Unencrypted Mof Local User DisplayName to Cname Conversion} += @{'DHCP Local Admin' = ${script:DHCP Server 00 Mgmt Cname}}

    ${Unencrypted Mof Local User DisplayName to Cname Conversion} += @{${script:Root CA Server Mgmt Cname} = 'RootCA Local Admin'}
    ${Unencrypted Mof Local User DisplayName to Cname Conversion} += @{'RootCA Local Admin' = ${script:Root CA Server Mgmt Cname}}

    ${Unencrypted Mof Local User DisplayName to Cname Conversion} += @{${script:Policy CA1 Server Mgmt Cname} = 'PolicyCA1 Local Admin'}
    ${Unencrypted Mof Local User DisplayName to Cname Conversion} += @{'PolicyCA1 Local Admin' = ${script:Policy CA1 Server Mgmt Cname}}

    ${Unencrypted Mof Local User DisplayName to Cname Conversion} += @{${script:Leaf CA1 Server Mgmt Cname} = 'Leaf CA1 Local Admin'}
    ${Unencrypted Mof Local User DisplayName to Cname Conversion} += @{'Leaf CA1 Local Admin' = ${script:Leaf CA1 Server Mgmt Cname}}

    ${Unencrypted Mof Local User DisplayName to Cname Conversion} += @{${script:Web PKI Support Mgmt Cname} = 'Web PKI Local Admin'}
    ${Unencrypted Mof Local User DisplayName to Cname Conversion} += @{'Web PKI Local Admin' = ${script:Web PKI Support Mgmt Cname}}

    ${Unencrypted Mof Local User DisplayName to Cname Conversion} += @{${script:Leaf CA2 Server Mgmt Cname} = 'Leaf CA2 Local Admin'}
    ${Unencrypted Mof Local User DisplayName to Cname Conversion} += @{'Leaf CA2 Local Admin' = ${script:Leaf CA2 Server Mgmt Cname}}

    ${Unencrypted Mof Local User DisplayName to Cname Conversion} += @{${script:Policy CA2 Server Mgmt Cname} = 'PolicyCA2 Local Admin'}
    ${Unencrypted Mof Local User DisplayName to Cname Conversion} += @{'PolicyCA2 Local Admin' = ${script:Policy CA2 Server Mgmt Cname}}

    ${Unencrypted Mof Local User DisplayName to Cname Conversion} += @{${script:End-Entity CA1 Server Mgmt Cname} = 'End-Entity CA1 Local Admin'}
    ${Unencrypted Mof Local User DisplayName to Cname Conversion} += @{'End-Entity CA1 Local Admin' = ${script:End-Entity CA1 Server Mgmt Cname}}

    ${Unencrypted Mof Local User DisplayName to Cname Conversion} += @{${script:End-Entity CA2 Server Mgmt Cname} = 'End-Entity CA2 Local Admin'}
    ${Unencrypted Mof Local User DisplayName to Cname Conversion} += @{'End-Entity CA2 Local Admin' = ${script:End-Entity CA2 Server Mgmt Cname}}

    #endregion
    return ${Unencrypted Mof Local User DisplayName to Cname Conversion}.$cname
  }
  static [System.String] UnDesc ([System.String] $cname) {
    ${Unencrypted Mof Local User Description to Cname Conversion} = [System.Collections.Specialized.OrderedDictionary]@{}
    #region | Ordered Dictionary |
    ${Unencrypted Mof Local User Description to Cname Conversion} += @{${script:DSC Authoring Station Mgmt Cname} = 'Local administrator for local interactive logon sessions'}
    ${Unencrypted Mof Local User Description to Cname Conversion} += @{'Local administrator for local interactive logon sessions' = ${script:DSC Authoring Station Mgmt Cname}}

    ${Unencrypted Mof Local User Description to Cname Conversion} += @{${script:AD Forest Creator Mgmt Cname} = 'Account used for operations that require local admin rights prior to creating the new AD Forest'}
    ${Unencrypted Mof Local User Description to Cname Conversion} += @{'Account used for operations that require local admin rights prior to creating the new AD Forest' = ${script:AD Forest Creator Mgmt Cname}}

    ${Unencrypted Mof Local User Description to Cname Conversion} += @{${script:DHCP Server 00 Mgmt Cname} = 'non-domain local admin on unclu DHCP server'}
    ${Unencrypted Mof Local User Description to Cname Conversion} += @{'non-domain local admin on unclu DHCP server' = ${script:DHCP Server 00 Mgmt Cname}}

    ${Unencrypted Mof Local User Description to Cname Conversion} += @{${script:Root CA Server Mgmt Cname} = 'Temporary local admin for use on root CA host during deployment'}
    ${Unencrypted Mof Local User Description to Cname Conversion} += @{'Temporary local admin for use on root CA host during deployment' = ${script:Root CA Server Mgmt Cname}}

    ${Unencrypted Mof Local User Description to Cname Conversion} += @{${script:Policy CA1 Server Mgmt Cname} = 'Temporary local admin for use on policy CA1 host during deployment'}
    ${Unencrypted Mof Local User Description to Cname Conversion} += @{'Temporary local admin for use on policy CA1 host during deployment' = ${script:Policy CA1 Server Mgmt Cname}}

    ${Unencrypted Mof Local User Description to Cname Conversion} += @{${script:Leaf CA1 Server Mgmt Cname} = 'Temporary local admin for use on leaf CA1 host during deployment'}
    ${Unencrypted Mof Local User Description to Cname Conversion} += @{'Temporary local admin for use on leaf CA1 host during deployment' = ${script:Leaf CA1 Server Mgmt Cname}}

    ${Unencrypted Mof Local User Description to Cname Conversion} += @{${script:Web PKI Support Mgmt Cname} = 'Temporary local admin for use on web server providing PKI support services'}
    ${Unencrypted Mof Local User Description to Cname Conversion} += @{'Temporary local admin for use on web server providing PKI support services' = ${script:Web PKI Support Mgmt Cname}}

    ${Unencrypted Mof Local User Description to Cname Conversion} += @{${script:Leaf CA2 Server Mgmt Cname} = 'Temporary local admin for use on leaf CA2 host during deployment'}
    ${Unencrypted Mof Local User Description to Cname Conversion} += @{'Temporary local admin for use on leaf CA2 host during deployment' = ${script:Leaf CA2 Server Mgmt Cname}}

    ${Unencrypted Mof Local User Description to Cname Conversion} += @{${script:Policy CA2 Server Mgmt Cname} = 'Temporary local admin for use on policy CA2 host during deployment'}
    ${Unencrypted Mof Local User Description to Cname Conversion} += @{'Temporary local admin for use on policy CA2 host during deployment' = ${script:Policy CA2 Server Mgmt Cname}}

    ${Unencrypted Mof Local User Description to Cname Conversion} += @{${script:End-Entity CA1 Server Mgmt Cname} = 'Temporary admin on End-Entity CA1 host'}
    ${Unencrypted Mof Local User Description to Cname Conversion} += @{'Temporary admin on End-Entity CA1 host' = ${script:End-Entity CA1 Server Mgmt Cname}}

    ${Unencrypted Mof Local User Description to Cname Conversion} += @{${script:End-Entity CA2 Server Mgmt Cname} = 'Temporary admin on End-Entity CA2 host'}
    ${Unencrypted Mof Local User Description to Cname Conversion} += @{'Temporary admin on End-Entity CA2 host' = ${script:End-Entity CA2 Server Mgmt Cname}}

    ${Unencrypted Mof Local User Description to Cname Conversion} += @{${script:DSC WebServer Mgmt Cname} = 'Temporary local admin on DSC Pull Web Server'}
    ${Unencrypted Mof Local User Description to Cname Conversion} += @{'Temporary local admin on DSC Pull Web Server' = ${script:DSC WebServer Mgmt Cname}}
    #endregion
    return ${Unencrypted Mof Local User Description to Cname Conversion}.$cname
  }
  static [System.String] ComputerDescriptionBeforeDomainJoin ([System.String] $cname) {
    ${Computer Description before Domain-Join to Cname Conversion} = [System.Collections.Specialized.OrderedDictionary]@{}
    #region | Ordered Dictionary |
    ${Computer Description before Domain-Join to Cname Conversion} += @{${script:DSC Authoring Station Mgmt Cname} = "Unclustered Hyper-V Host (No. 1) and Primordial_DSC_Push_Server"}
    ${Computer Description before Domain-Join to Cname Conversion} += @{"Unclustered Hyper-V Host (No. 1) and Primordial_DSC_Push_Server" = ${script:DSC Authoring Station Mgmt Cname}}

    ${Computer Description before Domain-Join to Cname Conversion} += @{${script:AD Forest Creator Mgmt Cname} = "Very first DC that creates the AD Forest"}
    ${Computer Description before Domain-Join to Cname Conversion} += @{"Very first DC that creates the AD Forest" = ${script:AD Forest Creator Mgmt Cname}}

    ${Computer Description before Domain-Join to Cname Conversion} += @{${script:DHCP Server 00 Mgmt Cname} = "DHCP server 1. Provides no HA either by LBFO or clustering."}
    ${Computer Description before Domain-Join to Cname Conversion} += @{"DHCP server 1. Provides no HA either by LBFO or clustering." = ${script:DHCP Server 00 Mgmt Cname}}

    ${Computer Description before Domain-Join to Cname Conversion} += @{${script:Root CA Server Mgmt Cname} = "System that hosts the Standalone Root CA"}
    ${Computer Description before Domain-Join to Cname Conversion} += @{"System that hosts the Standalone Root CA" = ${script:Root CA Server Mgmt Cname}}

    ${Computer Description before Domain-Join to Cname Conversion} += @{${script:Policy CA1 Server Mgmt Cname} = "System that hosts $(${script:Policy CA1 Name})"}
    ${Computer Description before Domain-Join to Cname Conversion} += @{"System that hosts $(${script:Policy CA1 Name})" = ${script:Policy CA1 Server Mgmt Cname}}

    ${Computer Description before Domain-Join to Cname Conversion} += @{${script:Leaf CA1 Server Mgmt Cname} = 'CA for user identity'}
    ${Computer Description before Domain-Join to Cname Conversion} += @{'CA for user identity' = ${script:Leaf CA1 Server Mgmt Cname}}

    ${Computer Description before Domain-Join to Cname Conversion} += @{${script:Web PKI Support Mgmt Cname} = 'Web server for cert support services'}
    ${Computer Description before Domain-Join to Cname Conversion} += @{'Web server for cert support services' = ${script:Web PKI Support Mgmt Cname}}

    <#
      ${Computer Description before Domain-Join to Cname Conversion} += @{${script:Leaf CA2 Server Mgmt Cname} = ''}
      ${Computer Description before Domain-Join to Cname Conversion} += @{'' = ${script:Leaf CA2 Server Mgmt Cname}}
    #>

    ${Computer Description before Domain-Join to Cname Conversion} += @{${script:Policy CA2 Server Mgmt Cname} = "System that hosts the Policy CA2"}
    ${Computer Description before Domain-Join to Cname Conversion} += @{"System that hosts the Policy CA2" = ${script:Policy CA2 Server Mgmt Cname}}

    <#
      ${Computer Description before Domain-Join to Cname Conversion} += @{${script:End-Entity CA1 Server Mgmt Cname} = ''}
      ${Computer Description before Domain-Join to Cname Conversion} += @{'' = ${script:End-Entity CA1 Server Mgmt Cname}}

      ${Computer Description before Domain-Join to Cname Conversion} += @{${script:End-Entity CA2 Server Mgmt Cname} = ''}
      ${Computer Description before Domain-Join to Cname Conversion} += @{'' = ${script:End-Entity CA2 Server Mgmt Cname}}
    #>


    ${Computer Description before Domain-Join to Cname Conversion} += @{${script:DSC WebServer Mgmt Cname} = "Non-domain DSC WebServer and Authoring Station $(${script:DSC WebServer Mgmt Cname})"}
    ${Computer Description before Domain-Join to Cname Conversion} += @{"Non-domain DSC WebServer and Authoring Station $(${script:DSC WebServer Mgmt Cname})" = ${script:DSC WebServer Mgmt Cname}}
    #endregion
    return ${Computer Description before Domain-Join to Cname Conversion}.$cname
  }
  static [System.String] ComputerDescriptionAfterDomainJoin ([System.String] $cname) {
    ${Computer Description upon Domain-Join Cname Conversion} = [System.Collections.Specialized.OrderedDictionary]@{}
    #region | Ordered Dictionary |
    ${Computer Description upon Domain-Join Cname Conversion} += @{${script:DSC Authoring Station Mgmt Cname} = "Unclustered Hyper-V Host and Primordial DSC Push Server"}
    ${Computer Description upon Domain-Join Cname Conversion} += @{"Unclustered Hyper-V Host and Primordial DSC Push Server" = ${script:DSC Authoring Station Mgmt Cname}}

    <#
      ${Computer Description upon Domain-Join Cname Conversion} += @{${script:AD Forest Creator Mgmt Cname} = ''}
      ${Computer Description upon Domain-Join Cname Conversion} += @{'' = ${script:AD Forest Creator Mgmt Cname}}
    #>

    ${Computer Description upon Domain-Join Cname Conversion} += @{${script:DHCP Server 00 Mgmt Cname} = "DHCP server 1. Provides no HA either by LBFO or clustering."}
    ${Computer Description upon Domain-Join Cname Conversion} += @{"DHCP server 1. Provides no HA either by LBFO or clustering." = ${script:DHCP Server 00 Mgmt Cname}}

    ${Computer Description upon Domain-Join Cname Conversion} += @{${script:Leaf CA1 Server Mgmt Cname} = 'Enterprise CA for human Named Subjects'}
    ${Computer Description upon Domain-Join Cname Conversion} += @{'Enterprise CA for human Named Subjects' = ${script:Leaf CA1 Server Mgmt Cname}}

    ${Computer Description upon Domain-Join Cname Conversion} += @{${script:Web PKI Support Mgmt Cname} = 'Web Server for PKI Support Services'}
    ${Computer Description upon Domain-Join Cname Conversion} += @{'Web Server for PKI Support Services' = ${script:Web PKI Support Mgmt Cname}}
    #endregion
    return ${Computer Description upon Domain-Join Cname Conversion}.$cname
  }
  static [System.String] VmNotes ([System.String] $cname) {
    ${Notes Attribute of Hyper-V VM to Cname Conversion} = [System.Collections.Specialized.OrderedDictionary]@{}
    #region | Ordered Dictionary |
    ${Notes Attribute of Hyper-V VM to Cname Conversion} += @{${script:AD Forest Creator Mgmt Cname} = "DC that creates the Kerberos Networks AD Forest."}
    ${Notes Attribute of Hyper-V VM to Cname Conversion} += @{"DC that creates the Kerberos Networks AD Forest." = ${script:AD Forest Creator Mgmt Cname}}

    ${Notes Attribute of Hyper-V VM to Cname Conversion} += @{${script:DHCP Server 00 Mgmt Cname} = "Unclustered DHCP server. Highly-available DHCP scopes in LBFO mode with dhcpBagel is a mid-build goal."}
    ${Notes Attribute of Hyper-V VM to Cname Conversion} += @{"Unclustered DHCP server. Highly-available DHCP scopes in LBFO mode with dhcpBagel is a mid-build goal." = ${script:DHCP Server 00 Mgmt Cname}}

    ${Notes Attribute of Hyper-V VM to Cname Conversion} += @{${script:Root CA Server Mgmt Cname} = "Host for the Standalone Root CA. Not a member of the domain."}
    ${Notes Attribute of Hyper-V VM to Cname Conversion} += @{"Host for the Standalone Root CA. Not a member of the domain." = ${script:Root CA Server Mgmt Cname}}

    ${Notes Attribute of Hyper-V VM to Cname Conversion} += @{${script:Policy CA1 Server Mgmt Cname} = "policy CA No. 1 host. non-domain & standalone."}
    ${Notes Attribute of Hyper-V VM to Cname Conversion} += @{"policy CA No. 1 host. non-domain & standalone." = ${script:Policy CA1 Server Mgmt Cname}}

    ${Notes Attribute of Hyper-V VM to Cname Conversion} += @{${script:Policy CA2 Server Mgmt Cname} = "policy CA No. 2 host. non-domain & standalone."}
    ${Notes Attribute of Hyper-V VM to Cname Conversion} += @{"policy CA No. 2 host. non-domain & standalone." = ${script:Policy CA2 Server Mgmt Cname}}

    ${Notes Attribute of Hyper-V VM to Cname Conversion} += @{${script:Leaf CA1 Server Mgmt Cname} = "Issuer for user certs."}
    ${Notes Attribute of Hyper-V VM to Cname Conversion} += @{"Issuer for user certs." = ${script:Leaf CA1 Server Mgmt Cname}}

    ${Notes Attribute of Hyper-V VM to Cname Conversion} += @{${script:Web PKI Support Mgmt Cname} = "Provides AIA, CRLDP, OSCP, and other PKI-centric services supporting the Enterprise CA"}
    ${Notes Attribute of Hyper-V VM to Cname Conversion} += @{"Provides AIA, CRLDP, OSCP, and other PKI-centric services supporting the Enterprise CA" = ${script:Web PKI Support Mgmt Cname}}

    #endregion
    return ${Notes Attribute of Hyper-V VM to Cname Conversion}.$cname
  }
}
$accelerators::Add('qmcc','QuickMgmtCnameConversion')
#endregion

