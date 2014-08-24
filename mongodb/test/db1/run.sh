#!/bin/sh

set -e

cd "`dirname $0`"
wd="`pwd`"

exec /usr/bin/mongod --unixSocketPrefix="$wd/run" --config "$wd/mongodb.conf" run
