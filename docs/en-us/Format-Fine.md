---
external help file: FineFormat-help.xml
Module Name: fineFormat
online version:
schema: 2.0.0
---

# Format-Fine

## SYNOPSIS
Formats and filters the output.

## SYNTAX

```
Format-Fine [-InputObject] <Object> [-HasValue] [-Value <PSObject>] [-CompactNumbers] [-NumberGroupSeparator] [-NoValue] [-NumbersAs <String>] [-NumericTypes] [-SymbolicTypes] [-ValueFilter <ScriptBlock>] [-TypeNameFilter <ScriptBlock>] [<CommonParameters>]
```

## DESCRIPTION
Cmdlet formats and filters the output using various requirements.

If used without parameters, it does not change accepted objects in any way.

Can also be referred to by its alias: ff.

## PARAMETERS

### -InputObject
Specifies the input object.

This parameter supports accepting values from the pipeline.

```yaml
Type: Object
Parameter Sets: (All)
Aliases:

Required: True
Position: 0
Default value: None
Accept pipeline input: True (ByValue)
Accept wildcard characters: False
```

### -HasValue
Specifies that only the properties that have values other than $null or empty should be displayed.

Aliases: HaveValue, NotNullOrEmpty

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: HaveValue, NotNullOrEmpty

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -Value
Specifies the values of properties to filter on.

Supports wildcards.

Implies -HasValue.

```yaml
Type: PSObject
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CompactNumbers
Displays numbers as KB, MB, GB, TB, or PB depending on the magnitude of the number.

If the number is smaller than 1KB, it is displayed without conversion.

It differs from the -NumbersAs parameter in the way, that -NumbersAs parameter uses the specified units (KB, MB, etc.), and -CompactNumbers determines the proper unit based on the number's magnitude.

This parameter has priority over the -NumbersAs parameter.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NumberGroupSeparator
Displays numbers with group separators.

Group separator symbol depends on regional settings.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NoValue
Specifies that only the properties that have $null or empty values should be displayed.

Alias: NullOrEmpty

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: NullOrEmpty

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NumbersAs
Displays numbers as KB, MB, GB, TB, or PB.

If the number is smaller than the specified value, it is displayed without conversion.

It differs from the -CompactNumbers parameter in the way, that -NumbersAs parameter uses the specified units (KB, MB, etc.), and -CompactNumbers determines the proper unit based on the number's magnitude.

The -CompactNumbers parameter has priority over this parameter.

```yaml
Type: String
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NumericTypes
Specifies that only the properties that have numeric values (Int, Double, etc.) should be displayed.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -SymbolicTypes
Specifies that only the properties that have textual values (String, Char) should be displayed.

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -ValueFilter
Specifies scriptblock to be used for filtering by properties values.

For example: -ValueFilter {$PSItem -like "somevalue"}

Implies -HasValue.

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TypeNameFilter
Specifies scriptblock to be used for filtering by properties value type names.

For example: -TypeNameFilter {$PSItem -like "datatype"}

```yaml
Type: ScriptBlock
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## EXAMPLES

### Example 1: Properties that have values other than $null or empty
```powershell
Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -Filter "Index=10" | ff -HasValue
```

```
Caption               : [00000010] Hyper-V Virtual Switch Extension Adapter
Description           : Hyper-V Virtual Switch Extension Adapter
SettingID             : {946D7DBF-BE1D-4236-80AC-45892A467346}
DHCPEnabled           : False
Index                 : 10
InterfaceIndex        : 9
IPEnabled             : False
ServiceName           : VMSMP
CimClass              : root/cimv2:Win32_NetworkAdapterConfiguration
CimInstanceProperties : {Caption, Description, SettingID, ArpAlwaysSourceRoute…}
CimSystemProperties   : Microsoft.Management.Infrastructure.CimSystemProperties
```

Get only the properties that have values other than $null or empty.

### Example 2: Properties that have specified values
```powershell
Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -Filter "Index=10" | ff -Value *adapter, 3, $false
```

```
Caption        : [00000010] Hyper-V Virtual Switch Extension Adapter
Description    : Hyper-V Virtual Switch Extension Adapter
DHCPEnabled    : False
InterfaceIndex : 3
IPEnabled      : False
```

Get only the properties that have specified values.

### Example 3: Properties that have $null or empty values
```powershell
Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -Filter "Index=10" | ff -NoValue
```

```
ArpAlwaysSourceRoute         :
ArpUseEtherSNAP              :
DatabasePath                 :
DeadGWDetectEnabled          :
DefaultIPGateway             :
DefaultTOS                   :
DefaultTTL                   :
DHCPLeaseExpires             :
DHCPLeaseObtained            :
DHCPServer                   :
DNSDomain                    :
DNSDomainSuffixSearchOrder   :
...
```

Get only the properties that have $null or empty values.

### Example 4: Properties that have values of numeric types
```powershell
Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -Filter "Index=10" | ff -NumericTypes
```

```
ForwardBufferMemory          :
Index                        : 10
InterfaceIndex               : 9
IPConnectionMetric           :
IPXMediaType                 :
KeepAliveInterval            :
KeepAliveTime                :
MTU                          :
NumForwardPackets            :
TcpipNetbiosOptions          :
TcpMaxConnectRetransmissions :
TcpMaxDataRetransmissions    :
TcpNumConnections            :
TcpWindowSize                :
```

Get only the properties that have values of numeric types (Int, Double, etc.).

### Example 5: Properties that have values of symbolic types
```powershell
Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -Filter "Index=10" | ff -SymbolicTypes
```

```
Caption             : [00000010] Hyper-V Virtual Switch Extension Adapter
Description         : Hyper-V Virtual Switch Extension Adapter
SettingID           : {946D7DBF-BE1D-4236-80AC-45892A467346}
DatabasePath        :
DHCPServer          :
DNSDomain           :
DNSHostName         :
IPXAddress          :
IPXVirtualNetNumber :
MACAddress          :
ServiceName         : VMSMP
WINSHostLookupFile  :
WINSPrimaryServer   :
WINSScopeID         :
WINSSecondaryServer :
PSComputerName      :
```

Get only the properties that have values of symbolic types (String, Char).

### Example 6: Display numbers with group separator
```powershell
Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID='C:'" | ff -HasValue -NumericTypes -NumberGroupSeparator
```

```
Access                 : 0
FreeSpace              : 57,692,909,568
Size                   : 214,223,253,504
DriveType              : 3
MaximumComponentLength : 255
MediaType              : 12
```

Use the -NumberGroupSeparator parameter to display numbers with group separators.

### Example 7: Display numbers as MB
```powershell
Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID='C:'" | ff -HasValue -NumericTypes -NumberGroupSeparator -NumbersAs MB
```

```
Access                 : 0
FreeSpace              : 55,018.6 MB
Size                   : 204,299.21 MB
DriveType              : 3
MaximumComponentLength : 255
MediaType              : 12
```

Use the -NumbersAs parameter with the value of MB to display numbers as MB.

### Example 8: Compact numbers
```powershell
Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID='C:'" | ff -HasValue -NumericTypes -CompactNumbers
```

```
Access                 : 0
FreeSpace              : 53.73 GB
Size                   : 199.51 GB
DriveType              : 3
MaximumComponentLength : 255
MediaType              : 12
```

Display numbers in their most compact form using KB, MB, GB, TB, and PB units.

### Example 9: Properties that have specific values
```powershell
Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -Filter "Index=10" | ff -ValueFilter {$PSItem -like "*adapter"}
```

```
Caption                                             Description
-------                                             -----------
[00000010] Hyper-V Virtual Switch Extension Adapter Hyper-V Virtual Switch Extension Adapter
```

Get only the properties that have specific values.

### Example 10: Properties of specified data type
```powershell
Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -Filter "Index=10" | ff -HasValue -TypeNameFilter {$PSItem -like "*int"}
```

```
Index InterfaceIndex
----- --------------
   10              9
```

Get only the properties of specific data type.

## INPUTS

### System.Object

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
