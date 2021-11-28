#!/usr/bin/env bash

# 
# Title
#   js-configure-ubuntu.sh
#
# Description
#   Ubuntu configuration helper
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
#   NONE
#
# Configuration files needed
#   NONE
#

#### [MODULES] ####

#   NONE

#### [DECLARATIONS AND DEFINITIONS] ####

#Script info and arguments evaluation variables
declare script_name="js-configure-ubuntu.sh"
declare version="0.1"
declare description="Ubuntu configuration helper"

#Global operational variables
# NONE

#### [FUNCTIONS] ####

#Script header
header()
{
  # 
  # contributor:  Julio Jiménez Delgado (jouleSoft)
  # version:      0.1
  # updated:      08-10-2019
  # change:       Initial development
  #
  # dependencies
  #   - git
  # 
  # parameters
  #   - $1 - script_name
  #   - $2 - version
  #   - $3 - description
  #

  echo -e "\n${LIGHT_GREY} $1 ${YELLOW}$2 ${LIGHT_GREY}- $3${NC}\n"
}

# -.- Operational functions (if required) -.-

root_only()
{
  if [ $(id -u) -ne 0 ]; then
    echo -e "The script must be executed as superuser"; echo
    exit 1
  fi
}

apt_install()
{
  apt update

  apt install fish \
    emacs \
    python3-pynvim \
    fonts-powerline \
    curl \
    wget \
    neovim \
    gh \
    bat
}

starship_install()
{
  sh -c "$(curl -fsSL https://starship.rs/install.sh)"
}

exa_install()
{
  declare output_path="/tmp/exa-linux.zip"
  declare exa_url="https://github.com/ogham/exa/releases/download/v0.10.0/exa-linux-x86_64-v0.10.0.zip"
  declare unzip_dir="/tmp/exa"

  wget $exa_url -O $output_path
  unzip $output_path -d $unzip_dir
  cp $unzip_dir/bin/exa /usr/bin/
}

slimbook_repo()
{
  add-apt-repository ppa:slimbook/slimbook -y
}

githubCli_repo()
{
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
}

#Main function
main()
{
  echo
  root_only

  # Adding repos
  slimbook_repo
  githubCli_repo

  # Installing software
  apt_install
  starship_install
  exa_install
  echo
}

#### [EXECUTION] ####

#Printing the header
header "$script_name" "$version" "$description"

#Main function execution
main

#### [FINALIZATION] ####

#Unset common.sh module variables
common_unset

#Operational variables (if any)
#

