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
# Dependencies (packages)
#   git
#   coreutils
#
# Configuration files needed
#   ~/.config/js-dotfiles-bkp.conf.sh
#

#### [MODULES] ####
declare mod_dir
mod_dir=$(dirname "$0")

. "$mod_dir/modules/common.sh"
. "$mod_dir/modules/git.sh"

# Preferences module to import the arrays
. $HOME/.config/js-dotfiles-bkp.conf.sh

#### [DECLARATIONS AND DEFINITIONS] ####

#Script info and arguments evaluation variables
declare script_name="js-dotfiles-bkp.sh"
declare version="v.1.2"
declare description="Create dotfiles backup at GitHub"

#Dependencies array: used for checking the dependencies.
#Declared in 'common.sh' module.
deps_array=(
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
  for d in "${dotFiles[@]}"; do
    dotFilesCopy "$d"
  done

  for d in "${dotConfig[@]}"; do
    dotFilesCopy "$d"
  done

  for d in "${dotConfig_conky[@]}"; do
    dotFilesCopy "$d"
  done

  for d in "${dotConfig_i3wm[@]}"; do
    dotFilesCopy "$d"
  done

  for d in "${dotDoom[@]}"; do
    dotFilesCopy "$d"
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

#Check if config file exists (when needed)
config_file_check "$HOME/.config/js-dotfiles-bkp.conf.sh"

#Dependecy evaluation
deps_check "${deps_array[@]}"

#Main function execution
main

#### [FINALIZATION] ####

common_unset

#Operational variables (if any)
# NONE
