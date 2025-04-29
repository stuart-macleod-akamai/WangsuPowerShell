function Get-WangsuPropertyDeployment {
    [CmdletBinding(DefaultParameterSetName = 'all-name')]
    Param (
        [Parameter(ParameterSetName = 'single')]
        [string]
        $DeploymentID,
        
        [Parameter(ParameterSetName = 'all-name', Mandatory)]
        [string]
        $PropertyName,
        
        [Parameter(ParameterSetName = 'all-id', Mandatory)]
        [int]
        $PropertyID,
        
        [Parameter(ParameterSetName = 'all-name')]
        [Parameter(ParameterSetName = 'all-id')]
        [ValidateSet('PENDING', 'IN_PROCESS', 'SUCCESS', 'FAIL')]
        [string]
        $Status,

        [Parameter(ParameterSetName = 'all-name')]
        [Parameter(ParameterSetName = 'all-id')]
        [ValidateSet('staging', 'production')]
        [string]
        $Target,

        [Parameter(ParameterSetName = 'all-name')]
        [Parameter(ParameterSetName = 'all-id')]
        [int]
        $Offset,

        [Parameter(ParameterSetName = 'all-name')]
        [Parameter(ParameterSetName = 'all-id')]
        [ValidateRange(0, 200)]
        [int]
        $Limit,

        [Parameter(ParameterSetName = 'all-name')]
        [Parameter(ParameterSetName = 'all-id')]
        [ValidateSet('asc', 'desc ')]
        [string]
        $SortOrder,
        
        [Parameter(ParameterSetName = 'all-name')]
        [Parameter(ParameterSetName = 'all-id')]
        [ValidateSet('submissionTime', 'lastUpdateTime')]
        [string]
        $SortBy,

        [Parameter()]
        [string]
        $WangsuRCFile
    )

    $QueryParams = @{}
    if ($DeploymentID) {
        $Path = "/api/properties/deployments/$DeploymentID"
    }
    else {
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
        if ($PropertyID) { $QueryParams.propertyId = $PropertyID }
        if ($Status) { $QueryParams.status = $Status }
        if ($Target) { $QueryParams.target = $Target }
        if ($PSBoundParameters.Offset) { $QueryParams.offset = $Offset }
        if ($PSBoundParameters.Limit) { $QueryParams.limit = $Limit }
        if ($SortOrder) { $QueryParams.sortOrder = $SortOrder }
        if ($SortBy) { $QueryParams.sortBy = $SortBy }
    }

    $RequestParams = @{
        'Path'            = $Path
        'Method'          = 'GET'
        'WangsuRCFile'    = $WangsuRCFile
        'QueryParameters' = $QueryParams
    }

    $Response = Invoke-WangsuRequest @RequestParams
    if ($DeploymentID) {
        return $Response.data
    }
    else {
        return $Response.data.deployments
    }
}