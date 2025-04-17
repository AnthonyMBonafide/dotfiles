#!/usr/bin/env bash

# Inspired by https://github.com/mathiasbynens/dotfiles/blob/b7c7894e7bb2de5d60bfb9a2f5e46d01a61300ea/brew.sh

# Install command-line tools using Homebrew.
if ! command -v brew 2>&1 >/dev/null; then
  echo "Brew now installed, installing now via homebrews install.sh"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade

# Save Homebrew’s installed location.
BREW_PREFIX=$(brew --prefix)

# Install GNU core utilities (those that come with macOS are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
ln -s "${BREW_PREFIX}/bin/gsha256sum" "${BREW_PREFIX}/bin/sha256sum"

NEW_PACKAGES=$(comm -23 <(sort brew-list.txt) <(brew leaves | sort))
for new_package in $NEW_PACKAGES; do
  echo "Installing $new_package due to being in the brew-list"
  brew install $new_package
done

NEW_CASKS=$(comm -23 <(sort brew-casks-list.txt) <(brew list --cask | sort))
for new_cask in $NEW_CASKS; do
  echo "Installing $new_cask due to being in the brew-cask-list"
  brew install --cask $new_cask
done

# TODO need to fix this so that transitive dependecies are not removed
# Last time this was run it not only removed extra packages(not really an issue)
# it removed all packages including the ones that are listed. This would
# be nice to have a more Nix like setup where what is listed in the package
# files were the only things installed to ensure consistency and can be used
# day-to-day to install packages and stay up-to-date

# OLD_PACKAGES=$(comm -13 <(sort brew-list.txt) <(brew leaves | sort))
# for old_package in $OLD_PACKAGES; do
#   echo "Removing $old_package due to not being in the brew-list"
#   brew uninstall $old_package
# done

# OLD_CASKS=$(comm -13 <(sort brew-casks-list.txt) <(brew list --cask | sort))
# for old_cask in $OLD_CASKS; do
#   echo "Removing $old_cask due to not being in the brew-cask-list"
#   brew uninstall --cask $old_cask
# done

# # Remove outdated versions from the cellar.
brew cleanup

# Set the time notifications stay on the screen to 2 seconds
defaults write com.apple.notificationcenterui bannerTime -int 2
