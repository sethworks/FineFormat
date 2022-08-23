$NumbersAsValues = @('KB', 'MB', 'GB', 'TB', 'PB')
$NumericTypesExpression = '^System\.(U)?Int(\d\d)?$|^System\.Single$|^System\.Double$|^System\.Decimal$|^(u)?short$|^(u)?int$|^(u)?long$'
$SymbolicTypesExpression = '^System\.string$|^string$|^System\.Char$|^char$'
$ComparisonOperatorTokens = @('Ige', 'Cge', 'Igt', 'Cgt', 'Ile', 'Cle', 'Ilt', 'Clt')
function Format-Fine
{
    Param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        $InputObject,
        [Alias('HaveValue','NotNullOrEmpty')]
        [switch]$HasValue,
        [psobject[]]$Value,
        [switch]$CompactNumbers,
        [switch]$NumberGroupSeparator,
        [Alias('NullOrEmpty')]
        [switch]$NoValue,
        [ArgumentCompletions('KB', 'MB', 'GB', 'TB', 'PB')]
        [string]$NumbersAs,
        [switch]$NumericTypes,
        [switch]$SymbolicTypes,
        [scriptblock]$ValueFilter,
        [scriptblock]$TypeNameFilter
    )
    begin
    {
        if ($NumbersAs -and $NumbersAs -notin $NumbersAsValues)
        {
            Write-Warning -Message "-NumbersAs parameter accepts only 'KB', 'MB', 'GB', 'TB', or 'PB' values."
        }

        # $PSBoundParameters.Keys -contains 'Value' is used because $Value can be equal to $false
        if ($PSBoundParameters.Keys -contains 'Value' -or $ValueFilter)
        {
            # is used for excluding properties with empty values, including empty arrays, for example @()
            $HasValue = $true
        }

        if ($ValueFilter)
        {
            $ComparisonOperator = $false
            $BinaryExpressionAstOperators = $ValueFilter.Ast.FindAll({$args[0] -is [System.Management.Automation.Language.BinaryExpressionAst]}, $true).Operator
            if ($BinaryExpressionAstOperators)
            {
                foreach ($op in $BinaryExpressionAstOperators)
                {
                    if ($op -in $ComparisonOperatorTokens)
                    {
                        # used as a flag to exclude properties, whose value types don't support comparison, i.e. haven't implemented IComparable interface.
                        $ComparisonOperator = $true
                        break
                    }
                }
            }
        }
    }
    process
    {
        foreach ($io in $InputObject)
        {
            # default
            if (-not ($HasValue -or
                      $PSBoundParameters.Keys -contains 'Value' -or  # -Value can be equal to $false
                      $TypeName -or
                      $CompactNumbers -or
                      $NumberGroupSeparator -or
                      $NoValue -or
                      $NumbersAs -or
                      $NumericTypes -or
                      $SymbolicTypes -or
                      $ValueFilter -or
                      $TypeNameFilter) )
            {
                $io
                continue
            }

            $hash = [ordered]@{}
            foreach ($p in $io.PSObject.Properties)
            {
                if ( ($HasValue -and ([string]::IsNullOrEmpty($p.Value))) -or

                     ($NoValue -and -not [string]::IsNullOrEmpty($p.Value)) -or

                     ($NumericTypes -and $p.TypeNameOfValue -notmatch $NumericTypesExpression) -or

                     ($SymbolicTypes -and $p.TypeNameOfValue -notmatch $SymbolicTypesExpression) -or

                     # $PSBoundParameters.Keys -contains 'Value' is used because $Value can be $false
                     ($PSBoundParameters.Keys -contains 'Value' -and ( inTestValue -pvl $p.Value -vl $Value ) ) -or 

                     ($ValueFilter -and
                           # exclude properties, whose value types don't support comparison, i.e. haven't implemented IComparable interface.
                         ( ($ComparisonOperator -and $p.Value.GetType().ImplementedInterfaces.Name -notcontains 'IComparable') -or
                           -not ($p.Value | Where-Object -FilterScript $ValueFilter) ) ) -or

                     ($TypeNameFilter -and -not ($p.TypeNameOfValue | Where-Object -FilterScript $TypeNameFilter)) )
                {
                    continue
                }

                if ($NumberGroupSeparator)
                {
                    $template = "{0:#,0.##}"
                }
                elseif ($NumbersAs -or $CompactNumbers)
                {
                    $template = "{0:0.##}"
                }

                if ($CompactNumbers)
                {
                    $pvalue = $p.Value
                    if ([Math]::Truncate($pvalue / 1KB))
                    {
                        $pvalue /= 1KB
                        $i = 0
                        while ([Math]::Truncate($pvalue / 1KB))
                        {
                            $pvalue /= 1KB
                            $i++
                            if ($i -eq 4)
                            {
                                break
                            }
                        }
                        $template += " $($NumbersAsValues[$i])"
                    }
                    $hash.Add($p.Name, $template -f $pvalue)
                }
                elseif ($NumbersAs -in $NumbersAsValues -and $p.TypeNameOfValue -match $NumericTypesExpression)
                {
                    $pvalue = $p.Value

                    if ($NumbersAs -eq 'KB' -and $p.Value -ge 1KB)
                    {
                        $template += " KB"
                        $pvalue /= 1KB
                    }
                    elseif ($NumbersAs -eq 'MB' -and $p.Value -ge 1MB)
                    {
                        $template += " MB"
                        $pvalue /= 1MB
                    }
                    elseif ($NumbersAs -eq 'GB' -and $p.Value -ge 1GB)
                    {
                        $template += " GB"
                        $pvalue /= 1GB
                    }
                    elseif ($NumbersAs -eq 'TB' -and $p.Value -ge 1TB)
                    {
                        $template += " TB"
                        $pvalue /= 1TB
                    }
                    elseif ($NumbersAs -eq 'PB' -and $p.Value -ge 1PB)
                    {
                        $template += " PB"
                        $pvalue /= 1PB
                    }
                    $hash.Add($p.Name, $template -f $pvalue)

                }
                elseif ($NumberGroupSeparator -and $p.TypeNameOfValue -match $NumericTypesExpression)
                {
                    $hash.Add($p.Name, $template -f $p.Value)
                }
                else
                {
                    $hash.Add($p.Name, $p.Value)
                }
            }
            [PSCustomObject]$hash
        }
    }
}

function inTestValue
{
    Param (
        [psobject]$pvl,
        [psobject]$vls
    )   

    foreach ($vl in $vls)
    {
        if ($pvl -like $vl)
        {
            return $false
            break
        }
    }
    return $true
}
