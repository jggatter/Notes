#bash #linux #shell #unixlike #zsh
## Concepts
### Interactive vs. Non-interactive Session

An interactive session refers to a shell session in which the user can interact with the system by entering commands directly. This typically occurs when you log in to a text console, through graphic terminal emulator within a desktop environment or via SSH. 

In contrast, a non-interactive session or shell is one where the shell is running a script or command sequence that does not require user interaction. The shell executes commands that are fed to it in a batch mode from a script or through input redirection.

To sum it up, if you are able to type commands and get feedback from the shell, you are in an interactive session. Some characteristics of interactive sessions:
- Prompt availability (you can type commands)
- Command input -> display of output
- Command history
- Job control using commands or key combinations to stop (^Z), resume (`fg` or `bg`), or terminate (^C) them.
- Signal handling: certain signals like SIGINT (^C) may get handled differently

Certain scripts or commands can force non-interactive shells to behave interactively for testing purposes by manipulating file descriptors or using utilities like `expect`.
### Login vs. Non-login Shell
[Link](https://unix.stackexchange.com/a/46856)

#### Login

Login shell is the first process that executes under your user ID when you log in for an interactive session. 

The login process tells the shell to behave as a login shell with a convention: pass the name of the shell executable, e.g. `bash`, with a `-` prefixed as argument 0, i.e. `-bash`.

Login shells typically read a file that does things like set environments, e.g. for the Bourne shell, `sh`: `/etc/profile` and `~/.profile`.

When you log into a text console, or through SSH, or with `su -`, you get an **interactive login** shell. When you log in via graphical mode (e.g. on an X display manager) you don't get a login shell but rather a session or window manager.

It's rare to run a **non-interactive login** shell, but some X settings do that when you log in with a display manager, so as to arrange to read the profile files. Other settings (this depends on the distribution and on the display manager) read `/etc/profile` and `~/.profile` explicitly, or don't read them.

Another way to get a non-interactive login shell is to log in remotely with a command passed through standard input which is not a terminal, e.g. `ssh example.com <my-script-which-is-stored-locally` (as opposed to `ssh example.com my-script-which-is-on-the-remote-machine`, which runs a non-interactive, non-login shell).

#### Non-login

When you start a shell in an existing session (screen, X terminal, Emacs terminal, buffer, a shell inside another shell (`bash`)) you get an **interactive, non-login** shell. That shell may read a shell configuration file (`~/.bashrc` for `bash`). Some graphical terminal emulators do offer the option to run the shell as a login shell within the preferences.

When a shell runs a script or a command passed on its command line, it's a **non-interactive, non-login** shell. Such shells run all the time: it's very common that when a program calls another program, it really runs a tiny script in a shell to invoke that other program. Some shells read a startup file in this case (bash runs the file indicated by the `BASH_ENV` variable, `zsh` runs `/etc/zshenv` and `~/.zshenv`), but this is risky: the shell can be invoked in all sorts of contexts, and there's hardly anything you can do that might not break something.

#### Interactively determining whether login

To tell if you are in a login shell:
```bash
prompt> echo $0
-bash # "-" is the first character. Therefore, this is a login shell.

prompt> echo $0
bash # "-" is NOT the first character. This is NOT a login shell.
```

When I open the terminal on Fedora, it's an interactive, non-login Zsh session.

### Sourcing vs. Executing files

in the context of Unix-like shell environments, "sourcing" a file is equivalent to reading and executing its contents within the current shell process. When you source a script, all the commands in the file are executed as if they were typed directly into the current shell. This means that any environment variables or functions defined in the sourced file become part of the current shell's environment.

In `bash`, `zsh`, and similar shells, you can source a file using the `source` command or the `.` (dot) command:
```sh
source /path/to/file
```
or
```sh
. /path/to/file
```

After sourcing, if the file contains export statements that set environment variables, those variables will be available in the current session. If it contains function definitions, those functions will be callable from the shell. 

When you source a file that contains `export` statements, these exported environment variables are available not only in the current shell but also any child subshells and processes.

Sourcing a file is different from executing a script directly. When a script is executed (for example, `./script.sh` or `bash script.sh`), it runs in a new subshell. The environment of this subshell is initially a copy of the parent shell's environment. Thus, variables or functions defined in the script do not affect the environment of the parent shell that launched the script.

## Configuration files 
These files determine the behavior of the shell and the user's environment. They are often found in the home directory of a user.

### Bash

Interactive login shell only: Upon invocation, `bash` tries to source one of the following files and does not continue and does not continue to search once it has found one. The search happens in order:
1. `.bash_profile`: contains commands that should be run only once at login, such as setting up environment variables `PATH`, `EDITOR`, etc and running startup scripts.
3. `.bash_login` is not as commonly used, but it serves as an alternative to `.bash_profile`.
4. `.profile` is the older initialization file for the Bourne shell, `sh`.

Interactive non-login shell only: The `.bashrc` "run commands" file is sourced. This file is sometimes sourced manually from `.bash_profile` to ensure that settings apply to both login and non-login shells. If you wanted to do this:
```bash
# Check if running in an interactive shell
if [ -n "$PS1" ]; then
    # Check if .bashrc exists and source it
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi
```
If there are any login-specific configurations (like setting up environment variables that should only be set once when the user logs in), those can still go in `.bash_profile`.

When an interactive shell exits, `.bash_logout` is sourced. It can contain commands to clean up the environment and typically does tasks like clearing the screen to protect the privacy of your work.

Non-interactive shells do not normally read any of the files mentioned. Non-interactive shells are for script execution, and they only read environment variables from the environment that started them. However, non-interactive shells will read the contents of the `BASH_ENV` environment variable if it is set. This variable should point to a file that the shell will source before execution.

### Zsh

The `.zshenv` file is always sourced, regardless of whether the shell is a login shell or whether it is an interactive shell. If you have an environment variable or settings that need to be present in both interactive and non-interactive sessions, `.zshenv` is the place to set them. In the context of scripting, it is often better practice to not rely on files and specify necessary environment variables and settings within the script themselves to ensure portability and predictable behavior. 

Login shells source `.zprofile` after `.zshenv`. It's a good place to store commands that should only be run in login shells.

Interactive shells source `.zshrc`. The equivalent of `.bashrc`, it's a good place to put commands that apply to interactive shells.

After `.zshrc`, an interactive login shell will source `.zlogin`. It's often used to execute commands that cleanup an entire environment after it's set up.

When a login shell exits, `.zlogout` is sourced. It can be used to clean up thing set by `.zlogin` or `.zprofile`.

### Other

For Zsh/Bash, global counterparts for user-specific configuration files are located within the `/etc` directory. These system-wide configuration files set the default environment for all users. The global counterparts are generally sourced before or after the respective user-specific counterpart. A more specific note: in Zsh, the file `/etc/zshenv` is sourced before `~/.zshenv`, which is slightly different from the Bash behavior, where `/etc/profile` is sourced before `~/.bash_profile` or the others.

Also for Zsh/Bash, sometimes people manually source a `.zsh_aliases`/`.bash_aliases` file within their `.zshrc`/`.bashrc` file. This is used to keep aliases separate from the main configuration.

For the `readline` library used by shells for input, the `.inputrc` can be sourced to allow custom behaviors and key bindings.

`/etc/skel` is a directory that contains a set of default files, including shell configurations, to give to newly created users. The files here are copied to the new home directory when the `useradd` command creates the new user.

## Job control

Job control is a feature that allows users to manipulate the state of running processes directly from the command line or a terminal interface. When you are working in a shell, you may sometimes need to run a long process and do something else in the meantime, you may start a process and then realize you need to do something else before letting it continue. Job control allows you to pause, resume, or terminate jobs. A "job" is typically a shell-initiated process.

When you end a command with the `&` operator, it starts the command in the background.

`jobs` lists all current jobs along with their states, which could be running, stopped, or terminated.

`bg` resumes a suspended job in the background. If you have a job that you've stopped by pressing `Ctrl-Z`, then you can resume it in the background via `bg %jobnumber` where `jobnumber` is displayed next to the job by the `jobs` command.

`fg` brings a job to the foreground, making it the current job. If you've stopped a job via `Ctrl-Z`, you can continue it in the foreground via `fg %jobnumber`.

`Ctrl+Z` is a key combination that stops a job running in the foreground via the `SIGSTOP` signal. It does not terminate the job. You can then leave it stopped or use `bg` to move it to run in the background.

`kill %jobnumber` sends a `SIGTERM` signal that asks a process to terminate gracefully. `kill -9 %jobnumber` will forcefully terminate a job. Note that `%jobnumber` is used to refer to a job control job number rather than a process ID. `kill` also accepts PIDs.

`disown` removes a job from the shell's job table. This means that the shell will no longer report its status, and will not try to terminate it when the shell exits. This can be useful for long-running jobs that you do not want to terminate when the terminal closes.

Example:
```console
$ long-running-command

# Press Ctrl+Z to suspend the command
^Z
[1]+  Stopped                 long-running-command

# Check the job's status
$ jobs
[1]+  Stopped                 long-running-command

# Move the job to the background
$ bg %1
[1]+ long-running-command &

# Bring the job back to the foreground
$ fg %1
long-running-command

# You can also kill the job if needed
$ kill %1
```

## Input/Output Management

### Pipes and Redirection

The `|` operator passes the output of one command as the input to the next:
`command1 | command2`
e.g.
`ls | sort`  sorts and displays the output of `ls`.

Redirection is used to control where the output of a command goes or where the input of a command comes from. An output could go to another file or another command. An input could come from a file (instead of the keyboard).

There are standard streams:
- Standard input (`stdin`): Typically the keyboard denoted by file descriptor `0`.
- Standard output (`stdout`): The screen, denoted by file descriptor `1`.
- Standard error (`stderr`): Error messages output to the screen, denoted by file descriptor `2`.

There are quite a few redirection operators:
- `>` redirects standard output to a file, overwriting it if it exists
- `>>` redirects and appends standard output to a file
- `<` redirects standard input from a file
- `2>` redirects standard error to a file
- `2>&1` redirects standard error to standard output.
- `&>` (Bash-specific) redirects both standard output and error to a file

### Here Documents (Heredocs)

A type of redirection that allows you to pass a block of text (multiple lines) as input to a command. The syntax is `command <<DELIMITER ... DELIMITER` where `...` is the block of text and `DELIMITER` is any text that denotes the start and end of the heredoc.

Example:
```sh
cat <<EOF
This is a line.
This is another line.
EOF
```
This will send the two lines of text as input to `cat`, which then prints them.

### Command Substitution

TODO

### Process Substitution

Process substitution allows a process' input or output to be referred to using a filename. Technically, doing so creates a pseudo-file (often under `/dev/fd/`).

It's useful for using multiple processes to send the output of a command to multiple processes. 

It's especially handy when dealing with commands that expect files as arguments but you want to use the output of another command instead.

The syntax is as follows:
- `<(command)`: The output of a `command` is made available as a named file
- `>(command)`: A named file is provided that will send input to a command

Examples:
- `diff <(ls dir1) <(ls dir2)` - Compares the output of `ls` on `dir1` and `dir2`.
- `cat > >(command)` - Takes the output of `cat` and uses it as input for `command`.
* `tar -cf >(ssh remote_server tar xf -) .` - Transfer all contents of the current directory to a remote server. The archive is created on the fly and is extracted on the server.

### Variable interpolation

TODO
## Options

Shell options are settings that alter the behavior of the shell itself. These options can control a wide range of shell activities, from globbing patterns to the way jobs are handled in the background.

The `set` command is a built-in command that is used to enable or disable shell options and positional parameters. It works for Bash and Zsh sessions. You can turn options on via `set -o optionname` and off via `set +o optionname`. Running `set` without any arguments will display the name and values of all shell variables. 

In Bash, the `shopt` command is used to set and unset `bash` shell options. You can turn options on with `shopt -s optionname` and off with `shopt -u optionname`. Running `shopt` without any options will display the status of each shell option. Running `shopt` without any arguments will display the name and values of each `bash` shell option

In Zsh, the `setopt` and `unsetopt` commands are used to set and unset `zsh` options. There is usually an equivalent options in Zsh for a given Bash option. Where you might use `shopt -s extglob` in Bash, you can use `setopt EXTENDED_GLOB` in Zsh. Just as `set` affects Bash sessions, so too does it affect Zsh sessions. Just note that the behavior may differ between the two shells.

Commonly used shell options:
- **`set -e`**: Exit immediately if a command exits with a non-zero status. Scripts often use this to catch errors
- **`set -u`**: Treat unset variables as an error when substituting. Scripts often use this for catching bugs.
- **`set -x`**: Print commands and their arguments as they are executed. This is useful for debugging scripts.
- **`set -o pipefail`**: Return the exit status of the last command in the pipeline that failed. This is useful for catching errors in a pipeline.
- **`set -o noclobber`**: Prevent the overwriting of files by redirecting output via `<`.

I very commonly use `set -euo pipefail` in my bash scripts after binding arguments to variable names.

Options for globbing:
- **`set -o noglob`**: Disable filename expansion (globbing)
- **`shopt -s globstar`**: Allow `**` to match recursively match all files and zero or more directories/subdirectories when used in a pathname expansion
- **`shopt -s dotglob`**: Include hidden files (i.e. filenames that start with `.`) in pathname expansions.
- **`shopt -s extglob`**: Enable extended pattern matching features
- **`shopt -s nullglob`**: Make patterns that match no files expand to a null string, rather than themselves.

History options:
- **`shopt -s histappend`**: Append to the history file rather than overwriting it.
- **`setopt SHARE_HISTORY`**: This shares history between all sessions.
- **`setopt HIST_IGNORE_ALL_DUPS`**: When set, Zsh won't write a command to the history if it's the same as the one before it.
- **`setopt HIST_IGNORE_SPACE`**: This tells Zsh to ignore commands that start with a space for the purposes of history.
- **`setopt HIST_FIND_NO_DUPS`**: This makes the `history` command and the `Ctrl+R` reverse search ignore duplicates.

Other options:
- **`setopt NO_CHECK_JOBS`**: This will not warn you about jobs that are running or stopped when you exit the shell.
- **`setopt CORRECT`**: This will attempt to correct the spelling of commands.
- **`setopt CORRECT_ALL`**: Similar to `CORRECT`, but applies to all arguments of the command.

## History

`history`: View history where each command has a corresponding number
`^r`: Incremental reverse search of history

`$?`: Return code of the last executed command
`$!`: Process ID (PID) of the most recent background command

### History expansion

`!<number>`: Interpolate the respective command from the history
`!!`: Interpolate the last used command
`!$`: Interpolate the last argument of the last command
`!*`: Interpolate all arguments of the last command
`!^`: Interpolate first argument of the last command

## Oh My Zsh

[Cheatsheet](https://github.com/ohmyzsh/ohmyzsh/wiki/Cheatsheet)

`alias`: List all aliases
`~`: `cd ~`
`d`: List last visited directories (`dirs -v`)
`-`: `cd` to last visited directory
`1`: `cd -1`
`...`: `cd ../..`

