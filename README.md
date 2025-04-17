# dotfiles

Personal collection of dotfiles that contain configurations for commonly used 
tools and system configurations

## Overview

This repo is organized using [GNU Stow](https://www.gnu.org/software/stow) which helps in setting up dotfiles in a way that can also be tracked with version control.

The contents of this directory are for setting up common system configurations as well as common tools. For exmaple:

- ZSH
- Neo Vim
- Git

## Set up

Clone this repoisitory to the `HOME` (`~`) directory.

```shell
$ cd ~
$ git clone git@github.com:AnthonyMBonafide/dotfiles.git
```

Once cloned run `stow` to place the files in the correct directory:

```shell
$ stow .
```


This will place all the files in this directory in the correct spot.
