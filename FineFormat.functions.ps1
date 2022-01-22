function Format-Fine
{
    Param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true)]
        $InputObject,
        [switch]$NotNullOrEmpty
    )

    process
    {
        foreach ($io in $InputObject)
        {
            # default
            if (-not $NotNullOrEmpty)
            {
                $io
            }

            # NotNullOrEmpty
            elseif ($NotNullOrEmpty)
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
        }
    }
}

