${VhdxFileFromIsoImage Set} = $Node.'VhdxFileFromIsoImage Set'
if ($null -ne ${VhdxFileFromIsoImage Set}) {
  ${Dependencys VhdxFileFromIsoImage Set} = [System.Collections.ArrayList]::New()
  foreach ($VhdxFileFromIsoImage in ${VhdxFileFromIsoImage Set}) {
    VhdxFileFromIsoImage $VhdxFileFromIsoImage.Resource_Title {
      VhdxFilePath                =       [System.String]$VhdxFileFromIsoImage.VhdxFilePath
      IndexOfImage                =       [System.Int32]$VhdxFileFromIsoImage.IndexOfImage
      IsoFilePath                 =       [System.String]$VhdxFileFromIsoImage.IsoFilePath
      DscResModZipFilePaths       =       [System.String[]]$VhdxFileFromIsoImage.DscResModZipFilePaths
      Ensure                      =       [System.String]$VhdxFileFromIsoImage.Ensure
      #PsDscRunAsCredential       =       [PSCredential]$VhdxFileFromIsoImage.PsDscRunAsCredential
      DependsOn                   =       ${Dependencys Event Log Channel Status}
    }

    ${Dependencys VhdxFileFromIsoImage Set}.Add(
      [System.String]"[VhdxFileFromIsoImage]$($VhdxFileFromIsoImage.Resource_Title)"
    ) | Out-Null
  }
}

${System VHDX Cascades} = $Node.'System VHDX Cascades'
if ($null -ne ${System VHDX Cascades}) {
  foreach (${System VHDX Cascade} in ${System VHDX Cascades}) {
    ${VHDX 1-Special__Copy Operation} = ${System VHDX Cascade}.'VHDX 1-Special__Copy Operation'
    ${VHDX 0-General Directory} = ([System.IO.FileInfo]${VHDX 1-Special__Copy Operation}.SourcePath).Directory
    ${Windows Server Image Index-VM} = ${VHDX 0-General Directory}.BaseName
    ${VHDX 1-Special File Path} = ${VHDX 1-Special__Copy Operation}.DestinationPath

    ${VHDX 1-Special Parent Path} = ([System.IO.FileInfo]${VHDX 1-Special File Path}).Directory.FullName
    ${VHDX 1-Special 2xParent Path} = ([System.IO.DirectoryInfo]${VHDX 1-Special Parent Path}).Parent.FullName

    ${Is node-specific VHDX 1-Special Directory present at MOF compilation} = Test-Path -Path ${VHDX 1-Special 2xParent Path}
    if (${Is node-specific VHDX 1-Special Directory present at MOF compilation}) {
      ${pattern (Anchorless)} = [System.Text.RegularExpressions.Regex]::Escape("[VhdxFileFromIsoImage]Deploy .vhdx file of Server 2025 edition with image index ${Windows Server Image Index-VM} into \VHDX 0-General\ directory")
      $pattern = '^' + ${pattern (Anchorless)} + '$'
      ${Dependency VhdxFileFromIsoImage} = ${Dependencys VhdxFileFromIsoImage Set} | Where-Object -FilterScript {$_ -match $pattern}

      ${Is Source File1 Present at Time of MOF Compilation} = Test-Path -Path ${VHDX 1-Special__Copy Operation}.SourcePath
      if (${Is Source File1 Present at Time of MOF Compilation}) {
        File ${VHDX 1-Special__Copy Operation}.Resource_Title {
          DestinationPath               =        [System.String]${VHDX 1-Special__Copy Operation}.DestinationPath
          SourcePath                    =        [System.String]${VHDX 1-Special__Copy Operation}.SourcePath
          Force                         =        [System.Boolean]${VHDX 1-Special__Copy Operation}.Force
          Type                          =        [System.String]${VHDX 1-Special__Copy Operation}.Type
          #Credential                   =        [PSCredential]${VHDX 1-Special__Copy Operation}.Credential
          Ensure                        =        [System.String]${VHDX 1-Special__Copy Operation}.Ensure
          #PsDscRunAsCredential         =        [PSCredential]${VHDX 1-Special__Copy Operation}.PsDscRunAsCredential
          DependsOn                     =        ${Dependency VhdxFileFromIsoImage}
        }

        ${Dependency Create UNPREPARED VHDX 1-Special by copying VHDX 0-General} = [System.String[]]@(
          "[File]$(${VHDX 1-Special__Copy Operation}.Resource_Title)"
        )

        ${Is Destination File1 Present at Time of MOF Compilation} = Test-Path -Path ${VHDX 1-Special__Copy Operation}.DestinationPath

        if (${Is Destination File1 Present at Time of MOF Compilation}) {
          ${VHDX 1-Special 2xParent Path} = Resolve-Path -Path "$(${VHDX 1-Special__Copy Operation}.DestinationPath)\..\.." | Select-Object -ExpandProperty 'Path'
          ${VHDX 1-Special 2xParent Directory} = [System.IO.DirectoryInfo]${VHDX 1-Special 2xParent Path}
          ${CNAME of Mgmt Interface on Node Config Target} = ${VHDX 1-Special 2xParent Directory}.BaseName
          $VmConfigTargetNode = $ConfigurationData.AllNodes.Where({$_.NodeMgmtCname -eq ${CNAME of Mgmt Interface on Node Config Target}})
          
          ${Prepare 1-Special VHDX} = ${VHDX 1-Special__Copy Operation}.'Prepare VHDX 1-Special'

          if ($null -ne ${Prepare 1-Special VHDX}) {
            if (
              $null -ne ${Prepare 1-Special VHDX}.VhdPath
            ) {
              <#
                Get-DscResourceProperty.ps1 -ModuleName 'HyperVDsc' -ResourceName 'VhdFile' | clip.exe`
                Name                 IsKey Mandatory TypeConstraint      Values
                ----                 ----- --------- --------------      ------
                VhdPath               True      True String              {}
                FileDirectory        False      True DSC_FileDirectory[] {}
                CheckSum             False     False String              { ModifiedDate | SHA-1 | SHA-256 | SHA-512 }
                PsDscRunAsCredentia1 False     False MSFT_Credential     {}
                DependsOn            False     False StringArray         {}
                #------------------------------------------------------------------------------------#
                NOTE: xoap example for VhdFile writes that 'Attributes' is a
                sub-property of the 'DSC_FileDirectory' property of the 'VhdFile' DSC Resource. 
                Investigate another time. 
              #>

              VhdFile ${Prepare 1-Special VHDX}.Resource_Title {
                VhdPath                   =     ${Prepare 1-Special VHDX}.VhdPath
                FileDirectory             =     $(
                  @(
                    #region | Environment Data Filtering Structure Reference |
                    if ( # Server Core |
                      ! (-not (${Windows Server Image Index-VM} % 2))
                    ) {}
                    if ( # Desktop Experience |
                      -not (${Windows Server Image Index-VM} % 2)
                    ) {}
                    if ( # VM that creates the Active Directory Forest |
                      $VmConfigTargetNode.Life          -eq $true              -and `
                      $VmConfigTargetNode.SuperEmpire   -eq 'Microsoft'        -and `
                      $VmConfigTargetNode.Empire        -eq 'VM'               -and `
                      $VmConfigTargetNode.SubEmpire     -eq 'Windows Server'   -and `
                      $VmConfigTargetNode.SuperDominion -match '^Yes'          -and `
                      $VmConfigTargetNode.Dominion      -eq 'Active Directory' -and `
                      $VmConfigTargetNode.Kingdom       -eq 'New AD Forest'
                    ) {}
                    #endregion

                    #region | Eliminate 'profile.ps1' or 'unattend.xml', if present |
                    DSC_FileDirectory { # Ensure the Windows PowerShell AUAH profile.ps1 file is ABSENT for this pass |
                      DestinationPath = [System.String]".\Windows\System32\WindowsPowerShell\v1.0\profile.ps1"
                      Type            = [System.String]'File'
                      #Force           = [System.Boolean]$true
                      Ensure          = [System.String]'Absent'
                    }
                    DSC_FileDirectory { # Ensure the "$env:SystemDrive\unattend.xml" file is ABSENT for this pass |
                      DestinationPath = [System.String]".\unattend.xml"
                      Type            = [System.String]'File'
                      #Force           = [System.Boolean]$true
                      Ensure          = [System.String]'Absent'
                    }
                    DSC_FileDirectory { # Ensure the "$env:WinDir\Panther\unattend.xml" file is ABSENT for this pass |
                      DestinationPath = [System.String]".\Windows\Panther\unattend.xml"
                      Type            = [System.String]'File'
                      #Force           = [System.Boolean]$true
                      Ensure          = [System.String]'Absent'
                    }
                    #endregion

                    #region | Files NOT specific to any CNAME and NOT specific to any MetaConfig.mof/Pending.mof |
                    #region | $env:Statics |
                    # Populate the $Statics directory |
                    (Get-ChildItem -Path $env:Statics).Where({
                      $_.PSIsContainer -eq $true
                    }).ForEach({ # Containers |
                      DSC_FileDirectory {
                        DestinationPath = [System.String]$(
                          $ContainerPath = $env:Statics
                          $ContainerPath.Replace(([System.IO.DirectoryInfo]$ContainerPath).Root.Name,'.\')
                        )
                        SourcePath      = [System.String]$_.FullName
                        Type            = [System.String]'Directory'
                        #Force           = [System.Boolean]$true
                        Recurse         = [System.Boolean]$true
                        Ensure          = [System.String]'Present'
                      }
                    })
                    (Get-ChildItem -Path $env:Statics).Where({
                      $_.PSIsContainer -eq $false
                    }).ForEach({ # Files |
                      DSC_FileDirectory {
                        DestinationPath = [System.String]$(
                          $LeafPath = $env:Statics
                          $LeafPath.Replace(([System.IO.DirectoryInfo]$LeafPath).Root.Name,'.\')
                        )
                        SourcePath      = [System.String]$_.FullName
                        Type            = [System.String]'File'
                        #Force           = [System.Boolean]$true
                        Recurse         = [System.Boolean]$true
                        Ensure          = [System.String]'Present'
                      }
                    })

                    <#
                      DSC_FileDirectory { # Populate the $Statics directory |
                        DestinationPath = [System.String]$(
                          $ContainerPath = Resolve-Path -Path "$env:Statics\.." | Select-Object -ExpandProperty 'Path'
                          $ContainerPath.Replace(([System.IO.DirectoryInfo]$ContainerPath).Root.Name,'.\')
                        )
                        SourcePath      = [System.String]$env:Statics
                        Type            = [System.String]'Directory'
                        #Force           = [System.Boolean]$true
                        Recurse         = [System.Boolean]$true
                        Ensure          = [System.String]'Present'
                      }
                    #>
                    #endregion
                    #region | <blank> |
                    #endregion
                    #region | .ZIP Part I: Professional DSC + Windows PowerShell |
                    # Populate the ResMod directory with professionally-authored DSC Resource modules in a .zip file |
                    (Get-ChildItem -Path "$env:DSC_CFG_ROOT\DSC Resource Modules").Where({
                      $($env:AuthoredDscResourceModules -split ' ') -notcontains $_.BaseName -and `
                      $_.PSIsContainer                              -eq          $false
                    }).ForEach({
                      DSC_FileDirectory {
                        DestinationPath = [System.String]$(
                          $ResModFileFullName = $_.FullName
                          $ResModFileFullName.Replace(([System.IO.DirectoryInfo]$ResModFileFullName).Root.Name,'.\')
                        )
                        SourcePath      = [System.String]$_.FullName
                        Type            = [System.String]'File'
                        #Force           = [System.Boolean]$true
                        Recurse         = [System.Boolean]$true
                        Ensure          = [System.String]'Present'
                      }
                    })
                    DSC_FileDirectory { # .zip Files of Windows PowerShell Modules (Non-DSC Resources) |
                      DestinationPath = [System.String]$(
                        $env:DSC_CFG_ROOT.Replace(([System.IO.DirectoryInfo]$env:DSC_CFG_ROOT).Root.Name,'.\')
                      )
                      SourcePath      = [System.String]"$env:DSC_CFG_ROOT\Installs\Modules"
                      Type            = [System.String]'Directory'
                      #Force           = [System.Boolean]$true
                      Recurse         = [System.Boolean]$true
                      Ensure          = [System.String]'Present'
                    }
                    #endregion
                    #region | PowerShell 7 |
                    (Get-ChildItem -Path "$env:DSC_CFG_ROOT\Installs\PowerShell 7").Where({
                      $_.PSIsContainer -eq $true
                    }).ForEach({ # '/Installs/PowerShell 7' | Containers |
                      DSC_FileDirectory {
                        DestinationPath = [System.String]$(
                          $ContainerPath = "$env:DSC_CFG_ROOT\Installs\PowerShell 7"
                          $ContainerPath.Replace(([System.IO.DirectoryInfo]$ContainerPath).Root.Name,'.\')
                        )
                        SourcePath      = [System.String]$_.FullName
                        Type            = [System.String]'Directory'
                        #Force           = [System.Boolean]$true
                        Recurse         = [System.Boolean]$true
                        Ensure          = [System.String]'Present'
                      }
                    })
                    (Get-ChildItem -Path "$env:DSC_CFG_ROOT\Installs\PowerShell 7").Where({
                      $_.PSIsContainer -eq $false
                    }).ForEach({ # '/Installs/PowerShell 7' | Files |
                      DSC_FileDirectory {
                        DestinationPath = [System.String]$(
                          $LeafPath = "$env:DSC_CFG_ROOT\Installs\PowerShell 7"
                          $LeafPath.Replace(([System.IO.DirectoryInfo]$LeafPath).Root.Name,'.\')
                        )
                        SourcePath      = [System.String]$_.FullName
                        Type            = [System.String]'File'
                        #Force           = [System.Boolean]$true
                        Recurse         = [System.Boolean]$true
                        Ensure          = [System.String]'Present'
                      }
                    })
                    #endregion
                    #region | 7-Zip |
                    <#
                      (Get-ChildItem -Path "$env:DSC_CFG_ROOT\Installs\7-Zip").Where({
                        $_.PSIsContainer -eq $true
                      }).ForEach({ # '/Installs/7-Zip' | Containers |
                        DSC_FileDirectory {
                          DestinationPath = [System.String]$(
                            $ContainerPath = "$env:DSC_CFG_ROOT\Installs\7-Zip"
                            $ContainerPath.Replace(([System.IO.DirectoryInfo]$ContainerPath).Root.Name,'.\')
                          )
                          SourcePath      = [System.String]$_.FullName
                          Type            = [System.String]'Directory'
                          #Force           = [System.Boolean]$true
                          Recurse         = [System.Boolean]$true
                          Ensure          = [System.String]'Present'
                        }
                      })
                      (Get-ChildItem -Path "$env:DSC_CFG_ROOT\Installs\7-Zip").Where({
                        $_.PSIsContainer -eq $false
                      }).ForEach({ # '/Installs/7-Zip' | Files |
                        DSC_FileDirectory {
                          DestinationPath = [System.String]$(
                            $LeafPath = "$env:DSC_CFG_ROOT\Installs\7-Zip"
                            $LeafPath.Replace(([System.IO.DirectoryInfo]$LeafPath).Root.Name,'.\')
                          )
                          SourcePath      = [System.String]$_.FullName
                          Type            = [System.String]'File'
                          #Force           = [System.Boolean]$true
                          Recurse         = [System.Boolean]$true
                          Ensure          = [System.String]'Present'
                        }
                      })
                    #>
                    #endregion
                    #region | Misc. |
                    DSC_FileDirectory { # SysinternalsSuite |
                      DestinationPath = [System.String]$(
                        # $SysinternalsSuite = "$env:SystemDrive\SysinternalsSuite"
                        # $SysinternalsSuite.Replace(([System.IO.DirectoryInfo]$SysinternalsSuite).Root.Name,'.\')
                        ([System.IO.DriveInfo]$env:SystemDrive).Name.Replace($env:SystemDrive,'.')
                        #$env:SystemDrive.Replace(([System.IO.DriveInfo]$env:SystemDrive).Root.Name,'.\')
                        #([System.IO.DriveInfo]$env:DSC_CFG_ROOT).Name.Replace($env:DSC_CFG_ROOT,'.')
                      )
                      #SourcePath      = [System.String]"$env:SystemDrive\SysinternalsSuite"
                      SourcePath      = [System.String]$(Resolve-Path -Path "$env:DSC_CFG_ROOT\..\SysinternalsSuite" | Select-Object -ExpandProperty 'Path')
                      Type            = [System.String]'Directory'
                      #Force           = [System.Boolean]$true
                      Recurse         = [System.Boolean]$true
                      Ensure          = [System.String]'Present'
                    }
                    if ( # Desktop Experience | Load OneDrive File |
                      -not (${Windows Server Image Index-VM} % 2)
                    ) {
                      (Get-ChildItem -Path "$env:DSC_CFG_ROOT\Installs\OneDrive").Where({
                        $_.PSIsContainer -eq $false
                      }).ForEach({ # '/Installs/OneDrive' | File |
                        DSC_FileDirectory {
                          DestinationPath = [System.String]$(
                            $OneDrive = $_.DirectoryName
                            $OneDrive.Replace(([System.IO.DirectoryInfo]$OneDrive).Root.Name,'.\')
                          )
                          SourcePath      = [System.String]$_.FullName
                          Type            = [System.String]'File'
                          Force          = [System.Boolean]$true
                          #Recurse         = [System.Boolean]$true
                          Ensure          = [System.String]'Present'
                        }
                      })
                    }
                    if ( # Desktop Experience | Load lockscreen.png |
                      -not (${Windows Server Image Index-VM} % 2)
                    ) {
                      DSC_FileDirectory { # lockscreen.png |
                        DestinationPath = [System.String]".\lockscreen.png"
                        SourcePath      = [System.String]"$env:DSC_CFG_ROOT\Preboots\lockscreen.png"
                        Type            = [System.String]'File'
                        #~#Force           = [System.Boolean]$true
                        Ensure          = [System.String]'Present'
                      }
                    }
                    #endregion
                    #endregion
                  )
                )
                CheckSum                  =     [System.String]${Prepare 1-Special VHDX}.CheckSum
                #PsDscRunAsCredential     =     [PSCredential]${Prepare 1-Special VHDX}.PsDscRunAsCredential
                #DependsOn                =     ${Dependencys Event Log Channel Status}
                DependsOn                 =     ${Dependency Create UNPREPARED VHDX 1-Special by copying VHDX 0-General}
              }

              ${Dependency Prepare 1-Special VHDX} = [System.String[]]@(
                "[VhdFile]$(${Prepare 1-Special VHDX}.Resource_Title)"
              )

              ${VHDX 2-Unique__Copy Operation} = ${Prepare 1-Special VHDX}.'VHDX 2-Unique__Copy Operation'
              #%_Delete_To_Allow_VHDX_2_Unique%#${Is Source File2 Present at Time of MOF Compilation} = Test-Path -Path ${VHDX 2-Unique__Copy Operation}.SourcePath
              #%_Delete_To_Block_VHDX_2_Unique%#${Is Source File2 Present at Time of MOF Compilation} = $false
              if (${Is Source File2 Present at Time of MOF Compilation}) {
                File ${VHDX 2-Unique__Copy Operation}.Resource_Title {
                  DestinationPath               =        [System.String]${VHDX 2-Unique__Copy Operation}.DestinationPath
                  SourcePath                    =        [System.String]${VHDX 2-Unique__Copy Operation}.SourcePath
                  Force                         =        [System.Boolean]${VHDX 2-Unique__Copy Operation}.Force
                  Type                          =        [System.String]${VHDX 2-Unique__Copy Operation}.Type
                  #Credential                   =        [PSCredential]${VHDX 2-Unique__Copy Operation}.Credential
                  Ensure                        =        [System.String]${VHDX 2-Unique__Copy Operation}.Ensure
                  #PsDscRunAsCredential         =        [PSCredential]${VHDX 2-Unique__Copy Operation}.PsDscRunAsCredential
                  DependsOn                     =        ${Dependency Prepare 1-Special VHDX}
                }

                ${Dependency Create UNPREPARED VHDX 2-Unique by copying PREPARED VHDX 1-Special} = [System.String[]]@(
                  "[File]$(${VHDX 2-Unique__Copy Operation}.Resource_Title)"
                )

                ${Is Destination File2 Present at Time of MOF Compilation} = Test-Path -Path ${VHDX 2-Unique__Copy Operation}.DestinationPath
                #Write-Host -Object "`${Is Destination File2 Present at Time of MOF Compilation} = ${Is Destination File2 Present at Time of MOF Compilation}; `$ConfigTargetCname.GetType() = $($ConfigTargetCname.GetType()); `$ConfigTargetCname = $ConfigTargetCname"
                if (${Is Destination File2 Present at Time of MOF Compilation}) {
                  ${Prepare 2-Unique VHDX} = ${VHDX 2-Unique__Copy Operation}.'Prepare VHDX 2-Unique'
                  if ( ## How can you place environmental data for FileDirectory along with all the other environmental data?
                    #$null -ne ${Prepare 2-Unique VHDX}.FileDirectory -and `
                    $null -ne ${Prepare 2-Unique VHDX}.VhdPath
                  ) {
                    VhdFile ${Prepare 2-Unique VHDX}.Resource_Title {
                      VhdPath                   =     ${Prepare 2-Unique VHDX}.VhdPath
                      FileDirectory             =     $(
                        @(
                          #region | Environment Data Filtering Structure Reference |
                          if ( # Server Core |
                            ! (-not (${Windows Server Image Index-VM} % 2))
                          ) {}
                          if ( # Desktop Experience |
                            -not (${Windows Server Image Index-VM} % 2)
                          ) {}
                          if ( # VM that creates the Active Directory Forest |
                            $VmConfigTargetNode.Life          -eq $true              -and `
                            $VmConfigTargetNode.SuperEmpire   -eq 'Microsoft'        -and `
                            $VmConfigTargetNode.Empire        -eq 'VM'               -and `
                            $VmConfigTargetNode.SubEmpire     -eq 'Windows Server'   -and `
                            $VmConfigTargetNode.SuperDominion -match '^Yes'          -and `
                            $VmConfigTargetNode.Dominion      -eq 'Active Directory' -and `
                            $VmConfigTargetNode.Kingdom       -eq 'New AD Forest'
                          ) {}
                          #endregion
                          #region | Files specific to the MetaConfig.mof/Pending.mof |
                          DSC_FileDirectory { # "$env:WinDir\System32\Configuration\MetaConfig.mof" |
                            DestinationPath = [System.String]".\Windows\System32\Configuration\MetaConfig.mof"
                            SourcePath      = [System.String]"$env:DSC_CFG_ROOT\Preboots\${CNAME of Mgmt Interface on Node Config Target}\localhost.meta.mof"
                            Type            = [System.String]'File'
                            Force           = [System.Boolean]$true
                            Ensure          = [System.String]'Present'
                          }
                          DSC_FileDirectory { # "$env:WinDir\System32\Configuration\Pending.mof" |
                            DestinationPath = [System.String]".\Windows\System32\Configuration\Pending.mof"
                            SourcePath      = [System.String]"$env:DSC_CFG_ROOT\Preboots\${CNAME of Mgmt Interface on Node Config Target}\localhost.mof"
                            Type            = [System.String]'File'
                            Force           = [System.Boolean]$true
                            Ensure          = [System.String]'Present'
                          }
                          DSC_FileDirectory { # "$env:SystemDrive\MetaConfig-sdelete.mof" |
                            DestinationPath = [System.String]".\MetaConfig-sdelete.mof"
                            SourcePath      = [System.String]"$env:DSC_CFG_ROOT\Preboots\${CNAME of Mgmt Interface on Node Config Target}\localhost.meta.mof"
                            Type            = [System.String]'File'
                            Force           = [System.Boolean]$true
                            Ensure          = [System.String]'Present'
                          }
                          DSC_FileDirectory { # "$env:SystemDrive\Pending-sdelete.mof" |
                            DestinationPath = [System.String]".\Pending-sdelete.mof"
                            SourcePath      = [System.String]"$env:DSC_CFG_ROOT\Preboots\${CNAME of Mgmt Interface on Node Config Target}\localhost.mof"
                            Type            = [System.String]'File'
                            Force           = [System.Boolean]$true
                            Ensure          = [System.String]'Present'
                          }
                          #endregion
                          #region | Windows PowerShell AUAH profile.ps1 file |
                          DSC_FileDirectory { # Use the same Windows PowerShell profile file that's currently present on the Hyper-V host |
                            DestinationPath = [System.String]".\Windows\System32\WindowsPowerShell\v1.0\profile.ps1"
                            SourcePath      = [System.String]"$env:WinDir\System32\WindowsPowerShell\v1.0\profile.ps1"
                            Type            = [System.String]'File'
                            #~#Force           = [System.Boolean]$true
                            Ensure          = [System.String]'Present'
                          }
                          #endregion
                          #region | unattend.xml file |
                          DSC_FileDirectory { # "$env:SystemDrive\unattend.xml" file |
                            DestinationPath = [System.String]".\unattend.xml"
                            SourcePath      = [System.String]"$env:DSC_CFG_ROOT\Preboots\${CNAME of Mgmt Interface on Node Config Target}\unattend.xml"
                            Type            = [System.String]'File'
                            #~#Force           = [System.Boolean]$true
                            Ensure          = [System.String]'Present'
                          }
                          DSC_FileDirectory { # "$env:WinDir\Panther\unattend.xml" file |
                            DestinationPath = [System.String]".\Windows\Panther\unattend.xml"
                            SourcePath      = [System.String]"$env:DSC_CFG_ROOT\Preboots\${CNAME of Mgmt Interface on Node Config Target}\unattend.xml"
                            Type            = [System.String]'File'
                            #~#Force           = [System.Boolean]$true
                            Ensure          = [System.String]'Present'
                          }
                          #endregion
                          #region | PSPKI File-System Objects | Installed here because required for the enactment of pending.mof to succeed. |
                          DSC_FileDirectory {
                            DestinationPath = [System.String]".\Program Files\WindowsPowerShell\Modules"
                            SourcePath      = [System.String]"$env:ProgramModules\PSPKI"
                            Type            = [System.String]'Directory'
                            #~#Force           = [System.Boolean]$true
                            Recurse         = [System.Boolean]$true
                            Ensure          = [System.String]'Present'
                          }
                          #endregion
                          #region | xDscDiagnostics File-System Objects | Installed here because required for the enactment of pending.mof to succeed. |
                          DSC_FileDirectory {
                            DestinationPath = [System.String]".\Program Files\WindowsPowerShell\Modules"
                            SourcePath      = [System.String]"$env:ProgramModules\xDscDiagnostics"
                            Type            = [System.String]'Directory'
                            #~#Force           = [System.Boolean]$true
                            Recurse         = [System.Boolean]$true
                            Ensure          = [System.String]'Present'
                          }
                          #endregion
                          #region | AdHocDsc File-System Objects | Necessary because Pending.mof calls resources defined within the AdHoc DSC Resource modules |
                          <#
                            DSC_FileDirectory {
                              DestinationPath = [System.String]".\Program Files\WindowsPowerShell\Modules"
                              SourcePath      = [System.String]"$env:ProgramModules\AdHocDsc"
                              Type            = [System.String]'Directory'
                              #~#Force           = [System.Boolean]$true
                              Recurse         = [System.Boolean]$true
                              Ensure          = [System.String]'Present'
                            }

                            # Copy FSOs that comprise the custom authored DSC resource modules |
                            DSC_FileDirectory {
                              DestinationPath = [System.String]".\Program Files\WindowsPowerShell\Modules"
                              SourcePath      = [System.String]"$env:ProgramModules\AdHocCertsDsc"
                              Type            = [System.String]'Directory'
                              #~#Force           = [System.Boolean]$true
                              Recurse         = [System.Boolean]$true
                              Ensure          = [System.String]'Present'
                            }

                            DSC_FileDirectory {
                              DestinationPath = [System.String]".\Program Files\WindowsPowerShell\Modules"
                              SourcePath      = [System.String]"$env:ProgramModules\AdHocNetsDsc"
                              Type            = [System.String]'Directory'
                              #~#Force           = [System.Boolean]$true
                              Recurse         = [System.Boolean]$true
                              Ensure          = [System.String]'Present'
                            }

                            DSC_FileDirectory {
                              DestinationPath = [System.String]".\Program Files\WindowsPowerShell\Modules"
                              SourcePath      = [System.String]"$env:ProgramModules\AdHocPkiDsc"
                              Type            = [System.String]'Directory'
                              #~#Force           = [System.Boolean]$true
                              Recurse         = [System.Boolean]$true
                              Ensure          = [System.String]'Present'
                            }

                            DSC_FileDirectory {
                              DestinationPath = [System.String]".\Program Files\WindowsPowerShell\Modules"
                              SourcePath      = [System.String]"$env:ProgramModules\AdHocUtilsDsc"
                              Type            = [System.String]'Directory'
                              #~#Force           = [System.Boolean]$true
                              Recurse         = [System.Boolean]$true
                              Ensure          = [System.String]'Present'
                            }
                          #>
                          #endregion
                          #region | Populate ResMod with Authored DSC Resource Modules |
                          (Get-ChildItem -Path "$env:DSC_CFG_ROOT\DSC Resource Modules").Where({ # Populate the zipped authored resource modules into the ResMod |
                            $($env:AuthoredDscResourceModules -split ' ') -contains $_.BaseName -and `
                            $_.PSIsContainer                              -eq       $false
                          }).ForEach({
                            DSC_FileDirectory {
                              DestinationPath = [System.String]$(
                                $ResModFileFullName = $_.FullName
                                $ResModFileFullName.Replace(([System.IO.DirectoryInfo]$ResModFileFullName).Root.Name,'.\')
                              )
                              SourcePath      = [System.String]$_.FullName
                              Type            = [System.String]'File'
                              #~#Force           = [System.Boolean]$true
                              Recurse         = [System.Boolean]$true
                              Ensure          = [System.String]'Present'
                            }
                          })
                          #endregion

                          #region | Copy 'GPO ZIPs' and 'AD-Dependent Modules' Directories to the mounted VHDX of the VM that creates the AD Forest |
                          <#
                            if ( # VM that creates the Active Directory Forest |
                              $VmConfigTargetNode.Life          -eq $true              -and `
                              $VmConfigTargetNode.SuperEmpire   -eq 'Microsoft'        -and `
                              $VmConfigTargetNode.Empire        -eq 'VM'               -and `
                              $VmConfigTargetNode.SubEmpire     -eq 'Windows Server'   -and `
                              $VmConfigTargetNode.SuperDominion -match '^Yes'          -and `
                              $VmConfigTargetNode.Dominion      -eq 'Active Directory' -and `
                              $VmConfigTargetNode.Kingdom       -eq 'New AD Forest'
                            ) {
                              DSC_FileDirectory {
                                DestinationPath = [System.String]$(
                                  $ContainerPath = "$env:DSC_CFG_ROOT\Installs\GPO ZIPs"
                                  $ContainerPath.Replace(([System.IO.DirectoryInfo]$ContainerPath).Root.Name,'.\')
                                )
                                SourcePath      = [System.String]$ContainerPath
                                Type            = [System.String]'Directory'
                                #~#Force           = [System.Boolean]$true
                                Recurse         = [System.Boolean]$true
                                Ensure          = [System.String]'Present'
                              }
                              DSC_FileDirectory {
                                DestinationPath = [System.String]$(
                                  $ContainerPath = "$env:DSC_CFG_ROOT\Installs\AD-Dependent Modules"
                                  $ContainerPath.Replace(([System.IO.DirectoryInfo]$ContainerPath).Root.Name,'.\')
                                )
                                SourcePath      = [System.String]$ContainerPath
                                Type            = [System.String]'Directory'
                                #~#Force           = [System.Boolean]$true
                                Recurse         = [System.Boolean]$true
                                Ensure          = [System.String]'Present'
                              }
                            }
                          #>
                          #endregion


                          #region | Pre-PKI Global Certificate Signer .txt & .cer |
                          <#
                            $ConfigTargetCname = $DomainCtrl00Cname
                            $VmConfigTargetNode = $ConfigurationData.AllNodes.Where({$_.NodeMgmtCname -eq $ConfigTargetCname})
                            ${Copy Pre-PKI Global Certificate Signer File into Mounted .VHDX} = $VmConfigTargetNode.'Import Pre-PKI Global Certificate Signer'
                            ${Copy Pre-PKI Global Certificate Signer File into Mounted .VHDX}
                            ${Copy Pre-PKI Global Certificate Signer File into Mounted .VHDX} = $VmConfigTargetNode.'Import Pre-PKI Global Certificate Signer'
                          #>
                          
                          ${Copy Pre-PKI Global Certificate Signer File into Mounted .VHDX} = $ConfigurationData.AllNodes.Where({
                            $_.NodeMgmtCname -eq ${CNAME of Mgmt Interface on Node Config Target}
                          }).'Import Pre-PKI Global Certificate Signer'

                          DSC_FileDirectory {
                            DestinationPath = [System.String]$(
                              $file = [System.IO.FileInfo]${Copy Pre-PKI Global Certificate Signer File into Mounted .VHDX}.Path
                              $path = $file.FullName
                              $path.Replace(([System.IO.DirectoryInfo]$file.Directory).Root.Name,'.\')
                            )              
                            SourcePath      = [System.String]$file.FullName
                            Type            = [System.String]'File'
                            #~#Force           = [System.Boolean]$true
                            Ensure          = [System.String]'Present'
                          }
                          DSC_FileDirectory {
                            DestinationPath = [System.String]$(
                              $file = [System.IO.FileInfo](${Copy Pre-PKI Global Certificate Signer File into Mounted .VHDX}.Path -replace '\.cer$','.txt')
                              $path = $file.FullName
                              $path.Replace(([System.IO.DirectoryInfo]$file.Directory).Root.Name,'.\')
                            )              
                            SourcePath      = [System.String]$file.FullName
                            Type            = [System.String]'File'
                            #~#Force           = [System.Boolean]$true
                            Ensure          = [System.String]'Present'
                          }
                          #endregion
                          #region | Pre-PKI Global Code Signer .txt & .cer |
                          ${Copy Pre-PKI Global Code Signer File into Mounted .VHDX} = $ConfigurationData.AllNodes.Where({
                            $_.NodeMgmtCname -eq ${CNAME of Mgmt Interface on Node Config Target}
                          }).'Import Pre-PKI Global Code Signer'

                          DSC_FileDirectory {
                            DestinationPath = [System.String]$(
                              $file = [System.IO.FileInfo]${Copy Pre-PKI Global Code Signer File into Mounted .VHDX}.Path
                              $path = $file.FullName
                              $path.Replace(([System.IO.DirectoryInfo]$file.Directory).Root.Name,'.\')
                            )              
                            SourcePath      = [System.String]$file.FullName
                            Type            = [System.String]'File'
                            #~#Force           = [System.Boolean]$true
                            Ensure          = [System.String]'Present'
                          }
                          DSC_FileDirectory {
                            DestinationPath = [System.String]$(
                              $file = [System.IO.FileInfo](${Copy Pre-PKI Global Code Signer File into Mounted .VHDX}.Path -replace '\.cer$','.txt')
                              $path = $file.FullName
                              $path.Replace(([System.IO.DirectoryInfo]$file.Directory).Root.Name,'.\')
                            )              
                            SourcePath      = [System.String]$file.FullName
                            Type            = [System.String]'File'
                            #~#Force           = [System.Boolean]$true
                            Ensure          = [System.String]'Present'
                          }
                          #endregion

                          #region | Pre-PKI .txt, .cer, and .pfx files for MOF Password Protection on this this particular config target node |
                          ${Copy Pre-PKI Document Encryption cert for MOF Password Protection PFX File into Mounted .VHDX} = $ConfigurationData.AllNodes.Where({
                            $_.NodeMgmtCname -eq ${CNAME of Mgmt Interface on Node Config Target}
                          }).'PFX File of Document Encryption cert for MOF Password Protection'

                          DSC_FileDirectory {
                            DestinationPath = [System.String]$(
                              $file = [System.IO.FileInfo](${Copy Pre-PKI Document Encryption cert for MOF Password Protection PFX File into Mounted .VHDX}.Path -replace '\.pfx$','.txt')
                              $path = $file.FullName
                              $path.Replace(([System.IO.DirectoryInfo]$file.Directory).Root.Name,'.\')
                            )              
                            SourcePath      = [System.String]$file.FullName
                            Type            = [System.String]'File'
                            #~#Force           = [System.Boolean]$true
                            Ensure          = [System.String]'Present'
                          }
                          DSC_FileDirectory {
                            DestinationPath = [System.String]$(
                              $file = [System.IO.FileInfo](${Copy Pre-PKI Document Encryption cert for MOF Password Protection PFX File into Mounted .VHDX}.Path -replace '\.pfx$','.cer')
                              $path = $file.FullName
                              $path.Replace(([System.IO.DirectoryInfo]$file.Directory).Root.Name,'.\')
                            )              
                            SourcePath      = [System.String]$file.FullName
                            Type            = [System.String]'File'
                            #~#Force           = [System.Boolean]$true
                            Ensure          = [System.String]'Present'
                          }
                          DSC_FileDirectory {
                            DestinationPath = [System.String]$(
                              $file = [System.IO.FileInfo]${Copy Pre-PKI Document Encryption cert for MOF Password Protection PFX File into Mounted .VHDX}.Path
                              $path = $file.FullName
                              $path.Replace(([System.IO.DirectoryInfo]$file.Directory).Root.Name,'.\')
                            )              
                            SourcePath      = [System.String]$file.FullName
                            Type            = [System.String]'File'
                            #~#Force           = [System.Boolean]$true
                            Ensure          = [System.String]'Present'
                          }
                          #endregion
                          #region | Pre-PKI .txt, .cer, and .pfx files for Event Log Privacy on this this particular config target node |
                          ${Copy Pre-PKI Document Encryption cert for Event Log Privacy PFX File into Mounted .VHDX} = $ConfigurationData.AllNodes.Where({
                            $_.NodeMgmtCname -eq ${CNAME of Mgmt Interface on Node Config Target}
                          }).'PFX File of Document Encryption cert for Event Log Privacy'

                          DSC_FileDirectory {
                            DestinationPath = [System.String]$(
                              $file = [System.IO.FileInfo](${Copy Pre-PKI Document Encryption cert for Event Log Privacy PFX File into Mounted .VHDX}.Path -replace '\.pfx$','.txt')
                              $path = $file.FullName
                              $path.Replace(([System.IO.DirectoryInfo]$file.Directory).Root.Name,'.\')
                            )              
                            SourcePath      = [System.String]$file.FullName
                            Type            = [System.String]'File'
                            #~#Force           = [System.Boolean]$true
                            Ensure          = [System.String]'Present'
                          }
                          DSC_FileDirectory {
                            DestinationPath = [System.String]$(
                              $file = [System.IO.FileInfo](${Copy Pre-PKI Document Encryption cert for Event Log Privacy PFX File into Mounted .VHDX}.Path -replace '\.pfx$','.cer')
                              $path = $file.FullName
                              $path.Replace(([System.IO.DirectoryInfo]$file.Directory).Root.Name,'.\')
                            )              
                            SourcePath      = [System.String]$file.FullName
                            Type            = [System.String]'File'
                            #~#Force           = [System.Boolean]$true
                            Ensure          = [System.String]'Present'
                          }
                          DSC_FileDirectory {
                            DestinationPath = [System.String]$(
                              $file = [System.IO.FileInfo]${Copy Pre-PKI Document Encryption cert for Event Log Privacy PFX File into Mounted .VHDX}.Path
                              $path = $file.FullName
                              $path.Replace(([System.IO.DirectoryInfo]$file.Directory).Root.Name,'.\')
                            )              
                            SourcePath      = [System.String]$file.FullName
                            Type            = [System.String]'File'
                            #~#Force           = [System.Boolean]$true
                            Ensure          = [System.String]'Present'
                          }
                          #endregion

                          #region | Server Authentication .txt for all machines |
                          ${Copy Operations on PFX File Set of pre-PKI Server Authentication certs into Mounted .VHDX} = $ConfigurationData.AllNodes.Where({
                            $null -ne $PSItem.NodeMgmtCname
                          }).'PFX File of Server Authentication cert for Mutual Authentication'

                          if ($null -ne ${Copy Operations on PFX File Set of pre-PKI Server Authentication certs into Mounted .VHDX}) {
                            foreach (${Copy Operation on PFX File of pre-PKI Server Authentication cert Into Mounted VHDX} in ${Copy Operations on PFX File Set of pre-PKI Server Authentication certs into Mounted .VHDX}) {
                              DSC_FileDirectory {
                                DestinationPath = [System.String]$(
                                  $file = [System.IO.FileInfo](${Copy Operation on PFX File of pre-PKI Server Authentication cert Into Mounted VHDX}.Path -replace '\.pfx$','.txt')
                                  $path = $file.FullName
                                  $path.Replace(([System.IO.DirectoryInfo]$file.Directory).Root.Name,'.\')
                                )              
                                SourcePath      = [System.String]$file.FullName
                                Type            = [System.String]'File'
                                #~#Force           = [System.Boolean]$true
                                Ensure          = [System.String]'Present'
                              }
                            }
                          }
                          #endregion


                          #region | Server Authentication .cer for all machines except $ConfigTargetCname |
                          ${Copy Operations on CER File Set of pre-PKI Server Authentication certs into Mounted .VHDX} = $ConfigurationData.AllNodes.Where({
                            $_.NodeMgmtCname -ne ${CNAME of Mgmt Interface on Node Config Target}
                          }).'Import Pre-PKI Server Authentication CER Files'

                          foreach (${Copy Operation on CER File of pre-PKI Server Authentication cert Into Mounted VHDX} in ${Copy Operations on CER File Set of pre-PKI Server Authentication certs into Mounted .VHDX}) {
                            DSC_FileDirectory {
                              DestinationPath = [System.String]$(
                                $File = [System.IO.FileInfo]${Copy Operation on CER File of pre-PKI Server Authentication cert Into Mounted VHDX}.Path
                                $Path = $File.FullName
                                $Path.Replace(([System.IO.DirectoryInfo]$File.Directory).Root.Name,'.\')
                              )
                              SourcePath      = [System.String]$file.FullName
                              Type            = [System.String]'File'
                              #~#Force           = [System.Boolean]$true
                              Ensure          = [System.String]'Present'
                            }            
                          }
                          #endregion
                          #region | Server Authentication .pfx for $ConfigTargetCname |
                          ${Copy Operation on PFX File of pre-PKI Server Authentication cert into Mounted .VHDX} = $ConfigurationData.AllNodes.Where({
                            $_.NodeMgmtCname -eq ${CNAME of Mgmt Interface on Node Config Target}
                          }).'PFX File of Server Authentication cert for Mutual Authentication'

                          DSC_FileDirectory {
                            DestinationPath = [System.String]$(
                              $file = [System.IO.FileInfo]${Copy Operation on PFX File of pre-PKI Server Authentication cert into Mounted .VHDX}.Path
                              $path = $file.FullName
                              $path.Replace(([System.IO.DirectoryInfo]$file.Directory).Root.Name,'.\')
                            )
                            SourcePath      = [System.String]$file.FullName
                            Type            = [System.String]'File'
                            #~#Force           = [System.Boolean]$true
                            Ensure          = [System.String]'Present'
                          }
                          #endregion

                          #region | Client Authentication .txt for all machines |
                          ${PFX Files of Client Authentication certs} = $ConfigurationData.AllNodes.Where({
                            $null -ne $PSItem.NodeMgmtCname
                          }).'PFX File Collection of Client Authentication certs'

                          foreach (${PFX File of Client Authentication cert} in ${PFX Files of Client Authentication certs}) {
                            DSC_FileDirectory {
                              DestinationPath = [System.String]$(
                                $file = [System.IO.FileInfo](${PFX File of Client Authentication cert}.Path -replace '\.pfx$','.txt')
                                $path = $file.FullName
                                $path.Replace(([System.IO.DirectoryInfo]$file.Directory).Root.Name,'.\')
                              )              
                              SourcePath      = [System.String]$file.FullName
                              Type            = [System.String]'File'
                              #~#Force           = [System.Boolean]$true
                              Ensure          = [System.String]'Present'
                            }
                          }
                          #endregion

                          #region | Client Authentication .cer files for $ConfigTargetCname |
                          ${PFX File Collection of Client Authentication certs} = $ConfigurationData.AllNodes.Where({
                            $_.NodeMgmtCname -eq ${CNAME of Mgmt Interface on Node Config Target}
                          }).'PFX File Collection of Client Authentication certs'

                          foreach (${PFX File of Client Authentication cert} in ${PFX File Collection of Client Authentication certs}) {
                            DSC_FileDirectory {
                              DestinationPath = [System.String]$(
                                $file = [System.IO.FileInfo](${PFX File of Client Authentication cert}.Path -replace '\.pfx$','.cer')
                                $path = $file.FullName
                                $path.Replace(([System.IO.DirectoryInfo]$file.Directory).Root.Name,'.\')
                              )
                              SourcePath      = [System.String]$file.FullName
                              Type            = [System.String]'File'
                              #~#Force           = [System.Boolean]$true
                              Ensure          = [System.String]'Present'
                            }
                          }
                          #endregion

                          #region | Client Authentication .pfx for all machines except $ConfigTargetCname |
                          ${PFX File Collection of Client Authentication certs} = $ConfigurationData.AllNodes.Where({
                            $_.NodeMgmtCname -ne ${CNAME of Mgmt Interface on Node Config Target}
                          }).'PFX File Collection of Client Authentication certs'

                          foreach (${PFX File of Client Authentication cert} in ${PFX File Collection of Client Authentication certs}) {
                            DSC_FileDirectory {
                              DestinationPath = [System.String]$(
                                $file = [System.IO.FileInfo]${PFX File of Client Authentication cert}.Path
                                $path = $file.FullName
                                $path.Replace(([System.IO.DirectoryInfo]$file.Directory).Root.Name,'.\')
                              )
                              SourcePath      = [System.String]$file.FullName
                              Type            = [System.String]'File'
                              #~#Force           = [System.Boolean]$true
                              Ensure          = [System.String]'Present'
                            }
                          }
                          #endregion
                        )
                      )
                      CheckSum                  =     [System.String]${Prepare 2-Unique VHDX}.CheckSum
                      #PsDscRunAsCredential     =     [PSCredential]${Prepare 2-Unique VHDX}.PsDscRunAsCredential
                      #DependsOn                =     ${Dependencys Event Log Channel Status}
                      DependsOn                 =     ${Dependency Create UNPREPARED VHDX 2-Unique by copying PREPARED VHDX 1-Special}
                    }

                    ${Dependency Prepare 2-Unique VHDX} = [System.String[]]@(
                      "[VhdFile]$(${Prepare 2-Unique VHDX}.Resource_Title)"
                    )

                    ${VHDX Virtual Hard Disks directory__Copy Operation} = ${Prepare 2-Unique VHDX}.'VHDX Virtual Hard Disks directory__Copy Operation'
                    ${Is Destination File2 Present at Time of MOF Compilation} = Test-Path -Path ${VHDX Virtual Hard Disks directory__Copy Operation}.SourcePath
                    if (${Is Destination File2 Present at Time of MOF Compilation}) {
                      File ${VHDX Virtual Hard Disks directory__Copy Operation}.Resource_Title {
                        DestinationPath           =      [System.String]${VHDX Virtual Hard Disks directory__Copy Operation}.DestinationPath
                        SourcePath                =      [System.String]${VHDX Virtual Hard Disks directory__Copy Operation}.SourcePath
                        Force                     =      [System.Boolean]${VHDX Virtual Hard Disks directory__Copy Operation}.Force
                        Type                      =      [System.String]${VHDX Virtual Hard Disks directory__Copy Operation}.Type
                        #Credential               =      [PSCredential]${VHDX Virtual Hard Disks directory__Copy Operation}.Credential
                        Ensure                    =      [System.String]${VHDX Virtual Hard Disks directory__Copy Operation}.Ensure
                        #PsDscRunAsCredential     =      [PSCredential]${VHDX Virtual Hard Disks directory__Copy Operation}.PsDscRunAsCredential
                        DependsOn                 =      ${Dependency Prepare 2-Unique VHDX}
                      }

                      ${Dependency VHDX Virtual Hard Disks directory__Copy Operation} = [System.String[]]@(
                        "[File]$(${VHDX Virtual Hard Disks directory__Copy Operation}.Resource_Title)"
                      )
                    }
                  }
                }
              }
            }
          }
        }
      }
    } 
    else {
      $Resource_Title = ${VHDX 1-Special 2xParent Path} -replace '[^a-z0-9- _\.]','\'
      File $Resource_Title {
        DestinationPath = ${VHDX 1-Special 2xParent Path}
        Type            = 'Directory'
        Ensure          = 'Present'
      }
    }
  }
}