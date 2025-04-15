function Get-WangsuEdgeHostname {
    [CmdletBinding()]
    Param (
        [Parameter()]
        [string]
        $EdgeHostname
    )

    $Path = "/api/edge-hostnames"
    if ($EdgeHostname) {
        $Path = "/api/edge-hostnames/$EdgeHostname"
    }

    $RequestParams = @{
        'Path'   = $Path
        'Method' = 'GET'
    }

    $Response = Invoke-WangsuRequest @RequestParams
    if ($EdgeHostname) {
        return $Response.data
    }
    else {
        return $Response.data.edgeHostnames
    }
}