#!/usr/bin/perl -w

sub accum {
    my $curr = 0;
    sub {
        my $param = shift;
        $curr += $param;
    }
}


my $acc1 = accum();

print "a1 ",$acc1->(3),"\n";
print "a1 ",$acc1->(5),"\n";

my $acc2 = accum();

print "a2 ",$acc2->(1),"\n";

print "a1 ",$acc1->(2),"\n";


print "a2 ",$acc2->(7),"\n";

print "a1 ",$acc1->(10),"\n";

print "a2 ",$acc2->(4),"\n";
