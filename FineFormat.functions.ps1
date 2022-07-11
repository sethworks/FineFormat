function Format-Fine
{
    Param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        $InputObject,
        [switch]$NotNullOrEmpty,
        [switch]$NullOrEmpty,
        [switch]$Numeric,
        [switch]$Textual,
        [scriptblock]$ValueFilter,
        [scriptblock]$TypeNameFilter
    )

    process
    {
        foreach ($io in $InputObject)
        {
            # default
            if (-not $NotNullOrEmpty -and -not $NullOrEmpty -and -not $Numeric -and -not $Textual -and -not $ValueFilter -and -not $TypeNameFilter)
            {
                $io
                continue
            }

            $hash = [ordered]@{}
            $t = $ValueFilter.Ast.EndBlock.Extent.Text
            foreach ($p in $io.PSObject.Properties)
            {
                if ( ($NotNullOrEmpty -and ([string]::IsNullOrEmpty($p.Value))) -or

                     ($NullOrEmpty -and -not [string]::IsNullOrEmpty($p.Value)) -or

                     ($Numeric -and $p.TypeNameOfValue -notmatch '^System\.(U)?Int(\d\d)?$|^System\.Single$|^System\.Double$|^System\.Decimal$|^(u)?short$|^(u)?int$|^(u)?long$') -or

                     ($Textual -and $p.TypeNameOfValue -notmatch '^System\.string$|^string$|^System\.Char$|^char$') -or

                    #  !($ValueFilter -and ($p.Value | Where-Object -FilterScript $([scriptblock]::Create($t)))) #-or
                     ($ValueFilter -and -not ($p.Value | Where-Object -FilterScript $ValueFilter)) -or

                     ($TypeNameFilter -and -not ($p.TypeNameOfValue | Where-Object -FilterScript $TypeNameFilter))
                     )
                {
                    continue
                }
                # if (!( $ValueFilter -and $p.Value | Where-Object -FilterScript $ValueFilter ))
                # if (!($ValueFilter -and ($p.Value | Where-Object -FilterScript $([scriptblock]::Create($t)))))
                # {
                    # continue
                    # $hash.Add($p.Name, $p.Value)
                # }
                $hash.Add($p.Name, $p.Value)
            }
            [PSCustomObject]$hash
        }
    }
}

