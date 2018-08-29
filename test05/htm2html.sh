#!/bin/sh
for f in *.htm
do
    if test -e "$f"l; then
        echo  "$f"l exists
        exit 1
    fi
    mv "$f" "$f"l
done