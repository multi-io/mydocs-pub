#!/bin/sh

set -e

cd "`dirname $0`"

. ./env.sh

mkdir -p "data"

"$ES_HOME/bin/elasticsearch" -Des.path.conf="./config" -Des.path.data="data" -f

# "$ES_HOME/bin/elasticsearch" -Des.node.name="$node" -Des.path.conf="./config" -Des.path.data="$node/data" -Des.path.work="$node/work" -Des.path.logs="$node/logs" -f
