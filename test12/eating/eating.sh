#!/usr/local/bin/sh

cat $1 | egrep -e "price" | cut -d\" -f4 | sort | uniq


