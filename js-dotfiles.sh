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
#   -V            Show version
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
  "dirname"
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
  source "$HOME/.config/js-dotfiles.conf"

  [ -f /tmp/js-dotfiles.include.tmp ] && rm -f /tmp/js-dotfiles.include.tmp
  [ -f /tmp/js-dotfiles.exclude.tmp ] && rm -f /tmp/js-dotfiles.exclude.tmp

  # dotFilles array from js-dotfiles.conf
  for s in "${dotFiles[@]}"; do
    if [ -e "$HOME/$s" ]; then
      echo "$s" >> /tmp/js-dotfiles.include.tmp
    fi
  done

  # exclude array from js-dotfiles.conf
  for s in "${exclude[@]}"; do
      echo "$s" >> /tmp/js-dotfiles.exclude.tmp
  done

  check_arguments "$@"
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
    -d <dotFile>  Get dotFile differences between loaded and stored
    -v            More detailed output durint sync (verbose)

    -h            Display this message
    -V            Display version and script info"

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

  if [ "$#" -eq 0 ]; then

  dotFile_check_active "$sync_verbose"

  fi

  while getopts :hvVd: options; do
    case "$options" in
      d)
        echo -e "${YELLOW}differences in '$OPTARG' dotFile\n${NC}"

        dotFile_get_diff "$OPTARG"
        ;;
      h) print_help; exit 0;;
      v) sync_verbose="true";;
      V)
        #Printing the header
        header "$script_name" "$version" "$description"

        echo -e "License"
        echo -e "  The MIT License (MIT)"
        echo -e "  Copyright (c) 2022 Julio Jimenez Delgado (jouleSoft)\n"
        echo -e "GitHub"
        echo -e "  https://github.com/jouleSoft/bash-scripts.git\n"
        # License
        #   The MIT License (MIT)
        #   Copyright (c) 2022 Julio Jimenez Delgado (jouleSoft)
        #
      ;;

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

  if [ "$sync_verbose" == "true" ]; then
    dotFile_check_active "$sync_verbose"
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

  declare diffs
  diffs="false"

  declare -a diffs_array
  diffs_array=()

  declare verbose
  verbose="$1"

  declare current_dir
  current_dir=$(pwd)

  # $dotFiles_repo declared at js-dotfiles.conf
  cd "$dotFiles_repo" || exit 1

  #IFS=""

  echo -e "\n${CYAN} Checking dotFiles${NC}\n"

  for t in "${dotFiles[@]}"; do
    if [ ! -e "$t" ]; then
      echo -e "  ${RED}[   WA   ] $t"

      if [ -e "$source/$t" ]; then
        diffs="true"
        diffs_array+=("$t")
      fi

    elif [ ! -e "$source/$t" ]; then
      echo -e "  ${NC}[   --   ] $t"

    elif ! diff "$t" "$source/$t" > /dev/null 2>&1; then
      echo -e "  ${YELLOW}[   DF   ] $t"

      diffs="true"
      diffs_array+=("$t")

    elif [ "$(diff -r --suppress-common-lines --exclude-from="/tmp/js-dotfiles.exclude.tmp" "$t" "$source/$t" | wc -l)" -gt 0 ]; then
      echo -e "  ${ORANGE}[   CK   ] $t"

      diffs="true"
      diffs_array+=("$t")

    else
      #dotFile currently active
      echo -e "  ${LIGHT_GREEN}[   AC   ]${NC} $t"

    fi
  done

  echo

  dotFiles_check_active_legend

  echo

  cd "$current_dir" || exit 1

if [ "$diffs" == "true" ]; then

  declare confirm

  read -rp "Do you want to see the diffs? (Y/n): " confirm
  [ "$confirm" == "" ] && confirm="y"

  if [ "$confirm" == "y" ] || [ "$confirm" == "Y" ]; then
    for d in "${diffs_array[@]}"; do
      dotFile_get_diff "$d"
      echo
    done
  fi

  read -rp "Do you want to sync? (Y/n): " confirm
  [ "$confirm" == "" ] && confirm="y"

  if [ "$confirm" == "y" ] || [ "$confirm" == "Y" ]; then
    if [ "$verbose" == "false" ]; then
      sync_data "$source" "$dotFiles_repo"
    else
      sync_data_verbose "$source" "$dotFiles_repo"
    fi

    echo

    gitCheck_and_commit "$dotFiles_repo"
  fi
fi

}

# ===  FUNCTION  ====================================================
#         NAME: dotFile_check_active_legend
#  DESCRIPTION: Pring check active dotFiles legend
#         TYPE: Operational
# ===================================================================

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
  echo -e "  ${ORANGE}[   CK   ]${NC}: Differences between active and stored dotFile. Stored need to be checked"
  echo -e "  ${RED}[   WA   ]${NC}: Warinig. The dotFiles aren't in the store repo"
  echo -e "  ${NC}[   --   ]: Not Active. The dotFile is not currently in the system"
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
    --files-from=/tmp/js-dotfiles.include.tmp \
    --exclude-from=/tmp/js-dotfiles.exclude.tmp \
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

  # dotFilles array from js-dotfiles.conf
  for s in "${dotFiles[@]}"; do
    if [ -e "$HOME/$s" ]; then
      echo "$s" >> /tmp/js-dotfiles.include.tmp
    else
      echo "Not found: $s"
    fi
  done

  echo

  for s in "${exclude[@]}"; do
      echo "$s" >> /tmp/js-dotfiles.exclude.tmp
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
    --files-from=/tmp/js-dotfiles.include.tmp \
    --exclude-from=/tmp/js-dotfiles.exclude.tmp \
    "$1" \
    "$2/"
}


# -------------------------------------------------------------------
#   EXECUTION
# -------------------------------------------------------------------

# Check if config file exists (when needed)
config_file_check "$HOME/.config/js-dotfiles.conf"

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
