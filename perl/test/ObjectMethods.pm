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
