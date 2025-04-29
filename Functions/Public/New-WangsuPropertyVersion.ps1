function New-WangsuPropertyVersion {
    [CmdletBinding(DefaultParameterSetName = 'name')]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'name')]
        [string]
        $PropertyName,
        
        [Parameter(Mandatory, ParameterSetName = 'id')]
        [int]
        $PropertyID,
        
        [Parameter(Mandatory, ValueFromPipeline)]
        [PSCustomObject]
        $Body,

        [Parameter()]
        [string]
        $WangsuRCFile
    )

    process {
        if ($PropertyName) {
            $Property = Get-WangsuProperty | Where-Object propertyName -eq $PropertyName
            if ($Property) {
                $PropertyID = $Property.propertyId
            }
            else {
                throw "Property $PropertyName not found"
            }
        }

        # Sanitize
        $TopLevelSanitizers = 'variables', 'origins'
        $RuleTypes = 'responsePhase', 'originPhase', 'requestPhase', 'cachePhase', 'connectPhase'
        
        foreach ($TopLevelObject in $TopLevelSanitizers) {
            $Body.$TopLevelObject | ForEach-Object {
                if ($_.id) {
                    $_.PSObject.Members.Remove('id')
                }
            }
        }

        foreach ($RuleType in $RuleTypes) {
            $Body.rules.$RuleType | ForEach-Object {
                if ($_.id) {
                    $_.PSObject.Members.Remove('id')
                }
            }
        }


        $RequestParams = @{
            'Path'         = "/api/properties/$PropertyID/versions"
            'Method'       = 'POST'
            'Body'         = $Body
            'WangsuRCFile' = $WangsuRCFile
        }
    
        $Response = Invoke-WangsuRequest @RequestParams
        return $Response.data
    }
}