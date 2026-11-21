${Pre-PKI Global Certificate Signer-Sequence 0} = $Node.'Pre-PKI Global Certificate Signer-Sequence 0'
if ($null -ne ${Pre-PKI Global Certificate Signer-Sequence 0}) {
  if (
    $null -ne ${Pre-PKI Global Certificate Signer-Sequence 0}.IsSingleInstance -and `
    $null -ne ${Pre-PKI Global Certificate Signer-Sequence 0}.FriendlyName
  ) {
    PrePKIGlobalCertificateSignerSequence0 ${Pre-PKI Global Certificate Signer-Sequence 0}.Resource_Title {
      IsSingleInstance            =       [System.String]${Pre-PKI Global Certificate Signer-Sequence 0}.IsSingleInstance
      FriendlyName                =       [System.String]${Pre-PKI Global Certificate Signer-Sequence 0}.FriendlyName
      Ensure                      =       [System.String]${Pre-PKI Global Certificate Signer-Sequence 0}.Ensure
      #PsDscRunAsCredential       =       [PSCredential]${Pre-PKI Global Certificate Signer-Sequence 0}.PsDscRunAsCredential
      DependsOn                   =       ${Dependencys Event Log Channel Status}
    }
    ${Dependency PrePKIGlobalCertificateSignerSequence0} = [System.String[]]@(
      "[PrePKIGlobalCertificateSignerSequence0]$(${Pre-PKI Global Certificate Signer-Sequence 0}.Resource_Title)"
    )
    ${Signal PrePKIGlobalCertificateSignerSequence0} = Get-ChildItem -Path 'Cert:\LocalMachine\My' -Recurse | Where-Object -FilterScript {
      $_.FriendlyName -eq 'Pre-PKI Global Certificate Signer'
    }

    # Structural data below is only written into the configuration document
    # if the global cert signing cert has been detected in Personal store. 
    if ($null -ne ${Signal PrePKIGlobalCertificateSignerSequence0}) {
      ${Pre-PKI Global Code Signer-Sequence 0} = $Node.'Pre-PKI Global Code Signer-Sequence 0'
      if ($null -ne ${Pre-PKI Global Code Signer-Sequence 0}) {
        PrePKIGlobalCodeSignerSequence0 ${Pre-PKI Global Code Signer-Sequence 0}.Resource_Title {
          IsSingleInstance           =      [System.String]${Pre-PKI Global Code Signer-Sequence 0}.IsSingleInstance
          FriendlyName               =      [System.String]${Pre-PKI Global Code Signer-Sequence 0}.FriendlyName
          Ensure                     =      [System.String]${Pre-PKI Global Code Signer-Sequence 0}.Ensure
          #PsDscRunAsCredential      =      [PSCredential]${Pre-PKI Global Code Signer-Sequence 0}.PsDscRunAsCredential
          DependsOn                  =      ${Dependency PrePKIGlobalCertificateSignerSequence0}
        }
        ${Dependency PrePKIGlobalCodeSignerSequence0} = [System.String[]]@(
          "[PrePKIGlobalCodeSignerSequence0]$(${Pre-PKI Global Code Signer-Sequence 0}.Resource_Title)"
        )
        ${Signal PrePKIGlobalCodeSignerSequence0} = Get-ChildItem -Path 'Cert:\LocalMachine\My' -Recurse | Where-Object -FilterScript {
          $_.FriendlyName -eq 'Pre-PKI Global Code Signer'
        }

        # Structural data below is only written into the configuration document
        # if the global code signing cert has been detected in Personal store. 
        if ($null -ne ${Signal PrePKIGlobalCodeSignerSequence0}) {
          ${Pre-PKI Global Certificate Signer-Sequence 1} = $Node.'Pre-PKI Global Certificate Signer-Sequence 1'
          if ($null -ne ${Pre-PKI Global Certificate Signer-Sequence 1}) {
            PrePKIGlobalCertificateSignerSequence1 ${Pre-PKI Global Certificate Signer-Sequence 1}.Resource_Title {
              IsSingleInstance           =     [System.String]${Pre-PKI Global Certificate Signer-Sequence 1}.IsSingleInstance
              FriendlyName               =     [System.String]${Pre-PKI Global Certificate Signer-Sequence 1}.FriendlyName
              Ensure                     =     [System.String]${Pre-PKI Global Certificate Signer-Sequence 1}.Ensure
              #PsDscRunAsCredential      =     [PSCredential]${Pre-PKI Global Certificate Signer-Sequence 1}.PsDscRunAsCredential
              DependsOn                  =     ${Dependency PrePKIGlobalCertificateSignerSequence0}
            }
            ${Dependency PrePKIGlobalCertificateSignerSequence1} = [System.String[]]@(
              "[PrePKIGlobalCertificateSignerSequence1]$(${Pre-PKI Global Certificate Signer-Sequence 1}.Resource_Title)"
            )
            ${Signal PrePKIGlobalCertificateSignerSequence1} = Get-ChildItem -Path 'Cert:\LocalMachine\Root' -Recurse | Where-Object -FilterScript {
              $_.FriendlyName -eq 'Pre-PKI Global Certificate Signer'
            }

            ${Pre-PKI Global Code Signer-Sequence 1} = $Node.'Pre-PKI Global Code Signer-Sequence 1'
            if ($null -ne ${Pre-PKI Global Code Signer-Sequence 1}) {
              # Structural data below is only written into the configuration document
              # if the global cert signing cert has been detected in Root store.
              if ($null -ne ${Signal PrePKIGlobalCertificateSignerSequence1}) {
                #region | Private key to digitally sign a .MOF + Code Signing certificate to validate digital signature on that .MOF |
                PrePKIGlobalCodeSignerSequence1 ${Pre-PKI Global Code Signer-Sequence 1}.Resource_Title {
                  IsSingleInstance           =      [System.String]${Pre-PKI Global Code Signer-Sequence 1}.IsSingleInstance
                  FriendlyName               =      [System.String]${Pre-PKI Global Code Signer-Sequence 1}.FriendlyName
                  Ensure                     =      [System.String]${Pre-PKI Global Code Signer-Sequence 1}.Ensure
                  #PsDscRunAsCredential      =      [PSCredential]${Pre-PKI Global Code Signer-Sequence 1}.PsDscRunAsCredential
                  DependsOn                  =      ${Dependency PrePKIGlobalCodeSignerSequence0}
                }
                ${Dependency PrePKIGlobalCodeSignerSequence1} = [System.String[]]@(
                  "[PrePKIGlobalCodeSignerSequence1]$(${Pre-PKI Global Code Signer-Sequence 1}.Resource_Title)"
                )
                #endregion

                #region | Document Encryption certs to encrypt sensitive strings in MOF files |
                ${New Document Encryption Certs for MOF Password Protection} = $Node.'New Document Encryption Certs for MOF Password Protection'
                if ($null -ne ${New Document Encryption Certs for MOF Password Protection}) {
                  foreach (${New Document Encryption Cert for MOF Password Protection} in ${New Document Encryption Certs for MOF Password Protection}) {
                    if (
                      $null -ne ${New Document Encryption Cert for MOF Password Protection}.FriendlyName
                    ) {
                      PrePKIMofPasswordProtectionSequence0 ${New Document Encryption Cert for MOF Password Protection}.Resource_Title {
                        FriendlyName                =      [System.String]${New Document Encryption Cert for MOF Password Protection}.FriendlyName
                        Ensure                      =      [System.String]${New Document Encryption Cert for MOF Password Protection}.Ensure
                        #PsDscRunAsCredential       =      [PSCredential]${New Document Encryption Cert for MOF Password Protection}.PsDscRunAsCredential
                        #DependsOn                   =      ${Dependency PrePKIGlobalCertificateSignerSequence0}
                      }
                    }
                  }
                }

                ${CER Files of Document Encryption certs for MOF Password Protection} = $Node.'CER Files of Document Encryption certs for MOF Password Protection'
                if ($null -ne ${CER Files of Document Encryption certs for MOF Password Protection}) {
                  foreach (${CER File of Document Encryption cert for MOF Password Protection} in ${CER Files of Document Encryption certs for MOF Password Protection}) {
                    # ${Signal PrePKIMofPasswordProtectionSequence0} = Get-ChildItem -Path 'Cert:\LocalMachine\My' -Recurse | Where-Object -FilterScript {$_.FriendlyName -eq ${CER File of Document Encryption cert for MOF Password Protection}.FriendlyName}
                    ${Signal PrePKIMofPasswordProtectionSequence0} = Test-Path -Path "${env:Pre-PKI CertFSOs}\$(${CER File of Document Encryption cert for MOF Password Protection}.FriendlyName).txt"
                    # Structural data below is only written into the configuration document
                    # if the .txt containing cert thumbprint has been exported, which implies that 
                    # the corresponding cert has established in the Personal store.
                    if (
                      ${Signal PrePKIMofPasswordProtectionSequence0}
                    ) {
                      if (
                        $null -ne ${CER File of Document Encryption cert for MOF Password Protection}.FriendlyName
                      ) {
                        PrePKIMofPasswordProtectionSequence1 ${CER File of Document Encryption cert for MOF Password Protection}.Resource_Title {
                          FriendlyName                =        [System.String]${CER File of Document Encryption cert for MOF Password Protection}.FriendlyName
                          Ensure                      =        [System.String]${CER File of Document Encryption cert for MOF Password Protection}.Ensure
                          #PsDscRunAsCredential       =        [PSCredential]${CER File of Document Encryption cert for MOF Password Protection}.PsDscRunAsCredential
                          DependsOn                   =        ${Dependency PrePKIGlobalCertificateSignerSequence0}
                        }
                      }
                    }
                  }
                }

                ${PFX Files of Document Encryption certs for MOF Password Protection} = $Node.'PFX Files of Document Encryption certs for MOF Password Protection'
                if ($null -ne ${PFX Files of Document Encryption certs for MOF Password Protection}) {
                  foreach (${PFX File of Document Encryption cert for MOF Password Protection} in ${PFX Files of Document Encryption certs for MOF Password Protection}) {
                    ${Signal PrePKIMofPasswordProtectionSequence0} = Get-ChildItem -Path 'Cert:\LocalMachine\My' -Recurse | Where-Object -FilterScript {$_.FriendlyName -eq ${PFX File of Document Encryption cert for MOF Password Protection}.FriendlyName}

                    # Structural data below is only written into the configuration document
                    # if the certificate has been established in the Personal store, which 
                    # implies that the corresponding thumbprint has been exported to .txt
                    if (
                      ${Signal PrePKIMofPasswordProtectionSequence0}
                    ) {
                      if (
                        $null -ne ${PFX File of Document Encryption cert for MOF Password Protection}.Path
                      ) {
                        <#
                          start msedge.exe 'https://github.com/dsccommunity/CertificateDsc/wiki/CertificateExport'
                          Get-DscResourceProperty.ps1 -ModuleName 'CertificateDsc' -ResourceName 'CertificateExport' | clip.exe

                          Name                 IsKey Mandatory TypeConstraint  Values
                          ----                 ----- --------- --------------  ------
                          Path                  True      True String          {}
                          AllowExpired         False     False Boolean         {}
                          ChainOption          False     False String          {BuildChain | EndEntityCertOnly}
                          DNSName              False     False StringArray     {}
                          EnhancedKeyUsage     False     False StringArray     {}
                          FriendlyName         False     False String          {}
                          Issuer               False     False String          {}
                          KeyUsage             False     False StringArray     {}
                          MatchSource          False     False Boolean         {}
                          Password             False     False MSFT_Credential {}
                          ProtectTo            False     False StringArray     {}
                          Store                False     False String          {}
                          Subject              False     False String          {}
                          Thumbprint           False     False String          {}
                          Type                 False     False String          {Cert | P7B | SST | PFX}
                          PsDscRunAsCredentia1 False     False MSFT_Credential {}
                          DependsOn            False     False StringArray     {}
                        #>

                        CertificateExport ${PFX File of Document Encryption cert for MOF Password Protection}.Resource_Title {
                          Path                        =        [System.String]${PFX File of Document Encryption cert for MOF Password Protection}.Path
                          FriendlyName                =        [System.String]${PFX File of Document Encryption cert for MOF Password Protection}.FriendlyName
                          Thumbprint                  =        [System.String]${PFX File of Document Encryption cert for MOF Password Protection}.Thumbprint
                          Type                        =        [System.String]${PFX File of Document Encryption cert for MOF Password Protection}.Type
                          Password                    =        [PSCredential]${PFX File of Document Encryption cert for MOF Password Protection}.Password
                          #Ensure = $null  # The 'CertificateExport' DSC Resource does not define the 'Ensure' property! See 'https://github.com/dsccommunity/CertificateDsc/wiki/CertificateExport'
                          #PsDscRunAsCredential       =        [PSCredential]${PFX File of Document Encryption cert for MOF Password Protection}.PsDscRunAsCredential
                          DependsOn                   =        ${Dependency PrePKIGlobalCertificateSignerSequence0}
                        }
                      }
                    }
                  }
                }
                #endregion

                #region | Document Encryption certs to secure event log records |
                ${New Document Encryption Certs for Event Log Privacy} = $Node.'New Document Encryption Certs for Event Log Privacy'
                if ($null -ne ${New Document Encryption Certs for Event Log Privacy}) {
                  foreach (${New Document Encryption Cert for Event Log Privacy} in ${New Document Encryption Certs for Event Log Privacy}) {
                    if (
                      $null -ne ${New Document Encryption Cert for Event Log Privacy}.FriendlyName
                    ) {
                      PrePKIEventLogRecordProtectorSequence0 ${New Document Encryption Cert for Event Log Privacy}.Resource_Title {
                        FriendlyName                =      [System.String]${New Document Encryption Cert for Event Log Privacy}.FriendlyName
                        Ensure                      =      [System.String]${New Document Encryption Cert for Event Log Privacy}.Ensure
                        #PsDscRunAsCredential       =      [PSCredential]${New Document Encryption Cert for Event Log Privacy}.PsDscRunAsCredential
                        DependsOn                   =      ${Dependency PrePKIGlobalCertificateSignerSequence0}
                      }
                    }
                  }
                }

                ${CER Files of Document Encryption certs for Event Log Privacy} = $Node.'CER Files of Document Encryption certs for Event Log Privacy'
                if ($null -ne ${CER Files of Document Encryption certs for Event Log Privacy}) {
                  foreach (${CER File of Document Encryption certs for Event Log Privacy} in ${CER Files of Document Encryption certs for Event Log Privacy}) {
                    # ${Signal PrePKIEventLogRecordProtectorSequence0} = Get-ChildItem -Path 'Cert:\LocalMachine\My' -Recurse | Where-Object -FilterScript {$_.FriendlyName -eq ${CER File of Document Encryption certs for Event Log Privacy}.FriendlyName}
                    ${Signal PrePKIEventLogRecordProtectorSequence0} = Test-Path -Path "${env:Pre-PKI CertFSOs}\$(${CER File of Document Encryption certs for Event Log Privacy}.FriendlyName).txt"
                    # Structural data below is only written into the configuration document
                    # if the .txt containing cert thumbprint has been exported, which implies that 
                    # the corresponding cert has established in the Personal store.
                    if (
                      ${Signal PrePKIEventLogRecordProtectorSequence0}
                    ) {
                      if (
                        $null -ne ${CER File of Document Encryption certs for Event Log Privacy}.FriendlyName
                      ) {
                        PrePKIEventLogRecordProtectorSequence1 ${CER File of Document Encryption certs for Event Log Privacy}.Resource_Title {
                          FriendlyName                =        [System.String]${CER File of Document Encryption certs for Event Log Privacy}.FriendlyName
                          Ensure                      =        [System.String]${CER File of Document Encryption certs for Event Log Privacy}.Ensure
                          #PsDscRunAsCredential       =        [PSCredential]${CER File of Document Encryption certs for Event Log Privacy}.PsDscRunAsCredential
                          DependsOn                   =        ${Dependency PrePKIGlobalCertificateSignerSequence0}
                        }
                      }
                    }
                  }
                }

                ${PFX Files of Document Encryption certs for Event Log Privacy} = $Node.'PFX Files of Document Encryption certs for Event Log Privacy'
                if ($null -ne ${PFX Files of Document Encryption certs for Event Log Privacy}) {
                  foreach (${PFX File of Document Encryption cert for Event Log Privacy} in ${PFX Files of Document Encryption certs for Event Log Privacy}) {
                    ${Signal PrePKIEventLogRecordProtectorSequence0} = Get-ChildItem -Path 'Cert:\LocalMachine\My' -Recurse | Where-Object -FilterScript {$_.FriendlyName -eq ${PFX File of Document Encryption cert for Event Log Privacy}.FriendlyName}

                    # Structural data below is only written into the configuration document
                    # if the certificate has been established in the Personal store, which 
                    # implies that the corresponding thumbprint has been exported to .txt
                    if (
                      ${Signal PrePKIEventLogRecordProtectorSequence0}
                    ) {
                      if (
                        $null -ne ${PFX File of Document Encryption cert for Event Log Privacy}.Path
                      ) {
                        CertificateExport ${PFX File of Document Encryption cert for Event Log Privacy}.Resource_Title {
                          Path                        =        [System.String]${PFX File of Document Encryption cert for Event Log Privacy}.Path
                          FriendlyName                =        [System.String]${PFX File of Document Encryption cert for Event Log Privacy}.FriendlyName
                          Thumbprint                  =        [System.String]${PFX File of Document Encryption cert for Event Log Privacy}.Thumbprint
                          Type                        =        [System.String]${PFX File of Document Encryption cert for Event Log Privacy}.Type
                          Password                    =        [PSCredential]${PFX File of Document Encryption cert for Event Log Privacy}.Password
                          #PsDscRunAsCredential       =        [PSCredential]${PFX File of Document Encryption cert for Event Log Privacy}.PsDscRunAsCredential
                          DependsOn                   =        ${Dependency PrePKIGlobalCertificateSignerSequence0}
                        }
                      }
                    }
                  }
                }
                #endregion

                #region | Server Authentication certs for WinRM sessions |
                ${New Server Authentication certs for Mutual Authentication} = $Node.'New Server Authentication certs for Mutual Authentication'
                if ($null -ne ${New Server Authentication certs for Mutual Authentication}) {
                  foreach (${New Server Authentication cert for Mutual Authentication} in ${New Server Authentication certs for Mutual Authentication}) {
                    if (
                      $null -ne ${New Server Authentication cert for Mutual Authentication}.FriendlyName
                    ) {
                      PrePKIServerAuthenticationCertificateSequence0 ${New Server Authentication cert for Mutual Authentication}.Resource_Title {
                        FriendlyName                =      [System.String]${New Server Authentication cert for Mutual Authentication}.FriendlyName
                        DnsZoneName                 =      [System.String]${New Server Authentication cert for Mutual Authentication}.DnsZoneName
                        Ensure                      =      [System.String]${New Server Authentication cert for Mutual Authentication}.Ensure
                        #PsDscRunAsCredential       =      [PSCredential]${New Server Authentication cert for Mutual Authentication}.PsDscRunAsCredential
                        DependsOn                   =      ${Dependency PrePKIGlobalCertificateSignerSequence0}
                      }
                    }
                  }
                }
                
                ${CER Files of Server Authentication certs for Mutual Authentication} = $Node.'CER Files of Server Authentication certs for Mutual Authentication'
                if ($null -ne ${CER Files of Server Authentication certs for Mutual Authentication}) {
                  foreach (${CER File of Server Authentication cert for Mutual Authentication} in ${CER Files of Server Authentication certs for Mutual Authentication}) {
                    # ${Signal PrePKIServerAuthenticationCertificateSequence0} = Get-ChildItem -Path 'Cert:\LocalMachine\My' -Recurse | Where-Object -FilterScript {$_.FriendlyName -eq ${CER File of Server Authentication cert for Mutual Authentication}.FriendlyName}
                    ${Signal PrePKIServerAuthenticationCertificateSequence0} = Test-Path -Path "${env:Pre-PKI CertFSOs}\$(${CER File of Server Authentication cert for Mutual Authentication}.FriendlyName).txt"
                    # Structural data below is only written into the configuration document
                    # if the .txt containing cert thumbprint has been exported, which implies that 
                    # the corresponding cert has established in the Personal store.
                    if ( # If .txt containing cert thumbprint has been exported... |
                      ${Signal PrePKIServerAuthenticationCertificateSequence0}
                    ) {
                      if (
                        $null -ne ${CER File of Server Authentication cert for Mutual Authentication}.FriendlyName
                      ) {
                        PrePKIServerAuthenticationCertificateSequence1 ${CER File of Server Authentication cert for Mutual Authentication}.Resource_Title {
                          FriendlyName                =        [System.String]${CER File of Server Authentication cert for Mutual Authentication}.FriendlyName
                          Ensure                      =        [System.String]${CER File of Server Authentication cert for Mutual Authentication}.Ensure
                          #PsDscRunAsCredential       =        [PSCredential]${CER File of Server Authentication cert for Mutual Authentication}.PsDscRunAsCredential
                          DependsOn                   =        ${Dependency PrePKIGlobalCertificateSignerSequence0}
                        }
                      }
                    }
                  }
                }

                ${PFX Files of Server Authentication certs for Mutual Authentication} = $Node.'PFX Files of Server Authentication certs for Mutual Authentication'
                if ($null -ne ${PFX Files of Server Authentication certs for Mutual Authentication}) {
                  foreach (${PFX File of Server Authentication cert for Mutual Authentication} in ${PFX Files of Server Authentication certs for Mutual Authentication}) {
                    ${Signal PrePKIServerAuthenticationCertificateSequence0} = Get-ChildItem -Path 'Cert:\LocalMachine\My' -Recurse | Where-Object -FilterScript {$_.FriendlyName -eq ${PFX File of Server Authentication cert for Mutual Authentication}.FriendlyName}

                    # Structural data below is only written into the configuration document
                    # if the certificate has been established in the Personal store, which 
                    # implies that the corresponding thumbprint has been exported to .txt
                    if (
                      ${Signal PrePKIServerAuthenticationCertificateSequence0}
                    ) {
                      if (
                        $null -ne ${PFX File of Server Authentication cert for Mutual Authentication}.Path
                      ) {
                        CertificateExport ${PFX File of Server Authentication cert for Mutual Authentication}.Resource_Title {
                          Path                        =        [System.String]${PFX File of Server Authentication cert for Mutual Authentication}.Path
                          FriendlyName                =        [System.String]${PFX File of Server Authentication cert for Mutual Authentication}.FriendlyName
                          Thumbprint                  =        [System.String]${PFX File of Server Authentication cert for Mutual Authentication}.Thumbprint
                          Type                        =        [System.String]${PFX File of Server Authentication cert for Mutual Authentication}.Type
                          Password                    =        [PSCredential]${PFX File of Server Authentication cert for Mutual Authentication}.Password
                          #PsDscRunAsCredential       =        [PSCredential]${PFX File of Server Authentication cert for Mutual Authentication}.PsDscRunAsCredential
                          DependsOn                   =        ${Dependency PrePKIGlobalCertificateSignerSequence0}
                        }
                      }
                    }
                  }
                }
                #endregion

                #region | Client Authentication certs for WinRM sessions |
                ${New Collection Set of Client Authentication certs for Mutual Authentication} = $Node.'New Collection Set of Client Authentication certs for Mutual Authentication'
                if ($null -ne ${New Collection Set of Client Authentication certs for Mutual Authentication}) {
                  foreach (${New Collection of Client Authentication certs for Mutual Authentication} in ${New Collection Set of Client Authentication certs for Mutual Authentication}) {
                    foreach (${New Client Authentication cert for Mutual Authentication} in ${New Collection of Client Authentication certs for Mutual Authentication}) {
                      if (
                        $null -ne ${New Client Authentication cert for Mutual Authentication}.FriendlyName
                      ) {
                        PrePKIClientAuthenticationCertificateSequence0 ${New Client Authentication cert for Mutual Authentication}.Resource_Title {
                          FriendlyName                =        [System.String]${New Client Authentication cert for Mutual Authentication}.FriendlyName
                          Ensure                      =        [System.String]${New Client Authentication cert for Mutual Authentication}.Ensure
                          #PsDscRunAsCredential       =        [PSCredential]${New Client Authentication cert for Mutual Authentication}.PsDscRunAsCredential
                          DependsOn                   =        ${Dependency PrePKIGlobalCertificateSignerSequence0}
                        }
                      }
                    }
                  }
                }

                ${CER File Collection Set of Client Authentication certs for Mutual Authentication} = $Node.'CER File Collection Set of Client Authentication certs for Mutual Authentication'
                if ($null -ne ${CER File Collection Set of Client Authentication certs for Mutual Authentication}) {
                  foreach (${CER File Collection of Client Authentication certs for Mutual Authentication} in ${CER File Collection Set of Client Authentication certs for Mutual Authentication}) {
                    foreach (${CER File of Client Authentication cert for Mutual Authentication} in ${CER File Collection of Client Authentication certs for Mutual Authentication}) {
                      # ${Signal PrePKIClientAuthenticationCertificateSequence0} = Get-ChildItem -Path 'Cert:\LocalMachine\My' -Recurse | Where-Object -FilterScript {$_.FriendlyName -eq ${CER File of Client Authentication cert for Mutual Authentication}.FriendlyName}
                      ${Signal PrePKIClientAuthenticationCertificateSequence0} = Test-Path -Path "${env:Pre-PKI CertFSOs}\$(${CER File of Client Authentication cert for Mutual Authentication}.FriendlyName).txt"
                      # Structural data below is only written into the configuration document
                      # if the .txt containing cert thumbprint has been exported, which implies that 
                      # the corresponding cert has established in the Personal store.
                      if ( # If .txt containing cert thumbprint has been exported... |
                        ${Signal PrePKIClientAuthenticationCertificateSequence0}
                      ) {
                        if ( # And if the mandatory FriendlyName property has been defined...
                          $null -ne ${CER File of Client Authentication cert for Mutual Authentication}.FriendlyName
                        ) {
                          PrePKIClientAuthenticationCertificateSequence1 ${CER File of Client Authentication cert for Mutual Authentication}.Resource_Title {
                            FriendlyName                =        [System.String]${CER File of Client Authentication cert for Mutual Authentication}.FriendlyName
                            Ensure                      =        [System.String]${CER File of Client Authentication cert for Mutual Authentication}.Ensure
                            #PsDscRunAsCredential       =        [PSCredential]${CER File of Client Authentication cert for Mutual Authentication}.PsDscRunAsCredential
                            DependsOn                   =        ${Dependency PrePKIGlobalCertificateSignerSequence0}
                          }
                        }
                      }
                    }
                  }
                }

                ${PFX File Collection Set of Client Authentication certs for Mutual Authentication} = $Node.'PFX File Collection Set of Client Authentication certs for Mutual Authentication'
                if ($null -ne ${PFX File Collection Set of Client Authentication certs for Mutual Authentication}) {
                  foreach (${PFX File Collection of Client Authentication certs for Mutual Authentication} in ${PFX File Collection Set of Client Authentication certs for Mutual Authentication}) {
                    foreach (${PFX File of Client Authentication cert for Mutual Authentication} in ${PFX File Collection of Client Authentication certs for Mutual Authentication}) {
                      ${Signal PrePKIClientAuthenticationCertificateSequence0} = Test-Path -Path "${env:Pre-PKI CertFSOs}\$(${PFX File of Client Authentication cert for Mutual Authentication}.FriendlyName).txt"

                      # Structural data below is only written into the configuration document
                      # if the .txt containing cert thumbprint has been exported, which implies that 
                      # the corresponding cert has established in the Personal store.
                      if ( # If .txt containing cert thumbprint has been exported... |
                        ${Signal PrePKIClientAuthenticationCertificateSequence0}
                      ) {
                        if ( # And if the mandatory FriendlyName property has been defined...
                          $null -ne ${PFX File of Client Authentication cert for Mutual Authentication}.Path
                        ) {
                          CertificateExport ${PFX File of Client Authentication cert for Mutual Authentication}.Resource_Title {
                            Path                        =        [System.String]${PFX File of Client Authentication cert for Mutual Authentication}.Path
                            FriendlyName                =        [System.String]${PFX File of Client Authentication cert for Mutual Authentication}.FriendlyName
                            Thumbprint                  =        [System.String]${PFX File of Client Authentication cert for Mutual Authentication}.Thumbprint
                            Type                        =        [System.String]${PFX File of Client Authentication cert for Mutual Authentication}.Type
                            Password                    =        [PSCredential]${PFX File of Client Authentication cert for Mutual Authentication}.Password
                            #PsDscRunAsCredential       =        [PSCredential]${PFX File of Client Authentication cert for Mutual Authentication}.PsDscRunAsCredential
                            DependsOn                   =        ${Dependency PrePKIGlobalCertificateSignerSequence0}
                          }
                        }
                      }
                    }
                  }
                }
                #endregion
              }
            }
          }
        }
      }
    }
  }
}