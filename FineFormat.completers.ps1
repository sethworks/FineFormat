using namespace System.Management.Automation
using namespace System.Management.Automation.Language
using namespace System.Collections
using namespace System.Collections.Generic

class PossibleValues
{
    [string]$Original
    [string]$Escaped

    PossibleValues($in)
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
        $possibleValues = New-Object -TypeName 'List[PossibleValues]'
        $TypeNameOfValue = @()
        $valuesAst = @()
        [string]$command = ""

        # Format-Fine -InputObject $ObjectArray -TypeName ...
        if ($inputObjectParameterAst = $commandAst.Find({$args[0].GetType().Name -eq 'CommandParameterAst' -and $args[0].ParameterName -eq 'InputObject'}, $false))
        {
            $inputObjectParameterValueAst = $commandAst.CommandElements[$commandAst.CommandElements.IndexOf($inputObjectParameterAst) + 1]

            if ($inputObjectParameterValueAst.GetType().Name -ne 'CommandParameterAst')
            {
                $command = $inputObjectParameterValueAst.Extent.Text
            }
        }

        # Get-SomeObjects | Format-Fine -TypeName ...
        elseif ($i = $commandAst.Parent.PipelineElements.IndexOf($commandAst))
        {
            $endOffset = $commandAst.Parent.PipelineElements[$i-1].Extent.EndOffset
            $startOffset = $commandAst.Parent.PipelineElements[$i-1].Extent.StartOffset

            $command = $commandAst.Parent.Extent.Text.Substring(0, $endOffset-$startOffset)
        }

        if ($command)
        {
            $TypeNameOfValue = [scriptblock]::Create($command).Invoke() | ForEach-Object {$_.psobject.Properties.TypeNameOfValue} | Sort-Object | Get-Unique
        }

        $possibleValues = $TypeNameOfValue | ForEach-Object { [PossibleValues]::new($_) }
        
        $commandParameterAst = $commandAst.Find({$args[0].GetType().Name -eq 'CommandParameterAst' -and $args[0].ParameterName -eq $parameterName}, $false)
        
        if ($commandParameterValueAst = $commandAst.CommandElements[$commandAst.CommandElements.IndexOf($commandParameterAst)+1])
        {
            # -TypeName one, two<Tab>
            if ($commandParameterValueAst.GetType().Name -eq 'ArrayLiteralAst')
            {
                $valuesAst = $commandParameterValueAst.Elements[0..($commandParameterValueAst.Elements.Count - 2)]
            }
            # -TypeName one, <Tab>
            elseif ($commandParameterValueAst.GetType().Name -eq 'ErrorExpressionAst')
            {
                $valuesAst = $commandParameterValueAst.NestedAst
            }
            # -TypeName one<Tab> case doesn't need to be processed, because there is nothing to exclude

            foreach ($va in $valuesAst)
            {
                # -TypeName one, 
                if ($va.StringConstantType -eq 'BareWord')
                {
                    $valuesToExclude.Add($va.SafeGetValue())
                }
                # -TypeName 'one', 
                elseif ($va.StringConstantType -eq 'SingleQuoted')
                {
                    $valuesToExclude.Add("'$($va.SafeGetValue())'")
                }
            }
        }

        foreach ($pv in $possibleValues)
        {
            if ( ($pv.Escaped -like "$wordToComplete*" -or $pv.Escaped -like "'$wordToComplete*") -and $pv.Escaped -notin $valuesToExclude )
            {
                $result.Add([CompletionResult]::new($pv.Escaped, $pv.Original, [CompletionResultType]::ParameterValue, $pv.Original))
            }
        }

        return $result
    }
}
