# dotfiles

A collection of all of my zsh configs.
To source them, add the following to your .zshrc file.

```
# Source config files
export DOTFILE_PATH="PATH_TO_YOUR_DOTFILES"

for file in "$DOTFILE_PATH"/*.zsh; do
  source "$file"
do
```

### [NVIM](https://github.com/neovim/neovim/wiki/Installing-Neovim)

Customized nvchad configs. Once installed, create a symlink with:
`ln -s {path to dotfiles/nvim} ~/.config/nvim`

### [KITTY](https://sw.kovidgoyal.net/kitty/binary/#binary-install)

Terminal emulator configs + startup session script and theme. Create a symlink with:
`ln -s {path to dotfiles/kitty} ~/.config/kitty`

### [STARSHIP](https://starship.rs/guide/#%F0%9F%9A%80-installation)

1. Install starship
   `brew install starship`

2. Link to .config
   `ln -s {path to dotfiles/starship.toml} ~/.config/starship.toml`

### OTHER

Here's a list of other handy tools and their installation instructions

1. [homebrew](https://brew.sh/)
2. [autojump](https://github.com/wting/autojump)
3. [asdf](https://asdf-vm.com/guide/getting-started.html)
