#!/usr/bin/env bash

dotFilesCopy()
{
  #Dotfiles from '~/.doom.d' directory

  declare output

  for c in "${dotDoom[@]}"; do

    if [ ! -e "$repo/.doom.d/$c" ]; then
      #if there is no files yet in the repo, create the first copy of them.
      cp -rf "$HOME/.doom.d/$c" "$repo/.doom.d/$c" && output="${YELLOW}[   CP   ]${NC} .doom.d/$c"

    elif diff -q "$HOME/.doom.d/$c" "$repo/.doom.d/$c" > /dev/null; then
      #if there is no differences between the dotDoom source and the repo,
      #the file or directory won't be copied
      output="${LIGHT_GREEN}[   OK   ]${NC} .doom.d/$c"

    else
      cp -rf "$HOME/.doom.d/$c" "$repo/.doom.d/$c" && output="${YELLOW}[   CP   ]${NC} .doom.d/$c"
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
