#!/usr/bin/env bash

gitCommit()
{

  read -rp "Do you want to stage all files and commit (Y/n): " confirm
  echo

  [ "$confirm" == "" ] && confirm="y"

  if [ "$confirm" == "y" ] || [ "$confirm" == "Y" ]; then

    # if git add returns with 0, then if git commit returns 0
    if git add . && git commit -m "backup" > /dev/null; then
    echo -e "${LIGHT_GREEN}[   OK   ]${NC} commit"

    # if git push returns 0
    if git push -q > /dev/null; then
    echo -e "${LIGHT_GREEN}[   OK   ]${NC} push"
    else
      echo -e "${RED}[   KO   ]${NC} push"
    fi

    else
      if [ "$?" -eq 1 ]; then
      echo "[   --   ] commit"
      echo "[   --   ] push"
      else
        echo -e "${RED}[   KO   ]${NC} commit"
        echo "[   --   ] push"
      fi
    fi
  fi
}

gitCheck_and_commit()
{
  # -.- [PARAMETERS] -.-
  # $1 - repository path

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
    echo -e "${LIGHT_GREEN}GIT status of [$(pwd)]${NC}"
    echo "---"
    # check git status
    git status --short
    echo "---"

    echo

    # (todo) Ask user if commit and push

    gitCommit

  else
    echo "$gitRepo doesn't exist or it can't be openned"
  fi

  # change to the stored current directory before exit
  cd "$currentDir" || echo "$currentDir doesn't exsit"
}
