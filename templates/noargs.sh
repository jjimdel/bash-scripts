#!/usr/bin/env bash

# 
# Title:        <SCRIPT_NAME>
# Description:  <SHORT_DESCRIPTION>
# Contributors: Julio Jimenez Delgado
#
# GitHub repo:	https://github.com/jouleSoft/bash-scripts
#
# License:      The MIT License (MIT)
#               Copyright (c) <YEAR> Julio Jiménez Delgado (jouleSoft)
#
# Template:     noargs.sh <https://github.com/jouleSoft/bash-scripts/templates/>
#
# Dependencies: <dependency1>
#               <dependency2>
# 

#### [MODULES] ####

. /home/jjimenez/workspace/bash-scripts/modules/general.sh

#### [DECLARATIONS AND DEFINITIONS] ####

#Script info and arguments evaluation variables
declare script_name
declare version
declare description

script_name=""
version="v0.1"
description=""

#Global operational variables
# NONE

#### [FUNCTIONS] ####

#Operational functions (if required)
# NONE

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

#Main function execution
main


#### [FINALIZATION] ####

#Script header
unset script_name
unset version
unset description

#Operational variables (if any)
#

