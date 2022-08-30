BeforeAll {
    Remove-Module -Name FineFormat -Force -ErrorAction SilentlyContinue
    Import-Module -Name "$PSScriptRoot\..\FineFormat.psd1"
}

Describe "FineFormat" {

    BeforeAll {
        $Object1 = [PSCustomObject]@{
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
        } | Add-Member -TypeName 'Object1' -PassThru

        $gs = (Get-Culture).NumberFormat.NumberGroupSeparator
        $ds = (Get-Culture).NumberFormat.NumberDecimalSeparator

        $Object2 = [PSCustomObject]@{
            st = 'String'
            pl = 512
            fl = [double]::Parse("512.256", [cultureinfo]::InvariantCulture)
            kb = 1024
            mb = 2000000
            gb = 3000000000
            tb = 4000000000000
            pb = 5000000000000000
            eb = 6000000000000000000
        }

        if (-not ($IsLinux -or $IsMacOS))
        {
            $CimClassPhysicalMemory = Get-CimClass -ClassName Win32_PhysicalMemory
            $CimInstancePhysicalMemory = New-CimInstance -CimClass $CimClassPhysicalMemory -ClientOnly -Property @{FormFactor=8; Capacity=8589934592; DataWidth=64; InterleavePosition=1; MemoryType=24; Speed=1333; TotalWidth=64; Attributes=2; InterleaveDataDepth=1; SMBiosMemoryType=24; TypeDetail=128; Caption='Physical Memory'; Description='Physical Memory'; Name='Physical Memory'; Manufacturer='Kingston'; Tag='Physical Memory 0'; Banklabel='BANK 0'; DeviceLocator='ChannelA-DIMM0'}
            $CimClassLogicalDisk = Get-CimClass -ClassName Win32_LogicalDisk
            $CimInstanceLogicalDisk = New-CimInstance -CimClass $CimClassLogicalDisk -ClientOnly -Property @{DeviceID='C:'; Caption='C:'; Description='Local Fixed Disk'; Name='C:'; CreationClassName='Win32_LogicalDisk'; SystemCreationClassName='Win32_ComputerSystem'; Access=0; FreeSpace=57682386944; Size=214223253504; Compressed=$False; DriveType=3; FileSystem='NTFS'; MaximumComponentLength=255; MediaType=12; QuotasDisabled=$True; QuotasIncomplete=$False; QuotasRebuilding=$False; SupportsDiskQuotas=$True; SupportsFileBasedCompression=$True; VolumeDirty=$False; VolumeSerialNumber='1234ABCD'}
        }

    }

    Context "Without parameters" {

        BeforeAll {
            $result = $Object1 | Format-Fine
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

    Context "-HasValue" {

        BeforeAll {
            $result = $Object1 | Format-Fine -HasValue
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

    Context "-NoValue" {

        BeforeAll {
            $result = $Object1 | Format-Fine -NoValue
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

    Context "-Value" {

        Context "-Value string" {

            BeforeAll {
                $result = $Object1 | Format-Fine -Value "str"
            }

            It "Should be null" {
                $result | Should -BeNullOrEmpty
            }
        }

        Context "-Value *string*" {

            BeforeAll {
                $result = $Object1 | Format-Fine -Value "*str*"
            }

            It "Has 1 property" {
                $result.PSObject.Properties | Should -HaveCount 1
            }
    
            It "Has correct property" {
                $result.PSObject.Properties.Name | Should -BeExactly 'String'
            }
    
            It "Has correct value" {
                $result.PSObject.Properties.Value | Should -BeExactly "It's a string"
            }
        }

        Context "-Value number" {

            BeforeAll {
                $result = $Object1 | Format-Fine -Value 15
            }

            It "Has 1 property" {
                $result.PSObject.Properties | Should -HaveCount 1
            }
    
            It "Has correct property" {
                $result.PSObject.Properties.Name | Should -BeExactly 'Integer'
            }
    
            It "Has correct value" {
                $result.PSObject.Properties.Value | Should -BeExactly 15
            }
        }

        Context "-Value number*" {

            BeforeAll {
                $result = $Object1 | Format-Fine -Value 1*
            }

            It "Has 2 properties" {
                $result.PSObject.Properties | Should -HaveCount 2
            }
    
            It "Has correct properties" {
                $result.PSObject.Properties.Name | Should -BeExactly @('Integer', 'ArrayInteger')
            }
    
            It "Has correct values" {
                $result.PSObject.Properties.Value | Should -BeExactly @(15, 1, 2, 3)
            }
        }

        Context "-Value True" {

            BeforeAll {
                $result = $Object1 | Format-Fine -Value $true
            }

            It "Has 1 property" {
                $result.PSObject.Properties | Should -HaveCount 1
            }
    
            It "Has correct property" {
                $result.PSObject.Properties.Name | Should -BeExactly 'True'
            }
    
            It "Has correct value" {
                $result.PSObject.Properties.Value | Should -BeExactly $true
            }
        }

        Context "-Value False" {

            BeforeAll {
                $result = $Object1 | Format-Fine -Value $false
            }

            It "Has 1 property" {
                $result.PSObject.Properties | Should -HaveCount 1
            }
    
            It "Has correct property" {
                $result.PSObject.Properties.Name | Should -BeExactly 'False'
            }
    
            It "Has correct value" {
                $result.PSObject.Properties.Value | Should -BeExactly $false
            }
        }

        Context "-Value array" {

            BeforeAll {
                $result = $Object1 | Format-Fine -Value "*str*", 1*
            }

            It "Has 3 properties" {
                $result.PSObject.Properties | Should -HaveCount 3
            }
    
            It "Has correct property" {
                $result.PSObject.Properties.Name | Should -BeExactly @('Integer', 'String', 'ArrayInteger')
            }
    
            It "Has correct value" {
                $result.PSObject.Properties.Value | Should -BeExactly @(15, "It's a string", 1, 2, 3)
            }
        }

        Context "-Value star" {

            BeforeAll {
                $result = $Object1 | Format-Fine -Value *
            }

            It "Has 7 properties" {
                $result.PSObject.Properties | Should -HaveCount 7
            }
    
            It "Has correct property" {
                $result.PSObject.Properties.Name | Should -BeExactly @('IntegerZero', 'Integer', 'String', 'True', 'False', 'ArrayInteger', 'ArrayString')
            }
    
            It "Has correct value" {
                $result.PSObject.Properties.Value | Should -BeExactly @(0, 15, "It's a string", $true, $false, 1, 2, 3, 'One', 'Two', 'Three')
            }
        }
    }

    Context "-TypeName" {

        Context "-TypeName System.String" {

            BeforeAll {
                $result = $Object1 | Format-Fine -TypeName System.String
            }

            It "Has 2 properties" {
                $result.PSObject.Properties | Should -HaveCount 2
            }
    
            It "Has correct property" {
                $result.PSObject.Properties.Name | Should -BeExactly @('EmptyString', 'String')
            }
    
            It "Has correct value" {
                $result.PSObject.Properties.Value | Should -BeExactly @('', "It's a string")
            }
        }

        Context "-TypeName uint" -Skip:($IsLinux -or $IsMacOS) {

            BeforeAll {
                $result = $CimInstanceLogicalDisk | Format-Fine -TypeName uint
            }

            It "Has 5 properties" {
                $result.PSObject.Properties | Should -HaveCount 5
            }
    
            It "Has correct property" {
                $result.PSObject.Properties.Name | Should -BeExactly @('ConfigManagerErrorCode', 'LastErrorCode', 'DriveType', 'MaximumComponentLength', 'MediaType')
            }
    
            It "Has correct value" {
                $result.PSObject.Properties.Value | Should -BeExactly @($null, $null, 3, 255, 12)
            }
        }

        Context "-TypeName array" {

            BeforeAll {
                $result = $Object1 | Format-Fine -TypeName *int*, 'System.Object`[`]'
            }

            It "Has 6 properties" {
                $result.PSObject.Properties | Should -HaveCount 6
            }
    
            It "Has correct property" {
                $result.PSObject.Properties.Name | Should -BeExactly @('IntegerZero', 'Integer', 'ArrayInteger', 'ArrayString', 'ArrayEmptyString', 'EmptyArray')
            }
    
            It "Has correct value" {
                $result.PSObject.Properties.Value | Should -BeExactly @(0, 15, 1, 2, 3, 'One', 'Two', 'Three', '')
            }
        }

        Context "-TypeName array cim" -Skip:($IsLinux -or $IsMacOS) {

            BeforeAll {
                $result = $CimInstanceLogicalDisk | Format-Fine -TypeName *int, 'ushort`[`]'
            }

            It "Has 6 properties" {
                $result.PSObject.Properties | Should -HaveCount 6
            }
    
            It "Has correct property" {
                $result.PSObject.Properties.Name | Should -BeExactly @('ConfigManagerErrorCode', 'LastErrorCode', 'PowerManagementCapabilities', 'DriveType', 'MaximumComponentLength', 'MediaType')
            }
    
            It "Has correct value" {
                $result.PSObject.Properties.Value | Should -BeExactly @($null, $null, $null, 3, 255, 12)
            }
        }

        Context "-TypeName star" {

            BeforeAll {
                $result = $Object1 | Format-Fine -TypeName *
            }

            It "Has 1 properties" {
                $result.PSObject.Properties | Should -HaveCount 11
            }
    
            It "Has correct property" {
                $result.PSObject.Properties.Name | Should -BeExactly @('IntegerZero', 'Integer', 'EmptyString', 'String', 'True', 'False', 'Null', 'ArrayInteger', 'ArrayString', 'ArrayEmptyString', 'EmptyArray')
            }
    
            It "Has correct value" {
                $result.PSObject.Properties.Value | Should -BeExactly @(0, 15, '', "It's a string", $true, $false, $null, 1, 2, 3, 'One', 'Two', 'Three', '')
            }
        }
    }

    Context "Type groups" {

        Context "-NumericTypes" {

            BeforeAll {
                $result = $Object1 | Format-Fine -NumericTypes
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

        Context "-NumericTypes cim" -Skip:($IsLinux -or $IsMacOS) {

            BeforeAll {
                $result = $CimInstancePhysicalMemory | Format-Fine -NumericTypes
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

        Context "-SymbolicTypes" {

            BeforeAll {
                $result = $Object1 | Format-Fine -SymbolicTypes
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

        Context "-SymbolicTypes cim" -Skip:($IsLinux -or $IsMacOS) {

            BeforeAll {
                $result = $CimInstancePhysicalMemory | Format-Fine -SymbolicTypes
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

        Context "-Boolean" {

            BeforeAll {
                $result = $Object1 | Format-Fine -Boolean
            }

            It "Has 2 properties" {
                $result.PSObject.Properties | Should -HaveCount 2
            }

            It "Has correct properties" {
                $result.PSObject.Properties.Name | Should -BeExactly @('True', 'False')
            }

            It "Has correct values" {
                $result.PSObject.Properties.Value | Should -BeExactly @($true, $false)
            }
        }

        Context "-Boolean cim" -Skip:($IsLinux -or $IsMacOS) {

            BeforeAll {
                $result = $CimInstancePhysicalMemory | Format-Fine -Boolean
            }

            It "Has 4 properties" {
                $result.PSObject.Properties | Should -HaveCount 4
            }

            It "Has correct properties" {
                $result.PSObject.Properties.Name | Should -BeExactly @('PoweredOn', 'HotSwappable', 'Removable', 'Replaceable')
            }

            It "Has correct values" {
                $result.PSObject.Properties.Value | Should -BeExactly @($null, $null, $null, $null)
            }
        }

        Context "-NumericTypes -SymbolicTypes" {

            BeforeAll {
                $result = $Object1 | Format-Fine -NumericTypes -SymbolicTypes
            }

            It "Has 4 properties" {
                $result.PSObject.Properties | Should -HaveCount 4
            }

            It "Has correct properties" {
                $result.PSObject.Properties.Name | Should -BeExactly @('IntegerZero', 'Integer', 'EmptyString', 'String')
            }

            It "Has correct values" {
                $result.PSObject.Properties.Value | Should -BeExactly @(0, 15, "", "It's a string")
            }
        }

        Context "-NumericTypes -SymbolicTypes cim" -Skip:($IsLinux -or $IsMacOS) {

            BeforeAll {
                $result = $CimInstancePhysicalMemory | Format-Fine -NumericTypes -SymbolicTypes
            }

            It "Has 32 properties" {
                $result.PSObject.Properties | Should -HaveCount 32
            }

            It "Has correct properties" {
                $result.PSObject.Properties.Name | Should -BeExactly @('Caption', 'Description', 'Name', 'Status', 'CreationClassName', 'Manufacturer', 'Model', 'OtherIdentifyingInfo', 'PartNumber', 'SerialNumber', 'SKU', 'Tag', 'Version','FormFactor', 'BankLabel', 'Capacity', 'DataWidth', 'InterleavePosition', 'MemoryType', 'PositionInRow', 'Speed', 'TotalWidth', 'Attributes', 'ConfiguredClockSpeed', 'ConfiguredVoltage', 'DeviceLocator', 'InterleaveDataDepth', 'MaxVoltage', 'MinVoltage', 'SMBIOSMemoryType', 'TypeDetail', 'PSComputerName')
            }

            It "Has correct values" {
                $result.PSObject.Properties.Value | Should -BeExactly @("Physical Memory", "Physical Memory", "Physical Memory", $null, $null, "Kingston", $null, $null, $null, $null, $null, "Physical Memory 0", $null, 8, "BANK 0", 8589934592, 64, 1, 24, $null, 1333, 64, 2, $null, $null, "ChannelA-DIMM0", 1, $null, $null, 24, 128, $null)
            }
        }

        Context "-NumericTypes -Boolean" {

            BeforeAll {
                $result = $Object1 | Format-Fine -NumericTypes -Boolean
            }

            It "Has 4 properties" {
                $result.PSObject.Properties | Should -HaveCount 4
            }

            It "Has correct properties" {
                $result.PSObject.Properties.Name | Should -BeExactly @('IntegerZero', 'Integer', 'True', 'False')
            }

            It "Has correct values" {
                $result.PSObject.Properties.Value | Should -BeExactly @(0, 15, $true, $false)
            }
        }

        Context "-NumericTypes -Boolean cim" -Skip:($IsLinux -or $IsMacOS) {

            BeforeAll {
                $result = $CimInstancePhysicalMemory | Format-Fine -NumericTypes -Boolean
            }

            It "Has 20 properties" {
                $result.PSObject.Properties | Should -HaveCount 20
            }

            It "Has correct properties" {
                $result.PSObject.Properties.Name | Should -BeExactly @('PoweredOn', 'HotSwappable', 'Removable', 'Replaceable', 'FormFactor', 'Capacity', 'DataWidth', 'InterleavePosition', 'MemoryType', 'PositionInRow', 'Speed', 'TotalWidth', 'Attributes', 'ConfiguredClockSpeed', 'ConfiguredVoltage', 'InterleaveDataDepth', 'MaxVoltage', 'MinVoltage', 'SMBIOSMemoryType', 'TypeDetail')
            }

            It "Has correct values" {
                $result.PSObject.Properties.Value | Should -BeExactly @($null, $null, $null, $null, 8, 8589934592, 64, 1, 24, $null, 1333, 64, 2, $null, $null, 1, $null, $null, 24, 128)
            }
        }

        Context "-SymbolicTypes -Boolean" {

            BeforeAll {
                $result = $Object1 | Format-Fine -SymbolicTypes -Boolean
            }

            It "Has 4 properties" {
                $result.PSObject.Properties | Should -HaveCount 4
            }

            It "Has correct properties" {
                $result.PSObject.Properties.Name | Should -BeExactly @('EmptyString', 'String', 'True', 'False')
            }

            It "Has correct values" {
                $result.PSObject.Properties.Value | Should -BeExactly @("", "It's a string", $true, $false)
            }
        }

        Context "-SymbolicTypes -Boolean cim" -Skip:($IsLinux -or $IsMacOS) {

            BeforeAll {
                $result = $CimInstancePhysicalMemory | Format-Fine -SymbolicTypes -Boolean
            }

            It "Has 20 properties" {
                $result.PSObject.Properties | Should -HaveCount 20
            }

            It "Has correct properties" {
                $result.PSObject.Properties.Name | Should -BeExactly @('Caption', 'Description', 'Name', 'Status', 'CreationClassName', 'Manufacturer', 'Model', 'OtherIdentifyingInfo', 'PartNumber', 'PoweredOn', 'SerialNumber', 'SKU', 'Tag', 'Version', 'HotSwappable', 'Removable', 'Replaceable', 'BankLabel', 'DeviceLocator', 'PSComputerName')
            }

            It "Has correct values" {
                $result.PSObject.Properties.Value | Should -BeExactly @("Physical Memory", "Physical Memory", "Physical Memory", $null, $null, "Kingston", $null, $null, $null, $null, $null, $null, "Physical Memory 0", $null, $null, $null, $null, "BANK 0", "ChannelA-DIMM0", $null)
            }
        }

        Context "-NumericTypes -SymbolicTypes -Boolean" {

            BeforeAll {
                $result = $Object1 | Format-Fine -NumericTypes -SymbolicTypes -Boolean
            }

            It "Has 6 properties" {
                $result.PSObject.Properties | Should -HaveCount 6
            }

            It "Has correct properties" {
                $result.PSObject.Properties.Name | Should -BeExactly @('IntegerZero', 'Integer', 'EmptyString', 'String', 'True', 'False')
            }

            It "Has correct values" {
                $result.PSObject.Properties.Value | Should -BeExactly @(0, 15, "", "It's a string", $true, $false)
            }
        }

        Context "-NumericTypes -SymbolicTypes -Boolean cim" -Skip:($IsLinux -or $IsMacOS) {

            BeforeAll {
                $result = $CimInstancePhysicalMemory | Format-Fine -NumericTypes -SymbolicTypes -Boolean
            }

            It "Has 36 properties" {
                $result.PSObject.Properties | Should -HaveCount 36
            }

            It "Has correct properties" {
                $result.PSObject.Properties.Name | Should -BeExactly @('Caption', 'Description', 'Name', 'Status', 'CreationClassName', 'Manufacturer', 'Model', 'OtherIdentifyingInfo', 'PartNumber', 'PoweredOn', 'SerialNumber', 'SKU', 'Tag', 'Version', 'HotSwappable', 'Removable', 'Replaceable',  'FormFactor', 'BankLabel', 'Capacity', 'DataWidth', 'InterleavePosition', 'MemoryType', 'PositionInRow', 'Speed', 'TotalWidth', 'Attributes', 'ConfiguredClockSpeed', 'ConfiguredVoltage', 'DeviceLocator', 'InterleaveDataDepth', 'MaxVoltage', 'MinVoltage', 'SMBIOSMemoryType', 'TypeDetail', 'PSComputerName')
            }

            It "Has correct values" {
                $result.PSObject.Properties.Value | Should -BeExactly @("Physical Memory", "Physical Memory", "Physical Memory", $null, $null, "Kingston", $null, $null, $null, $null, $null, $null, "Physical Memory 0", $null, $null, $null, $null, 8, "BANK 0", 8589934592, 64, 1, 24, $null, 1333, 64, 2, $null, $null, "ChannelA-DIMM0", 1, $null, $null, 24, 128, $null)
            }
        }
    }

    Context "Filters" {

        Context "-ValueFilter" {

            BeforeAll {
                $result = $Object1 | ff -ValueFilter {$PSItem -like "*ing"}
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

        Context "-ValueFilter cim" -Skip:($IsLinux -or $IsMacOS) {

            BeforeAll {
                $result = $CimInstancePhysicalMemory | ff -ValueFilter {$PSItem -le 128}
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
                $result = $Object1 | ff -TypeNameFilter {$PSItem -like "*Int32"}
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

        Context "-TypeNameFilter cim" -Skip:($IsLinux -or $IsMacOS) {

            BeforeAll {
                $result = $CimInstancePhysicalMemory | ff -TypeNameFilter {$PSItem -like "uint"}
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

    Context "Numbers transformation" {

        Context "-CompactNumbers" {

            BeforeAll {
                $result = $Object2 | ff -CompactNumbers
            }

            It "Has 9 properties" {
                $result.PSObject.Properties | Should -HaveCount 9
            }

            It "Has correct properties" {
                $result.PSObject.Properties.Name | Should -BeExactly @('st', 'pl', 'fl', 'kb', 'mb', 'gb', 'tb', 'pb', 'eb')
            }

            It "Has correct values" {
                $result.PSObject.Properties.Value | Should -BeExactly @('String', '512', "512${ds}26", '1 K', "1${ds}91 M", "2${ds}79 G", "3${ds}64 T", "4${ds}44 P", "5329${ds}07 P")
            }
        }

        Context "-NumberGroupSeparator" {

            BeforeAll {
                $result = $Object2 | ff -NumberGroupSeparator
            }

            It "Has 9 properties" {
                $result.PSObject.Properties | Should -HaveCount 9
            }

            It "Has correct properties" {
                $result.PSObject.Properties.Name | Should -BeExactly @('st', 'pl', 'fl', 'kb', 'mb', 'gb', 'tb', 'pb', 'eb')
            }

            It "Has correct values" {
                $result.PSObject.Properties.Value | Should -BeExactly @('String', '512', "512${ds}26", "1${gs}024", "2${gs}000${gs}000", "3${gs}000${gs}000${gs}000", "4${gs}000${gs}000${gs}000${gs}000", "5${gs}000${gs}000${gs}000${gs}000${gs}000", "6${gs}000${gs}000${gs}000${gs}000${gs}000${gs}000")
            }
        }

        Context "-NumberGroupSeparator cim" -Skip:($IsLinux -or $IsMacOS) {

            BeforeAll {
                $result = $CimInstanceLogicalDisk | ff -NumericTypes -HasValue -NumberGroupSeparator
            }

            It "Has 6 properties" {
                $result.PSObject.Properties | Should -HaveCount 6
            }

            It "Has correct properties" {
                $result.PSObject.Properties.Name | Should -BeExactly @('Access', 'FreeSpace', 'Size', 'DriveType', 'MaximumComponentLength', 'MediaType')
            }

            It "Has correct values" {
                $result.PSObject.Properties.Value | Should -BeExactly @('0', "57${gs}682${gs}386${gs}944", "214${gs}223${gs}253${gs}504", '3', '255', '12')
            }
        }

        Context "-CompactNumbers -NumberGroupSeparator" {

            BeforeAll {
                $result = $Object2 | ff -CompactNumbers -NumberGroupSeparator
            }

            It "Has 9 properties" {
                $result.PSObject.Properties | Should -HaveCount 9
            }

            It "Has correct properties" {
                $result.PSObject.Properties.Name | Should -BeExactly @('st', 'pl', 'fl', 'kb', 'mb', 'gb', 'tb', 'pb', 'eb')
            }

            It "Has correct values" {
                $result.PSObject.Properties.Value | Should -BeExactly @('String', '512', "512${ds}26", '1 K', "1${ds}91 M", "2${ds}79 G", "3${ds}64 T", "4${ds}44 P", "5${gs}329${ds}07 P")
            }
        }

        Context "-NumbersAs Kilo" {

            BeforeAll {
                $result = $Object2 | ff -NumbersAs Kilo
            }

            It "Has 9 properties" {
                $result.PSObject.Properties | Should -HaveCount 9
            }

            It "Has correct properties" {
                $result.PSObject.Properties.Name | Should -BeExactly @('st', 'pl', 'fl', 'kb', 'mb', 'gb', 'tb', 'pb', 'eb')
            }

            It "Has correct values" {
                $result.PSObject.Properties.Value | Should -BeExactly @('String', '512', "512${ds}26", '1 K', "1953${ds}13 K", "2929687${ds}5 K", "3906250000 K", "4882812500000 K", "5859375000000000 K")
            }
        }

        Context "-NumbersAs Kilo cim" -Skip:($IsLinux -or $IsMacOS) {

            BeforeAll {
                $result = $CimInstanceLogicalDisk | ff -NumericTypes -HasValue -NumbersAs Kilo
            }

            It "Has 6 properties" {
                $result.PSObject.Properties | Should -HaveCount 6
            }

            It "Has correct properties" {
                $result.PSObject.Properties.Name | Should -BeExactly @('Access', 'FreeSpace', 'Size', 'DriveType', 'MaximumComponentLength', 'MediaType')
            }

            It "Has correct values" {
                $result.PSObject.Properties.Value | Should -BeExactly @('0', '56330456 K', '209202396 K', '3', '255', '12')
            }
        }

        Context "-NumbersAs Mega" {

            BeforeAll {
                $result = $Object2 | ff -NumbersAs Mega
            }

            It "Has 9 properties" {
                $result.PSObject.Properties | Should -HaveCount 9
            }

            It "Has correct properties" {
                $result.PSObject.Properties.Name | Should -BeExactly @('st', 'pl', 'fl', 'kb', 'mb', 'gb', 'tb', 'pb', 'eb')
            }

            It "Has correct values" {
                $result.PSObject.Properties.Value | Should -BeExactly @('String', '512', "512${ds}26", '1024', "1${ds}91 M", "2861${ds}02 M", "3814697${ds}27 M", "4768371582${ds}03 M", "5722045898437${ds}5 M")
            }
        }

        Context "-NumbersAs Mega cim" -Skip:($IsLinux -or $IsMacOS) {

            BeforeAll {
                $result = $CimInstanceLogicalDisk | ff -NumericTypes -HasValue -NumbersAs Mega
            }

            It "Has 6 properties" {
                $result.PSObject.Properties | Should -HaveCount 6
            }

            It "Has correct properties" {
                $result.PSObject.Properties.Name | Should -BeExactly @('Access', 'FreeSpace', 'Size', 'DriveType', 'MaximumComponentLength', 'MediaType')
            }

            It "Has correct values" {
                $result.PSObject.Properties.Value | Should -BeExactly @('0', "55010${ds}21 M", "204299${ds}21 M", '3', '255', '12')
            }
        }

        Context "-NumbersAs Giga" {

            BeforeAll {
                $result = $Object2 | ff -NumbersAs Giga
            }

            It "Has 6 properties" {
                $result.PSObject.Properties | Should -HaveCount 9
            }

            It "Has correct properties" {
                $result.PSObject.Properties.Name | Should -BeExactly @('st', 'pl', 'fl', 'kb', 'mb', 'gb', 'tb', 'pb', 'eb')
            }

            It "Has correct values" {
                $result.PSObject.Properties.Value | Should -BeExactly @('String', '512', "512${ds}26", '1024', "2000000", "2${ds}79 G", "3725${ds}29 G", "4656612${ds}87 G", "5587935447${ds}69 G")
            }
        }

        Context "-NumbersAs Giga cim" -Skip:($IsLinux -or $IsMacOS) {

            BeforeAll {
                $result = $CimInstanceLogicalDisk | ff -NumericTypes -HasValue -NumbersAs Giga
            }

            It "Has 6 properties" {
                $result.PSObject.Properties | Should -HaveCount 6
            }

            It "Has correct properties" {
                $result.PSObject.Properties.Name | Should -BeExactly @('Access', 'FreeSpace', 'Size', 'DriveType', 'MaximumComponentLength', 'MediaType')
            }

            It "Has correct values" {
                $result.PSObject.Properties.Value | Should -BeExactly @('0', "53${ds}72 G", "199${ds}51 G", '3', '255', '12')
            }
        }

        Context "-NumbersAs Tera" {

            BeforeAll {
                $result = $Object2 | ff -NumbersAs Tera
            }

            It "Has 9 properties" {
                $result.PSObject.Properties | Should -HaveCount 9
            }

            It "Has correct properties" {
                $result.PSObject.Properties.Name | Should -BeExactly @('st', 'pl', 'fl', 'kb', 'mb', 'gb', 'tb', 'pb', 'eb')
            }

            It "Has correct values" {
                $result.PSObject.Properties.Value | Should -BeExactly @('String', '512', "512${ds}26", '1024', '2000000', '3000000000', "3${ds}64 T", "4547${ds}47 T", "5456968${ds}21 T")
            }
        }

        Context "-NumbersAs Peta" {

            BeforeAll {
                $result = $Object2 | ff -NumbersAs Peta
            }

            It "Has 9 properties" {
                $result.PSObject.Properties | Should -HaveCount 9
            }

            It "Has correct properties" {
                $result.PSObject.Properties.Name | Should -BeExactly @('st', 'pl', 'fl', 'kb', 'mb', 'gb', 'tb', 'pb', 'eb')
            }

            It "Has correct values" {
                $result.PSObject.Properties.Value | Should -BeExactly @('String', '512', "512${ds}26", '1024', '2000000', '3000000000', '4000000000000', "4${ds}44 P", "5329${ds}07 P")
            }
        }

        Context "-NumbersAs wrong value" {

            BeforeAll {
                $result = $Object2 | ff -NumbersAs wrongvalue 3> $null
            }

            It "Has 9 properties" {
                $result.PSObject.Properties | Should -HaveCount 9
            }

            It "Has correct properties" {
                $result.PSObject.Properties.Name | Should -BeExactly @('st', 'pl', 'fl', 'kb', 'mb', 'gb', 'tb', 'pb', 'eb')
            }

            It "Has correct values" {
                $result.PSObject.Properties.Value | Should -BeExactly @('String', '512', "512${ds}256", '1024', '2000000', '3000000000', '4000000000000', '5000000000000000', '6000000000000000000')
            }
        }
    }

    Context "-TypeName completion" {

        BeforeAll {
            $ObjectDefinition = '[PSCustomObject]@{IntegerZero = [int]0; Integer = [int]15; EmptyString = [string]""; String = [string]"It''s a string"; True = $true; False = $false; Null = $null; ArrayInteger = @(1, 2, 3); ArrayString = @("One", "Two", "Three"); ArrayEmptyString = @(""); EmptyArray = @() }'
        }

        Context "Pipeline" {

            It "ff -TypeName " {
                $line = "$ObjectDefinition | ff -TypeName <Tab>"
                $cursorColumn = $line.IndexOf('<Tab>')
                $commandCompletion = TabExpansion2 -inputScript $line.Remove($cursorColumn, 5) -cursorColumn $cursorColumn
                $commandCompletion.CompletionMatches | Should -HaveCount 5
                $commandCompletion.CompletionMatches.CompletionText | Should -BeExactly @('System.Boolean', 'System.Int32', 'System.Object', '''System.Object`[`]''', 'System.String')
            }

            It "ff -TypeName Sys" {
                $line = "$ObjectDefinition | ff -TypeName Sys<Tab>"
                $cursorColumn = $line.IndexOf('<Tab>')
                $commandCompletion = TabExpansion2 -inputScript $line.Remove($cursorColumn, 5) -cursorColumn $cursorColumn
                $commandCompletion.CompletionMatches | Should -HaveCount 5
                $commandCompletion.CompletionMatches.CompletionText | Should -BeExactly @('System.Boolean', 'System.Int32', 'System.Object', '''System.Object`[`]''', 'System.String')
            }

            It "ff -TypeName System." {
                $line = "$ObjectDefinition | ff -TypeName System.<Tab>"
                $cursorColumn = $line.IndexOf('<Tab>')
                $commandCompletion = TabExpansion2 -inputScript $line.Remove($cursorColumn, 5) -cursorColumn $cursorColumn
                $commandCompletion.CompletionMatches | Should -HaveCount 5
                $commandCompletion.CompletionMatches.CompletionText | Should -BeExactly @('System.Boolean', 'System.Int32', 'System.Object', '''System.Object`[`]''', 'System.String')
            }

            It "ff -TypeName System.Obj" {
                $line = "$ObjectDefinition | ff -TypeName System.Obj<Tab>"
                $cursorColumn = $line.IndexOf('<Tab>')
                $commandCompletion = TabExpansion2 -inputScript $line.Remove($cursorColumn, 5) -cursorColumn $cursorColumn
                $commandCompletion.CompletionMatches | Should -HaveCount 2
                $commandCompletion.CompletionMatches.CompletionText | Should -BeExactly @('System.Object', '''System.Object`[`]''')
            }

            It "ff -TypeName System.Object" {
                $line = "$ObjectDefinition | ff -TypeName System.Object<Tab>"
                $cursorColumn = $line.IndexOf('<Tab>')
                $commandCompletion = TabExpansion2 -inputScript $line.Remove($cursorColumn, 5) -cursorColumn $cursorColumn
                $commandCompletion.CompletionMatches | Should -HaveCount 2
                $commandCompletion.CompletionMatches.CompletionText | Should -BeExactly @('System.Object', '''System.Object`[`]''')
            }

            It "ff -TypeName System.Object, " {
                $line = "$ObjectDefinition | ff -TypeName System.Object, <Tab>"
                $cursorColumn = $line.IndexOf('<Tab>')
                $commandCompletion = TabExpansion2 -inputScript $line.Remove($cursorColumn, 5) -cursorColumn $cursorColumn
                $commandCompletion.CompletionMatches | Should -HaveCount 4
                $commandCompletion.CompletionMatches.CompletionText | Should -BeExactly @('System.Boolean', 'System.Int32', '''System.Object`[`]''', 'System.String')
            }

            It "ff -TypeName System.Object, System.Object" {
                $line = "$ObjectDefinition | ff -TypeName System.Object, System.Object<Tab>"
                $cursorColumn = $line.IndexOf('<Tab>')
                $commandCompletion = TabExpansion2 -inputScript $line.Remove($cursorColumn, 5) -cursorColumn $cursorColumn
                $commandCompletion.CompletionMatches | Should -HaveCount 1
                $commandCompletion.CompletionMatches.CompletionText | Should -BeExactly @('''System.Object`[`]''')
            }

            It "ff -TypeName 'System.Object``[``]', System.Object" {
                $line = "$ObjectDefinition | ff -TypeName 'System.Object``[``]', System.Object<Tab>"
                $cursorColumn = $line.IndexOf('<Tab>')
                $commandCompletion = TabExpansion2 -inputScript $line.Remove($cursorColumn, 5) -cursorColumn $cursorColumn
                $commandCompletion.CompletionMatches | Should -HaveCount 1
                $commandCompletion.CompletionMatches.CompletionText | Should -BeExactly @('System.Object')
            }
        }

        Context "-InputObject parameter" {

            It "ff -TypeName " {
                $line = "ff -InputObject ($ObjectDefinition) -TypeName <Tab>"
                $cursorColumn = $line.IndexOf('<Tab>')
                $commandCompletion = TabExpansion2 -inputScript $line.Remove($cursorColumn, 5) -cursorColumn $cursorColumn
                $commandCompletion.CompletionMatches | Should -HaveCount 5
                $commandCompletion.CompletionMatches.CompletionText | Should -BeExactly @('System.Boolean', 'System.Int32', 'System.Object', '''System.Object`[`]''', 'System.String')
            }

            It "ff -TypeName Sys" {
                $line = "ff -InputObject ($ObjectDefinition) -TypeName Sys<Tab>"
                $cursorColumn = $line.IndexOf('<Tab>')
                $commandCompletion = TabExpansion2 -inputScript $line.Remove($cursorColumn, 5) -cursorColumn $cursorColumn
                $commandCompletion.CompletionMatches | Should -HaveCount 5
                $commandCompletion.CompletionMatches.CompletionText | Should -BeExactly @('System.Boolean', 'System.Int32', 'System.Object', '''System.Object`[`]''', 'System.String')
            }

            It "ff -TypeName System." {
                $line = "ff -InputObject ($ObjectDefinition) -TypeName System.<Tab>"
                $cursorColumn = $line.IndexOf('<Tab>')
                $commandCompletion = TabExpansion2 -inputScript $line.Remove($cursorColumn, 5) -cursorColumn $cursorColumn
                $commandCompletion.CompletionMatches | Should -HaveCount 5
                $commandCompletion.CompletionMatches.CompletionText | Should -BeExactly @('System.Boolean', 'System.Int32', 'System.Object', '''System.Object`[`]''', 'System.String')
            }

            It "ff -TypeName System.Obj" {
                $line = "ff -InputObject ($ObjectDefinition) -TypeName System.Obj<Tab>"
                $cursorColumn = $line.IndexOf('<Tab>')
                $commandCompletion = TabExpansion2 -inputScript $line.Remove($cursorColumn, 5) -cursorColumn $cursorColumn
                $commandCompletion.CompletionMatches | Should -HaveCount 2
                $commandCompletion.CompletionMatches.CompletionText | Should -BeExactly @('System.Object', '''System.Object`[`]''')
            }

            It "ff -TypeName System.Object" {
                $line = "ff -InputObject ($ObjectDefinition) -TypeName System.Object<Tab>"
                $cursorColumn = $line.IndexOf('<Tab>')
                $commandCompletion = TabExpansion2 -inputScript $line.Remove($cursorColumn, 5) -cursorColumn $cursorColumn
                $commandCompletion.CompletionMatches | Should -HaveCount 2
                $commandCompletion.CompletionMatches.CompletionText | Should -BeExactly @('System.Object', '''System.Object`[`]''')
            }

            It "ff -TypeName System.Object, " {
                $line = "ff -InputObject ($ObjectDefinition) -TypeName System.Object, <Tab>"
                $cursorColumn = $line.IndexOf('<Tab>')
                $commandCompletion = TabExpansion2 -inputScript $line.Remove($cursorColumn, 5) -cursorColumn $cursorColumn
                $commandCompletion.CompletionMatches | Should -HaveCount 4
                $commandCompletion.CompletionMatches.CompletionText | Should -BeExactly @('System.Boolean', 'System.Int32', '''System.Object`[`]''', 'System.String')
            }

            It "ff -TypeName System.Object, System.Object" {
                $line = "ff -InputObject ($ObjectDefinition) -TypeName System.Object, System.Object<Tab>"
                $cursorColumn = $line.IndexOf('<Tab>')
                $commandCompletion = TabExpansion2 -inputScript $line.Remove($cursorColumn, 5) -cursorColumn $cursorColumn
                $commandCompletion.CompletionMatches | Should -HaveCount 1
                $commandCompletion.CompletionMatches.CompletionText | Should -BeExactly @('''System.Object`[`]''')
            }

            It "ff -TypeName 'System.Object``[``]', System.Object" {
                $line = "ff -InputObject ($ObjectDefinition) -TypeName 'System.Object``[``]', System.Object<Tab>"
                $cursorColumn = $line.IndexOf('<Tab>')
                $commandCompletion = TabExpansion2 -inputScript $line.Remove($cursorColumn, 5) -cursorColumn $cursorColumn
                $commandCompletion.CompletionMatches | Should -HaveCount 1
                $commandCompletion.CompletionMatches.CompletionText | Should -BeExactly @('System.Object')
            }
        }
    }
}
