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

## Clones
https://github.blog/2020-12-21-get-up-to-speed-with-partial-clone-and-shallow-clone/#

"There are three ways to reduce clone sizes for repositories hosted by GitHub.
- `git clone --filter=blob:none <url>` creates a _blobless clone_. These clones download all reachable commits and trees while fetching blobs on-demand. These clones are best for developers and build environments that span multiple builds.
- `git clone --filter=tree:0 <url>` creates a _treeless clone_. These clones download all reachable commits while fetching trees and blobs on-demand. These clones are best for build environments where the repository will be deleted after a single build, but you still need access to commit history.
- `git clone --depth=1 <url>` creates a _shallow clone_. These clones truncate the commit history to reduce the clone size. This creates some unexpected behavior issues, limiting which Git commands are possible. These clones also put undue stress on later fetches, so they are strongly discouraged for developer use. They are helpful for some build environments where the repository will be deleted after a single build."

This will get only the latest commit and no files (but still .git for all files which can be massive!):
```
git clone --depth=1 --no-checkout <url>
```
Pulling newer commits will increase the depth. To fetch older commits, `git fetch depth=N` where `N` is the depth of commits to fetch.

A sparse checkout is better:
```bash
git clone --filter=blob:none --sparse <url>
cd <repository>
git sparse-checkout set <path>
```
List currently set paths:
```bash
git sparse-checkout list
```
Add paths:
```sh
git sparse-checkout add <path>
```
List all paths not currently set:
```bash
git ls-tree -r HEAD --name-only | grep -vxF -f <(git sparse-checkout list)
```