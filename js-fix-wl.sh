#!/usr/bin/env bash
# ---
# Title:        js-fix-wl.sh
# Description:  Reload wl kernel module so that the kernel can start it again
# Contributors: Julio Jimenez Delgado
#
# GitHub repo:	https://github.com/jouleSoft/js-sh
#
# License:      The MIT License (MIT)
#               Copyright (c) <YEAR> Julio Jiménez Delgado (jouleSoft)
#
# Template:     noargs.sh <https://github.com/jouleSoft/js-templates>
#
# Dependencies: root access
#               wl module
# 
# Version:      0.1
# By:           Julio Jimenez Delgado
# Date:         20-07-2021
# Change:       Initial development
# 
#

#----------------------------------[Declarations and definitions]----------------------------------

#Script info and arguments evaluation variables
declare script_name
declare version
declare description

script_name="js-fix-wl.sh"
version="v0.1"
description="Reload wl kernel module so that the kernel can start it again"

#Global operational variables
# NONE

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
	echo -e "${LIGHT_GREY} $script_name ${YELLOW}$version ${LIGHT_GREY}- $description${NC}\n"
	echo 
}

#Operational functions (if required)
#

#Main function
main()
{
  echo
  if [ "$(id -u)" != 0 ]; then
    echo -e "only root user\n"
  else
    rmmod wl
    rmmod cfg80211
    modprobe wl
  fi
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

