#!/usr/bin/perl -w

sub read_pre {
    open F, "wget -q -O- $url|" or die;
    while ($line = <F>) {
        if ($line =~ /(Prerequisite[^<]*<\/p>)/) {
            $sentense = $1;
            # print $sentense;
            while ( $sentense =~ /([A-Z]{4}\d{4})/g ) {
                # print $1, "\n";
                $pre_course{$1} = 1;
            }
        } 
    }
    close F;
}


$url = "http://www.handbook.unsw.edu.au/postgraduate"
       . "/courses/2018/$ARGV[0].html";
read_pre();
$url = "http://www.handbook.unsw.edu.au/undergraduate"
       . "/courses/2018/$ARGV[0].html";
open F, "wget -q -O- $url|" or die;
read_pre();

foreach $course (sort keys %pre_course) {
    print $course, "\n";
}