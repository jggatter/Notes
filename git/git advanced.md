#git
```sh
# To turn any extended object reference into a hash:
git rev-parse HEAD

# `--verify` implies that: `The parameter given must be usable as a single, valid object name. Otherwise barf and abort.`
git rev-parse --verify HEAD

#To retrieve the short hash:
git rev-parse --short HEAD
```

## TODO: transform output

`git show <branch_name or commit_sha>:<file_path>`: View the content of the file from a specific branch without modifying existing file

`git checkout <branch_name> -- <file_path>`: Replace the current version of `example.txt` in your working directory with the version from the `feature-branch`. Keep in mind that this will overwrite any local changes you've made to the file.

git reset
`--soft`: uncommit changes, changes are left staged (index).
`--mixed` (default): uncommit + unstage changes, changes are left in working tree.
`--hard`: uncommit + unstage + delete changes, nothing left.

git revert

git merge

git bisect: This command helps you find the commit that introduced a bug in your code by performing a binary search. You can use git bisect start, git bisect good, and git bisect bad to guide the process.
`--first-parent`: Follow only the first parent commit upon seeing a merge commit.

git stash: Temporarily save changes in your working directory that you don't want to commit yet. You can apply these changes later using git stash apply.
-   `-u` or `--include-untracked`: Include untracked files in the stash.
-   `-a` or `--all`: Include all files, including ignored and untracked files, in the stash.
-   `-p` or `--patch`: Interactively select hunks to stash.

git cherry-pick: Apply changes from a specific commit to your current branch. This is useful when you want to bring a specific change from one branch to another without merging the entire branch.
-   `-n` or `--no-commit`: Apply changes from the commit but do not create a new commit.
-   `-e` or `--edit`: Allow editing of the commit message before committing.
0. Identify the SHA of the commit that exists on a different branch from the target
1. Switch to **target** branch (destination)
2. `git cherry-pick <commit SHA>`
3. Resolve any conflicts, add, commit


git reflog: Shows a log of all the actions performed on your local repository, including commits, branch switches, and more. This can be helpful for recovering lost commits or undoing a rebase.
`--expire=<time>`: Remove reflog entries older than the specified time.

git blame: Shows line-by-line authorship information for a file. This is useful when you want to find out who made a specific change to a file and when.
-   `-L <start>,<end>`: Limit the blame to the specified range of lines.
-   `-w`: Ignore whitespace changes when comparing lines.

git log --graph --decorate --oneline: Displays a visual representation of your commit history, which can be helpful for understanding the branching and merging in your project.
-  `-S "<string>"`: search the commit history for commits that introduce or remove a specific string (also known as "pickaxe" search), returning list of commits that added/removed instances of the specified string in the code.
-  `-G`: like `-S` but for regular expressions!
-   `--since=<date>`: Show commits more recent than the specified date.
-   `--until=<date>`: Show commits older than the specified date.
-   `-p`: Show the diff for each commit.
-   `--author=<pattern>`: Show commits only by the author matching the given pattern.
-   `--grep=<pattern>`: Show commits with messages matching the given pattern.
Both `-S` and `-G` can be combined with other `git log` options, like `--author`, `--since`, and `--until`, to further refine your search.

git rebase 
- `-i`: Interactive rebasing allows you to modify the commit history by combining, editing, or reordering commits.
-   `--onto=<newbase>`: Rebase the branch onto the specified new base commit.
-   `--preserve-merges`: Try to recreate merge commits instead of flattening the history.
-   `--autostash`: Automatically stash and reapply local changes before and after the rebase.

git fetch 
- `--prune`: Fetches updates from the remote repository and removes remote-tracking branches that have been deleted on the remote repository.
-   `--all`: Fetch updates from all remotes.
-   `--tags`: Fetch all tags, not just the ones reachable from the branches.

git show: Displays information about a specific commit, including the commit message, author, date, and changes made.
-   `--stat`: Show a diffstat summary of the changes made in the commit.
-   `--name-only`: Show the names of the changed files only.
-   `--name-status`: Show the names and status of the changed files.

git clean: Removes untracked files from your working directory. This can be helpful for cleaning up after a build or removing temporary files that shouldn't be committed.
-   `-d`: Remove untracked directories as well.
-   `-i` or `--interactive`: Interactively prompt before removing each file or directory.
-   `-n` or `--dry-run`: Show what files would be removed without actually removing them.
-   `-x`: Remove both ignored and non-ignored files.
-   `-X`: Remove only ignored files.

## Tags

```bash
git tag <version tag>
# Pushes the tag to the branch with <
git push origin <version tag>

git push --tags  # Pushes commits with local tags

# Shows local tags
git show-ref --tags

# Shows all tags
git tag -l
```

## Rebasing a Merge Queue

I have merge queue branch that I use to consolidate merged Dependabot pull requests.

Perhaps not the best practice, but I routinely rebase the merge queue branch to reset its history.

This rebases onto master, erasing commit history.
```sh
# Pull latest version of master
git checkout master
git pull

# Begin the rebase
git checkout merge-queue
git rebase master
```
I then resolve any conflicts and continue:
```sh
git add <conflicting files>
git rebase --continue
```
When the rebase succeeds, we force-push to the remote merge-queue.
```sh
git push -u origin merge-queue --force-with-lease
```

## Git Grep

```sh
# git grep a pattern in all of the content across all commits
# Filter search by a known path
# Set GIT_PAGER to cat so less is not used to display output
# Filter down to just the unique commit SHAs 
GIT_PAGER=cat git grep "LimmaDE" $(git rev-list --all) -- path/to/package/module/submodule/ \
	| cut -d : -f1 \
	| uniq

# Show info on a commit
git show --stat <commit>
```

## Git Bisect

Helps find the commit that introduced a bug using a binary search algorithm. Often requires a clean, "modular", and detailed commit history. If singular commits are too large and alter different functionalities of a project then it's not as useful for pinpointing changes that may be the cause.

1. Start via `git bisect start`
2. Mark the bugged commit as bad
	a. Current commit using `git bisect bad`
	b. Older commit using `git bisect bad <SHA>`
3. Mark a known good commit `git bisect good <SHA>` and you'll start advancing
4. Test current commit and mark as good or bad, continue until `git` narrows down the bad commit.
5. Finish the session by running `git bisect reset`, returning the HEAD to where it was before starting the session.

Git Worktrees

Alternative to stashing, switching, doing stuff, switching back, and stash applying. Also useful for reviewing other's PRs locally.

```sh
# It is a good idea not to test worktrees within other worktrees!
git worktree add ../path/to/new/worktree/repo_somebranch <branch to checkout>
cd ../path/to/new/worktree/repo_somebranch
git checkout -b somebranch
```