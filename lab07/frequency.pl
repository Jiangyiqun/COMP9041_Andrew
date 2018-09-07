#!/usr/bin/perl -w

foreach my $file (glob "lyrics/*.txt") {

    my $artist = $file;
    $artist =~ s/^lyrics\///;
    $artist =~ s/\.txt$//;
    $artist =~ s/[^a-zA-Z]/ /g;
    # print "$file\n";
    # print "$artist\n";
    open F, "<", $file or die;
    $dict{$artist}{lc($ARGV[0])} = 0;
    foreach my $line (<F>) {
        chomp $line;
        foreach my $word ($line =~ /[a-zA-Z]+/g) {
            $word = lc($word);
            $dict{$artist}{$word}++;
            $total{$artist}++;
        }
    }
    close F;
}

$keyword = lc($ARGV[0]);
foreach my $artist (sort keys %total) {
    printf "%4d/%6d = %.9f %s\n", 
            $dict{$artist}{$keyword},
            $total{$artist},
            $dict{$artist}{$keyword} / $total{$artist},
            $artist
}