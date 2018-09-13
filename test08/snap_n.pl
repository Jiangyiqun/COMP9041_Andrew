#!/usr/bin/perl -w

while (<STDIN>) {
    $dict{$_}++;
    if ($dict{$_} == $ARGV[0]) {
        print "Snap: ", $_;
        exit 0;
    }
}



