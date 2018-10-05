#!/usr/bin/perl -w
use File::Compare;


$dir1 = shift @ARGV;
$dir2 = shift @ARGV;

foreach $path1 (sort (glob $dir1."/*")) {
    $name = $path1;
    $name =~ s/^$dir1\///;
    $path2 = $dir2."/".$name;
    print "$name\n" if (compare($path1, $path2) == 0);
}