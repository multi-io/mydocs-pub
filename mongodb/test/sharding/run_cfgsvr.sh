#!/bin/sh

set -e

exec /usr/bin/mongod --configsvr --dbpath "`pwd`/config" --port 20000
