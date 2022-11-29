#git #dotfiles 

[Guide](https://www.ackama.com/what-we-think/the-best-way-to-store-your-dotfiles-a-bare-git-repository-explained/)

## Repositories

The git repository includes those objects that describe the state of the repository. These objects may exist in any directory, but typically exist in the `.git` directory in the top level directory of the workspace.

The state of a repository includes everything needed for version control; information like
- names of all existing branches, 
- commit history of those branches, 
- and the git log.

## Work trees

The work tree (aka working tree) does not store any information about the state of the repository. The work tree is a representation of the actual files tracked by the repository. These files are pulled out of the compressed database in the git directory and are placed on the disk for you to use or modify.

A work tree isn't a part of the repository, and a repository doesn't require a work tree. You can think of a work tree as a feature of a repository

The actual project files you get when cloning a repository are a working copy created by checking out a ref (branch, tag, or commit).

## Bare vs. Non-bare repositories

Non-bare respositories are the default initialized by `git init`. They are initialized with a work tree at the top level of the project directory. The git files are located in a `.git` folder within the project root directory (`/.git`).

A bare repository is initalized by `git init --bare <path/to/reponame>` . They do not contain a work tree and the git files are located in the project root directory.

