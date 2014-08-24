package ObjectMethods;

use Exporter;

@ISA = qw(Exporter);
@EXPORT_OK = qw(addMethods);

our $pkgidx = 0;

sub addMethods($@) {
    no strict 'refs';

    my $obj = shift;

    ++$pkgidx;
    my $methodspkg = "ObjectMethods::Methods${pkgidx}";
    @{"${methodspkg}::ISA"} = ref $obj;
    bless $obj, $methodspkg;
    while (@_) {
        my ($fname,$func) = (shift,shift);
        *{"${methodspkg}::$fname"} = $func;
    }
}


1;


__END__


=head1 NAME

ObjectMethods - Add new methods to single objects without (explicitly) creating a class

=head1 SYNOPSIS

use ObjectMethods qw(addMethods);

my $obj = SomeClass->new(...);

...

addMethods($obj,
           objmeth1 => sub { print "objmeth1 called\n"; },
           objmeth2 => sub($$) {
               my $obj = shift;
               print "objmeth2 called on ",$obj->{name}, " with ",shift,"\n";
           });

$obj->objmeth1;
$obj->objmeth2(42);


=head1 COPYRIGHT

    Copyright (c) 2004, Olaf Klischat. All Rights Reserved.
    This module is free software. It may be used, redistributed
        and/or modified under the same terms as Perl itself.
