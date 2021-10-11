#!/usr/bin/env bash

#### [DECLARATIONS AND DEFINITIONS] ####

#No color
declare NC='\033[0m'

#Standar colors
declare BLACK='\033[0;30m'
declare BLUE='\033[0;34m'
declare CYAN='\033[0;36m'
declare GREEN='\033[0;32m'
declare ORANGE='\033[0;33m'
declare PURPLE='\033[0;35m'
declare RED='\033[0;31m'
declare YELLOW='\033[1;33m'

#Light colors
declare LIGHT_BLUE='\033[1;34m'
declare LIGHT_CYAN='\033[1;36m'
declare LIGHT_GREEN='\033[1;32m'
declare LIGHT_GREY='\033[0;37m'
declare LIGHT_PURPLE='\033[1;35m'
declare LIGHT_RED='\033[1;31m'
declare LIGHT_WHITE='\033[1;37m'

#Dark colors
declare DARK_GREY='\033[1;30m'

#Dependencies check array: used in the help screen for enumerating the missing dependencies
#it will be completed in 'deps_check()' function
declare -a deps_check_array

#### [FUNCTIONS] ####

#Script header
header()
{
  # -.- [PARAMETERS DESCRIPTION] -.-
  # $1 - script_name
  # $2 - version
  # $3 - description

  echo
  echo -e "${LIGHT_GREY} $1 ${YELLOW}$2 ${LIGHT_GREY}- $3${NC}\n"
  echo
}

#Argument control
args_check()
{
  if [ "$#" -lt "$args" ]; then
    #When less arguments than expected: help text is shown

    echo " More arguments needed."
    echo "     Expected:   $args"
    echo "     Intruduced: $#"
    echo
    echo " Syntax:"
    echo "     $script_name ${args_array[*]}"
    echo
    echo " Where:"
    for (( i=0; i<args; i++ ))
    do
      echo "     ${args_array[$i]} - ${args_definition_array[$i]}"
    done
    echo

    args_check_result=1

  elif [ "$#" -gt "$args" ]; then
    #When more arguments than expected: help text is shown

    echo " More arguments than expected."
    echo "     Expected:   $args"
    echo "     Intruduced: $#"
    echo
    echo " Syntax:"
    echo "     $script_name ${args_array[*]}"
    echo
    echo " Where:"
    for (( i=0; i<args; i++ ))
    do
      echo "     ${args_array[$i]} - ${args_definition_array[$i]}"
    done
    echo

    args_check_result=1

  else
    #All arguments needed: OK.

    args_check_result=0
  fi
}

#Dependency control
deps_check()
{
  #Number of software dependencies
  declare deps="$#"

  if [[ $deps -gt 0 ]]; then

    #When number of dependencies is more than zero, they will be checked
    for d in "$@"; do
      which "$d" > /dev/null  2>&1
      if [ "$?" -gt 0 ]; then

        #If the dependency in $d is not installed, it will be stored in '${deps_check_array}'
        deps_check_array+=("$d")

      fi
    done
  fi
}
