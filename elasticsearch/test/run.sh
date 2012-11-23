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

"$ES_HOME/bin/elasticsearch" -Des.node.name="$node" -Des.path.conf="./config" -Des.path.data="$node/data" -Des.path.work="$node/work" -Des.path.logs="$node/logs" -f
