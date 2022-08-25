$Units = @('KB', 'MB', 'GB', 'TB', 'PB')
$UnitsString = @('', ' KB', ' MB', ' GB', ' TB', ' PB')
$NumericTypesExpression = '^System\.(U)?Int(\d\d)?$|^System\.Single$|^System\.Double$|^System\.Decimal$|^(u)?short$|^(u)?int$|^(u)?long$'
$SymbolicTypesExpression = '^System\.string$|^string$|^System\.Char$|^char$'
$ComparisonOperatorTokens = @('Ige', 'Cge', 'Igt', 'Cgt', 'Ile', 'Cle', 'Ilt', 'Clt')
function Format-Fine
{
    [CmdletBinding(DefaultParameterSetName='Default')]
    Param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        $InputObject,

        [Parameter(ParameterSetName='Default')]
        [Alias('HaveValue','NotNullOrEmpty')]
        [switch]$HasValue,

        [Parameter(ParameterSetName='Default')]
        [psobject[]]$Value,

        [string[]]$TypeName,

        [Parameter(ParameterSetName='Default')]
        [switch]$CompactNumbers,

        [Parameter(ParameterSetName='Default')]
        [switch]$NumberGroupSeparator,

        [Parameter(ParameterSetName='NoValue')]
        [Alias('NullOrEmpty')]
        [switch]$NoValue,

        [Parameter(ParameterSetName='Default')]
        [ArgumentCompletions('KB', 'MB', 'GB', 'TB', 'PB')]
        [string]$NumbersAs,

        [switch]$NumericTypes,

        [switch]$SymbolicTypes,

        [Parameter(ParameterSetName='Default')]
        [scriptblock]$ValueFilter,

        [scriptblock]$TypeNameFilter
    )
    begin
    {
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
            $NoParameters = $true
        }

        else
        {
            if ($NumbersAs -and $NumbersAs -notin $Units)
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

            if ($NumberGroupSeparator)
            {
                $template = "{0:#,0.##}"
            }
            elseif ($NumbersAs -or $CompactNumbers)
            {
                $template = "{0:0.##}"
            }
        }
    }
    process
    {
        foreach ($io in $InputObject)
        {
            if ($NoParameters)
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
                     ($PSBoundParameters.Keys -contains 'Value' -and ( inTestValue -pvl $p.Value -vls $Value ) ) -or 

                     ($TypeName -and ( inTestTypeName -ptn $p.TypeNameOfValue -tns $TypeName ) ) -or

                     ($ValueFilter -and
                           # exclude properties, whose value types don't support comparison, i.e. haven't implemented IComparable interface.
                         ( ($ComparisonOperator -and $p.Value.GetType().ImplementedInterfaces.Name -notcontains 'IComparable') -or
                           -not ($p.Value | Where-Object -FilterScript $ValueFilter) ) ) -or

                     ($TypeNameFilter -and -not ($p.TypeNameOfValue | Where-Object -FilterScript $TypeNameFilter)) )
                {
                    continue
                }

                if ($CompactNumbers)
                {
                    $pvalue = $p.Value
                    # if ([Math]::Truncate($pvalue / 1KB))
                    if ([double]::TryParse($pvalue, [ref]$null))
                    {
                        $i = 0
                        # if ([Math]::Truncate($pvalue / 1KB))
                        # {
                            # $pvalue /= 1KB
                            while ([Math]::Truncate($pvalue / 1KB))
                            {
                                $pvalue /= 1KB
                                $i++
                                if ($i -eq 5)
                                {
                                    break
                                }
                            }
                            # $template += " $($Units[$i])"
                            $hash.Add($p.Name, "$($template -f $pvalue)$($UnitsString[$i])")
                        # }
                        # else
                        # {
                        #     $hash.Add($p.Name, $template -f $pvalue)
                        # }
                    }
                    else
                    {
                        $hash.Add($p.Name, $p.Value)
                    }
                }
                elseif ($NumbersAs -in $Units -and $p.TypeNameOfValue -match $NumericTypesExpression)
                {
                    $pvalue = $p.Value
                    $i = 0
                    if ($NumbersAs -eq 'KB' -and $p.Value -ge 1KB)
                    {
                        # $template += " KB"
                        # $suffix = " KB"
                        $pvalue /= 1KB
                        $i = 1
                    }
                    elseif ($NumbersAs -eq 'MB' -and $p.Value -ge 1MB)
                    {
                        # $template += " MB"
                        # $suffix = " MB"
                        $pvalue /= 1MB
                        $i = 2
                    }
                    elseif ($NumbersAs -eq 'GB' -and $p.Value -ge 1GB)
                    {
                        # $template += " GB"
                        # $suffix = " GB"
                        $pvalue /= 1GB
                        $i = 3
                    }
                    elseif ($NumbersAs -eq 'TB' -and $p.Value -ge 1TB)
                    {
                        # $template += " TB"
                        # $suffix = " TB"
                        $pvalue /= 1TB
                        $i = 4
                    }
                    elseif ($NumbersAs -eq 'PB' -and $p.Value -ge 1PB)
                    {
                        # $template += " PB"
                        # $suffix = " PB"
                        $pvalue /= 1PB
                        $i = 5
                    }
                    # else
                    # {
                    #     $suffix = ""
                    # }
                    # $hash.Add($p.Name, "$($template -f $pvalue)$suffix")
                    $hash.Add($p.Name, "$($template -f $pvalue)$($UnitsString[$i])")

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

function inTestTypeName
{
    Param (
        [string]$ptn,
        [string[]]$tns
    )

    foreach ($tn in $tns)
    {
        if ($ptn -like $tn)
        {
            return $false
            break
        }
    }
    return $true
}
