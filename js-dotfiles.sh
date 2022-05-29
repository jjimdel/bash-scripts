#!/usr/bin/env bash

# Title
#   js-dotfiles.sh
#
# Description
#   Sync dotfiles against git repository
#
# Version
#   2.0
#
# Contributor
#   Julio Jimenez Delgado (jouleSoft)
#
# GitHub
#   https://github.com/jouleSoft/bash-scripts.git
#
# License
#   The MIT License (MIT)
#   Copyright (c) 2022 Julio Jimenez Delgado (jouleSoft)
#
# Template
#   https://github.com/jouleSoft/bash-scripts/templates/template-args.sh
#
# Dependencies
#   None
#
# Parameters
#
#   -d <dotfile>  Display diffs
#   -h            Display help message
#   -v            Verbose Sync
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

# shellcheck source=./modules/common.sh
source "$MOD_DIR"/git.sh

# -------------------------------------------------------------------
#   DECLARATIONS AND DEFINITIONS
# -------------------------------------------------------------------

# Script info
script_name="js-dotfiles.sh"
version="2.0"
description="Sync dotfiles against git repository"

# Dependencies array: used for checking the dependencies.
# Declared in 'common.sh' module.
deps_array=(
  "rsync"
)

# Logging:
#log_dir="$(dirname $0)/log"

# Global operational variables
# None

# -------------------------------------------------------------------
#   OPERATIONAL FUNCTIONS
# -------------------------------------------------------------------

# ===  FUNCTION  ====================================================
#         NAME: Main
#  DESCRIPTION: Main function
#         TYPE: Main
# ===================================================================

main()
{
  # ToDo: Create log dir

  # log_header "$log_dir"

  # shellcheck source=/dev/null
  source "$HOME/.config/js-sync-dotfiles.conf"

  #Printing the header
  header "$script_name" "$version" "$description"

  check_arguments "$@"
}


# -------------------------------------------------------------------
#   EXECUTION
# -------------------------------------------------------------------

# Check if config file exists (when needed)
config_file_check "$HOME/.config/js-sync-dotfiles.conf"

# Dependency evalutation
deps_check "${deps_array[@]}"

# Main function execution
main "$@"

# -------------------------------------------------------------------
#   FINALIZATION
# -------------------------------------------------------------------

# Unset common.sh module variables
common_unset

# Operational variables (if any)
# NONE
