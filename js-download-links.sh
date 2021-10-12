#!/usr/bin/env bash

# 
# Title
#   js-download-links.sh
#
# Description
#   Downloading links from a text file using youtube-dl
#
# Contributor
#   Julio Jimenez Delgado (jouleSoft)
#
# GitHub
#   https://github.com/jouleSoft/bash-scripts.git
#
# License
#   The MIT License (MIT)
#   Copyright (c) 2020-2021 Julio Jiménez Delgado (jouleSoft)
#
# Template
#   https://github.com/jouleSoft/bash-scripts/templates/args.sh 
#
# Dependencies 
#   youtube-dl
#

#### [MODULES] ####

. $HOME/workspace/bash-scripts/modules/common.sh

#### [DECLARATIONS AND DEFINITIONS] ####

#Script info and arguments evaluation variables
declare script_name="js-download-links.sh"
declare version="v0.4"
declare description="Downloading links from a text file using youtube-dl"

#Dependencies array: used for checking the dependencies.
#Declared in 'common.sh' module.
deps_array=(
  "youtube-dl"
)

#Arguments arrays: used on the help screen when args_check() function evals '1'.
args_array=(
  "links_file"
  "output_dir"
)

args_definition_array=(
  "list of links for downloading"
  "output directory where files are going to be downloaded"
)

#Total arguments expected / introduced
args=${#args_array[@]}

#Global operational variables
# NONE

#### [FUNCTIONS] ####

#Operational functions (if required)
#

#Main function
main()
{
  declare lnk_file="$1"
  declare total_lines=$(wc -l "$lnk_file" | cut -d ' ' -f 1)
  declare count_lines=1
  declare error_code=0

  if [ ! -e "$2" ]; then
    #if output directory doesn't exists. Create it
    echo "$2 Directory doesn't exist. Creating..."
    mkdir -p "$2" && echo "Directory created successfuly"
  fi

  OUTPUT="$2"

  for l in $(cat $lnk_file) 
  do 
    echo -e "\n${YELLOW} Link $count_lines / $total_lines${NC}\n\n"

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

#### [EXECUTION] ####

#Printing the header
header "$script_name" "$version" "$description"

#Check if config file exists (when needed)
# config_file_check "<config_file>"

#Dependency evalutation
deps_check "${deps_array[@]}"

#Arguments number evaluation
args_check "$@"

#Main function execution
main "$@"

#### [FINALIZATION] ####

#Script header
unset script_name
unset version
unset description

#Argument evaluation
unset args
unset args_array
unset args_definition_array
unset args_check_result

#Dependency checker
unset deps_array

#Operational variables (if any)
#
