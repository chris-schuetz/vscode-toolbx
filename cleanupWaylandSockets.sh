#!/bin/bash

opt_short="ha"
opt_long="help,all"

usage() {
  cat <<EOF
Usage: $(basename "${BASH_SOURCE[0]}") [-h] [-a]

Tries to delete the file(s) /tmp/user/1000/vscode-wayland-*.sock from all
running podman containers. The .sock gets left behind by VS Code.

Available options:

-h, --help      Print this help and exit
-a, --all       Also tries to delete the *.sock from stopped containers
                (by starting and stopping them)
EOF
  exit
}

OPTS=$(getopt -o "$opt_short" -l "$opt_long" -- "$@")
ALL=0

eval set -- "$OPTS"

while true
do
    case "$1" in
        -h|--help) usage ;;
        -a|--all) ALL=1; shift;;
        --) # End of input reading
            shift; break ;;
    esac
done

COMMAND="podman ps -q"
if [ $ALL -eq 1 ]
then
    COMMAND="$COMMAND -a"
fi
for containerId in $($COMMAND)
do
    STARTED=0
    if [ $(podman inspect $containerId -f '{{.State.Running}}') = "false" ]
    then
        podman start $containerId
        STARTED=1
    fi
    podman exec -it $containerId bash -c 'rm -f /tmp/user/1000/vscode-wayland-*.sock'
    if [ $STARTED -eq 1 ]
    then
        podman stop $containerId
        STARTED=0
    fi
    echo 'Removed socket for '$containerId
done
