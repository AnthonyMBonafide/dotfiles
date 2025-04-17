#!/usr/bin/env bash

# Inspired by https://github.com/mathiasbynens/dotfiles

# Update Pacman
pacman -Syu --no-confirm

# Install Hyprland DO NOT RESTART AT END
# bash <(curl -s https://raw.githubusercontent.com/mylinuxforwork/hyprland-starter/main/setup.sh)

# Install packages
pacman -S git alacritty zellij starship ripgrep fzf go zig lazygit neovim zoxide stow luarocks fd bat eza --no-confirm

# Pull from Github TODO make public
git clone https://github.com/AnthonyMBonafide/dotfiles.git ~

# Install dotfiles in the proper place
pushd ~/dotfiles/
stow .
popd
