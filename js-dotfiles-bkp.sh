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
# Dependencies: None
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
"$HOME/.bashrc"
)

#dotfiles from '~/.config' directory
declare -a dotConfig=(
"$HOME/.config/alacritty"
"$HOME/.config/dunst"
"$HOME/.config/fish"
"$HOME/.config/i3status-rust"
"$HOME/.config/kitty"
"$HOME/.config/picom.conf"
"$HOME/.config/ranger"
)

#-------------------------------------------[Functions]--------------------------------------------

#Script header
header() 
{
	#Init color variables
	NC='\033[0m'
	LIGHT_GREY='\033[0;37m'
	YELLOW='\033[1;33m'

	echo 
	echo -e "${LIGHT_GREY} $script_name ${YELLOW}$version ${LIGHT_GREY}- $description${NC}\n"
	echo 
}

#Operational functions (if required)
#

#Main function
main()
{
	#Only dotfiles from '~/' directory
	for d in "${dotFiles[@]}"; do
		#Copy .bashrc
		[ "$d" == "$HOME/.bashrc" ] && cp -f "$d" "$repo/bashrc" && echo "$d copied"
	done

	#Dotfiles from '~/.config' directory
	for c in "${dotConfig[@]}"; do
		cp -rf "$c" "$repo/config/" && echo "$c copied"
	done

	echo
	echo "Backup done"
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
#

