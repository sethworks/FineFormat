function Format-Fine
{
    Param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        $InputObject,
        [switch]$NotNullOrEmpty,
        [switch]$NullOrEmpty,
        [switch]$Numeric,
        [switch]$Textual
    )

    process
    {
        foreach ($io in $InputObject)
        {
            # default
            if (-not $NotNullOrEmpty -and -not $NullOrEmpty -and -not $Numeric -and -not $Textual)
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

                     ($Textual -and $p.TypeNameOfValue -notmatch '^System\.string$|^string$|^System\.Char$|^char$')
                )
                {
                    continue
                }

<#
                # NotNullOrEmpty
                if ($NotNullOrEmpty -and ([string]::IsNullOrEmpty($p.Value)))
                {
                    continue
                }

                # NullOrEmpty
                if ($NullOrEmpty -and -not [string]::IsNullOrEmpty($p.Value))
                {
                    continue
                }

                # Numeric
                if ($Numeric -and $p.TypeNameOfValue -notmatch '^System\.(U)?Int(\d\d)?$|^System\.Single$|^System\.Double$|^System\.Decimal$|^(u)?short$|^(u)?int$|^(u)?long$')
                {
                    continue
                }
#>

                $hash.Add($p.Name, $p.Value)
            }
            [PSCustomObject]$hash

<#
            # NotNullOrEmpty
            if ($NotNullOrEmpty)
            {
                $hash = [ordered]@{}
                foreach ($p in $io.PSObject.Properties)
                {
                    if ( -not [string]::IsNullOrEmpty($p.Value) )
                    {
                        $hash.Add($p.Name, $p.Value)
                    }
                }
                [PSCustomObject]$hash
            }

            # NullOrEmpty
            if ($NullOrEmpty)
            {
                $hash = [ordered]@{}
                foreach ($p in $io.PSObject.Properties)
                {
                    if ( [string]::IsNullOrEmpty($p.Value) )
                    {
                        $hash.Add($p.Name, $p.Value)
                    }
                }
                [PSCustomObject]$hash
            }

            # Numeric
            if ($Numeric)
            {
                $hash = [ordered]@{}
                foreach ($p in $io.PSObject.Properties)
                {
                    if ($p.TypeNameOfValue -match '^System\.(U)?Int(\d\d)?$|^System\.Single$|^System\.Double$|^System\.Decimal$|^(u)?short$|^(u)?int$|^(u)?long$')
                    {
                        $hash.Add($p.Name, $p.Value)
                    }
                }
                [PSCustomObject]$hash
            }
#>
        }
    }
}

