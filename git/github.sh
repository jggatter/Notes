## STARTING A REPOSITORY
# cd [directory]
# git init
# git add [path/to/files]
# git commit -m "first commit"
# git remote add origin [URL like https://github.com/ShalekLab/alexandria.git]
# git push -u origin master

## IF SOMEONE ELSE HAS UPDATED THE REPO
# git add/rm to handle local changes
# git pull
# git commit -m "explanation"
# git push -u origin master


### git reset <flag> <commit>
## Flags
#--soft: uncommit changes, changes are left staged (index).
#--mixed (default): uncommit + unstage changes, changes are left in working tree.
#--hard: uncommit + unstage + delete changes, nothing left.
## Commit
# HEAD is the local branch head

## https://stackoverflow.com/questions/5473/how-can-i-undo-git-reset-hard-head1
# git reflog
# git reset --hard <SHA1 for commit you want to go back to>

# Git remove all files that have been deleted.
#git rm $(git ls-files --deleted)
# Not sure?
#git add -u

# git checkout???
# git revert???