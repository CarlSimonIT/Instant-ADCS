#region | PowerShell Cookbook (4th Ed.) Selections |
#######################################################################
#region | PowerShell Cookbook 4th Ed by Lee Holmes |
#region | TabExpansi0n2 by Lee Holmes | Relies on too much knowledge I don't yet have. Just keep going. |
function TabExpansi0n2 {
    ##############################################################################
    ##
    ## TabExpansi0n2
    ##
    ## From PowerShell Cookbook (O'Reilly)
    ## by Lee Holmes (http://www.leeholmes.com/guide)
    ##
    ##############################################################################

    [CmdletBinding(DefaultParameterSetName = 'ScriptInputSet')]
    Param(
        [Parameter(ParameterSetName = 'ScriptInputSet', Mandatory = $true, Position = 0)]
        [string] $inputScript,

        [Parameter(ParameterSetName = 'ScriptInputSet', Mandatory = $true, Position = 1)]
        [int] $cursorColumn,

        [Parameter(ParameterSetName = 'AstInputSet', Mandatory = $true, Position = 0)]
        [System.Management.Automation.Language.Ast] $ast,

        [Parameter(ParameterSetName = 'AstInputSet', Mandatory = $true, Position = 1)]
        [System.Management.Automation.Language.Token[]] $tokens,

        [Parameter(ParameterSetName = 'AstInputSet', Mandatory = $true, Position = 2)]
        [System.Management.Automation.Language.IScriptPosition] $positionOfCursor,

        [Parameter(ParameterSetName = 'ScriptInputSet', Position = 2)]
        [Parameter(ParameterSetName = 'AstInputSet', Position = 3)]
        [Hashtable] $options = $null
    )

    End
    {
        ## Create a new 'Options' hashtable if one has not been supplied.
        ## In this hashtable, you can add keys for the following options, using
        ## $true or $false for their values:
        ##
        ## IgnoreHiddenShares - Ignore hidden UNC shares (such as \\COMPUTER\ADMIN$)
        ## RelativePaths - When expanding filenames and paths, $true forces PowerShell
        ##     to replace paths with relative paths. When $false, forces PowerShell to
        ##     replace them with absolute paths. By default, PowerShell makes this
        ##     decision based on what you had typed so far before invoking tab completion.
        ## LiteralPaths - Prevents PowerShell from replacing special file characters
        ##     (such as square brackets and back-ticks) with their escaped equivalent.
        if(-not $options) { $options = @{} }

        ## Demonstrate some custom tab expansion completers for parameters.
        ## This is a hash table of parameter names (and optionally cmdlet names)
        ## that we add to the $options hashtable.
        ##
        ## When PowerShell evaluates the script block, $args gets the
        ## following: command name, parameter, word being completed,
        ## AST of the command being completed, and currently-bound arguments.
        $options["CustomArgumentCompleters"] = @{
            "Get-ChildItem:Filter" = { "*.ps1","*.txt","*.doc" }
            "ComputerName" = { "ComputerName1","ComputerName2","ComputerName3" }
        }

        ## Also define a completer for a native executable.
        ## When PowerShell evaluates the script block, $args gets the
        ## word being completed, and AST of the command being completed.
        $options["NativeArgumentCompleters"] = @{
            "attrib" = { "+R","+H","+S" }
        }

        ## Define a "quick completions" list that we'll cycle through
        ## when the user types '!!' followed by TAB.
        $quickCompletions = @(
            'Get-Process -Name PowerShell | ? Id -ne $pid | Stop-Process',
            'Set-Location $pshome',
            ('$errors = $error | % { $_.InvocationInfo.Line }; Get-History | ' +
                ' ? { $_.CommandLine -notin $errors }')
        )

        ## First, check the built-in tab completion results
        $result = $null
        if ($psCmdlet.ParameterSetName -eq 'ScriptInputSet')
        {
            $result = [System.Management.Automation.CommandCompletion]::CompleteInput(
                <#inputScript#>  $inputScript,
                <#cursorColumn#> $cursorColumn,
                <#options#>      $options)
        }
        else
        {
            $result = [System.Management.Automation.CommandCompletion]::CompleteInput(
                <#ast#>              $ast,
                <#tokens#>           $tokens,
                <#positionOfCursor#> $positionOfCursor,
                <#options#>          $options)
        }

        ## If we didn't get a result
        if($result.CompletionMatches.Count -eq 0)
        {
            ## If this was done at the command-line or in a remote session,
            ## create an AST out of the input
            if ($psCmdlet.ParameterSetName -eq 'ScriptInputSet')
            {
                $ast = [System.Management.Automation.Language.Parser]::ParseInput(
                    $inputScript, [ref]$tokens, [ref]$null)
            }

            ## In this simple example, look at the text being supplied.
            ## We could do advanced analysis of the AST here if we wanted,
            ## but in this case just use its text. We use a regular expression
            ## to check if the text started with two exclamations, and then
            ## use a match group to retain the rest.
            $text = $ast.Extent.Text
            if($text -match '^!!(.*)')
            {
                ## Extract the rest of the text from the regular expression
                ## match group.
                $currentCompletionText = $matches[1].Trim()

                ## Go through each of our quick completions and add them to
                ## our completion results. The arguments to the completion results
                ## are the text to be used in tab completion, a potentially shorter
                ## version to use for display (i.e.: intellisense in the ISE),
                ## the type of match, and a potentially more verbose description to
                ## be used as a tool tip.
                $quickCompletions | Where-Object { $_ -match $currentCompletionText } |
                    Foreach-Object { $result.CompletionMatches.Add(
                        (New-Object Management.Automation.CompletionResult $_,$_,
                            "Text",$_) )
                }
            }
        }

        return $result
    }
}
#endregion
#region | Get-AliasSuggestion | Get-AliasSuggesti0n | called by the prompt function. User can invoke as well |
function Get-AliasSuggestion {
  ##############################################################################
  ##
  ## Get-AliasSuggestion
  ##
  ## From Windows PowerShell Cookbook (O'Reilly)
  ## by Lee Holmes (http://www.leeholmes.com/guide)
  ##
  ##############################################################################
  
  <#
  
  .SYNOPSIS
  
  Get an alias suggestion from the full text of the last command. Intended to
  be added to your prompt function to help learn aliases for commands.
  
  .EXAMPLE
  
  PS > Get-AliasSuggestion Remove-ItemProperty
  Suggestion: An alias for Remove-ItemProperty is rp
  
  #>
  
  param(
    ## The full text of the last command
    $LastCommand
  )
  
  Set-StrictMode -Version 3
  
  $helpMatches = @()
  
  ## Find all of the commands in their last input
  $tokens = [Management.Automation.PSParser]::Tokenize(
    $lastCommand, [ref] $null)
  $commands = $tokens | Where-Object { $_.Type -eq "Command" }
  
  ## Go through each command
  foreach($command in $commands)
  {
    ## Get the alias suggestions
    foreach($alias in Get-Alias -Definition $command.Content)
    {
      $helpMatches += "Suggestion: An alias for " +
          "$($alias.Definition) is $($alias.Name)"
    }
  }
  
  $helpMatches
}
function Get-AliasSuggesti0n {
  ##############################################################################
  ##
  ## Get-AliasSuggesti0n
  ##
  ## From Windows PowerShell Cookbook (O'Reilly)
  ## by Lee Holmes (http://www.leeholmes.com/guide)
  ##
  ##############################################################################
  
  <#
  
  .SYNOPSIS
  
  Get an alias suggestion from the full text of the last command. Intended to
  be added to your prompt function to help learn aliases for commands.
  
  .EXAMPLE
  
  PS > Get-AliasSuggesti0n Remove-ItemProperty
  Suggestion: An alias for Remove-ItemProperty is rp
  
  #>
  
  param (
    ## Commands excluded from output when PowerShell calls Get-AliasSuggesti0n:      
    [System.String[]]
    $ExcludedCommands = @(
      'Get-ChildItem'
      'Get-Item'
      'Get-PSSession'
      'New-Item'
      'Copy-Item'
      'Clear-Host'
      'Format-List'
      #       $ExcludedCommands | Sort-Object | Get-Unique | clip.exe 
    ),

    ## The full text of the last command
    $LastCommand
  )
  
  Set-StrictMode -Version 3
  
  $helpMatches = @()
  
  ## Find all of the commands in their last input
  $global:t0kens = [Management.Automation.PSParser]::Tokenize($lastCommand, [ref] $null)
  $tokens = [Management.Automation.PSParser]::Tokenize($lastCommand, [ref] $null)
  $commands = $tokens | Where-Object -FilterScript {
    $_.Type           -eq          "Command"   -and `
    $ExcludedCommands -notcontains $_.Content
  }
  
  ## Go through each command
  foreach($command in $commands)
  {
      ## Get the alias suggestions
      foreach($alias in Get-Alias -Definition $command.Content)
      {
          # Original $helpMatches += "Suggestion: An alias for " + "$($alias.Definition) is $($alias.Name)"
          # $helpMatches += $alias.Name
          $helpMatches += $($alias.Definition) + '%_Separator_%' + $($alias.Name)
      }
  }
  
  $helpMatches
}
#endregion
#region | Slightly modified version of Get-ParameterAlias by Lee Holmes |
${Reveal Parameter AliasesV2 Here-String} = @'
  ## Get the last item from the session history
  $history = Get-History -Count 1
  if (-not $history) {return}

  ## And extract the actual command line typed
  ${Last CLI input} = $history.CommandLine

  ## Use the Tokenizer API to determine which portions represent
  ## commands and parameters to those commands
  ${Token Array} = [System.Management.Automation.PsParser]::Tokenize(${Last CLI input}, [ref]$null)
  <#
    ${Token Array}.Count
    for($i = 0; $i -le ${Token Array}.Count; $i++) {
      ${Token Array}[$i].Content
      ${Token Array}[$i].Type
      ""
    }
  #>
  ${Token of type Command} = $null

  ## loop through each element of ${Token Array}
  foreach($token in ${Token Array})
  {
    ## If a token is of type 'Command', load the command's character sequence in ${Token of type Command}
    if ($token.Type -eq "Command") {${Token of type Command} = $token.Content}
    #            ${Token Array} | ? {$_.Type -eq 'Command'}

    ## However, if a token is of type 'CommandParameter', start looking for aliases. 
    if (
      # If token type = CommandParameter  AND a token of type Command already passed thru the loop...
      ($token.Type -eq "CommandParameter") -and (${Token of type Command}) 
    #            ${Token Array} | ? {$_.Type -eq 'CommandParameter'}
    )
    {
      # Then isolate the content of that CommandParameter token into the $currentParameter variable. 
      $currentParameter = $token.Content
      # Next, because we're only interested in the parameter name, remove the leading "-" from $currentParameter
      $currentParameter = $currentParameter.TrimStart("-")

      # Determine all of the parameters for the current command.
      ${Parameter Set} = (Get-Command ${Token of type Command}).Parameters.GetEnumerator()
      # (Get-Command ${Token of type Command}).Parameters.GetEnumerator() |

      ## For parameters that start with the current parameter name,
      ${Whole Parameter Name(s)} = ${Parameter Set} | Where-Object -FilterScript { $_.Key -like "$currentParameter*" }
      # Where-Object -FilterScript { $_.Key -like "$currentParameter*" } |

      # return all of the aliases that apply. We use "starts with" because the user might have typed a shortened form of the parameter name.
      ${Whole Parameter Name(s)} | ForEach-Object {
                          $_.Value.Aliases | ForEach-Object {
                            ${Here you go, fuckface} = "${Token of type Command}" + "|$currentParameter `b: `b$_"
                            write-host "${Here you go, fuckface}" -ForegroundColor DarkBlue
                          }
      }
    }
  };
'@
${Reveal Parameter AliasesV2} = [ScriptBlock]::Create(${Reveal Parameter AliasesV2 Here-String})
#endregion
#region | Enable-HistoryPersistence (if not in a remote session) |
try {
  Get-Process -Name 'wsmprovhost' -ErrorAction 'Stop' | Out-Null
} 
catch {
  $ScriptName = 'Enable-HistoryPersistence.ps1'; if (Test-Path -Path ".\$ScriptName") {& $ScriptName}
}
#endregion
#region | Automatically Capture Pipeline Output Without Explicit Variable Definition |
# leads to endless looping errors --> $PSDefaultParameterValues.Add("Out-Default:OutVariable","__")
$PSDefaultParameterValues['Out-Default:OutVariable'] = "__"
#endregion
#endregion
#######################################################################
#endregion

