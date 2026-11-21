${Dependencys Copy Non-System Virtual Disk Files to Virtual Hard Disk Directory} = [System.Collections.ArrayList]::New()

$Node.'Non-System VHD Files for All Hyper-V VMs' `
| Where-Object -FilterScript {$null -ne $PSItem} -PipelineVariable 'Non-System VHD' `
| ForEach-Object -Process {
  switch ($true) {
    { # Conditions for triggering ONLY the attachment of a Virtual Hard Disk from a brand new .vhdx file |
      (Get-Disk | Where-Object -FilterScript {$_.Location -eq ${Non-System VHD}.VirtualHardDisk.FilePath}) -eq $null `
      -and `
      -not (Test-Path -Path ${Non-System VHD}.'Text File With UniqueId'.DestinationPath) `
      -and `
      -not (Test-Path -Path ${Non-System VHD}.VirtualHardDisk.FilePath) `
      -and `
      -not (Test-Path -Path ${Non-System VHD}.'VHDX File'.DestinationPath)
    } {
      VirtualHardDisk ${Non-System VHD}.VirtualHardDisk.Resource_Title {
        FilePath                  =    [System.String]${Non-System VHD}.VirtualHardDisk.FilePath 
        DiskFormat                =    [System.String]${Non-System VHD}.VirtualHardDisk.DiskFormat
        DiskSize                  =    [System.UInt64]${Non-System VHD}.VirtualHardDisk.DiskSize
        DiskType                  =    [System.String]${Non-System VHD}.VirtualHardDisk.DiskType
        Ensure                    =    [System.String]${Non-System VHD}.VirtualHardDisk.Ensure
        #PsDscRunAsCredential     =    [PSCredential]${Non-System VHD}.VirtualHardDisk.PsDscRunAsCredential
        DependsOn                 =    ${Dependencys Event Log Channel Status}
      }
      break
    }
    { # Conditions for triggering ONLY the creation of a txt file containing the UniqueId of the currently mounted .vhdx file |
      $null -ne (Get-Disk | Where-Object -FilterScript {$_.Location -eq ${Non-System VHD}.VirtualHardDisk.FilePath}) `
      -and `
      -not (Test-Path -Path ${Non-System VHD}.'Text File With UniqueId'.DestinationPath) `
      -and `
      (Test-Path -Path ${Non-System VHD}.VirtualHardDisk.FilePath) `
      -and `
      -not (Test-Path -Path ${Non-System VHD}.'VHDX File'.DestinationPath)
    } {
      File ${Non-System VHD}.'Text File with UniqueId'.Resource_Title {
        DestinationPath           =      [System.String]${Non-System VHD}.'Text File with UniqueId'.DestinationPath
        Attributes                =      [System.String[]]${Non-System VHD}.'Text File with UniqueId'.Attributes
        Contents                  =      [System.String]$(
          Get-Disk `
          | Where-Object -FilterScript {
            $_.FriendlyName -eq 'Msft Virtual Disk' `
            -and `
            $_.Location -eq ${Non-System VHD}.VirtualHardDisk.FilePath
          } `
          | Select-Object -ExpandProperty 'UniqueId' 
        )
        CheckSum                  =      [System.String]${Non-System VHD}.'Text File with UniqueId'.Checksum
        Force                     =      [System.Boolean]${Non-System VHD}.'Text File with UniqueId'.Force
        MatchSource               =      [System.Boolean]${Non-System VHD}.'Text File with UniqueId'.MatchSource
        Recurse                   =      [System.Boolean]${Non-System VHD}.'Text File with UniqueId'.Recurse
        #Credential               =      [PSCredential]${Non-System VHD}.'Text File with UniqueId'.Credential
        Ensure                    =      [System.String]${Non-System VHD}.'Text File with UniqueId'.Ensure
        #PsDscRunAsCredential     =      [PSCredential]${Non-System VHD}.'Text File with UniqueId'.PsDscRunAsCredential
        DependsOn                 =      ${Dependencys Event Log Channel Status}
      }
      break
    }
    { # Conditions for triggering ONLY the dismount of the Virtual Hard Disk |
      $null -ne (Get-Disk | Where-Object -FilterScript {$_.Location -eq ${Non-System VHD}.VirtualHardDisk.FilePath}) `
      -and `
      (Test-Path -Path ${Non-System VHD}.'Text File With UniqueId'.DestinationPath) `
      -and `
      (Test-Path -Path ${Non-System VHD}.VirtualHardDisk.FilePath) `
      -and `
      -not (Test-Path -Path ${Non-System VHD}.'VHDX File'.DestinationPath)
    } {
      VirtualHardDisk ${Non-System VHD}.VirtualHardDisk.Resource_Title {
        FilePath                  =    [System.String]${Non-System VHD}.VirtualHardDisk.FilePath 
        DiskFormat                =    [System.String]${Non-System VHD}.VirtualHardDisk.DiskFormat
        DiskSize                  =    [System.UInt64]${Non-System VHD}.VirtualHardDisk.DiskSize
        DiskType                  =    [System.String]${Non-System VHD}.VirtualHardDisk.DiskType
        Ensure                    =    [System.String]'Absent'
        #PsDscRunAsCredential     =    [PSCredential]${Non-System VHD}.VirtualHardDisk.PsDscRunAsCredential
        DependsOn                 =    ${Dependencys Event Log Channel Status}
      }
      break
    }
    { # Conditions for triggering ONLY the copy operation of the non-system .vhdx file into (Get-VMHost).VirtualHardDiskPath |
      (Get-Disk | Where-Object -FilterScript {$_.Location -eq ${Non-System VHD}.VirtualHardDisk.FilePath}) -eq $null `
      -and `
      (Test-Path -Path ${Non-System VHD}.'Text File With UniqueId'.DestinationPath) `
      -and `
      (Test-Path -Path ${Non-System VHD}.VirtualHardDisk.FilePath) `
      -and `
      -not (Test-Path -Path ${Non-System VHD}.'VHDX File'.DestinationPath)
    } {
      File ${Non-System VHD}.'VHDX File'.Resource_Title {
        DestinationPath             =      [System.String]${Non-System VHD}.'VHDX File'.DestinationPath
        SourcePath                  =      [System.String]${Non-System VHD}.'VHDX File'.SourcePath
        Type                        =      [System.String]${Non-System VHD}.'VHDX File'.Type
        Attributes                  =      [System.String[]]${Non-System VHD}.'VHDX File'.Attributes
        #Credential                 =      [PSCredential]${Non-System VHD}.'VHDX File'.Credential
        Ensure                      =      [System.String]${Non-System VHD}.'VHDX File'.Ensure
        #PsDscRunAsCredential       =      [PSCredential]${Non-System VHD}.'VHDX File'.PsDscRunAsCredential
        DependsOn                   =      ${Dependencys Event Log Channel Status}
      }

      ${Dependencys Copy Non-System Virtual Disk Files to Virtual Hard Disk Directory}.Add(
        [System.String]"[File]$(${Non-System VHD}.'VHDX File'.Resource_Title)"
      ) > $null
    }
    { # Conditions defining desired state |
      (Get-Disk | Where-Object -FilterScript {$_.Location -eq ${Non-System VHD}.VirtualHardDisk.FilePath}) -eq $null `
      -and `
      (Test-Path -Path ${Non-System VHD}.'Text File With UniqueId'.DestinationPath) `
      -and `
      (Test-Path -Path ${Non-System VHD}.VirtualHardDisk.FilePath) `
      -and `
      (Test-Path -Path ${Non-System VHD}.'VHDX File'.DestinationPath)
    } {
      File ${Non-System VHD}.'VHDX File'.Resource_Title {
        DestinationPath             =      [System.String]${Non-System VHD}.'VHDX File'.DestinationPath
        SourcePath                  =      [System.String]${Non-System VHD}.'VHDX File'.SourcePath
        Type                        =      [System.String]${Non-System VHD}.'VHDX File'.Type
        Attributes                  =      [System.String[]]${Non-System VHD}.'VHDX File'.Attributes
        #Credential                 =      [PSCredential]${Non-System VHD}.'VHDX File'.Credential
        Ensure                      =      [System.String]${Non-System VHD}.'VHDX File'.Ensure
        #PsDscRunAsCredential       =      [PSCredential]${Non-System VHD}.'VHDX File'.PsDscRunAsCredential
        DependsOn                   =      ${Dependencys Event Log Channel Status}
      }

      ${Dependencys Copy Non-System Virtual Disk Files to Virtual Hard Disk Directory}.Add(
        [System.String]"[File]$(${Non-System VHD}.'VHDX File'.Resource_Title)"
      ) > $null
    }
    default { # Any other result is a partial reset |
      # (1) Unmount the .vhdx file
      VirtualHardDisk ${Non-System VHD}.VirtualHardDisk.Resource_Title {
        FilePath                  =    [System.String]${Non-System VHD}.VirtualHardDisk.FilePath 
        DiskFormat                =    [System.String]${Non-System VHD}.VirtualHardDisk.DiskFormat
        DiskSize                  =    [System.UInt64]${Non-System VHD}.VirtualHardDisk.DiskSize
        DiskType                  =    [System.String]${Non-System VHD}.VirtualHardDisk.DiskType
        Ensure                    =    [System.String]'Absent'
        #PsDscRunAsCredential     =    [PSCredential]${Non-System VHD}.VirtualHardDisk.PsDscRunAsCredential
        DependsOn                 =    ${Dependencys Event Log Channel Status}
      }

      # (2) Delete the .txt file containing the UniqueId of the disk
      File ${Non-System VHD}.'Text File with UniqueId'.Resource_Title {
        DestinationPath           =      [System.String]${Non-System VHD}.'Text File with UniqueId'.DestinationPath
        #Credential               =      [PSCredential]${Non-System VHD}.'Text File with UniqueId'.Credential
        Ensure                    =      [System.String]'Absent'
        #PsDscRunAsCredential     =      [PSCredential]${Non-System VHD}.'Text File with UniqueId'.PsDscRunAsCredential
        DependsOn                 =      ${Dependencys Event Log Channel Status}
      }

      # (3) Delete the .vhdx file from 'VHDX 2-Unique'
      File ${Non-System VHD}.VirtualHardDisk.Resource_Title {
        DestinationPath           =      [System.String]${Non-System VHD}.VirtualHardDisk.FilePath
        #Credential               =      [PSCredential]${Non-System VHD}.'Text File with UniqueId'.Credential
        Ensure                    =      [System.String]'Absent'
        #PsDscRunAsCredential     =      [PSCredential]${Non-System VHD}.'Text File with UniqueId'.PsDscRunAsCredential
        DependsOn                 =      ${Dependencys Event Log Channel Status}
      }

      # (4) Detach the VM Hard Disk Drive from the virtual SCSI Controller on the Hyper-V VM.
      VMHardDiskDrive ${Non-System VHD}.'VMHardDiskDrive'.Resource_Title {
        Path                        =      [System.String]${Non-System VHD}.'VMHardDiskDrive'.Path
        VMName                      =      [System.String]${Non-System VHD}.'VMHardDiskDrive'.VMName
        ControllerNumber            =      [System.UInt32]${Non-System VHD}.'VMHardDiskDrive'.ControllerNumber
        ControllerLocation          =      [System.UInt32]${Non-System VHD}.'VMHardDiskDrive'.ControllerLocation
        ControllerType              =      [System.String]${Non-System VHD}.'VMHardDiskDrive'.ControllerType
        Ensure                      =      [System.String]'Absent'
        #PsDscRunAsCredential       =      [PSCredential]${Non-System VHD}.'VMHardDiskDrive'.PsDscRunAsCredential
        DependsOn                   =      ${Dependencys Event Log Channel Status}
      }

      # (5) Delete the .vhdx file from the Virtual Hard Disks directory
      File ${Non-System VHD}.'VHDX File'.Resource_Title {
        DestinationPath             =      [System.String]${Non-System VHD}.'VHDX File'.DestinationPath
        SourcePath                  =      [System.String]${Non-System VHD}.'VHDX File'.SourcePath
        Type                        =      [System.String]${Non-System VHD}.'VHDX File'.Type
        Attributes                  =      [System.String[]]${Non-System VHD}.'VHDX File'.Attributes
        #Credential                 =      [PSCredential]${Non-System VHD}.'VHDX File'.Credential
        Ensure                      =      [System.String]'Absent'
        #PsDscRunAsCredential       =      [PSCredential]${Non-System VHD}.'VHDX File'.PsDscRunAsCredential
        DependsOn                   =      ${Dependencys Event Log Channel Status}
      }
    }
  }
}