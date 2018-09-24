#!/usr/bin/perl -w

foreach (<>) {
    # translate Interpreter
    s|#!/bin/bash|#!/usr/bin/perl -w|;

    # translate expression
    if (/(^.*?)\(\((.*?)\)\)/) {
        $prefix = $1;
        $expression = $2;
        $expression =~ s|([a-zA-Z]+)|\$$1|g;
        $_ = $prefix."(".$expression.")"."\n";
    }

    # translate varible assignment statement
    s|(^\s*)(\w+=.*$)|$1\$$2;|;
    
    # translate block boundary bracket
    s|do$|{|;
    s|done$|}|;
    s|then$|{|;
    s|fi$|}|;
    s|else$|} else {|;
    # translate arithmetic expression (remove $ and strip bracket)
    s|(.*=)\$\((.*)\)|$1$2|;
    
    # translate echo statement to print statement
    if (/echo /) {
        s|(.*)|$1\\n";|;              # add \n in the end        
        s|([^\$]*?)(\$\w+)|$1", $2|g;   # handle str before var
        s|(\$\w+)([^\$]*?)|$1, "$2|g;   # handle str after var
        s|echo (.*)|print "$1|;
    };
    print;
}