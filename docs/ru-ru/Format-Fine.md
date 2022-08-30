---
external help file: FineFormat-help.xml
Module Name: fineFormat
online version:
schema: 2.0.0
---

# Format-Fine

## SYNOPSIS
Форматирует и фильтрует вывод.

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
Командлет используется для форматирования и фильтрации вывода с использованием различных условий.

Если командлет используется без указания параметров, то он не оказывает никакого влияния на обрабатываемые объекты.

Командлет также можно вызвать с использованием его алиаса: ff.

## PARAMETERS

### -InputObject
Задает объекты для обработки.

Этот параметр поддерживает получение объектов по конвейеру.

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
Параметр указывает, что отображаться должны только те свойства объектов, которые имеют значения, отличные от пустых или $null.

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
Параметр задает значения свойств объектов для использования в качестве фильтра.

Поддерживает символы подстановки.

Устанавливает параметр -HasValue в $True.

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
Параметр задает типы данных свойств объектов для использования в качестве фильтра.

Поддерживает символы подстановки.

Поддерживает завершение ввода по клавише Tab. Например:

Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration | ff -TypeName <Tab>

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
Отображает числа в виде Kilo, Mega, Giga, Tera или Peta в зависимости от их величины.

Если число меньше 1K, то оно отображается без изменений.

Параметр отличается от параметра -NumbersAs в том, что параметр -NumbersAs использует указанные единицы измерения (Kilo, Mega и т. д.), а параметр -CompactNumbers определяет подходящий вариант на основе величины числа.

Этот параметр имеет приоритет перед параметром -NumbersAs.

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
Отображает числа в виде Kilo, Mega, Giga, Tera или Peta.

Если число меньше, чем указанная единица измерения, то оно отображается без изменений.

Параметр отличается от параметра -CompactNumbers в том, что параметр -NumbersAs использует указанные единицы измерения (Kilo, Mega и т. д.), а параметр -CompactNumbers определяет подходящий вариант на основе величины числа.

Параметр -CompactNumbers имеет приоритет перед этим параметром.

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
Отображает числа с разделителями групп цифр.

Символ разделителя зависит от региональных настроек.

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
Параметр указывает, что отображаться должны только те свойства объектов, значения которых пусты или равны $null.

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
Параметр указывает, что результат должен включать в себя свойства объектов, значения которых являются числовым типом (Int, Double и т. д.).

Параметры -NumericTypes, -SymbolicTypes и -Boolean обладают кумулятивным эффектом.

Если указан только этот параметр - отобразятся только те свойства объектов, значения которых являются числовым типом (Int, Double и т. д.).

Если параметр указан вместе с параметрами -SymbolicTypes и -Boolean - результат будет включать в себя свойства с числовыми, символьными значениями и значениями типа Boolean.

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
Параметр указывает, что результат должен включать в себя свойства объектов, значения которых являются символьным типом (String, Char).

Параметры -NumericTypes, -SymbolicTypes и -Boolean обладают кумулятивным эффектом.

Если указан только этот параметр - отобразятся только те свойства объектов, значения которых являются символьным типом (String, Char).

Если параметр указан вместе с параметрами -NumericTypes и -Boolean - результат будет включать в себя свойства с числовыми, символьными значениями и значениями типа Boolean.

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
Параметр указывает, что результат должен включать в себя свойства объектов, значения которых являются типом Boolean.

Параметры -NumericTypes, -SymbolicTypes и -Boolean обладают кумулятивным эффектом.

Если указан только этот параметр - отобразятся только те свойства объектов, значения которых являются типом Boolean.

Если параметр указан вместе с параметрами -NumericTypes и -SymbolicTypes - результат будет включать в себя свойства с числовыми, символьными значениями и значениями типа Boolean.

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
Задает скриптблок, который будет использоваться для фильтрации свойств по их значениям.

Например: -ValueFilter {$PSItem -like "somevalue"}

Устанавливает параметр -HasValue в $True.

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
Задает скриптблок, который будет использоваться для фильтрации свойств по типам данных.

Например: -TypeNameFilter {$PSItem -like "datatype"}

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

### Example 1: Свойства со значениями, отличными от пустых или $null
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

Получение только тех свойств объектов, которые имеют значения, отличные от пустых или $null.

### Example 2: Свойства, обладающие указанными значениями
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

Получение только тех свойств, значения которых соответствуют указанным.

### Example 3: Свойства заданного типа
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

Получение только тех свойств, чей тип данных соответствует условию.

### Example 4: Свойства, значения которых пусты или равны $null
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

Получение только тех свойств объектов, значения которых пусты или равны $null.

### Example 5: Свойства, значения которых являются числовым типом
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

Получение только тех свойств объектов, значения которых являются числовым типом (Int, Double и т. д.).

### Example 6: Свойства, значения которых являются символьным типом
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

Получение только тех свойств объектов, значения которых являются символьным типом (String, Char).

### Example 7: Свойства, значения которых являются типом Boolean
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

Получение только тех свойств объектов, значения которых являются типом Boolean.

### Example 8: Свойства, значения которых являются числовым, символьным типом или типом Boolean
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

Получение только тех свойств объектов, значения которых являются числовым, символьным типом или типом Boolean.

### Example 9: Отображение чисел в наиболее компактной форме
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

Отображение чисел в их наиболее компактной форме с использованием таких величин, как Kilo, Mega, Giga, Tera и Peta.

### Example 10: Отображение чисел в виде Mega
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

Использование параметра -NumbersAs для отображения чисел в виде Mega.

### Example 11: Отображение чисел в виде Mega с разделителями групп
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

Использование параметров -NumbersAs и -NumberGroupSeparator для отображения чисел в виде Mega с разделителями групп.

### Example 12: Свойства с заданными значениями
```powershell
Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -Filter "Index=10" | ff -ValueFilter {$PSItem -like "*adapter"}
```

```
Caption                                             Description
-------                                             -----------
[00000010] Hyper-V Virtual Switch Extension Adapter Hyper-V Virtual Switch Extension Adapter
```

Получение только тех свойств, чьи значения соответствуют условию.

### Example 13: Свойства заданного типа
```powershell
Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -Filter "Index=10" | ff -HasValue -TypeNameFilter {$PSItem -like "*int"}
```

```
Index InterfaceIndex
----- --------------
   10              9
```

Получение только тех свойств, чей тип данных соответствует условию.

## INPUTS

### System.Object

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
