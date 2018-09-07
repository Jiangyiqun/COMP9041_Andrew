#!/usr/bin/perl -w

$dict{lc($ARGV[0])} = 0;
foreach (<STDIN>) {
    chomp;
    foreach $word (/[a-zA-Z]+/g) {
        $word = lc($word);
        $dict{$word}++;
        # $total++;
    }
}

print lc($ARGV[0]), " occurred ",
    $dict{lc($ARGV[0])}, " times\n";
# print $total;