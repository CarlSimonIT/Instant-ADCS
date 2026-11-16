[DscResource()]
class VhdxFileFromIsoImage {
  [DscProperty(Key)]
  [System.String]
  $VhdxFilePath

  [DscProperty()]
  [ValidateSet(
    '1','2','3','4','5','6','7','8','9','10'
  )]
  [System.UInt16]
  $IndexOfImage = 1

  [DscProperty(Mandatory)]
  [System.String]
  $IsoFilePath

  [DscProperty()]
  [System.UInt64]
  $DiskSizeOfMountedSystemVhdx = 256GB

  [DscProperty()]
  [System.String[]]
  $DscResModZipFilePaths

  [DscProperty(NotConfigurable)]
  [System.Boolean]
  $Assessment

  [DscProperty(Mandatory)]
  [Ensure]
  $Ensure

  #%_Test Explained Here-String_%
  [System.Boolean] Test () {
    #region | Test() Subphase A | Uncover the reality |
    Write-Verbose -Message "Test() Subphase A"
    ${OBSERVED real-world state of the object which corresponds to this exact specific DSC Resource instance} = Get-Item -Path ($this.VhdxFilePath) -ErrorAction 'SilentlyContinue'

    if ($null -ne ${OBSERVED real-world state of the object which corresponds to this exact specific DSC Resource instance}) 
    {
      ${Does there exist on this computer a real-world object whose properties perfectly match the exact specific DSC Resource instance?} = 'Yup'
    } 
    else 
    {
      ${Does there exist on this computer a real-world object whose properties perfectly match the exact specific DSC Resource instance?} = 'Nope'
    }
    #endregion

    #region | Test() Subphase B | Consider whether this reality is desired |
    Write-Verbose -Message "Test() Subphase B"
    if (
      'Yup' -eq ${Does there exist on this computer a real-world object whose properties perfectly match the exact specific DSC Resource instance?} `
      -and `
      $this.Ensure -eq [Ensure]::Present
    ) {
      $this.Assessment = $true
    }

    if (
      'Nope' -eq ${Does there exist on this computer a real-world object whose properties perfectly match the exact specific DSC Resource instance?} `
      -and `
      $this.Ensure -eq [Ensure]::Present
    ) {
      $this.Assessment = $false
    }

    if (
      'Yup' -eq ${Does there exist on this computer a real-world object whose properties perfectly match the exact specific DSC Resource instance?} `
      -and `
      $this.Ensure -eq [Ensure]::Absent
    ) {
      $this.Assessment = $false
    }

    if (
      'Nope' -eq ${Does there exist on this computer a real-world object whose properties perfectly match the exact specific DSC Resource instance?} `
      -and `
      $this.Ensure -eq [Ensure]::Absent
    ) {
      $this.Assessment = $true
    }
    #endregion

    #region | Test() Subphase C | Return to Set() the $Assessment. If this reality is NOT desired, Set() will handle the details |
    Write-Verbose -Message "Test() Subphase C: `$Assessment = $($this.Assessment)"
    return $this.Assessment
    #endregion
  }

  #%_Set Explained Here-String_%
  [System.Void] Set () {
    Write-Verbose -Message "Call to Set()"
    if ($this.Ensure -eq [Ensure]::Present) 
    {
      Write-Verbose -Message "Mounting the DiskImage at path '$($this.IsoFilePath)'"
      $MountedImageLetter = (Mount-DiskImage -ImagePath $this.IsoFilePath | Get-DiskImage | Get-Volume | Select-Object -ExpandProperty 'DriveLetter') + ':'

      Write-Verbose -Message "New VHD at path '$($this.VhdxFilePath)' with disk size of $($this.DiskSizeOfMountedSystemVhdx/1GB)GB"
      New-VHD -Path $this.VhdxFilePath -SizeBytes ($this.DiskSizeOfMountedSystemVhdx) -Dynamic | Out-Null

      Write-Verbose -Message "Mount vhdx file"
      $MountedRefVhdxDiskNumber = Mount-DiskImage -ImagePath $this.VhdxFilePath | Get-DiskImage | Get-Disk | Select-Object -ExpandProperty 'Number'

      Write-Verbose -Message "Initialize Disk that is in reality a mounted vhdx file"
      Initialize-Disk -Number $MountedRefVhdxDiskNumber -PartitionStyle 'MBR'
      Write-Verbose -Message "New partition creation"
      $MountedRefVhdxLetter = (New-Partition -DiskNumber $MountedRefVhdxDiskNumber -AssignDriveLetter -UseMaximumSize -IsActive | Format-Volume -FileSystem 'NTFS' -Confirm:$false | Select-Object -ExpandProperty 'DriveLetter') + ':'

      Write-Verbose -Message "Apply Image"
      Dism.exe /Apply-Image /ImageFile:"$MountedImageLetter\Sources\install.wim" /Index:$($this.IndexOfImage) /ApplyDir:"$MountedRefVhdxLetter\" | Out-Null

      Write-Verbose -Message "Extract DSC Resource module ZIP files"
      $this.DscResModZipFilePaths | ForEach-Object -Process {
        $expandarchive_HT = @{
          Path            = $_
          DestinationPath = "$MountedRefVhdxLetter\Program Files\WindowsPowerShell\Modules"
          Verbose         = $false
          ErrorAction     = 'SilentlyContinue'
          Force           = $true
        }
        Expand-Archive @expandarchive_HT | Out-Null
      }

      Write-Verbose -Message "bcdboot"
      bcdboot.exe $MountedRefVhdxLetter\Windows /s $MountedRefVhdxLetter /f BIOS | Out-Null

      Write-Verbose -Message "mbr2gpt"
      MBR2GPT.EXE /Convert /Disk:$MountedRefVhdxDiskNumber /allowFullOs | Out-Null

      Write-Verbose -Message "diskmount disk image of VHDX file"
      Dismount-DiskImage -ImagePath $this.VhdxFilePath | Out-Null

      Write-Verbose -Message "diskmount disk image of ISO file"
      Dismount-DiskImage -ImagePath $this.IsoFilePath | Out-Null
    }
    elseif ($this.Ensure -eq [Ensure]::Absent) 
    {
      Write-Verbose -Message "Remove VHDX File"
      Remove-Item -Path $this.VhdxFilePath -Force
    }
  }

  #%_Get Explained Here-String_%
  [VhdxFileFromIsoImage] Get () {
    Write-Verbose -Message "Get () real-world state of VhdxFileFromIsoImage resource instance"

    $CurrentState = [System.Collections.Hashtable]::New()    

    ${OBSERVED real-world state of the object which corresponds to this exact specific DSC Resource instance} = Get-Item -Path ($this.VhdxFilePath) -ErrorAction 'SilentlyContinue'

    if ($null -ne ${OBSERVED real-world state of the object which corresponds to this exact specific DSC Resource instance}) 
    {
      $CurrentState.Add('VhdxFilePath',${OBSERVED real-world state of the object which corresponds to this exact specific DSC Resource instance}.FullName)
      $CurrentState.Add('Ensure',[Ensure]::Present)
    } 
    else 
    {
      $CurrentState.Add('Ensure',[Ensure]::Absent)
    }

    return $CurrentState
  }
}