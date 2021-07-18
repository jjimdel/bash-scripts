#!/usr/bin/env bash

pwd_dir=$(pwd)
github_dir=$(ls -1 ~/github)

for d in $github_dir
do
  if [ -f "$HOME/github/$d" ]; then
    continue
  fi

  cd "$HOME/github/$d" || continue

  if [ ! "$(git status -s)" == "" ]; then
    echo "[ $HOME/github/$d ]"
    echo "--------------------"
    git status -s
    echo "--------------------"
    echo
  fi
done

cd "$pwd_dir" || exit 1
