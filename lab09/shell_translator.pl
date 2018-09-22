#!/usr/bin/perl -w

foreach (<>) {
    # translate Interpreter
    s|#!/bin/bash|#!/usr/bin/perl -w|;
    # translate expression
    s|(^\s*)(\w+=.*$)|$1\$$2;|; # add $ to var name on LHS
    s|\(\((.*?)([a-z]+)(.*?)\)\)|(($1\$$2$3))|g; # add $ to var name on RHS
    # s|\(\((.*?)\)\)|($1)|;  # strip one bracket from expression
    # # translate block boundary bracket
    # s|do$|{|;
    # s|done$|}|;
    # s|then$|{|;
    # s|fi$|}|;
    # # fix arithmetic expression (remove $ and strip bracket)
    # s|(.*=)\$\((.*)\)|$1$2|;
    # # translate echo statement
    # if (/echo /) {
    #     s|(.*)|$1\\n";|;              # add \n in the end        
    #     s|([^\$]*?)(\$\w+)|$1", $2|g;   # handle str before var
    #     s|(\$\w+)([^\$]*?)|$1, "$2|g;   # handle str after var
    #     s|echo (.*)|print "$1|;
    # };
    print;
}