#!/bin/sh
for jpg_name in *.jpg
do
    png_name=`echo $jpg_name | sed "s/\.jpg/\.png/"`
    #echo "$png_name"
    if test -e "$png_name"
    then
        echo "$png_name already exists"
        exit 1
    fi
    convert "$jpg_name" "$png_name"
    rm -f "$jpg_name"
done
exit 0
