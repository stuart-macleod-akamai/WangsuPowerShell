function Get-WangsuPropertyDeployment {
    [CmdletBinding()]
    Param (
        [Parameter()]
        [string]
        $DeploymentID
    )

    $Path = '/api/properties/deployments'
    if ($PropertyID) {
        $Path = "/api/properties/deployments/$DeploymentID"
    }

    $RequestParams = @{
        'Path'   = $Path
        'Method' = 'GET'
    }

    $Response = Invoke-WangsuRequest @RequestParams
    if ($PropertyID) {
        return $Response.data
    }
    else {
        return $Response.data.deployments
    }
}