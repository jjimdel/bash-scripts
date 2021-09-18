#!/usr/bin/env bash

# 
# Title
#   <script_name>
#
# Description
#   <short_description>
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
#   <dependency | None>
#


#### [MODULES] ####

. /home/jjimenez/workspace/bash-scripts/modules/common.sh

#### [DECLARATIONS AND DEFINITIONS] ####

#Script info and arguments evaluation variables
declare script_name
declare version
declare description

script_name=""
version="v0.1"
description=""

#Arguments arrays: used on the help screen when args_check() function evals '1'.
args_array=(
  "arg1"
  "arg2"
)
args_definition_array=(
  "arg1 description"
  "arg2 description"
)

#Total arguments expected / introduced
args=${#args_array[@]}

#Dependencies array: used for checking the dependencies
#Leave empty if there is not any dependency
deps_array=()

#Dependencies check array: used in the help screen for enumerating the missing dependencies
#it will be completed in 'deps_check()' function
deps_check_array=()

#Global operational variables
# NONE

#### [FUNCTIONS] ####

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

        #All arguments needed: OK.
      else
        args_check_result=0
  fi
}

#Dependency control
deps_check()
{
  #Number of software dependencies 
  local deps="$#"

  if [[ $deps -gt 0 ]]; then
    #When number of dependencies are more than zero, they will be checked
    for d in "$@"; do
      if [[ $(which "$d" > "/dev/null  2>&1") -gt 0 ]]; then
        #If the dependency in $d is not installed,
        #it will be stored in '${deps_check_array}'

        deps_check_array+=("$d")

      fi
    done
  fi
}

#Operational functions (if required)
#

#Main function
main()
{
  echo
  #Write main code block here!!
  echo
}

#### [EXECUTION] ####

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
fi

#### [FINALIZATION] ####

#Script header
unset script_name
unset version
unset description

#Argument evaluation
unset args
unset args_array
unset args_definition_array
unset args_check_result

#Dpendency evaulation
unset deps_check_array
unset deps_array

#Operational variables (if any)
#
