<#PSScriptInfo
.VERSION 1.0.0
.GUID 7A3E5C91-B2D4-4F68-9E1A-C84F0D5B6E23
.AUTHOR @dotjesper
.COMPANYNAME dotjesper.com
.COPYRIGHT dotjesper.com
.TAGS powershell spotify music focus ambient search oauth
.LICENSEURI https://github.com/dotjesper/hello-world/blob/main/LICENSE
.PROJECTURI https://github.com/dotjesper/hello-world/
.ICONURI
.EXTERNALMODULEDEPENDENCIES
.REQUIREDSCRIPTS
.EXTERNALSCRIPTDEPENDENCIES
.RELEASENOTES https://github.com/dotjesper/hello-world/blob/main/solution#release-notes
#>
<#
.SYNOPSIS
    Searches Spotify for focus-friendly tracks using the Spotify Web API.

.DESCRIPTION
    Invoke-SpotifySearch uses the Spotify Web API search endpoint to find
    focus-friendly tracks using keyword-based queries. Research suggests music
    between 50 and 80 BPM helps generate alpha waves, making it ideal for
    concentration and deep work.

    The Spotify API requires a user-authenticated access token.
    The script supports two authentication methods:
    - Provide an existing access token using the AccessToken parameter
    - Provide ClientId and ClientSecret to authenticate using the Authorization
      Code Flow, which opens a browser for Spotify login and starts a local
      listener to capture the callback automatically

    When using the Authorization Code Flow, tokens are cached in the user's temp
    folder. On subsequent runs, the script reuses the cached token or refreshes
    it automatically when expired.

.PARAMETER AccessToken
    A user-authenticated Spotify API access token. Obtain one from
    https://developer.spotify.com.

.PARAMETER ClientId
    The Spotify application Client ID for Authorization Code Flow authentication.
    Register an application at https://developer.spotify.com to obtain credentials.

.PARAMETER ClientSecret
    The Spotify application Client Secret for Authorization Code Flow authentication.

.PARAMETER RedirectUri
    The redirect URI registered with the Spotify application. A local HTTP listener
    is started on this URI to capture the authorization callback automatically.
    Default is "http://127.0.0.1:8000/callback".

.PARAMETER SearchQuery
    The search query used to find focus-friendly tracks.
    Default is "ambient instrumental focus".

.PARAMETER Limit
    Number of tracks to retrieve. Must be between 1 and 200.
    Default is 20.

.PARAMETER MaxAlbumLength
    Maximum number of characters to display for album titles. Longer titles
    are truncated with an ellipsis. Must be between 10 and 200. Default is 50.

.EXAMPLE
    .\Invoke-SpotifySearch.ps1 -AccessToken "BQD..."

    Searches for focus-friendly tracks using an existing access token.

.EXAMPLE
    .\Invoke-SpotifySearch.ps1 -ClientId "your_client_id" -ClientSecret "your_client_secret"

    Opens a browser for Spotify login and searches for focus-friendly tracks.

.EXAMPLE
    .\Invoke-SpotifySearch.ps1 -AccessToken "BQD..." -SearchQuery "classical piano focus" -Limit 10

    Searches for 10 classical piano focus tracks.

.EXAMPLE
    .\Invoke-SpotifySearch.ps1 -AccessToken "BQD..." -Verbose

    Searches for focus-friendly tracks with verbose output showing request details.

.NOTES
    Version: 1.0.0
    Author: Jesper Nielsen (@dotjesper)
    Release notes: Initial release
#>
#requires -version 5.1
[CmdletBinding(DefaultParameterSetName = "Token")]
param (
    [Parameter(Mandatory, Position = 0, ParameterSetName = "Token", HelpMessage = "A user-authenticated Spotify API access token from https://developer.spotify.com.")]
    [ValidateNotNullOrEmpty()]
    [string]$AccessToken,

    [Parameter(Mandatory, Position = 0, ParameterSetName = "OAuth", HelpMessage = "The Spotify application Client ID for authentication.")]
    [ValidateNotNullOrEmpty()]
    [string]$ClientId,

    [Parameter(Mandatory, Position = 1, ParameterSetName = "OAuth", HelpMessage = "The Spotify application Client Secret for authentication.")]
    [ValidateNotNullOrEmpty()]
    [string]$ClientSecret,

    [Parameter(Mandatory = $false, ParameterSetName = "OAuth", HelpMessage = "The redirect URI registered with the Spotify application.")]
    [ValidateNotNullOrEmpty()]
    [string]$RedirectUri = "http://127.0.0.1:8000/callback",

    [Parameter(Mandatory = $false, HelpMessage = "The search query used to find focus-friendly tracks.")]
    [ValidateNotNullOrEmpty()]
    [string]$SearchQuery = "ambient instrumental focus",

    [Parameter(Mandatory = $false, HelpMessage = "Number of tracks to retrieve.")]
    [ValidateRange(1, 200)]
    [int]$Limit = 20,

    [Parameter(Mandatory = $false, HelpMessage = "Maximum number of characters to display for album titles.")]
    [ValidateRange(10, 200)]
    [int]$MaxAlbumLength = 50
)
#region :: begin
begin {
    #region :: Environment configurations
    [version]$ScriptVersion = '1.0.0'
    Set-Variable -Name 'ScriptVersion' -Value $ScriptVersion -Option ReadOnly -Scope Script
    #endregion

    #region :: TLS 1.2 (required for Spotify API, not always the default in PowerShell 5.1)
    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
    #endregion

    #region :: Invocation details
    Write-Verbose -Message "Script name: $($myInvocation.myCommand.name)"
    Write-Verbose -Message "Parameter set: $($PSCmdlet.ParameterSetName)"
    Write-Verbose -Message "Search query: $SearchQuery"
    Write-Verbose -Message "Limit: $Limit"
    #endregion

    #region :: Token cache path
    $tokenCachePath = Join-Path -Path $env:TEMP -ChildPath "SpotifyOAuthCache.json"
    #endregion

    #region :: functions
    function Get-SpotifyAuthHeader {
        param (
            [Parameter(Mandatory, Position = 0, HelpMessage = "The Spotify application Client ID.")]
            [string]$ClientId,

            [Parameter(Mandatory, Position = 1, HelpMessage = "The Spotify application Client Secret.")]
            [string]$ClientSecret
        )
        $bytes = [System.Text.Encoding]::UTF8.GetBytes("${ClientId}:${ClientSecret}")
        return [System.Convert]::ToBase64String($bytes)
    }

    function Get-CachedSpotifyToken {
        param (
            [Parameter(Mandatory, Position = 0, HelpMessage = "Path to the token cache file.")]
            [string]$CachePath
        )
        if (Test-Path -Path $CachePath) {
            try {
                $cache = Get-Content -Path $CachePath -Raw | ConvertFrom-Json
                $expiresAt = [datetime]::Parse($cache.expires_at)

                # Return the cached tokens if the access token has at least 60 seconds of validity remaining
                if ($expiresAt -gt (Get-Date).AddSeconds(60)) {
                    Write-Verbose -Message "Using cached access token (expires at $($cache.expires_at))."
                    return $cache
                }
                else {
                    Write-Verbose -Message "Cached access token has expired."

                    # Return cache with expired flag so the refresh token can be used
                    if ($cache.refresh_token) {
                        return $cache
                    }
                }
            }
            catch {
                Write-Verbose -Message "Failed to read token cache."
            }
        }
        return $null
    }

    function Save-SpotifyToken {
        param (
            [Parameter(Mandatory, Position = 0, HelpMessage = "Path to the token cache file.")]
            [string]$CachePath,

            [Parameter(Mandatory, Position = 1, HelpMessage = "The access token to cache.")]
            [string]$Token,

            [Parameter(Mandatory, Position = 2, HelpMessage = "Token lifetime in seconds.")]
            [int]$ExpiresIn,

            [Parameter(Mandatory = $false, Position = 3, HelpMessage = "The refresh token to cache.")]
            [string]$RefreshToken
        )
        $cache = @{
            access_token  = $Token
            expires_at    = (Get-Date).AddSeconds($ExpiresIn).ToString("o")
        }
        if ($RefreshToken) {
            $cache.refresh_token = $RefreshToken
        }
        $cache | ConvertTo-Json | Set-Content -Path $CachePath -Force
        Write-Verbose -Message "Access token cached to $CachePath (expires in $ExpiresIn seconds)."
    }

    function Update-SpotifyToken {
        param (
            [Parameter(Mandatory, Position = 0, HelpMessage = "The refresh token.")]
            [string]$RefreshToken,

            [Parameter(Mandatory, Position = 1, HelpMessage = "Base64-encoded client credentials.")]
            [string]$AuthHeader,

            [Parameter(Mandatory, Position = 2, HelpMessage = "Path to the token cache file.")]
            [string]$CachePath
        )
        try {
            $response = Invoke-RestMethod -Method Post -Uri "https://accounts.spotify.com/api/token" `
                -Headers @{ "Authorization" = "Basic $AuthHeader" } `
                -Body @{
                    grant_type    = "refresh_token"
                    refresh_token = $RefreshToken
                }

            Write-Verbose -Message "Access token refreshed, expires in $($response.expires_in) seconds."

            # Save refreshed token (keep existing refresh token if a new one is not returned)
            $newRefreshToken = if ($response.refresh_token) { $response.refresh_token } else { $RefreshToken }
            Save-SpotifyToken -CachePath $CachePath -Token $response.access_token -ExpiresIn $response.expires_in -RefreshToken $newRefreshToken

            return $response.access_token
        }
        catch {
            Write-Warning -Message "Failed to refresh access token: $_"
            return $null
        }
    }

    function Connect-SpotifyOAuth {
        param (
            [Parameter(Mandatory, Position = 0, HelpMessage = "The Spotify application Client ID.")]
            [string]$ClientId,

            [Parameter(Mandatory, Position = 1, HelpMessage = "The Spotify application Client Secret.")]
            [string]$ClientSecret,

            [Parameter(Mandatory, Position = 2, HelpMessage = "The redirect URI registered with the Spotify application.")]
            [string]$RedirectUri,

            [Parameter(Mandatory, Position = 3, HelpMessage = "Path to the token cache file.")]
            [string]$CachePath
        )

        $authHeader = Get-SpotifyAuthHeader -ClientId $ClientId -ClientSecret $ClientSecret

        # Check for a valid cached token or refresh an expired one
        $cached = Get-CachedSpotifyToken -CachePath $CachePath
        if ($cached) {
            $expiresAt = [datetime]::Parse($cached.expires_at)
            if ($expiresAt -gt (Get-Date).AddSeconds(60)) {
                return $cached.access_token
            }
            elseif ($cached.refresh_token) {
                Write-Verbose -Message "Refreshing expired access token."
                $refreshedToken = Update-SpotifyToken -RefreshToken $cached.refresh_token -AuthHeader $authHeader -CachePath $CachePath
                if ($refreshedToken) {
                    return $refreshedToken
                }
                Write-Verbose -Message "Refresh failed, starting new authorization."
            }
        }

        # Start local HTTP listener to capture the authorization callback
        $listener = New-Object System.Net.HttpListener
        $listenerPrefix = if ($RedirectUri.EndsWith("/")) { $RedirectUri } else { "$RedirectUri/" }
        $listener.Prefixes.Add($listenerPrefix)
        $listener.Start()
        Write-Verbose -Message "Local listener started on $RedirectUri."

        try {
            # Build the authorization URL and open the browser for Spotify login
            $scope = "user-read-private"
            $encodedScope = [System.Uri]::EscapeDataString($scope)
            $encodedRedirect = [System.Uri]::EscapeDataString($RedirectUri)
            $authUrl = "https://accounts.spotify.com/authorize?client_id=$ClientId&response_type=code&redirect_uri=$encodedRedirect&scope=$encodedScope"

            Write-Verbose -Message "Authorization URL: $authUrl"
            Write-Host "Opening browser for Spotify authorization..."
            Start-Process $authUrl

            # Wait for the redirect callback containing the authorization code
            $context = $listener.GetContext()
            $code = $context.Request.QueryString["code"]
            $errorParam = $context.Request.QueryString["error"]

            # Send a response to the browser
            $html = "<html><body><p>Authorization complete. You may close this window.</p></body></html>"
            $buffer = [System.Text.Encoding]::UTF8.GetBytes($html)
            $context.Response.ContentLength64 = $buffer.Length
            $context.Response.OutputStream.Write($buffer, 0, $buffer.Length)
            $context.Response.OutputStream.Close()

            if ($errorParam) {
                Write-Warning -Message "Authorization denied: $errorParam"
                return $null
            }

            if (-not $code) {
                Write-Warning -Message "No authorization code received."
                return $null
            }

            Write-Verbose -Message "Authorization code received, exchanging for tokens."

            # Exchange the authorization code for access and refresh tokens
            $tokenResponse = Invoke-RestMethod -Method Post -Uri "https://accounts.spotify.com/api/token" `
                -Headers @{ "Authorization" = "Basic $authHeader" } `
                -Body @{
                    grant_type   = "authorization_code"
                    code         = $code
                    redirect_uri = $RedirectUri
                }

            Write-Verbose -Message "Access token obtained, expires in $($tokenResponse.expires_in) seconds."

            # Cache both the access and refresh tokens for subsequent runs
            Save-SpotifyToken -CachePath $CachePath -Token $tokenResponse.access_token -ExpiresIn $tokenResponse.expires_in -RefreshToken $tokenResponse.refresh_token

            return $tokenResponse.access_token
        }
        finally {
            $listener.Stop()
            Write-Verbose -Message "Local listener stopped."
        }
    }
    #endregion
}
#endregion

#region :: process
process {
    try {
        Write-Output -InputObject "Invoke-SpotifySearch v$ScriptVersion"
        Write-Output -InputObject "Searching for focus-friendly tracks..."

        # Obtain access token based on parameter set
        $token = $null
        if ($PSCmdlet.ParameterSetName -eq "OAuth") {
            Write-Verbose -Message "Authenticating using Authorization Code Flow."
            $token = Connect-SpotifyOAuth -ClientId $ClientId -ClientSecret $ClientSecret -RedirectUri $RedirectUri -CachePath $tokenCachePath
            if (-not $token) {
                Write-Warning -Message "Authentication failed."
                return
            }
        }
        else {
            $token = $AccessToken
        }

        # Spotify apps in development mode may restrict the limit parameter to 10
        # Retrieve the requested number of tracks using pagination with batches of 10
        [int]$batchSize = 10
        [array]$allTracks = @()
        [int]$offset = 0
        [int]$remaining = $Limit

        Write-Verbose -Message "Search query: $SearchQuery"
        Write-Verbose -Message "Limit: $Limit (fetching in batches of $batchSize)"
        Write-Verbose -Message "Requesting tracks from Spotify Search API."

        $encodedQuery = [System.Uri]::EscapeDataString($SearchQuery.Trim())

        while ($remaining -gt 0) {
            $currentBatch = [math]::Min($remaining, $batchSize)
            $searchUri = "https://api.spotify.com/v1/search?q=${encodedQuery}&type=track&limit=${currentBatch}&offset=${offset}"

            Write-Verbose -Message "Batch request: limit=$currentBatch, offset=$offset"
            Write-Verbose -Message "Request URI: $searchUri"

            # Use HttpWebRequest directly to prevent PowerShell cmdlets from re-encoding the URI
            $request = [System.Net.HttpWebRequest]::Create($searchUri)
            $request.Method = "GET"
            $request.Headers.Add("Authorization", "Bearer $token")

            try {
                $webResponse = $request.GetResponse()
            }
            catch [System.Net.WebException] {
                $errorResponse = $_.Exception.Response
                if ($errorResponse) {
                    $reader = New-Object System.IO.StreamReader($errorResponse.GetResponseStream())
                    $errorBody = $reader.ReadToEnd()
                    $reader.Close()
                    Write-Verbose -Message "Error body: $errorBody"
                }
                throw $_
            }

            $reader = New-Object System.IO.StreamReader($webResponse.GetResponseStream())
            $responseBody = $reader.ReadToEnd()
            $reader.Close()
            $webResponse.Close()

            $searchResults = $responseBody | ConvertFrom-Json
            $tracks = $searchResults.tracks.items

            if ($tracks.Count -eq 0) {
                Write-Verbose -Message "No more tracks available at offset $offset."
                break
            }

            $allTracks += $tracks
            $offset += $tracks.Count
            $remaining -= $tracks.Count

            Write-Verbose -Message "Retrieved $($tracks.Count) tracks (total: $($allTracks.Count))."

            # Stop if Spotify returned fewer tracks than requested (no more results)
            if ($tracks.Count -lt $currentBatch) {
                break
            }
        }

        # Display results
        if ($allTracks.Count -eq 0) {
            Write-Output -InputObject "No tracks found matching the specified criteria."
        }
        else {
            Write-Output -InputObject "Found $($allTracks.Count) focus-friendly tracks:"
            Write-Output -InputObject ""

            $trackNumber = 0
            $allTracks | ForEach-Object {
                $trackNumber++
                $trackName = $_.name
                $artistName = ($_.artists | ForEach-Object { $_.name }) -join ", "
                $albumName = if ($_.album.name.Length -gt $MaxAlbumLength) { $_.album.name.Substring(0, $MaxAlbumLength - 3) + "..." } else { $_.album.name }
                $minutes = [int][math]::Floor($_.duration_ms / 60000)
                $seconds = [int][math]::Floor(($_.duration_ms % 60000) / 1000)
                $duration = "${minutes}:$($seconds.ToString('D2'))"
                $spotifyUrl = $_.external_urls.spotify
                Write-Output -InputObject "  ${trackNumber}. ${trackName} - ${artistName} (${albumName}) [${duration}]"
                Write-Output -InputObject "     ${spotifyUrl}"
            }

            Write-Output -InputObject ""
        }
    }
    catch {
        Write-Warning -Message "Spotify search failed: $_"
        exit 1
    }
}
#endregion

#region :: end
end {
    Write-Output -InputObject "Spotify search completed."
}
#endregion
