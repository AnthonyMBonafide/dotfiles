# dotfiles

Personal collection of dotfiles that contain configurations for commonly used
tools and system configurations

## Overview

This repo is organized using [GNU Stow](https://www.gnu.org/software/stow)
which helps in setting up dotfiles in a way that can also be tracked with
version control.

The contents of this directory are for setting up common system configurations
as well as common tools. For example:

- Fish Shell
- Neo Vim
- Git
- JuJutsu(JJ)
- Ghostty
- Tmux
- etc

## Set up

Clone this repository to the `HOME` (`~`) directory.

```shell
cd ~
git clone git@github.com:AnthonyMBonafide/dotfiles.git
```

Once cloned run `stow` to place the files in the correct directory:

```shell
stow .
```

This will place all the files in this directory in the correct spot.

If there are errors stating that files already exist in a location you can
backup the existing files and re-execute the command, like:

```shell
mv ~/.zshrc ~/.zshrc.bak
stow .
```

or use the `--adopt` flag to use the existing files to overwrite the ones
in this repo.

### Additional Items

**Git**:

- Create or copy an existing SSH key to ~/.ssh/id_ed25519 and ~/.ssh/id_ed25519.pub
- Upload SSH keys to Github. Be sure to add the SSH public key for
  authentication and signing(currently this requires you to add two different
  keys, one for each purpose). Also, configure the key for SSO/SAML to get access
  to private organizations
- Create base locations under `~/projects` directory `~/projects/work/` and `~/projects/oss/`
  Authenticate Github CLI tool with `gh auth login`

**NeoVim**:

- Open to allow all plugins to download
- Run `healthcheck` and install any missing tools via home-brew

**Podman**:

- Create new VM for Podman with `podman machine init`.
- You may have to run `sudo
/opt/homebrew/Cellar/podman/5.5.0/bin/podman-mac-helper install` for MacOS
  followed by `podman machine stop` then `podman machine start`
- Open a terminal with Tmux running and have TPM install all plugins by running
  `Crtl + <Space> then I`

### Scripts

Use the scripts to bootstrap a system, pick the one that matches your system.
These scripts are meant to install a package manager, necessary packages, run
`stow`

### Mac Additional Setup

- Set `Caps lock` to `Control`
- Go into security settings and allow Alacrity/Ghostty to be run since it is
  not signed from Brew repo

#### Work In Progress

Eventually this will be able to bootstrap a system with one command from a
fresh install with no need for pre-installed packages like `git`. Ideally one
could run something like:

```shell
curl -s
https://raw.githubusercontent.com/AnthonyMBonafide/dotfiles/main/bootstrap.sh |
bash
```

#### TODO

[x] Remove hardcoded directories, especially ones with username (i.e. zellij
config location for plugins)
[ ] Error on Alacrity startup due to gnupg files not being created(dirty fix -
run gnupg)
[x] Create empty .workaliases file to get rid of errors upon startup
[ ] Trigger loading NVIM plugins so first time opening does not have errors/see loading
[ ] Create script for creating ssh key which can be used for easier Github setup
