#!/usr/bin/env bash
# ---
# Title:        js.simplebkp.sh
# Description:  Create a simple file copy adding today's date on iso format as prefix
# Author:       Julio Jimenez Delgado
#
# GitHub repo:	https://github.com/jouleSoft/js-sh (stable)
#		        https://github.com/jouleSoft/js-DevOps (testing)
#
# License:      The MIT License (MIT)
#		        <https://github.com/jouleSoft/js-sh/blob/master/LICENSE>
#               Copyright (c) <YEAR> Julio Jiménez Delgado (jouleSoft)
#
# Template:     template_args.dep.sh <https://github.com/jouleSoft/js-DevOps/templates/>
#
# Requirements: Arguments
# 
# Version:      0.1
# Author:       Julio Jimenez Delgado
# Date:         16/01/2021
# Change:       Initial development
# 
#

#----------------------------------[Declarations and definitions]----------------------------------

#Script info and arguments evaluation variables
script_name="js.simplebkp.sh"
version="v.0.1"
description="Create a simple file copy adding today's date on iso format as prefix"

#Arguments arrays: used on the help screen when args_check() function evals '1'.
args_array=(
	"filename"
	"backup_dir"
	)
args_definition_array=(
	"path where the target file is located"
	"path to destination directory to copy the backup of the target file"
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

#-------------------------------------------[Functions]--------------------------------------------

#Script header
header() 
{
	#Init color variables
	NC='\033[0m'
	LIGHT_GREY='\033[0;37m'
	YELLOW='\033[1;33m'

	echo 
	printf "${LIGHT_GREY} $script_name ${YELLOW}$version ${LIGHT_GREY}- $description${NC}\n"
	echo 
}

#Argument control
args_check() 
{
	#When less arguments than expected: help text is shown
	if [ "$#" -lt $args ]; then
		echo " More arguments needed."
		echo "     Expected:   $args"
		echo "     Intruduced: $#"
		echo 
		echo " Syntax:"
		echo "     $script_name ${args_array[*]}"
		echo 
		echo " Where:"
		for (( i=0; i<$args; i++ ))
		do
			echo "     ${args_array[$i]} - ${args_definition_array[$i]}"
		done
		echo 

		args_check_result=1

	#When more arguments than expected: help text is shown
	elif [ "$#" -gt $args ]; then
		echo " More arguments than expected."
		echo "     Expected:   $args"
		echo "     Intruduced: $#"
		echo 
		echo " Syntax:"
		echo "     $script_name ${args_array[*]}"
		echo 
		echo " Where:"
		for (( i=0; i<$args; i++ ))
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

	#When number of dependencies are more than zero, they will be checked
	if [[ $deps -gt 0 ]]; then
		for d in "$@"; do
			which $d > /dev/null 2>&1
			#If the dependency in $d is not installed,
			#it will be stored in '${deps_check_array}'
			if ! [[ $? -eq 0 ]]; then
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
	if [ -e "$2/$(date +%Y%m%d).$(basename $1)" ]; then
		echo " Today's backup already exists"
	else
		cp "$1" "$2/$(date +%Y%m%d).$(basename $1)"
		if [ "$?" -eq 0 ]; then
			echo " Backup done!"
		else
			echo " A problem occuried (err: $?)"
		fi
	fi

	echo
}

#-------------------------------------------[Execution]--------------------------------------------

#Printing the header
header

#Dependency evalutation
deps_check ${deps_array[@]}

#Arguments number evaluation
if [[ ${#deps_check_array[@]} -eq 0 ]]; then
	args_check "$@"
else
	echo "The dependencies listed below are needed:"
	for e in ${deps_check_array[@]}; do
		echo "     $e"
	done

	echo

	#If there are not all the dependencies, the main function will be skipped
	args_check_result=1
fi

if [ $args_check_result -eq 0 ]; then
	main "$@"
fi

#------------------------------------------[Finalization]------------------------------------------

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
