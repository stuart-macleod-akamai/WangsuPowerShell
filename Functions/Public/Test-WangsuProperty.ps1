function Test-WangsuProperty {
    [CmdletBinding()]
    Param (
        [Parameter(ParameterSetName = 'name')]
        [string]
        $PropertyName,
        
        [Parameter(ParameterSetName = 'id')]
        [int]
        $PropertyID,
        
        [Parameter(Mandatory)]
        [int]
        $PropertyVersion,

        [Parameter(Mandatory)]
        $Rules,
        
        [Parameter()]
        [string]
        $AccountID,
        
        [Parameter()]
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

    if ($PropertyName) {
        $Property = Get-WangsuProperty | Where-Object propertyName -eq $PropertyName
        if ($Property) {
            $PropertyID = $Property.propertyId
        }
        else {
            throw "Property $PropertyName not found"
        }
    }
    
    $Body = @{
        'propertyId'      = $PropertyID
        'propertyVersion' = $PropertyVersion
        'rules'           = $Rules
    }
    if ($AccountID) {
        $Body.accountId = $AccountID
    }
    if ($Hostnames) {
        $Body.hostnames = $Hostnames
    }
    if ($Origins) {
        $Body.origins = $Origins
    }
    if ($Variables) {
        $Body.variables = $Variables
    }

    $RequestParams = @{
        'Path'         = '/api/properties/validate'
        'Method'       = 'POST'
        'Body'         = $Body
        'WangsuRCFile' = $WangsuRCFile
    }

    $Response = Invoke-WangsuRequest @RequestParams
    return $Response.data
}