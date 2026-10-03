#region | Regular Expression Patterns |
[System.String]${String of Regex Octet Base10}                          = '(?:0?0?[0-9]|0?[1-9][0-9]|1[0-9]{2}|2[0-5][0-5]|2[0-4][0-9])'
[System.Text.RegularExpressions.Regex]${regex IPv4}                     = "^(?:${String of Regex Octet Base10}\.){3}(?:${String of Regex Octet Base10})$"
[System.String]${String of Regex IPv4 CIDR}                             = '/(?:\d|[12]\d|3[012])'
[System.Text.RegularExpressions.Regex]${regex IPv4 CIDR}                = "^(?:${String of Regex Octet Base10}\.){3}(?:${String of Regex Octet Base10})(?:${String of Regex IPv4 CIDR})$"

[System.Text.RegularExpressions.Regex]${regex IPv4 Octet Matches}       = "^(?<Octet_1>${String of Regex Octet Base10})\.(?<Octet_2>${String of Regex Octet Base10})\.(?<Octet_3>${String of Regex Octet Base10})\.(?<Octet_4>${String of Regex Octet Base10})`$"

[System.String]${regex literal IPv4}                                    = "'^(?:(?:1\d\d|2[0-5][0-5]|2[0-4]\d|0?[1-9]\d|0?0?\d)\.){3}(?:1\d\d|2[0-5][0-5]|2[0-4]\d|0?[1-9]\d|0?0?\d)$'"
[System.String]${regex literal IPv4 CIDR}                               = "'^(?:(?:1\d\d|2[0-5][0-5]|2[0-4]\d|0?[1-9]\d|0?0?\d)\.){3}(?:1\d\d|2[0-5][0-5]|2[0-4]\d|0?[1-9]\d|0?0?\d)/(?:\d|[12]\d|3[012])$'"
[System.Text.RegularExpressions.Regex]${regex DNS Name of Windows Host} = "^(?<Computer_Name>(?!(\d{1,15}|ANONYMOUS|BATCH|BUILTIN|DIALUP|DOMAIN|ENTERPRISE|INTERACTIVE|INTERNET|LOCAL|NETWORK|NULL|PROXY|RESTRICTED|SELF|SERVER|SERVICE|SYSTEM|USERS|WORLD)$)[a-z0-9][a-z0-9-]{1,13}[a-z0-9])\.(?<AD_DNS>(((?!-))(xn--|_)?[a-z0-9-]{0,61}[a-z0-9]{1,1}\.)*(xn--)?([a-z0-9][a-z0-9\-]{0,60}|[a-z0-9-]{1,30}\.[a-z]{2,}))`$"

[System.String]${regex literal SamAccountName of User Account in Active Directory}              = '^[^/\\\[\]\:;\|=,\+\*\?\<\>@"]{1,20}$'
[System.String]${regex literal SamAccountName of User Account in Active Directory (Anchorless)} = '[^/\\\[\]\:;\|=,\+\*\?\<\>@"]{1,20}'

[System.String]${regex literal Windows NetBIOS ComputerName}              = '^(?!(\d{1,15}|ANONYMOUS|BATCH|BUILTIN|DIALUP|DOMAIN|ENTERPRISE|INTERACTIVE|INTERNET|LOCAL|NETWORK|NULL|PROXY|RESTRICTED|SELF|SERVER|SERVICE|SYSTEM|USERS|WORLD)$)[a-z0-9][a-z0-9-]{1,13}[a-z0-9]$'
[System.String]${regex literal Windows NetBIOS ComputerName (Anchorless)} = '(?!(\d{1,15}|ANONYMOUS|BATCH|BUILTIN|DIALUP|DOMAIN|ENTERPRISE|INTERACTIVE|INTERNET|LOCAL|NETWORK|NULL|PROXY|RESTRICTED|SELF|SERVER|SERVICE|SYSTEM|USERS|WORLD)$)[a-z0-9][a-z0-9-]{1,13}[a-z0-9]'

<# 0------------0 |
  This ^ is a valid Windows %ComputerName% and 
  &&&&&&&&&&&&&&&&&&&&
  this ^ is a valid Windows %UserName% !

  '0------------0\&&&&&&&&&&&&&&&&&&&&' -match '^(?<ComputerName>(\.|(?!(\d{1,15}|ANONYMOUS|BATCH|BUILTIN|DIALUP|DOMAIN|ENTERPRISE|INTERACTIVE|INTERNET|LOCAL|NETWORK|NULL|PROXY|RESTRICTED|SELF|SERVER|SERVICE|SYSTEM|USERS|WORLD)$)[a-z0-9][a-z0-9-]{1,13}[a-z0-9]))\\(?<UserName>[^/\\\[\]\:;\|=,\+\*\?\<\>@"]{1,20})$'
#>
[System.String]${regex literal DNS Domain Name}              = '^(((?!-))(xn--|_)?[a-z0-9-]{0,61}[a-z0-9]{1,1}\.)*(xn--)?([a-z0-9][a-z0-9\-]{0,60}|[a-z0-9-]{1,30}\.[a-z]{2,})$'
[System.String]${regex literal DNS Domain Name (Anchorless)} = '(((?!-))(xn--|_)?[a-z0-9-]{0,61}[a-z0-9]{1,1}\.)*(xn--)?([a-z0-9][a-z0-9\-]{0,60}|[a-z0-9-]{1,30}\.[a-z]{2,})'

[System.String]${regex literal non-Domain Windows UserName}              = ${regex literal SamAccountName of User Account in Active Directory}
[System.String]${regex literal non-Domain Windows UserName (Anchorless)} = ${regex literal SamAccountName of User Account in Active Directory (Anchorless)}

# start msedge.exe 'https://learn.microsoft.com/en-us/troubleshoot/windows-server/active-directory/naming-conventions-for-computer-domain-site-ou#netbios-domain-names'
[System.String]${regex literal AD Domain NetBIOS Name}              = ${regex literal Windows NetBIOS ComputerName}
[System.String]${regex literal AD Domain NetBIOS Name (Anchorless)} = ${regex literal Windows NetBIOS ComputerName (Anchorless)}

# start msedge.exe 'https://learn.microsoft.com/en-us/troubleshoot/windows-server/active-directory/naming-conventions-for-computer-domain-site-ou#dns-domain-names'

#[System.String]${regex literal AD Domain DNS Name} = '^[a-z0-9-\.]{2,63}$' # since when did DNS domain names allow 2+ consecutive full-stop characters? 
# start msedge.exe 'https://www.regular-expressions.info/email.html'
[System.String]${regex literal AD Domain DNS Name}              = '^(?:[a-z0-9-]+\.)+[a-z]{2,}$'
[System.String]${regex literal AD Domain DNS Name (Anchorless)} = '(?:[a-z0-9-]+\.)+[a-z]{2,}'

[System.String]${regex literal UPN Suffix}              = ${regex literal AD Domain DNS Name}
[System.String]${regex literal UPN Suffix (Anchorless)} = ${regex literal AD Domain DNS Name (Anchorless)}

[System.String]${regex literal UPN Prefix}              = "^[^\$([System.Char]47)\$([System.Char]92)\$([System.Char]91)\$([System.Char]93)\$([System.Char]58)\$([System.Char]59)\$([System.Char]124)\$([System.Char]61)\$([System.Char]44)\$([System.Char]43)\$([System.Char]42)\$([System.Char]63)\$([System.Char]60)\$([System.Char]62)\$([System.Char]64)\$([System.Char]34)]{2,62}`$"
[System.String]${regex literal UPN Prefix (Anchorless)} = "[^\$([System.Char]47)\$([System.Char]92)\$([System.Char]91)\$([System.Char]93)\$([System.Char]58)\$([System.Char]59)\$([System.Char]124)\$([System.Char]61)\$([System.Char]44)\$([System.Char]43)\$([System.Char]42)\$([System.Char]63)\$([System.Char]60)\$([System.Char]62)\$([System.Char]64)\$([System.Char]34)]{2,62}"

[System.Text.RegularExpressions.Regex]${regex OU DistinguishedName}         = '^OU=[^,]+(?:,OU=[^,]+)*,DC=[^,]+(?:,DC=[^,]+)*$'                                                                  # All possible values for the 'DistinguishedName' property of an Organizational Unit in Active Directory: 
[System.Text.RegularExpressions.Regex]${regex Object DistinguishedName}     = 'OU=[^,]+(?:,OU=[^,]+)*,DC=[^,]+(?:,DC=[^,]+)*$'
[System.Text.RegularExpressions.Regex]${regex GUID}                         = '^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$'
[System.Text.RegularExpressions.Regex]${regex DNS Domain Name}              = '^(((?!-))(xn--|_)?[a-z0-9-]{0,61}[a-z0-9]{1,1}\.)*(xn--)?([a-z0-9][a-z0-9\-]{0,60}|[a-z0-9-]{1,30}\.[a-z]{2,})$'
[System.Text.RegularExpressions.Regex]${regex DNS Domain Name (Anchorless)} = '(((?!-))(xn--|_)?[a-z0-9-]{0,61}[a-z0-9]{1,1}\.)*(xn--)?([a-z0-9][a-z0-9\-]{0,60}|[a-z0-9-]{1,30}\.[a-z]{2,})'
[System.String]${regex literal All ASCII}                                   = "$([System.Char]91)$([System.Char]32)$([System.Char]45)$([System.Char]126)$([System.Char]93)"                      # All printable ASCII characters, from space to tilde.   (32..126) | % {[System.Char]$_}
[System.Text.RegularExpressions.Regex]${regex All ASCII}                    = ${regex literal All ASCII}

# start msedge 'https://learn.microsoft.com/en-us/troubleshoot/windows-server/active-directory/naming-conventions-for-computer-domain-site-ou#dns-host-names'
[System.String]${regex literal DNS CNAME}              = '^[a-z0-9_-]{1,63}$'
[System.String]${regex literal DNS CNAME (Anchorless)} = '[a-z0-9_-]{1,63}'
<# -_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_- |
  This ^ is a valid CNAME for Windows DNS clients and DNS servers!
#>

<# ${regex literal UPN Prefix (Anchorless)} |
  start msedge.exe 'https://learn.microsoft.com/en-us/troubleshoot/microsoft-365-apps/office-suite-issues/username-contains-special-character#cause'
  start msedge.exe 'https://learn.microsoft.com/en-us/previous-versions/windows/it-pro/windows-2000-server/bb726984(v=technet.10)?redirectedfrom=MSDN'

  [System.Uint32][System.Char]'/' # [System.Char]47
  [System.Uint32][System.Char]'\' # [System.Char]92
  [System.Uint32][System.Char]'[' # [System.Char]91
  [System.Uint32][System.Char]']' # [System.Char]93
  [System.Uint32][System.Char]':' # [System.Char]58
  [System.Uint32][System.Char]';' # [System.Char]59
  [System.Uint32][System.Char]'|' # [System.Char]124
  [System.Uint32][System.Char]'=' # [System.Char]61
  [System.Uint32][System.Char]',' # [System.Char]44
  [System.Uint32][System.Char]'+' # [System.Char]43
  [System.Uint32][System.Char]'*' # [System.Char]42
  [System.Uint32][System.Char]'?' # [System.Char]63
  [System.Uint32][System.Char]'<' # [System.Char]60
  [System.Uint32][System.Char]'>' # [System.Char]62
  [System.Uint32][System.Char]'@' # [System.Char]64
  [System.Uint32][System.Char]'"' # [System.Char]34

  [^/\\\[\]\:;\|=,\+\*\?\<\>@"]

  "\$([System.Char]47)\$([System.Char]92)\$([System.Char]91)\$([System.Char]93)\$([System.Char]58)\$([System.Char]59)\$([System.Char]124)\$([System.Char]61)\$([System.Char]44)\$([System.Char]43)\$([System.Char]42)\$([System.Char]63)\$([System.Char]60)\$([System.Char]62)\$([System.Char]64)\$([System.Char]34)"
  '[' + "^\$([System.Char]47)\$([System.Char]92)\$([System.Char]91)\$([System.Char]93)\$([System.Char]58)\$([System.Char]59)\$([System.Char]124)\$([System.Char]61)\$([System.Char]44)\$([System.Char]43)\$([System.Char]42)\$([System.Char]63)\$([System.Char]60)\$([System.Char]62)\$([System.Char]64)\$([System.Char]34)" + ']'
  "[^\$([System.Char]47)\$([System.Char]92)\$([System.Char]91)\$([System.Char]93)\$([System.Char]58)\$([System.Char]59)\$([System.Char]124)\$([System.Char]61)\$([System.Char]44)\$([System.Char]43)\$([System.Char]42)\$([System.Char]63)\$([System.Char]60)\$([System.Char]62)\$([System.Char]64)\$([System.Char]34)]"
  "[^\$([System.Char]47)\$([System.Char]92)\$([System.Char]91)\$([System.Char]93)\$([System.Char]58)\$([System.Char]59)\$([System.Char]124)\$([System.Char]61)\$([System.Char]44)\$([System.Char]43)\$([System.Char]42)\$([System.Char]63)\$([System.Char]60)\$([System.Char]62)\$([System.Char]64)\$([System.Char]34)]{2,62}"
#>

[System.String]${regex literal Windows DirectoryName}              = '^[^\\/:*?"<>|\r\n]+$'
[System.String]${regex literal Windows DirectoryName (Anchorless)} = '[^\\/:*?"<>|\r\n]+'
#endregion

