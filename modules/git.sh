#!/usr/bin/env bash

#### [DECLARATIONS AND DEFINITIONS] ####
# None

#### [FUNCTIONS] ####

gitCommit()
{
  # 
  # contributor:  Julio Jiménez Delgado (jouleSoft)
  # version:      0.3
  # updated:      13-09-2021
  # change:       text formated
  #
  # dependencies
  #   - git
  # 

  read -rp "Do you want to stage all files and commit (Y/n): " confirm
  echo

  [ "$confirm" == "" ] && confirm="y"

  if [ "$confirm" == "y" ] || [ "$confirm" == "Y" ]; then

    # if git add returns with 0, then if git commit returns 0
    if git add . && git commit -m "authomatic backup $(date +%F' '%H:%m)" > /dev/null; then
    echo -e "${LIGHT_GREEN}  [   OK   ]${NC} commit"

    # if git push returns 0
    if git push -q > /dev/null; then
    echo -e "${LIGHT_GREEN}  [   OK   ]${NC} push"
    else
      echo -e "${RED}  [   KO   ]${NC} push"
    fi

    else
      if [ "$?" -eq 1 ]; then
      echo "  [   --   ] commit"
      echo "  [   --   ] push"
      else
        echo -e "${RED}  [   KO   ]${NC} commit"
        echo "  [   --   ] push"
      fi
    fi
  fi
}

git_SomethingToStage()
{
  #
  # contributor:  Julio Jiménez Delgado (jouleSoft)
  # version:      0.2
  # updated:      17-09-2021
  # change:       output formated
  #
  # dependencies
  #   - git
  #

  if [ $(git status --short | wc -c) != 0 ]; then
    echo -e "${LIGHT_GREEN}GIT status of [$(pwd)]${NC}"
    echo " ---"
    # check git status
    git status --short
    echo " ---"

    echo

    # (todo) Ask user if commit and push

    gitCommit
  else
    echo -e "${LIGHT_GREEN} _All dotFiles up to date${NC}"
  fi
}

gitCheck_and_commit()
{
  #
  # contributor:  Julio Jiménez Delgado (jouleSoft)
  # version:      0.3
  # updated:      13-09-2021
  # change:       text formated
  #
  # parameters
  #   - $1 : repository url
  #

  # if repository exists
  if [ -e "$1" ]; then
    declare gitRepo
    gitRepo="$1"
  else
    return 1
  fi

  # current dir location
  declare currentDir
  currentDir="$(pwd)"

  # change to the repo directory
  if cd "$gitRepo"; then
    git_SomethingToStage
  else
    echo "$gitRepo doesn't exist or it can't be openned"
  fi

  # change to the stored current directory before exit
  cd "$currentDir" || echo "$currentDir doesn't exsit"
}

dotFilesCopy()
{
  # 
  # contributor:  Julio Jiménez Delgado (jouleSoft)
  # version:      0.3
  # updated:      01-10-2021
  # change:       first copy to repo problem solved
  #
  # dependencies: coreutils [dirname]
  # 

  declare output
  declare repo_subdir

  if [ ! -e "$repo/$1" ]; then
    #if there is no files yet in the repo, create the first copy of them.

    #create de repo subdir if not exists
    repo_subdir="$repo/$1"

    if [ ! -e $(dirname "$repo_subdir") ]; then
      mkdir -p $(dirname "$repo_subdir")
    fi

    #make the first copy
    cp -rf "$HOME/$1" "$repo/$1" && output="${YELLOW}[   CP   ]${NC} $1"

  elif [ ! -e "$HOME/$1" ]; then
    #if there is no files in the homedir, copy is not needed.
    output="${NC}[   NN   ] $1"

  elif diff -q "$HOME/$1" "$repo/$1" > /dev/null; then
    #if there is no differences between the dotFile from source and the repo,
    #the file or directory won't be copied
    output="${LIGHT_GREEN}[   OK   ]${NC} $1"

  else
    cp -rf "$HOME/$1" "$repo/$1" && output="${YELLOW}[   CP   ]${NC} $1"
  fi

  echo -e "  $output"
}

dotFilesCopy_legend()
{
  # 
  # contributor:  Julio Jiménez Delgado (jouleSoft)
  # version:      0.2
  # updated:      18-09-2021
  # change:       Output formated
  #
  # dependencies: coreutils
  # 

  echo -e "${CYAN} Legend:${NC}\n"
  echo -e "  ${LIGHT_GREEN}[   OK   ]${NC}: The dotFile is in its last version"
  echo -e "  ${YELLOW}[   CP   ]${NC}: The dotFile has been copied"
  echo -e "  ${NC}[   NN   ]: Not Needed. The dotFile is not currently in the system"
}

