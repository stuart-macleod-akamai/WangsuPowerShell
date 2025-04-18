function Remove-WangsuProperty {
    [CmdletBinding(DefaultParameterSetName = 'name')]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'name')]
        [string]
        $PropertyName,
        
        [Parameter(ParameterSetName = 'id', Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [int]
        $PropertyID,

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

        $Path = "/api/properties/$PropertyID"
        $RequestParams = @{
            'Path'         = $Path
            'Method'       = 'DELETE'
            'WangsuRCFile' = $WangsuRCFile
        }
    
        $Response = Invoke-WangsuRequest @RequestParams
        return $Response
    }
}
        