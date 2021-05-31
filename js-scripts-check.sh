#!/usr/bin/env bash
# ---
# Title:        js-scritps-check.sh
# Description:  Checks differences between shell scripts between 'js-DevOps' and 'js-sh' repos and syncs them
# Contributors: Julio Jimenez Delgado
#
# GitHub repo:	https://github.com/jouleSoft/js-DevOps
#
# License:      The MIT License (MIT)
#               Copyright (c) 2021 Julio Jiménez Delgado (jouleSoft)
#
# Template:     template_noargs.sh <https://github.com/jouleSoft/js-DevOps/templates/>
#
# Dependencies: <dependency1>
#
# Version:      0.1
# By:           Julio Jimenez Delgado
# Date:         30/05/2021
# Change:       Initial development
# 
#

#----------------------------------[Declarations and definitions]----------------------------------

#Script info and arguments evaluation variables
declare script_name
declare version
declare description

script_name="js-scripts-check.sh"
version="v0.1"
description="Checks differences between shell scripts between 'js-DevOps' and 'js-sh' repos and syncs them"

#Global operational variables
#Current dir
declare currentDir
currentDir="$(pwd)"

#-------------------------------------------[Functions]--------------------------------------------

#Script header
header() 
{
	#Declare color variables
	declare NC 
	declare LIGHT_GREY
	declare YELLOW

	#Init color variables
	NC='\033[0m'
	LIGHT_GREY='\033[0;37m'
	YELLOW='\033[1;33m'

	echo 
	#Print script header
	echo -e "${LIGHT_GREY}$script_name ${YELLOW}$version ${LIGHT_GREY}- $description${NC}"
	echo 
}

#Operational functions (if required)
gitCheck()
{
	declare -a gitRepos

	declare NC
	declare LIGHT_GREEN

	NC='\033[0m'
	LIGHT_GREEN='\033[1;32m'

	gitRepos=(
	"$HOME/github/js-DevOps"
	"$HOME/github/js-sh"
	)


	for g in "${gitRepos[@]}"; do
		if cd "$g"; then
			echo -e "${LIGHT_GREEN}GIT status of [$(pwd)]${NC}"
			echo "---"
			git status --short
			echo "---"
		else
			echo "$g doesn't exist"
		fi
	done
}

shCheck()
{
	#Declare and init color variables
	declare NC
	declare LIGHT_GREY
	declare YELLOW

	NC='\033[0m'
	LIGHT_GREY='\033[0;37m'
	YELLOW='\033[1;33m'

	#Declare file and directory variables
	declare develFiles
	declare prodFiles
	declare develDir
	declare prodDir

	declare counter
	counter=0

	#Init directory variables
	develDir="$HOME/github/js-DevOps/sh"
	prodDir="$HOME/github/js-sh"

	#Init file variables
	cd "$develDir" && develFiles=$(/usr/bin/ls -1 *.sh) || echo "directory $develDir doesn't exist"
	cd "$prodDir" && prodFiles=$(/usr/bin/ls -1 *.sh) || echo "directory $prodDir doesn't exist"

	if [ ! "$(echo "$develFiles"|wc -l)" -eq "$(echo "$prodFiles"|wc -l)" ]; then
		echo -e "${YELLOW}js-DevOps (sh):${NC} $(echo "$develFiles"|wc -l) <--> ${YELLOW}js-sh:${NC} $(echo "$prodFiles"|wc -l)"
	else
		echo -e "${LIGHT_GREY}js-DevOps (sh):${NC} $(echo "$develFiles"|wc -l) <--> ${LIGHT_GREY}js-sh:${NC} $(echo "$prodFiles"|wc -l)"
	fi

	echo "-----"

	for d in $develFiles; do
		for p in $prodFiles; do
			[ "$d" == "$p" ] && ((counter++))
		done

		[ "$counter" -eq 0 ] && echo -e "${YELLOW}[ N ]${NC} $d" || echo "[ Y ] $d"

		counter=0
	done

}

#Main function
main()
{
	shCheck
	echo
	gitCheck
	cd "$currentDir" || echo "$currentDir doesn't exsit"
	echo
}

#-------------------------------------------[Execution]--------------------------------------------


#Printing the header
header

#Main function execution
main


#------------------------------------------[Finalization]------------------------------------------

#Script header
unset script_name
unset version
unset description

#Operational variables (if any)
unset currentDir
