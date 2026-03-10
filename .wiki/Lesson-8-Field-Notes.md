This page captures practical lessons learned while working with this project - things that were not obvious at first but became clear through hands-on experience. These are the kind of insights that only surface when you actually build, configure, and troubleshoot a real repository.

For AI-assisted coding exercises and GitHub Copilot configuration, see the [Lesson 6 AI as a Learning Companion](./Lesson-6-AI-as-a-Learning-Companion) and [Lesson 7 Copilot Configuration](./Lesson-7-Copilot-Configuration) pages.

## Extension recommendations in multi-root workspaces

Extension recommendations in multi-root workspaces behave differently than expected. When opening a single folder, Visual Studio Code reads `.vscode/extensions.json` and shows recommended extensions as expected. However, when the same folder is opened as part of a multi-root workspace, folder-level extension recommendations are ignored.

### Why folder-level recommendations are ignored

In a multi-root workspace, the configuration hierarchy changes. Visual Studio Code treats the workspace file as the single source of truth - not the individual folders.

A single folder setup reads recommendations normally:

```text
📂 folder/
   └── 📂 .vscode/
       └── 📄 extensions.json   ← works
```

A multi-root workspace ignores folder-level recommendations:

```text
📄 my-workspace.code-workspace
📂 folderA/
   └── 📂 .vscode/
       └── 📄 extensions.json   ← ignored
📂 folderB/
   └── 📂 .vscode/
       └── 📄 extensions.json   ← ignored
```

This is an intentional design choice. In multi-root workspaces, only workspace-level recommendations are used. This prevents conflicts where different folders might recommend competing extensions - for example, one folder recommending ESLint while another recommends TSLint.

### The solution - workspace-level recommendations

Extension recommendations must be defined in the workspace file to take effect in a multi-root setup:

```jsonc
{
  "folders": [
    { "path": "folderA" },
    { "path": "folderB" }
  ],
  "extensions": {
    "recommendations": [
      "ms-python.python",
      "esbenp.prettier-vscode"
    ]
  }
}
```

This is the only source Visual Studio Code reads for extension recommendations in multi-root mode.

### Key takeaway

Visual Studio Code treats a multi-root workspace as a single project, even if it contains many folders. The workspace file becomes the authoritative configuration for extension recommendations, settings, and other workspace-level concerns. When working with multi-root workspaces, always define extension recommendations in the workspace file rather than in individual folder-level `.vscode/extensions.json` files.

## Copilot instructions and the GitHub Wiki sidebar

GitHub Wiki treats every Markdown file in the repository as a wiki page and displays it in the sidebar. This includes files that are not intended to be pages - such as `.github/copilot-instructions.md`. If this file is committed to the wiki repository, it appears in the sidebar as a page titled "copilot instructions", which is confusing and clutters the navigation. For an introduction to creating and maintaining the copilot-instructions.md file, see [Lesson 7 Copilot Configuration](./Lesson-7-Copilot-Configuration).

### Why this happens

GitHub Wiki has no concept of hidden pages, draft pages, or sidebar exclusions. Every `.md` file in the repository root or subfolders is automatically listed in the sidebar. There is no configuration file, frontmatter property, or naming convention that prevents a Markdown file from appearing as a page.

This means any supporting file - custom instructions, templates, notes - will show up as a wiki page if it is a Markdown file and is committed to the repository.

### The workaround - exclude the folder via .gitignore

Since there is no way to hide a page from the sidebar, the solution is to prevent the file from being committed to the wiki repository in the first place. Adding `.github/` to the wiki repository's `.gitignore` keeps `copilot-instructions.md` out of the published wiki while still allowing it to exist locally for GitHub Copilot to read:

```text
#directories to ignore
.github/
```

This works because GitHub Copilot reads the file from the local working directory - it does not need the file to be committed or pushed. The `.gitignore` entry ensures the file stays local and never appears in the wiki sidebar.

### No built-in way to hide wiki pages

As of this writing, GitHub Wiki does not support any of the following:

- A sidebar configuration file that controls which pages are listed
- Frontmatter properties to mark a page as hidden or unlisted
- Filename prefixes (like `_` or `.`) that suppress sidebar listing - dotfiles are simply not shown, but subfolder Markdown files still appear
- A `.wikiignore` or equivalent mechanism

The custom sidebar feature (`_Sidebar.md`) only controls the content of the sidebar panel - it does not prevent pages from being accessible or listed in the default page index. If `_Sidebar.md` exists, it replaces the auto-generated sidebar, but all pages remain accessible via direct URL.

### Key takeaway

Keep non-page Markdown files out of the wiki repository entirely using `.gitignore`. This is the only reliable way to prevent unwanted files from appearing in the GitHub Wiki sidebar.

## GitHub Wiki does not support branch switching

GitHub Wiki repositories do not support branches the same way normal repositories do. Each wiki is backed by a separate Git repository that normally only has one branch - `master` or `main`. The GitHub web UI always shows the default branch and provides no way to switch between branches. This means branching workflows that work in regular repositories do not translate directly to wikis.

### Why this is a limitation

In a normal repository, branches are a core part of the workflow - creating feature branches, reviewing changes in pull requests, and merging when ready. GitHub Wiki repositories are Git repositories under the hood, so branches can technically be created, but the web interface does not expose them. There is no branch selector, no pull request support, and no way to preview content from a non-default branch on `github.com`.

### Working with branches locally

Since the wiki is a Git repository, branches can be created and managed through the command line. The wiki repository URL follows the pattern `<repo>.wiki.git`:

```powershell
# Description: Clone the wiki repository and create a dev branch
# Elevation is not required - Git operations do not require elevated privileges

git clone https://github.com/<org>/<repo>.wiki.git
cd <repo>.wiki
git checkout -b dev
```

Editing wiki pages locally is straightforward because the pages are just Markdown files. Changes on a non-default branch remain invisible in the web UI until merged back to the default branch:

```powershell
# Description: Merge the dev branch into the default branch and push
# Elevation is not required - Git operations do not require elevated privileges

git checkout main
git merge dev
git push
```

### Important limitations to keep in mind

Working with wiki branches comes with several constraints:

- The GitHub web UI always shows only the default branch - there is no branch selector
- Non-default branches are only accessible via Git, not on `github.com/wiki`
- Pull requests are not supported for wiki repositories
- There is no built-in way to review or compare branch differences in the web interface

### Key takeaway

GitHub Wiki repositories are Git repositories, but the web interface only supports a single branch. Branches can be created and managed locally through Git, which is useful for drafts or experiments, but changes must be merged to the default branch to appear in the published wiki. Treat the wiki repository like any other Git repository - just without the web-based branch and pull request support.

## Launching Windows Sandbox from Visual Studio Code

Windows Sandbox provides a lightweight, disposable desktop environment for testing scripts without affecting the host machine. If the repository contains a Windows Sandbox configuration file (`.wsb`), a Visual Studio Code task can launch it directly from the editor - no need to navigate to the file in Explorer.

### Setting up the task

Visual Studio Code tasks are defined in `.vscode/tasks.json`. The following task launches a `.wsb` file located in the `solution/` folder:

```jsonc
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "Launch Windows Sandbox",
      "type": "shell",
      "command": "start ${workspaceFolder}/solution/solution.wsb",
      "group": "none",
      "presentation": {
        "reveal": "silent"
      },
      "problemMatcher": []
    }
  ]
}
```

The `type` is set to `shell`, which runs the command through the system shell. This is necessary because `.wsb` files are not executables - they rely on a Windows file association to open with Windows Sandbox. Using `process` instead of `shell` would fail with error code 193 (`ERROR_BAD_EXE_FORMAT`), since the `CreateProcess` API does not use file associations. The `start` command tells the shell to open the file using its registered handler, just like double-clicking it in Explorer. The `presentation.reveal` setting is set to `silent` to keep the terminal panel from appearing, since this is a GUI launch with no console output.

There are several ways to run the task:

- **Command Palette** - press **Ctrl+Shift+P**, type **Tasks: Run Task**, and select **Launch Windows Sandbox**
- **Terminal menu** - select **Terminal > Run Task** from the menu bar and pick the task from the list

### Adding a keyboard shortcut for the task

For faster access, a custom keyboard shortcut can be assigned to run the task directly. Open `keybindings.json` by pressing **Ctrl+K Ctrl+S** to open the Keyboard Shortcuts editor, then click the file icon in the top-right corner to edit the JSON file. Add the following entry:

```jsonc
{
  "key": "ctrl+shift+alt+s",
  "command": "workbench.action.tasks.runTask",
  "args": "Launch Windows Sandbox"
}
```

The `args` value must match the `label` in the task definition exactly. With this keybinding in place, pressing **Ctrl+Shift+Alt+S** launches Windows Sandbox immediately - no menus or prompts involved.

There is an important limitation to be aware of - keyboard shortcuts are a user-level setting. Visual Studio Code does not support workspace-level keybindings, so there is no `.vscode/keybindings.json` and the `.code-workspace` file does not have a keybindings section. The shortcut must be configured in the user-level `keybindings.json` and cannot be shared with collaborators through the repository. This is an intentional design choice to prevent repositories from overriding a user's key bindings.

### Understanding the Windows Sandbox configuration file

The `.wsb` file controls how Windows Sandbox is configured at launch. A typical configuration maps a host folder into Windows Sandbox so scripts and files are accessible inside:

```xml
<Configuration>
    <MappedFolders>
        <MappedFolder>
            <HostFolder>.\</HostFolder>
            <ReadOnly>false</ReadOnly>
        </MappedFolder>
    </MappedFolders>
    <Networking>Enabled</Networking>
    <VGpu>Disable</VGpu>
</Configuration>
```

The `<HostFolder>` path is relative to the location of the `.wsb` file. In the example above, `.\` maps the folder where `solution.wsb` lives - the `solution/` folder - into Windows Sandbox.

### Changing the mapped folder

To map a different folder - for example the repository root instead of the `solution/` folder - change the `<HostFolder>` value to a relative path that points to the desired location:

```xml
<MappedFolders>
    <MappedFolder>
        <HostFolder>..\</HostFolder>
        <ReadOnly>false</ReadOnly>
    </MappedFolder>
</MappedFolders>
```

Since `solution.wsb` is in `solution/`, the path `..\` resolves to the repository root. This makes the entire repository available inside Windows Sandbox, which is useful when scripts reference files outside the `solution/` folder.

To map a completely different host folder, an absolute path can also be used:

```xml
<HostFolder>C:\Projects\my-scripts</HostFolder>
```

The `<ReadOnly>` element controls whether the mapped folder is writable inside Windows Sandbox. Setting it to `true` prevents any changes inside Windows Sandbox from affecting the host files - useful when testing destructive operations. Setting it to `false` allows Windows Sandbox to write back to the host folder, which is useful when scripts log output to a file - the log file appears on the host and can be opened directly in Visual Studio Code for review.

### Key takeaway

A Visual Studio Code task combined with a `.wsb` configuration file provides a quick, repeatable way to launch Windows Sandbox with the right folders mapped. This is especially useful for repositories containing PowerShell scripts, where testing in an isolated environment is a good practice. Adjusting the `<HostFolder>` path in the `.wsb` file controls exactly which folder from the host is available inside Windows Sandbox.

## Mirroring wiki pages into the main repository

GitHub Wiki repositories do not support pull requests, which means wiki changes cannot be reviewed alongside code changes in the normal branch-based workflow. A practical workaround is to mirror wiki Markdown files into a `.wiki/` folder in the main repository. This makes wiki edits visible in branch diffs and pull requests, bringing the same review workflow to wiki content.

### Setting up the sync task

A Visual Studio Code task can use `robocopy.exe` to copy `.md` files from the wiki repository into the main repository. The following task mirrors all Markdown files from the wiki root into a `.wiki/` folder:

```jsonc
{
  "label": "Sync Wiki Pages",
  "type": "shell",
  "command": "robocopy.exe '${workspaceFolder}/../hello-world.wiki' '${workspaceFolder}/.wiki' *.md /XF _*.md /PURGE; if ($LASTEXITCODE -le 7) { exit 0 } else { exit 1 }",
  "group": "none",
  "presentation": {
    "reveal": "always"
  },
  "problemMatcher": []
}
```

The `/XF _*.md` flag excludes files that start with an underscore, such as `_Footer.md` and `_Sidebar.md`, which are GitHub Wiki layout files and not actual pages. The `/PURGE` flag removes files from the `.wiki/` folder that no longer exist in the wiki repository, keeping the mirror in sync. The exit code handling at the end is needed because `robocopy.exe` uses exit codes 1-7 for various success conditions (e.g., 1 means files were copied, 2 means extra files were removed). Visual Studio Code treats any non-zero exit code as a failure, so the `if` statement normalizes codes 0-7 to exit code 0.

### The editing workflow

All changes to wiki pages must be made in the wiki repository - never edit the mirrored files in `.wiki/` directly. The `.wiki/` folder is a read-only copy that gets overwritten each time the sync task runs. The intended workflow is:

1. Edit wiki pages in the wiki repository (the `hello-world.wiki` workspace folder)
2. Run the **Sync Wiki Pages** task to mirror the changes into the main repository's `.wiki/` folder
3. Commit and push both repositories as part of the same branch workflow
4. The mirrored `.wiki/` files appear in the pull request diff, making wiki changes reviewable alongside code changes
5. After the pull request is reviewed and approved, remove the `.wiki/` folder before merging to keep the main branch clean

The removal step can be done with a simple commit on the dev branch after the review is complete:

```powershell
# Description: Remove mirrored wiki pages after pull request review
# Elevation is not required - Git operations do not require elevated privileges

git rm -r .wiki
git commit -m "Remove mirrored wiki pages after review"
```

This keeps the main branch free of duplicated wiki content while still allowing wiki changes to be reviewed as part of the pull request process.

### Why the .wiki/ folder should not be gitignored

The `.wiki/` folder in the main repository must be committed - not added to `.gitignore`. The entire purpose of mirroring is to make wiki changes visible in the main repository's branch and pull request workflow. If the folder were ignored, the mirrored files would not appear in diffs or reviews, defeating the purpose.

This does mean wiki content is temporarily duplicated across both repositories during the review cycle. The duplication is intentional and lightweight - only the `.md` files are copied, not the wiki's `.assets/` folder or other supporting files. Images referenced in wiki pages will not render in the mirrored copy, but the text content is fully reviewable.

### Key takeaway

Mirroring wiki pages into the main repository bridges the gap between GitHub Wiki's lack of pull request support and a standard branch-based review workflow. Always edit wiki pages in the wiki repository first, then run the sync task to update the mirror. Running the sync task before creating a pull request ensures wiki changes are included in the review. After the review, remove the `.wiki/` folder before merging to keep the main branch clean.

## Useful references

These resources provide further reading on the topics covered on this page:

- [Multi-root Workspaces](https://code.visualstudio.com/docs/configure/workspaces/multi-root-workspaces "Multi-root Workspaces") - Visual Studio Code documentation on multi-root workspaces
- [Adding or editing wiki pages](https://docs.github.com/en/communities/documenting-your-project-with-wikis/adding-or-editing-wiki-pages "Adding or editing wiki pages") - GitHub documentation on working with wikis
- [Windows Sandbox configuration](https://learn.microsoft.com/windows/security/application-security/application-isolation/windows-sandbox/windows-sandbox-configure-using "Windows Sandbox configuration") - Microsoft Learn documentation on configuring Windows Sandbox
- [Tasks in Visual Studio Code](https://code.visualstudio.com/docs/editor/tasks "Tasks in Visual Studio Code") - Visual Studio Code documentation on tasks

---

*Page revised: March 10, 2026*
