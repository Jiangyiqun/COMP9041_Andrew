#!/usr/bin/perl -w

$middle = int((scalar @ARGV) / 2);
# print $middle;
@sorted_list = sort{$a <=> $b} @ARGV;
print $sorted_list[$middle], "\n";