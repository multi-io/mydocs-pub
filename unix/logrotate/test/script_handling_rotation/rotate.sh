#!/bin/sh

cd "`dirname $0`"
/usr/sbin/logrotate -vv --force --state logrotate_status logrotate.conf

