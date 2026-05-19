## Contributing to the **Hello World** project

Thank you for your interest in contributing to the **Hello World** project!

This project is a personal learning platform and open-source tool, and contributions of all kinds are welcome - from bug reports and feature ideas to code improvements and documentation updates.

## Prerequisites

The workspace includes Visual Studio Code tasks that require specific components to be installed and enabled. The following table lists the prerequisites for each task:

| Task | Prerequisite | How to enable or install |
| :--- | :----------- | :----------------------- |
| Launch Windows Sandbox | Windows Sandbox feature enabled | `Enable-WindowsOptionalFeature -Online -FeatureName Containers-DisposableClientVM` |
| Run PSScriptAnalyzer | PSScriptAnalyzer module installed | `Install-Module -Name PSScriptAnalyzer -Scope CurrentUser` |
| Run PSScriptAnalyzer | `.config/` folder with analyzer profiles | Included in the repository - contains `Default.psd1`, `Strict.psd1`, and `CI.psd1` |
| Sync Wiki Pages | Wiki repository cloned as sibling folder | `git clone https://github.com/dotjesper/hello-world.wiki.git` alongside the main repository |

## How to contribute

Contributing to this project follows a standard fork-and-pull workflow:

1. Fork the repository on GitHub
1. Clone your fork locally
1. Create a feature or fix branch (`feature/short-description` or `fix/short-description`)
1. Make your changes following the conventions described below
1. Commit with a clear, imperative message (e.g., "Add validation to configuration parser")
1. Push your branch and open a pull request against `main`

## Conventions and standards

This project uses a `.github/copilot-instructions.md` file to define coding standards, writing style, and terminology conventions for GitHub Copilot. The file is included in the repository and serves as the reference for project conventions.

The repository also demonstrates the use of a `.github/instructions/` folder with additional instruction files for more detailed guidance. These files are highly personal and reflect individual workflows and preferences - they should not be copied directly but created in your own context based on your own standards and working style.

All contributions should follow these general principles:

- PowerShell scripts use `#requires -version 5.1`, `begin`/`process`/`end` blocks, comment-based help, and parameter validation
- PowerShell scripts use `try`/`catch`/`finally` error handling - this is non-negotiable
- Markdown files use sentence case headings, bold for emphasis (not italics), and " - " (space-hyphen-space) for dashes
- Use full Microsoft product names consistently (e.g., "Microsoft Intune", "Visual Studio Code", "Windows Sandbox")

## Starting a discussion

For general questions, ideas, or feedback that are not specific bugs or feature requests, please use [GitHub Discussions](https://github.com/dotjesper/hello-world/discussions). This is the best place to:

- Ask questions about usage or configuration
- Share ideas for new features or improvements
- Discuss best practices for deployment scenarios

## Code of conduct

This is a personal development project shared with the community. Please respect the community sharing philosophy:

- Be respectful and constructive in all interactions
- Keep discussions focused and on-topic
- Acknowledge that this is an evolving project and be patient with responses

## License

By contributing to the **Hello World** project, you agree that your contributions will be licensed under the [Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License](https://creativecommons.org/licenses/by-nc-sa/4.0/) - in other words, share generously, provide attribution, but no commercial use.

---

*Page revised: May 18, 2026*
