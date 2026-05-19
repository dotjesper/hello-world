Welcome to the **Hello World** project.

This repository serves as a reference for GitHub best practices, repository management, and solution design - and as a template for future projects.

If you have comments, ideas, or suggestions, please use the [Discussions](https://github.com/dotjesper/hello-world/discussions "Join the discussion") section.

## About

Every IT professional writes code - they just do not call it that. PowerShell scripts, configuration baselines, and deployment fixes live in folders no one else can navigate. The difference between a folder of scripts and a professional body of work is structure - and that structure reflects who you are and how you work.

This repository is built on that idea. It is a personal learning platform and demonstration project for turning unstructured work into a version-controlled, well-documented repository - using GitHub, Git, and Visual Studio Code.

## Overview

Every IT professional and veteran software developer knows the term **Hello World** as the first step in learning to code. The program, which outputs some variant of "Hello, World!" on a device's display, can be created in most languages, making it some of the most basic syntax involved in the coding process.

> Brian Kernighan, author of one of the most widely read programming books, "C Programming Language", also created "Hello, World". He first referenced **Hello World** in the C Programming Language book’s predecessor: A Tutorial Introduction to the Programming Language B published in 1973.

Since the first "Hello World!" program was written in 1972, it has become a tradition to introduce the topic of programming with this example. As a result, "Hello World!" is often the first program most people write and this repository is no different - this is my sample-ground and learning-area for working with [GitHub](https://github.com/ "https://github.com/").

## Idea

The **Hello World** project is built on the principle that the best way to learn is by doing. With more teams adopting infrastructure-as-code practices and community-driven PowerShell repositories growing rapidly, version control is a core skill for IT professionals - not just developers. A well-structured repository signals quality, makes work accessible to others, and sets the author apart.

Rather than treating **Hello World** as just a simple code example, this repository uses it as a foundation to explore and master GitHub repository management, Git workflows, and development tooling. By building a complete project around this simple concept, you can learn:

- Repository structure and organization best practices
- Documentation standards and community engagement
- Version control workflows including branching strategies
- Issue tracking, pull requests, and collaborative development
- Project automation and maintenance practices

This approach transforms a trivial program into a meaningful learning experience - turning a folder of scripts into a professional, version-controlled repository with clear documentation, consistent formatting, and the configuration files that signal quality to anyone who finds the work.

## Goal

The primary goals of this project are to:

1. **Learn by example** - Create a well-structured, documented reference repository that demonstrates GitHub best practices.
2. **Build a template** - Develop reusable patterns and structures for future projects.
3. **Practice workflows** - Gain hands-on experience with branching, merging, releases, and collaboration.
4. **Document the journey** - Maintain clear documentation that helps others understand both the what and the why.
5. **Foster community** - Create a welcoming space for discussion, feedback, and shared learning.

## Synopsis

Using the "Hello World" concept as inspiration, this project focuses on the infrastructure and practices that surround a repository rather than the code itself - from comprehensive documentation and contribution guidelines to structured layouts and community engagement. The project is designed to grow and evolve as new concepts are explored and mastered.

## Content

The repository is organized into the following structure:

```text
 📂 hello-world/
  └─ 📁 .assets/                            # Asset folder
     📂 .config/
      ├─ 📄 CI.psd1                         # PSScriptAnalyzer CI profile (Error only)
      ├─ 📄 Default.psd1                    # PSScriptAnalyzer default profile (Warning + Error)
      ├─ 📄 FileFormatRules.psm1            # Custom file format rules module
      └─ 📄 Strict.psd1                     # PSScriptAnalyzer strict profile (all severities)
     📂 .github/
      ├─ 📁 instructions/                   # GitHub Copilot instruction files
      ├─ 📂 ISSUE_TEMPLATE/
      │   ├─ 📄 bug_report.yml              # Bug report issue form
      │   ├─ 📄 feature_request.yml         # Feature request issue form
      │   └─ 📄 config.yml                  # Template chooser configuration
      ├─ 📄 copilot-instructions.md         # GitHub Copilot custom instructions
      └─ 📄 PULL_REQUEST_TEMPLATE.md        # Pull request template
     📂 .vscode/
      ├─ 📄 extensions.json                 # Recommended Visual Studio Code extensions
      ├─ 📄 settings.json                   # Workspace settings
      └─ 📄 tasks.json                      # Task definitions
     📂 solution/
      ├─ 📂 assets/
      │   ├─ 📁 archives/                   # Compressed asset files
      │   └─ 📁 images/                     # Image assets
      ├─ 📂 scripts/
      │   ├─ 📄 Get-RepositoryFile.ps1      # Download files from a GitHub repository
      │   ├─ 📄 Get-RepositoryOverview.ps1  # Repository structure overview
      │   ├─ 📄 invoke-helloworld-v1.ps1    # Hello World v1 (demonstration with intentional errors)
      │   ├─ 📄 Invoke-HelloWorld.v2.ps1    # Hello World v2 demonstration script
      │   ├─ 📄 Invoke-Speedtest.ps1        # Network speed test script
      │   ├─ 📄 Invoke-SpotifySearch.ps1    # Spotify search using the Web API
      │   ├─ 📄 New-VMHydration.ps1         # Virtual machine hydration script
      │   └─ 📄 Set-ShortcutPin.ps1         # Pin shortcuts to Start Menu or taskbar
      └─ 📄 solution.wsb                    # Windows Sandbox configuration
     📄 .editorconfig                       # Cross-editor configuration
     📄 .gitattributes                      # Git attributes configuration
     📄 .gitignore                          # Files to exclude from Git
     📄 CONTRIBUTING.md                     # Contribution guidelines
     📄 LICENSE                             # CC BY-NC-SA 4.0 license
     📄 README.md                           # Repository documentation (this file)
```

## AI and GitHub Copilot in this project

This repository uses GitHub Copilot as an active part of the development workflow - not just for code completion, but for writing documentation, reviewing content, and maintaining consistency across files. The `.github/copilot-instructions.md` file defines project-specific rules that GitHub Copilot follows when working in this repository, including file standards, project structure, and review checklists. Topic-specific conventions - such as writing style, PowerShell coding patterns, and terminology - are maintained separately in the `.github/instructions/` folder.

### The instructions folder

The `.github/instructions/` folder is intentionally empty in the repository. Instruction files are excluded from version control via `.gitignore` because I consider them highly personal - they reflect individual workflows, preferences, and conventions that vary from person to person.

Adding files to the `.github/instructions/` folder is entirely optional and should be done by the user. The `copilot-instructions.md` file in the `.github/` root is where project-specific instructions should live. I have chosen to design my instruction files to be generic and reusable across multiple repositories, while the project-level `copilot-instructions.md` handles what is unique to each project.

As examples, the following instruction files are ones I continuously refine and use across various repositories:

| File | Purpose |
| :--- | :------ |
| `github.instructions.md` | Versioning, tags, commit messages, and release notes |
| `linkedin.instructions.md` | LinkedIn profile and content management |
| `markdown.instructions.md` | Markdown formatting and syntax |
| `powershell.instructions.md` | PowerShell coding style, naming, and security |
| `sessionize.instructions.md` | Session abstracts and speaker profile |
| `terminology.instructions.md` | Approved product names and terminology |
| `writing-style.instructions.md` | Prose conventions, punctuation, and readability |

### Creating your own instruction files

The best way to create instruction files is to let GitHub Copilot analyze your existing work and generate conventions based on what it finds. Here are some sample prompts to get started:

**Writing style**

```text
Analyze the Markdown files in this repository and create a writing-style.instructions.md
file that captures the tone, formatting patterns, punctuation rules, and heading conventions
I already use.
```

**PowerShell conventions**

```text
Review the PowerShell scripts in this repository and create a powershell.instructions.md
file that documents the naming conventions, script structure, error handling patterns, and
security practices I follow.
```

**Terminology**

```text
Scan this repository for product names and technical terms, then create a
terminology.instructions.md file that defines the correct spelling and capitalization
for each term.
```

**Markdown formatting**

```text
Look at how I format Markdown across this repository - headings, lists, code blocks,
tables - and create a markdown.instructions.md file that captures those patterns as rules.
```

Starting from your own existing patterns means the instructions will feel natural and consistent with how you already work. From there, refine and extend them over time as your conventions evolve.

You can also feed GitHub Copilot external resources - blog posts, style guides, or reference articles - to help it generate richer and more opinionated instruction files. For example:

**PowerShell naming**

```text
Read "How to name your PowerShell scripts and functions"
(https://dotjesper.com/2025/how-to-name-your-powershell-scripts-and-functions/) and use the
naming conventions described there as the basis for a powershell.instructions.md file.
```

**LinkedIn content strategy**

```text
Read "Learning to build a LinkedIn posting strategy"
(https://dotjesper.com/2026/learning-to-build-a-linkedin-posting-strategy/) and create a
linkedin.instructions.md file that captures the posting principles, content mix, and
formatting guidelines described in the article.
```

Combining your own repository patterns with external references gives GitHub Copilot a stronger foundation to work from - and the resulting instruction files will be more complete and actionable from the start.

## Companion wiki

The [project wiki](https://github.com/dotjesper/hello-world/wiki "Hello World wiki") is a companion to this repository - a living notebook capturing deeper notes, decisions, and lessons learned along the way. It covers the full journey from first install to daily use:

| Page | Description |
| :--- | :---------- |
| **[Part 1 Getting Started](https://github.com/dotjesper/hello-world/wiki/Part-1-Getting-Started)** | Introduction to GitHub, Git and Visual Studio Code |
| **[Part 2 Creating a Repository](https://github.com/dotjesper/hello-world/wiki/Part-2-Creating-a-Repository)** | Creating and configuring a GitHub repository |
| **[Part 3 Repository Essentials](https://github.com/dotjesper/hello-world/wiki/Part-3-Repository-Essentials)** | Markdown, README files, and common repository files |
| **[Part 4 Branching and Workflows](https://github.com/dotjesper/hello-world/wiki/Part-4-Branching-and-Workflows)** | Cloning, branching, pull requests, and the daily Git workflow |
| **[Part 5 Working With Repositories](https://github.com/dotjesper/hello-world/wiki/Part-5-Working-With-Repositories)** | Downloading, referencing, and working with repositories programmatically |
| **[Part 6 AI as a Learning Companion](https://github.com/dotjesper/hello-world/wiki/Part-6-AI-as-a-Learning-Companion)** | AI-assisted coding, GitHub Copilot, and Vibe Coding as a learning companion |
| **[Part 7 Copilot Configuration](https://github.com/dotjesper/hello-world/wiki/Part-7-Copilot-Configuration)** | Creating, maintaining, and sharing GitHub Copilot custom instructions |
| **[Part 8 Field Notes](https://github.com/dotjesper/hello-world/wiki/Part-8-Field-Notes)** | Practical lessons learned and insights collected through hands-on experience |
| **[Part 9 Exercises](https://github.com/dotjesper/hello-world/wiki/Part-9-Exercises)** | Companion exercises for each part of the wiki |

## Usage

This repository is primarily a learning and reference resource. To make the most of it:

1. **Explore the structure** - Review how the repository is organized and documented.
2. **Read the documentation** - Study the README, CONTRIBUTING, and other documentation files.
3. **Check the wiki** - Explore the [companion wiki](https://github.com/dotjesper/hello-world/wiki) for in-depth guides on every topic covered in this project.
4. **Join discussions** - Participate in [GitHub Discussions](https://github.com/dotjesper/hello-world/discussions) to share ideas.
5. **Use as a template** - Fork or reference this structure for your own projects.

## Contributing and feedback

Contributions, ideas, and feedback are welcome! Please see the [Contributing Guide](./CONTRIBUTING.md) for details on how to get involved.

- **Issues** - Report bugs or request features via [GitHub Issues](https://github.com/dotjesper/hello-world/issues "Report an issue").
- **Discussions** - Ask questions, share ideas, or start a conversation via [GitHub Discussions](https://github.com/dotjesper/hello-world/discussions "Join the discussion").
- **Pull Requests** - Fork the repository and submit a pull request with your improvements.

## Legal and licensing

This section covers the license, disclaimer, and usage guidelines for the repository and its contents.

### License

This project is licensed under a [Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International License](https://creativecommons.org/licenses/by-nc-sa/4.0/). You are free to share and adapt the material for non-commercial purposes, as long as you give appropriate credit and distribute any contributions under the same license. See the [LICENSE](./LICENSE) file for details.

### Disclaimer

This repository is provided "AS IS" without warranty of any kind, express or implied. The content is subject to change without notice and should not be interpreted as an offer or commitment. This is a personal learning project and demonstration platform, not affiliated with or endorsed by any organization unless explicitly stated. Any mention of third-party products, services, or trademarks is for reference purposes only and does not imply endorsement or affiliation. All trademarks and product names are the property of their respective owners.

### Usage guidelines

Scripts, solutions, or code in this repository may contain additional legal disclaimers or usage notes in their headers or inline comments. Users should review all documentation before use, test thoroughly in non-production environments, and understand that they assume all risks and responsibilities associated with using any content from this repository. It is the user's responsibility to ensure compliance with applicable laws and regulations.

All scripts in this repository are provided for demonstration purposes only and are intentionally not digitally signed. If your environment requires digitally signed scripts, sign the scripts with your own code signing certificate before use.

## Change log

See the [Change Log](https://github.com/dotjesper/hello-world/wiki/Revision) wiki page for full version history.

---

*Page revised: May 19, 2026*

[![Jesper on Bluesky](https://img.shields.io/badge/follow-@dotjesper.bsky.social-whitesmoke?style=social&logo=bluesky)](https://bsky.app/profile/dotjesper.bsky.social/ "Follow Jesper")
[![Jesper on X](https://img.shields.io/badge/follow-@dotjesper-whitesmoke?style=social&logo=x)](https://x.com/dotjesper/ "Follow Jesper")
[![dotjesper.com](https://img.shields.io/badge/explore-dotjesper.com-whitesmoke?style=social&logo=rss)](https://dotjesper.com/ "Explore https://dotjesper.com/")
