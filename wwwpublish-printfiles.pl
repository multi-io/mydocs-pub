#!/usr/bin/perl -w

use strict;

do "./wwwpublish";

sub printdir($$);

sub printdir($$) {
    my ($dir, $prefix) = @_;
    foreach my $d (@{$dir->{DIRS}}) {
        printdir($d, $prefix . "/" . $d->{NAME});
    }
    foreach my $f (@{$dir->{FILES}}) {
        print($prefix , "/" . $f, "\n");
    }
}

printdir($::root, ".");
