#vim #dotfiles 

## Configuring

I have my configuration installable through my dotfiles repository.

## Keys

This [cheatsheet](https://vim.rtorr.com/) is also pretty nice and I took some info from here.

### Basics

#### Insert

Normal mode:
`i`: Insert at cursor position
`I`: Insert at beginning of line
`a`: Insert after cursor position
`A`: Insert after end of line
`o`: Insert below line
`O`: Insert above line

#### Navigate

Normal or visual mode:
`h`: Move left
`j`: Move down
`k`: Move up
`l`: Move right

`w`: Move forward a word
`W`: Move forward a word that may contain punctuation
`b`: Move backwards a word
`B`: Move backwards a word that may contain punctuation
`e`: Move to the end of a word
`E`: Move to the end of a word that may contain punctuation
`ge`: Jump to the end of the previous word
`gE`: Jump to the end of the previous word that may contain punctuation

`{`: Move to next paragraph or block
`}` Move to previous paragraph or block

#### Delete or change

Normal mode:
`x`: Delete the current character

`dd`: Delete line
`dw`: Delete word
`daw`: Delete around word
`dap`: Delete around paragraph
`di"`: Delete inside `"sometext"`

`cc`: Change line
`cw`: Change word
`caw`: Change around word
`cap`: Change around paragraph
`ci"`: Change inside `"sometext"`

`r`: Replace a character
`R` Replace multiple characters until escape

Visual mode:
`d`: Delete
`c`: Change

#### Copy-paste

Normal mode:
`yy`: Yank line
`yw`: Yank word
`yaw: Yank around word
`yap`: Yank around paragraph
`yi"`: Yank inside `"sometext"`

`p`: Paste
`P`: Paste above

Visual mode:
`y`: Copy
`p`: Paste over

See Advanced for specifics about the register and system clipboards.

#### Undo and redo

Normal mode
`u`: Undo
`^r`: Redo

### Advanced

#### Misc

`.`: Repeat last command

#### Registers and the system clipboard

Special registers are stored in `~/.viminfo`.
`0`: last yank
`"`: last delete or yank
`%`: current filename
`#` alternate filename
`*`: clipboard contents (X11 primary)
`+`: clipboard contents (X11 clipboard)
`/`: last search pattern
`:`: last command-line
`.` last inserted text
`-`: last small (less than one line) delete
`=`: expression register
`_`: blackhole register

##### Linux

`"+y`: Yank to system clipboard
`"+p`: Paste from system clipboard

The `"*` register might achieve the same thing? 

##### WSL

Visual mode:
`:w !clip.exe`: Copy to system clipboard

Normal mode:
`:w !clip.exe`: Copy file to system clipboard

#### Jumping around

Normal mode
`0`: Jump to the beginning of a line
`^`: Jump to the first non-blank character of a line
`$`: Jump to the end of a line

`gg`: Go to the first line of the file
`G`: Go to last line of the file
`42G`: Go to line 42 in the file
`-42G`: Go the the 42nd to last line in the file

`gd`: Go to definition of a variable, class, function, etc.
`gD`: Go to global definition

`^o`: Jump to previous cursor position in jump list
`^i`: Jump back to next cursor position in jump list

`f(`: Go to the next `(` character within the line
`F(`: Go to the previous occurence of character `(` within the line
`t(`: Go to before the first '(' character within the line
`T(`: Go to before the previous occurence of character `(` within the line
When in find mode, use `;` to go to the next occurence and `,` to go to the previous occurence.

`%`: Go between next pair of opening/closing braces within the line

#### Multi-line insert
1. First, go to the first line you want to comment, press `^V`. This will put the editor in the `VISUAL BLOCK` mode.
2. Then using the arrow key and select until the last line
3. Now press `I`, which will put the editor in `INSERT` mode and then type the character(s) to insert, e.g. `#` for a comment in Python.
4. You may need to press ESC twice

#### Macros:

1. Go to desired cursor position
2. `qq` to start recording a macro into register `q`
3. Perform a series of actions in NORMAL, INSERT, etc. modes
4. `q` to stop recording the macro

- Use `@q` to play back the macro once. Afterwards, `@@` will repeat the macro.
- `20@@` would repeat the last macro played 20 times

A multi-line insert that would act at the end of a block of lines of varying lengths is possible using a macro:
```vim
qq
$
i
<INSERT CHARACTERS>
<ESC>
j
q

@q
20@@
```

#### Change case

Visual mode
`U`: To uppercase
`u`: To lowercase
`~`: Toggle to opposite casing
