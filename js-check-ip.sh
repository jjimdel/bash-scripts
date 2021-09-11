#!/usr/bin/env bash
# ---
# Title:        js-check-ip.sh
# Description:  Checks an IP address and log the result
# Contributors: Julio Jimenez Delgado
#
# GitHub repo:  https://github.com/jouleSoft/bash-scripts.git
#
# License:      The MIT License (MIT)
#               Copyright (c) 2021 Julio Jiménez Delgado (jouleSoft)
#
# Template:     args-dep.sh <https://github.com/jouleSoft/bash-scripts/templates>
#
# Dependencies: NONE
#
# Version:      0.1
# By:           Julio Jimenez Delgado
# Date:         06/09/2021
# Change:       Initial development
#
#

####  -.- [MODULES] -.-  ####
. /home/jjimenez/workspace/bash-scripts/modules/general.sh

####  -.- [DECLARATIONS AND DEFINITIONS] -.-  ####

#Script info and arguments evaluation variables
declare script_name="js-check-ip.sh"
declare version="v.0.1"
declare description="Checks an IP address and log the result"

#Arguments arrays: used on the help screen when args_check() function evals '1'.
declare -a args_array=(
  "source_addr"
  "target"
  "log_file"
)
declare -a args_definition_array=(
  "Source interface or IP address"
  "Hostname or IP address to check"
  "Logfile path"
)

#Total arguments expected / introduced
declare args=${#args_array[@]}

#Dependencies array: used for checking the dependencies
#Leave empty if there is not any dependency
declare -a deps_array=()

#Dependencies check array: used in the help screen for enumerating the missing dependencies
#it will be completed in 'deps_check()' function
declare -a deps_check_array=()

#Global operational variables
# NONE

#### -.- [FUNCTIONS] -.-  ####

check_ip()
{
  declare time_stamp
  declare log_file
  declare log_write

  time_stamp="$(date +%d-%m-%y' '%H:%M:%S' '%Z)"
  log_file=""


  ping -c 1 -4 -I "$1" "$2" > /dev/null

  if [ "$?" -eq 0 ]; then
    log_write="$time_stamp: ping to $2 succeeded"
  else
    log_write="$time_stamp: ping to $2 failed"
  fi


  if [ ! -e "$3" ]; then
    echo "# js-check-ip.sh log file" > "$3"
    echo "---" >> "$3"
  fi
  echo "$log_write" >> "$3"
}


#Operational functions (if required)
#

#Main function
main()
{
  check_ip "$@"
  echo
}

#### -.- [EXECUTION] -.-  ####

#Printing the header
header "$script_name" "$version" "$description"

#Dependency evalutation
deps_check "${deps_array[@]}"

#Arguments number evaluation
if [[ ${#deps_check_array[@]} -eq 0 ]]; then
  args_check "$@"
else
  echo "The dependencies listed below are needed:"
  for e in "${deps_check_array[@]}"; do
    echo "     $e"
  done

  echo

  #If there are not all the dependencies, the main function will be skipped
  args_check_result=1
fi

if [ $args_check_result -eq 0 ]; then
  main "$@"

  if [ "$?" -eq 0 ]; then
    exit 0
  else
    exit 1
  fi
fi

#### -.- [FINALIZATION] -.-  ####

#Script header
unset script_name
unset version
unset description

#Argument evaluation
unset args
unset args_array
unset args_definition_array
unset args_check_result

#Dependency evaulation
unset deps_check_array
unset deps_array

#Operational variables (if any)
#
