#!/bin/bash
/usr/bin/php-fpm7 -F &
pids="$pids $!"

/usr/sbin/nginx &
pids="$pids $!"

trap "kill -TERM $pids" SIGTERM
wait