#!/usr/bin/perl -w

# generate %dict and %total from "lyrics/*.txt"
foreach my $file (glob "lyrics/*.txt") {
    my $artist = $file;
    $artist =~ s/^lyrics\///;
    $artist =~ s/\.txt$//;
    $artist =~ s/[^a-zA-Z]/ /g;
    # print "$file\n";
    # print "$artist\n";
    open F, "<", $file or die;
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


# rad files from arguments
foreach my $file (@ARGV) {
    # print "$file\n";
    open F, "<", $file or die;
    foreach my $line (<F>) {
        chomp $line;
        # generate %log_probability
        foreach my $word ($line =~ /[a-zA-Z]+/g) {
            $word = lc($word);
            # print $word, "\n";
            foreach my $artist (sort keys %total) {
                if (exists $dict{$artist}{$word}) {
                    $log_probability{$file}{$artist} += log(
                            ($dict{$artist}{$word} + 1) / $total{$artist}
                            );
                } else {
                    $log_probability{$file}{$artist} += log(1/$total{$artist});
                }
            }
        }
    }
    close F;
    my @the_artist = sort {$log_probability{$file}{$a} <=>
            $log_probability{$file}{$b}}
             keys %{$log_probability{$file}};
    printf "%s most resembles the work of %s (log-probability=%4.1f)\n",
          $file, $the_artist[-1],
          $log_probability{$file}{$the_artist[-1]}
}