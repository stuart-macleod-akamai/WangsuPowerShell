function Deploy-WangsuEdgeHostname {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [string]
        $EdgeHostname,

        [Parameter()]
        [string]
        $WangsuRCFile
    )

    $Path = "/api/edge-hostnames/$EdgeHostname/deploy"

    $RequestParams = @{
        'Path'         = $Path
        'Method'       = 'POST'
        'WangsuRCFile' = $WangsuRCFile
    }

    $Response = Invoke-WangsuRequest @RequestParams
    return $Response
}