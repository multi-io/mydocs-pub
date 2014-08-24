#!/bin/sh

cd "`dirname $0`"

set -e

restart_required=''

trap restart_required='yes' HUP

while true; do
    exec >>logfile.txt 2>&1

    while [ -z "$restart_required" ]; do
        date;
        sleep 1;
    done

    #echo restart...
    restart_required='';
done
