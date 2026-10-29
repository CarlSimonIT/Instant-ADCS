#Requires -PSEdition Desktop
#Requires -Version 5.1

function ConvertTo-HereStringPrecursor {
  [CmdletBinding()]
  [Alias('c2hsp')]
  param (
    [Parameter(
      Mandatory = $false
    )]
    [System.UInt32]
    [Alias('itq')]
    $InternalTabsQuantity = 0,

    [Parameter(
      Mandatory = $false
    )]
    [System.UInt32]
    [Alias('esq')]
    $ExternalSpacesQuantity = 2
  )

  # Copy PowerShell code to Windows Clipboard BEFORE to executing ConvertTo-HereStringPrecursor. 

  # Write clipboard to temporary file
  $FileOld = New-TemporaryFile
  Get-Clipboard | Out-File -FilePath $FileOld.FullName

  # Load unmodified text into $LinesOld
  $LinesOld = Get-Content -Path $FileOld.FullName

  ## Un-escape these specific text-sequences which represent variables
  ## that must be resolved prior to compiling the here-string.
  ${Escaped text sequences} = @(
    # '`$__DirectoryForDscConfigs'
    '`$([System.Char]96)'
    '`${usb0 FriendlyName}'
    '`${usb0 UniqueId}'
    '`${usb0 SerialNumber}'
    '`${usb1 FriendlyName}'
    '`${usb1 UniqueId Raw}'
    '`${usb1 SerialNumber}'
    '`${OSDeploy FriendlyName}'
    '`${OSDeploy UniqueId Raw}'
    '`${OSDeploy SerialNumber}'
  )

  # Process each line 
  $LinesNewPrecursor = foreach ($LineOld in $LinesOld) {
    ## replace all grave accent characters with $([System.Char]96)
    $LineNewPrecursor = $LineOld -replace '`$','$([System.Char]96)'
    
    ## Escape all PowerShell variables by replacing dollar-sign characters with `$
    $LineNewPrecursor = $LineNewPrecursor -replace '\$','`$'

    ## Replace all single-quote characters with $([System.Char]39)
    $LineNewPrecursor = $LineNewPrecursor -replace [Regex]::Escape($([System.Char]39)),'$([System.Char]39)'

    ## Replace all double-quote characters with $([System.Char]34)
    $LineNewPrecursor = $LineNewPrecursor -replace [Regex]::Escape($([System.Char]34)),'$([System.Char]34)'

    ## Un-escape any pattern that matches an element of the
    ## 'Escaped text sequences' array
    foreach (${Escaped text sequence} in ${Escaped text sequences}) {
      $Length = ${Escaped text sequence}.Length
      ${Un-escaped text sequence} = ${Escaped text sequence}.Substring(1,$Length - 1)
      $LineNewPrecursor = $LineNewPrecursor.Replace(${Escaped text sequence},${Un-escaped text sequence})
    }

    ## Left-concatenate "$InternalTabsQuantity" tab characters represented as plain-text
    if ($InternalTabsQuantity -gt 0) {
      ${Tabs To Left-Concatenate} = [System.String]::Join(
        (1..$InternalTabsQuantity).ForEach({"`t"}),''
      )
      $LineNewPrecursor = ${Tabs To Left-Concatenate} + $LineNewPrecursor
    }

    ## Right-concatenate a NewLine character represented as plain-text (`n)
    $LineNewPrecursor = $LineNewPrecursor + '`n'


    ## Enclose in double-quotes. 
    $LineNewPrecursor = $([System.Char]34) + $LineNewPrecursor + $([System.Char]34)

    <# Eliminate all spacing characters left of the double-quoted string |
      if (
        $LineNewPrecursor -match '^(?<Extraneous_SpacingChars>\s+)(?<Double_Quoted_String>.*)$'
      ) {
        $LineNewPrecursor = $Matches['Double_Quoted_String']
      }
    #>

    ## Return the $LineNewPrecursor
    $LineNewPrecursor
  }

  ## Top-concatenate a double quote-enclosed NewLine character represented as plain-text
  ## Lower-concatenate two double quote-enclosed tab characters represented as plain-text
  $LinesNewPrecursor = @('"`n"') + $LinesNewPrecursor + @('"`t`t"')

  ${Spaces To Left-Concatenate} = ''
  if ($ExternalSpacesQuantity -gt 0) {
    ${Spaces To Left-Concatenate} = (1..$ExternalSpacesQuantity | ForEach-Object -Process {Write-Output ' '}) -join ''
    #${Spaces To Left-Concatenate} = [System.String]::Join((1..$ExternalSpacesQuantity).ForEach({''}),' ')
  }
  #write-host -object "`${Spaces To Left-Concatenate}.Length = $(${Spaces To Left-Concatenate}.Length)"
  #write-host -object "`${Spaces To Left-Concatenate}.Count = $(${Spaces To Left-Concatenate}.Count)"

  $LinesNew = foreach ($LineNewPrecursor in $LinesNewPrecursor) {
    "${Spaces To Left-Concatenate}" + $LineNewPrecursor
  }

  # Define & write modified text to new temporary file
  $FileNew = New-TemporaryFile
  Set-Content -Path $FileNew.FullName -Value ($LinesNew)

  # Copy modified text to Windows Clipboard
  $LinesNew | Set-Clipboard
}

function ConvertTo-HereStringCompatible {
  [CmdletBinding()]
  [Alias('c2hsc')]
  param (
    [Parameter(
      Mandatory = $false
    )]
    [System.UInt32]
    [Alias('itq')]
    $InternalTabsQuantity = 3,

    [Parameter(
      Mandatory = $false
    )]
    [System.UInt32]
    [Alias('esq')]
    $ExternalSpacesQuantity = 6
  )

  # Copy PowerShell code to Windows Clipboard BEFORE to executing ConvertTo-HereStringCompatible. 

  # Write clipboard to temporary file
  $FileOld = New-TemporaryFile
  Get-Clipboard | Out-File -FilePath $FileOld.FullName

  # Load unmodified text into $LinesOld
  $LinesOld = Get-Content -Path $FileOld.FullName

  ## Un-escape these specific text-sequences which represent variables
  ## that must be resolved prior to compiling the here-string.
  ${Escaped text sequences} = @(
    '`$__DirectoryForDscConfigs'
    '`$FolderFQN'
    '`$([System.Char]96)'
    '`${usb0 FriendlyName}'
    '`${usb0 UniqueId}'
    '`${usb0 SerialNumber}'
    '`${usb1 FriendlyName}'
    '`${usb1 UniqueId Raw}'
    '`${usb1 SerialNumber}'
    '`${OSDeploy FriendlyName}'
    '`${OSDeploy UniqueId Raw}'
    '`${OSDeploy SerialNumber}'
  )

  # Process each line 
  $LinesNewPrecursor = foreach ($LineOld in $LinesOld) {
    ## replace all grave accent characters with $([System.Char]96)
    $LineNewPrecursor = $LineOld -replace '`$','$([System.Char]96)'
    
    ## Packing Import-DscResource into code within an XML file 
    ## requires a text-replacement workaround. 
    $LineNewPrecursor = $LineNewPrecursor -replace 'Imp0rt-DscResource','Import-DscResource'

    ## Escape all PowerShell variables by replacing dollar-sign characters with `$
    $LineNewPrecursor = $LineNewPrecursor -replace '\$','`$'

    ## Replace all single-quote characters with $([System.Char]39)
    $LineNewPrecursor = $LineNewPrecursor -replace [Regex]::Escape($([System.Char]39)),'$([System.Char]39)'

    ## Replace all double-quote characters with $([System.Char]34)
    $LineNewPrecursor = $LineNewPrecursor -replace [Regex]::Escape($([System.Char]34)),'$([System.Char]34)'

    ## Un-escape any pattern that matches an element of the
    ## 'Escaped text sequences' array
    foreach (${Escaped text sequence} in ${Escaped text sequences}) {
      $Length = ${Escaped text sequence}.Length
      ${Un-escaped text sequence} = ${Escaped text sequence}.Substring(1,$Length - 1)
      $LineNewPrecursor = $LineNewPrecursor.Replace(${Escaped text sequence},${Un-escaped text sequence})
    }

    ## Left-concatenate "$InternalTabsQuantity" tab characters represented as plain-text
    if ($InternalTabsQuantity -gt 0) {
      #${Tabs To Left-Concatenate} = [System.String]::Join((1..$InternalTabsQuantity).ForEach({"`t"}),'')

      ${Tabs To Left-Concatenate} = (1..$InternalTabsQuantity | ForEach-Object -Process {'`t'}) -join ''

      $LineNewPrecursor = ${Tabs To Left-Concatenate} + $LineNewPrecursor
    }

    ## Right-concatenate a NewLine character represented as plain-text (`n)
    $LineNewPrecursor = $LineNewPrecursor + '`n'


    ## Enclose in double-quotes. 
    $LineNewPrecursor = $([System.Char]34) + $LineNewPrecursor + $([System.Char]34)

    ## Return the $LineNewPrecursor
    $LineNewPrecursor
  }

  ## Top-concatenate a double quote-enclosed NewLine character represented as plain-text
  ## Lower-concatenate two double quote-enclosed tab characters represented as plain-text
  $LinesNewPrecursor = @('"`n"') + $LinesNewPrecursor + @('"`t`t"')

  ${Spaces To Left-Concatenate} = ''
  if ($ExternalSpacesQuantity -gt 0) {
    ${Spaces To Left-Concatenate} = (1..$ExternalSpacesQuantity | ForEach-Object -Process {Write-Output ' '}) -join ''
  }

  $LinesNew = foreach ($LineNewPrecursor in $LinesNewPrecursor) {
    "${Spaces To Left-Concatenate}" + $LineNewPrecursor
  }

  # Define & write modified text to new temporary file
  $FileNew = New-TemporaryFile
  Set-Content -Path $FileNew.FullName -Value ($LinesNew)

  # Copy modified text to Windows Clipboard
  $LinesNew | Set-Clipboard
}

function ConvertTo-NoTabsHereStringCompatible {
  [CmdletBinding()]
  param ()

  # Copy PowerShell code to Windows Clipboard prior to executing ConvertTo-HereStringCompatible. 

  # Write clipboard to temporary file
  $FileOld = New-TemporaryFile
  Get-Clipboard | Out-File -FilePath $FileOld.FullName

  # Load unmodified text into $LinesOld
  $LinesOld = Get-Content -Path $FileOld.FullName

  ## Un-escape these specific text-sequences which represent variables
  ## that must be resolved prior to compiling the here-string.
  ${Escaped text sequences} = @(
    '`$__DirectoryForDscConfigs'
    #'`$usb0_FriendlyName'
    #'`$usb0_UniqueId'
    #'`$usb0_SerialNumber'
    #'`$usb1_FriendlyName'
    #'`$usb1_UniqueId'
    #'`$usb1_SerialNumber'


    '${usb0 FriendlyName}'
    '${usb0 UniqueId}'
    '${usb0 SerialNumber}'
    '${usb1 FriendlyName}'
    '${usb1 UniqueId Raw}'
    '${usb1 SerialNumber}'
    '${OSDeploy FriendlyName}'
    '${OSDeploy UniqueId Raw}'
    '${OSDeploy SerialNumber}'
    '`$([System.Char]96)'
  )

  # Process each line 
  $LinesNew = foreach ($LineOld in $LinesOld) {
    ## replace all grave accent characters with $([System.Char]96)
    #$LineNew = $LineOld -replace [Regex]::Escape($([System.Char]96)),'$([System.Char]96)'
    #$LineNew = $LineOld -replace [Regex]::Escape('`$'),'$([System.Char]96)'
    $LineNew = $LineOld -replace '`$','$([System.Char]96)'
    
    ## Escape all PowerShell variables by replacing dollar-sign characters with `$
    #$LineNew = $LineNew -replace [Regex]::Escape('$'),'`$'
    $LineNew = $LineNew -replace '\$','`$'

    ## replace all single-quote characters with $([System.Char]39)
    $LineNew = $LineNew -replace [Regex]::Escape($([System.Char]39)),'$([System.Char]39)'

    ## replace all double-quote characters with $([System.Char]34)
    $LineNew = $LineNew -replace [Regex]::Escape($([System.Char]34)),'$([System.Char]34)'

    foreach (${Escaped text sequence} in ${Escaped text sequences}) {
      $Length = ${Escaped text sequence}.Length
      ${Un-escaped text sequence} = ${Escaped text sequence}.Substring(1,$Length - 1)
      #$LineNew = $LineNew -replace ${Escaped text sequence},${Un-escaped text sequence}
      $LineNew = $LineNew.Replace(${Escaped text sequence},${Un-escaped text sequence})
    }  

    ## Left-concatenate 0 tab characters represented as plain-text ()
    $LineNew = '' + $LineNew

    ## Right-concatenate a NewLine character represented as plain-text (`n)
    $LineNew = $LineNew + '`n'

    ## Enclose in double-quotes. 
    $LineNew = $([System.Char]34) + $LineNew + $([System.Char]34)

    ## Return the $LineNew
    $LineNew
  }

  ## Top-concatenate a double quote-enclosed NewLine character represented as plain-text
  ## Lower-concatenate two double quote-enclosed tab characters represented as plain-text
  $LinesNew = @('"`n"') + $LinesNew + @('"`t`t"')



  # Define & write modified text to new temporary file
  $FileNew = New-TemporaryFile
  Set-Content -Path $FileNew.FullName -Value ($LinesNew)

  # Copy modified text to Windows Clipboard
  $LinesNew | Set-Clipboard
}

