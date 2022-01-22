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
                    if ($p.Value.Count -eq 1 -and $p.Value.Length -gt 0) # $Null.Count = 0, "".Count = 1, "".Length = 0
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

