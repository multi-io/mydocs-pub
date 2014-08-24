#!/usr/bin/perl -w



sub varprinter($) {
    my ($var) = @_;
    sub {
        print "var=$var\n";
    }
}


my $var = 42;
my $pr = varprinter($var);

$pr->();

++$var;

$pr->();

$var = 25;

$pr->();



my $var2 = [52];
$pr = varprinter($var2);

$pr->();

++$var2->[0];

$pr->();

$var2=[27];

$pr->();
