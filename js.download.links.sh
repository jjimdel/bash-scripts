#!/usr/bin/env bash
# ---
# Title:        js.downolad-links.sh
# Description:  Downloading links from a text file using youtube-dl
# Author:       Julio Jimenez Delgado
#
# GitHub repo:	https://github.com/jouleSoft/js-sh (stable)
#		https://github.com/jouleSoft/js-DevOps (testing)
#
# License:      The MIT License (MIT)
#		<https://github.com/jouleSoft/js-sh/blob/master/LICENSE>
#               Copyright (c) 2020 Julio Jiménez Delgado (jouleSoft)
#
# Template:     js.script-args.sh <https://github.com/jouleSoft/js-DevOps/templates/>
#
# Requirements: Arguments, youtube-dl
# 
# Version:      0.1
# Author:       Julio Jimenez Delgado
# Date:         08/10/2019
# Change:       Initial development
# 
# Version:      0.2
# Author:       Julio Jimenez Delgado
# Date:         08/11/2019
# Change:       Checking dependency: youtube-dl
#
# Version:      0.3
# Author:       Julio Jimenez Delgado
# Date:         13/12/2020
# Change:       Directory of destination set at '~/Downloads' or '~/' instead
#
# Version:      0.4
# Author:       Julio Jimenez Delgado
# Date:         15/12/2020
# Change:       Changing the dependency checking: 'deps_check()' function
#

#----------------------------------[Declarations and definitions]----------------------------------

#Script info and arguments evaluation variables
script_name="js.downolad-links.sh"
version="v.0.4"
description="Downloading links from a text file using youtube-dl"

#Arguments arrays: used on the help screen when args_check() function evals '1'
args_array=(
	"text_file"
	)
args_definition_array=(
	"list of links for downloading"
	)
	
#Total arguments expected / introduced
args=${#args_array[@]}

#Dependencies array: used for checking the dependencies
deps_array=(
	"youtube-dl"
	)

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
	local lnk_file="$1"
	local total_lines=$(wc -l "$lnk_file" | cut -d ' ' -f 1)
	local count_lines=1
	local error_code=0

	if [ -e $HOME/Descargas ]; then
		OUTPUT="$HOME/Descargas"
	elif [ -e $HOME/Downloads ]; then
		OUTPUT="$HOME/Downloads"
	else
		OUTPUT="$HOME"
	fi
	
	for l in $(cat $lnk_file) 
	do 
		printf "\n${YELLOW} Link $count_lines / $total_lines${NC}\n\n"

		youtube-dl -i $l -o "$OUTPUT/%(title)s.%(ext)s"
		
		if [ ! $? -eq 0 ]; then
			error_code=1
		fi

		let "count_lines++"
	done

	if [ $error_code -eq 0 ]; then
		> $lnk_file
	fi
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
	if [ -e "$1" ]; then
		main "$@"
	else
		echo -e "\n 'text_file' is not in the system.\n"
	fi
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

#Dependency evaluation
unset deps_check_array
unset deps_array

#Operational variables (if any)
#
