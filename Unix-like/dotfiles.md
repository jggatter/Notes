#linux #dotfiles

## Storing dotfiles in a repo
[Guide](https://www.ackama.com/what-we-think/the-best-way-to-store-your-dotfiles-a-bare-git-repository-explained/) and my notes: [[git work trees and bare]]

Done using a bare repository and configuring `$HOME` as the work tree.

```zsh
# Initialize bare repository used to track dotfiles: .cfg/
git init --bare $HOME/.dotfiles

# Store in zshrc/bashrc
alias git-dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Do not display untracked files for cleanliness
git-dotfiles config --local status.showUntrackedFiles no

# Add files and commit
git-dotfiles add .zshrc .bashrc .vimrc  # etc.
git-dotfiles commit -m "Initial commit with rc files"

# Create new repository on github
git-dotfiles remote add origin https://github.com/jggatter/dotfiles.git
git-dotfiles branch -M main
git-dotfiles push -u origin main
```

## Cloning this repository

```zsh
git clone --bare git@github.com/jggatter/dotfiles.git $HOME/.dotfiles

alias git-dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
git-dotfiles config --local status.showUntrackedFiles no
git-dotfiles checkout

# If unsuccessful checkout due to risk of overwriting files. E.g.
mv .bashrc .bashrc_backup 
git-dotfiles checkout
```