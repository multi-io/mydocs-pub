print "l1\n";

BEGIN {
    print "begin1\n";
}

$mw = MainWindow->new(;
print "l2\n";


BEGIN {
    print "begin2\n";
}
