#Requires -PSEdition Desktop -Version 5.1

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
  '`$usb0_FriendlyName'
  '`$usb0_UniqueId'
  '`$usb0_SerialNumber'
  '`$usb1_FriendlyName'
  '`$usb1_UniqueId'
  '`$usb1_SerialNumber'
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

  ## Left-concatenate three tab characters represented as plain-text (`t`t`t)
  $LineNew = '`t`t`t' + $LineNew

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
