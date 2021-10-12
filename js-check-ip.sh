#!/usr/bin/env bash

# 
# Title
#   js-check-ip.sh
#
# Description
#   Checks an IP address and log the result
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
#   https://github.com/jouleSoft/bash-scripts/templates/args.sh 
#
# Dependencies 
#   None
#

#### [MODULES] ####

. $HOME/workspace/bash-scripts/modules/common.sh

#### [DECLARATIONS AND DEFINITIONS] ####

#Script info and arguments evaluation variables
script_name="js-check-ip.sh"
version="v0.3"
description="Checks an IP address and log the result"

#Dependencies array: used for checking the dependencies.
#Declared in 'common.sh' module.
deps_array=()

#Arguments arrays: used on the help screen when args_check() function evals '1'.
args_array=(
  "source_addr"
  "target"
  "log_dir"
)

args_definition_array=(
  "Source interface or IP address"
  "Hostname or IP address to check"
  "Log directory path"
)

#Total arguments expected / introduced
args=${#args_array[@]}

#Global operational variables
# NONE

#### [FUNCTIONS] ####

#Operational functions (if required)
check_ip()
{
  # 
  # parameters
  #   - $1 - Source IP address or interface
  #   - $2 - Target IP address
  #   - $3 - Log directory
  #

  #Ping once to IPv4 address ($2) from an specific interface ($1)
  ping -c 1 -4 -I "$1" "$2" > /dev/null

  #Log string
  if [ "$?" -eq 0 ]; then
    log_write="ping to $2 succeeded"
  else
    log_write="ping to $2 failed"
  fi

  #Write log header into logfile ($3/logfile)
  log_header "$3"

  #Write to logfile ($3/logfile)
  log_in "$log_write" "$3"
}

#Main function
main()
{
  check_ip "$@"
  echo
}

#### [EXECUTION] ####

#Printing the header
header "$script_name" "$version" "$description"

#Check if config file exists (when needed)
# config_file_check "<config_file>"

#Dependency evalutation
deps_check "${deps_array[@]}"

#Arguments number evaluation
args_check "$@"

#Main function execution
main "$@"

#### [FINALIZATION] ####

#Unset common.sh module variables
common_unset

#Operational variables (if any)
#
