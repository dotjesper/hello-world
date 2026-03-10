This page covers the hands-on workflow of cloning repositories, working with branches, and using the daily Git cycle. These are the skills you will use every time you sit down to work on a project.

For creating and configuring a repository, see the [Lesson 2 Creating a Repository](./Lesson-2-Creating-a-Repository) page. For writing documentation, see the [Lesson 3 Writing Content](./Lesson-3-Writing-Content) page.

## Cloning a repository

Cloning creates a local copy of a GitHub repository on your device, so you can work on files offline and sync changes back to GitHub.

### Cloning using Visual Studio Code

The easiest way to clone a repository is directly from Visual Studio Code:

1. Open Visual Studio Code
2. Press **F1** to open the Command Palette
3. Type `Git: Clone` and select the command
4. Paste the repository URL (e.g., `https://github.com/<YOUR GITHUB ACCOUNT>/<YOUR REPOSITORY NAME>.git`)
5. Choose a local folder to save the repository
6. Open the cloned repository when prompted

### Cloning using the command line

You can also clone a repository using Git from the terminal:

```powershell
# Description: Clone a GitHub repository to the current directory
# Elevation is not required - Git clone operates in user space

git clone https://github.com/<YOUR GITHUB ACCOUNT>/<YOUR REPOSITORY NAME>.git
```

### Cloning a wiki repository

GitHub wiki repositories are separate Git repositories. Clone a wiki by appending `.wiki` to the repository name:

```powershell
# Description: Clone a GitHub wiki repository
# Elevation is not required - Git clone operates in user space

git clone https://github.com/<YOUR GITHUB ACCOUNT>/<YOUR REPOSITORY NAME>.wiki.git
```

### Working with private repositories

If the repository is private, Visual Studio Code will prompt you to authenticate with GitHub. Make sure you are signed in to your GitHub account in Visual Studio Code. If you experience issues, use the Command Palette approach:

1. Press **F1** in Visual Studio Code
2. Type `Git: Clone`
3. Paste the repository URL
4. Follow the authentication prompts

## Using multi-root workspaces

Multi-root workspaces in Visual Studio Code allow you to open both a repository and its wiki side by side in the same editor window. This is useful when you want to edit code and documentation together.

### Creating a multi-root workspace

To set up a multi-root workspace:

1. Open Visual Studio Code
2. Go to **File** > **Add Folder to Workspace...**
3. Select your main repository folder (e.g., `hello-world`)
4. Repeat step 2 and select the wiki repository folder (e.g., `hello-world.wiki`)
5. Save the workspace file using **File** > **Save Workspace As...** and give it a meaningful name (e.g., `hello-world.code-workspace`)

### Understanding the workspace file

The workspace file is a JSON file with a `.code-workspace` extension. It defines which folders are included, along with shared settings, recommended extensions, and launch configurations. Here is an example workspace file that includes both a repository and its wiki:

```json
{
  "extensions": {
    "recommendations": []
  },
  "folders": [
    {
      // Hello World
      "name": "Hello World project",
      "path": "hello-world"
    },
    {
      // Hello World wiki
      "name": "Hello World wiki",
      "path": "hello-world.wiki"
    }
  ],
  "launch": {
    "configurations": [],
    "compounds": []
  },
  "settings": {}
}
```

A few things to note about the workspace file:

- The `name` property sets the display name for each folder in the Visual Studio Code Explorer sidebar
- The `path` property is relative to the location of the workspace file - clone both repositories into the same parent folder for this to work
- The `extensions.recommendations` array can list extension identifiers that Visual Studio Code will suggest when opening the workspace
- The `settings` object can hold workspace-specific settings that override user settings

### Recommended folder structure

For the workspace file paths to resolve correctly, clone both the repository and the wiki repository into the same parent folder:

```text
📂 parent-folder/
   ├── 📂 hello-world/               # Main repository
   ├── 📂 hello-world.wiki/          # Wiki repository
   └── 📄 hello-world.code-workspace
```

Open the workspace file in Visual Studio Code by double-clicking it or using **File** > **Open Workspace from File...**.

## Working with branches

Branches let you work on changes without affecting the main codebase. This is a core concept in Git, even for non-developers.

### Creating a branch in Visual Studio Code

Creating a branch in Visual Studio Code takes just a few clicks:

1. Click the branch name in the bottom-left corner of Visual Studio Code
2. Select **Create new branch...**
3. Enter a descriptive branch name (e.g., `update-readme` or `add-wifi-script`)
4. Press **Enter** to create and switch to the new branch

### Creating a branch using Git

You can also create a branch from the terminal:

```powershell
# Description: Create and switch to a new Git branch
# Elevation is not required - Git branch operates in user space

git checkout -b your-branch-name
```

### Merging changes with pull requests

When your changes are ready, push the branch to GitHub and create a pull request:

1. Push your branch to GitHub using the **Publish Branch** button in Visual Studio Code or by running `git push -u origin your-branch-name`
2. Go to your repository on GitHub
3. Click **Compare & pull request** for your branch
4. Add a title and description explaining your changes
5. Click **Create pull request**
6. After review, click **Merge pull request** to merge the changes into the main branch

Pull requests are a great way to review changes before they are merged, even when working alone.

## The daily Git workflow

Understanding the basic Git workflow helps you stay organized and avoid losing work. The daily workflow consists of four key actions:

1. **Pull** - Get the latest changes from GitHub before you start working: `git pull`
2. **Stage** - Mark the files you want to include in your next commit: `git add .`
3. **Commit** - Save your staged changes with a descriptive message: `git commit -m "Add WiFi profile script"`
4. **Push** - Upload your commits to GitHub: `git push`

In Visual Studio Code, these actions are available in the **Source Control** panel (click the branch icon in the sidebar or press **Ctrl+Shift+G**).

## Useful references

These resources provide further reading on the topics covered on this page:

- [GitHub Documentation](https://docs.github.com/ "GitHub Documentation") - Official documentation for GitHub features
- [Git Documentation](https://git-scm.com/doc "Git Documentation") - Official Git reference and tutorials
- [Visual Studio Code Documentation](https://code.visualstudio.com/docs/ "Visual Studio Code Documentation") - Guides and references for Visual Studio Code

---

*Page revised: March 7, 2026*
