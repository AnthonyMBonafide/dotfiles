if status is-interactive
    # Commands to run in interactive sessions can go here
end

fish_add_path /opt/homebrew/bin/
set fish_greeting
source $HOME/.config/fish/.dockeraliases.fish
source $HOME/.config/fish/.workaliases.fish
source $HOME/.config/fish/.gitaliases.fish
source $HOME/.config/fish/.brewaliases.fish

set -gx VISUAL nvim
set -gx EDITOR "$VISUAL"
set -gx GOBIN "$HOME/go/bin"

source $HOME/.config/fish/.clitools.fish
