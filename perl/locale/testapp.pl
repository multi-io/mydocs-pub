#!/usr/bin/perl -w

our (%messages);

do "myapp_$ENV{LANG}.pl" or do "myapp_DEFAULT.pl" or die "no locale!";

print "lalala\n";

$wert = 42;
$richtig = 0;

die sprintf($messages{IDS_MASKE}, $wert) unless $richtig;
