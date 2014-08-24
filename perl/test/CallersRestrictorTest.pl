#!/usr/bin/perl

use CallersRestrictor;

sub fn1 {
    print "fn1 called\n";
}

sub fn2 {
    print "fn2 called\n";
}


restrictCallers fn1 => ['pkg1','pkg3'],
                fn2 => ['pkg2'];




package pkg1;

main::fn1; main::fn2;

package pkg2;

main::fn1; main::fn2;

package pkg3;

main::fn1; main::fn2;
