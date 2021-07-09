#!/usr/bin/env bash
# ---
# Title:        js-dotfiles-bkp.sh
# Description:  Create dotfiles backup
# Contributors: Julio Jimenez Delgado
#
# GitHub repo:	https://github.com/jouleSoft/js-DevOps
#
# License:      The MIT License (MIT)
#               Copyright (c) 2021 Julio Jiménez Delgado (jouleSoft)
#
# Template:     template_noargs.sh <https://github.com/jouleSoft/js-DevOps/templates/>
#
# Dependencies: git
# 
# Version:      0.1
# By:           Julio Jimenez Delgado
# Date:         30/05/2021
# Change:       Initial development
#
# Version:      0.2
# By:           Julio Jimenez Delgado
# Date:         30/05/2021
# Change:       Check GIT status of all dotfile repos
#
# Version:      0.3
# By:           Julio Jimenez Delgado
# Date:         01/06/2021
# Change:       Redirect diff output to /dev/null
#
# Version:      0.4
# By:           Julio Jimenez Delgado
# Date:         12/06/2021
# Change:       Conky dotfile added
#
# Version:      0.5
# By:           Julio Jimenez Delgado
# Date:         09/07/2021
# Change:       Now 'dotfiles' repo will be the only repo for all the files
#
#

#----------------------------------[Declarations and definitions]----------------------------------

#Script info and arguments evaluation variables
declare script_name="js-dotfiles-bkp.sh"
declare version="v.0.5"
declare description="Create dotfiles backup"

#Global operational variables
#dotfiles from '~/' directory
declare -a dotFiles=(
".bashrc"
".vim/vimrc"
)

#dotfiles from '~/.config' directory
declare -a dotConfig=(
"alacritty"
"conky"
"dunst"
"fish"
"i3status-rust"
"i3"
"kitty"
"picom.conf"
"polybar"
"qtile"
"ranger"
)

#-------------------------------------------[Functions]--------------------------------------------

#Script header
header() 
{
  #Init color variables
  declare NC='\033[0m'
  declare LIGHT_GREY='\033[0;37m'
  declare YELLOW='\033[1;33m'

  echo 
  echo -e "${LIGHT_GREY} $script_name ${YELLOW}$version ${LIGHT_GREY}- $description${NC}\n"
  echo 
}

#Operational functions (if required)
gitCheck()
{
  declare gitRepo

  declare currentDir
  declare NC
  declare LIGHT_GREEN

  NC='\033[0m'
  LIGHT_GREEN='\033[1;32m'

  gitRepo="$HOME/github/dotfiles"

  currentDir="$(pwd)"

  if cd "$gitRepo"; then
    echo -e "${LIGHT_GREEN}GIT status of [$(pwd)]${NC}"
    echo "---"
    git status --short
    echo "---"
  else
    echo "$gitRepo doesn't exist"
  fi

  cd "$currentDir" || echo "$currentDir doesn't exsit"
}

#Main function
main()
{
  #Color variables
  declare NC='\033[0m'
  declare LIGHT_GREEN='\033[1;32m'
  declare YELLOW='\033[1;33m'

  #Repo path
  declare repo="$HOME/github/dotfiles"

  echo "Backup to: [$HOME/github/dotfiles]"
  echo "-------------------------------------------"
  #Only dotfiles from '~/' directory
  for d in "${dotFiles[@]}"; do
    #Copy .bashrc
    if [ "$HOME/$d" == "$HOME/.bashrc" ]; then
      #if there is no differences between the dotFile source and the repo,
      #the file or directory won't be copied
      if diff -q "$HOME/$d" "$repo/bashrc" > /dev/null; then
        echo -e "${LIGHT_GREEN}[   OK   ]${NC} $d"
      else
        cp -f "$HOME/$d" "$repo/bashrc" && echo -e "${YELLOW}[ copied ]${NC} $d"
      fi

    elif [ "$HOME/$d" == "$HOME/.vim" ]; then
      if diff -q "$HOME/$d/vimrc" "$repo/.vim/vimrc" > /dev/null; then
        echo -e "${LIGHT_GREEN}[   OK   ]${NC} $d"
      else
        cp -f "$HOME/$d/vimrc" "$repo/.vim/vimrc" && echo -e "${YELLOW}[ copied ]${NC} $d"
      fi
    fi
  done

  #Dotfiles from '~/.config' directory
  for c in "${dotConfig[@]}"; do
    #if there is no differences between the dotConfig source and the repo,
    #the file or directory won't be copied
    if diff -q "$HOME/.config/$c" "$repo/.config/$c" > /dev/null; then
      echo -e "${LIGHT_GREEN}[   OK   ]${NC} .config/$c"
    else
      cp -rf "$HOME/.config/$c" "$repo/.config/" && echo -e "${YELLOW}[ copied ]${NC} .config/$c"
    fi
  done

  echo "-------------------------------------------"
  echo

  gitCheck

  echo
}

#-------------------------------------------[Execution]--------------------------------------------


#Printing the header
header

#Main function execution
main


#------------------------------------------[Finalization]------------------------------------------

#Script header
unset script_name
unset version
unset description

#Operational variables (if any)
unset dotFiles
unset dotConfig
