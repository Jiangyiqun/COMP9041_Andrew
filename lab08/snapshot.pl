#!/usr/bin/perl -w
use File::Copy;


sub save {
    # print "calling save subroutine\n";
    # get the right version number
    my $version = 0;
    $version++ while (-e ".snapshot.".$version);
    # create the snapshot directory
    print "Creating snapshot ", $version, "\n";
    mkdir(".snapshot.".$version) or die;
    # copy the file to the snapshot directory
    my @files = glob("*");
    foreach my $file (@files) {
        if ($file =~ /^[^\.].*/ && $file ne "snapshot.pl") {
            # print $file, "\n";
            copy($file, ".snapshot.".$version);
        }
    }
}


sub load {
    # get the right version number
    my $version = $_[0];
    # save snapshot first
    save();
    # print "calling load subrouting with parameter ", $version, "\n";
    # restore the files
    print "Restoring snapshot ", $version, "\n";
    my @files = glob("./.snapshot.".$version."/*");
    foreach my $file (@files) {
        copy($file, ".");
    }

}



if ($ARGV[0] eq "save") {
    save();
}
elsif ($ARGV[0] eq "load") {
    load($ARGV[1]);
} else {
    exit 0;
}