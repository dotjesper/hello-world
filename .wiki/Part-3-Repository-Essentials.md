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

## Community health files

Beyond the common repository files, GitHub recognizes a set of community health files that help maintainers manage contributions, security, and support. These files are optional, but adding them improves the contributor experience and satisfies GitHub's Community Standards checklist.

### SECURITY.md

A SECURITY.md file tells people how to responsibly report security vulnerabilities in your project. Without one, people may open a public issue to report a vulnerability - potentially exposing it before you can fix it.

GitHub recognizes this file and links to it from the repository's **Security** tab. A typical SECURITY.md includes:

- **Supported versions** - Which branches or releases receive security updates
- **Reporting instructions** - How to report a vulnerability privately (for example, using [GitHub Private Vulnerability Reporting](https://docs.github.com/en/code-security/security-advisories/guidance-on-reporting-and-writing-information-about-vulnerabilities/privately-reporting-a-security-vulnerability "Privately reporting a security vulnerability"))
- **Scope** - What types of issues are considered security concerns
- **Response expectations** - How quickly reporters can expect acknowledgment

A SECURITY.md is most important for projects that include scripts, tools, or code that others run in their environments. For personal learning projects, it is optional but demonstrates awareness of responsible disclosure practices.

### CODE_OF_CONDUCT.md

A CODE_OF_CONDUCT.md defines the behavior expected from participants in the project community. It signals that the project is welcoming and that maintainers will address unacceptable behavior.

The most widely adopted standard is the [Contributor Covenant](https://www.contributor-covenant.org/ "Contributor Covenant"), used by projects like .NET, Ruby, and Kubernetes. GitHub can generate a Code of Conduct file from the repository settings, or you can add one manually.

A Code of Conduct typically covers:

- **Expected behavior** - Being respectful, inclusive, and constructive
- **Unacceptable behavior** - Harassment, trolling, and personal attacks
- **Enforcement** - How violations are reported and handled
- **Scope** - Where the code applies (issues, pull requests, discussions)

For smaller or personal projects, a brief section in CONTRIBUTING.md may be sufficient. A dedicated file is more valuable for projects with an active community or multiple contributors.

### SUPPORT.md

A SUPPORT.md file tells people where to go for help. GitHub recognizes this file and displays a link to it in the issue template chooser, helping redirect general questions away from the issue tracker.

A SUPPORT.md typically includes:

- **Where to ask questions** - For example, GitHub Discussions, a community forum, or a chat channel
- **Where to report bugs** - A link to the issue tracker or issue templates
- **Where to find documentation** - Links to the wiki, README, or external docs

A dedicated SUPPORT.md is most useful when a project has multiple support channels or tiers. For projects that already direct questions to GitHub Discussions through CONTRIBUTING.md or issue template configuration, a separate SUPPORT.md may not add new information - but it does satisfy the GitHub Community Standards checklist.

### Issue templates

Issue templates provide structured forms that guide contributors when opening new issues. Instead of a blank text box, contributors see pre-defined fields and prompts that help them provide the right information upfront.

GitHub supports two formats for issue templates:

- **Markdown templates** (`.md` files) - Simple templates that pre-fill the issue body with Markdown text. These work everywhere, including GitHub Enterprise Server.
- **YAML issue forms** (`.yml` files) - Structured forms with dropdowns, checkboxes, text fields, and required validation. These provide a better contributor experience but require GitHub.com.

Issue templates are stored in the `.github/ISSUE_TEMPLATE/` folder. A typical setup might include:

```text
 📂 .github/
  └─ 📂 ISSUE_TEMPLATE/
      ├─ 📄 bug_report.yml        # Structured bug report form
      ├─ 📄 feature_request.yml   # Feature or improvement suggestion
      └─ 📄 config.yml            # Template chooser configuration
```

The `config.yml` file controls the template chooser that appears when contributors select **New Issue**. It can disable blank issues and add contact links - for example, a link to GitHub Discussions for general questions:

```yaml
blank_issues_enabled: false
contact_links:
  - name: Ask a question
    url: https://github.com/yourname/yourrepo/discussions
    about: Use GitHub Discussions for questions, ideas, or general feedback.
```

Disabling blank issues ensures that every issue follows one of the defined templates, which keeps the issue tracker organized and reduces back-and-forth with contributors.

### Pull request template

A pull request template pre-fills the description field when contributors open a new pull request. Unlike issue templates, GitHub only supports a single Markdown file for pull requests - there is no YAML form option.

The template is stored as `.github/PULL_REQUEST_TEMPLATE.md` and typically includes sections for describing the change, linking related issues, and confirming that the contributor has followed the project's guidelines:

```markdown
## Description

<!-- A clear description of the changes in this pull request. -->

## Related issue

<!-- Link the issue this PR addresses, e.g., Fixes issue 123 -->

## Type of change

- [ ] Bug fix
- [ ] New feature
- [ ] Documentation update

## Checklist

- [ ] I have tested the changes locally
- [ ] I have reviewed the Contributing Guide
```

A pull request template adds consistency to pull requests without requiring contributors to remember the expected format. It is especially useful in repositories where multiple people contribute, but even for personal projects it serves as a useful self-checklist.

### Community Standards checklist

GitHub provides a built-in checklist that shows which community health files your repository includes. The checklist is not immediately obvious in the interface, but it provides a quick overview of what is in place and what is missing.

To access the Community Standards checklist:

1. Go to your repository on GitHub
2. Select **Insights** from the top navigation
3. Select **Community Standards** from the sidebar

The checklist shows the status of files like README, CONTRIBUTING, LICENSE, CODE_OF_CONDUCT, SECURITY, and issue templates. Each item links to guidance on how to add it. This is a useful reference when setting up a new repository or reviewing an existing one for completeness.

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
- [Creating a default community health file](https://docs.github.com/en/communities/setting-up-your-project-for-healthy-contributions/creating-a-default-community-health-file "Creating a default community health file") - GitHub documentation on community health files
- [Adding a security policy](https://docs.github.com/en/code-security/getting-started/adding-a-security-policy-to-your-repository "Adding a security policy") - GitHub documentation on SECURITY.md
- [Contributor Covenant](https://www.contributor-covenant.org/ "Contributor Covenant") - A widely adopted Code of Conduct for open-source projects
- [Configuring issue templates](https://docs.github.com/en/communities/using-templates-to-encourage-useful-contributions/configuring-issue-templates-for-your-repository "Configuring issue templates for your repository") - GitHub documentation on issue templates
- [Syntax for issue forms](https://docs.github.com/en/communities/using-templates-to-encourage-useful-contributions/syntax-for-issue-forms "Syntax for issue forms") - GitHub documentation on YAML issue forms
- [Creating a pull request template](https://docs.github.com/en/communities/using-templates-to-encourage-useful-contributions/creating-a-pull-request-template-for-your-repository "Creating a pull request template for your repository") - GitHub documentation on PR templates

---

*Page revised: March 11, 2026*
