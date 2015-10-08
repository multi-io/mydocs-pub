#!/usr/bin/perl -w

return 1 if caller;
    
print "x.pl main\n";

our $var = 42;

sub xfunc() {
    print "x.pl xfunc\n";
}

sub xfuncvar() {
    print "x.pl xfuncvar, var=$var\n";
}
