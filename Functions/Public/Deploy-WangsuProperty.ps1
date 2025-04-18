function Deploy-WangsuProperty {
    [CmdletBinding()]
    Param (
        [Parameter(ParameterSetName = 'name')]
        [string]
        $PropertyName,
        
        [Parameter(ParameterSetName = 'id')]
        [int]
        $PropertyID,
        
        [Parameter(Mandatory)]
        [string]
        $Version,

        [Parameter()]
        [ValidateSet('staging', 'production')]
        [string]
        $Target,

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
        
        $Path = '/api/properties/deployments'
        $Body = @{
            'target'  = $Target
            'actions' = @(
                @{
                    'action'     = 'deploy_property'
                    'propertyId' = $PropertyID
                    'version'    = $Version
                }
            )
        }
    
        $RequestParams = @{
            'Path'         = $Path
            'Method'       = 'POST'
            'Body'         = $Body
            'WangsuRCFile' = $WangsuRCFile
        }
    
        $Response = Invoke-WangsuRequest @RequestParams
        return $Response.data
    }
}