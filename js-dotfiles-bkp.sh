#!/usr/bin/env bash

# 
# Title:        js-dotfiles-bkp.sh
# Description:  Create dotfiles backup
# Contributors: Julio Jimenez Delgado
#
# GitHub repo:  https://github.com/jouleSoft/bash-scripts
#
# License:      The MIT License (MIT)
#               Copyright (c) 2021 Julio Jiménez Delgado (jouleSoft)
#
# Template:     noargs.sh <https://github.com/jouleSoft/bash-scripts/templates/>
#
# Dependencies
#   - git
#   - coreutils
#

#### [MODULES] ####

. /home/jjimenez/workspace/bash-scripts/modules/dotfiles.sh
. /home/jjimenez/workspace/bash-scripts/modules/general.sh
. /home/jjimenez/workspace/bash-scripts/modules/git.sh

#### [DECLARATIONS AND DEFINITIONS] ####

#Script info and arguments evaluation variables
declare script_name
declare version
declare description

script_name="js-dotfiles-bkp.sh"
version="v.1.0"
description="Create dotfiles backup at GitHub"

#Global operational variables
#dotfiles from '~/' directory
declare -a dotFiles=(
".bashrc"
".vim/vimrc"
)

#dotfiles from '~/.config' directory
declare -a dotConfig=(
".config/alacritty/alacritty.yml"
".config/alacritty/dracula.yml"
".config/alacritty/template.yml"
".config/conky/conky.conf"
".config/dunst/dunstrc"
".config/fish/config.fish"
".config/fish/fish_variables"
".config/gtk-3.0/gtk.css"
".config/i3status-rust/config.toml"
".config/i3status/config"
".config/i3/config"
".config/i3/dmApplications.sh"
".config/i3/dmConfig.sh"
".config/i3/dmDocs.sh"
".config/i3/dmScripts.sh"
".config/i3/dmUrl.sh"
".config/i3/dunstify-volume.sh"
".config/i3/pctl-playPause.sh"
".config/i3/umenu-term-apps.sh"
".config/kitty/diff.conf"
".config/kitty/dracula.conf"
".config/kitty/kitty.conf"
".config/nvim/init.vim"
".config/picom.conf"
".config/polybar/config"
".config/polybar/launch.sh"
".config/polybar/spotify_status.py"
".config/qtile/config.py"
".config/qtile/autostart.sh"
".config/ranger/commands.py"
".config/ranger/commands_full.py"
".config/ranger/rc.conf"
".config/ranger/rifle.conf"
".config/ranger/scope.sh"
".config/starship.toml"
)

#dotfiles from '~/.doom.d' directory
declare -a dotDoom=(
".doom.d/init.el"
".doom.d/config.el"
".doom.d/custom.el"
".doom.d/packages.el"
)

#### [FUNCTIONS] ####

#Operational functions (if required)
# NONE

#Main function
main()
{
  #Color variables
  declare NC
  NC='\033[0m'

  declare LIGHT_GREEN
  LIGHT_GREEN='\033[1;32m'
  
  declare YELLOW
  YELLOW='\033[1;33m'

  declare RED
  RED='\033[0;31m'

  #Repo path
  declare repo
  repo="$HOME/workspace/dotfiles"

  echo " Backup to: [$HOME/workspace/dotfiles]"
  echo " -------------------------------------------"
  for d in ${dotFiles[@]}; do
    dotFilesCopy $d
  done

  for d in ${dotConfig[@]}; do
    dotFilesCopy $d
  done

  for d in ${dotDoom[@]}; do
    dotFilesCopy $d
  done
  echo " -------------------------------------------"
  echo
  dotFilesCopy_legend
  echo

  gitCheck_and_commit "$repo"

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
unset dotFiles
unset dotConfig
