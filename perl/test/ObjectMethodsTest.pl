#!/usr/bin/perl -w

package C;

sub new {
    my $class = shift;
    my $objname = shift;
    bless { name=>$objname }, $class;
}


sub cmethod {
    print "cmethod called\n";
}




package main;

use ObjectMethods qw(addMethods);

my $obj = C->new("myobj");

$obj->cmethod;

print "obj is a: ",ref $obj, "\n";

addMethods($obj,
           objmeth1 => sub { print "objmeth1 called\n"; });

$obj->objmeth1;

print "obj is a: ",ref $obj, "\n";

addMethods($obj,
           objmeth2 => sub($$) {
               my $obj = shift;
               print "objmeth2 called on ",$obj->{name}, " with ",shift,"\n";
           });

$obj->objmeth1;
$obj->objmeth2(42);

print "obj is a: ",ref $obj, "\n";

print "the end\n";
