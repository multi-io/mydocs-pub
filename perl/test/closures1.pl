#!/usr/bin/perl -w

package C;

sub new($$) {
    my ($class, $param) = @_;
    bless {param=>$param}, $class;
}


sub getparam($) {
    my ($self) = @_;
    $self->{param};
}


sub setparam($$) {
    my ($self,$val) = @_;
    $self->{param} = $val;
}



package main;

my $var=42;

my $printvar = sub { print "var=$var\n"; };



$printvar->();

++$var;

$printvar->();

$var=23;

$printvar->();



my $c=C->new(5);

my $printc = sub { print "c->param=",$c->getparam,"\n"; };

$printc->();

$c->setparam(5 + $c->getparam);

$printc->();


$c=C->new(27);

$printc->();
