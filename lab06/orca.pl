#!/usr/bin/perl -w

$sum = 0;

foreach (<>) {
    /^\S+\s+(\d+)\s+(.*)$/;
    my $number = $1;
    my $species = $2;
    # print $2, "\n";
    $sum += $number if ($2 eq "Orca");
}

print $sum, " Orcas reported in ", $ARGV, "\n";