using namespace System.Management.Automation
using namespace System.Management.Automation.Language
using namespace System.Collections
using namespace System.Collections.Generic

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
        # [List[String]]$valuesToExclude = $null
        $TypeNameOfValue = @()
        $valuesAst = @()

        if ($i = $commandAst.Parent.PipelineElements.IndexOf($commandAst))
        {
            $endOffset = $commandAst.Parent.PipelineElements[$i-1].Extent.EndOffset
            $command = $commandAst.Parent.Extent.Text.Substring(0, $endOffset)
            # $objects = [scriptblock]::Create($command).Invoke()
            $TypeNameOfValue = [scriptblock]::Create($command).Invoke() | ForEach-Object {$_.psobject.Properties.TypeNameOfValue} | Sort-Object | Get-Unique
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
    
            if ($valuesAst)
            {
                $valuesToExclude = $valuesAst | ForEach-Object {$_.SafeGetValue()}
    
                if ($wordToComplete)
                {
                    $valuesToExclude.Remove($wordToComplete)
                }
            }
        }

        foreach ($t in $TypeNameOfValue)
        {
            if ($t -like "$wordToComplete*" -and $t -notin $valuesToExclude)
            {
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
            }
        }

        # $result.Add([CompletionResult]::new('completionText', 'listItemText', [CompletionResultType]::ParameterValue, 'tooltip'))

        return $result
    }
}