#region | Node Mgmt NetIPInterface CNAMEs |
<# Decoupling DNS resource records from OS instances |
  Stop thinking of an IP address as being associated with an entire computer. A
  single computer may have more than one network adapter, and therefore a single
  computer may have multiple IP addresses. 

  Going forward, we will associate an IPv4 address with a specific network 
  IP interface on a computer. 

  It is no longer accurate to state "The IP of the DC is 192.168.0.1" because 
  multiple network adapters will be connected, and therefore the server will have 
  multiple IP addresses. 

  This new understanding presents significant challenges to the management of DNS
  and DHCP services, but if enhanced security via network segmentation is a goal
  for your organization, then an increase in complexity is unavoidable. 
#>

${DSC Authoring Station Mgmt Cname} = '%_DSC Authoring Station Mgmt Cname_%'
${DSC WebServer Mgmt Cname}         = '%_DSC WebServer Mgmt Cname_%'
${AD Forest Creator Mgmt Cname}     = '%_AD Forest Creator Mgmt Cname_%'
${Replica DC 00 Mgmt Cname}         = '%_Replica DC 00 Mgmt Cname_%'
${Replica DC 01 Mgmt Cname}         = '%_Replica DC 01 Mgmt Cname_%'
${Read-Only DC 00 Mgmt Cname}       = '%_Read-Only DC 00 Mgmt Cname_%'
${Read-Only DC 01 Mgmt Cname}       = '%_Read-Only DC 01 Mgmt Cname_%'
${DHCP Server 00 Mgmt Cname}        = '%_DHCP Server 00 Mgmt Cname_%'
${DHCP Server 01 Mgmt Cname}        = '%_DHCP Server 01 Mgmt Cname_%'
${Root CA Server Mgmt Cname}        = '%_Root CA Server Mgmt Cname_%'
${Policy CA1 Server Mgmt Cname}     = '%_Policy CA1 Server Mgmt Cname_%'
${Leaf CA1 Server Mgmt Cname}       = '%_Leaf CA1 Server Mgmt Cname_%'
${Leaf CA2 Server Mgmt Cname}       = '%_Leaf CA2 Server Mgmt Cname_%'
${Leaf CA3 Server Mgmt Cname}       = '%_Leaf CA3 Server Mgmt Cname_%'
${Policy CA2 Server Mgmt Cname}     = '%_Policy CA2 Server Mgmt Cname_%'
${End-Entity CA1 Server Mgmt Cname} = '%_End-Entity CA1 Server Mgmt Cname_%'
${End-Entity CA2 Server Mgmt Cname} = '%_End-Entity CA2 Server Mgmt Cname_%'
${Web PKI Support Mgmt Cname}       = '%_Web PKI Support Mgmt Cname_%'
${Web PKI CRLDP Server Mgmt Cname}  = '%_Web PKI CRLDP Server Mgmt Cname_%'
${Web PKI OSCP Server Mgmt Cname}   = '%_Web PKI OSCP Server Mgmt Cname_%'
${Web PKI CAWE Server Mgmt Cname}   = '%_Web PKI CAWE Server Mgmt Cname_%'
${Web PKI NDES Server Mgmt Cname}   = '%_Web PKI NDES Server Mgmt Cname_%'
#endregion

