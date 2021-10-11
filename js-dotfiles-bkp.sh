#!/usr/bin/env bash

# 
# Title
#   js-dotfiles-bkp.sh
#
# Description
#   Create dotfiles backup
#
# Contributor
#   Julio Jimenez Delgado (jouleSoft)
#
# GitHub
#   https://github.com/jouleSoft/bash-scripts.git
#
# License
#   The MIT License (MIT)
#   Copyright (c) 2021 Julio Jiménez Delgado (jouleSoft)
#
# Template
#   https://github.com/jouleSoft/bash-scripts/templates/noargs.sh 
#
# Dependencies 
#   git
#   coreutils
#   ~/.config/js-dotfiles-bkp.conf.sh
#

#### [MODULES] ####

. /home/jjimenez/workspace/bash-scripts/modules/common.sh
. /home/jjimenez/workspace/bash-scripts/modules/git.sh

# Preferences module to import the arrays
. /home/jjimenez/.config/js-dotfiles-bkp.conf.sh

#### [DECLARATIONS AND DEFINITIONS] ####

#Script info and arguments evaluation variables
declare script_name="js-dotfiles-bkp.sh"
declare version="v.1.1"
declare description="Create dotfiles backup at GitHub"

#Dependencies array: used for checking the dependencies
declare -a deps_array=(
  "git"
  "dirname"
)

#Global operational variables
# NONE

#### [FUNCTIONS] ####

#Operational functions (if required)
# NONE

#Main function
main()
{
  #Repo path
  declare repo
  repo="$HOME/workspace/dotfiles"

  echo -e "${CYAN} Backup to: [$HOME/workspace/dotfiles]${NC}\n"
  for d in ${dotFiles[@]}; do
    dotFilesCopy $d
  done

  for d in ${dotConfig[@]}; do
    dotFilesCopy $d
  done

  for d in ${dotDoom[@]}; do
    dotFilesCopy $d
  done

  for d in ${dotLocal[@]}; do
    dotFilesCopy $d
  done

  echo -e "\n"

  dotFilesCopy_legend
  echo

  gitCheck_and_commit "$repo"

  echo
}

#### [EXECUTION] ####

#Printing the header
header "$script_name" "$version" "$description"


#Dependecy evaluation
deps_check ${deps_array[@]}

if [ -e ~/.config/js-dotfiles-bkp.conf.sh ]; then
  if [[ ${#deps_check_array[@]} -eq 0 ]]; then
    #Main function execution
    main
  else
    echo -e " Dependencies listed below are needed:"
    for e in "${deps_check_array[@]}"; do
      echo -e "   $e"
    done

    echo; exit 2
  fi
else
  echo -e " configuration file not found\n"
  exit 1
fi

#### [FINALIZATION] ####

#Script header
unset script_name
unset version
unset description

#Operational variables (if any)
# NONE
