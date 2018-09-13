#!/bin/sh

version=0
while test -e ".$1.$version"
do
    version=$((version+1))
done
cp "$1" ".$1.$version"
echo Backup of "'$1'" saved as "'.$1.$version'"