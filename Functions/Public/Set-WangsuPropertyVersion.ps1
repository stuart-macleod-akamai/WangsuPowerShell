function Set-WangsuPropertyVersion {
    [CmdletBinding()]
    Param (
        [Parameter(ParameterSetName = 'name')]
        [string]
        $PropertyName,
        
        [Parameter(ParameterSetName = 'id')]
        [int]
        $PropertyID,
        
        [Parameter(Mandatory)]
        [int]
        $Version,
        
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
            'Path'         = "/api/properties/$PropertyID/versions/$Version"
            'Method'       = 'POST'
            'Body'         = $Body
            'WangsuRCFile' = $WangsuRCFile
        }
    
        $Response = Invoke-WangsuRequest @RequestParams
        return $Response.data
    }
}