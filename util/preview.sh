#!/usr/bin/env bash
BASE_DIR=$(dirname $0)

# -p/--port option to specify the port on which the documentation shall be served (default 8000)
# -H/--host option to specify the host on which the documentation shall be served (default 127.0.0.1)
# -i/--ignore multiple allowed, option to specify file ignore glob expression when watching changes, for example: *.tmp
# -B/--open-browser automatically open a web browser with the URL for this document
# --no-initial disable initial build
# -s/--delay delay in seconds before opening browser if --open-browser was selected (default 5)
# -z/--watch multiple allowed, option to specify additional directories to watch, for example: some/extra/dir
# --poll force polling, useful for Vagrant or VirtualBox which do not trigger file updates in shared folders

cd ${BASE_DIR}
rm -rf "_build/*"
sphinx-autobuild . _build -B \
    -p 50005 \
    -i "*.md" \
    -s 300


