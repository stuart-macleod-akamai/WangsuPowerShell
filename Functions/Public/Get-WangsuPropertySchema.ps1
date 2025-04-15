function Get-WangsuPropertySchema {
    [CmdletBinding()]
    Param (
        [Parameter()]
        [string]
        $WangsuRCFile = "~/.wangsurc.json"
    )

    $Path = '/api/properties/schema'

    $RequestParams = @{
        'Path'         = $Path
        'Method'       = 'GET'
        'WangsuRCFile' = $WangsuRCFile
    }

    $Response = Invoke-WangsuRequest @RequestParams
    return $Response.data
}