function Remove-WangsuProperty {
    [CmdletBinding(DefaultParameterSetName = 'name')]
    Param (
        [Parameter(Mandatory, ParameterSetName = 'name')]
        [string]
        $PropertyName,
        
        [Parameter(ParameterSetName = 'id', Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [int]
        $PropertyID,

        [Parameter()]
        [string]
        $WangsuRCFile = "~/.wangsurc.json"
    )

    process {
        $Path = "/api/properties/$PropertyID"
        $RequestParams = @{
            'Path'         = $Path
            'Method'       = 'DELETE'
            'WangsuRCFile' = $WangsuRCFile
        }
    
        $Response = Invoke-WangsuRequest @RequestParams
        return $Response
    }
}
        