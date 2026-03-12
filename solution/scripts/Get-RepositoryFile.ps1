<#PSScriptInfo
.VERSION 1.0.0
.GUID 8F0E1A6A-A24A-4344-8709-D68AB7A7F456
.AUTHOR @dotjesper
.COMPANYNAME dotjesper.com
.COPYRIGHT dotjesper.com
.TAGS powershell github download repository
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
    Downloads files from a GitHub repository to a local destination.

.DESCRIPTION
    Get-RepositoryFile retrieves files from a specified GitHub repository path and
    saves them to a local destination folder. Supports recursive directory traversal
    to download entire folder structures.

.PARAMETER Owner
    The GitHub repository owner (user or organization name).

.PARAMETER Repository
    The name of the GitHub repository.

.PARAMETER Path
    The path within the repository to download files from.

.PARAMETER DestinationPath
    The local directory path where downloaded files will be saved.

.PARAMETER Token
    The GitHub personal access token for authentication.
    Consider using environment variables or a secrets manager to provide this value.

.PARAMETER SilentProgress
    Suppresses the download progress bar when specified.

.EXAMPLE
    .\Get-RepositoryFile.ps1 -Owner "dotjesper" -Repository "hello-world" -Path "sample-content" -DestinationPath ".\sample-content" -Token $gitHubToken

    Downloads files from the sample-content folder in the hello-world repository.

.EXAMPLE
    .\Get-RepositoryFile.ps1 -Owner "dotjesper" -Repository "hello-world" -Path "sample-content" -DestinationPath ".\sample-content" -Token $gitHubToken -SilentProgress

    Downloads files without showing the progress bar.

.EXAMPLE
    .\Get-RepositoryFile.ps1 -Owner "dotjesper" -Repository "hello-world" -Path "sample-content" -DestinationPath ".\sample-content" -Token $gitHubToken -Verbose

    Downloads files with verbose output showing each file being downloaded.

.NOTES
    Version: 1.0.0
    Author: Jesper Nielsen (@dotjesper)
    Release notes: Initial release
#>
#requires -version 5.1
[CmdletBinding(SupportsShouldProcess)]
param (
    [Parameter(Mandatory, Position = 0, HelpMessage = "The GitHub repository owner (user or organization name).")]
    [ValidateNotNullOrEmpty()]
    [string]$Owner,

    [Parameter(Mandatory, Position = 1, HelpMessage = "The name of the GitHub repository.")]
    [ValidateNotNullOrEmpty()]
    [string]$Repository,

    [Parameter(Mandatory, Position = 2, ValueFromPipeline, ValueFromPipelineByPropertyName, HelpMessage = "The path within the repository to download files from.")]
    [ValidateNotNullOrEmpty()]
    [string]$Path,

    [Parameter(Mandatory, Position = 3, HelpMessage = "The local directory path where downloaded files will be saved.")]
    [ValidateNotNullOrEmpty()]
    [string]$DestinationPath,

    [Parameter(Mandatory, Position = 4, HelpMessage = "The GitHub personal access token for authentication.")]
    [ValidateNotNullOrEmpty()]
    [string]$Token,

    [Parameter(Mandatory = $false, HelpMessage = "Suppresses the download progress bar when specified.")]
    [switch]$SilentProgress
)
#region :: begin
begin {
    #region :: Environment configurations
    [version]$ScriptVersion = '1.0.0'
    Set-Variable -Name 'ScriptVersion' -Value $ScriptVersion -Option ReadOnly -Scope Script
    $originalProgressPreference = $ProgressPreference
    if ($SilentProgress) {
        $ProgressPreference = "SilentlyContinue"
    }
    #endregion

    #region :: TLS 1.2 (required by GitHub API, not always the default in PowerShell 5.1)
    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
    #endregion

    #region :: functions
    function Get-RepositoryFile {
        param (
            [Parameter(Mandatory, Position = 0, HelpMessage = "The GitHub repository owner.")]
            [string]$Owner,

            [Parameter(Mandatory, Position = 1, HelpMessage = "The name of the GitHub repository.")]
            [string]$Repository,

            [Parameter(Mandatory, Position = 2, HelpMessage = "The path within the repository.")]
            [string]$Path,

            [Parameter(Mandatory, Position = 3, HelpMessage = "The local destination path.")]
            [string]$DestinationPath,

            [Parameter(Mandatory, Position = 4, HelpMessage = "The GitHub authentication token.")]
            [string]$Token
        )
        try {
            # Set up headers for GitHub API authentication and construct the API URI for repository contents
            $headers = @{ Authorization = "token $Token" }
            $baseUri = "https://api.github.com/"
            $repositoryApiPath = "repos/$Owner/$Repository/contents/$Path"

            # Retrieve repository contents using -UseBasicParsing to avoid HTML DOM parsing and security warnings
            $webResponse = Invoke-WebRequest -Headers $headers -Uri "$($baseUri)$($repositoryApiPath)" -UseBasicParsing -ErrorAction Stop
            $objects = $webResponse.Content | ConvertFrom-Json
            $files = $objects | Where-Object { $_.type -eq "file" } | Select-Object -ExpandProperty download_url
            $directories = $objects | Where-Object { $_.type -eq "dir" }

            # Recursively download files from subdirectories
            $directories | ForEach-Object {
                Get-RepositoryFile -Owner $Owner -Repository $Repository -Path $_.path -DestinationPath "$DestinationPath\$($_.name)" -Token $Token
            }

            # Create destination directory if it does not exist
            if (-not (Test-Path -Path $DestinationPath)) {
                try {
                    New-Item -Path $DestinationPath -ItemType Directory -ErrorAction Stop | Out-Null
                }
                catch {
                    Write-Warning -Message "Error creating path: $DestinationPath"
                    return
                }
            }

            # Download each file to the destination path
            foreach ($file in $files) {
                $fileDestination = Join-Path -Path $DestinationPath -ChildPath (Split-Path -Path $file -Leaf)
                try {
                    # -UseBasicParsing avoids HTML DOM parsing, preventing security warnings and removing the dependency on Internet Explorer's engine
                    Invoke-WebRequest -Headers $headers -Uri $file -OutFile $fileDestination -UseBasicParsing -ErrorAction Stop
                    Write-Verbose -Message "Downloaded: $file to $fileDestination"
                }
                catch {
                    # Handle errors related to downloading individual files and output a warning message
                    Write-Warning -Message "Error downloading: $file"
                }
            }
        }
        catch {
            # Handle errors related to retrieving repository contents and output a warning message
            Write-Warning -Message "Failed to retrieve repository contents: $_"
        }
    }
    #endregion
}
#endregion

#region :: process
process {
    try {

        # Output initial information about the download process, including repository details and destination path
        Write-Output -InputObject "Get-RepositoryFile v$ScriptVersion"
        Write-Output -InputObject "Repository: $Owner/$Repository/$Path"
        Write-Output -InputObject "Destination: $DestinationPath"

        # Download files from the specified repository path
        Write-Verbose -Message "Processing repository $Owner/$Repository/$Path"
        Get-RepositoryFile -Owner $Owner -Repository $Repository -Path $Path -DestinationPath $DestinationPath -Token $Token
    }
    catch {
        # Handle any unexpected errors during the download process and output a warning message
        Write-Warning -Message "Download failed: $_"
        exit 1
    }
}
#endregion

#region :: end
end {
    # Restore original progress preference
    $ProgressPreference = $originalProgressPreference
    Write-Output -InputObject "Download completed."
}
#endregion
