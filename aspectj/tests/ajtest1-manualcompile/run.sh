#!/bin/sh

set -e

cd "`dirname $0`"

#ajcp="`echo lib/aspectj/*jar | tr ' ' ':'`"
ajcp=lib/aspectj/aspectjrt.jar

cp="bin:$ajcp"

java -cp "$cp" de/oklischat/ajtest1/Main
