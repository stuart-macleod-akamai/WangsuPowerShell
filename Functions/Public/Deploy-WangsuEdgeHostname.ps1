function Deploy-WangsuEdgeHostname {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [string]
        $EdgeHostname
    )

    $Path = "/api/edge-hostnames/$EdgeHostname/deploy"

    $RequestParams = @{
        'Path'   = $Path
        'Method' = 'POST'
    }

    $Response = Invoke-WangsuRequest @RequestParams
    return $Response.data
}