#!/usr/bin/perl -w

# print $ARGV[0], $ARGV[1];

open F, $ARGV[1];

$counter = 1;
foreach $line (<F>) {
    print $line if $counter == $ARGV[0];
    # print $counter;
    $counter++;
}

close F;