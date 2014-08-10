#!/bin/sh

# doesn't need a postrotate activity

cd "`dirname $0`"

set -e

while true; do
    date >>logfile.txt;
    sleep 1;
done
