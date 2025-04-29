function Invoke-WangsuRequest {
    [CmdletBinding()]
    Param(
        [Parameter(Mandatory)]
        [string]
        $Path,
        
        [Parameter()]
        [string]
        $Method = 'GET',
        
        [Parameter()]
        [hashtable]
        $QueryParameters,
        
        [Parameter()]
        [hashtable]
        $AdditionalHeaders,
        
        [Parameter()]
        $Body,
        
        [Parameter()]
        [string]
        $WangsuRCFile = "~/.wangsurc.json"
    )

    $APIHost = 'open.chinanetcenter.com'
    $ContentType = 'application/json; charset=utf-8'

    # Get Credentials
    if (-not $WangsuRCFile) {
        $WangsuRCFile = '~/.wangsurc.json'
    }
    $Credentials = Get-Content -Raw $WangsuRCFile | ConvertFrom-Json

    # Handle query params
    # Build QueryNameValueCollection
    if (-not $QueryParameters) {
        $QueryParameters = @{}
    }

    # Convert to string
    $QueryArray = New-Object -TypeName System.Collections.Generic.List[string]
    $QueryParameters.Keys | Sort-Object | ForEach-Object {
        $QueryArray.Add("$_=$($QueryParameters.$_)")
    }
    $QueryString = $QueryArray -Join '&'

    # Parse body
    if ($Body -and $Body -IsNot 'String') {
        try {
            $Body = $Body | ConvertTo-Json -Depth 100
        }
        catch {
            Write-Error "Body is not valid JSON"
            Write-Error $_
            return
        }
    }
    if (-not $Body) {
        $Body = ""
    }

    # -- Sign request

    # ---- 1. Hash body
    $Body_SHA256 = [System.Security.Cryptography.SHA256]::Create()
    $HashedBody = [System.Convert]::ToHexString($Body_SHA256.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($Body))).ToLower()

    # ---- 2. Cannonical request
    $SignedHeaders = "content-type;host"
    $CanonicalHeaders = "content-type:$ContentType`nhost:$APIHost`n"
    $CanonicalRequest = @(
        $Method.ToUpper()
        $Path
        $QueryString
        $CanonicalHeaders
        $SignedHeaders
        $HashedBody
    ) -Join "`n"
    Write-Debug "CanonicalRequest = $CanonicalRequest"

    # ---- 3. Sign
    $Date = Get-Date
    $TimeStamp = [Math]::Floor([decimal](Get-Date($Date).ToUniversalTime()-uformat "%s"))
    Write-Debug "Timestamp = $Timestamp"
    $CanonicalRequestSHA256 = [System.Security.Cryptography.SHA256]::Create()
    $HashedCanonicalRequest = [System.Convert]::ToHexString($CanonicalRequestSHA256.ComputeHash([System.Text.Encoding]::UTF8.GetBytes($CanonicalRequest))).ToLower()
    $StringToSign = "CNC-HMAC-SHA256`n" + $TimeStamp + "`n" + $HashedCanonicalRequest

    [byte[]] $KeyByte = [System.Text.Encoding]::UTF8.GetBytes($Credentials.secretKey)
    [byte[]] $MessageBytes = [System.Text.Encoding]::UTF8.GetBytes($StringToSign)
    $HMAC = new-object System.Security.Cryptography.HMACSHA256((, $keyByte))
    [byte[]] $HashMessage = $HMAC.ComputeHash($MessageBytes)
    $Signature = [System.Convert]::ToHexString($HashMessage)

    # ---- 4. Build auth header
    $AuthHeader = "CNC-HMAC-SHA256 Credential=$($Credentials.accessKey), SignedHeaders=content-type;host, Signature=$($Signature)"

    # -- Construct Headers
    $Headers = @{
        'Accept'            = 'application/json'
        'x-cnc-auth-method' = "AKSK"
        'x-cnc-accessKey'   = $Credentials.accessKey
        'x-cnc-timestamp'   = $Timestamp
        'Authorization'     = $AuthHeader
    }
    if ($AdditionalHeaders) {
        $Headers += $AdditionalHeaders
    }
    
    # -- Make Request
    $RequestURI = "https://$APIHost$Path"
    if ($QueryString) {
        $RequestURI += "?$QueryString"
    }

    $RequestParams = @{
        'uri'                  = $RequestURI
        'method'               = $Method
        'headers'              = $Headers
        'SkipHeaderValidation' = $true
        'Proxy'                = $env:https_proxy
        'ContentType'          = $ContentType
        'ErrorAction'          = 'Stop'
    }
    
    if ($Body) {
        $RequestParams.Body = $Body
    }

    try {
        $Response = Invoke-RestMethod @RequestParams
    }
    catch {
        throw $_
    }

    return $Response
}