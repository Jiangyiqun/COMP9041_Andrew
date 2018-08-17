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
    echo "$pic_name"
    display "$pic_name"
done

read -p "Address to e-mail this image to? " user_email
read -p "Message to accompany image? " user_message

#echo $user_email
#echo $user_message
#echo $*

echo "$user_message" | mutt -s "$user_message" -e 'set copy=no' -a $* -- "$user_email"

exit 0
