# Copilot Instructions - PowerShell

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

PowerShell code examples in Markdown documentation (code fences) must include a header comment block with description and elevation requirement. These header comments are for documentation only - do not add them to `.ps1` script files:

```powershell
# Description: Brief explanation of what the script does
# Elevation is required / is not required - Reason why this level is required

<rest of the code example>
```

### Naming

- **Script filenames**: PascalCase with Verb-Noun pattern (e.g., `Invoke-HelloWorld.ps1`, `Get-RepositoryFile.ps1`)
- **Functions and parameters**: PascalCase
- **Approved verbs**: Use PowerShell approved verbs (`Get-Verb`)

### Security

- Always use `-UseBasicParsing` on `Invoke-WebRequest` calls
- Enforce TLS 1.2 for API calls: `[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12`
- Use token-based authentication for GitHub API calls (never hardcode tokens)
