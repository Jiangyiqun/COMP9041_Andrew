#!/usr/bin/perl -w

$target_speice = shift @ARGV;
$whales_list = shift @ARGV;
$count = 0;
$how_many = 0;

open "fh", "<$whales_list";
foreach $line (<fh>) {
    if ($line =~ m/how_many/){
        $line =~ s/[^\d]*//g;
        $how_many = $line;
        # print $how_many;
    }
    if ($line =~ m/$target_speice/) {
        $count += $how_many;
    }
}
close "fh";

print $count, "\n";
