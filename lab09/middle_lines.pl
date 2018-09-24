#!/usr/bin/perl -w

@file = <>;
# print (scalar(@file));
#even
if (scalar(@file) == 0) {
    ;
} elsif (scalar(@file) % 2 == 0) {
    print $file[scalar(@file) / 2 - 1];
    print $file[scalar(@file) / 2];
} else {    # odd
    print $file[(scalar(@file) - 1) / 2];
}
