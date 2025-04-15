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
        $Target
    )

    process {
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
            'Path'   = $Path
            'Method' = 'POST'
            'Body'   = $Body
        }
    
        $Response = Invoke-WangsuRequest @RequestParams
        return $Response.data
    }
}