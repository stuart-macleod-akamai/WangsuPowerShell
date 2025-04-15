function Get-WangsuPropertyDeployment {
    [CmdletBinding()]
    Param (
        [Parameter()]
        [string]
        $DeploymentID,

        [Parameter()]
        [string]
        $WangsuRCFile = "~/.wangsurc.json"
    )

    $Path = '/api/properties/deployments'
    if ($PropertyID) {
        $Path = "/api/properties/deployments/$DeploymentID"
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
        return $Response.data.deployments
    }
}