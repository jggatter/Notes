#vim #dotfiles 

## Configuring

Some machines are locked down and prevent installation of software like Neovim. My goal is to have a Neovim/Vim setup I can bring to whatever machine. Therefore I followed this guide:
[Article: How to have a Neovim configuration compatible with Vim](https://threkk.medium.com/how-to-have-a-neovim-configuration-compatible-with-vim-b5a46723145e)

Have Neovim or Vim installed

Ensure the default path for Neovim configuration is created:
`mkdir -p $HOME/config/nvim`
Sidenotes: 
* You can read up on runtime paths: `:help rtp`
* For Neovim, much of this info is based on the [XDG Base Directory Specification](https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html)

When using Vim instead of Neovim, create two [[Symbolic links]]:
```sh
ln -s $HOME/.config/nvim $HOME/.vim \
&& ln -s $HOME/.config/nvim/init.vim $HOME/.vimrc
```

File tree explained:
- `init.vim` is the entry point of the configuration. 
	- It loads plugins using `vim-plug`, which works for both Vim and Neovim. 
	- It also defines where plugins should be located and which plugins to load for Neovim vs. Vim.
- `common.vim` contains common configuration files like bindings, tabs, word wrappings, etc.
	- These are classical Vim configurations and are the same for both Vim and Neovim
	- Rule of thumb: anything valid for both and not a plugin goes here! If inconsistentices between platforms, prioritize Neovim
- `plugins.vim` is the complementary of `common.vim`.
	- Every configuration used in both versions goes here for instance
	- e.g. NERDTree, easymotion, lightline.vim
- `only_vim.vim` contains only Vim configurations.
	- Loaded after so will overwrite Neovim configurations
- `languages/` contains custom language configurations used by both versions.
	- One file per language and an additional file `other.vim` for "the kitchen sink"
- `lua/` is the required location for all Lua code to be used by Neovim
	- Contains configurations of Lua plugins.
	- Each is the configuration for a concrete plugin, additionally we have `other.lua` for everything else

Install plug.vim as package installer
```bash
curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

## Keys

### Basics
### Advanced

#### Jumping around

Normal mode
`42G`: Go to line 42 in the file
`gd`: Go to definition of a variable, class, function, etc.
`^o`: Jump to previous cursor position in jump list
`^i`: Jump back to next cursor position in jump list

`f(`: Go to first `(` character within the line
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
