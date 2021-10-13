#!/usr/bin/env bash

# 
# Title
#   js-repo-check.sh
#
# Description
#   Check every Git repository from a list
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
#
# Configuration files needed
#   ~/.config/js-check-repo.conf.sh
#

#### [MODULES] ####

. $HOME/workspace/bash-scripts/modules/common.sh

#Configuration module
. $HOME/.config/js-check-repo.conf.sh

#### [DECLARATIONS AND DEFINITIONS] ####

#Script info and arguments evaluation variables
declare script_name="js-check-repo.sh"
declare version="0.1"
declare description="Check every Git repository from a list"

#Dependencies array: used for checking the dependencies.
#Declared in 'common.sh' module.
deps_array=(
  "git"
)

#Global operational variables
# NONE

#### [FUNCTIONS] ####

#Operational functions (if required)
# NONE

#Main function
main()
{
  declare currentDir="$(pwd)"

  echo -e "${CYAN} Status of every repository:${NC}\n"

  for r in ${repo_dir_array[@]}; do
    cd "$r"
 
    if [ $(git status --short | wc -c) != 0 ]; then
      echo -e "${YELLOW}  [   CK   ]${NC} $r"
    else
      echo -e "${LIGHT_GREEN}  [   OK   ]${NC} $r"
    fi
  done

  echo

  echo -e "${CYAN} Legend:${NC}\n"
  echo -e "  ${LIGHT_GREEN}[   OK   ]${NC}: The repo is up to date"
  echo -e "  ${YELLOW}[   CP   ]${NC}: The repo needs a check"
}

#### [EXECUTION] ####

#Printing the header
header "$script_name" "$version" "$description"

#Check if config file exists (when needed)
config_file_check "$HOME/.config/js-check-repo.conf.sh"

#Dependecy evaluation
deps_check ${deps_array[@]}

#Main function execution
main

#### [FINALIZATION] ####

#Unset common.sh module variables
common_unset

#Operational variables (if any)
#

