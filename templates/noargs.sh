#!/usr/bin/env bash

# 
# Title
#   <script_name>
#
# Description
#   <short_description>
#
# Contributor
#   Julio Jimenez Delgado (jouleSoft)
#
# GitHub
#   https://github.com/jouleSoft/bash-scripts.git
#
# License
#   The MIT License (MIT)
#   Copyright (c) 2021 Julio Jiménez Delgado (jouleSoft)
#
# Template
#   https://github.com/jouleSoft/bash-scripts/templates/noargs.sh 
#
# Dependencies 
#   <dependency | None>
#

#### [MODULES] ####

. /home/jjimenez/workspace/bash-scripts/modules/common.sh

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

