#!/usr/bin/env bash
# ---
# Title:        js.filex.sh
# Description:  File analyzer
# Author:       Julio Jimenez Delgado
# License:      The MIT License (MIT)
#				<https://github.com/jouleSoft/js-sh/blob/master/LICENSE>
#               Copyright (c) <YEAR> Julio Jiménez Delgado
#
# Template:     js.script-args.sh <https://github.com/jouleSoft/js-ShellScripts/templates/>
#
# Requirements: Arguments
# 
# Version:      0.1
# Author:       Julio Jimenez Delgado
# Date:         29/08/2019
# Change:       Initial development
# 
# Version:      0.2
# Author:       Julio Jimenez Delgado
# Date:         23/09/2019
# Change:       Functions 'owner()' and 'disk_usage()' has been created
#
# Version:      0.3
# Author:       Julio Jimenez Delgado
# Date:         14/12/2020
# Change:       Disk usage is expressed in bytes, explicitly
#


#----------------------------------[Declarations and definitions]----------------------------------

#Script info and arguments evaluation variables
script_name="js.filex.sh"
version="v.0.2"
description="File analyzer"

#Total arguments expected / introduced
args=1
args_in_array=("$@")

#Arguments arrays: used on the help screen when args_check() function evals '1'.
args_array=(
	"target"
)
args_definition_array=(
	"File or directory to analyze"
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
owner()
{
	echo "	Uid: 	$(stat $1 | grep 'Uid:'| cut -d ' ' -f6| tr -d '()')"
	echo "	Gid: 	$(stat $1 | grep 'Uid:'| cut -d ' ' -f11| tr -d '()')"
	echo ""
}

user_priv() # Checks group privileges
{
	local read_priv="";
	local write_priv="";
	local exec_priv="";

	case $(ls -l $1|cut -c2) in

		-) read_priv="No-read";;
		r) read_priv="Read";;

	esac

	case $(ls -l $1|cut -c3) in

		-) write_priv="No-write";;
		w) write_priv="Write";;

	esac

	case $(ls -l $1|cut -c4) in

		-) exec_priv="No-exec";;
		x) exec_priv="Exec";;
		
	esac

	echo "	User:	$read_priv, $write_priv, $exec_priv"
}

group_priv() # Checks group privileges
{
	local read_priv="";
	local write_priv="";
	local exec_priv="";

	case $(ls -l $1|cut -c5) in

		-) read_priv="No-read";;
		r) read_priv="Read";;

	esac

	case $(ls -l $1|cut -c6) in

		-) write_priv="No-write";;
		w) write_priv="Write";;

	esac

	case $(ls -l $1|cut -c7) in

		-) exec_priv="No-exec";;
		x) exec_priv="Exec";;
		
	esac

	echo "	Group:	$read_priv, $write_priv, $exec_priv"
}

others_priv() # Checks group privileges
{
	local read_priv="";
	local write_priv="";
	local exec_priv="";

	case $(ls -l $1|cut -c8) in

		-) read_priv="No-read";;
		r) read_priv="Read";;

	esac

	case $(ls -l $1|cut -c9) in

		-) write_priv="No-write";;
		w) write_priv="Write";;

	esac

	case $(ls -l $1|cut -c10) in

		-) exec_priv="No-exec";;
		x) exec_priv="Exec";;
		
	esac

	echo "	Others:	$read_priv, $write_priv, $exec_priv"
}

disk_usage()
{
	echo "	$(ls -lh $1 | cut -d ' ' -f5)"
}

md5_hash()
{
	echo "	$(md5sum $1 | cut -d ' ' -f1)"
}

#Main function
main()
{
	if [ -e "$1" ]; then
		echo " File type:"
		echo "	$(file $1 | cut -d ':' -f2)"
		echo ""

		if [ ! -d $1 ]; then
			echo " Ownership:"

			owner "$1"

			echo " Privileges:"

			user_priv "$1"
			group_priv "$1"
			others_priv "$1"
			
			echo ""

			echo " Disk usage:"
			echo "$(disk_usage "$1")B"

			echo ""

			echo " md5 hash:"
			md5_hash "$1"

			echo ""
		fi

	else
		echo " $1: No such file"
		echo ""
	fi
}

#-------------------------------------------[Execution]--------------------------------------------

#Printing the header
header

#Arguments number evaluation
args_check ${args_in_array[@]}

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
unset args_in_array
unset args_array
unset args_definition_array
unset args_check_result

#Operational variables (if any)
#
