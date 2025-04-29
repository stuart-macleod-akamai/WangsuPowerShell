function Get-WangsuPropertyVersion {
    [CmdletBinding(DefaultParameterSetName = 'name')]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'name')]
        [string]
        $PropertyName,
        
        [Parameter(Mandatory, ParameterSetName = 'id')]
        [int]
        $PropertyID,
        
        [Parameter()]
        [int]
        $Version,

        [Parameter()]
        [string]
        $WangsuRCFile
    )

    if ($PropertyName) {
        $Property = Get-WangsuProperty | Where-Object propertyName -eq $PropertyName
        if ($Property) {
            $PropertyID = $Property.propertyId
        }
        else {
            throw "Property $PropertyName not found"
        }
    }

    $Path = "/api/properties/$PropertyID/versions"
    if ($Version) {
        $Path = "/api/properties/$PropertyID/versions/$Version"
    }

    $RequestParams = @{
        'Path'         = $Path
        'Method'       = 'GET'
        'WangsuRCFile' = $WangsuRCFile
    }

    $Response = Invoke-WangsuRequest @RequestParams
    if ($Version) {
        return $Response.data
    }
    else {
        return $Response.data.propertyVersions
    }
}