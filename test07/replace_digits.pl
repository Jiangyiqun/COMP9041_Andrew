#!/usr/bin/perl -w

open F, "<", $ARGV[0] or die;
@file = <F>;
close F;




open F, ">", $ARGV[0] or die;
foreach my $line (@file) {
    $line =~ s/[0-9]/#/g;
    print F $line;
}
close F;