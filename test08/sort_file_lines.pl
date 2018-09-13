#!/usr/bin/perl -w

# read from file
open(F, "<", $ARGV[0]) or die;
@input = <F>;
close F;

# sort lines
@output = sort @input;
@output = sort {length($a) <=> length($b)} @output;

# print file
# open(F, ">", $ARGV[0]) or die;
foreach $line (@output) {
    print $line;
}
# close F;