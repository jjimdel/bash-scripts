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
source "$MOD_DIR"/common.sh

# shellcheck source=./modules/common.sh
#source "$MOD_DIR"/git.sh

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

  # shellcheck source=$HOME/.config/js-sync-dotfiles.conf.sh
  source "$HOME/.config/js-sync-dotfiles.conf"

  #Printing the header
  header "$script_name" "$version" "$description"

  check_arguments "$@"

}

# ===  FUNCTION  ====================================================
#         NAME: sync_data
#  DESCRIPTION: Sync data using rsync
#         TYPE: operational
# ===================================================================

sync_data()
{
  #
  # contributor:  Julio Jiménez Delgado (jouleSoft)
  # version:      0.1
  # created:      20-05-2022
  #
  # dependencies: rsync
  #
  # arguments:
  #    - '$1':    <source_directory>
  #    - '$2':    <dest_directory>
  #

  # dotFilles array from js-sync-dotfiles.conf
  for s in ${dotFiles[@]}; do
    if [ -e "$HOME/$s" ]; then
      echo "$s" >> /tmp/js-sync-dotfiles.include.tmp
    else
      echo "Not found: $s"
    fi
  done

  for s in ${exclude[@]}; do
      echo "$s" >> /tmp/js-sync-dotfiles.exclude.tmp
  done


  # Sync the dotfiles directories recursively to the repo
  rsync \
    --verbose \
    --info=stats1 \
    --archive \
    --update \
    --recursive \
    --backup \
    --backup-dir="$2/backup" \
    --files-from=/tmp/js-sync-dotfiles.include.tmp \
    --exclude-from=/tmp/js-sync-dotfiles.exclude.tmp \
    "$1" \
    "$2/"
}


# ===  FUNCTION  ====================================================
#         NAME: print_help
#  DESCRIPTION: Print usage text
#         TYPE: help
# ===================================================================

print_help()
{
  echo "  Usage:
    $script_name -h

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
  declare help=""
  declare sync=""

  if [ "$#" -eq 0 ]; then
    sync="true"
  fi

  while getopts :h options; do
    case "$options" in
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

  if [ -n "$sync" ]; then
    [ -f /tmp/js-sync-dotfiles.include.tmp ] && rm -f /tmp/js-sync-dotfiles.include.tmp
    [ -f /tmp/js-sync-dotfiles.exclude.tmp ] && rm -f /tmp/js-sync-dotfiles.exclude.tmp

    sync_data $HOME/ $destination

    exit 0
  fi

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
