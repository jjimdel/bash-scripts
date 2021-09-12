#!/usr/bin/env bash
# ---
# Title:        js-dotfiles-bkp.sh
# Description:  Create dotfiles backup
# Contributors: Julio Jimenez Delgado
#
# GitHub repo:  https://github.com/jouleSoft/js-DevOps
#
# License:      The MIT License (MIT)
#               Copyright (c) 2021 Julio Jiménez Delgado (jouleSoft)
#
# Template:     template_noargs.sh <https://github.com/jouleSoft/js-DevOps/templates/>
#
# Dependencies: git
# 
# Version:      0.1
# By:           Julio Jimenez Delgado
# Date:         30/05/2021
# Change:       Initial development
#
# Version:      0.2
# By:           Julio Jimenez Delgado
# Date:         30/05/2021
# Change:       Check GIT status of all dotfile repos
#
# Version:      0.3
# By:           Julio Jimenez Delgado
# Date:         01/06/2021
# Change:       Redirect diff output to /dev/null
#
# Version:      0.4
# By:           Julio Jimenez Delgado
# Date:         12/06/2021
# Change:       Conky dotfile added
#
# Version:      0.5
# By:           Julio Jimenez Delgado
# Date:         09/07/2021
# Change:       Now 'dotfiles' repo will be the only repo for all the files
#
# Version:      0.6
# By:           Julio Jimenez Delgado
# Date:         04/08/2021
# Change:       Auto update commit and push
#
# Version:      0.7
# By:           Julio Jimenez Delgado
# Date:         24/08/2021
# Change:       Checks if there is configuration file before the diff operation
#
# Version:      0.8
# By:           Julio Jimenez Delgado
# Date:         -
# Change:       Added a legend
#               Copy file functions refactored
#

# -.- [MODULES] -.-

# Git functions
. /home/jjimenez/workspace/bash-scripts/modules/general.sh
. /home/jjimenez/workspace/bash-scripts/modules/git.sh

# -.- [DECLARATIONS AND DEFINITIONS] -.-

#Script info and arguments evaluation variables
declare script_name="js-dotfiles-bkp.sh"
declare version="v.0.7"
declare description="Create dotfiles backup"

#Global operational variables
#dotfiles from '~/' directory
declare -a dotFiles=(
".bashrc"
".vim/vimrc"
)

#dotfiles from '~/.config' directory
declare -a dotConfig=(
"alacritty/alacritty.yml"
"alacritty/dracula.yml"
"alacritty/template.yml"
"conky/conky.conf"
"dunst/dunstrc"
"fish/config.fish"
"fish/fish_variables"
"gtk-3.0/gtk.css"
"i3status-rust/config.toml"
"i3status/config"
"i3/config"
"i3/dmApplications.sh"
"i3/dmConfig.sh"
"i3/dmDocs.sh"
"i3/dmScripts.sh"
"i3/dmUrl.sh"
"i3/dunstify-volume.sh"
"i3/pctl-playPause.sh"
"i3/umenu-term-apps.sh"
"kitty/diff.conf"
"kitty/dracula.conf"
"kitty/kitty.conf"
"picom.conf"
"polybar/config"
"polybar/launch.sh"
"polybar/spotify_status.py"
"qtile/config.py"
"qtile/autostart.sh"
"ranger/commands.py"
"ranger/commands_full.py"
"ranger/rc.conf"
"ranger/rifle.conf"
"ranger/scope.sh"
"starship.toml"
)

#dotfiles from '~/.doom.d' directory
declare -a dotDoom=(
"init.el"
"config.el"
"custom.el"
"packages.el"
)

# -.- [FUNCTIONS] -.-

#Operational functions (if required)
copyDotfiles_fromHome()
{
  #Only dotfiles from '~/' directory

  declare output

  for d in "${dotFiles[@]}"; do
    if [ -e $HOME/$d ]; then

      if diff -q "$HOME/$d" "$repo/$d" > /dev/null; then
        #if there is no differences between the dotFile source and the repo,
        #the file or directory won't be copied

        output="${LIGHT_GREEN}[   OK   ]${NC} $d"
      else
        cp -f "$HOME/$d" "$repo/$d" && output="${YELLOW}[ copied ]${NC} $d"
      fi

    else
      output="${NC}[   NN   ] $d"
    fi

    echo -e "  $output"

  done
}

copyDotfiles_fromHomeDotConfig()
{
  #Dotfiles from '~/.config' directory

  declare output
  
  for c in "${dotConfig[@]}"; do

    if [ -e $HOME/.config/$c ]; then

      if diff -q "$HOME/.config/$c" "$repo/.config/$c" > /dev/null; then
        #if there is no differences between the dotConfig source and the repo,
        #the file or directory won't be copied

        output="${LIGHT_GREEN}[   OK   ]${NC} .config/$c"
      else
        cp -rf "$HOME/.config/$c" "$repo/.config/$c" && output="${YELLOW}[ copied ]${NC} .config/$c"
      fi

    else
      output="${NC}[   NN   ] .config/$c"
    fi

    echo -e "  $output"

  done
}

copyDotfiles_fromHomeDotDoom()
{
  #Dotfiles from '~/.doom.d' directory

  declare output

  for c in "${dotDoom[@]}"; do

    if [ ! -e "$repo/.doom.d/$c" ]; then
      #if there is no files yet in the repo, create the first copy of them.
      cp -rf "$HOME/.doom.d/$c" "$repo/.doom.d/$c" && output="${YELLOW}[ copied ]${NC} .doom.d/$c"

    elif diff -q "$HOME/.doom.d/$c" "$repo/.doom.d/$c" > /dev/null; then
      #if there is no differences between the dotDoom source and the repo,
      #the file or directory won't be copied
      output="${LIGHT_GREEN}[   OK   ]${NC} .doom.d/$c"

    else
      cp -rf "$HOME/.doom.d/$c" "$repo/.doom.d/$c" && output="${YELLOW}[ copied ]${NC} .doom.d/$c"
    fi

    echo -e "  $output"

  done
}

showLegend()
{
  echo -e "Legend:\n"
  echo -e "  ${LIGHT_GREEN}[   OK   ]${NC}: The files are in its last version"
  echo -e "  ${YELLOW}[ copied ]${NC}: The files has been copied"
  echo -e "  ${NC}[   NN   ]: Not Needed. The dotfile is not currently in the system"
}

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

  echo "Backup to: [$HOME/workspace/dotfiles]"
  echo "-------------------------------------------"
  copyDotfiles_fromHome
  copyDotfiles_fromHomeDotConfig
  copyDotfiles_fromHomeDotDoom
  echo "-------------------------------------------"
  echo
  showLegend
  echo

  gitCheck_and_commit "$repo"

  echo
}

# -.- [EXECUTION] -.-

#Printing the header
header "$script_name" "$version" "$description"

#Main function execution
main


#------------------------------------------[Finalization]------------------------------------------

#Script header
unset script_name
unset version
unset description

#Operational variables (if any)
unset dotFiles
unset dotConfig
