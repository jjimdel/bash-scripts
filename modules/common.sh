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

#Dependencies array: used for checking the dependencies. It must be initialized in every script
declare -a deps_array

#Arguments arrays: used on the help screen when args_check() function evals '1'.
#Lists the required arguments
declare -a args_array
#Lists the required arguments description
declare -a args_definition_array

#Total arguments expected / introduced
declare args

#Dependencies array: used for checking the dependencies
#Leave empty if there is not any dependency
declare -a deps_array

#### [FUNCTIONS] ####

#Script header
header()
{
  # 
  # contributor:  Julio Jiménez Delgado (jouleSoft)
  # version:      0.1
  # updated:      08-10-2019
  # change:       Initial development
  #
  # dependencies
  #   - git
  # 
  # parameters
  #   - $1 - script_name
  #   - $2 - version
  #   - $3 - description
  #

  echo
  echo -e "${LIGHT_GREY} $1 ${YELLOW}$2 ${LIGHT_GREY}- $3${NC}\n"
  echo
}

#Argument control
args_check()
{
  # 
  # contributor:  Julio Jiménez Delgado (jouleSoft)
  # version:      0.1
  # updated:      08-11-2019
  # change:       Initial development
  #
  # dependencies
  #   - None
  # 

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

    exit 3

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

    exit 3
  fi
}

#Dependency control
deps_check()
{
  # 
  # contributor:  Julio Jiménez Delgado (jouleSoft)
  # version:      0.1
  # updated:      08-11-2019
  # change:       Initial development
  #
  # dependencies
  #   - which
  # 
  # parameters
  #   - $@ from 'deps_array' declared in every main script
  #
  # output
  #   - if there is any unfullfilled dependency, the function
  #     adds it to 'deps_check_array' (look DECLARATIONS AND
  #     DEFINITIONS section)
  #

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

  if [[ ${#deps_check_array[@]} -ne 0 ]]; then
    echo -e " Dependencies listed below are needed:"
    for e in "${deps_check_array[@]}"; do
      echo -e "   $e"
    done

    echo; exit 2
  fi
}

config_file_check()
{
  # 
  # contributor:  Julio Jiménez Delgado (jouleSoft)
  # version:      0.1
  # updated:      11-10-2021
  # change:       Initial development
  #
  # dependencies
  #   - None
  # 
  # parameters
  #   - $1 - Configuration file
  #
  # output
  #   - if there is no configuration file, exits with 1
  #

  if [ ! -e "$1" ]; then
    echo -e " configuration file not found\n"
    exit 1
  fi
}
