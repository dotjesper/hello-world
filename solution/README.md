This folder contains the scripts, assets, and resource files for the [Hello World](https://github.com/dotjesper/hello-world/) project.

## Folder structure

```text
 📂 solution/
  ├─ 📂 assets/
  │   ├─ 📂 archives/             # Compressed asset files (ZIP archives)
  │   └─ 📂 images/               # Image assets used by scripts and documentation
  ├─ 📂 scripts/                  # PowerShell scripts
  └─ 📄 solution.wsb              # Windows Sandbox configuration
```

## Assets

The `assets/` folder contains sample files used by the scripts:

- **archives/** - Compressed files such as ZIP archives used for testing or deployment (e.g., speed test download files)
- **images/** - Image assets referenced by scripts and documentation

## Scripts

The `scripts/` folder contains PowerShell scripts that demonstrate various automation tasks and serve as practical examples. All scripts follow the conventions defined in the project's [copilot-instructions.md](https://github.com/dotjesper/hello-world/blob/main/.github/copilot-instructions.md) - including `#requires -version 5.1`, `begin`/`process`/`end` blocks, comment-based help, and parameter validation.

| Script | Description |
| :----- | :---------- |
| **[Get-RepositoryFile.ps1](./scripts/Get-RepositoryFile.ps1)** | Downloads files from a GitHub repository to a local destination using the REST API. Supports recursive directory traversal. |
| **[Get-RepositoryOverview.ps1](./scripts/Get-RepositoryOverview.ps1)** | Generates a visual tree overview of a GitHub repository using the Git Trees API with emoji icons and box-drawing characters. |
| **[Invoke-HelloWorld.ps1](./scripts/Invoke-HelloWorld.ps1)** | Hello World demonstration script showcasing PowerShell invocation details and 64-bit relaunch. |
| **[Invoke-Speedtest.ps1](./scripts/Invoke-Speedtest.ps1)** | Performs a network speed test by repeatedly downloading a file and calculating average throughput in Mbit/sec. |
| **[Invoke-SpotifySearch.ps1](./scripts/Invoke-SpotifySearch.ps1)** | Searches Spotify for focus-friendly tracks using the Spotify Web API. The sample came up when writing "Learning to focus in a world of distractions" |
| **[Set-ShortcutPin.ps1](./scripts/Set-ShortcutPin.ps1)** | Attempts to pin or unpin a shortcut or app to the Windows taskbar or Start Menu using shell verbs. Supports both .lnk files and modern/UWP apps. |

### Release notes

#### March 13, 2026

- Added Invoke-SpotifySearch.ps1 v1.0.0 - searches Spotify for focus-friendly tracks with OAuth authentication and paginated results

#### March 12, 2026

- Added `#PSScriptInfo` headers to Invoke-HelloWorld.ps1, Invoke-Speedtest.ps1, and Set-ShortcutPin.ps1
- Added TLS 1.2 enforcement to Get-RepositoryFile.ps1 and Invoke-Speedtest.ps1
- Fixed `.RELEASENOTES` URL across all scripts

#### March 11, 2026

- Added Set-ShortcutPin.ps1 v1.1.0 - added `-AppName` parameter for modern/UWP app support and `-ListApps` for app discovery

#### March 8, 2026

- Added Get-RepositoryOverview.ps1 v1.0.0 - generates visual repository tree overview

#### March 5, 2026

- Added Get-RepositoryFile.ps1 v1.0.0 - downloads files from GitHub repositories
- Added Invoke-HelloWorld.ps1 v1.0.0 - Hello World demonstration script
- Added Invoke-Speedtest.ps1 v1.0.0 - network speed test script
- Added Set-ShortcutPin.ps1 v1.0.0 - pin shortcuts to Start Menu or taskbar

---

*Page revised: March 13, 2026*
