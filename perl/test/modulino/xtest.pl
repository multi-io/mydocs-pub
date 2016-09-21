#!/usr/bin/perl -w

require './x.pl';

print "xtest.pl main\n";

X::xfunc();

$X::var = 23;
X::xfuncvar();
    
