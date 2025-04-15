function Get-WangsuPropertySchema {
    [CmdletBinding()]
    Param (
        [Parameter()]
        [string]
        $PropertyID
    )

    $Path = '/api/properties/schema'

    $RequestParams = @{
        'Path'   = $Path
        'Method' = 'GET'
    }

    $Response = Invoke-WangsuRequest @RequestParams
    return $Response.data
}