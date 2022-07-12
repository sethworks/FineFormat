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

        $CimClass = Get-CimClass -ClassName Win32_PhysicalMemory
        $CimInstance = New-CimInstance -CimClass $CimClass -ClientOnly -Property @{FormFactor=8; Capacity=8589934592; DataWidth=64; InterleavePosition=1; MemoryType=24; Speed=1333; TotalWidth=64; Attributes=2; InterleaveDataDepth=1; SMBiosMemoryType=24; TypeDetail=128; Caption='Physical Memory'; Description='Physical Memory'; Name='Physical Memory'; Manufacturer='Kingston'; Tag='Physical Memory 0'; Banklabel='BANK 0'; DeviceLocator='ChannelA-DIMM0'}
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

    Context "-HaveValue" {

        BeforeAll {
            $result = $SomeObject | Format-Fine -HaveValue
        }

        It "Has 7 properties" {
            $result.PSObject.Properties | Should -HaveCount 7
        }

        It "Has correct properties" {
            $result.PSObject.Properties.Name | Should -BeExactly @('IntegerZero', 'Integer', 'String', 'True', 'False', 'ArrayInteger', 'ArrayString')
        }

        It "Has correct values" {
            $result.PSObject.Properties.Value | Should -BeExactly @(0, 15, "It's a string", $true, $false, 1, 2, 3, 'One', 'Two', 'Three')
        }
    }

    Context "-NullOrEmpty" {

        BeforeAll {
            $result = $SomeObject | Format-Fine -NullOrEmpty
        }

        It "Has 4 properties" {
            $result.PSObject.Properties | Should -HaveCount 4
        }

        It "Has correct properties" {
            $result.PSObject.Properties.Name | Should -BeExactly @('EmptyString', 'Null', 'ArrayEmptyString', 'EmptyArray')
        }

        It "Has correct values" {
            $result.PSObject.Properties.Value | Should -BeExactly @("", $null, "")
        }
    }

    Context "-Numeric" {

        BeforeAll {
            $result = $SomeObject | Format-Fine -Numeric
        }

        It "Has 2 properties" {
            $result.PSObject.Properties | Should -HaveCount 2
        }

        It "Has correct properties" {
            $result.PSObject.Properties.Name | Should -BeExactly @('IntegerZero', 'Integer')
        }

        It "Has correct values" {
            $result.PSObject.Properties.Value | Should -BeExactly @(0, 15)
        }
    }

    Context "-Numeric CIM" {

        BeforeAll {
            $result = $CimInstance | Format-Fine -Numeric
        }

        It "Has 16 properties" {
            $result.PSObject.Properties | Should -HaveCount 16
        }

        It "Has correct properties" {
            $result.PSObject.Properties.Name | Should -BeExactly @('FormFactor', 'Capacity', 'DataWidth', 'InterleavePosition', 'MemoryType', 'PositionInRow', 'Speed', 'TotalWidth', 'Attributes', 'ConfiguredClockSpeed', 'ConfiguredVoltage', 'InterleaveDataDepth', 'MaxVoltage', 'MinVoltage', 'SMBIOSMemoryType', 'TypeDetail')
        }

        It "Has correct values" {
            $result.PSObject.Properties.Value | Should -BeExactly @(8, 8589934592, 64, 1, 24, $null, 1333, 64, 2, $null, $null, 1, $null, $null, 24, 128)
        }
    }

    Context "-Textual" {

        BeforeAll {
            $result = $SomeObject | Format-Fine -Textual
        }

        It "Has 2 properties" {
            $result.PSObject.Properties | Should -HaveCount 2
        }

        It "Has correct properties" {
            $result.PSObject.Properties.Name | Should -BeExactly @('EmptyString', 'String')
        }

        It "Has correct values" {
            $result.PSObject.Properties.Value | Should -BeExactly @("", "It's a string")
        }
    }

    Context "-Textual CIM" {

        BeforeAll {
            $result = $CimInstance | Format-Fine -Textual
        }

        It "Has 16 properties" {
            $result.PSObject.Properties | Should -HaveCount 16
        }

        It "Has correct properties" {
            $result.PSObject.Properties.Name | Should -BeExactly @('Caption', 'Description', 'Name', 'Status', 'CreationClassName', 'Manufacturer', 'Model', 'OtherIdentifyingInfo', 'PartNumber', 'SerialNumber', 'SKU', 'Tag', 'Version', 'BankLabel', 'DeviceLocator', 'PSComputerName')
        }

        It "Has correct values" {
            $result.PSObject.Properties.Value | Should -BeExactly @("Physical Memory", "Physical Memory", "Physical Memory", $null, $null, "Kingston", $null, $null, $null, $null, $null, "Physical Memory 0", $null, "BANK 0", "ChannelA-DIMM0", $null)
        }
    }

    Context "-ValueFilter" {

        BeforeAll {
            $result = $SomeObject | ff -ValueFilter {$PSItem -like "*ing"}
        }

        It "Has 1 property" {
            $result.PSObject.Properties | Should -HaveCount 1
        }

        It "Has correct properties" {
            $result.PSObject.Properties.Name | Should -BeExactly @('String')
        }

        It "Has correct values" {
            $result.PSObject.Properties.Value | Should -BeExactly @("It's a string")
        }
    }

    Context "-ValueFilter CIM" {

        BeforeAll {
            $result = $CimInstance | ff -ValueFilter {$PSItem -le 128}
        }

        It "Has 9 properties" {
            $result.PSObject.Properties | Should -HaveCount 9
        }

        It "Has correct properties" {
            $result.PSObject.Properties.Name | Should -BeExactly @('FormFactor', 'DataWidth', 'InterleavePosition', 'MemoryType', 'TotalWidth', 'Attributes', 'InterleaveDataDepth', 'SMBIOSMemoryType', 'TypeDetail')
        }

        It "Has correct values" {
            $result.PSObject.Properties.Value | Should -BeExactly @(8, 64, 1, 24, 64, 2, 1, 24, 128)
        }
    }

    Context "-TypeNameFilter" {

        BeforeAll {
            $result = $SomeObject | ff -TypeNameFilter {$PSItem -like "*Int32"}
        }

        It "Has 2 properties" {
            $result.PSObject.Properties | Should -HaveCount 2
        }

        It "Has correct properties" {
            $result.PSObject.Properties.Name | Should -BeExactly @('IntegerZero', 'Integer')
        }

        It "Has correct values" {
            $result.PSObject.Properties.Value | Should -BeExactly @(0, 15)
        }
    }

    Context "-TypeNameFilter CIM" {

        BeforeAll {
            $result = $CimInstance | ff -TypeNameFilter {$PSItem -like "uint"}
        }

        It "Has 9 properties" {
            $result.PSObject.Properties | Should -HaveCount 9
        }

        It "Has correct properties" {
            $result.PSObject.Properties.Name | Should -BeExactly @('InterleavePosition', 'PositionInRow', 'Speed', 'Attributes', 'ConfiguredClockSpeed', 'ConfiguredVoltage', 'MaxVoltage', 'MinVoltage', 'SMBIOSMemoryType')
        }

        It "Has correct values" {
            $result.PSObject.Properties.Value | Should -BeExactly @(1, $null, 1333, 2, $null, $null, $null, $null, 24)
        }
    }
}