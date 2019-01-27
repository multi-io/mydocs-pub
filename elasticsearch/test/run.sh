#!/bin/sh

set -e

cd "`dirname $0`"

node="$1"

#if [ -z "$node" -o ! -d "$node" ]; then
if [ -z "$node" ]; then
  echo "usage: $0 <node name>"
  exit 1
fi

. ./env.sh

mkdir -p "$node/data" "$node/work" "$node/logs"

export ES_PATH_CONF="${PWD}/config"

"$ES_HOME/bin/elasticsearch" -Enode.name="$node" -Epath.data="${PWD}/$node/data" -Epath.logs="${PWD}/$node/logs"
