# git
gc() { [[ $# -eq 0 ]] && git commit || git commit -m "$*"; }
alias gs='git status -sb'
alias ga='git add'
alias gps='git push'
alias gpl='git pull'
alias gr='git restore'
alias gco='git checkout'
alias gm='git checkout main'

# claude
alias c='claude --dangerously-skip-permissions'
alias mcp="vim ~/Library/'Application Support'/Claude/claude_desktop_config.json"

# nvim
alias vim='nvim'

# python
alias python='python3'

# system
alias mv="mv -i" # prompt for confirmation before overwrites
alias cp="cp -i" # prompt for confirmation before overwrites
alias myip="ifconfig en0 | grep inet | grep -v inet6 | cut -d ' ' -f2"
alias back='cd "$OLDPWD"'
alias home="cd ~"

# kitty
alias ssh="kitten ssh"
alias ktheme="$HOME/.config/dotfiles/kitty/theme-switcher.sh"
alias ktls="ktheme list"
alias ktd="ktheme dark && claude config set --global theme dark"
alias ktl="ktheme light && claude config set --global theme light"
alias ktr="ktheme auto"
alias ktcurrent="grep -m 1 'name:' $HOME/.config/dotfiles/kitty/current-theme.conf | sed 's/^## name: *//'"

# lsd
alias ls="lsd"
alias lss="lsd --blocks name,size" # display file size

# pnpm
alias p="pnpm"

# macOS timeout (not available by default)
function timeout() { perl -e 'alarm shift; exec @ARGV' "$@"; }

# copy file contents to clipboard
function copy() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: copy <filename>"
        return 1
    fi
    
    if [[ ! -f "$1" ]]; then
        echo "Error: File '$1' not found"
        return 1
    fi
    
    cat "$1" | pbcopy
    echo "Copied contents of '$1' to clipboard"
}

# enable autocompletion for copy function
if command -v compdef > /dev/null; then
    compdef '_files' copy
fi
