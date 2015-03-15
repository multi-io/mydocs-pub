#!/usr/bin/perl -w

return 1 if caller;
    
print "x.pl main\n";


sub xfunc() {
    print "x.pl function\n";
}

