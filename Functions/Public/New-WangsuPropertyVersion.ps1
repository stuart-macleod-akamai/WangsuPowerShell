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