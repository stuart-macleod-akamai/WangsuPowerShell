Get-ChildItem -Path $PSScriptRoot/Functions/ -Recurse -Filter *.ps1 | ForEach-Object { . $_.FullName }
