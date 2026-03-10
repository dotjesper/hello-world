Once you are comfortable with the basics covered in the earlier lessons, there are several practical techniques that take your GitHub and PowerShell workflow further. This page covers how to interact with GitHub repositories programmatically - downloading files, referencing content directly, and understanding the different ways GitHub serves repository content.

For cloning, branching, and daily workflows, see the [Lesson 4 Branching and Workflows](./Lesson-4-Branching-and-Workflows) page.

## Understanding GitHub URLs

GitHub exposes repository content through several different URL patterns, and understanding the difference is important when referencing or downloading files programmatically.

### Repository URL vs. raw file URL

The repository URL and the raw file URL serve different purposes:

| URL type | Pattern | Returns |
| -------- | ------- | ------- |
| Repository page | `https://github.com/<OWNER>/<REPO>` | HTML page with the GitHub UI |
| File view | `https://github.com/<OWNER>/<REPO>/blob/main/<PATH>` | HTML page showing the file with syntax highlighting |
| Raw file | `https://raw.githubusercontent.com/<OWNER>/<REPO>/main/<PATH>` | The actual file content, no HTML wrapper |
| API endpoint | `https://api.github.com/repos/<OWNER>/<REPO>/contents/<PATH>` | JSON metadata and Base64-encoded content |

### When to use each URL type

Choosing the right URL type depends on your use case:

- **Repository page** - Use when linking to a repository in documentation or browser bookmarks
- **File view** - Use when linking to a specific file for someone to read on GitHub
- **Raw file** - Use when downloading or referencing a file in scripts, as it returns the plain file content without HTML
- **API endpoint** - Use when you need metadata (file size, SHA, encoding) or want to interact with the repository programmatically

> [!IMPORTANT]
> Never use the `github.com/blob/` URL in scripts expecting raw content - it returns an HTML page, not the file itself. Always use `raw.githubusercontent.com` or the GitHub REST API.

## Downloading files from GitHub using PowerShell

PowerShell can download individual files or entire repositories from GitHub using the REST API or raw file URLs. This is useful for automating script deployments, pulling configuration files, or bootstrapping a device setup.

### Downloading a single raw file

The simplest approach downloads a file directly using its raw URL:

```powershell
# Description: Download a single file from a GitHub repository using the raw URL
# Elevation is not required - downloads to the current user's directory

$owner = "<OWNER>"
$repo = "<REPO>"
$branch = "main"
$filePath = "<PATH/TO/FILE>"
$outputPath = "$env:TEMP\$(Split-Path -Leaf $filePath)"

$rawUrl = "https://raw.githubusercontent.com/$owner/$repo/$branch/$filePath"
Invoke-RestMethod -Uri $rawUrl -OutFile $outputPath
Write-Output "Downloaded to: $outputPath"
```

### Downloading files using the GitHub REST API

The GitHub REST API provides more control, including access to private repositories when using authentication. See the sample script [Get-RepositoryFile.ps1](https://github.com/dotjesper/hello-world/blob/main/solution/scripts/Get-RepositoryFile.ps1 "Get-RepositoryFile.ps1") for a working example.

```powershell
# Description: Download a file from GitHub using the REST API
# Elevation is not required - downloads to the current user's directory

$owner = "<OWNER>"
$repo = "<REPO>"
$filePath = "<PATH/TO/FILE>"
$outputPath = "$env:TEMP\$(Split-Path -Leaf $filePath)"

$apiUrl = "https://api.github.com/repos/$owner/$repo/contents/$filePath"
$headers = @{
    "Accept"     = "application/vnd.github.v3.raw"
    "User-Agent" = "PowerShell"
}

Invoke-RestMethod -Uri $apiUrl -Headers $headers -OutFile $outputPath
Write-Output "Downloaded to: $outputPath"
```

### Downloading a file from a private repository

Accessing files in a private repository requires a GitHub personal access token (PAT). Generate a token from [GitHub Settings > Developer settings > Personal access tokens](https://github.com/settings/tokens "GitHub personal access tokens").

```powershell
# Description: Download a file from a private GitHub repository using a personal access token
# Elevation is not required - downloads to the current user's directory

$owner = "<OWNER>"
$repo = "<PRIVATE-REPO>"
$filePath = "<PATH/TO/FILE>"
$outputPath = "$env:TEMP\$(Split-Path -Leaf $filePath)"
$token = "<YOUR-GITHUB-PAT>"

$apiUrl = "https://api.github.com/repos/$owner/$repo/contents/$filePath"
$headers = @{
    "Accept"        = "application/vnd.github.v3.raw"
    "Authorization" = "Bearer $token"
    "User-Agent"    = "PowerShell"
}

Invoke-RestMethod -Uri $apiUrl -Headers $headers -OutFile $outputPath
Write-Output "Downloaded to: $outputPath"
```

> [!CAUTION]
> Never hard-code personal access tokens in scripts that are committed to a repository. Use environment variables, Azure Key Vault, or other secure storage mechanisms to manage secrets.

### Downloading an entire repository as a ZIP archive

You can download a complete repository as a ZIP archive using the GitHub API:

```powershell
# Description: Download a GitHub repository as a ZIP archive
# Elevation is not required - downloads to the current user's directory

$owner = "<OWNER>"
$repo = "<REPO>"
$branch = "main"
$outputPath = "$env:TEMP\$repo.zip"
$extractPath = "$env:TEMP\$repo"

$zipUrl = "https://api.github.com/repos/$owner/$repo/zipball/$branch"
$headers = @{
    "User-Agent" = "PowerShell"
}

Invoke-RestMethod -Uri $zipUrl -Headers $headers -OutFile $outputPath
Expand-Archive -Path $outputPath -DestinationPath $extractPath -Force
Write-Output "Repository extracted to: $extractPath"
```

## Referencing files in a repository

When writing documentation or scripts, you may need to reference specific files, lines, or versions in a GitHub repository.

### Linking to a specific file

Link to a file on a specific branch using the blob URL pattern:

```text
https://github.com/<OWNER>/<REPO>/blob/main/<PATH/TO/FILE>
```

### Linking to a specific line or range

Append a line anchor to link directly to a specific line or range in a file:

```text
https://github.com/<OWNER>/<REPO>/blob/main/<PATH/TO/FILE>#L10
https://github.com/<OWNER>/<REPO>/blob/main/<PATH/TO/FILE>#L10-L25
```

### Linking to a specific commit (permalink)

Branch links can change as new commits are added. For permanent links, use the commit SHA instead of the branch name:

```text
https://github.com/<OWNER>/<REPO>/blob/<COMMIT-SHA>/<PATH/TO/FILE>
```

To get a permalink on GitHub, press **Y** when viewing a file - this replaces the branch name with the commit SHA in the URL.

## Public vs. private repositories

Understanding the difference between public and private repositories helps you decide which visibility to use for your content.

| Aspect | Public repository | Private repository |
| ------ | ----------------- | ------------------ |
| Visibility | Anyone on the internet can see the repository | Only you and explicitly invited collaborators |
| Cloning | Anyone can clone without authentication | Requires authentication (GitHub account + access) |
| Raw file access | Available without authentication | Requires a personal access token |
| API access | Available without authentication (rate-limited) | Requires a personal access token |
| GitHub Pages | Available on free plans | Requires a paid plan or GitHub Pro |
| Use cases | Open-source projects, shared templates, public documentation | Internal scripts, proprietary configurations, work in progress |

### Choosing the right visibility

Consider these factors when choosing the right repository visibility:

- Use **public** when sharing scripts, templates, or documentation that benefit others
- Use **private** for work-related scripts, proprietary configurations, or anything containing sensitive information
- You can change visibility later, but be cautious - making a repository public exposes its entire commit history

## Sample scripts

The following sample scripts in the [Hello World](https://github.com/dotjesper/hello-world/) repository demonstrate these concepts in practice:

| Script | Description |
| ------ | ----------- |
| [Get-RepositoryFile.ps1](https://github.com/dotjesper/hello-world/blob/main/solution/scripts/Get-RepositoryFile.ps1 "Get-RepositoryFile.ps1") | Download files and folders from a GitHub repository using the REST API |
| [Get-RepositoryOverview.ps1](https://github.com/dotjesper/hello-world/blob/main/solution/scripts/Get-RepositoryOverview.ps1 "Get-RepositoryOverview.ps1") | Generate a tree-like overview of a GitHub repository structure |

> [!NOTE]
> Sample scripts are for demonstration and learning purposes. Review and test scripts in a non-production environment before use.

## GitHub Gist as an alternative

[GitHub Gist](https://gist.github.com/ "GitHub Gist") is a lightweight alternative to a full repository when you want to share a single script or snippet without the overhead of creating a repository.

GitHub Gist is a good fit when you need to:

- Share a single PowerShell script or code snippet quickly
- Create a quick reference or cheat sheet
- Share configuration examples without a full project structure
- Collaborate on small, standalone files

Gists support versioning, comments, and can be either public or secret (unlisted). For anything more than a few files, a full repository is the better choice.

## Useful references

These resources provide further reading on the topics covered in this page:

- [GitHub REST API](https://docs.github.com/en/rest/ "GitHub REST API") - Official documentation for the GitHub API
- [Personal access tokens](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/managing-your-personal-access-tokens "Personal access tokens") - Managing authentication tokens for API access
- [About repositories](https://docs.github.com/en/repositories/creating-and-managing-repositories/about-repositories "About repositories") - Understanding repository visibility and settings
- [Creating a gist](https://docs.github.com/en/get-started/writing-on-github/editing-and-sharing-content-with-gists/creating-gists "Creating a gist") - GitHub Gist documentation
- [Invoke-RestMethod](https://learn.microsoft.com/powershell/module/microsoft.powershell.utility/invoke-restmethod "Invoke-RestMethod") - PowerShell documentation for REST API calls

---

*Page revised: March 7, 2026*
