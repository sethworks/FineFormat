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

### Default (Default)
```
Format-Fine [-InputObject] <Object> [-HasValue] [-Value <PSObject[]>] [-TypeName <String[]>] [-CompactNumbers]
 [-NumbersAs <String>] [-NumberGroupSeparator] [-NumericTypes] [-SymbolicTypes] [-Boolean]
 [-ValueFilter <ScriptBlock>] [-TypeNameFilter <ScriptBlock>] [<CommonParameters>]
```

### NoValue
```
Format-Fine [-InputObject] <Object> [-TypeName <String[]>] [-NoValue] [-NumericTypes] [-SymbolicTypes]
 [-Boolean] [-TypeNameFilter <ScriptBlock>] [<CommonParameters>]
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
Parameter Sets: Default
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
Type: PSObject[]
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -TypeName
Specifies the type names of properties to filter on.

Supports wildcards.

```yaml
Type: String[]
Parameter Sets: (All)
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -CompactNumbers
Displays numbers as Kilo, Mega, Giga, Tera, or Peta depending on the magnitude of the number.

If the number is smaller than 1K, it is displayed without conversion.

It differs from the -NumbersAs parameter in the way, that -NumbersAs parameter uses the specified units (Kilo, Mega, etc.), and -CompactNumbers determines the proper unit based on the number's magnitude.

This parameter has priority over the -NumbersAs parameter.

```yaml
Type: SwitchParameter
Parameter Sets: Default
Aliases:

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NumbersAs
Displays numbers as Kilo, Mega, Giga, Tera, or Peta.

If the number is smaller than the specified value, it is displayed without conversion.

It differs from the -CompactNumbers parameter in the way, that -NumbersAs parameter uses the specified units (Kilo, Mega, etc.), and -CompactNumbers determines the proper unit based on the number's magnitude.

The -CompactNumbers parameter has priority over this parameter.

```yaml
Type: String
Parameter Sets: Default
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
Parameter Sets: Default
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
Parameter Sets: NoValue
Aliases: NullOrEmpty

Required: False
Position: Named
Default value: None
Accept pipeline input: False
Accept wildcard characters: False
```

### -NumericTypes
Specifies that the result should include properties with numberic data types (Int, Double, etc.).

The effect of using -NumericTypes, -SymbolicTypes, and -Boolean parameters is cumulative.

If used alone - only the properties that have numeric values (Int, Double, etc.) will be displayed.

If used together with -SymbolicTypes and -Boolean parameters - the result will include properties with Numeric, Symbolic, and Boolean data types.

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
Specifies that the result should include properties with symbolic data types (String, Char).

The effect of using -NumericTypes, -SymbolicTypes, and -Boolean parameters is cumulative.

If used alone - only the properties that have symbolic values (String, Char) will be displayed.

If used together with -NumericTypes and -Boolean parameters - the result will include properties with Numeric, Symbolic, and Boolean data types.

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

### -Boolean
Specifies that the result should include properties with Boolean data types.

The effect of using -NumericTypes, -SymbolicTypes, and -Boolean parameters is cumulative.

If used alone - only the properties that have Boolean values will be displayed.

If used together with -NumericTypes and -SymbolicTypes parameters - the result will include properties with Numeric, Symbolic, and Boolean data types.

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
Parameter Sets: Default
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

### Example 3: Properties of specified types
```powershell
Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -Filter "Index=10" | ff -TypeName string, *int, 'ushort`[`]'
```

```
Caption                      : [00000010] Hyper-V Virtual Switch Extension Adapter
Description                  : Hyper-V Virtual Switch Extension Adapter
SettingID                    : {9DB15731-C0BE-421E-B21E-F3BDA6B18D6B}
DatabasePath                 :
DHCPServer                   :
DNSDomain                    :
DNSHostName                  :
ForwardBufferMemory          :
GatewayCostMetric            :
Index                        : 10
InterfaceIndex               : 3
...
```

Get only the properties of specific data types.

### Example 4: Properties that have $null or empty values
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

### Example 5: Properties that have values of numeric types
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

### Example 6: Properties that have values of symbolic types
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

### Example 7: Properties that have values of Boolean types
```powershell
Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -Filter "Index=10" | ff -Boolean
```

```
ArpAlwaysSourceRoute         :
ArpUseEtherSNAP              :
DeadGWDetectEnabled          :
DHCPEnabled                  : False
DNSEnabledForWINSResolution  :
DomainDNSRegistrationEnabled :
FullDNSRegistrationEnabled   :
IPEnabled                    : False
IPFilterSecurityEnabled      :
IPPortSecurityEnabled        :
IPUseZeroBroadcast           :
IPXEnabled                   :
PMTUBHDetectEnabled          :
PMTUDiscoveryEnabled         :
TcpUseRFC1122UrgentPointer   :
WINSEnableLMHostsLookup      :
```

Get only the properties that have values of Boolean type.

### Example 8: Properties that have values of numeric, symbolic, or Boolean types
```powershell
Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -Filter "Index=10" | ff -NumericTypes -SymbolicTypes -Boolean
```

```
Caption                      : [00000010] Hyper-V Virtual Switch Extension Adapter
Description                  : Hyper-V Virtual Switch Extension Adapter
SettingID                    : {9DB15731-C0BE-421E-B21E-F3BDA6B18D6B}
ArpAlwaysSourceRoute         :
ArpUseEtherSNAP              :
DatabasePath                 :
DeadGWDetectEnabled          :
DHCPEnabled                  : False
DHCPServer                   :
DNSDomain                    :
DNSEnabledForWINSResolution  :
DNSHostName                  :
DomainDNSRegistrationEnabled :
ForwardBufferMemory          :
FullDNSRegistrationEnabled   :
Index                        : 10
InterfaceIndex               : 3
IPConnectionMetric           :
IPEnabled                    : False
IPFilterSecurityEnabled      :
IPPortSecurityEnabled        :
...
```

Get only the properties that have values of numeric, symbolic, or Boolean type.

### Example 9: Compact numbers
```powershell
Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID='C:'" | ff -HasValue -NumericTypes -CompactNumbers
```

```
Access                 : 0
FreeSpace              : 53.73 G
Size                   : 199.51 G
DriveType              : 3
MaximumComponentLength : 255
MediaType              : 12
```

Display numbers in their most compact form using Kilo, Mega, Giga, Tera, and Peta units.

### Example 10: Display numbers as Mega
```powershell
Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID='C:'" | ff -HasValue -NumericTypes -NumbersAs Mega
```

```
Access                 : 0
FreeSpace              : 32128.93 M
Size                   : 204299.21 M
DriveType              : 3
MaximumComponentLength : 255
MediaType              : 12
```

Use the -NumbersAs parameter to display numbers as Mega.

### Example 11: Display numbers as Mega with group separator
```powershell
Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID='C:'" | ff -HasValue -NumericTypes -NumbersAs Mega -NumberGroupSeparator
```

```
Access                 : 0
FreeSpace              : 32,128.83 M
Size                   : 204,299.21 M
DriveType              : 3
MaximumComponentLength : 255
MediaType              : 12
```

Use the -NumbersAs and -NumberGroupSeparator parameters to display numbers as Mega with group separators.

### Example 12: Properties that have specific values
```powershell
Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -Filter "Index=10" | ff -ValueFilter {$PSItem -like "*adapter"}
```

```
Caption                                             Description
-------                                             -----------
[00000010] Hyper-V Virtual Switch Extension Adapter Hyper-V Virtual Switch Extension Adapter
```

Get only the properties that have specific values.

### Example 13: Properties of specified data type
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
