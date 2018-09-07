#!/usr/bin/perl -w

foreach (<>) {
    chomp;
    foreach (/[a-zA-Z]+/g) {
        $count++;
    }
}

print $count, " words\n";