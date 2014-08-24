#!/usr/bin/perl -w

while (<>) {
    foreach my $var (/(\S+)/g) {
        print "$var\n";
    }
}
