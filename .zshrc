autoload -Uz compinit
compinit

# Allow to edit command in editor
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line # Binds Ctrl+X Ctrl+E to open editor

# Allow Vim mode 
bindkey -v

alias n='nvim'

source $HOME/.dockeraliases
source $HOME/.workaliases
source $HOME/.gitaliases
source $HOME/.brewaliases

source $HOME/.historyconfig

export PATH=$PATH:/opt/bin:$HOME/go/bin:/opt/homebrew/bin:/bin:/usr/bin:$HOME/.cargo/bin:$HOME/.config/tmux/plugins/tmuxifier/bin:$HOME/scripts/
# Path to your oh-my-zsh installation.
export VISUAL=nvim
export EDITOR="$VISUAL"
export GOBIN="$HOME/go/bin"
export GPG_TTY=$(tty)
gpgconf --launch gpg-agent

# Git completions
fpath=(~/.zsh $fpath)
zstyle ':completion:*:*:git:*' script ~/.zsh/git-completion.bash
autoload -Uz compinit && compinit

source $HOME/.zsh/jj.completion.zsh
source $HOME/.clitools
