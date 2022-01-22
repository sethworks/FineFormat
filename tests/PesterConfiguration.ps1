$PesterConfiguration = New-PesterConfiguration

$PesterConfiguration.Run.Path = '.\tests\FineFormat.tests.ps1'
$PesterConfiguration.Output.Verbosity = 'Detailed'

$PesterConfiguration.Should.ErrorAction = 'Continue'
