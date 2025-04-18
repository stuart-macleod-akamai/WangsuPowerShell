function New-WangsuProperty {
    [CmdletBinding()]
    Param (
        [Parameter(Mandatory)]
        [string]
        $PropertyName,

        [Parameter(Mandatory)]
        $Rules,
        
        [Parameter(Mandatory)]
        [ValidateSet('wsa', 'wsa-https')]
        [string]
        $ServiceType,
        
        [Parameter(Mandatory)]
        $Hostnames,

        [Parameter()]
        [string]
        $Origins,
        
        [Parameter()]
        [string]
        $Variables,

        [Parameter()]
        [string]
        $WangsuRCFile
    )

    $Body = @{
        'propertyName' = $PropertyName
        'rules'        = $Rules
        'serviceType'  = $ServiceType
        'hostnames'    = $Hostnames
        'origins'      = $Origins
        'variables'    = $Variables
    }

    $RequestParams = @{
        'Path'         = '/api/properties'
        'Method'       = 'POST'
        'Body'         = $Body
        'WangsuRCFile' = $WangsuRCFile
    }

    $Response = Invoke-WangsuRequest @RequestParams
    return $Response.data
}