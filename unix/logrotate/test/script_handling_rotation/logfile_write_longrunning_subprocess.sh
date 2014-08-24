#!/bin/sh

cd "`dirname $0`"

set -e

trap 'kill 0' EXIT
trap 'true' HUP

while true; do
    # (while true; do echo hello; sleep 1; done) | prepend-time >>logfile2.txt 2>&1 &
    log-transferrate eth0 | prepend-time >>logfile2.txt 2>&1 &
    wait "$!" || true
    echo kill "$!"
    kill "$!"
done

# not perfect -- the kill $! actually kills only the prepend-time and
# may cause "broken pipe" messages on stderr. But functionality-wise
# everything works.