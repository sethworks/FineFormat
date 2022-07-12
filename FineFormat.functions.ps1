$NumbersAsValues = @('KB', 'MB', 'GB', 'TB', 'PB')
$NumericTypesExpression = '^System\.(U)?Int(\d\d)?$|^System\.Single$|^System\.Double$|^System\.Decimal$|^(u)?short$|^(u)?int$|^(u)?long$'
$SymbolicTypesExpression = '^System\.string$|^string$|^System\.Char$|^char$'
$ExcludePropertiesExpression = '^CimClass$|^CimInstanceProperties$|^CimSystemProperties$' # Gets in the way of values comparison when using -ValueFilter parameter

function Format-Fine
{
    Param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        $InputObject,
        [Alias('HaveValue','NotNullOrEmpty')]
        [switch]$HasValue,
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
    }
    process
    {
        foreach ($io in $InputObject)
        {
            # default
            if (-not ($HasValue -or
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

                     ($ValueFilter -and ($p.Name -match $ExcludePropertiesExpression -or -not ($p.Value | Where-Object -FilterScript $ValueFilter))) -or

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
                    $value = $p.Value
                    if ([Math]::Floor($value / 1KB))
                    {
                        $value /= 1KB
                        $i = 0
                        while ([Math]::Floor($value / 1KB))
                        {
                            $value /= 1KB
                            $i++
                            if ($i -eq 4)
                            {
                                break
                            }
                        }
                        $template += " $($NumbersAsValues[$i])"
                    }
                    $hash.Add($p.Name, $template -f $value)
                }
                elseif ($NumbersAs -in $NumbersAsValues -and $p.TypeNameOfValue -match $NumericTypesExpression)
                {
                    $value = $p.Value

                    if ($NumbersAs -eq 'KB' -and $p.Value -ge 1KB)
                    {
                        $template += " KB"
                        $value /= 1KB
                    }
                    elseif ($NumbersAs -eq 'MB' -and $p.Value -ge 1MB)
                    {
                        $template += " MB"
                        $value /= 1MB
                    }
                    elseif ($NumbersAs -eq 'GB' -and $p.Value -ge 1GB)
                    {
                        $template += " GB"
                        $value /= 1GB
                    }
                    elseif ($NumbersAs -eq 'TB' -and $p.Value -ge 1TB)
                    {
                        $template += " TB"
                        $value /= 1TB
                    }
                    elseif ($NumbersAs -eq 'PB' -and $p.Value -ge 1PB)
                    {
                        $template += " PB"
                        $value /= 1PB
                    }
                    $hash.Add($p.Name, $template -f $value)

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
