function Format-Fine
{
    Param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        $InputObject,
        [switch]$NotNullOrEmpty,
        [switch]$NullOrEmpty
    )

    process
    {
        foreach ($io in $InputObject)
        {
            # default
            if (-not $NotNullOrEmpty -and -not $NullOrEmpty)
            {
                $io
                continue
            }

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
        }
    }
}

