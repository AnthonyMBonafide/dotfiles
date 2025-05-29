# dotfiles

Personal collection of dotfiles that contain configurations for commonly used 
tools and system configurations

## Overview

This repo is organized using [GNU Stow](https://www.gnu.org/software/stow) which helps in setting up dotfiles in a way that can also be tracked with version control.

The contents of this directory are for setting up common system configurations as well as common tools. For example:

- ZSH
- Neo Vim
- Git
- Alacritty
- Zellij
- etc

## Set up

Clone this repository to the `HOME` (`~`) directory.

```shell
$ cd ~
$ git clone git@github.com:AnthonyMBonafide/dotfiles.git
```

Once cloned run `stow` to place the files in the correct directory:

```shell
$ stow .
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

### Scripts

Use the scripts to bootstrap a system, pick the one that matches your system.
These scripts are meant to install a package manager, necessary packages, run 
`stow`


### Mac Additional Setup

- Set `Caps lock` to `Control`
- Go into security settings and allow Alacrity to be run since it is not signed from Brew repo


#### Work In Progress

Eventually this will be able to bootstrap a system with one command from a
fresh install with no need for pre-installed packages like `git`. Ideally one
could run something like:
```shell
curl -s https://raw.githubusercontent.com/AnthonyMBonafide/dotfiles/main/bootstrap.sh | bash
```

#### TODO

[ ] Remove hardcoded directories, especially ones with username (i.e. zellij config location for plugins)
[ ] Error on Alacrity startup due to gnupg files not being created(dirty fix - run gnupg)
[ ] Create empty .workaliases file to get rid of errors upon startup
[ ] Trigger loading NVIM plugins so first time opening does not have errors/see loading
[ ] Create script for creating ssh key which can be used for easier Github setup

