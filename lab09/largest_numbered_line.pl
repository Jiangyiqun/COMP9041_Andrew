#!/usr/bin/perl -w

$largest_number = 0;
@largest_number_line = ();

sub get_largest_number {
    my $line = $_[0];
    my @matchs  = ($line =~ /(-?\d+\.?\d*)/g);
    my $largest_number = $matchs[0];
    foreach my $number (@matchs) {
        if ($number > $largest_number) {
            $largest_number = $number;
        }
    }
    # print "on line: ",$line;
    # print "number = ", $largest_number, "\n";
    return $largest_number;
}

while (<STDIN>) {
    if (/-?\d+\.?\d*/) {
        my $number = get_largest_number($_);
        if ($number > $largest_number) {
            $largest_number = $number;
            @largest_number_line = ();
            push @largest_number_line, $_;
        } elsif ($number == $largest_number) {
            push @largest_number_line, $_;
        } else {    # $number < $largest_number
            ;
        }
    }

    
}

# print $largest_number, "\n";
print @largest_number_line;