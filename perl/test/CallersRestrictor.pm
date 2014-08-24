package CallersRestrictor;

use Exporter;

@ISA = qw(Exporter);
@EXPORT = qw(restrictCallers);


sub restrictCallers {
    no strict 'refs';
    my $srcpkg = caller();
    while (@_) {
        my ($fname,$callers) = (shift,shift);
        my $origfn = \&{"${srcpkg}::$fname"};
        *{"${srcpkg}::$fname"} = sub {
            my $caller = caller();
            unless (grep /$caller/, @$callers) {
                print "$caller not allowed to call ${srcpkg}::$fname\n"; return;
            }
            $origfn->(@_);
        }
    }
}

1;
