# tmux

## Plugins and Configuration

The tmux.conf file is the configuration file for tmux. Mine is in ~/.config/tmux/tmux.conf. After cloning tpm, `tmux source ~/.config/tmux/tmux.conf` can be used to source the conf file.

tpm is the tmux plugin manager that installs and loads `tmux` plugins. It must be cloned from GitHub prior to usage. At the bottom of the ~/.config/tmux/tmux.conf the `run` line sets tpm to download packages to ~/.tmux/plugins/tpm. tpm itself gets installed to this directory. `set -g @plugins` lines specify plugins to be installed by tpm. Once tpm is cloned and the tmux conf is sourced, `<prefix>I` installs these plugins.

If tpm returns exit code 1 upon trying to install plugins, then it is a good idea to kill all sessions, restart tmux, and retry. Additionally, reinstalling tmux and tpm might help.

## Sessions, windows, and panes

Sessions are the top-most layer and are a collection of one of more windows. You can have multiple sessions open at a time, but you're typically only attached to one. Each session has a single active window. Windows are containers to one or more panes. Windows are the equivalent to tabs in a web browser. Each window has a currently active pane and allows switching between panes. The currently active window is marked on the status line with an `*`. Panes are splits in the window and represent an individual terminal session. There is only one active at a time that you'll interact with.

# Commands

See [tmuxcheatsheet.com](https://tmuxcheatsheet.com).

The prefix key is key combination, by default `^b`, that enables entering of commands.

`tmux` outside of a current session will create and attach to a new session.
`tmux new -s <session name>` creates and attaches to a new, named session.
`:new` creates and attaches to a new session
`:new -s <session name>` creates and attaches to a new, named session
`tmux ls` lists active sessions when outside of an active session
`<prefix>s` lists active sessions when inside of an active session
`<prefix>w` preview windows for each session. `<Enter>` will attach to the selected session.

`<prefix>d` will detach from the currently attached session
`:kill-session` kills the current session
`tmux attach` attaches to the most recent session.
`tmux attach -t <session name` will attach to the specified session

`<prefix>c` creates a new window which is then set as the current active window.
`<prefix><number>` switch to the window corresponding the number
`<prefix>n` switch to the next window
`<prefix>p` switch to the previous window
`<prefix>` start entering a command which starts with `:`.
`:swap-window -s <source window number> -t <dest window number>` command swaps window positions

`<prefix>x` kill a single pane, confirming with yes or no. Alternatively, `exit` shell command, but this will not kill the session.
`<prefix>&` kill all panes. This will kill the window.

`<prefix>o` switch to the next pane
`<prefix>%` vertically split a pane
`<prefix>"` horizontally split a pane
`:join-pane -s <source window number> -t <dest window number>` join two windows as one pane

`<prefix><hold an arrow key>` resize a pane
`<prefix>{` swap pane
`<prefix>}` swap pane in the other direction
`<prefix>q` display pane numbers and press `<number>` to swap to displayed panes
`<prefix>z` toggle zoom in/out on a pane
`<prefix>!` convert a pane into a new window
`<prefix><spacebar>` toggle between pane layouts


## Navigating
https://superuser.com/a/209608
`<prefix>[`:  Enter copy mode to copy text or view the history.

Once in this mode you can do the following:

Function                     vi
--------                     --              -----
Half page down                `^d`
Half page up                     `^u`
Next page                         `^f`
Previous page                  `^b`
Scroll down                      `J` or `^e` or `^<down>`
Scroll up                           `K` or `^y` or `^<up>`
Search again                    `n`
Search again in reverse  `N`
Search backward            `?`
Search forward                `/` 
Select line                        `V`
Copy selection                `<enter>`

https://superuser.com/a/510310
Option `set -g mouse on` enables mouse mode

## Integrations

### `fzf`

`fzf` can start in a tmux pop-up using the `--tmux` flag. See the [README.md](https://github.com/junegunn/fzf?tab=readme-ov-file#--tmux-mode). The most useful commands seem to be `fzf --tmux center` or the other `right`/`left`/`top`/`bottom` options.

