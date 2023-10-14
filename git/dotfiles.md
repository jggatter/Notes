#linux #dotfiles

## Storing dotfiles in a repo
[Guide](https://www.ackama.com/what-we-think/the-best-way-to-store-your-dotfiles-a-bare-git-repository-explained/) and my notes: [[git work trees and bare]]

Done using a bare repository and configuring `$HOME` as the work tree.

```zsh
# Initialize bare repository used to track dotfiles: .cfg/
git init --bare $HOME/.dotfiles

# Store in zshrc/bashrc
alias git-df='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# Do not display untracked files for cleanliness
git-df config --local status.showUntrackedFiles no

# Add files and commit
git-df add .zshrc .bashrc .vimrc  # etc.
git-df commit -m "Initial commit with rc files"

# Create new repository on github
git-df remote add origin https://github.com/jggatter/dotfiles.git
git-df branch -M main
git-df push -u origin main
```

## Cloning this repository

```zsh
git clone --bare git@github.com/jggatter/dotfiles.git $HOME/.dotfiles

alias git-df='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
git-df config --local status.showUntrackedFiles no
git-df checkout

# If unsuccessful checkout due to risk of overwriting files. E.g.
mv .bashrc .bashrc_backup 
git-dotfiles checkout
```