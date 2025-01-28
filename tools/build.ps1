#------------------------------------------------------------------------
#
#	Name: build.ps1
#	Author: S Macleod
#	Purpose: Update module manifest with new functions and version
#	Date: 27/01/2025
#	Version: 1
#
#------------------------------------------------------------------------

param(
    [Parameter()]
    $Version
)

$ModuleDirectory = "$PSScriptRoot/../"
$ModuleName = 'ChinaPowerShell'

# Clear previously loaded modules.
if ( (Get-Module $ModuleName) ) {
    Remove-Module $ModuleName
}

Write-Host -ForegroundColor Cyan "Building module $ModuleName"
    
$ModuleFile = Get-ChildItem $ModuleDirectory/*.psm1
$DataFile = Get-ChildItem $ModuleDirectory/*.psd1
Import-Module $ModuleFile -Force
    
$PS1Files = Get-ChildItem -Path $ModuleDirectory/Functions/ -Recurse -Filter *.ps1
$Aliases = New-Object -TypeName System.Collections.ArrayList
foreach ($File in $PS1Files) {
    try {
        $Alias = Get-Alias -Definition $File.baseName -ErrorAction Stop
        if ($Alias) {
            $Aliases.Add($Alias.Name) | Out-Null
        }
    }
    catch {
    
    }
}
    
$Params = @{
    Path              = $DataFile
    FunctionsToExport = $PS1Files.BaseName
    AliasesToExport   = $Aliases
    CmdletsToExport   = @()
    Copyright         = '(c) 2025 Akamai Technologies. All rights reserved.'
    Author            = 'Akamai Technologies Ltd.'
}
    
if ($Version) {
    $Params.ModuleVersion = $Version
}
    
Update-ModuleManifest @Params

# Finally remove all modules to force reload of new data from saved file
Remove-Module $ModuleName
Import-Module $DataFile -Force

Write-Host -ForegroundColor Green 'Process complete'

