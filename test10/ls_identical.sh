#!/usr/local/bin/sh

# echo $1
# echo $2

for path1 in $1/*
do
    name=`echo "$path1" | sed "s/^$1\///"`
    path2="$2""/""$name"
    # echo $path1
    # echo $path2
    # diff "$path1" "$path2"
    if `diff "$path1" "$path2" > /dev/null 2>&1`
    then
        echo "$name"
    fi
done