<#PSScriptInfo
.VERSION 1.0.0
.GUID 3C7E2F1A-B8D4-4E6F-9A12-D5F0C3E7B9A2
.AUTHOR @dotjesper
.COMPANYNAME dotjesper.com
.COPYRIGHT dotjesper.com
.TAGS powershell github repository tree overview
.LICENSEURI https://github.com/dotjesper/hello-world/blob/main/LICENSE
.PROJECTURI https://github.com/dotjesper/hello-world/
.ICONURI
.EXTERNALMODULEDEPENDENCIES
.REQUIREDSCRIPTS
.EXTERNALSCRIPTDEPENDENCIES
.RELEASENOTES https://github.com/dotjesper/hello-world/wiki/release-notes
#>
<#
.SYNOPSIS
    Generates a visual tree overview of a GitHub repository.

.DESCRIPTION
    Get-RepositoryOverview retrieves the file and folder structure of a GitHub
    repository using the Git Trees API and renders it as a visual tree diagram
    with emoji icons and box-drawing characters.

    The output follows the same tree format used in the project documentation:
    folders are shown with a folder emoji and files with a document emoji,
    connected by tree-drawing characters.

.PARAMETER Owner
    The GitHub repository owner (user or organization name).

.PARAMETER Repository
    The name of the GitHub repository.

.PARAMETER Branch
    The branch name to retrieve the tree from. Defaults to "main".

.PARAMETER Token
    Optional GitHub personal access token for authentication.
    Required for private repositories. Public repositories can be accessed without
    a token, but with a lower rate limit (60 requests/hour vs. 5,000 authenticated).
    Consider using environment variables or a secrets manager to provide this value.

.PARAMETER OutputPath
    Optional file path to save the tree output. If omitted, output is written
    to the console only.

.EXAMPLE
    .\Get-RepositoryOverview.ps1 -Owner "dotjesper" -Repository "hello-world"

    Displays the repository tree structure for a public repository without authentication.

.EXAMPLE
    .\Get-RepositoryOverview.ps1 -Owner "dotjesper" -Repository "hello-world" -Token $gitHubToken

    Displays the repository tree structure with authentication (required for private repositories).

.EXAMPLE
    .\Get-RepositoryOverview.ps1 -Owner "dotjesper" -Repository "hello-world" -Branch "main.dev" -Token $gitHubToken

    Displays the tree structure for the main.dev branch.

.EXAMPLE
    .\Get-RepositoryOverview.ps1 -Owner "dotjesper" -Repository "hello-world" -Token $gitHubToken -OutputPath ".\repo-tree.md"

    Saves the tree structure to a Markdown file.

.EXAMPLE
    .\Get-RepositoryOverview.ps1 -Owner "dotjesper" -Repository "hello-world" -Token $gitHubToken -Verbose

    Displays the tree structure with verbose diagnostic output.

.NOTES
    Version: 1.0.0
    Author: Jesper Nielsen (@dotjesper)
    Release notes: Initial release
#>
#requires -version 5.1
[CmdletBinding()]
param (
    [Parameter(Mandatory, Position = 0, HelpMessage = "The GitHub repository owner (user or organization name).")]
    [ValidateNotNullOrEmpty()]
    [string]$Owner,

    [Parameter(Mandatory, Position = 1, HelpMessage = "The name of the GitHub repository.")]
    [ValidateNotNullOrEmpty()]
    [string]$Repository,

    [Parameter(Mandatory = $false, Position = 2, HelpMessage = "The branch name to retrieve the tree from.")]
    [ValidateNotNullOrEmpty()]
    [string]$Branch = "main",

    [Parameter(Mandatory = $false, Position = 3, HelpMessage = "Optional GitHub personal access token for authentication.")]
    [ValidateNotNullOrEmpty()]
    [string]$Token,

    [Parameter(Mandatory = $false, HelpMessage = "Optional file path to save the tree output.")]
    [string]$OutputPath
)
#region :: begin
begin {
    #region :: Environment configurations
    [version]$ScriptVersion = '1.0.0'
    Set-Variable -Name 'ScriptVersion' -Value $ScriptVersion -Option ReadOnly -Scope Script
    #endregion

    #region :: TLS 1.2 (required by GitHub API, not always the default in PowerShell 5.1)
    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
    #endregion

    #region :: Emoji characters (supplementary Unicode, requires ConvertFromUtf32)
    $script:folderEmoji = [char]::ConvertFromUtf32(0x1F4C2)
    $script:fileEmoji = [char]::ConvertFromUtf32(0x1F4C4)
    #endregion

    #region :: Box-drawing characters
    $script:branchConnector = [char]0x251C + [string][char]0x2500 + [string][char]0x2500
    $script:cornerConnector = [char]0x2514 + [string][char]0x2500 + [string][char]0x2500
    $script:verticalPipe = [char]0x2502
    #endregion

    #region :: functions
    function Get-GitHubTree {
        param (
            [Parameter(Mandatory)]
            [string]$Owner,

            [Parameter(Mandatory)]
            [string]$Repository,

            [Parameter(Mandatory)]
            [string]$Branch,

            [Parameter(Mandatory = $false)]
            [string]$Token
        )
        try {
            # Set up headers for GitHub API request
            $requestParams = @{
                Uri             = $null
                Headers         = @{ 'User-Agent' = "Get-RepositoryOverview/$ScriptVersion" }
                ErrorAction     = 'Stop'
            }
            if ($Token) {
                $requestParams['Headers']['Authorization'] = "token $Token"
            }
            $baseUri = "https://api.github.com"

            # Retrieve the full repository tree recursively using the Git Trees API
            $treeUri = "$baseUri/repos/$Owner/$Repository/git/trees/$($Branch)?recursive=1"
            Write-Verbose -Message "Requesting tree from: $treeUri"

            $requestParams['Uri'] = $treeUri
            $treeData = Invoke-RestMethod @requestParams

            if ($treeData.truncated -eq $true) {
                Write-Warning -Message "Repository tree was truncated due to size. Some items may be missing."
            }

            return $treeData.tree
        }
        catch {
            Write-Warning -Message "Failed to retrieve repository tree: $_"
            return $null
        }
    }

    function ConvertTo-TreeStructure {
        param (
            [Parameter(Mandatory)]
            [array]$TreeItems
        )

        # Build a nested hashtable structure from flat path list
        $root = @{}

        foreach ($item in $TreeItems) {
            $parts = $item.path -split '/'
            $current = $root

            for ($i = 0; $i -lt $parts.Count; $i++) {
                $part = $parts[$i]

                if (-not $current.ContainsKey($part)) {
                    if ($i -eq ($parts.Count - 1) -and $item.type -eq "blob") {
                        # Leaf node (file)
                        $current[$part] = $null
                    }
                    else {
                        # Directory node
                        $current[$part] = @{}
                    }
                }

                if ($current[$part] -is [hashtable]) {
                    $current = $current[$part]
                }
            }
        }

        return $root
    }

    function Format-TreeOutput {
        param (
            [Parameter(Mandatory)]
            [hashtable]$Node,

            [string]$Prefix = "",

            [bool]$IsRoot = $true
        )

        $lines = [System.Collections.Generic.List[string]]::new()

        # Sort entries: directories first, then files, alphabetically within each group
        $directories = [System.Collections.Generic.List[string]]::new()
        $files = [System.Collections.Generic.List[string]]::new()

        foreach ($key in $Node.Keys) {
            if ($Node[$key] -is [hashtable]) {
                $directories.Add($key)
            }
            else {
                $files.Add($key)
            }
        }

        $directories.Sort()
        $files.Sort()
        $sortedEntries = @($directories) + @($files)
        $totalEntries = $sortedEntries.Count

        for ($i = 0; $i -lt $totalEntries; $i++) {
            $entry = $sortedEntries[$i]
            $isLast = ($i -eq ($totalEntries - 1))

            if ($IsRoot) {
                # Root-level items use the same style as the README
                if ($Node[$entry] -is [hashtable]) {
                    $lines.Add("$Prefix$script:folderEmoji $entry/")
                    $childLines = Format-TreeOutput -Node $Node[$entry] -Prefix "$Prefix " -IsRoot $false
                    $lines.AddRange([string[]]$childLines)
                }
                else {
                    $lines.Add("$Prefix$script:fileEmoji $entry")
                }
            }
            else {
                $connector = if ($isLast) { $script:cornerConnector } else { $script:branchConnector }
                $childPrefix = if ($isLast) { "$Prefix     " } else { "$Prefix$script:verticalPipe    " }

                if ($Node[$entry] -is [hashtable]) {
                    $lines.Add("$Prefix$connector $script:folderEmoji $entry/")
                    $childLines = Format-TreeOutput -Node $Node[$entry] -Prefix $childPrefix -IsRoot $false
                    $lines.AddRange([string[]]$childLines)
                }
                else {
                    $lines.Add("$Prefix$connector $script:fileEmoji $entry")
                }
            }
        }

        return ,$lines.ToArray()
    }
    #endregion
}
#endregion

#region :: process
process {
    try {
        # Output script information
        Write-Output -InputObject "Get-RepositoryOverview v$ScriptVersion"
        Write-Output -InputObject "Repository: https://github.com/$Owner/$Repository"
        Write-Output -InputObject "Branch: $Branch"
        Write-Output -InputObject ""

        # Retrieve the repository tree from GitHub
        Write-Verbose -Message "Retrieving tree for $Owner/$Repository branch $Branch"
        $treeParams = @{
            Owner      = $Owner
            Repository = $Repository
            Branch     = $Branch
        }
        if ($Token) {
            $treeParams['Token'] = $Token
        }

        $treeItems = Get-GitHubTree @treeParams

        if ($null -eq $treeItems) {
            Write-Warning -Message "No tree data returned. Verify the owner, repository, branch, and token."
            exit 1
        }

        Write-Verbose -Message "Retrieved $($treeItems.Count) items from repository tree"

        # Build the hierarchical tree structure from the flat path list
        $treeStructure = ConvertTo-TreeStructure -TreeItems $treeItems

        # Render the visual tree with the repository name as root
        $headerLine = "$script:folderEmoji $Repository/"
        $treeLines = Format-TreeOutput -Node $treeStructure -Prefix " " -IsRoot $false

        $output = @($headerLine) + $treeLines

        # Output the tree to the console
        foreach ($line in $output) {
            Write-Output -InputObject $line
        }

        # Save to file if OutputPath is specified
        if ($OutputPath) {
            try {
                $parentDirectory = Split-Path -Path $OutputPath -Parent
                if ($parentDirectory -and -not (Test-Path -Path $parentDirectory)) {
                    New-Item -Path $parentDirectory -ItemType Directory -ErrorAction Stop | Out-Null
                }

                $fileContent = $output -join "`n"
                [System.IO.File]::WriteAllText((Resolve-Path -Path $parentDirectory | Join-Path -ChildPath (Split-Path -Path $OutputPath -Leaf)), $fileContent, [System.Text.Encoding]::UTF8)
                Write-Output -InputObject ""
                Write-Output -InputObject "Tree saved to: $OutputPath"
            }
            catch {
                Write-Warning -Message "Failed to save tree to file: $_"
            }
        }
    }
    catch {
        Write-Warning -Message "Failed to generate repository overview: $_"
        exit 1
    }
}
#endregion

#region :: end
end {
    Write-Verbose -Message "Repository overview completed."
}
#endregion
