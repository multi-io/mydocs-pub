#!/usr/bin/perl -w

BEGIN { @INC = (".", @INC); }

use Template;


my $rs = Template->new("rundschreiben.templ");

our @people =
( {name=>'Meier', sex=>'m', debt=>4000},
  {name=>'Schubert', sex=>'f', debt=>2500},
  {name=>'Hubertus', sex=>'m', debt=>3000}
);

$rs->run();
