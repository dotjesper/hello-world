This page covers how to create, maintain, and share GitHub Copilot custom instructions across projects. Custom instructions give GitHub Copilot project-specific context, so every response is aligned with your conventions without repeating guidance in every prompt.

For hands-on walkthroughs with GitHub Copilot and AI-assisted coding, see the [Part 6 AI as a Learning Companion](./Part-6-AI-as-a-Learning-Companion) page. For practical discoveries about copilot-instructions.md in wiki repositories, see the [Part 8 Field Notes](./Part-8-Field-Notes) page.

## Adding copilot-instructions.md to your repository

A `copilot-instructions.md` file gives GitHub Copilot project-specific context every time it works with your repository. Instead of repeating the same guidance in every prompt, you define your conventions once and GitHub Copilot follows them automatically. This walkthrough guides you through creating and maintaining this file.

### What copilot-instructions.md does

The copilot-instructions.md file is a Markdown file stored at `.github/copilot-instructions.md` in your repository. When GitHub Copilot processes requests in Visual Studio Code, it reads this file and applies the instructions as additional context. This means every response GitHub Copilot gives is already aligned with your project's standards - without you having to specify them each time.

Common instructions include:

- **Coding conventions** - Naming patterns, formatting rules, and preferred cmdlets or modules
- **Project structure** - Where files go, how folders are organized, and naming patterns for new files
- **Documentation standards** - Comment styles, header formats, and required metadata in scripts
- **Security requirements** - Authentication patterns, credential handling, and compliance rules
- **Writing style** - Tone, terminology, and formatting rules for documentation and wiki pages

### Creating the file

Follow these steps to add a copilot-instructions.md file to your repository:

1. In Visual Studio Code, create the folder and file:

   ```text
    📂 your-repository/
     └─ 📂 .github/
         └─ 📄 copilot-instructions.md
   ```

2. Open Copilot Chat and ask for help drafting the initial content:

   ```text
   Please help me draft a copilot-instructions.md file for my PowerShell project.
   The file should include sections for coding conventions, project structure, and
   documentation standards. My scripts follow these conventions: verb-noun naming
   for functions, comment-based help on all functions, and CIM instances instead
   of WMI.
   ```

3. Review the generated draft carefully - this file shapes every future GitHub Copilot interaction in your repository, so it is worth getting right

4. Start simple. A good first version covers coding conventions, script headers, and documentation standards in short bullet lists. Here is an example structure:

   - A top-level heading like `# Copilot Instructions`
   - A `## Coding conventions` section with rules such as: use approved PowerShell verbs for function names (e.g., `Get-`, `Set-`, `New-`), use `Get-CimInstance` instead of `Get-WmiObject`, include comment-based help on all functions, and use PascalCase for function names
   - A `## Script header` section specifying that all scripts must include a description comment and an elevation requirement comment
   - A `## Documentation` section with rules like: use Markdown for all documentation, write in a professional but approachable tone, and use sentence case for headings

5. Commit the file to your repository so it is available on every device where you clone the project

> [!NOTE]
> The copilot-instructions.md file is read automatically by GitHub Copilot when you work in the repository. There is no additional configuration needed - just create the file in the `.github/` folder and commit it. For wiki repositories, there is a sidebar gotcha to be aware of - see the [Part 8 Field Notes](./Part-8-Field-Notes) page for a workaround using `.gitignore`.

### Maintaining the file over time

The copilot-instructions.md file is not a one-time setup - it evolves as your project grows and as you discover what guidance produces the best GitHub Copilot output.

Good maintenance habits include:

- **Add conventions as you establish them** - When you decide on a new pattern (like how to handle logging, error handling, or parameter validation), add it to the instructions file
- **Remove rules that do not work** - If a particular instruction consistently produces poor output, revise or remove it
- **Keep it focused** - Long, complex instruction files can confuse GitHub Copilot just as they confuse people. Aim for clear, concise rules
- **Review periodically** - As your project evolves, review the instructions to ensure they still reflect current practices

To update the file, you can ask GitHub Copilot for help:

```text
Please help me review my copilot-instructions.md file. Are there any sections that
could be clearer or more specific? What common PowerShell conventions am I missing?
```

### Real-world example

The wiki repository for this project includes a copilot-instructions.md file that defines writing style, page conventions, formatting rules, and terminology standards. Every wiki page GitHub Copilot helps create automatically follows these conventions - consistent heading levels, sentence case, proper terminology like "Visual Studio Code" instead of "VS Code", and the correct revision date format at the end of each page.

This is the practical benefit - instead of correcting GitHub Copilot's output after every interaction, you teach it your standards once and it applies them consistently.

## Sharing instructions across repositories

The repo-level `copilot-instructions.md` file works well for project-specific conventions, but some instructions apply to everything you do - writing style, documentation standards, or coding patterns you follow across all your projects. Rather than duplicating these instructions in every repository, you can store them in a central location and reference them globally. For more information on custom instructions, see [Custom instructions for GitHub Copilot in Visual Studio Code](https://code.visualstudio.com/docs/copilot/customization/custom-instructions).

### Storing shared instruction files

Create a folder in your OneDrive directory to hold reusable instruction files:

```text
 📂 %USERPROFILE%\OneDrive\.github\copilot-instructions\
  ├─ 📄 base.instructions.md                       # General coding conventions
  ├─ 📄 writing-session-abstracts.instructions.md  # Session abstract writing guide
  └─ 📄 documentation-style.instructions.md        # Documentation formatting rules
```

Storing instruction files in OneDrive ensures they sync automatically across all your devices. Each file covers a specific topic and can be maintained independently. This gives you a single source of truth for all reusable instruction sets.

> [!TIP]
> Consider turning the `.github\copilot-instructions\` folder into a Git repository. This gives you full version history and branching - useful when you want to experiment with new instructions without losing what already works. Since the folder is in OneDrive, you get both cloud sync and Git history.

### Referencing shared files in Visual Studio Code

Reference the shared instruction files in your global Visual Studio Code settings (`settings.json`) using absolute paths:

```json
"github.copilot.chat.codeGeneration.instructions": [
  { "file": "C:\\Users\\YourName\\OneDrive\\.github\\copilot-instructions\\base.instructions.md" },
  { "file": "C:\\Users\\YourName\\OneDrive\\.github\\copilot-instructions\\documentation-style.instructions.md" }
]
```

These files apply to every workspace you open in Visual Studio Code unless overridden by workspace-level settings.

> [!IMPORTANT]
> Visual Studio Code requires absolute paths - it does not expand `~` or `$HOME`. Use the full path to your OneDrive directory.

### Combining global and repo-level instructions

For projects that need both shared and project-specific instructions, add workspace-level settings in `.vscode/settings.json` that reference both:

```json
"github.copilot.chat.codeGeneration.instructions": [
  { "file": "C:\\Users\\YourName\\OneDrive\\.github\\copilot-instructions\\base.instructions.md" },
  { "file": "C:\\Users\\YourName\\OneDrive\\.github\\copilot-instructions\\documentation-style.instructions.md" },
  { "file": ".github/copilot-instructions/linked.instructions.md" },
  { "file": ".github/copilot-instructions/session.instructions.md" }
]
```

This layered approach gives you global reusable knowledge combined with local project-specific overrides - without duplicating content across repositories.

### Organizing multiple repo-level instruction files

As a repository grows, a single `copilot-instructions.md` file may not be enough. Creating a dedicated folder inside `.github/` keeps instruction files organized and easy to maintain:

```text
 📂 your-repository/
  └─ 📂 .github/
      ├─ 📄 copilot-instructions.md          # Auto-picked up by GitHub Copilot
      └─ 📂 copilot-instructions/
           ├─ 📄 linked.instructions.md      # Companion blog post writing guide
           ├─ 📄 session.instructions.md     # Session abstract writing guide
           └─ 📄 powershell.instructions.md  # PowerShell coding standards
```

The `copilot-instructions.md` file in the `.github/` root is picked up automatically by GitHub Copilot without any configuration. Additional files inside the `copilot-instructions/` folder need to be referenced explicitly in `.vscode/settings.json` - but having them in a clearly named folder makes it obvious what they are and where they belong.

### When to use each approach

Choosing the right location for your instructions depends on how broadly they apply:

| Approach | Location | Applies to |
| :------- | :------- | :--------- |
| Repo-level (single file) | `.github/copilot-instructions.md` | A single repository - auto-picked up |
| Repo-level (multiple files) | `.github/copilot-instructions/` | A single repository - referenced via settings |
| Global settings | `%USERPROFILE%\OneDrive\.github\copilot-instructions\` | All repositories on your device (synced via OneDrive) |
| Workspace settings | `.vscode/settings.json` | A specific workspace, combining global and local files |

Start with repo-level instructions for project-specific conventions. As you find patterns that repeat across repositories, move them to shared files and reference them globally.

## Useful references

These resources provide further reading on the topics covered on this page:

- [Custom instructions for GitHub Copilot in Visual Studio Code](https://code.visualstudio.com/docs/copilot/customization/custom-instructions "Custom instructions for GitHub Copilot in Visual Studio Code") - Visual Studio Code documentation on custom instructions
- [GitHub Copilot documentation](https://docs.github.com/en/copilot "GitHub Copilot documentation") - Official documentation for getting started with GitHub Copilot

---

*Page revised: March 10, 2026*
