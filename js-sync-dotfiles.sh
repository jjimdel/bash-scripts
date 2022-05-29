#!/usr/bin/env bash

#
# Title
#   js-sync-dotfiles.sh
#
# Description
#   Sync dotfiles against git repository
#
# Version
#   1.1
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
source "$MOD_DIR"/git.sh

# -------------------------------------------------------------------
#   DECLARATIONS AND DEFINITIONS
# -------------------------------------------------------------------

# Script info
script_name="js-sync-dotfiles.sh"
version="1.1"
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
  for s in "${dotFiles[@]}"; do
    if [ -e "$HOME/$s" ]; then
      echo "$s" >> /tmp/js-sync-dotfiles.include.tmp
    fi
  done

  for s in "${exclude[@]}"; do
      echo "$s" >> /tmp/js-sync-dotfiles.exclude.tmp
  done

  # Sync the dotfiles directories recursively to the repo
  rsync \
    --info=stats1,progress2 \
    --human-readable \
    --archive \
    --partial \
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
#         NAME: sync_data_verbose
#  DESCRIPTION: Sync data using rsync with detailed output
#         TYPE: operational
# ===================================================================

sync_data_verbose()
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
  for s in "${dotFiles[@]}"; do
    if [ -e "$HOME/$s" ]; then
      echo "$s" >> /tmp/js-sync-dotfiles.include.tmp
    else
      echo "Not found: $s"
    fi
  done

  echo

  for s in "${exclude[@]}"; do
      echo "$s" >> /tmp/js-sync-dotfiles.exclude.tmp
  done

  # Sync the dotfiles directories recursively to the repo
  rsync \
    --info=stats2 \
    --human-readable \
    --verbose \
    --archive \
    --partial \
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
    -c          Check active dotFiles (default)
    -d          Get dotFiles differences
    -s          Syncronize
    -v          More detailed output durint sync (verbose)
                Used with -s

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
  declare sync_verbose="false"
  declare sync="false"

  if [ "$#" -eq 0 ]; then

  dotFile_check_active

  fi

  while getopts :hvscd: options; do
    case "$options" in
      c) dotFile_check_active;;
      d)
        echo -e "${YELLOW}differences in '$OPTARG' dotFile\n${NC}"

        dotFile_get_diff "$OPTARG"
        ;;
      h) print_help; exit 0;;
      s) sync="true";;
      v) sync_verbose="true";;

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

  shift $((OPTIND-1))

  if [ "$sync" == "true" ] && [ "$sync_verbose" == "false" ]; then

    [ -f /tmp/js-sync-dotfiles.include.tmp ] && rm -f /tmp/js-sync-dotfiles.include.tmp
    [ -f /tmp/js-sync-dotfiles.exclude.tmp ] && rm -f /tmp/js-sync-dotfiles.exclude.tmp

    sync_data "$source" "$dotFiles_repo"

    echo

    gitCheck_and_commit "$dotFiles_repo"

  fi

  if [ "$sync" == "true" ] && [ "$sync_verbose" == "true" ]; then

    [ -f /tmp/js-sync-dotfiles.include.tmp ] && rm -f /tmp/js-sync-dotfiles.include.tmp
    [ -f /tmp/js-sync-dotfiles.exclude.tmp ] && rm -f /tmp/js-sync-dotfiles.exclude.tmp

    sync_data_verbose "$source" "$dotFiles_repo"

    echo

    gitCheck_and_commit "$dotFiles_repo"

  fi

  if [ "$sync" == "false" ] && [ "$sync_verbose" == "true" ]; then
    print_help
    exit 1
  fi

}

# ===  FUNCTION  ====================================================
#         NAME: dotFile_check_active
#  DESCRIPTION: Check actives dotFiles
#         TYPE: Operational
# ===================================================================

dotFile_check_active()
{
  #
  # contributor:  Julio Jiménez Delgado (jouleSoft)
  # version:      0.1
  # created:      22-05-2022
  #
  # dependencies: coreutils [dirname]
  #

  declare current_dir
  current_dir=$(pwd)

  # $dotFiles_repo declared at js-sync-dotfiles.conf
  cd "$dotFiles_repo" || exit 1

  #IFS=""

  #for t in $(find|sed -e "s/./~/"); do
  for t in "${dotFiles[@]}"; do
    if [ ! -e "$source/$t" ]; then
      echo -e "${NC}[   NA   ] $t"
    elif ! diff "$t" "$source/$t" > /dev/null 2>&1; then
      echo -e "${YELLOW}[   DF   ] $t"
    else
      #dotFile currently active
      echo -e "${LIGHT_GREEN}[   AC   ]${NC} $t"
    fi
  done

  echo

  dotFiles_check_active_legend

  echo

  cd "$current_dir" || exit 1
}

dotFiles_check_active_legend()
{
  #
  # contributor:  Julio Jiménez Delgado (jouleSoft)
  # version:      0.2
  # created:      22-05-2022
  #
  # dependencies: coreutils
  #

  echo -e "${CYAN} Legend:${NC}\n"
  echo -e "  ${LIGHT_GREEN}[   AC   ]${NC}: The dotFile is active in the system"
  echo -e "  ${YELLOW}[   DF   ]${NC}: Differences between active and stored dotFile"
  echo -e "  ${NC}[   NA   ]: Not Active. The dotFile is not currently in the system"
}

# ===  FUNCTION  ====================================================
#         NAME: dotFile_get_diff
#  DESCRIPTION: Get dotFiles differences
#         TYPE: Operational
# ===================================================================

dotFile_get_diff()
{
  diff -r --color='always' --suppress-common-lines "$dotFiles_repo/$1" "$source/$1" \
    && echo -e "${GREEN}None${NC}\n" \
    || echo
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
