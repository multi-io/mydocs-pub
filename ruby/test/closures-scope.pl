$n=10;

$p=sub{0};

foreach my $x (0..$n) {
    my $pprev = $p;
    $p = sub{ $x + $pprev->() };
}



print $p->();
