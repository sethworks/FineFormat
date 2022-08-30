new-externalHelp -Path .\docs\en-us -OutputPath .\en-us -Force
new-externalHelp -Path .\docs\ru-ru -OutputPath .\ru-ru -Force

$ModuleName = Split-Path -Path $PSScriptRoot\.. -Leaf

foreach ($helpFile in (Get-ChildItem -Path "${ModuleName}-help.xml" -Recurse))
{
    [xml]$xml = Get-Content $helpFile.FullName

    $count = $xml.helpItems.command.examples.example.Count

    for ($i = 0; $i -lt $count - 1; $i++)
    {
        $el = $xml.CreateElement('maml', 'para', 'http://schemas.microsoft.com/maml/2004/10')
        $xml.helpItems.command.examples.example[$i].remarks.AppendChild($el) | Out-Null
        $el = $xml.CreateElement('maml', 'para', 'http://schemas.microsoft.com/maml/2004/10')
        $xml.helpItems.command.examples.example[$i].remarks.AppendChild($el) | Out-Null
    }

    $xml.Save($helpFile.FullName)
}
