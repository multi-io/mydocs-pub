#!/bin/sh

set -e

mongos --configdb localhost:20000 --chunkSize 2
