#!/usr/bin/env bash

git worktree remove $1
git branch -D AnthonyMBonafide/$1
