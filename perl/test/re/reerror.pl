#!/usr/bin/perl -w

@arr = split (/n( *n)+?/,'nnan         nnnbnbnnnnnnc');

foreach (@arr) { print ">>$_<<\n"; }

__END__

Ausgabe:

>><<
>>n<<
>>a<<
>>n<<
>>bnb<<
>>n<<
>>c<<


sollte IMHO:

>><<
>>a<<
>>bnb<<
>>c<<

(bei "/nn+/" als RE klappt das auch so)
