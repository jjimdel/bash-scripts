#!/usr/bin/env bash

dotFilesCopy()
{
  declare output
  declare -a dotFiles_array="$1"

  for c in "${dotFiles_array[@]}"; do

    if [ ! -e "$repo/$c" ]; then
      #if there is no files yet in the repo, create the first copy of them.
      cp -rf "$HOME/$c" "$repo/$c" && output="${YELLOW}[   CP   ]${NC} $c"

    elif [ ! -e "$HOME/$c" ]; then
      #if there is no files in the homedir, copy is not needed.
      output="${NC}[   NN   ] $c"

    elif diff -q "$HOME/$c" "$repo/$c" > /dev/null; then
      #if there is no differences between the dotFile from source and the repo,
      #the file or directory won't be copied
      output="${LIGHT_GREEN}[   OK   ]${NC} $c"

    else
      cp -rf "$HOME/$c" "$repo/$c" && output="${YELLOW}[   CP   ]${NC} $c"
    fi

    echo -e "  $output"

  done
}

dotFilesCopy_legend()
{
  echo -e "Legend:\n"
  echo -e "  ${LIGHT_GREEN}[   OK   ]${NC}: The files are in its last version"
  echo -e "  ${YELLOW}[   CP   ]${NC}: The files has been copied"
  echo -e "  ${NC}[   NN   ]: Not Needed. The dotfile is not currently in the system"
}
