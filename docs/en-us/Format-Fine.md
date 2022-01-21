---
external help file: FineFormat-help.xml
Module Name: fineFormat
online version:
schema: 2.0.0
---

# Format-Fine

## SYNOPSIS
Formats commands output

## SYNTAX

```
Format-Fine [-InputObject] <Object> [-NotNullOrEmpty] [<CommonParameters>]
```

## DESCRIPTION
Cmdlet formats commands output using various requirements.

If used without any parameters, it does not change accepted objects in any way.

## EXAMPLES

### Example 1
```powershell
PS C:\> {{ Add example code here }}
```

{{ Add example description here }}

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

### -NotNullOrEmpty
Specifies, that only the properties, that have values other than $null or empty, should be displayed.

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
