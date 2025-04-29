# Wangsu PowerShell

PowerShell functions for Wangsu CDN.

## Authentication

The functions in this module all read auth info from a JSON file in the following format:

```json
{
    "accessKey": "sdfkjslkdjfnlkzdjsn",
    "secretKey": "erfghubierovbseriuvnlosdivrunlsdirjvnlrijnv"
}
```

The default location for this file is `~/.wangsurc.json`, but you can override this by adding `-WangsuRCFile /path/to/file` to any command. Even so, it is recommended for simplicity to simply set your Wangsu credentials in the default file path.

## Usage

To use this module you will need to manually import it. To do so, open PowerShell (`pwsh`), navigate to this directory, then run:

```powershell
Import-Module ./Wangsu.psd1
```

To get a list of supported commands run:

```powershell
Get-Command -Module Wangsu
```

The output will look similar to this.

```powershell
❯_  get-command -Module Wangsu

CommandType     Name                                               Version    Source
-----------     ----                                               -------    ------
Function        Deploy-WangsuEdgeHostname                          0.0.1      Wangsu
Function        Deploy-WangsuProperty                              0.0.1      Wangsu
Function        Disable-WangsuProperty                             0.0.1      Wangsu
Function        Format-AkamaiProperty                              0.0.1      Wangsu
Function        Format-AkamaiRule                                  0.0.1      Wangsu
Function        Get-WangsuEdgeHostname                             0.0.1      Wangsu
Function        Get-WangsuProperty                                 0.0.1      Wangsu
Function        Get-WangsuPropertyDeployment                       0.0.1      Wangsu
Function        Get-WangsuPropertySchema                           0.0.1      Wangsu
Function        Get-WangsuPropertyVersion                          0.0.1      Wangsu
Function        Invoke-WangsuRequest                               0.0.1      Wangsu
Function        New-WangsuProperty                                 0.0.1      Wangsu
Function        New-WangsuPropertyMigration                        0.0.1      Wangsu
Function        New-WangsuPropertyVersion                          0.0.1      Wangsu
Function        Remove-WangsuProperty                              0.0.1      Wangsu
Function        Set-WangsuPropertyVersion                          0.0.1      Wangsu
Function        Test-WangsuProperty                                0.0.1      Wangsu
```