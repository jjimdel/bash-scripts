#!/usr/bin/env bash

#
# Title
#   <script_name>
#
# Description
#   <short_description>
#
# Version
#   1.0
#
# Contributor
#   Julio Jimenez Delgado (OM-Monitoring)
#
# GitHub
#   https://github.com/jouleSoft/bash-scripts.git
#
# License
#   The MIT License (MIT)
#   Copyright (c) 2022 OM-Monitoring
#
# Template
#   https://github.com/jouleSoft/bash-scripts/templates/template-args.sh
#
# Dependencies
#   root privileges
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

# -------------------------------------------------------------------
#   DECLARATIONS AND DEFINITIONS
# -------------------------------------------------------------------

#Script info
script_name=""
version=""
description=""

#Dependencies array: used for checking the dependencies.
#Declared in 'common.sh' module.
deps_array=(
  "find"
)

#Logging:
log_dir="$(dirname $0)/log"

#Global operational variables
declare hostname=""
declare id=""
declare server=""
declare poller_type=""

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

  # Write your code here!!!
}

# ===  FUNCTION  ====================================================
#         NAME: <function_name>
#  DESCRIPTION: <short_description>
#         TYPE: <operational | help | other>
# ===================================================================

#edit_gorgoned_pull()
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
