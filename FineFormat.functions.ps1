enum prefix
{
    KB = 0
    MB = 1
    GB = 2
    TB = 3
    PB = 4
}

$NumbersAsValues = @('KB', 'MB', 'GB', 'TB', 'PB', 'Max')
function Format-Fine
{
    Param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        $InputObject,
        [Alias('HaveValue')]
        [switch]$NotNullOrEmpty,
        [switch]$NullOrEmpty,
        [switch]$Numeric,
        [switch]$Textual,
        [scriptblock]$ValueFilter,
        [scriptblock]$TypeNameFilter,
        [switch]$NumberGroupSeparator,
        # [ValidateSet('KB', 'MB', 'GB', 'TB', 'PB')]
        # [ArgumentCompletions($NumbersAsValues)]
        [ArgumentCompletions('KB', 'MB', 'GB', 'TB', 'PB', 'Max')]
        [string]$NumbersAs
    )
    begin
    {
        if ($NumbersAs -and $NumbersAs -notin $NumbersAsValues)
        {
            Write-Verbose -Message "-NumbersAs parameter accepts only 'KB', 'MB', 'GB', 'TB', 'PB', or 'Max' values." -Verbose
        }
    }
    process
    {
        foreach ($io in $InputObject)
        {
            # default
            if (-not $NotNullOrEmpty -and -not $NullOrEmpty -and -not $Numeric -and -not $Textual -and -not $ValueFilter -and -not $TypeNameFilter -and -not $NumberGroupSeparator -and -not $NumbersAs)
            {
                $io
                continue
            }

            $hash = [ordered]@{}
            foreach ($p in $io.PSObject.Properties)
            {
                if ( ($NotNullOrEmpty -and ([string]::IsNullOrEmpty($p.Value))) -or

                     ($NullOrEmpty -and -not [string]::IsNullOrEmpty($p.Value)) -or

                     ($Numeric -and $p.TypeNameOfValue -notmatch '^System\.(U)?Int(\d\d)?$|^System\.Single$|^System\.Double$|^System\.Decimal$|^(u)?short$|^(u)?int$|^(u)?long$') -or

                     ($Textual -and $p.TypeNameOfValue -notmatch '^System\.string$|^string$|^System\.Char$|^char$') -or

                    #  ($ValueFilter -and -not ($p.Value | Where-Object -FilterScript $ValueFilter)) -or
                     ($ValueFilter -and ($p.Name -match '^CimClass$|^CimInstanceProperties$|^CimSystemProperties$' -or -not ($p.Value | Where-Object -FilterScript $ValueFilter))) -or

                     ($TypeNameFilter -and -not ($p.TypeNameOfValue | Where-Object -FilterScript $TypeNameFilter))
                   )
                {
                    continue
                }

                if ($NumberGroupSeparator)
                {
                    $template = "{0:#,0.##}"
                }
                elseif ($NumbersAs)
                {
                    $template = "{0:0.##}"
                }

                if ($NumbersAs -in @('KB', 'MB', 'GB', 'TB', 'PB', 'Max') -and $p.TypeNameOfValue -match '^System\.(U)?Int(\d\d)?$|^System\.Single$|^System\.Double$|^System\.Decimal$|^(u)?short$|^(u)?int$|^(u)?long$')
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
                    elseif ($NumbersAs -eq 'Max')
                    {
                        if ([Math]::Floor($value / 1KB))
                        {
                            $value /= 1KB
                            $i = 0

                            while ([Math]::Floor($value / 1KB))
                            {
                                $value /= 1KB
                                $i++
                            }
                            $template += " $($NumbersAsValues[$i])"
                        }
                    }
                    $hash.Add($p.Name, $template -f $value)

                }
                # elseif ($NumberGroupSeparator -and $p.TypeNameOfValue -match '^System\.(U)?Int(\d\d)?$|^System\.Single$|^System\.Double$|^System\.Decimal$|^(u)?short$|^(u)?int$|^(u)?long$' -and [Math]::Floor($p.Value/1000))
                elseif ($NumberGroupSeparator -and $p.TypeNameOfValue -match '^System\.(U)?Int(\d\d)?$|^System\.Single$|^System\.Double$|^System\.Decimal$|^(u)?short$|^(u)?int$|^(u)?long$')
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

