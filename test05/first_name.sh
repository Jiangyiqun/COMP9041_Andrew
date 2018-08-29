#!/bin/sh
egrep "COMP[29]041" $1 | cut -d'|' -f3 | cut -f2 -d',' | cut -f2 -d' ' | sort | uniq -c | sort -n | tail -1 | sed s/[^a-zA-Z]//g