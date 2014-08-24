#!/usr/bin/perl -w

sub DoStupidPrint {
    my $bnValue = shift;
    eval qq[sub {
                if ($bnValue) {
                    print("Hallo Isch bin ein Berliner!\n");
                }
            }];
}


DoStupidPrint(0)->();
DoStupidPrint(1)->();

DoStupidPrint(someRuntimeValue())->();
