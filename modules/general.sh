#!/usr/bin/env bash

#Script header
header()
{
  # -.- [PARAMETERS DESCRIPTION] -.-
  # $1 - script_name
  # $2 - version
  # $3 - description

  #Init color variables
  declare NC='\033[0m'
  declare LIGHT_GREY='\033[0;37m'
  declare YELLOW='\033[1;33m'

  echo
  echo -e "${LIGHT_GREY} $1 ${YELLOW}$2 ${LIGHT_GREY}- $3${NC}\n"
  echo
}
