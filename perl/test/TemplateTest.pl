#!/usr/bin/perl -w

BEGIN { @INC = (".", @INC); }

use Template;


# my $rs = Template->new("rundschreiben.templ", do{open(F,">out.txt"); *F});
my $rs = Template->new("rundschreiben.templ");

my $out = "foo";
# my $rs = Template->new("rundschreiben.templ", \$out);

our @people =
( {name=>'Meier', sex=>'m', debt=>4000},
  {name=>'Schubert', sex=>'f', debt=>2500},
  {name=>'Hubertus', sex=>'m', debt=>3000}
);

$rs->run();


# print "output: >>>>${out}<<<<\n";
