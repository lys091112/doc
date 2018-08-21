#!/usr/bin/env bash

command -v pip3 >/dev/null 2>&1 || { echo >&2 "Require pip3 but it is not installed. Aborting."; exit 1; }
command -v python3 >/dev/null 2>&1 || { echo >&2 "Require python3 but it is not installed. Aborting."; exit 1; }

echo -e "Update python packages"

sudo pip3 freeze --local | grep -v "^\-e" | cut -d = -f 1  | xargs -n1 pip3 install -U

echo -e "Install sphinx and required packages"

sudo pip3 install -r requirements.txt
sudo pip3 install sphinx sphinx-autobuild

echo -e "\n\033[41;37mIt is ready to write your docs, execute preview.sh to get start\033[0m"
