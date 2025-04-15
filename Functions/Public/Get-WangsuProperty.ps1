function Get-WangsuProperty {
    [CmdletBinding(DefaultParameterSetName = '__AllParameterSets')]
    Param (
        [Parameter(ParameterSetName = 'name')]
        [string]
        $PropertyName,
        
        [Parameter(ParameterSetName = 'id')]
        [int]
        $PropertyID,

        [Parameter()]
        [string]
        $WangsuRCFile = "~/.wangsurc.json"
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
    
        $Path = '/api/properties'
        if ($PropertyID) {
            $Path = "/api/properties/$PropertyID"
        }
    
        $RequestParams = @{
            'Path'         = $Path
            'Method'       = 'GET'
            'WangsuRCFile' = $WangsuRCFile
        }
    
        $Response = Invoke-WangsuRequest @RequestParams
        if ($PropertyID) {
            return $Response.data
        }
        else {
            return $Response.data.Properties
        }
    }
}