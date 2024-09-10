# git
alias gc='conventional_commit'
alias gs='git status -sb'
alias ga='git add'
alias gps='git push'
alias gpl='git pull'
alias gr='git restore'
alias gco='git checkout'

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

# pomo
alias pomo=$HOME/.pomo/bin/pomo

# kitty ssh
alias ssh="kitten ssh"

# lsd
alias ls="lsd"
