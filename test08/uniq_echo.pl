#!/usr/bin/perl -w

sub is_uniq {
    my $token = $_[0];
    foreach $printed_token (our @printed_tokens) {
        return 0 if ($token eq $printed_token);
    }
    return 1;
}


foreach my $token (@ARGV) {
    if (is_uniq($token)) {
        print $token, " ";
        push (our @printed_tokens, $token);
    }
}
print "\n";