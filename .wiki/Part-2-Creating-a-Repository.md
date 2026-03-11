This page walks through creating and configuring a GitHub repository from scratch. By the end, you will have a fully configured repository with a wiki, ready for collaboration.

> A repository is just a folder, it is as simple as that.<br>And then you add configuration files to make it a repository.

That is the core idea behind this part - start simple, then layer on the configuration that turns a folder into a well-structured, collaborative workspace.

For installation, configuration, and setup, see the [Part 1 Getting Started](./Part-1-Getting-Started) page. For writing documentation and structuring repository files, see the [Part 3 Repository Essentials](./Part-3-Repository-Essentials) page.

## Creating a GitHub repository

Creating a repository on GitHub gives you a central place to store and share your files, scripts, and documentation.

### Step-by-step guide

Follow these steps to create a new repository on GitHub:

1. Go to [GitHub](https://github.com/ "GitHub") and sign in with your account
2. Click the **+** icon in the top-right corner and select **New repository**
3. Enter a repository name - use lowercase with hyphens (e.g., `my-scripts`)
4. Add a description that explains the purpose of the repository
5. Choose **Public** or **Private** visibility
6. Check **Add a README file** to create an initial README.md
7. Optionally add a `.gitignore` template and a `.LICENSE` file
8. Click **Create repository**

### Editing repository details

Editing repository details helps visitors understand the purpose of the repository and improves discoverability. After creating the repository, click the gear icon next to **About** on the repository page to edit the details:

- **Description** - Add a short summary of the repository (e.g., "This repository contains the source code for the Hello World demonstration project.")
- **Website** - Add a URL if the project has an associated website
- **Topics** - Add topic tags separated by spaces to help others find the repository

Under the **Include in the home page** section, configure which items appear on the repository home page. These are my preferred settings:

- [x] **Releases**
- [ ] **Deployments**
- [ ] **Packages**

Click **Save Changes** when done.

### Adding a social preview

Adding a social preview image customizes the image shown when the repository is shared on social media. Go to **Settings** and find the **Social preview** section:

1. Click **Edit** under Social preview
2. Upload an image - images should be at least 640x320 pixels (1280x640 pixels for best display)
3. Save the changes

### Configuring repository features

Configuring repository features controls which GitHub features are available for the repository. Go to **Settings** > **General** and scroll to the **Features** section. These are my preferred settings for a new repository:

- [x] **Wikis** and enable **Restrict editing to collaborators only**
- [x] **Issues**
- [ ] **Sponsorships**
- [ ] **Preserve this repository**
- [x] **Discussions**
- [ ] **Projects**
- [x] **Pull requests**

### Setting up the wiki

Setting up the wiki gives you a place to write documentation alongside your code. After enabling Wikis in the repository settings:

1. Click the **Wiki** tab on the repository page
2. Click **Create the first page** - GitHub creates a default **Home** page
3. Edit the page content as needed
4. Set the edit message to describe the initial commit (e.g., "Initial commit")
5. Click **Save page**

To work with wiki pages locally, copy the clone URL from the wiki sidebar. The wiki is a separate Git repository with `.wiki.git` appended to the repository URL (e.g., `https://github.com/dotjesper/hello-world.wiki.git`).

## Initializing Git in a standalone folder

Not every project starts on GitHub. Sometimes you already have a folder with scripts, configuration files, or documentation on your local machine, and you want to start tracking changes with Git. Instead of creating a repository on GitHub first, you can initialize Git directly in an existing folder.

The folder does not need to be empty. Git can be initialized in a folder that already contains files - scripts, configuration files, documentation, or any other content. Existing files are not modified or removed when Git is initialized. They simply become untracked files that you can then stage and commit.

### When to use git init

Initializing Git locally makes sense when you already have files you want to track, when you want to experiment with Git before publishing anything, or when you simply prefer to start locally and push to GitHub later.

### Step-by-step guide using Visual Studio Code

Follow these steps to initialize Git in a standalone folder using the Visual Studio Code interface:

1. Open Visual Studio Code and select **File** > **Open Folder** to open the folder you want to track
2. Click the **Source Control** icon in the Activity Bar (or press **Ctrl+Shift+G**)
3. Click **Initialize Repository** - Visual Studio Code creates a hidden `.git` folder and the folder is now a Git repository
4. All existing files appear in the **Changes** list as untracked files
5. Click the **+** icon next to **Changes** to stage all files, or click the **+** icon next to individual files to stage them selectively
6. Enter a commit message (e.g., "Initial commit") in the message box and click **Commit**

### Step-by-step guide using the terminal

Follow these steps to initialize Git in a standalone folder using the terminal in Visual Studio Code:

1. Open Visual Studio Code and select **File** > **Open Folder** to open the folder you want to track
2. Open the terminal in Visual Studio Code by selecting **Terminal** > **New Terminal**
3. Run the following command to initialize a new Git repository in the folder:

```shell
git init
```

4. Git creates a hidden `.git` folder that tracks all changes - the folder is now a Git repository
5. Stage all existing files by running:

```shell
git add .
```

6. Create the first commit:

```shell
git commit -m "Initial commit"
```

Both approaches produce the same result - a fully functional local Git repository. You can stage changes, commit updates, and view history - all without a GitHub connection.

### Connecting to GitHub

Connecting a local repository to GitHub lets you back up your work, collaborate, and access your files from anywhere. To push your local repository to GitHub:

1. Create a new repository on GitHub following the steps in the [Creating a GitHub repository](#creating-a-github-repository) section - do **not** check **Add a README file** or any other initialization options, since you already have local content
2. Copy the repository URL from GitHub
3. Add the GitHub repository as a remote:

```shell
git remote add origin https://github.com/your-username/your-repository.git
```

4. Push your local commits to GitHub:

```shell
git push -u origin main
```

After pushing, the local folder and the GitHub repository are connected. From this point, the daily workflow is the same as any cloned repository - pull, stage, commit, push - as described in [Part 4 Branching and Workflows](./Part-4-Branching-and-Workflows).

## Useful references

These resources provide further reading on the topics covered on this page:

- [How to set up a well-configured repository](https://dotjesper.com/2026/how-to-set-up-a-well-configured-repository/ "How to set up a well-configured repository") - A detailed guide on repository configuration best practices
- [Adding or editing wiki pages](https://docs.github.com/en/communities/documenting-your-project-with-wikis/adding-or-editing-wiki-pages "Adding or editing wiki pages") - GitHub documentation on working with wikis
- [GitHub Documentation](https://docs.github.com/ "GitHub Documentation") - Official documentation for GitHub features
- [About repositories](https://docs.github.com/en/repositories/creating-and-managing-repositories/about-repositories "About repositories") - Understanding repository visibility and settings

---

*Page revised: March 9, 2026*
