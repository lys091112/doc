#!/usr/bin/env bash

command -v pip >/dev/null 2>&1 || { echo >&2 "Require pip but it is not installed. Aborting."; exit 1; }
command -v python >/dev/null 2>&1 || { echo >&2 "Require python but it is not installed. Aborting."; exit 1; }

echo -e "Update python packages"

pip freeze --local | grep -v "^\-e" | cut -d = -f 1  | xargs -n1 pip install -U

echo -e "Install sphinx and required packages"

pip install -r requirements.txt
pip install sphinx sphinx-autobuild

echo -e "\n\033[41;37mIt is ready to write your docs, execute preview.sh to get start\033[0m"
