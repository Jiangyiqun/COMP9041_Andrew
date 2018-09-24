#!/usr/bin/perl -w

foreach $line (@ARGV) {
    print $line." " if ($line =~ /[aeiou]{3}/i);
}
print "\n";