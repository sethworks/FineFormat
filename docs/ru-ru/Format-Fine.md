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

```
Format-Fine [-InputObject] <Object> [-HasValue] [-Value <PSObject>] [-CompactNumbers] [-NumberGroupSeparator] [-NoValue] [-NumbersAs <String>] [-NumericTypes] [-SymbolicTypes] [-ValueFilter <ScriptBlock>] [-TypeNameFilter <ScriptBlock>] [<CommonParameters>]
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
Parameter Sets: (All)
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
Отображает числа в виде KB, MB, GB, TB или PB в зависимости от их величины.

Если число меньше 1KB, то оно отображается без изменений.

Параметр отличается от параметра -NumbersAs в том, что параметр -NumbersAs использует указанные единицы измерения (KB, MB и т. д.), а параметр -CompactNumbers определяет подходящий вариант на основе величины числа.

Этот параметр имеет приоритет перед параметром -NumbersAs.

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
Отображает числа с разделителями групп цифр.

Символ разделителя зависит от региональных настроек.

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
Параметр указывает, что отображаться должны только те свойства объектов, значения которых пусты или равны $null.

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
Отображает числа в виде KB, MB, GB, TB или PB.

Если число меньше, чем указанная единица измерения, то оно отображается без изменений.

Параметр отличается от параметра -CompactNumbers в том, что параметр -NumbersAs использует указанные единицы измерения (KB, MB и т. д.), а параметр -CompactNumbers определяет подходящий вариант на основе величины числа.

Параметр -CompactNumbers имеет приоритет перед этим параметром.

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
Параметр указывает, что отображаться должны только те свойства объектов, значения которых являются числовым типом (Int, Double и т. д.).

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
Параметр указывает, что отображаться должны только те свойства объектов, значения которых являются символьным типом (String, Char).

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
Parameter Sets: (All)
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

### Example 3: Свойства, значения которых пусты или равны $null
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

### Example 4: Свойства, значения которых являются числовым типом
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

### Example 5: Свойства, значения которых являются символьным типом
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

### Example 6: Отображение чисел с разделителями групп
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

Использование параметра -NumberGroupSeparator для отображения чисел с разделителями групп.

### Example 7: Отображение чисел в виде MB
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

Использование параметра -NumbersAs для отображения чисел в виде MB.

### Example 8: Отображение чисел в наиболее компактной форме
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

Отображение чисел в их наиболее компактной форме с использованием таких единиц измерения, как KB, MB, GB, TB и PB.

### Example 9: Свойства с заданными значениями
```powershell
Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -Filter "Index=10" | ff -ValueFilter {$PSItem -like "*adapter"}
```

```
Caption                                             Description
-------                                             -----------
[00000010] Hyper-V Virtual Switch Extension Adapter Hyper-V Virtual Switch Extension Adapter
```

Получение только тех свойств, чьи значения соответствуют условию.

### Example 10: Свойства заданного типа
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
