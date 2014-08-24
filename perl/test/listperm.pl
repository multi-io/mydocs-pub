#!/usr/bin/perl -w

use strict;


sub listPerms {
    my $size = 1 + $#_;
    if ($size <= 1) {
        return [@_];
    }
    else {
        my $firstEl = $_[0];
        my @subPermRefs = listPerms(@_[1 .. $size-1]);
        my @result = ();
        foreach my $subPermRef (@subPermRefs) {
            for (my $i=0; $i<$size; $i++) {
                push @result, [(@{$subPermRef}[0 .. $i-1], $firstEl, @{$subPermRef}[$i .. $size-2])];
            }
        }
        return @result;
    }
}


my @permRefs = listPerms(@ARGV);

foreach my $permRef (@permRefs) {
    print "@$permRef\n";
}
