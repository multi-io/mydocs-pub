#!/usr/bin/perl -w

use Thread;

my $t1 = new Thread \&threadf ( 3 ),
   $t2 = new Thread \&threadf ( 1 )

$t1->join;

sub threadf {
    print "thread anfang\n";
    sleep $_[0];
    print "thread ende\n";
}
