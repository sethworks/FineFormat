---
external help file: FineFormat-help.xml
Module Name: fineFormat
online version:
schema: 2.0.0
---

# Format-Fine

## SYNOPSIS
Командлет форматирует вывод команд

## SYNTAX

```
Format-Fine [-InputObject] <Object> [-HaveValue] [-CompactNumbers] [-NumberGroupSeparator] [-NullOrEmpty] [-NumbersAs <String>] [-Numeric] [-Textual] [-ValueFilter <ScriptBlock>] [-TypeNameFilter <ScriptBlock>] [<CommonParameters>]
```

## DESCRIPTION
Командлет форматирует вывод команд с использованием различных условий.

Если командлет используется без указания каких-либо параметров, то он не оказывает никакого влияния на обрабатываемые объекты.

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

### -HaveValue
Параметр указывает, что отображаться должны только те свойства объектов, которые имеют значения, отличные от пустых или $null.

Alias: NotNullOrEmpty

```yaml
Type: SwitchParameter
Parameter Sets: (All)
Aliases: NotNullOrEmpty

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

### -NullOrEmpty
Параметр указывает, что отображаться должны только те свойства объектов, значения которых пусты или равны $null.

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

### -Numeric
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

### -Textual
Параметр указывает, что отображаться должны только те свойства объектов, значения которых являются текстовым типом (String, Char).

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
Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -Filter "Index=10" | ff -HaveValue
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

### Example 2: Свойства, значения которых пусты или равны $null
```powershell
Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -Filter "Index=10" | ff -NullOrEmpty
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

### Example 3: Свойства, значения которых являются числовым типом
```powershell
Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -Filter "Index=10" | ff -Numeric
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

Получение только тех свойств объектов, значения которых являются числовым типом.

### Example 4: Свойства, значения которых являются текстовым типом
```powershell
Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -Filter "Index=10" | ff -Textual
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

Получение только тех свойств объектов, значения которых являются текстовым типом.

### Example 5: Свойства с заданными значениями
```powershell
Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -Filter "Index=10" | ff -ValueFilter {$PSItem -like "*adapter"}
```

```
Caption                                             Description
-------                                             -----------
[00000010] Hyper-V Virtual Switch Extension Adapter Hyper-V Virtual Switch Extension Adapter
```

Получение только тех свойств, чьи значения соответствуют условию.

### Example 6: Свойства заданного типа
```powershell
Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -Filter "Index=10" | ff -HaveValue -TypeNameFilter {$PSItem -like "*int"}
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
