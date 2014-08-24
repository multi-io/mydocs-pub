#!/bin/sh

file="$1"; shift

nodejs dojo-release-1.9.2-src/dojo/dojo.js load="$file" "$@"
