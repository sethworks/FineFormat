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

        $ObjectForCompaction = [PSCustomObject]@{
            pl = 512
            kb = 1024
            mb = 2000000
            gb = 3000000000
            tb = 4000000000000
            pb = 5000000000000000
        }

        $CimClassPhysicalMemory = Get-CimClass -ClassName Win32_PhysicalMemory
        $CimInstancePhysicalMemory = New-CimInstance -CimClass $CimClassPhysicalMemory -ClientOnly -Property @{FormFactor=8; Capacity=8589934592; DataWidth=64; InterleavePosition=1; MemoryType=24; Speed=1333; TotalWidth=64; Attributes=2; InterleaveDataDepth=1; SMBiosMemoryType=24; TypeDetail=128; Caption='Physical Memory'; Description='Physical Memory'; Name='Physical Memory'; Manufacturer='Kingston'; Tag='Physical Memory 0'; Banklabel='BANK 0'; DeviceLocator='ChannelA-DIMM0'}
        $CimClassLogicalDisk = Get-CimClass -ClassName Win32_LogicalDisk
        $CimInstanceLogicalDisk = New-CimInstance -CimClass $CimClassLogicalDisk -ClientOnly -Property @{DeviceID='C:'; Caption='C:'; Description='Local Fixed Disk'; Name='C:'; CreationClassName='Win32_LogicalDisk'; SystemCreationClassName='Win32_ComputerSystem'; Access=0; FreeSpace=57682386944; Size=214223253504; Compressed=$False; DriveType=3; FileSystem='NTFS'; MaximumComponentLength=255; MediaType=12; QuotasDisabled=$True; QuotasIncomplete=$False; QuotasRebuilding=$False; SupportsDiskQuotas=$True; SupportsFileBasedCompression=$True; VolumeDirty=$False; VolumeSerialNumber='1234ABCD'}

        $gs = (Get-Culture).NumberFormat.NumberGroupSeparator
        $ds = (Get-Culture).NumberFormat.NumberDecimalSeparator
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

    Context "-HasValue" {

        BeforeAll {
            $result = $SomeObject | Format-Fine -HasValue
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
            $result = $SomeObject | Format-Fine -NoValue
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

        Context "-Value string>" {

            BeforeAll {
                $result = $SomeObject | Format-Fine -Value "str"
            }

            It "Should be null" {
                $result | Should -BeNullOrEmpty
            }
        }

        Context "-Value *string*" {

            BeforeAll {
                $result = $SomeObject | Format-Fine -Value "*str*"
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
                $result = $SomeObject | Format-Fine -Value 15
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
                $result = $SomeObject | Format-Fine -Value 1*
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
                $result = $SomeObject | Format-Fine -Value $true
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
                $result = $SomeObject | Format-Fine -Value $false
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
                $result = $SomeObject | Format-Fine -Value "*str*", 1*
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
                $result = $SomeObject | Format-Fine -Value *
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

        Context "-TypeName uint" {

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
                $result = $SomeObject | Format-Fine -TypeName *
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

    Context "-NumericTypes" {

        BeforeAll {
            $result = $SomeObject | Format-Fine -NumericTypes
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

    Context "-NumericTypes 2" {

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
            $result = $SomeObject | Format-Fine -SymbolicTypes
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

    Context "-SymbolicTypes 2" {

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

    Context "-ValueFilter 2" {

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

    Context "-TypeNameFilter 2" {

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

    Context "-NumberGroupSeparator" {

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

    Context "-NumbersAs KB" {

        BeforeAll {
            $result = $CimInstanceLogicalDisk | ff -NumericTypes -HasValue -NumbersAs KB
        }

        It "Has 6 properties" {
            $result.PSObject.Properties | Should -HaveCount 6
        }

        It "Has correct properties" {
            $result.PSObject.Properties.Name | Should -BeExactly @('Access', 'FreeSpace', 'Size', 'DriveType', 'MaximumComponentLength', 'MediaType')
        }

        It "Has correct values" {
            $result.PSObject.Properties.Value | Should -BeExactly @('0', '56330456 KB', '209202396 KB', '3', '255', '12')
        }
    }

    Context "-NumbersAs MB" {

        BeforeAll {
            $result = $CimInstanceLogicalDisk | ff -NumericTypes -HasValue -NumbersAs MB
        }

        It "Has 6 properties" {
            $result.PSObject.Properties | Should -HaveCount 6
        }

        It "Has correct properties" {
            $result.PSObject.Properties.Name | Should -BeExactly @('Access', 'FreeSpace', 'Size', 'DriveType', 'MaximumComponentLength', 'MediaType')
        }

        It "Has correct values" {
            $result.PSObject.Properties.Value | Should -BeExactly @('0', "55010${ds}21 MB", "204299${ds}21 MB", '3', '255', '12')
        }
    }

    Context "-NumbersAs GB" {

        BeforeAll {
            $result = $CimInstanceLogicalDisk | ff -NumericTypes -HasValue -NumbersAs GB
        }

        It "Has 6 properties" {
            $result.PSObject.Properties | Should -HaveCount 6
        }

        It "Has correct properties" {
            $result.PSObject.Properties.Name | Should -BeExactly @('Access', 'FreeSpace', 'Size', 'DriveType', 'MaximumComponentLength', 'MediaType')
        }

        It "Has correct values" {
            $result.PSObject.Properties.Value | Should -BeExactly @('0', "53${ds}72 GB", "199${ds}51 GB", '3', '255', '12')
        }
    }

    Context "-NumbersAs TB" {

        BeforeAll {
            $result = $ObjectForCompaction | ff -NumbersAs TB
        }

        It "Has 6 properties" {
            $result.PSObject.Properties | Should -HaveCount 6
        }

        It "Has correct properties" {
            $result.PSObject.Properties.Name | Should -BeExactly @('pl', 'kb', 'mb', 'gb', 'tb', 'pb')
        }

        It "Has correct values" {
            $result.PSObject.Properties.Value | Should -BeExactly @('512', '1024', '2000000', '3000000000', "3${ds}64 TB", "4547${ds}47 TB")
        }
    }

    Context "-NumbersAs PB" {

        BeforeAll {
            $result = $ObjectForCompaction | ff -NumbersAs PB
        }

        It "Has 6 properties" {
            $result.PSObject.Properties | Should -HaveCount 6
        }

        It "Has correct properties" {
            $result.PSObject.Properties.Name | Should -BeExactly @('pl', 'kb', 'mb', 'gb', 'tb', 'pb')
        }

        It "Has correct values" {
            $result.PSObject.Properties.Value | Should -BeExactly @('512', '1024', '2000000', '3000000000', '4000000000000', "4${ds}44 PB")
        }
    }

    Context "-NumbersAs wrong value" {

        BeforeAll {
            $result = $ObjectForCompaction | ff -NumbersAs wrongvalue 3> $null
        }

        It "Has 6 properties" {
            $result.PSObject.Properties | Should -HaveCount 6
        }

        It "Has correct properties" {
            $result.PSObject.Properties.Name | Should -BeExactly @('pl', 'kb', 'mb', 'gb', 'tb', 'pb')
        }

        It "Has correct values" {
            $result.PSObject.Properties.Value | Should -BeExactly @('512', '1024', '2000000', '3000000000', '4000000000000', '5000000000000000')
        }
    }

    Context "-CompactNumbers" {

        BeforeAll {
            $result = $ObjectForCompaction  | ff -CompactNumbers
        }

        It "Has 6 properties" {
            $result.PSObject.Properties | Should -HaveCount 6
        }

        It "Has correct properties" {
            $result.PSObject.Properties.Name | Should -BeExactly @('pl', 'kb', 'mb', 'gb', 'tb', 'pb')
        }

        It "Has correct values" {
            $result.PSObject.Properties.Value | Should -BeExactly @('512', '1 KB', "1${ds}91 MB", "2${ds}79 GB", "3${ds}64 TB", "4${ds}44 PB")
        }
    }

}