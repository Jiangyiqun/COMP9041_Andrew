#!/usr/bin/perl -w

$individuals = 0;
$pods = 0;

open F, "<", $ARGV[1];
while (<F>) {
    /^\S+\s+(\d+)\s+(.*)$/;
    my $number = $1;
    my $species = $2;
    if ($2 eq $ARGV[0]){
        $individuals += $number;
        $pods += 1;
    }
}
close F;

print $ARGV[0], " observations: ",$pods, " pods, ",
        $individuals, " individuals\n";