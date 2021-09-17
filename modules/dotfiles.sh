#!/usr/bin/env bash

dotFilesCopy()
{
  # --
  # contributor:  Julio Jiménez Delgado (jouleSoft)
  # version:      0.2
  # updated:      17-09-2021
  #
  # dependencies: coreutils
  # --

  declare output

  if [ ! -e "$repo/$1" ]; then
    #if there is no files yet in the repo, create the first copy of them.
    cp -rf "$HOME/$1" "$repo/$1" && output="${YELLOW}[   CP   ]${NC} $1"

  elif [ ! -e "$HOME/$1" ]; then
    #if there is no files in the homedir, copy is not needed.
    output="${NC}[   NN   ] $1"

  elif diff -q "$HOME/$1" "$repo/$1" > /dev/null; then
    #if there is no differences between the dotFile from source and the repo,
    #the file or directory won't be copied
    output="${LIGHT_GREEN}[   OK   ]${NC} $1"

  else
    cp -rf "$HOME/$1" "$repo/$1" && output="${YELLOW}[   CP   ]${NC} $1"
  fi

  echo -e "  $output"
}

dotFilesCopy_legend()
{
  echo -e "Legend:\n"
  echo -e "  ${LIGHT_GREEN}[   OK   ]${NC}: The files are in its last version"
  echo -e "  ${YELLOW}[   CP   ]${NC}: The files has been copied"
  echo -e "  ${NC}[   NN   ]: Not Needed. The dotfile is not currently in the system"
}
