# Copilot Instructions - Hello World

These instructions define project-specific rules for GitHub Copilot in this repository. Generic conventions for PowerShell, Markdown, terminology, and GitHub workflows are defined in the `.github/instructions/` files and apply automatically - this file covers only project-level overrides and patterns unique to hello-world.

The hello-world repository is a personal learning platform and reference for GitHub best practices, repository management, and PowerShell scripting.

## Project structure

The full project structure is defined in `README.md`. When creating or moving files, refer to that structure to ensure files are placed in the correct directories.

## File standards

All files in this repository must follow these standards:

- **Encoding**: UTF-8 for all files
- **Line endings**: LF (`\n`) - never CRLF (configured in `.vscode/settings.json` and `.editorconfig`)
- **Final newline**: Always insert a final newline at end of file
- **Trailing whitespace**: Trim trailing whitespace (except in Markdown files where trailing spaces may be intentional)
- **Indentation**: 2 spaces for Markdown, YAML, and JSON files; 4 spaces for PowerShell scripts (no tabs)

## Writing style

Writing style, prose conventions, and terminology rules are defined in the respective instruction files in the `.github/instructions/` folder, if present. Those files apply automatically across the workspace. The following project-specific conventions also apply:

- Use "I" for personal perspective

## Reviewing content

Reviewing content means systematically checking files for correctness, consistency, and compliance with the standards defined in this document and the applicable instruction files. A review should be performed before committing changes and applies equally to PowerShell scripts, Markdown files, and configuration files.

### What to review for

Every review should verify compliance with the conventions defined in the applicable instruction files, plus the following project-specific checks:

- **File standards**: UTF-8 encoding, LF line endings, final newline present, trailing whitespace trimmed, and 2-space indentation (no tabs)
- **Project structure alignment**: Files are placed in the correct directories as defined in the project structure section
- **Reading flow**: Content follows a logical progression, transitions between sections feel natural, and the document reads well from start to finish
- **Overlapping content**: No unintentional duplication across files - repetition is acceptable when restating context for a different audience or reinforcing a key point, but identical content copied across multiple files should be consolidated
- **Heading hierarchy**: No skipped heading levels (e.g., `##` jumping to `####`) and logical nesting of sections
- **List consistency**: Bullet style and punctuation follow the same pattern within each list - do not mix fragments and full sentences
- **Revision date**: The `*Page revised:*` footer reflects the date of the latest change
- **Link validity**: URLs, cross-references, and relative links point to existing and correct targets
- **Spelling and grammar**: No typos, correct grammar, and clear phrasing throughout
- **Accuracy**: Technical content is correct, code examples run without errors, and instructions produce the expected outcome

### Review approach

A review follows these steps:

1. Verify file standards - encoding, line endings, indentation, and final newline
2. Read through content for clarity, accuracy, and tone
3. Verify compliance with the applicable instruction files (writing style, terminology, PowerShell, Markdown)
4. Check reading flow - logical progression and smooth transitions between sections
5. Look for overlapping or duplicated content across files
6. Confirm files are placed in the correct project structure locations
7. Test code examples and commands where possible
8. Verify all links and cross-references resolve correctly
9. Check for spelling errors, grammar issues, and unclear phrasing

## Intentionally non-compliant files

The following files are intentionally non-compliant with the coding conventions defined in this document and the instruction files. Do not modify these files to fix style or naming violations - they exist for demonstration purposes:

- `solution/scripts/invoke-helloworld-v1.ps1` - Hello World v1 demonstration with intentional errors

## Companion wiki

The project wiki lives in the `hello-world.wiki` repository as a sibling workspace folder. Wiki pages follow separate conventions defined in the wiki's own `.github/copilot-instructions.md`. See the [project wiki](https://github.com/dotjesper/hello-world/wiki) for parts and field notes.

---

*Page revised: May 18, 2026*
