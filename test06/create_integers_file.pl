#!/usr/bin/perl -w

# print $ARGV[0], $ARGV[1], $ARGV[2],;

open F, ">>$ARGV[2]";
foreach $i ($ARGV[0]..$ARGV[1]) {
    print F $i, "\n";
}
close F;