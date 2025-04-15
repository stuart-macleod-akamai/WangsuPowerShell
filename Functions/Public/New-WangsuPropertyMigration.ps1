function New-WangsuPropertyMigration {
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
        $PropertyComment,
        
        [Parameter()]
        [string]
        $VersionComment,

        [Parameter()]
        [string]
        $AkamaiMainAccount,

        [Parameter()]
        [string]
        $AkamaiContractID,

        [Parameter()]
        [string]
        $AkamaiGroupID,

        [Parameter()]
        [string]
        $AkamaiGroupName,

        [Parameter()]
        [string]
        $AkamaiParentGroupID,

        [Parameter()]
        [string]
        $AkamaiParentGroupName,

        [Parameter()]
        [string]
        $WangsuRCFile = "~/.wangsurc.json"
    )

    if ($Rules -isnot 'String') {
        $Rules = $Rules | ConvertTo-Json -Depth 100
    }

    $Body = @{
        'propertyName' = $PropertyName
        'akProperty'   = $Rules
        'serviceType'  = $ServiceType
        'hostnames'    = @($Hostnames)
    }

    $AdditionalHeaders = @{}
    if ($AkamaiContractID) {
        $AdditionalHeaders.'x-ak-akamai-contract-id' = $AkamaiContractID
    }
    if ($AkamaiMainAccount) {
        $AdditionalHeaders.'x-ak-customer-main-account' = $AkamaiMainAccount
    }
    if ($AkamaiParentGroupID) {
        $AdditionalHeaders.'x-ak-parent-group-id' = $AkamaiParentGroupID
    }
    if ($AkamaiParentGroupName) {
        $AdditionalHeaders.'x-ak-parent-group-name' = $AkamaiParentGroupName
    }
    if ($AkamaiGroupID) {
        $AdditionalHeaders.'x-ak-group-id' = $AkamaiGroupID
    }
    if ($AkamaiGroupName) {
        $AdditionalHeaders.'x-ak-group-name' = $AkamaiGroupName
    }

    $RequestParams = @{
        'Path'              = '/api/properties/migration'
        'Method'            = 'POST'
        'Body'              = $Body
        'AdditionalHeaders' = $AdditionalHeaders
        'WangsuRCFile'      = $WangsuRCFile
    }

    $Response = Invoke-WangsuRequest @RequestParams
    return $Response.data
}