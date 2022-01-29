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

Can also be referred by its alias: ff.

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
Specifies that only the properties that have values other than $null or empty should be displayed.

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
Specifies that only the properties that have $null or empty values should be displayed.

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

## EXAMPLES

### Example 1: Properties that have values other than $null or empty
```powershell
Get-CimInstance -ClassName Win32_NetworkAdapterConfiguration -Filter "Index=10" | ff -NotNullOrEmpty
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

### Example 2: Properties that have $null or empty values
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

Get only the properties that have $null or empty values.

## INPUTS

### System.Object

## OUTPUTS

### System.Object
## NOTES

## RELATED LINKS
