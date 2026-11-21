# Organization Naming | Location | Culture | Geography |
${Organization Naming File Names} = $Node.'Organization Naming File Names'
if ($null -ne ${Organization Naming File Names}) {
  ${Dependencys Organization Naming File Names} = [System.Collections.ArrayList]::New()
  foreach (${Organization Naming File Name} in ${Organization Naming File Names}) {
    File ${Organization Naming File Name}.Resource_Title {
      DestinationPath            =      [System.String]${Organization Naming File Name}.DestinationPath
      Type                       =      [System.String]${Organization Naming File Name}.Type
      Attributes                 =      [System.String[]]${Organization Naming File Name}.Attributes
      Contents                   =      [System.String]${Organization Naming File Name}.Contents
      Force                      =      [System.Boolean]${Organization Naming File Name}.Force
      #Credential                =      [PSCredential]${Organization Naming File Name}.Credential
      Ensure                     =      [System.String]${Organization Naming File Name}.Ensure
      #PsDscRunAsCredential      =      [PSCredential]${Organization Naming File Name}.PsDscRunAsCredential
      DependsOn                  =      ${Dependencys Event Log Channel Status}
    }

    ${Dependencys Organization Naming File Names}.Add(
      [System.String]"[File]$(${Organization Naming File Name}.Resource_Title)"
    ) | Out-Null
  }
}

${UPN Suffix Set 02} = $Node.'UPN Suffix Set 02'
if ($null -ne ${UPN Suffix Set 02}) {
  ${Dependencys UPN Suffix Set 02} = [System.Collections.ArrayList]::New()
  foreach (${UPN Suffix} in ${UPN Suffix Set 02}) {
    File ${UPN Suffix}.Resource_Title {
      DestinationPath             =      [System.String]${UPN Suffix}.DestinationPath
      Type                        =      [System.String]${UPN Suffix}.Type
      Attributes                  =      [System.String[]]${UPN Suffix}.Attributes
      Contents                    =      [System.String]${UPN Suffix}.Contents
      Force                       =      [System.Boolean]${UPN Suffix}.Force
      #Credential                 =      [PSCredential]${UPN Suffix}.Credential
      Ensure                      =      [System.String]${UPN Suffix}.Ensure
      #PsDscRunAsCredential       =      [PSCredential]${UPN Suffix}.PsDscRunAsCredential
      DependsOn                   =      ${Dependencys Event Log Channel Status}
    }

    ${Dependencys UPN Suffix Set 02}.Add(
      [System.String]"[File]$(${UPN Suffix}.Resource_Title)"
    ) | Out-Null
  }
}

${Public Key Infrastructure File Names} = $Node.'Public Key Infrastructure File Names'
if ($null -ne ${Public Key Infrastructure File Names}) {
  ${Dependencys Public Key Infrastructure File Names} = [System.Collections.ArrayList]::New()
  foreach (${Public Key Infrastructure File Name} in ${Public Key Infrastructure File Names}) {
    File ${Public Key Infrastructure File Name}.Resource_Title {
      DestinationPath             =       [System.String]${Public Key Infrastructure File Name}.DestinationPath
      Type                        =       [System.String]${Public Key Infrastructure File Name}.Type
      Attributes                  =       [System.String[]]${Public Key Infrastructure File Name}.Attributes
      Contents                    =       [System.String]${Public Key Infrastructure File Name}.Contents
      Force                       =       [System.Boolean]${Public Key Infrastructure File Name}.Force
      #Credential                 =       [PSCredential]${Public Key Infrastructure File Name}.Credential
      Ensure                      =       [System.String]${Public Key Infrastructure File Name}.Ensure
      #PsDscRunAsCredential       =       [PSCredential]${Public Key Infrastructure File Name}.PsDscRunAsCredential
      DependsOn                   =       ${Dependencys Event Log Channel Status}
    }

    ${Dependencys Public Key Infrastructure File Names}.Add(
      [System.String]"[File]$(${Public Key Infrastructure File Name}.Resource_Title)"
    ) | Out-Null
  }
}

# Mainly for unattend.xml files
${Location Culture Geography File Names} = $Node.'Location Culture Geography File Names'
if ($null -ne ${Location Culture Geography File Names}) {
  ${Dependencys Location Culture Geography File Names} = [System.Collections.ArrayList]::New()
  foreach (${Location Culture Geography File Name} in ${Location Culture Geography File Names}) {
    File ${Location Culture Geography File Name}.Resource_Title {
      DestinationPath             =       [System.String]${Location Culture Geography File Name}.DestinationPath
      Type                        =       [System.String]${Location Culture Geography File Name}.Type
      Attributes                  =       [System.String[]]${Location Culture Geography File Name}.Attributes
      Contents                    =       [System.String]${Location Culture Geography File Name}.Contents
      Force                       =       [System.Boolean]${Location Culture Geography File Name}.Force
      #Credential                 =       [PSCredential]${Location Culture Geography File Name}.Credential
      Ensure                      =       [System.String]${Location Culture Geography File Name}.Ensure
      #PsDscRunAsCredential       =       [PSCredential]${Location Culture Geography File Name}.PsDscRunAsCredential
      DependsOn                   =       ${Dependencys Event Log Channel Status}
    }

    ${Dependencys Location Culture Geography File Names}.Add(
      [System.String]"[File]$(${Location Culture Geography File Name}.Resource_Title)"
    ) | Out-Null
  }
}

${Physical RAM on this DSC Authoring Station File Name} = $Node.'Physical RAM on this DSC Authoring Station File Name'
if ($null -ne ${Physical RAM on this DSC Authoring Station File Name}) {
  ${Dependency Physical RAM on this DSC Authoring Station File Name} = [System.Collections.ArrayList]::New()
  File ${Physical RAM on this DSC Authoring Station File Name}.Resource_Title {
    DestinationPath             =       [System.String]${Physical RAM on this DSC Authoring Station File Name}.DestinationPath
    Type                        =       [System.String]${Physical RAM on this DSC Authoring Station File Name}.Type
    Attributes                  =       [System.String[]]${Physical RAM on this DSC Authoring Station File Name}.Attributes
    Contents                    =       [System.String]${Physical RAM on this DSC Authoring Station File Name}.Contents
    Force                       =       [System.Boolean]${Physical RAM on this DSC Authoring Station File Name}.Force
    #Credential                 =       [PSCredential]${Physical RAM on this DSC Authoring Station File Name}.Credential
    Ensure                      =       [System.String]${Physical RAM on this DSC Authoring Station File Name}.Ensure
    #PsDscRunAsCredential       =       [PSCredential]${Physical RAM on this DSC Authoring Station File Name}.PsDscRunAsCredential
    DependsOn                   =       ${Dependencys Event Log Channel Status}
  }

  ${Dependency Physical RAM on this DSC Authoring Station File Name}.Add(
    [System.String]"[File]$(${Physical RAM on this DSC Authoring Station File Name}.Resource_Title)"
  ) | Out-Null
}

${Physical MAC Address File Names} = $Node.'Physical MAC Address File Names'
if ($null -ne ${Physical MAC Address File Names}) {
  ${Dependencys Physical MAC Address File Names} = [System.Collections.ArrayList]::New()
  foreach (${Physical MAC Address File Name} in ${Physical MAC Address File Names}) {
    File ${Physical MAC Address File Name}.Resource_Title {
      DestinationPath             =       [System.String]${Physical MAC Address File Name}.DestinationPath
      Type                        =       [System.String]${Physical MAC Address File Name}.Type
      Attributes                  =       [System.String[]]${Physical MAC Address File Name}.Attributes
      Contents                    =       [System.String]${Physical MAC Address File Name}.Contents
      Force                       =       [System.Boolean]${Physical MAC Address File Name}.Force
      #Credential                 =       [PSCredential]${Physical MAC Address File Name}.Credential
      Ensure                      =       [System.String]${Physical MAC Address File Name}.Ensure
      #PsDscRunAsCredential       =       [PSCredential]${Physical MAC Address File Name}.PsDscRunAsCredential
      DependsOn                   =       ${Dependencys Event Log Channel Status}
    }

    ${Dependencys Physical MAC Address File Names}.Add(
      [System.String]"[File]$(${Physical MAC Address File Name}.Resource_Title)"
    ) | Out-Null
  }
}

${Custom PowerShell Class Static Property File Names} = $Node.'Custom PowerShell Class Static Property File Names'
if ($null -ne ${Custom PowerShell Class Static Property File Names}) {
  ${Dependencys Custom PowerShell Class Static Property File Names} = [System.Collections.ArrayList]::New()
  foreach (${Custom PowerShell Class Static Property File Name} in ${Custom PowerShell Class Static Property File Names}) {
    File ${Custom PowerShell Class Static Property File Name}.Resource_Title {
      DestinationPath               =         [System.String]${Custom PowerShell Class Static Property File Name}.DestinationPath
      Type                          =         [System.String]${Custom PowerShell Class Static Property File Name}.Type
      Attributes                    =         [System.String[]]${Custom PowerShell Class Static Property File Name}.Attributes
      Contents                      =         [System.String]${Custom PowerShell Class Static Property File Name}.Contents
      Force                         =         [System.Boolean]${Custom PowerShell Class Static Property File Name}.Force
      #Credential                   =         [PSCredential]${Custom PowerShell Class Static Property File Name}.Credential
      Ensure                        =         [System.String]${Custom PowerShell Class Static Property File Name}.Ensure
      #PsDscRunAsCredential         =         [PSCredential]${Custom PowerShell Class Static Property File Name}.PsDscRunAsCredential
      DependsOn                     =         ${Dependencys Event Log Channel Status}
    }

    ${Dependencys Custom PowerShell Class Static Property File Names}.Add(
      [System.String]"[File]$(${Custom PowerShell Class Static Property File Name}.Resource_Title)"
    ) | Out-Null
  }
}

${Custom PowerShell Class Static Network Property File Names} = $Node.'Custom PowerShell Class Static Network Property File Names'
if ($null -ne ${Custom PowerShell Class Static Network Property File Names}) {
  ${Dependencys Custom PowerShell Class Static Network Property File Names} = [System.Collections.ArrayList]::New()
  foreach (${Custom PowerShell Class Static Network Property File Name} in ${Custom PowerShell Class Static Network Property File Names}) {
    File ${Custom PowerShell Class Static Network Property File Name}.Resource_Title {
      DestinationPath             =       [System.String]${Custom PowerShell Class Static Network Property File Name}.DestinationPath
      Type                        =       [System.String]${Custom PowerShell Class Static Network Property File Name}.Type
      Attributes                  =       [System.String[]]${Custom PowerShell Class Static Network Property File Name}.Attributes
      Contents                    =       [System.String]${Custom PowerShell Class Static Network Property File Name}.Contents
      Force                       =       [System.Boolean]${Custom PowerShell Class Static Network Property File Name}.Force
      #Credential                 =       [PSCredential]${Custom PowerShell Class Static Network Property File Name}.Credential
      Ensure                      =       [System.String]${Custom PowerShell Class Static Network Property File Name}.Ensure
      #PsDscRunAsCredential       =       [PSCredential]${Custom PowerShell Class Static Network Property File Name}.PsDscRunAsCredential
      DependsOn                   =       ${Dependencys Event Log Channel Status}
    }

    ${Dependencys Custom PowerShell Class Static Network Property File Names}.Add(
      [System.String]"[File]$(${Custom PowerShell Class Static Network Property File Name}.Resource_Title)"
    ) | Out-Null
  }
}

# Values for the filename of the .iso file of Windows Server (or Windows 10/11/12) downloaded from Microsoft.
${OS .iso File Names} = $Node.'OS .iso File Names'
if ($null -ne ${OS .iso File Names}) {
  ${Dependencys OS .iso File Names} = [System.Collections.ArrayList]::New()
  foreach (${OS .iso File Name} in ${OS .iso File Names}) {
    File ${OS .iso File Name}.Resource_Title {
      DestinationPath            =     [System.String]${OS .iso File Name}.DestinationPath
      Type                       =     [System.String]${OS .iso File Name}.Type
      Attributes                 =     [System.String[]]${OS .iso File Name}.Attributes
      Contents                   =     [System.String]${OS .iso File Name}.Contents
      Force                      =     [System.Boolean]${OS .iso File Name}.Force
      #Credential                =     [PSCredential]${OS .iso File Name}.Credential
      Ensure                     =     [System.String]${OS .iso File Name}.Ensure
      #PsDscRunAsCredential      =     [PSCredential]${OS .iso File Name}.PsDscRunAsCredential
      DependsOn                  =     ${Dependencys Event Log Channel Status}
    }

    ${Dependencys OS .iso File Names}.Add(
      [System.String]"[File]$(${OS .iso File Name}.Resource_Title)"
    ) | Out-Null
  }
}

# Values for the versions of the Windows Assessment and Deployment Kit (Windows ADK)
${Windows ADK Version File Names} = $Node.'Windows ADK Version File Names'
if ($null -ne ${Windows ADK Version File Names}) {
  ${Dependencys Windows ADK Version File Names} = [System.Collections.ArrayList]::New()
  foreach (${Windows ADK Version File Name} in ${Windows ADK Version File Names}) {
    File ${Windows ADK Version File Name}.Resource_Title {
      DestinationPath            =     [System.String]${Windows ADK Version File Name}.DestinationPath
      Type                       =     [System.String]${Windows ADK Version File Name}.Type
      Attributes                 =     [System.String[]]${Windows ADK Version File Name}.Attributes
      Contents                   =     [System.String]${Windows ADK Version File Name}.Contents
      Force                      =     [System.Boolean]${Windows ADK Version File Name}.Force
      #Credential                =     [PSCredential]${Windows ADK Version File Name}.Credential
      Ensure                     =     [System.String]${Windows ADK Version File Name}.Ensure
      #PsDscRunAsCredential      =     [PSCredential]${Windows ADK Version File Name}.PsDscRunAsCredential
      DependsOn                  =     ${Dependencys Event Log Channel Status}
    }

    ${Dependencys Windows ADK Version File Names}.Add(
      [System.String]"[File]$(${Windows ADK Version File Name}.Resource_Title)"
    ) | Out-Null
  }
}

${DNS Name of AD Forest Root Domain File Name} = $Node.'DNS Name of AD Forest Root Domain File Name'
if ($null -ne ${DNS Name of AD Forest Root Domain File Name}) {
  ${Dependency DNS Name of AD Forest Root Domain File Name} = [System.Collections.ArrayList]::New()
  File ${DNS Name of AD Forest Root Domain File Name}.Resource_Title {
    DestinationPath             =       [System.String]${DNS Name of AD Forest Root Domain File Name}.DestinationPath
    Type                        =       [System.String]${DNS Name of AD Forest Root Domain File Name}.Type
    Attributes                  =       [System.String[]]${DNS Name of AD Forest Root Domain File Name}.Attributes
    Contents                    =       [System.String]${DNS Name of AD Forest Root Domain File Name}.Contents
    Force                       =       [System.Boolean]${DNS Name of AD Forest Root Domain File Name}.Force
    #Credential                 =       [PSCredential]${DNS Name of AD Forest Root Domain File Name}.Credential
    Ensure                      =       [System.String]${DNS Name of AD Forest Root Domain File Name}.Ensure
    #PsDscRunAsCredential       =       [PSCredential]${DNS Name of AD Forest Root Domain File Name}.PsDscRunAsCredential
    DependsOn                   =       ${Dependencys Event Log Channel Status}
  }

  ${Dependency DNS Name of AD Forest Root Domain File Name}.Add(
    [System.String]"[File]$(${DNS Name of AD Forest Root Domain File Name}.Resource_Title)"
  ) | Out-Null
}