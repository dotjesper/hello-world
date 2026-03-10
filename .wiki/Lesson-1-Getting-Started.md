This page is a gentle introduction to GitHub, Git and Visual Studio Code - written for device administrators, IT professionals, and anyone taking their first steps into version control. No prior development experience is needed. The goal is to help you understand the basics, get set up, and start using these tools with confidence in your day-to-day work.

The content is based on the *Getting started with GitHub, Git and Visual Studio Code* demonstration session and covers prerequisites, installation, and initial configuration.

For creating and configuring a repository, see the [Lesson 2 Creating a Repository](./Lesson-2-Creating-a-Repository) page. For writing documentation and structuring repository files, see the [Lesson 3 Writing Content](./Lesson-3-Writing-Content) page.

## Why GitHub, Git and Visual Studio Code

Version control is not just for developers. Understanding GitHub, Git and Visual Studio Code brings real benefits for device administrators and IT professionals:

- **Track changes** - Keep a full history of configuration files, scripts, and documentation so you can see what changed, when, and why
- **Collaborate safely** - Work on scripts and configurations in branches without risking production-ready files
- **Share and reuse** - Publish reusable PowerShell scripts, templates, and documentation for your team
- **Learn modern workflows** - Build skills that transfer across tools like Microsoft Intune, Infrastructure as Code, and DevOps pipelines
- **Document decisions** - Use wikis, README files, and commit messages to capture the reasoning behind changes

## What you need before you start

Before the session, make sure you have the following prerequisites in place:

- A GitHub account (free) - sign up at [GitHub](https://github.com/ "GitHub")

> [!NOTE]
> Some software installations may require administrator rights on your device.

## Installing Visual Studio Code and Git

Visual Studio Code and Git can be installed using the Windows Package Manager (winget), which is included in modern versions of Windows.

> [!NOTE]
> If you are running Windows on ARM and want native ARM64 versions, download the installers directly from the [Visual Studio Code](https://code.visualstudio.com/download "Visual Studio Code downloads") and [Git for Windows](https://git-scm.com/download/win "Git for Windows downloads") download pages.

### Installing Visual Studio Code

Visual Studio Code is a lightweight but powerful editor that works well with Git and GitHub. Use the following commands to search for and install Visual Studio Code:

```powershell
# Description: Search for and install Visual Studio Code using winget
# Elevation is not required - winget installs per-user by default

winget search "Visual Studio Code"
winget show --Id "Microsoft.VisualStudioCode"
winget install --Id "Microsoft.VisualStudioCode" --silent
```

For a fully silent installation with custom options, use the override parameter:

```powershell
# Description: Install Visual Studio Code silently with custom merge tasks
# Elevation is not required - winget installs per-user by default

winget install --Id "Microsoft.VisualStudioCode" --override "/VERYSILENT /NORESTART /MERGETASKS=!runcode"
```

### Installing Git

Git is the version control system that tracks changes to your files. Install Git with the following command:

```powershell
# Description: Install Git for Windows with common components enabled
# Elevation is not required - winget installs per-user by default

winget install --Id "Git.Git" --override "/VERYSILENT /NORESTART /COMPONENTS=ext,ext\shellhere,ext\guihere,gitlfs,assoc,assoc_sh,autoupdate"
```

### Keeping software up to date

After installation, use winget to check for and apply updates:

```powershell
# Description: Check for available updates and upgrade all installed packages
# Elevation is not required - winget upgrade runs per-user

winget upgrade
winget upgrade --All
```

## Setting up Visual Studio Code

Once Visual Studio Code is installed, there are a few recommended steps to get the most out of it.

### Sign in and sync settings

Sign in to Visual Studio Code using your GitHub account to connect your editor to GitHub. Open Visual Studio Code, click the account icon in the lower-left corner, and sign in with GitHub. Signing in enables several key features:

- **GitHub repository access** - Clone, push, and pull repositories directly from the editor
- **Settings Sync** - Keep your extensions, themes, keybindings, and preferences consistent across devices
- **GitHub Copilot** - Get AI-powered code suggestions and chat assistance (requires a GitHub Copilot subscription)
- **Pull requests and issues** - Review and manage pull requests and issues without leaving the editor

### Recommended extensions

Visual Studio Code extensions add functionality for working with Git, Markdown, and PowerShell. These extensions are helpful for administrators and IT professionals:

- **[EditorConfig for VS Code](https://marketplace.visualstudio.com/items?itemName=EditorConfig.EditorConfig "EditorConfig for VS Code")** - Enforces consistent formatting across contributors
- **[GitHub Pull Requests](https://marketplace.visualstudio.com/items?itemName=GitHub.vscode-pull-request-github "GitHub Pull Requests")** - Review and manage pull requests directly in Visual Studio Code
- **[GitLens](https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens "GitLens")** - Visualize code authorship, compare changes, and explore Git history
- **[Insert GUID](https://marketplace.visualstudio.com/items?itemName=heaths.vscode-guid "Insert GUID")** - Insert GUIDs in different formats directly into the editor
- **[Learn Markdown](https://marketplace.visualstudio.com/items?itemName=docsmsft.docs-markdown "Learn Markdown")** - Markdown authoring assistance based on Microsoft Learn standards
- **[PowerShell](https://marketplace.visualstudio.com/items?itemName=ms-vscode.PowerShell "PowerShell")** - Syntax highlighting, IntelliSense, and debugging for PowerShell scripts
- **[XML Tools](https://marketplace.visualstudio.com/items?itemName=DotJoshJohnson.xml "XML Tools")** - XML formatting, XQuery, and XPath tools

> [!TIP]
> You can share recommended extensions with your team by adding an `extensions.json` file to the `.vscode` folder in your repository. Visual Studio Code will prompt contributors to install the listed extensions when they open the project. See [Workspace recommended extensions](https://code.visualstudio.com/docs/configure/extensions/extensions-json "Workspace recommended extensions") for details.

## Configuring Git

Before you start working with Git, you need to configure your identity. Git uses this information to associate your name and email with every commit you make.

### Setting up your global identity

Configure your username and email globally so they apply to all repositories on your device.

Open a terminal in Visual Studio Code by selecting `Terminal` > `New Terminal` from the menu. Git commands work directly in the default PowerShell terminal, as long as Git is installed on your device. Git Bash is also available from the dropdown arrow next to the `+` button in the terminal panel, if you prefer a Unix-style shell.

Run the following commands:

```powershell
# Description: Configure Git global username and email
# Elevation is not required - Git config is stored in the user profile

git config --global user.name "Your Name"
git config --global user.email "your-email-address@domain.com"
```

### Overriding identity for a single repository

If you need a different identity for a specific repository - for example, a work repository versus a personal one - navigate to the repository folder and set the values locally:

```powershell
# Description: Configure Git username and email for a specific repository
# Elevation is not required - Git config is stored in the repository folder

cd C:\path\to\your\repository
git config user.name "Your Name"
git config user.email "your-email@domain.com"
git config --list
```

## Useful references

These resources provide further reading on the topics covered on this page:

- [Visual Studio Code Documentation](https://code.visualstudio.com/docs/ "Visual Studio Code Documentation") - Guides and references for Visual Studio Code
- [Git Documentation](https://git-scm.com/doc "Git Documentation") - Official Git reference and tutorials
- [Windows Package Manager (winget)](https://learn.microsoft.com/windows/package-manager/ "Windows Package Manager") - Documentation for the winget command-line tool

---

*Page revised: March 7, 2026*

<hr style="height:1px solid;">

sdsdsd
