# autojump (https://github.com/wting/autojump)
[[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh

# npm path
export PATH=~/.npm-global/bin:$PATH;

# asdf (https://asdf-vm.com/guide/getting-started.html)
. $HOME/.asdf/asdf.sh

# nvm (https://github.com/neovim/neovim/wiki/Installing-Neovim)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# starship
# https://starship.rs/guide/#%F0%9F%9A%80-installation
# https://starship.rs/presets/#pure-prompt
eval "$(starship init zsh)"

# fzf
eval "$(fzf --zsh)"

# fuck
eval "$(thefuck --alias)"
