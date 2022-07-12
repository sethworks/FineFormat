$NumbersAsValues = @('KB', 'MB', 'GB', 'TB', 'PB')
$NumbersExpression = '^System\.(U)?Int(\d\d)?$|^System\.Single$|^System\.Double$|^System\.Decimal$|^(u)?short$|^(u)?int$|^(u)?long$'
$TextExpression = '^System\.string$|^string$|^System\.Char$|^char$'
$ExcludePropertiesExpression = '^CimClass$|^CimInstanceProperties$|^CimSystemProperties$' # Gets in the way of values comparison when using -ValueFilter parameter

function Format-Fine
{
    Param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        $InputObject,
        [Alias('NotNullOrEmpty')]
        [switch]$HaveValue,
        [switch]$CompactNumbers,
        [switch]$NullOrEmpty,
        [switch]$Numeric,
        [switch]$Textual,
        [scriptblock]$ValueFilter,
        [scriptblock]$TypeNameFilter,
        [switch]$NumberGroupSeparator,
        # [ValidateSet('KB', 'MB', 'GB', 'TB', 'PB')]
        # [ArgumentCompletions($NumbersAsValues)]
        [ArgumentCompletions('KB', 'MB', 'GB', 'TB', 'PB')]
        [string]$NumbersAs
    )
    begin
    {
        if ($NumbersAs -and $NumbersAs -notin $NumbersAsValues)
        {
            Write-Verbose -Message "-NumbersAs parameter accepts only 'KB', 'MB', 'GB', 'TB', or 'PB' values." -Verbose
        }
    }
    process
    {
        foreach ($io in $InputObject)
        {
            # default
            if (-not $HaveValue -and -not $CompactNumbers -and -not $NullOrEmpty -and -not $Numeric -and -not $Textual -and -not $ValueFilter -and -not $TypeNameFilter -and -not $NumberGroupSeparator -and -not $NumbersAs)
            {
                $io
                continue
            }

            $hash = [ordered]@{}
            foreach ($p in $io.PSObject.Properties)
            {
                if ( ($HaveValue -and ([string]::IsNullOrEmpty($p.Value))) -or

                     ($NullOrEmpty -and -not [string]::IsNullOrEmpty($p.Value)) -or

                    #  ($Numeric -and $p.TypeNameOfValue -notmatch '^System\.(U)?Int(\d\d)?$|^System\.Single$|^System\.Double$|^System\.Decimal$|^(u)?short$|^(u)?int$|^(u)?long$') -or
                     ($Numeric -and $p.TypeNameOfValue -notmatch $NumbersExpression) -or

                    #  ($Textual -and $p.TypeNameOfValue -notmatch '^System\.string$|^string$|^System\.Char$|^char$') -or
                     ($Textual -and $p.TypeNameOfValue -notmatch $TextExpression) -or

                    #  ($ValueFilter -and -not ($p.Value | Where-Object -FilterScript $ValueFilter)) -or
                    #  ($ValueFilter -and ($p.Name -match '^CimClass$|^CimInstanceProperties$|^CimSystemProperties$' -or -not ($p.Value | Where-Object -FilterScript $ValueFilter))) -or
                     ($ValueFilter -and ($p.Name -match $ExcludePropertiesExpression -or -not ($p.Value | Where-Object -FilterScript $ValueFilter))) -or

                     ($TypeNameFilter -and -not ($p.TypeNameOfValue | Where-Object -FilterScript $TypeNameFilter))
                   )
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
                # elseif ($NumbersAs -in $NumbersAsValues -and $p.TypeNameOfValue -match '^System\.(U)?Int(\d\d)?$|^System\.Single$|^System\.Double$|^System\.Decimal$|^(u)?short$|^(u)?int$|^(u)?long$')
                elseif ($NumbersAs -in $NumbersAsValues -and $p.TypeNameOfValue -match $NumbersExpression)
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
                # elseif ($NumberGroupSeparator -and $p.TypeNameOfValue -match '^System\.(U)?Int(\d\d)?$|^System\.Single$|^System\.Double$|^System\.Decimal$|^(u)?short$|^(u)?int$|^(u)?long$' -and [Math]::Floor($p.Value/1000))
                elseif ($NumberGroupSeparator -and $p.TypeNameOfValue -match $NumbersExpression)
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

