#!/usr/bin/perl -w

my @lines = <>;
chop @lines;

foreach my $line (@lines) {
    1 == grep { $_ eq $line } @lines or die "FEHLER: Zeile \"$line\" nicht genau ein mal gefunden!\n";
}

print "Test bestanden.\n";
