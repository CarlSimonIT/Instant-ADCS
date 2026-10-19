function New-WindowsPreinstallationEnvironmentWorkspace {
  []
}

<# copype.cmd |
  @echo off
  setlocal

  set TEMPL=media
  set BOOTBINS=bootbins
  set EXITCODE=0
  set WIMMOUNTED=0

  rem
  rem Input validation
  rem
  if /i "%1"=="/?" goto usage
  if /i "%1"=="" goto usage
  if /i "%~2"=="" goto usage
  if /i not "%3"=="" goto usage

  rem
  rem Set environment variables for use in the script
  rem
  set WINPE_ARCH=%1
  set SOURCE=%WinPERoot%\%WINPE_ARCH%
  set FWFILESROOT=%OSCDImgRoot%\..\..\%WINPE_ARCH%\Oscdimg
  set DEST=%~2
  set WIMSOURCEPATH=%SOURCE%\en-us\winpe.wim

  rem
  rem Validate input architecture
  rem
  rem If the source directory as per input architecture does not exist,
  rem it means the architecture is not present
  rem
  if not exist "%SOURCE%" (
    echo ERROR: The following processor architecture was not found: %WINPE_ARCH%.
    goto fail
  )

  rem
  rem Validate the boot app directory location
  rem
  rem If the input architecture is validated, this directory must exist
  rem This check is only to be extra careful
  rem
  if not exist "%FWFILESROOT%" (
    echo ERROR: The following path for firmware files was not found: "%FWFILESROOT%".
    goto fail
  )

  rem
  rem Make sure the appropriate winpe.wim is present
  rem
  if not exist "%WIMSOURCEPATH%" (
    echo ERROR: WinPE WIM file does not exist: "%WIMSOURCEPATH%".
    goto fail
  )

  rem
  rem Make sure the destination directory does not exist
  rem
  if exist "%DEST%" (
    echo ERROR: Destination directory exists: %2.
    goto fail
  )

  mkdir "%DEST%"
  if errorlevel 1 (
    echo ERROR: Unable to create destination: %2.
    goto fail
  )

  echo.
  echo ===================================================
  echo Creating Windows PE customization working directory
  echo.
  echo     %DEST%
  echo ===================================================
  echo.

  mkdir "%DEST%\%TEMPL%"
  if errorlevel 1 (
    echo ERROR: Unable to create directory: "%DEST%\%TEMPL%".
    goto fail
  )

  mkdir "%DEST%\mount"
  if errorlevel 1 (
    echo ERROR: Unable to create directory: "%DEST%\mount".
    goto fail
  )

  mkdir "%DEST%\%BOOTBINS%"
  if errorlevel 1 (
    echo ERROR: Unable to create directory: "%DEST%\%BOOTBINS%".
    goto fail
  )

  echo Staging media files...

  rem
  rem Copy the boot files and WinPE WIM to the destination location
  rem
  xcopy /herky "%SOURCE%\Media" "%DEST%\%TEMPL%\" >NUL
  if errorlevel 1 (
    echo ERROR: Unable to copy boot files: "%SOURCE%\Media" to "%DEST%\%TEMPL%".
    goto fail
  )

  mkdir "%DEST%\%TEMPL%\sources"
  if errorlevel 1 (
    echo ERROR: Unable to create directory: "%DEST%\%TEMPL%\sources".
    goto fail
  )

  copy "%WIMSOURCEPATH%" "%DEST%\%TEMPL%\sources\boot.wim" >NUL
  if errorlevel 1 (
    echo ERROR: Unable to copy WinPE WIM: "%WIMSOURCEPATH%" to "%DEST%\%TEMPL%\sources\boot.wim".
    goto fail
  )

  rem
  rem Mount the WinPE WIM file
  rem
  echo Mounting "%DEST%\%TEMPL%\sources\boot.wim"
  "%DISMRoot%\Dism.exe" /Mount-Image /ImageFile:"%DEST%\%TEMPL%\sources\boot.wim" /Index:1 /MountDir:"%DEST%\mount" /ReadOnly >NUL
  if errorlevel 1 (
    echo ERROR: Failed to mount the WinPE WIM file. Check logs at %WINDIR%\Logs\DISM for more details.
    goto fail
  )

  set WIMMOUNTED=1

  echo Copying boot files from WIM...

  rem
  rem Copy both 2011 and 2023 signed boot managers for later use
  rem
  copy "%DEST%\mount\Windows\Boot\EFI\bootmgfw.efi" "%DEST%\%BOOTBINS%" >NUL
  if errorlevel 1 (
    echo ERROR: Unable to copy boot file: "bootmgfw.efi" to "%DEST%\%BOOTBINS%".
    goto fail
  )
  copy "%DEST%\mount\Windows\Boot\EFI_EX\bootmgfw_EX.efi" "%DEST%\%BOOTBINS%" >NUL
  if errorlevel 1 (
    echo ERROR: Unable to copy boot file: "bootmgfw_EX.efi" to "%DEST%\%BOOTBINS%".
    goto fail
  )

  rem
  rem Copy the boot sector files to enable ISO creation and boot
  rem
  rem  UEFI boot uses efisys.bin or efisys_EX.bin
  rem  BIOS boot uses etfsboot.com
  rem

  copy "%FWFILESROOT%\efisys.bin" "%DEST%\%BOOTBINS%" >NUL
  if errorlevel 1 (
    echo ERROR: Unable to copy boot sector file: "%FWFILESROOT%\efisys.bin" to "%DEST%\%BOOTBINS%".
    goto fail
  )

  copy "%FWFILESROOT%\efisys_noprompt.bin" "%DEST%\%BOOTBINS%" >NUL
  if errorlevel 1 (
    echo ERROR: Unable to copy boot sector file: "%FWFILESROOT%\efisys_noprompt.bin" to "%DEST%\%BOOTBINS%".
    goto fail
  )

  copy "%FWFILESROOT%\efisys_EX.bin" "%DEST%\%BOOTBINS%" >NUL
  if errorlevel 1 (
    echo ERROR: Unable to copy boot sector file: "%FWFILESROOT%\efisys_EX.bin" to "%DEST%\%BOOTBINS%".
    goto fail
  )

  copy "%FWFILESROOT%\efisys_noprompt_EX.bin" "%DEST%\%BOOTBINS%" >NUL
  if errorlevel 1 (
    echo ERROR: Unable to copy boot sector file: "%FWFILESROOT%\efisys_noprompt_EX.bin" to "%DEST%\%BOOTBINS%".
    goto fail
  )

  if not exist "%FWFILESROOT%\etfsboot.com" goto success

  copy "%FWFILESROOT%\etfsboot.com" "%DEST%\%BOOTBINS%" >NUL
  if errorlevel 1 (
    echo ERROR: Unable to copy boot sector file: "%FWFILESROOT%\etfsboot.com" to "%DEST%\%BOOTBINS%".
    goto fail
  )

  :success
  set EXITCODE=0
  cd /d "%~2"
  goto cleanup

  :usage
  set EXITCODE=1
  echo Creates working directories for WinPE image customization and media creation.
  echo.
  echo copype { amd64 ^| x86 ^| arm ^| arm64 } ^<workingDirectory^>
  echo.
  echo  amd64             Copies amd64 boot files and WIM to ^<workingDirectory^>\media.
  echo  x86               Copies x86 boot files and WIM to ^<workingDirectory^>\media.
  echo  arm               Copies arm boot files and WIM to ^<workingDirectory^>\media.
  echo  arm64             Copies arm64 boot files and WIM to ^<workingDirectory^>\media.
  echo                    Note: ARM/ARM64 content may not be present in this ADK.
  echo  workingDirectory  Creates the working directory at the specified location.
  echo.
  echo Example: copype amd64 C:\WinPE_amd64
  goto cleanup

  :fail
  set EXITCODE=1
  echo.
  echo Failed to stage %DEST%!
  echo.
  goto cleanup

  :cleanup
  if %WIMMOUNTED% EQU 1 (
    echo Unmounting "%DEST%\%TEMPL%\sources\boot.wim"
    "%DISMRoot%\Dism.exe" /Unmount-Image /MountDir:"%DEST%\mount" /Discard >NUL
    if errorlevel 1 (
      echo ERROR: "%DEST%\%TEMPL%\sources\boot.wim" still mounted!
      set EXITCODE=1
    )
  )
  if %EXITCODE% EQU 0 (
    echo.
    echo ===================================================
    echo Successfully staged %DEST%
    echo ===================================================
    echo.
  )
  endlocal & exit /b %EXITCODE%
#>












<# DandISetEnv.bat
  @Echo off

  REM
  REM Sets the PROCESSOR_ARCHITECTURE according to native platform. 
  REM
  IF /I %PROCESSOR_ARCHITECTURE%==x86 (
      REM Set the "right" processor architecture
      IF NOT "%PROCESSOR_ARCHITEW6432%"=="" (
          SET PROCESSOR_ARCHITECTURE=%PROCESSOR_ARCHITEW6432%
      )
  ) ELSE IF /I %PROCESSOR_ARCHITECTURE%==arm (
      REM Set the "right" processor architecture
      IF NOT "%PROCESSOR_ARCHITEW6432%"=="" (
          SET PROCESSOR_ARCHITECTURE=%PROCESSOR_ARCHITEW6432%
      )
  ) ELSE IF /I %PROCESSOR_ARCHITECTURE%==amd64 (
      REM Nothing to do
  ) ELSE IF /I %PROCESSOR_ARCHITECTURE%==arm64 (
      REM Nothing to do
  ) ELSE (
      @echo Not implemented for PROCESSOR_ARCHITECTURE of %PROCESSOR_ARCHITECTURE%.
      got :EOF
  )

  REM
  REM Query the 32-bit and 64-bit Registry hive for KitsRoot
  REM

  SET regKeyPathFound=1
  SET wowRegKeyPathFound=1
  SET KitsRootRegValueName=KitsRoot10

  REG QUERY "HKLM\Software\Wow6432Node\Microsoft\Windows Kits\Installed Roots" /v %KitsRootRegValueName% 1>NUL 2>NUL || SET wowRegKeyPathFound=0
  REG QUERY "HKLM\Software\Microsoft\Windows Kits\Installed Roots" /v %KitsRootRegValueName% 1>NUL 2>NUL || SET regKeyPathFound=0

  if %wowRegKeyPathFound% EQU 0 (
    if %regKeyPathFound% EQU 0 (
      @echo KitsRoot not found, can't set common path for Deployment Tools
      goto :EOF 
    ) else (
      SET regKeyPath=HKLM\Software\Microsoft\Windows Kits\Installed Roots
    )
  ) else (
      SET regKeyPath=HKLM\Software\Wow6432Node\Microsoft\Windows Kits\Installed Roots
  )

    
  FOR /F "skip=2 tokens=2*" %%i IN ('REG QUERY "%regKeyPath%" /v %KitsRootRegValueName%') DO (SET KitsRoot=%%j)

  REM
  REM Build the D&I Root from the queried KitsRoot
  REM
  SET DandIRoot=%KitsRoot%Assessment and Deployment Kit\Deployment Tools

  REM
  REM Construct the path to WinPE directory, architecture-independent
  REM
  SET WinPERoot=%KitsRoot%Assessment and Deployment Kit\Windows Preinstallation Environment
  SET WinPERootNoArch=%KitsRoot%Assessment and Deployment Kit\Windows Preinstallation Environment

  REM
  REM Construct the path to DISM, Setup and USMT, architecture-independent
  REM
  SET WindowsSetupRootNoArch=%KitsRoot%Assessment and Deployment Kit\Windows Setup
  SET USMTRootNoArch=%KitsRoot%Assessment and Deployment Kit\User State Migration Tool

  REM 
  REM Constructing tools paths relevant to the current Processor Architecture 
  REM
  SET DISMRoot=%DandIRoot%\%PROCESSOR_ARCHITECTURE%\DISM
  SET BCDBootRoot=%DandIRoot%\%PROCESSOR_ARCHITECTURE%\BCDBoot
  SET ImagingRoot=%DandIRoot%\%PROCESSOR_ARCHITECTURE%\Imaging
  SET OSCDImgRoot=%DandIRoot%\%PROCESSOR_ARCHITECTURE%\Oscdimg
  SET WdsmcastRoot=%DandIRoot%\%PROCESSOR_ARCHITECTURE%\Wdsmcast

  REM
  REM Now do the paths that apply to all architectures...
  REM
  REM Note that the last one in this list should not have a
  REM trailing semi-colon to avoid duplicate semi-colons
  REM on the last entry when the final path is assembled.
  REM
  SET HelpIndexerRoot=%DandIRoot%\HelpIndexer

  REM
  REM Set WSIMRoot. WSIM is x86 only
  REM
  SET WSIMRoot=%DandIRoot%\WSIM\x86

  REM
  REM Set ICDRoot. ICD is x86 only
  REM
  SET ICDRoot=%KitsRoot%Assessment and Deployment Kit\Imaging and Configuration Designer\x86

  REM
  REM Now buld the master path from the various tool root folders...
  REM
  REM Note that each fragment above should have any required trailing 
  REM semi-colon as a delimiter so we do not put any here.
  REM
  REM Note the last one appended to NewPath should be the last one
  REM set above in the arch. neutral section which also should not
  REM have a trailing semi-colon.
  REM
  SET NewPath=%DISMRoot%;%ImagingRoot%;%BCDBootRoot%;%OSCDImgRoot%;%WdsmcastRoot%;%HelpIndexerRoot%;%WSIMRoot%;%WinPERoot%;%ICDRoot%

  SET PATH=%NewPath:"=%;%PATH%

  REM
  REM Set current directory to DandIRoot
  REM
  cd /d "%DandIRoot%"

  REM
  REM Run WimMountAdkSetup to install the wimmount.sys and wofadk.sys
  REM file system filter drivers.
  REM
  "%DISMRoot%\WimMountAdkSetup%PROCESSOR_ARCHITECTURE%.exe" /repair /q /log %WINDIR%\Logs\DISM\WimMountAdkSetup.log

#>



