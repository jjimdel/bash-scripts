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
# Configuration files needed
#   <file | None>
#

#### [MODULES] ####

. $HOME/workspace/bash-scripts/modules/common.sh

#### [DECLARATIONS AND DEFINITIONS] ####

#Script info and arguments evaluation variables
declare script_name=""
declare version=""
declare description=""

#Dependencies array: used for checking the dependencies.
#Declared in 'common.sh' module.
deps_array=(
  "git"
  "dirname"
)

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

#Check if config file exists (when needed)
# config_file_check "<config_file>"

#Dependecy evaluation
deps_check ${deps_array[@]}

#Main function execution
main

#### [FINALIZATION] ####

#Unset common.sh module variables
common_unset

#Operational variables (if any)
#

