#!/usr/bin/env bash

#
# Title
#   js-sync-dotfiles.sh
#
# Description
#   Sync dotfiles against git repository
#
# Version
#   1.0
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
#   -h          Display help message
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
. "$MOD_DIR"/common.sh

# shellcheck source=./modules/common.sh
. "$MOD_DIR"/git.sh

# -------------------------------------------------------------------
#   DECLARATIONS AND DEFINITIONS
# -------------------------------------------------------------------

# Script info
script_name="js-sync-dotfiles.sh"
version="1.0"
description="Sync dotfiles against git repository"

# Dependencies array: used for checking the dependencies.
# Declared in 'common.sh' module.
deps_array=(
  "rsync"
)

# Logging:
log_dir="$(dirname $0)/log"

# Global operational variables
declare source=""
declare destination=""

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

  check_arguments "$@"

  sync_data $source $destination
}

# ===  FUNCTION  ====================================================
#         NAME: <function_name>
#  DESCRIPTION: <short_description>
#         TYPE: <operational | help | other>
# ===================================================================

#function_name()
#{
#  Write code here!!
#}


# ===  FUNCTION  ====================================================
#         NAME: print_help
#  DESCRIPTION: Print usage text
#         TYPE: help
# ===================================================================

print_help()
{
  echo "  Usage:
    $0 -h

  Options:

    -h          Display this message"

  echo
}

# ===  FUNCTION  ====================================================
#         NAME: check_arguments
#  DESCRIPTION: Handle command line arguments
#         TYPE: Operational
# ===================================================================

check_arguments()
{
  if [ "$#" -eq 0 ]; then
    echo -e "  Arguments expected\n"

    print_help

    exit 3
  fi

  declare help=""

  while getopts :hs:d: options; do
    case "$options" in
      d) destination="$OPTARG";;
      s) source="$OPTARG";;

      h) help="true";;

      :) echo -e "  -$OPTARG needs a value\n"

         print_help

         exit 2
         ;;
      ?) echo -e "  -$OPTARG is not a valid parameter\n"

         print_help

         exit 2
         ;;
    esac
  done

  shift $(($OPTIND-1))

  if [ -n "$help" ]; then
    print_help
    exit 0
  fi
}

# -------------------------------------------------------------------
#   EXECUTION
# -------------------------------------------------------------------

#Printing the header
header "$script_name" "$version" "$description"

# Check if config file exists (when needed)
# file_check "<config_file>"

# Dependency evalutation
deps_check "${deps_array[@]}"

# Arguments number evaluation
# args_check "$@"

# Run script as root
# run_as_root

# Main function execution
main "$@"

# -------------------------------------------------------------------
#   FINALIZATION
# -------------------------------------------------------------------

# Unset common.sh module variables
common_unset

# Operational variables (if any)
# NONE
