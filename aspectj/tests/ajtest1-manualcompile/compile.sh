#!/bin/sh

set -e

cd "`dirname $0`"

#ajcp="`echo lib/aspectj/*jar | tr ' ' ':'`"
ajcp=lib/aspectj/aspectjrt.jar

cp="bin:$ajcp"

ajc -1.5 -classpath "$cp" -d bin -sourceroots src
