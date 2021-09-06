#!/usr/bin/env bash

#Script header
header()
{
  # -.- [PARAMETERS DESCRIPTION] -.-
  # $1 - script_name
  # $2 - version
  # $3 - description

  #Init color variables
  declare NC='\033[0m'
  declare LIGHT_GREY='\033[0;37m'
  declare YELLOW='\033[1;33m'

  echo
  echo -e "${LIGHT_GREY} $1 ${YELLOW}$2 ${LIGHT_GREY}- $3${NC}\n"
  echo
}

#Argument control
args_check()
{
        #When less arguments than expected: help text is shown
        if [ "$#" -lt "$args" ]; then
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

        #When more arguments than expected: help text is shown
        elif [ "$#" -gt "$args" ]; then
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

        #All arguments needed: OK.
        else
                args_check_result=0
        fi
}

#Dependency control
deps_check()
{
        #Number of software dependencies
        declare deps="$#"

        #When number of dependencies are more than zero, they will be checked
        if [[ $deps -gt 0 ]]; then
                for d in "$@"; do
                        #If the dependency in $d is not installed,
                        #it will be stored in '${deps_check_array}'
                        if [[ $(which "$d" > "/dev/null  2>&1") -gt 0 ]]; then
                                deps_check_array+=("$d")
                        fi
                done
        fi
}
