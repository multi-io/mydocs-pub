#!/bin/sh

cd "`dirname $0`"

set -e

exec >>logfile.txt 2>&1

while true; do
  date;
  sleep 1;
done
