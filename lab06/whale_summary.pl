#!/usr/bin/perl -w

$individuals = 0;
$pods = 0;
@whales_list;
$flag = 0;

sub name_convert {
    my $name = shift @_;
    # All whale names should be converted to lower case. 
    $name =~ tr/A-Z/a-z/;
    # All whale names should be converted from plural to singular
    $name =~ s/s$//;
    # Any extra white space should be ignored.
    $name =~ s/( )+/ /g;
    return $name;
}


sub species_count {
    $species_to_be_count = shift @_;
    # print $species_to_be_count;
    open F, "<", $ARGV[0];
    @lines = <F>;
    foreach $line (@lines) {
        $line = name_convert($line);
        $line =~ /^\S+\s+(\d+)\s+(.*)$/;
        my $number = $1;
        my $species = $2;
        if ($species eq $species_to_be_count){
            $individuals += $number;
            $pods += 1;
        }
    }
    close F;
    return $individuals, $pods;
}


# return @whales_list
sub get_whales_list {
    open F, "<", $ARGV[0];
    @lines = <F>;
    foreach $line (@lines) {
        $line = name_convert($line);
        $line =~ /^\S+\s+\d+\s+(.*)$/;
        $species = $1;
        foreach $whales (@whales_list) {
            if $species eq $whales {

            }
        }
    }
    close F;
}


print species_count("dwarf minke whale")
# print $ARGV[0], " observations: ",$pods, " pods, ",
#         $individuals, " individuals\n";