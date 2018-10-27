#!/usr/bin/perl -w


$total = 0;

while (<>) {
    if (m|("price": "\$)(\d+.\d+)|) {
        $total += $2;
    }
    # print;
    # print "$2\n";
}

printf("\$%.2f\n", $total);