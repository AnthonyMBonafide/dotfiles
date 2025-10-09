if status is-interactive
    # Commands to run in interactive sessions can go here
end

fish_add_path /opt/homebrew/opt/llvm/bin
fish_add_path /opt/homebrew/bin/
fish_add_path $HOME/go/bin

set fish_greeting
source $HOME/.config/fish/.dockeraliases.fish
source $HOME/.config/fish/.gitaliases.fish
source $HOME/.config/fish/.brewaliases.fish

# This file is not checked into a VCS and is not guaranteed to be created 
if test -f $HOME/.config/fish/.workaliases.fish
    source $HOME/.config/fish/.workaliases.fish
end

set -gx VISUAL nvim
set -gx EDITOR "$VISUAL"
set -gx GOBIN "$HOME/go/bin"
set -gx LDFLAGS -L/opt/homebrew/opt/llvm/lib
set -gx CPPFLAGS -I/opt/homebrew/opt/llvm/include

# Do this last since it might require other configurations
source $HOME/.config/fish/.clitools.fish
