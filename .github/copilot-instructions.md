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
 📂 hello-world/
  └─ 📂 .assets/                      # Repository branding images
     📂 .github/
      ├─ 📂 ISSUE_TEMPLATE/
      │   ├─ 📄 bug_report.yml            # Bug report issue form
      │   ├─ 📄 feature_request.yml       # Feature request issue form
      │   └─ 📄 config.yml                # Template chooser configuration
      ├─ � instructions/
      │   └─ 📄 powershell.instructions.md # PowerShell coding standards
      ├─ �📄 copilot-instructions.md       # GitHub Copilot custom instructions
      └─ 📄 PULL_REQUEST_TEMPLATE.md      # Pull request template
     📂 .vscode/
      ├─ 📄 extensions.json           # Recommended Visual Studio Code extensions
      ├─ 📄 settings.json             # Workspace settings
      └─ 📄 tasks.json                # Task definitions
     📂 solution/
      ├─ 📄 solution.wsb              # Windows Sandbox configuration
      ├─ 📂 assets/
      │   ├─ 📂 archives/             # Compressed asset files
      │   └─ 📂 images/               # Image assets
      └─ 📂 scripts/                  # PowerShell scripts
     📄 .editorconfig                 # Editor configuration
     📄 .gitattributes                # Git attributes (line endings)
     📄 .gitignore                    # Git ignore rules
     📄 CONTRIBUTING.md               # Contribution guidelines
     📄 LICENSE                       # CC BY-NC-SA 4.0 License
     📄 README.md                     # Project overview
```

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

## Reviewing content

Reviewing content means systematically checking files for correctness, consistency, and compliance with the standards defined in this document. A review should be performed before committing changes and applies equally to PowerShell scripts, Markdown files, and configuration files.

### What to review for

Every review should verify the following areas:

- **File standards**: UTF-8 encoding, LF line endings, final newline present, trailing whitespace trimmed, and 2-space indentation (no tabs)
- **Writing style and tone**: Professional but approachable tone, "I" for personal perspective, " - " (space-hyphen-space) for dashes, **bold** for emphasis (not italics), and consistent use of the approved terminology list
- **Terminology consistency**: All product names and terms match the terminology list in the Writing style section - check every occurrence, not just the first
- **PowerShell script structure**: `#requires -version 5.1` present, `begin`/`process`/`end` blocks, try-catch error handling, full comment-based help with `#PSScriptInfo` headers (VERSION, GUID, AUTHOR, TAGS), parameter validation attributes with `HelpMessage`, progress bars for long-running operations, and `-Verbose` support
- **PowerShell header comments**: Code examples in Markdown documentation include a header comment block with description and elevation requirement (not in `.ps1` files)
- **PowerShell naming**: PascalCase filenames using Verb-Noun pattern with approved verbs, PascalCase functions and parameters
- **PowerShell security**: `-UseBasicParsing` on all `Invoke-WebRequest` calls, TLS 1.2 enforced for API calls, token-based authentication with no hardcoded secrets
- **Reading flow**: Content follows a logical progression, transitions between sections feel natural, and the document reads well from start to finish
- **Overlapping content**: No unintentional duplication across files - some repetition is acceptable when context demands it, but identical content in multiple places should be consolidated
- **Spelling and grammar**: No typos, correct grammar, and clear phrasing throughout
- **Heading hierarchy**: No skipped heading levels (e.g., `##` jumping to `####`) and logical nesting of sections
- **List consistency**: Bullet style and punctuation follow the same pattern within each list - do not mix fragments and full sentences
- **Revision date**: The `*Page revised:*` footer reflects the date of the latest change
- **Project structure alignment**: Files are placed in the correct directories as defined in the project structure section
- **Link validity**: URLs, cross-references, and relative links point to existing and correct targets
- **Accuracy**: Technical content is correct, code examples run without errors, and instructions produce the expected outcome

### Review approach

A review follows these steps:

1. Verify file standards - encoding, line endings, indentation, and final newline
2. Read through content for clarity, accuracy, and tone
3. Check reading flow - logical progression and smooth transitions between sections
4. Look for overlapping or duplicated content across files
5. Check all terminology against the approved terminology list
6. For PowerShell scripts - validate structure, naming conventions, security practices, and header comments
7. Confirm files are placed in the correct project structure locations
8. Test code examples and commands where possible
9. Verify all links and cross-references resolve correctly
10. Check for spelling errors, grammar issues, and unclear phrasing

## Companion wiki

The project wiki lives in the `hello-world.wiki` repository as a sibling workspace folder. Wiki pages follow separate conventions defined in the wiki's own `.github/copilot-instructions.md`. See the [project wiki](https://github.com/dotjesper/hello-world/wiki) for parts and field notes.

---

*Page revised: March 14, 2026*
