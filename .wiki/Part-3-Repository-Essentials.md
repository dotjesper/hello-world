This page covers the essential files and standards that turn a collection of scripts into a well-documented, professional repository - README, LICENSE, .gitignore, .editorconfig, and more.

For installation, configuration, and setup, see the [Part 1 Getting Started](./Part-1-Getting-Started) page. For more advanced topics like downloading files programmatically, see the [Part 5 Working With Repositories](./Part-5-Working-With-Repositories) page.

## Learning Markdown

Markdown is the formatting language used for README files, wiki pages, and GitHub comments. Learning the basics takes only a few minutes.

These are the most common Markdown elements:

| Element | Syntax | Result |
| ------- | ------ | ------ |
| Heading | `## Section title` | Section heading |
| Bold | `**bold text**` | **bold text** |
| Italic | `*italic text*` | *italic text* |
| Link | `[text](url)` | Clickable link |
| Code | `` `inline code` `` | `inline code` |
| List | `- item` | Bullet point |

For a complete reference, see [Writing on GitHub](https://docs.github.com/en/get-started/writing-on-github/getting-started-with-writing-and-formatting-on-github/basic-writing-and-formatting-syntax "Basic writing and formatting syntax").

## Common repository files

A well-configured repository typically includes several standard files. Understanding these files helps you set up a professional repository structure.

### README.md

A README.md is the first thing visitors see when they open your repository. It does not have to be long, but it should give readers a clear understanding of what the project is and how to use it.

A good README typically includes these sections:

- **Title and description** - A clear project name and a one-line summary of what it does
- **Prerequisites** - Software, tools, or permissions needed before getting started
- **Installation** - Step-by-step instructions for setting up the project locally
- **Usage** - How to run or use the project, with examples where helpful
- **Screenshots or demos** - Images or GIFs that show the project in action, making it easier for visitors to understand the purpose at a glance
- **Contributing** - How others can get involved (or a link to CONTRIBUTING.md)
- **License** - The license type (or a link to the LICENSE file)

For longer README files, consider adding a table of contents at the top so readers can jump to the section they need.

A simple README for a PowerShell project might look like this:

```markdown
# my-scripts

PowerShell scripts for managing Windows device configurations.

## Prerequisites

- Windows 11 24H2 or later
- PowerShell 5.1 or later

## Installation

Clone the repository to your local machine:

git clone https://github.com/yourname/my-scripts.git

## Usage

Run the scripts from a PowerShell terminal:

.\Deploy-WiFiProfile.ps1 -ProfileName "Corporate"

## Contributing

Contributions are welcome. Please open an issue or submit a pull request.

## License

This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.
```

README files, wiki pages, and most documentation on GitHub are written in Markdown. If Markdown is new to you, the [Markdown Guide](https://www.markdownguide.org/ "Markdown Guide") is an excellent starting point.

### CONTRIBUTING.md

A CONTRIBUTING.md file explains how others can contribute to the repository. Even for personal repositories, documenting contribution guidelines helps maintain consistency. A typical CONTRIBUTING.md includes:

- How to report issues
- How to suggest changes
- Coding standards and conventions
- The pull request process

### LICENSE

A LICENSE file tells others what they can and cannot do with the code. Without a license, the default copyright laws apply - meaning nobody else can use, copy, or modify the work. Common open-source licenses include:

- **MIT License** - Simple and permissive, allows almost any use
- **Apache License 2.0** - Permissive with an explicit patent grant
- **GNU GPL v3** - Requires derivative works to also be open-source

GitHub can add a license file when you create a repository, or you can add one later. See [Choose a License](https://choosealicense.com/ "Choose a License") for help picking the right license.

### .gitignore

A .gitignore file tells Git which files and folders to exclude from version control. This prevents temporary files, build output, and sensitive data from being committed. GitHub provides [template .gitignore files](https://github.com/github/gitignore "GitHub .gitignore templates") for many languages and frameworks.

A simple .gitignore for a PowerShell project might include:

```text
# PowerShell module output
/output/

# Editor files
.vscode/.history/
*.code-workspace

# OS files
Thumbs.db
.DS_Store
```

### .editorconfig

An .editorconfig file defines consistent coding styles across editors and contributors. It sets rules for indentation, line endings, character encoding, and trailing whitespace. Most modern editors - including Visual Studio Code with the EditorConfig extension - read this file automatically.

A typical .editorconfig file for a repository with Markdown and PowerShell files:

```ini
root = true

[*]
charset = utf-8
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true
indent_style = space
indent_size = 4

[*.md]
trim_trailing_whitespace = false

[*.{json,yml,yaml}]
indent_size = 2
```

> [!NOTE]
> Visual Studio Code does not read .editorconfig files natively. Install the [EditorConfig for VS Code](https://marketplace.visualstudio.com/items?itemName=EditorConfig.EditorConfig "EditorConfig for VS Code") extension to enable support.

### .gitattributes

A .gitattributes file controls how Git handles files in the repository - particularly line endings and binary file detection. Consistent line endings prevent unnecessary diffs caused by different operating systems:

```text
* text=auto eol=lf
*.ps1 text eol=lf
*.md text eol=lf
*.json text eol=lf
*.png binary
*.jpg binary
```

## Writing good commit messages

Commit messages serve as a log of what changed and why. Good commit messages are essential, even for small projects.

Follow these guidelines when writing commit messages:

- Start with a short summary (50 characters or less)
- Use the imperative mood (e.g., "Add script" not "Added script")
- Reference the reason for the change when it is not obvious
- Separate the summary from additional details with a blank line

Examples of good commit messages:

```text
Add WiFi profile deployment script

Update README with installation instructions

Fix typo in contributing guidelines
```

## Common scenarios for IT professionals

These are practical scenarios where GitHub, Git and Visual Studio Code add value for device administrators and IT professionals.

### Managing PowerShell scripts

Store your PowerShell scripts in a GitHub repository to track changes, collaborate with colleagues, and maintain a history of every version. This is especially useful for scripts deployed through Microsoft Intune or other management tools.

### Documenting configurations and processes

Use Markdown files and wiki pages to document device configurations, deployment processes, and troubleshooting guides. Documentation stored alongside scripts ensures it stays up to date.

### Sharing templates and standards

Create repositories with reusable templates - for example, standard `.gitignore` files, script headers, or configuration baselines. Share them within your team or organization.

### Reviewing changes before deployment

Use branches and pull requests to review script changes before merging them into your main branch. This adds a safety net, especially for scripts that modify device configurations.

## Useful references

These resources provide further reading on the topics covered on this page:

- [Markdown Guide](https://www.markdownguide.org/ "Markdown Guide") - Learn Markdown syntax and best practices
- [Choose a License](https://choosealicense.com/ "Choose a License") - Help choosing an open-source license
- [GitHub .gitignore templates](https://github.com/github/gitignore "GitHub .gitignore templates") - Template .gitignore files for many languages
- [EditorConfig](https://editorconfig.org/ "EditorConfig") - Consistent coding styles between editors
- [About READMEs](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/customizing-your-repository/about-readmes "About READMEs") - GitHub documentation on README files
- [Adding or editing wiki pages](https://docs.github.com/en/communities/documenting-your-project-with-wikis/adding-or-editing-wiki-pages "Adding or editing wiki pages") - GitHub documentation on working with wikis

---

*Page revised: March 7, 2026*
