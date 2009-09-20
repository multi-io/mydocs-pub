use bigint;

sub fac($) {
    my ($i,$res) = (shift,1);
    for (1..$i) { $res *= $_; }
    $res;
}



print fac(5), "\n";
