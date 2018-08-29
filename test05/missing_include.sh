#!/bin/sh
for origin_file in $@
do
    while read line
    do
        include_file=`echo "$line" | egrep "^#include \"" | cut -f2 -d'"'`
        if test -n "$include_file" && ! test -f "$include_file"; then
            echo "$include_file" included into "$origin_file" does not exist
        fi

    done < "$origin_file"
done
