#region | prompt(s) |
#######################################################################
#region | Here-Strings for the prompt function |
${Most Recent HistoryInfo Object Here-String} = @'
  ## Get the last item from the history
  $historyItem = Get-History -Count 1
'@
${History Indexing Here-String} = @'
  $HistoryItemId = 1

  $historyItem = Get-History -Count 1

  if ($null -ne $historyItem) {
    $HistoryItemId = $historyItem.Id + 1
  }

  Write-Host -Object "$HistoryItemId> " -NoNewLine

  "`b "
'@
${Suggest Command Alias Original Here-String} = @'
  ## If there were any history items
  if ($null -ne $historyItem) {
    # Feed prior commands into Get-AliasSuggestion and save output to variable
    $suggestions = @(Get-AliasSuggestion $historyItem.CommandLine)
    
    # Confirm whether any suggestions resulted
    if ($suggestions) {
      ## Write each suggestion to screen 
      foreach ($aliasSuggestion in $suggestions) {
        Write-Host -Object "$aliasSuggestion"
      }
      Write-Host ""
    }
  }

'@
${Suggest Command Alias v00 Here-String} = @'
  # Confirm whether any history items exist
  if ($null -ne $historyItem) {
    # Feed prior commands into Get-AliasSuggesti0n and save output to variable
    $suggestions = @(Get-AliasSuggesti0n $historyItem.CommandLine)

    # Confirm whether any output resulted
    if ($suggestions) {
      # if Get-AliasSuggesti0n has a suggestion, then stream output to console as a non-object
      ## Original: foreach ($aliasSuggestion in $suggestions) {Write-Host -Object "$aliasSuggestion"}

      [System.String[]]$RefinedSuggestions = $suggestions | Sort-Object | Get-Unique
      [System.String[]]$global:GlobalRefinedSuggestions = $suggestions | Sort-Object | Get-Unique
      $RenameThisHashTable = [System.Collections.Hashtable]::New()
      [System.String[]]${Alias Definitions} = foreach ($RefinedSuggestion in $RefinedSuggestions) {
        $RefinedSuggestion -match '^(?<Alias_Definition>[a-z0-9-_]+)%_Separator_%(?<Alias_Name>[a-z0-9-_]+)$' | Out-Null
        $Matches['Alias_Definition']
      }
      [System.String[]]$KeyTitles = ${Alias Definitions} | Sort-Object | Get-Unique
      [System.String[]]$global:GlobalKeyTitles = ${Alias Definitions} | Sort-Object | Get-Unique

      # for ($i = 0; $i -lt $KeyTitles.Count; $i++) {$KeyTitle = $KeyTitles[$i]; for ($j = 0; $j -lt $j++) {}}

      foreach ($KeyTitle in $KeyTitles) {
        [System.String[]]${Alias Names} = foreach ($suggestion in $RefinedSuggestions) {
          #$pattern = "^(?<Alias_Definition>$([System.Text.RegularExpressions.Regex]::Escape($KeyTitle)))%_Separator_%(?<Alias_Name>.+)$"
          #$pattern = "^(?<Alias_Definition>$($KeyTitle))%_Separator_%(?<Alias_Name>.+)$"
          #[System.Text.RegularExpressions.Regex]$pattern = "^(?<Alias_Definition>$($KeyTitle))%_Separator_%(?<Alias_Name>.+)$"
          [System.String]$pattern = "^(?<Alias_Definition>$($KeyTitle))%_Separator_%(?<Alias_Name>.+)`$"
          if ($suggestion -match $pattern) {
            $Matches['Alias_Name']
          }              
        }

        ${Alias Names Unique} = ${Alias Names} | Sort-Object | Get-Unique

        $KeyValue = ${Alias Names Unique} -join ' '

        $RenameThisHashTable.Add($KeyTitle,$KeyValue)
      }

      $KeyTitleIndexMax = $KeyTitles.Count - 1
      foreach ($KeyTitleIndex in (0..$KeyTitleIndexMax)) {
        $KeyTitle = $KeyTitles[$KeyTitleIndex]
        ${No-color Output} = $KeyTitles[$KeyTitleIndex] + ':' + $($RenameThisHashTable[$KeyTitle])

        $HT = @{
          Object          = ${No-color Output}
          ForegroundColor = [System.ConsoleColor]::Black
          BackgroundColor = $(Pick-RandomBackgroundColor)
          NoNewLine       = $true
        }
        Write-Host @HT
        Write-Host -Object ""
      }

      Write-Host -Object ""
      <#

        @(0..$KeyTitleIndexMax) | ForEach-Object -Process {
          $KeyTitleIndex = $_
          $KeyTitle = $KeyTitles[$KeyTitleIndex]

          ${No-color Output} = $KeyTitles[$KeyTitleIndex] + ':' + $($RenameThisHashTable[$KeyTitle] -join ',')

          $BackgroundColor = $(Pick-RandomBackgroundColor)

          $HT = @{
            Object          = ${No-color Output}
            ForegroundColor = [System.ConsoleColor]::Black
            BackgroundColor = $BackgroundColor
            NoNewLine       = $false
          }
          Write-Host @HT
          # "`b"
        }
        Write-Host -Object ""

      #>

      #$HT = @{
      #  Object          = "$([System.String]::Join(' ',$suggestions))"
      #  ForegroundColor = [System.ConsoleColor]::Black
      #  BackgroundColor = Pick-RandomBackgroundColor
      #}
      #Write-Host @HT
    }
  }
'@
${Suggest Command Alias v01 Here-String} = @'
  #region | Function Get-AliasSuggesti0n is called |
  # Confirm whether any history items exist
  if ($null -ne $historyItem) {
    # Feed prior commands into Get-AliasSuggesti0n and save output to variable
    #$suggestions = @(Get-AliasSuggesti0n $historyItem.CommandLine)
    $suggestions = @(Get-AliasSuggesti0n -LastCommand $historyItem.CommandLine)

    # Confirm whether any output resulted
    if ($suggestions) {
      # if Get-AliasSuggesti0n has a suggestion, then stream output to console as a non-object
      ## Original: foreach ($aliasSuggestion in $suggestions) {Write-Host -Object "$aliasSuggestion"}

      [System.String[]]$RefinedSuggestions = $suggestions | Sort-Object | Get-Unique
      #[System.String[]]$global:GlobalRefinedSuggestions = $suggestions | Sort-Object | Get-Unique
      $RenameThisHashTable = [System.Collections.Hashtable]::New()
      [System.String[]]${Alias Definitions} = foreach ($RefinedSuggestion in $RefinedSuggestions) {
        $RefinedSuggestion -match '^(?<Alias_Definition>[a-z0-9-_]+)%_Separator_%(?<Alias_Name>[a-z0-9-_]+)$' | Out-Null
        $Matches['Alias_Definition']
      }
      [System.String[]]$KeyTitles = ${Alias Definitions} | Sort-Object | Get-Unique
      #[System.String[]]$global:GlobalKeyTitles = ${Alias Definitions} | Sort-Object | Get-Unique

      # for ($i = 0; $i -lt $KeyTitles.Count; $i++) {$KeyTitle = $KeyTitles[$i]; for ($j = 0; $j -lt $j++) {}}

      foreach ($KeyTitle in $KeyTitles) {
        [System.String[]]${Alias Names} = foreach ($suggestion in $RefinedSuggestions) {
          #$pattern = "^(?<Alias_Definition>$([System.Text.RegularExpressions.Regex]::Escape($KeyTitle)))%_Separator_%(?<Alias_Name>.+)$"
          #$pattern = "^(?<Alias_Definition>$($KeyTitle))%_Separator_%(?<Alias_Name>.+)$"
          #[System.Text.RegularExpressions.Regex]$pattern = "^(?<Alias_Definition>$($KeyTitle))%_Separator_%(?<Alias_Name>.+)$"
          [System.String]$pattern = "^(?<Alias_Definition>$($KeyTitle))%_Separator_%(?<Alias_Name>.+)`$"
          if ($suggestion -match $pattern) {
            $Matches['Alias_Name']
          }              
        }

        ${Alias Names Unique} = ${Alias Names} | Sort-Object | Get-Unique

        $KeyValue = ${Alias Names Unique} -join ' '

        $RenameThisHashTable.Add($KeyTitle,$KeyValue)
      }

      $KeyTitleIndexMax = $KeyTitles.Count - 1
      [System.Collections.Hashtable[]] $Collection_Of_Hashtables = foreach ($KeyTitleIndex in (0..$KeyTitleIndexMax)) {
        $KeyTitle = $KeyTitles[$KeyTitleIndex]

        ${No-color Output} = $KeyTitles[$KeyTitleIndex] + ':' + $($RenameThisHashTable[$KeyTitle])

        @{
          Object          = ${No-color Output}
          ForegroundColor = [System.ConsoleColor]::Black
          #ForegroundColor = $(Pick-RandomForegroundColor)
          BackgroundColor = $(Pick-RandomBackgroundColor)
          NoNewLine       = $true
        }
      }

      for ($k = 0; $k -lt $Collection_Of_Hashtables.Count; $k++) {
        $IndividualHT = $Collection_Of_Hashtables[$k]
        Write-Host @IndividualHT
        if ($k -lt ($Collection_Of_Hashtables.Count - 1)) {
          Write-Host "|" -NoNewLine
        }            
      }

      Write-Host -Object ""
    }
  }
  #endregion
'@
${Reveal Parameter AliasesV2 Here-String} = @'
  #region | Slightly modified version of Get-ParameterAlias by Lee Holmes |
  # More annoying than anything else. Comment this line once you get tired of the on screen clutter
  # lol, yeah this is really annoying #  ${Reveal Parameter AliasesV2}.InvokeReturnAsIs()
  # if (Test-Path -Path "$env:AutoTml\Get-ParameterAlias.ps1") {Get-ParameterAlias};' 
  #endregion
'@




${Display History Index Here-String} = @'
  $HistoryItemId = 1
  if ($null -ne $historyItem) {
    $HistoryItemId = $historyItem.Id + 1
  }
  Write-Host -Object "$HistoryItemId> " -NoNewLine
  "`b "
'@
#endregion
#region | What evidence signals that the console is actually PowerShell Remoting session? |
$_Var_Name = 'PSSenderInfo'; try {Get-Variable -Name $_Var_Name -ErrorAction 'Stop' | Out-Null} catch {New-Variable -Name $_Var_Name -Value $null}
# Is this another Option?    Test-Path -Path Variable:\PSSenderInfo
# Is the concept of a 'runspace' related? 
#endregion
switch ($true) {
  ('a' -eq 'b') {
    ${Prompt Here-String Set} = @(
      ${History Indexing Here-String}
    )
    ${Prompt Here-String} = [System.String]::Join("`r`n",${Prompt Here-String Set})
    ${Prompt ScriptBlock} = [ScriptBlock]::Create(${Prompt Here-String})

    # function prompt ${Prompt Here-String}
    function prompt {& ${Prompt ScriptBlock}}

    # Figure this out some other time. 
    # I think that Siddaway-Payette Chapter 10 holds the solution

    break
  }
  # Situation 1: Block that runs if code within profile.ps1 is executed by the .NET runtime within a virtual machine (if the local machine is also the Hyper-V host.) |
  (${Computer Info Lite}.ImmutableTitle -eq 'Virtual Machine') {

    function prompt {
      $HistoryItemId = 1

      $historyItem = Get-History -Count 1

      if ($historyItem) {
        $HistoryItemId = $historyItem.Id + 1
      }

      Write-Host -Object "$HistoryItemId> " -NoNewLine

      "`b "
    }

    break
  }
  # Situation 2: Block that runs if code within profile.ps1 is executed by the .NET runtime within a remote machine (either physical or virtual)
  ($null -ne $PSSenderInfo) {
    ${Prop Joe & Omar} = "Prop Joe & Omar"

    function prompt {
      $HistoryItemId = 1

      $historyItem = Get-History -Count 1

      if ($historyItem) {
        $HistoryItemId = $historyItem.Id + 1
      }

      Write-Host -Object "$HistoryItemId> " -NoNewLine

      "`b "
    }
    
    break
  }
  # Situation "not 1 or 2": Block that runs if code within profile.ps1 is executed by the .NET runtime of the local machine. 
  # Situation "not 1 or 2" is the most common situation. 
  (${Computer Info Lite}.ImmutableTitle -ne 'Virtual Machine') {
    ${Prompt Here-String Set} = $(
      ${Most Recent HistoryInfo Object Here-String}
      #if (${Computer Info Lite}.IsWindowsClient) {${Suggest Command Alias Original Here-String}}
      if (${Computer Info Lite}.IsWindowsClient) {${Suggest Command Alias v01 Here-String}}
      ${Display History Index Here-String}
    )
    ${Prompt Here-String} = [System.String]::Join("`r`n",${Prompt Here-String Set})
    ${Prompt ScriptBlock} = [ScriptBlock]::Create(${Prompt Here-String})
    function prompt {& ${Prompt ScriptBlock}}
    break
  }
}
#######################################################################
#endregion

