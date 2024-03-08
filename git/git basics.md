#git #TODO

## Authenticate Git with GitHub
```sh
# Install GitHub CLI
brew install gh # Mac

# Login to GitHub and authorize Git CLI
# Say yes to authorizing Git CLI!
gh auth login 

# Clone a repository to local filesystem
gh repo clone <author/reponame>
```

In Git, the terms "origin" and "remote" have specific meanings:

1. **Origin**: This is the default name Git gives to the server you cloned from. When you run a command like `git clone [URL]`, Git automatically names this remote server "origin". It's like a nickname for the URL of the remote repository. This means you can refer to the remote repository as "origin" instead of the URL when pushing to or pulling from the repository.
2. **Remote**: This term refers to any version of your repository that is hosted on the internet or on a network somewhere. You can have several of them, and each has a different name. A remote in Git is a common repository that all team members use to exchange their changes. In most cases, such a remote repository is stored on a code hosting service like GitHub, Bitbucket, or on an internal server. In addition to the default "origin", you can add new remotes with different names pointing to different URLs.

TLDR; "origin" is the alias for the default remote version of your repository.

```sh
git remote -v # lists all the remote connections you have to other repositories.

# Sets origin as an SSH connection to the remote GitHub repository jgatter/Notes
git remote set-url origin git@github.com:jgatter/Notes.git

Please make sure you have the correct access rights
and the repository exists.
```
## Git basics
```sh
# Switch to an existing branch to which you wish to push changes
git checkout <branch>
# Switch to a new branch, branching off the current branch
git checkout -b <branch name>

# Pull latest commits that were pushed to branch
# a good idea to do before making changes
# may have to resolve merge conflicts otherwise
git pull
# Fetch upstream
git fetch -u origin <branch>

# Adds modified paths (files/folders) to index
git add <path>

# Remove deleted file from index
git rm <filepath>
# Remove file from index but keep the file
git rm --cached <filepath>
# Remove file from the index and delete it
git rm -f <filepath>
# Remove deleted directory and all files recursively
# can use with other flags
git rm -r <dirpath>

# These can accept wildcards like regular '*' or recursive '**'
git add **.py
git rm --cached */docs/**.md

# Diff file/folder of files not yet staged for commit
git diff <path>
# Diff file/folder of files staged for commit
git diff --cached <path>

# Unstage paths that are staged for commit
git restore --staged <path>
git restore --staged . # Restore all staged files

# Uncommit and unstage changes
git reset
# CAUTION: Reset all changes to the most recent commit, wiping all changes!
git reset --hard
# Travel back 1 commit before most recent commit, keeping current changes in stage
git reset --soft HEAD~1

# Commit staged files/folders to the index permanently
git commit -m "descriptive message of changes to index!"
# Amending commits
# WARNING: Best not to amend already pushed commits!
## 
git commit --amend -m "I changed my mind here's a better commit message"
# Realize you forgot to include another change in your commit!
# After git add, rm, etc. 
# no-edit doesn't change commit message!
git commit --amend --no-edit

# Push commits to 
# -u sets the upstream of "origin" here to the remote <branch>
git push -u origin <branch>
# For future pushes after an upstream is set:
git push
```

## New repository
```sh
# Create a new directory for your project and navigate to it in the terminal:

mkdir my-project
cd my-project
# Initialize the directory as a Git repository:

git init
# reate a new file or add existing files to the repository. For example, you can create a README.md file:
echo "# My Project" > README.md
# Add the files to the staging area:
git add .
# Commit the changes:
git commit -m "Initial commit"

# Go to GitHub and create a new repository. You can do this by clicking the '+' icon in the top-right corner and selecting 'New repository'. 
# Choose a name for your repository, add a description, and select whether to make it public or private.
# After creating the repository, copy the repository URL. It should look like 
# this: https://github.com/yourusername/my-project.git
# Add the remote repository to your local repository:
git remote add origin https://github.com/yourusername/my-project.git

# Push the changes to the remote repository:
git push -u origin main
```




