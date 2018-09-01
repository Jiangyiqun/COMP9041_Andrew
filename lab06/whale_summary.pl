#!/usr/bin/perl -w

# %pods;
# %individuals;

sub name_convert {
    my $name = shift @_;
    # All whale names should be converted to lower case. 
    $name =~ tr/A-Z/a-z/;
    # All whale names should be converted from plural to singular
    $name =~ s/s$//;
    # Any extra white space should be ignored.
    $name =~ s/( )+/ /g;    # white space in the middle
    $name =~ s/^( )+//;     # leading white space
    $name =~ s/( )+$//;     # trailing white space
    return $name;
}


# format: blue whale observations: 51 pods, 1171 individuals
open F, "<", $ARGV[0];
@lines = <F>;
foreach $line (@lines) {
    $line = name_convert($line);
    $line =~ /^\S+\s+(\d+)\s+(.*)$/;
    $number = $1;
    $species = $2;
    if (exists $pods{$species}){
        $pods{$species} += 1;
        $individuals{$species} += $number;
    } else {
        $pods{$species} = 1;
        $individuals{$species} = $number;
    }
}
close F;


foreach $name (sort keys %pods) {
    print $name, " observations: ",
            $pods{$name}, " pods, ",
            $individuals{$name}, " individuals\n"
}