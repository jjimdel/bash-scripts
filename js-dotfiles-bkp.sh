#!/usr/bin/env bash
# ---
# Title:        js-dotfiles-bkp.sh
# Description:  Create dotfiles backup
# Contributors: Julio Jimenez Delgado
#
# GitHub repo:	https://github.com/jouleSoft/js-DevOps
#
# License:      The MIT License (MIT)
#               Copyright (c) 2021 Julio Jiménez Delgado (jouleSoft)
#
# Template:     template_noargs.sh <https://github.com/jouleSoft/js-DevOps/templates/>
#
# Dependencies: git
# 
# Version:      0.1
# By:           Julio Jimenez Delgado
# Date:         30/05/2021
# Change:       Initial development
# 
#

#----------------------------------[Declarations and definitions]----------------------------------

#Script info and arguments evaluation variables
script_name="js-dotfiles-bkp.sh"
version="v.0.1"
description="Create dotfiles backup"

#Global operational variables
#Repo path
repo="$HOME/github/dotfiles"

#dotfiles from '~/' directory
declare -a dotFiles=(
".bashrc"
)

#dotfiles from '~/.config' directory
declare -a dotConfig=(
"alacritty"
"dunst"
"fish"
"i3status-rust"
"kitty"
"picom.conf"
"ranger"
)

#-------------------------------------------[Functions]--------------------------------------------

#Script header
header() 
{
	#Init color variables
	local NC='\033[0m'
	local LIGHT_GREY='\033[0;37m'
	local YELLOW='\033[1;33m'

	echo 
	echo -e "${LIGHT_GREY} $script_name ${YELLOW}$version ${LIGHT_GREY}- $description${NC}\n"
	echo 
}

#Operational functions (if required)
gitCheck()
{
	local currentDir
	currentDir="$(pwd)"

	cd "$repo" && echo "GIT status of [$(pwd)]"; echo; git status --short || echo "$repo doesn't exist"
	cd "$currentDir" || echo "$currentDir doesn't exsit"

}

#Main function
main()
{
	local NC='\033[0m'
	local LIGHT_GREEN='\033[1;32m'
	local YELLOW='\033[1;33m'

	#Only dotfiles from '~/' directory
	for d in "${dotFiles[@]}"; do
		#Copy .bashrc
		if [ "$HOME/$d" == "$HOME/.bashrc" ]; then
			#if there is no differences between the dotFile source and the repo,
			#the file or directory won't be copied
			if diff "$HOME/$d" "$repo/bashrc"; then
				echo -e "${LIGHT_GREEN}[ OK ]${NC} $d"
			else
				cp -f "$HOME/$d" "$repo/bashrc" && echo -e "${YELLOW}[ copied ]${NC} $d"
			fi
		fi
	done

	#Dotfiles from '~/.config' directory
	for c in "${dotConfig[@]}"; do
		#if there is no differences between the dotConfig source and the repo,
		#the file or directory won't be copied
		if diff "$HOME/.config/$c" "$repo/config/$c"; then
			echo -e "${LIGHT_GREEN}[ OK ]${NC} .config/$c"
		else
			cp -rf "$HOME/.config/$c" "$repo/config/" && echo -e "${YELLOW}[ copied ]${NC} .config/$c"
		fi
	done

	echo
	echo "Backup done"
	echo
	gitCheck
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
unset dotFiles
unset dotConfig
