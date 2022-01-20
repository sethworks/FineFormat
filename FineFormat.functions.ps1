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

            elseif ($NotNullOrEmpty)
            {
                $hash = [ordered]@{}
                foreach ($p in $io.PSObject.Properties)
                {
                    if ($p.Value.count -eq 1)
                    {
                        $hash.Add($p.Name, $p.Value)
                    }
                    elseif ($p.Value.count -gt 1)
                    {
                        $va = @()
                        foreach ($v in $p.Value)
                        {
                            $va += $v.name
                        }
                        $hash.Add($p.Name, $va)
                    }
                }
                [PSCustomObject]$hash
            }
        }
    }
}

