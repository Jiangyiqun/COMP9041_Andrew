#!/usr/bin/perl -w

@article = <>;

foreach (@article) {
    # print;
    @line = ();
    foreach my $word (/\S+/g) {
        chomp $word;
        push @line, $word;
    }
    foreach my $word (sort @line) {
        print $word, " ";
    }
    print "\n";
}