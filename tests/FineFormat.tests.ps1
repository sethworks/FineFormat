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
            ArrayInteger = @(1, 2, 3)
            ArrayString = @('One', 'Two', 'Three')
            ArrayEmptyString = @("")
            EmptyArray = @()
        } | Add-Member -TypeName 'SomeObject' -PassThru
    }

    Context "Without parameters" {

        BeforeAll {
            $result = $SomeObject | Format-Fine
        }

        It "Has 7 properties" {
            $result.PSObject.Properties | Should -HaveCount 11
        }

        It "Has correct properties" {
            $result.PSObject.Properties.Name | Should -BeExactly @('IntegerZero', 'Integer', 'EmptyString', 'String', 'True', 'False', 'Null', 'ArrayInteger', 'ArrayString', 'ArrayEmptyString', 'EmptyArray')
        }

        It "Has correct values" {
            $result.PSObject.Properties.Value | Should -BeExactly @(0, 15, "", "It's a string", $true, $false, $null, 1, 2, 3, 'One', 'Two', 'Three', "")
        }

    }

    Context "-NotNullOrEmpty" {

        BeforeAll {
            $result = $SomeObject | Format-Fine -NotNullOrEmpty
        }

        It "Has 5 properties" {
            $result.PSObject.Properties | Should -HaveCount 7
        }

        It "Has correct properties" {
            $result.PSObject.Properties.Name | Should -BeExactly @('IntegerZero', 'Integer', 'String', 'True', 'False', 'ArrayInteger', 'ArrayString')
        }

        It "Has correct values" {
            $result.PSObject.Properties.Value | Should -BeExactly @(0, 15, "It's a string", $true, $false, 1, 2, 3, 'One', 'Two', 'Three')
        }
    }
}