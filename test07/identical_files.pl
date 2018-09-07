#!/usr/bin/perl -w

if (@ARGV == 0) {
    print "Usage: ", $0, " <files>\n";
    exit 0;
} elsif (@ARGV == 1) {
    print "All files are identical\n";
} else {
    open F, "<", $ARGV[0] or die;
    @base = <F>;
    close F;
    foreach my $i (1...scalar(@ARGV)-1) {
        $file = $ARGV[$i]; 
        # print $file, "\n";
        open F, "<", $file or die "could not open $file";
        @current = <F>;
        if (scalar(@base) != scalar(@current)) {
            print $file, " is not identical\n";
            exit 0;
        }
        foreach my $i (0...scalar(@base)-1) {
            if ($base[$i] ne $current[$i]) {
                print $file, " is not identical\n";
                exit 0;
            }
        }
        close F;
    }
    print "All files are identical\n";
}

