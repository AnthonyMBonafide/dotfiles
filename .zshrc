alias n='nvim'

source $HOME/.dockeraliases
source $HOME/.workaliases
source $HOME/.gitaliases

source $HOME/.historyconfig

export PATH=$PATH:/opt/bin:$HOME/go/bin:/opt/homebrew/bin:/bin:/usr/bin:$HOME/.cargo/bin:$HOME/.config/tmux/plugins/tmuxifier/bin
# Path to your oh-my-zsh installation.
export VISUAL=nvim
export EDITOR="$VISUAL"
export GOBIN="$HOME/go/bin"
export GPG_TTY=$(tty)
gpgconf --launch gpg-agent

source $HOME/.clitools
