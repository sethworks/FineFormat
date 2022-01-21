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
Format-Fine [-InputObject] <Object> [-NotNullOrEmpty] [<CommonParameters>]
```

## DESCRIPTION
Командлет форматирует вывод команд с использованием различных условий.

Если командлет используется без указания каких-либо параметров, то он не оказывает никакого влияния на обрабатываемые объекты.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

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

### -NotNullOrEmpty
Параметр указывает, что отображаться должны только те свойства объектов, которые имеют значения, отличные от пустых или $null.

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

### CommonParameters
This cmdlet supports the common parameters: -Debug, -ErrorAction, -ErrorVariable, -InformationAction, -InformationVariable, -OutVariable, -OutBuffer, -PipelineVariable, -Verbose, -WarningAction, and -WarningVariable. For more information, see [about_CommonParameters](http://go.microsoft.com/fwlink/?LinkID=113216).

## INPUTS

### System.Object

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
