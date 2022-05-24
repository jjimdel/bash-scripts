#!/usr/bin/env bash

# 
# Title
#   js-repo-check.sh
#
# Description
#   Check every Git repository from a list
#
# Version
#   0.2
#
# Contributor
#   Julio Jimenez Delgado (jouleSoft)
#
# GitHub
#   https://github.com/jouleSoft/bash-scripts.git
#
# License
#   The MIT License (MIT)
#   Copyright (c) 2021-2022 Julio Jiménez Delgado (jouleSoft)
#
# Template
#   https://github.com/jouleSoft/bash-scripts/templates/noargs.sh 
#
# Dependencies 
#   git
#
# Configuration files needed
#   ~/.config/js-repo-check.conf
#

# -------------------------------------------------------------------
#   BASH REQUIREMENTS
# -------------------------------------------------------------------
#
# -e             Scripts stops on error (return != 0)
# -u             Error if undefined variable
# -x             Output every line (debug mode)
# -o pipefail    Script fails if one of the piped commands fails
# -o posix       Causes Bash to match the standard when the
#                default operation differs from the Posix standard

set -eu -o pipefail -o posix

# -------------------------------------------------------------------
#   MODULE IMPORTS
# -------------------------------------------------------------------

# Modules path
declare MOD_DIR
MOD_DIR="$(dirname "$0")/modules"

# shellcheck source=./modules/common.sh
source "$MOD_DIR"/common.sh

# shellcheck source=./modules/git.sh
source "$MOD_DIR"/git.sh

# -------------------------------------------------------------------
#   DECLARATIONS AND DEFINITIONS
# -------------------------------------------------------------------

#Script info and arguments evaluation variables
declare script_name="js-check-repo.sh"
declare version="0.2"
declare description="Check every Git repository from a list"

#Dependencies array: used for checking the dependencies.
#Declared in 'common.sh' module.
deps_array=(
  "git"
)

#Global operational variables
# NONE

# -------------------------------------------------------------------
#   FUNCTIONS
# -------------------------------------------------------------------

# ===  FUNCTION  ====================================================
#         NAME: Main
#  DESCRIPTION: Main function
#         TYPE: Main
# ===================================================================

main()
{
  # Configuration file
  config_file_check "$HOME/.config/js-repo-check.conf"

  # shellcheck source=$HOME/.config/js-check-repo.conf
  source "$HOME/.config/js-repo-check.conf"

  declare currentDir
  currentDir="$(pwd)"

  echo -e "${CYAN} Status of every repository:${NC}\n"

  for r in "${repo_dir_array[@]}"; do
    cd "$r" 2> /dev/null || continue

    if ! git fetch -q > /dev/null 2>&1; then
      echo -e "  [   --   ] $r"
      continue
    fi
 
    if [ "$(git status --short | wc -c)" != 0 ]; then
      echo -e "${YELLOW}  [   CK   ]${NC} $r"
    else
      echo -e "${LIGHT_GREEN}  [   OK   ]${NC} $r"
    fi
  done

  echo

  echo -e "${CYAN} Legend:${NC}\n"
  echo -e "  ${LIGHT_GREEN}[   OK   ]${NC}: The repo is up to date"
  echo -e "  ${YELLOW}[   CK   ]${NC}: The repo needs to be checked"
  echo -e "  [   CK   ]: It is not a repo\n"
}

# -------------------------------------------------------------------
#   EXECUTION
# -------------------------------------------------------------------

#Printing the header
header "$script_name" "$version" "$description"

#Dependecy evaluation
deps_check "${deps_array[@]}"

#Main function execution
main

# -------------------------------------------------------------------
#   FINALIZATION
# -------------------------------------------------------------------

#Unset common.sh module variables
common_unset

#Operational variables (if any)
#

