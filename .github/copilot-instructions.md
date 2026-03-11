# Copilot Instructions - Hello World

These instructions guide GitHub Copilot when working with files in this project. The hello-world repository is a personal learning platform and reference for GitHub best practices, repository management, and PowerShell scripting.

## File standards

All files in this repository must follow these standards:

- **Encoding**: UTF-8 for all files
- **Line endings**: LF (`\n`) - never CRLF (configured in `.vscode/settings.json` and `.editorconfig`)
- **Final newline**: Always insert a final newline at end of file
- **Trailing whitespace**: Trim trailing whitespace (except in Markdown files where trailing spaces may be intentional)
- **Indentation**: 2 spaces (no tabs)

## Project structure

```text
📂 .assets/                       # Repository branding images
📂 .github/
 └── 📄 copilot-instructions.md   # GitHub Copilot custom instructions
📂 .vscode/
 ├── 📄 extensions.json           # Recommended Visual Studio Code extensions
 ├── 📄 settings.json             # Workspace settings
 └── 📄 tasks.json                # Task definitions
📂 solution/
 ├── 📄 solution.wsb              # Windows Sandbox configuration
 ├── 📂 assets/
 │    ├── 📂 archives/            # Compressed asset files
 │    └── 📂 images/              # Image assets
 └── 📂 scripts/                  # PowerShell scripts
📂 .wiki/                          # Mirrored wiki pages for branch review
📄 .editorconfig                  # Editor configuration
📄 .gitattributes                 # Git attributes (line endings)
📄 .gitignore                     # Git ignore rules
📄 CONTRIBUTING.md                # Contribution guidelines
📄 LICENSE                        # CC BY-NC-SA 4.0 License
📄 README.md                      # Project overview
```

## PowerShell conventions

All PowerShell scripts live in `solution/scripts/` and follow these conventions:

### Script structure

- **Minimum version**: PowerShell 5.1+ (`#requires -version 5.1`)
- **Function structure**: Use standard `begin`/`process`/`end` blocks
- **Error handling**: Try-catch blocks with warnings and proper exit codes
- **Help documentation**: Full comment-based help with `#PSScriptInfo` headers including VERSION, GUID, AUTHOR, and TAGS
- **Parameters**: Validate with `[ValidateNotNullOrEmpty()]`, `[ValidateRange()]`, and similar attributes. Include `HelpMessage` for each parameter.
- **Progress indication**: Use progress bars for long-running operations
- **Verbosity**: Support `-Verbose` throughout

### Script header comments

Every script must include a header comment block with description and elevation requirement:

```powershell
# Description: Brief explanation of what the script does
# Elevation is required / is not required - Reason why this level is required
```

### Naming

- **Script filenames**: PascalCase with Verb-Noun pattern (e.g., `Invoke-HelloWorld.ps1`, `Get-RepositoryFile.ps1`)
- **Functions and parameters**: PascalCase
- **Approved verbs**: Use PowerShell approved verbs (`Get-Verb`)

### Security

- Always use `-UseBasicParsing` on `Invoke-WebRequest` calls
- Enforce TLS 1.2 for API calls: `[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12`
- Use token-based authentication for GitHub API calls (never hardcode tokens)

## Writing style

Content in Markdown files (`README.md`, `CONTRIBUTING.md`) follows these conventions:

- Professional but approachable tone
- Use "I" for personal perspective
- Use " - " (space-hyphen-space) for dashes, not em-dashes
- Use **bold** for emphasis, not italics

Consistent terminology must be used throughout the repository:

- Use "PowerShell" (not "PS", "PoSH", or "Powershell")
- Use "Microsoft 365" (not "M365")
- Use "Microsoft Edge" (not "Edge" alone)
- Use "Microsoft Intune" (not "Intune" alone)
- Use "Microsoft Teams" (not "Teams" alone)
- Use "Windows Autopatch" (not "Autopatch" alone)
- Use "Windows Autopilot" (not "Autopilot" alone)
- Use "Windows Autopilot device preparation" (not "Autopilot device preparation" or "device preparation" alone)
- Use "Windows Sandbox" (not "Sandbox" alone)
- Use "Visual Studio Code" (not "VS Code")
- Use "Windows 365" (not "W365")
- Use "Vibe Coding" (not "vibe coding" or "Vibe coding")
- Use Microsoft Copilot product names in full on first reference (e.g., "GitHub Copilot", "Microsoft Copilot for Word")

## Companion wiki

The project wiki lives in the `hello-world.wiki` repository as a sibling workspace folder. Wiki pages follow separate conventions defined in the wiki's own `.github/copilot-instructions.md`. See the [project wiki](https://github.com/dotjesper/hello-world/wiki) for parts and field notes.

---

*Page revised: March 08, 2026*
