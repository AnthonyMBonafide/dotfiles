#!/usr/bin/env bash
git fetch
git worktree add -b AnthonyMBonafide/$1 $1 origin/main --track

FILE=./.vscode/launch.json

if [ -f "$FILE" ]; then
  mkdir ./$1/.vscode
  cp $FILE ./$1/.vscode/launch.json
else
  echo "No .vscode file in root worktree, skipping copy"
fi
