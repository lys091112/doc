#!/usr/bin/env bash
BASE_DIR=$(dirname $0)

cd ${BASE_DIR}
rm -rf "_build/*"
sphinx-autobuild . _build -B -p 8004 -s 1
