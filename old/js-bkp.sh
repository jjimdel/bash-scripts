#!/usr/bin/env bash
# ---
# Title:        js.bkp.sh
# Description:  Create a simple file/directory backup
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
# Version:      0.2
# Author:       Julio Jimenez Delgado
# Date:         23/01/2021
# Change:       Declarations and definitions
# 					- 'description' variable: description test changed
#				Functions
#					- Main function:
#					   * Create a directory per day where the backups
#					     are going to be stored.
#					   * Create a log file where log the original target path
#

#----------------------------------[Declarations and definitions]----------------------------------

#Script info and arguments evaluation variables
script_name="js.bkp.sh"
version="v.0.2"
description="Create a simple file/directory backup"

#Arguments arrays: used on the help screen when args_check() function evals '1'.
args_array=(
	"target_dir"
	"backup_dir"
	)
args_definition_array=(
	"Path of the target"
	"path to destination directory to make the backup"
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
	#File where write the original paths for
	#helping in case of necessity of recovery
	local content_flog="backup_trace.log"

	#If not exists, create a directory named by date
	if [ ! -e "$2/$(date +%Y%m%d)" ]; then
		mkdir "$2/$(date +%Y%m%d)"
	fi

	#If not exists yet, copy target file / directory
	if [ ! -e "$2/$(date +%Y%m%d)/_$(basename $1)" ]; then
		cp -r "$1" "$2/$(date +%Y%m%d)/_$(basename $1)"

		#Evaluate if target is a file or a directory
		if [ -d "$1" ]; then
			local ftype="d"
		elif [ -f "$1" ]; then
			local ftype="f"
		fi

		#Log target's orginal path indicating if it is a file or a directory
		printf "$(date +%F' '%T) :: ($ftype)[$(basename $1)] :\t $1\n" >> "$2/$(date +%Y%m%d)/$content_flog"

		if [ "$?" -eq 0 ]; then
			echo " Backup done!"
		else
			echo " A problem occuried (err: $?)"
		fi
	else
		echo " The backup already exists. No files copied"
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
