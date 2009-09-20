#!/usr/bin/perl -w

use strict;


my @arr1 = ( 8,9,10,"huhu","huifgd");
my @arr2 = ( "blah","blubb","brabbel","stammel");

my $i=8;
print "$i\n";
$i = @arr1;   # "@arr" in Skalar-Kontext ergibt Laenge des Arrays
print "$i\n";

print "@arr2\n";
@arr2 = $i;   # "$skal" in Array-Kontext ergibt Array mit dem Skalar als einziges Element
print "@arr2\n$#arr2\n";
