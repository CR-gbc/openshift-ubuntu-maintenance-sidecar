#!/bin/bash
set -e

ID=`id -u`
sed -i 's/:12358:/:'"$ID"':/g' /etc/passwd

exec "$@"
