function Get-WangsuPropertyDeployment {
    [CmdletBinding()]
    Param (
        [Parameter()]
        [string]
        $DeploymentID,

        [Parameter()]
        [string]
        $WangsuRCFile
    )

    $Path = '/api/properties/deployments'
    if ($DeploymentID) {
        $Path = "/api/properties/deployments/$DeploymentID"
    }

    $RequestParams = @{
        'Path'         = $Path
        'Method'       = 'GET'
        'WangsuRCFile' = $WangsuRCFile
    }

    $Response = Invoke-WangsuRequest @RequestParams
    if ($DeploymentID) {
        return $Response.data
    }
    else {
        return $Response.data.deployments
    }
}