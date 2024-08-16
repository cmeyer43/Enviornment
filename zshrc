export OPENSSL_ROOT_DIR=/opt/homebrew/opt/openssl@3

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
#__conda_setup="$('/Users/coreymeyer/opt/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
#if [ $? -eq 0 ]; then
#    eval "$__conda_setup"
#else
#    if [ -f "/Users/coreymeyer/opt/miniconda3/etc/profile.d/conda.sh" ]; then
#        . "/Users/coreymeyer/opt/miniconda3/etc/profile.d/conda.sh"
#    else
#        export PATH="/Users/coreymeyer/opt/miniconda3/bin:$PATH"
#    fi
#fi
#unset __conda_setup
# <<< conda initialize <<<


test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# The following lines were added by compinstall

zstyle ':completion:*' completer _complete _ignored
zstyle :compinstall filename '/Users/coreymeyer/.zshrc'

autoload -Uz compinit
compinit

alias pace="ssh cmeyer43@coc-ice.pace.gatech.edu"
alias ECE4130="ssh -Y cmeyer43@ece-linlabsrv01.ece.gatech.edu"

alias ls='ls --color=auto'
alias ll="ls -lFh"
alias la="ls -a"
alias l="ls -CF"
alias reset="reset && printf '\e[3J'"
alias grep='grep --color=auto'

export PATH=$PATH:/usr/local/go/bin

# End of lines added by compinstall

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/coreymeyer/Downloads/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/coreymeyer/Downloads/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/coreymeyer/Downloads/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/coreymeyer/Downloads/google-cloud-sdk/completion.zsh.inc'; fi

setopt PROMPT_SUBST
PROMPT='%B%F{green}%n%F{white}@%F{red}$(sw_vers -productName)-$(sw_vers -productVersion)%f%F{white}:%f%F{blue}%~%f\$%b '

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'
set -o monitor

# some more ls aliases
alias ll='ls -lFh'
alias la='ls -Al'
alias l='ls -CF'
alias reset="reset && printf '\e[3J'"
alias bdf="df -k"
alias gk="gitk --all"
alias gs="git status"
alias gcm="git commit -m"
alias gch="git checkout"
alias gl="git log"

export PATH=~/.local/bin:$PATH

alias fp='fprime-util'
alias fpp='yes | fprime-util purge'
alias fpg='fprime-util generate'
alias fpb='fprime-util build'
alias fpr='yes | fprime-util purge && fprime-util generate && fprime-util build'
 
# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

export fgm1="fgm1-user@143.215.191.21"

export PATH=~/.local/bin:$PATH

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

