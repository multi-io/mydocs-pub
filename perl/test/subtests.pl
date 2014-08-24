#! /usr/bin/perl


sub testf {
    print "this ist testf.\n";

    sub testfinner {
        print "this ist testfinner\n";
    }

# syntax error..
#     my sub testmyf {
#         print "this ist testmyf\n";
#     }

}

testf();
testfinner();


# scheint wie in Python zu sein:
#
# "sub" sieht fuer C-Programmierer aus wie eine Funktionsdeklaration,
# es ist aber eine /Anweisung/, die das angegebene Codestueck unter dem
# angegebenen Namen in die aktuelle(?) Symboltabelle eintraegt.
#
# warum aber geht dann folgendes (sub-Anweisung duerfte beim lowerf()-Aufruf
# noch nicht ausgeführt worden sein -- so ist es auch in Python: siehe lowerftest.py)


lowerf();

sub lowerf {
    print "this ist lowerf.\n";
}


# andere tests...

# Skalare werden immer by-reference uebergeben:

sub doubleval {
    $_[0] *= 2;
}


$a=7;
doubleval $a;
print "$a\n";   # => 14



sub printargs {
    print join("\n",@_) . "\n\n";
}


printargs("ha","he","hi","hu");

# Listen als Argumente werden "geflatted". Sinn?

printargs("bla","blubb",("sub1","sub2",781),2891.9,(8,9,(9.1,9.2),10,11));


printargs(("CPU"=>"PII","MHz"=>333,"HDD"=>"IBM DHEA"));

# aha.. Hashes in List-Kontext erzeugen Liste mit (key1,value1,key2,value2,...):

%myhash = ("CPU"=>"i486","MHz"=>100,"HDD"=>"Quantum Bigfoot");
foreach (%myhash) {
    print "$_\n";
}



# will man keine "geflatteten" Listen, muss man sie als Referenzen oder "Typeglobs" uebergeben.
# Referenzen:

