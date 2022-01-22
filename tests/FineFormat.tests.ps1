BeforeAll {
    Remove-Module -Name FineFormat -Force -ErrorAction SilentlyContinue
    Import-Module -Name "$PSScriptRoot\..\FineFormat.psd1"
}

Describe "FineFormat" {

    BeforeAll {
        $SomeObject = [PSCustomObject]@{
            IntegerZero = [int]0
            Integer = [int]15
            EmptyString = [string]""
            String = [string]"It's a string"
            True = $true
            False = $false
            Null = $null
        } | Add-Member -TypeName 'SomeObject' -PassThru
    }

    Context "Without parameters" {

        BeforeAll {
            $result = $SomeObject | Format-Fine
        }

        It "Has 7 properties" {
            $result.PSObject.Properties | Should -HaveCount 7
        }

        It "Has correct properties" {
            $result.PSObject.Properties.Name | Should -Be @('IntegerZero', 'Integer', 'EmptyString', 'String', 'True', 'False', 'Null')
        }

        It "Has correct values" {
            $result.PSObject.Properties.Value | Should -Be @(0, 15, "", "It's a string", $true, $false, $null)
        }

    }

    Context "-NotNullOrEmpty" {

        BeforeAll {
            $result = $SomeObject | Format-Fine -NotNullOrEmpty
        }

        It "Has 5 properties" {
            $result.PSObject.Properties | Should -HaveCount 5
        }

        It "Has correct properties" {
            $result.PSObject.Properties.Name | Should -Be @('IntegerZero', 'Integer', 'String', 'True', 'False')
        }

        It "Has correct values" {
            $result.PSObject.Properties.Value | Should -Be @(0, 15, "It's a string", $true, $false)
        }
    }
}