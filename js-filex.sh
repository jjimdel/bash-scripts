#!/usr/bin/env bash
# 
# Title
#   js-filex.sh
#
# Description
#   File analyzer
#
# Contributor
#   Julio Jimenez Delgado (jouleSoft)
#
# GitHub
#   https://github.com/jouleSoft/bash-scripts.git
#
# License
#   The MIT License (MIT)
#   Copyright (c) 2019-2021 Julio Jiménez Delgado (jouleSoft)
#
# Template
#   https://github.com/jouleSoft/bash-scripts/templates/args.sh 
#
# Dependencies 
#   None
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
# Version:      0.4
# Author:       Julio Jimenez Delgado
# Date:         06/10/2021
# Change:       Output formated
#

#### [MODULES] ####

. /home/jjimenez/workspace/bash-scripts/modules/common.sh

#### [DECLARATIONS AND DEFINITIONS] ####

#Script info
declare script_name="js-filex.sh"
declare version="v.0.4"
declare description="File analyzer"

#Number of arguments exptected
declare -a args=1 
declare -a args_in_array=("$@")

#Arguments arrays: used on the help screen when
#args_check() function evals '1'.
declare -a args_array=(
  "target"
)
declare -a args_definition_array=(
  "File or directory to analyze"
)

#Global operational variables
# NONE

#### [FUNCTIONS] ####

#Operational functions (if required)
owner()
{
  #Get owner information from file

  echo -e "   ${PURPLE}Uid:${NC}  $(stat $1 | grep 'Uid:'| cut -d ' ' -f6| tr -d '()')"
  echo -e "   ${PURPLE}Gid:${NC}  $(stat $1 | grep 'Uid:'| cut -d ' ' -f11| tr -d '()')"
  echo ""
}

user_priv() 
{
  #Check file user privileges over the file

  declare read_priv="";
  declare write_priv="";
  declare exec_priv="";

  case $(ls -l $1|cut -c2) in

    -) read_priv="No-read ";;
    r) read_priv="Read    ";;

  esac

  case $(ls -l $1|cut -c3) in

    -) write_priv="No-write ";;
    w) write_priv="Write    ";;

  esac

  case $(ls -l $1|cut -c4) in

    -) exec_priv="No-exec ";;
    x) exec_priv="Exec    ";;

  esac

  echo -e "   ${PURPLE}User:${NC}     $read_priv $write_priv $exec_priv"
}

group_priv()
{
  #Check file group privileges

  declare read_priv="";
  declare write_priv="";
  declare exec_priv="";

  case $(ls -l $1|cut -c5) in

    -) read_priv="No-read ";;
    r) read_priv="Read    ";;

  esac

  case $(ls -l $1|cut -c6) in

    -) write_priv="No-write ";;
    w) write_priv="Write    ";;

  esac

  case $(ls -l $1|cut -c7) in

    -) exec_priv="No-exec ";;
    x) exec_priv="Exec    ";;

  esac

  echo -e "   ${PURPLE}Group:${NC}    $read_priv $write_priv $exec_priv"
}

others_priv()
{
  #Check file other privileges

  declare read_priv="";
  declare write_priv="";
  declare exec_priv="";

  case $(ls -l $1|cut -c8) in

    -) read_priv="No-read ";;
    r) read_priv="Read    ";;

  esac

  case $(ls -l $1|cut -c9) in

    -) write_priv="No-write ";;
    w) write_priv="Write    ";;

  esac

  case $(ls -l $1|cut -c10) in

    -) exec_priv="No-exec ";;
    x) exec_priv="Exec    ";;

  esac

  echo -e "   ${PURPLE}Others:${NC}   $read_priv $write_priv $exec_priv"
}

disk_usage()
{
  #Get file disk usage

  echo -e "${PURPLE}   $(ls -lh $1 | cut -d ' ' -f5)"
}

md5_hash()
{
  #Get file md5 hashcode

  echo -e "${PURPLE}   $(md5sum $1 | cut -d ' ' -f1)${NC}"
}

#Main function
main()
{
  if [ -e "$1" ]; then
    echo -e "${LIGHT_GREEN} File type:${NC}"
    echo -e "${CYAN}  $(file $1 | cut -d ':' -f2)${NC}"
    echo ""

    if [ ! -d $1 ]; then
      echo -e "${LIGHT_GREEN} Ownership:${NC}"

      owner "$1"

      echo -e "${LIGHT_GREEN} Privileges:${NC}"

      user_priv "$1"
      group_priv "$1"
      others_priv "$1"

      echo ""

      echo -e "${LIGHT_GREEN} Disk usage:${NC}"
      echo "$(disk_usage "$1")B"

      echo ""

      echo -e "${LIGHT_GREEN} MD5 hashcode:${NC}"
      md5_hash "$1"

      echo ""
    fi

  else
    echo " $1: No such file or directory"
    echo ""
  fi
}

#### [EXECUTION] ####

#Printing the header
header "$script_name" "$version" "$description"

#Arguments number evaluation
args_check ${args_in_array[@]}

if [ $args_check_result -eq 0 ]; then
  main "$@"
fi

#### [FINALIZATION] ####

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
