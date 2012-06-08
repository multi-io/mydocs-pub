#!/bin/sh

set -e

exec /usr/bin/mongod --shardsvr --dbpath "`pwd`/db2" --port 10001
