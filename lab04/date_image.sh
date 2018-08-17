#!/bin/sh
for pic_name in $@
do
    if  ! test -e "$pic_name"
    then
        echo "$pic_name does not exists"
        exit 1
    fi
done

for pic_name in $@
do
    text_lable=`ls -l "$pic_name" | cut -d' ' -f6-8`
    #echo "$text_lable"
    temp_file=$(mktemp -t "$file.XXXXXX")
    #echo "$temp_file"
    convert -gravity south -pointsize 36 -draw "text 0,10 \"$text_lable\"" "$pic_name" "$temp_file"
    display "$temp_file"
done

exit 0
