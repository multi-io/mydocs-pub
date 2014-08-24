#!/usr/bin/perl -w


my @subs;

for my $i (1..10) {
    push @subs, sub { print "value: $i\n"; };
}


foreach my $sub (@subs) {
    $sub->();
}
