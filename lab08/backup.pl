#!/usr/bin/perl -w

use File::Copy;

$version = 0;
$version++ while (-e ".".$ARGV[0].".".$version);
copy($ARGV[0], ".".$ARGV[0].".".$version) or die;
print("Backup of \'$ARGV[0]\' saved as \'.$ARGV[0].$version\'\n")