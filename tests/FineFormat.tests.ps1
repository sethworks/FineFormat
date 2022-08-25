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
            $result.PSObject.Properties.Value | Should -BeExactly @('String', '512', "512${ds}26", '1 KB', "1${ds}91 MB", "2${ds}79 GB", "3${ds}64 TB", "4${ds}44 PB", "5329${ds}07 PB")
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
            $result.PSObject.Properties.Value | Should -BeExactly @('String', '512', "512${ds}26", '1 KB', "1${ds}91 MB", "2${ds}79 GB", "3${ds}64 TB", "4${ds}44 PB", "5${gs}329${ds}07 PB")
        }
    }

    Context "-NumbersAs KB" {

        BeforeAll {
            $result = $Object2 | ff -NumbersAs KB
        }

        It "Has 9 properties" {
            $result.PSObject.Properties | Should -HaveCount 9
        }

        It "Has correct properties" {
            $result.PSObject.Properties.Name | Should -BeExactly @('st', 'pl', 'fl', 'kb', 'mb', 'gb', 'tb', 'pb', 'eb')
        }

        It "Has correct values" {
            $result.PSObject.Properties.Value | Should -BeExactly @('String', '512', "512${ds}26", '1 KB', "1953${ds}13 KB", "2929687${ds}5 KB", "3906250000 KB", "4882812500000 KB", "5859375000000000 KB")
        }
    }

    Context "-NumbersAs KB cim" -Skip:($IsLinux -or $IsMacOS) {

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
            $result = $Object2 | ff -NumbersAs MB
        }

        It "Has 9 properties" {
            $result.PSObject.Properties | Should -HaveCount 9
        }

        It "Has correct properties" {
            $result.PSObject.Properties.Name | Should -BeExactly @('st', 'pl', 'fl', 'kb', 'mb', 'gb', 'tb', 'pb', 'eb')
        }

        It "Has correct values" {
            $result.PSObject.Properties.Value | Should -BeExactly @('String', '512', "512${ds}26", '1024', "1${ds}91 MB", "2861${ds}02 MB", "3814697${ds}27 MB", "4768371582${ds}03 MB", "5722045898437${ds}5 MB")
        }
    }

    Context "-NumbersAs MB cim" -Skip:($IsLinux -or $IsMacOS) {

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
            $result = $Object2 | ff -NumbersAs GB
        }

        It "Has 6 properties" {
            $result.PSObject.Properties | Should -HaveCount 9
        }

        It "Has correct properties" {
            $result.PSObject.Properties.Name | Should -BeExactly @('st', 'pl', 'fl', 'kb', 'mb', 'gb', 'tb', 'pb', 'eb')
        }

        It "Has correct values" {
            $result.PSObject.Properties.Value | Should -BeExactly @('String', '512', "512${ds}26", '1024', "2000000", "2${ds}79 GB", "3725${ds}29 GB", "4656612${ds}87 GB", "5587935447${ds}69 GB")
        }
    }

    Context "-NumbersAs GB cim" -Skip:($IsLinux -or $IsMacOS) {

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
            $result = $Object2 | ff -NumbersAs TB
        }

        It "Has 9 properties" {
            $result.PSObject.Properties | Should -HaveCount 9
        }

        It "Has correct properties" {
            $result.PSObject.Properties.Name | Should -BeExactly @('st', 'pl', 'fl', 'kb', 'mb', 'gb', 'tb', 'pb', 'eb')
        }

        It "Has correct values" {
            $result.PSObject.Properties.Value | Should -BeExactly @('String', '512', "512${ds}26", '1024', '2000000', '3000000000', "3${ds}64 TB", "4547${ds}47 TB", "5456968${ds}21 TB")
        }
    }

    Context "-NumbersAs PB" {

        BeforeAll {
            $result = $Object2 | ff -NumbersAs PB
        }

        It "Has 9 properties" {
            $result.PSObject.Properties | Should -HaveCount 9
        }

        It "Has correct properties" {
            $result.PSObject.Properties.Name | Should -BeExactly @('st', 'pl', 'fl', 'kb', 'mb', 'gb', 'tb', 'pb', 'eb')
        }

        It "Has correct values" {
            $result.PSObject.Properties.Value | Should -BeExactly @('String', '512', "512${ds}26", '1024', '2000000', '3000000000', '4000000000000', "4${ds}44 PB", "5329${ds}07 PB")
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