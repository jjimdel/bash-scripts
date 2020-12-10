#!/usr/bin/env bash
# ---
# Title:        js.downolad-links.sh
# Description:  Downloading links from a text file using youtube-dl
# Author:       Julio Jimenez Delgado
# License:      The MIT License (MIT)
#		<https://github.com/jouleSoft/js-ShellScript/blob/master/LICENSE>
#               Copyright (c) 2020 Julio Jiménez Delgado
#
# Template:     js.script-args.sh <https://github.com/jouleSoft/js-ShellScripts/templates/>
#
# Requirements: Arguments
#		youtube-dl
# 
# Version:      0.1
# Author:       Julio Jimenez Delgado
# Date:         <DD/MM/AAAA>
# Change:       Initial development
# 
#

#----------------------------------[Declarations and definitions]----------------------------------

#Script info and arguments evaluation variables
script_name="js.downolad-links.sh"
version="v.0.1"
description="Downloading links from a text file using youtube-dl"

#Total arguments expected / introduced
args=1
args_in_array=("$@")

#Arguments arrays: used on the help screen when args_check() function evals '1'.
args_array=(
	"text_file"
)
args_definition_array=(
	"list of links for downloading"
)

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
	#When less arguments than expected
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

	#When more arguments than expected
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
        
		#Less arguments than expected.
		args_check_result=1
	
	#All arguments needed: OK.
	else
		args_check_result=0
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

	if [ ! -e /home/jjimenez/Descargas ]; then
		OUTPUT="$HOME/Descargas"
	elif [ ! -e /home/jjimenez/Downloads ]; then
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

#Arguments number evaluation
args_check ${args_in_array[@]}

if [ $args_check_result -eq 0 ]; then

	which youtube-dl > /dev/null

	if [[ $? -eq 0 ]] && [ -e "$1" ]; then
		main "$@"
	else
		echo -e "\n youtube-dl is not installed or 'text_file' is not in the system.\n"
	fi
fi

#------------------------------------------[Finalization]------------------------------------------

#Script header
unset script_name
unset version
unset description

#Argument evaluation
unset args
unset args_in_array
unset args_array
unset args_definition_array
unset args_check_result

#Operational variables (if any)
#
