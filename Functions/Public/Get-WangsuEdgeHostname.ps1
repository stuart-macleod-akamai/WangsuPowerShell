function Get-WangsuEdgeHostname {
    [CmdletBinding()]
    Param (
        [Parameter()]
        [string]
        $EdgeHostname,

        [Parameter()]
        [string]
        $WangsuRCFile
    )

    $Path = "/api/edge-hostnames"
    if ($EdgeHostname) {
        $Path = "/api/edge-hostnames/$EdgeHostname"
    }

    $RequestParams = @{
        'Path'         = $Path
        'Method'       = 'GET'
        'WangsuRCFile' = $WangsuRCFile
    }

    $Response = Invoke-WangsuRequest @RequestParams
    if ($EdgeHostname) {
        return $Response.data
    }
    else {
        return $Response.data.edgeHostnames
    }
}