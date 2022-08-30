using namespace System.Management.Automation
using namespace System.Management.Automation.Language
using namespace System.Collections
using namespace System.Collections.Generic


class Values
{
    [string]$Original
    [string]$Escaped

    Values($in)
    {
        $this.Original = $in
        if ($in -match '[`\[\]]')
        {
            $this.Escaped = $in -replace '[`\[\]]', '`$0'
            $this.Escaped = $this.Escaped.Insert($this.Escaped.Length, "'").Insert(0, "'")
        }
        else
        {
            $this.Escaped = $this.Original
        }
    }
}

class TypeNameCompleter : IArgumentCompleter
{
    [IEnumerable[CompletionResult]] CompleteArgument(
        [string] $commandName, 
        [string] $parameterName,
        [string] $wordToComplete,
        [CommandAst] $commandAst,
        [IDictionary] $fakeBoundParameters
    )
    {
        $result = New-Object -TypeName 'List[CompletionResult]'
        $valuesToExclude = New-Object -TypeName 'List[String]'
        # $valuesToExclude = New-Object -TypeName 'List[Values]'
        # [List[String]]$valuesToExclude = $null
        $TypeNameOfValue = @()
        $valuesAst = @()
        [Values[]]$Values = $null

        if ($i = $commandAst.Parent.PipelineElements.IndexOf($commandAst))
        {
            $endOffset = $commandAst.Parent.PipelineElements[$i-1].Extent.EndOffset
            $command = $commandAst.Parent.Extent.Text.Substring(0, $endOffset)
            # $objects = [scriptblock]::Create($command).Invoke()
            $TypeNameOfValue = [scriptblock]::Create($command).Invoke() | ForEach-Object {$_.psobject.Properties.TypeNameOfValue} | Sort-Object | Get-Unique
            $Values = $TypeNameOfValue | ForEach-Object { [Values]::new($_) }
        }
        
        $commandParameterAst = $commandAst.Find({$args[0].GetType().Name -eq 'CommandParameterAst' -and $args[0].ParameterName -eq $parameterName}, $false)
        
        if ($commandParameterValueAst = $commandAst.CommandElements[$commandAst.CommandElements.IndexOf($commandParameterAst)+1])
        {
            if ($commandParameterValueAst.GetType().Name -eq 'ArrayLiteralAst')
            {
                $valuesAst = $commandParameterValueAst.Elements
            }
            elseif ($commandParameterValueAst.GetType().Name -eq 'ErrorExpressionAst')
            {
                $valuesAst = $commandParameterValueAst.NestedAst
            }
            elseif ($commandParameterValueAst.GetType().Name -eq 'StringConstantExpressionAst')
            {
                $valuesAst = $commandParameterValueAst
            }
    
            if ($valuesAst)
            {
                foreach ($va in $valuesAst)
                {
                    if ($va.StringConstantType -eq 'BareWord')
                    {
                        $valuesToExclude.Add($va.SafeGetValue())
                    }
                    elseif ($va.StringConstantType -eq 'SingleQuoted')
                    {
                        $valuesToExclude.Add("'$($va.SafeGetValue())'")
                    }
                }
                # $valuesToExclude = $valuesAst | ForEach-Object {$_.SafeGetValue()}

                # $valuesToExclude = $valuesAst | ForEach-Object { [Values]::new($_.SafeGetValue()) }
    
                # if ($wordToComplete)
                # {
                #     $valuesToExclude.Remove($wordToComplete)
                # }
            }
        }

        # foreach ($t in $TypeNameOfValue)
        foreach ($t in $Values)
        {
            if ( ($t.Escaped -like "$wordToComplete*" -or $t.Escaped -like "'$wordToComplete*") -and $t.Escaped -notin $valuesToExclude )
            {
                <#
                if ($t -match '[`\[\]]')
                {
                    $escape = $t -replace '[`\[\]]', '`$0'
                    $escape = $escape.Insert($escape.Length, "'").Insert(0, "'")
                    $result.Add([CompletionResult]::new($escape, $t, [CompletionResultType]::ParameterValue, $t))
                }
                else
                {
                    $result.Add([CompletionResult]::new($t, $t, [CompletionResultType]::ParameterValue, $t))
                }
                #>
                $result.Add([CompletionResult]::new($t.Escaped, $t.Original, [CompletionResultType]::ParameterValue, $t.Original))
            }
        }

        # $result.Add([CompletionResult]::new('completionText', 'listItemText', [CompletionResultType]::ParameterValue, 'tooltip'))

        return $result
    }
}
