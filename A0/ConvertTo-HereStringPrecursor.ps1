#Requires -PSEdition Desktop
#Requires -Version 5.1

function ConvertTo-HereStringPrecursor {
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
    '`$__DirectoryForDscConfigs'
    '`$([System.Char]96)'
    '${usb0 FriendlyName}'
    '${usb0 UniqueId}'
    '${usb0 SerialNumber}'
    '${usb1 FriendlyName}'
    '${usb1 UniqueId Raw}'
    '${usb1 SerialNumber}'
    '${OSDeploy FriendlyName}'
    '${OSDeploy UniqueId Raw}'
    '${OSDeploy SerialNumber}'
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