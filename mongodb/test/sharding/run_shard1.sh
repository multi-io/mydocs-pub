#!/bin/sh

set -e

exec /usr/bin/mongod --shardsvr --dbpath "`pwd`/db1" --port 10000
