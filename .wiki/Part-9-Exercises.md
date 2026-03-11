This page is a companion handout for the [Hello World](https://github.com/dotjesper/hello-world/) project wiki. It collects the practical exercises from each part into a single reference you can follow during or after the session. Each exercise includes a brief description, step-by-step instructions, and a link to the full part for additional context.

The exercises are designed for device administrators, IT professionals, and anyone taking their first steps into version control. No prior development experience is needed.

## Prerequisites

Before starting the exercises, make sure you have the following in place:

- A GitHub account (free) - sign up at [GitHub](https://github.com/)
- A GitHub Copilot subscription (Free, Pro, or through your organization) - for Part 6 and 7 exercises
- Windows 11 with [Windows Package Manager (winget)](https://learn.microsoft.com/windows/package-manager/) available - most exercises can be completed on other operating systems such as macOS, but installation commands and paths may differ

## Part 1 - Getting started

These exercises cover installing and configuring the tools you need. See the full part: [Part 1 Getting Started](./Part-1-Getting-Started).

### Exercise 1.1 - Install Visual Studio Code and Git

Install both tools using the Windows Package Manager:

1. Open a PowerShell terminal
2. Install Visual Studio Code:

   ```powershell
   winget install --Id "Microsoft.VisualStudioCode" --silent
   ```

3. Install Git:

   ```powershell
   winget install --Id "Git.Git" --override "/VERYSILENT /NORESTART /COMPONENTS=ext,ext\shellhere,ext\guihere,gitlfs,assoc,assoc_sh,autoupdate"
   ```

4. Verify both are installed by opening Visual Studio Code and opening a terminal (**Terminal** > **New Terminal**)

### Exercise 1.2 - Sign in and configure Git

Connect Visual Studio Code to GitHub and set up your Git identity:

1. Open Visual Studio Code and click the account icon in the lower-left corner
2. Sign in with your GitHub account
3. Open a terminal and configure your Git identity:

   ```powershell
   git config --global user.name "Your Name"
   git config --global user.email "your-email-address@domain.com"
   ```

4. Verify your configuration:

   ```powershell
   git config --list
   ```

### Exercise 1.3 - Install recommended extensions

Install the following extensions from the Visual Studio Code Extensions sidebar (**Ctrl+Shift+X**):

- EditorConfig for VS Code
- GitHub Pull Requests
- GitLens
- PowerShell

## Part 2 - Creating a repository

These exercises walk through creating and configuring a GitHub repository. See the full part: [Part 2 Creating a Repository](./Part-2-Creating-a-Repository).

### Exercise 2.1 - Create a GitHub repository

1. Go to [GitHub](https://github.com/) and sign in
2. Click **+** > **New repository**
3. Enter a repository name (e.g., `my-first-repo`)
4. Add a description
5. Choose **Public** visibility
6. Check **Add a README file**
7. Click **Create repository**

### Exercise 2.2 - Configure repository settings

1. On your new repository page, click the gear icon next to **About**
2. Add a description, topics, and configure the home page options
3. Go to **Settings** > **General** > **Features** and enable:
   - [x] Wikis
   - [x] Issues
   - [x] Discussions

### Exercise 2.3 - Initialize Git in a local folder

1. Create a new folder on your device (e.g., `C:\Projects\my-scripts`)
2. Open the folder in Visual Studio Code (**File** > **Open Folder**)
3. Click the **Source Control** icon and click **Initialize Repository**
4. Create a simple file (e.g., `README.md`) with a project title
5. Stage the file, enter a commit message, and click **Commit**

### Exercise 2.4 - Connect your local repository to GitHub

1. Create a new **empty** repository on GitHub (do not check "Add a README file")
2. Copy the repository URL
3. In the Visual Studio Code terminal, add the remote and push:

   ```powershell
   git remote add origin https://github.com/your-username/your-repository.git
   git push -u origin main
   ```

4. Verify your files appear on GitHub

## Part 3 - Repository essentials

These exercises cover the essential files that make a repository professional. See the full part: [Part 3 Repository Essentials](./Part-3-Repository-Essentials).

### Exercise 3.1 - Write a README

Using the repository from Exercise 2.1 or 2.3, create or update `README.md` with the following sections:

1. **Title and description** - A clear project name and summary
2. **Prerequisites** - What is needed to use the project
3. **Usage** - How to run or use the project
4. **License** - The license type

Commit your changes with a descriptive message.

### Exercise 3.2 - Add repository configuration files

Add the following files to your repository:

1. A `.gitignore` file - use the templates at [github/gitignore](https://github.com/github/gitignore) or create a basic one:

   ```text
   # Editor files
   .vscode/.history/

   # OS files
   Thumbs.db
   .DS_Store
   ```

2. An `.editorconfig` file:

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
   ```

3. A `.gitattributes` file:

   ```text
   * text=auto eol=lf
   *.ps1 text eol=lf
   *.md text eol=lf
   *.png binary
   ```

4. Commit all three files in a single commit

### Exercise 3.3 - Practice commit messages

Make three small changes to your repository (edit the README, add a comment to a file, fix a typo) and practice writing good commit messages:

- Start with a short summary (50 characters or less)
- Use the imperative mood (e.g., "Add", "Update", "Fix")
- Reference the reason for the change when not obvious

## Part 4 - Branching and workflows

These exercises cover the daily Git workflow. See the full part: [Part 4 Branching and Workflows](./Part-4-Branching-and-Workflows).

### Exercise 4.1 - Clone a repository

1. Open Visual Studio Code
2. Press **F1** and type `Git: Clone`
3. Paste the URL of the [Hello World](https://github.com/dotjesper/hello-world/) repository:

   ```text
   https://github.com/dotjesper/hello-world.git
   ```

4. Choose a local folder and open the cloned repository

### Exercise 4.2 - Create a branch and make changes

1. Click the branch name in the bottom-left corner of Visual Studio Code
2. Select **Create new branch** and name it `update-readme`
3. Make a change to `README.md` in your own repository
4. Stage, commit, and push the branch:

   ```powershell
   git push -u origin update-readme
   ```

### Exercise 4.3 - Create a pull request

1. Go to your repository on GitHub
2. Click **Compare & pull request** for your branch
3. Add a title and description
4. Click **Create pull request**
5. Review the changes, then click **Merge pull request**

### Exercise 4.4 - Practice the daily workflow

Run through the full daily cycle in your repository:

1. **Pull** the latest changes: `git pull`
2. Make a small edit to any file
3. **Stage** the change: `git add .`
4. **Commit** with a message: `git commit -m "Update README with usage section"`
5. **Push** to GitHub: `git push`

## Part 5 - Working with repositories

These exercises cover downloading and referencing repository content programmatically. See the full part: [Part 5 Working With Repositories](./Part-5-Working-With-Repositories).

### Exercise 5.1 - Download a file using PowerShell

Download a single file from the Hello World repository using its raw URL:

```powershell
$rawUrl = "https://raw.githubusercontent.com/dotjesper/hello-world/main/README.md"
$outputPath = "$env:TEMP\README.md"

Invoke-RestMethod -Uri $rawUrl -OutFile $outputPath
Write-Output "Downloaded to: $outputPath"
```

Open the downloaded file and verify the content.

### Exercise 5.2 - Download a file using the GitHub REST API

Download the same file using the API endpoint:

```powershell
$apiUrl = "https://api.github.com/repos/dotjesper/hello-world/contents/README.md"
$headers = @{
    "Accept"     = "application/vnd.github.v3.raw"
    "User-Agent" = "PowerShell"
}

Invoke-RestMethod -Uri $apiUrl -Headers $headers -OutFile "$env:TEMP\README-api.md"
```

Compare the two approaches - when would you use the raw URL versus the API?

### Exercise 5.3 - Create a permalink to a file

1. Go to the [Hello World repository](https://github.com/dotjesper/hello-world/) on GitHub
2. Open any file (e.g., `README.md`)
3. Press **Y** to convert the branch URL to a permalink with the commit SHA
4. Copy the permalink - this URL will always point to this exact version of the file

## Part 6 - AI as a learning companion

These exercises introduce AI-assisted coding with GitHub Copilot. See the full part: [Part 6 AI as a Learning Companion](./Part-6-AI-as-a-Learning-Companion).

### Exercise 6.1 - Your first Copilot conversation

1. Open Visual Studio Code and press **Ctrl+Alt+I** to open Copilot Chat
2. Type the following prompt:

   ```text
   Please help me understand the difference between a PowerShell function and a cmdlet.
   ```

3. Read the response carefully
4. Follow up with:

   ```text
   Could you please show me a simple example of a PowerShell function that accepts
   a parameter?
   ```

5. Review the generated code - do you understand every line?

### Exercise 6.2 - Compare vague and specific prompts

Try both prompts in Copilot Chat and compare the results:

**Vague prompt:**

```text
Please help me draft a PowerShell script to get computer info.
```

**Specific prompt:**

```text
Please help me draft a PowerShell function that retrieves the computer name, operating
system version, total physical memory in GB, and last boot time. Use CIM instances
instead of WMI. Format the output as a custom PSObject. Include comment-based help
with a description and example usage.
```

Notice the difference in quality and completeness between the two responses.

### Exercise 6.3 - Generate and understand a script

1. Open a new file and save it as `Get-SystemUptime.ps1`
2. Ask GitHub Copilot:

   ```text
   Please help me draft a PowerShell script that calculates how long the current
   system has been running. Display the uptime in days, hours, and minutes. Use
   Get-CimInstance to retrieve the last boot time. Add a comment-based help block
   with a description and example.
   ```

3. Review the generated script - can you explain what every line does?
4. Ask GitHub Copilot to explain the code line by line
5. Modify the script yourself - add a `-ComputerName` parameter for remote systems

### Exercise 6.4 - Learn bitmasks through AI

Work through these prompts in sequence to discover a new concept:

1. Ask:

   ```text
   Please help me explore a design question. I have a PowerShell script that needs
   to enable or disable multiple features. Instead of using separate switch
   parameters for each feature, is there a cleaner approach using a single parameter?
   ```

2. Ask for a concrete example with bitmask values and the `-band` operator
3. Ask why feature values need to be powers of 2
4. Ask about the advantages and disadvantages compared to an array of feature names

### Exercise 6.5 - Validate AI-generated code

1. Ask GitHub Copilot to generate a script:

   ```text
   Please help me draft a PowerShell script that reads a CSV file of user display
   names and checks whether each account exists in Entra ID using Microsoft Graph
   PowerShell. Include error handling and output a summary of found and missing
   accounts.
   ```

2. Before using the code, work through this checklist:
   - [ ] Can you explain what every line does?
   - [ ] Does it handle empty input and malformed CSV files?
   - [ ] Does it handle credentials safely?
   - [ ] Would a colleague understand this code in six months?
   - [ ] Does it follow your naming conventions and coding standards?

3. Ask GitHub Copilot to review its own output for security issues and best practices

### Exercise 6.6 - Troubleshoot with logs and AI

1. Ask GitHub Copilot to generate a script that pings a list of computer names and logs the results with timestamps
2. Run the script with a few computer names to generate log output
3. Open the log file and ask GitHub Copilot to analyze it for errors and patterns
4. Ask for an optimized version that fails faster on unreachable devices

## Part 7 - Copilot configuration

These exercises cover creating and maintaining GitHub Copilot custom instructions. See the full part: [Part 7 Copilot Configuration](./Part-7-Copilot-Configuration).

### Exercise 7.1 - Create a copilot-instructions.md file

1. In your repository, create the file `.github/copilot-instructions.md`
2. Ask GitHub Copilot to help draft the initial content:

   ```text
   Please help me draft a copilot-instructions.md file for my PowerShell project.
   The file should include sections for coding conventions, project structure, and
   documentation standards. My scripts follow these conventions: verb-noun naming
   for functions, comment-based help on all functions, and CIM instances instead
   of WMI.
   ```

3. Review the generated draft - this file shapes every future GitHub Copilot interaction
4. Simplify to a focused first version covering coding conventions, script headers, and documentation standards
5. Commit the file to your repository

### Exercise 7.2 - Test your custom instructions

1. Open Copilot Chat in your repository (with the copilot-instructions.md file committed)
2. Ask GitHub Copilot to generate a simple PowerShell script:

   ```text
   Please help me draft a PowerShell script that retrieves the device serial number.
   ```

3. Check: does the output follow the conventions defined in your instructions file?
4. If not, refine the instructions and try again

## What to do next

After completing these exercises, consider these next steps:

- Explore the [Part 8 Field Notes](./Part-8-Field-Notes) wiki page for practical insights collected through hands-on experience
- Create a real repository for a project you are working on and apply what you have learned
- Set up a multi-root workspace with a repository and its wiki (see [Part 4](./Part-4-Branching-and-Workflows))
- Experiment with GitHub Copilot custom instructions to match your team's coding standards
- Share your repository with a colleague and practice the pull request workflow

## Useful references

- [Hello World repository](https://github.com/dotjesper/hello-world/) - Source code and project files
- [Hello World wiki](https://github.com/dotjesper/hello-world/wiki) - Full part content and field notes
- [Visual Studio Code Documentation](https://code.visualstudio.com/docs/)
- [Git Documentation](https://git-scm.com/doc)
- [GitHub Documentation](https://docs.github.com/)
- [GitHub Copilot documentation](https://docs.github.com/en/copilot)

---

*Page revised: March 10, 2026*
