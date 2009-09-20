#!/usr/bin/perl -w

use strict;

our %match_window_profile = ();

#%match_window_profile = (
#   [WM_CLASS, "Term"] => $VAR1={ignore-program-position=>1, foo=>42},
#   [WND_TITLE, "MyApp"] => $VAR1,
#   [WM_CLASS, "Lalala"] => {ignore-program-position=>0},
#   [WND_TITLE, "Netscape"] => {sticky=>1, cyclable=>0},
#);

$match_window_profile{WM_CLASS}{"Term"} = {ignore_program_position=>1, foo=>42};
$match_window_profile{WND_TITLE}{"MyApp"} = {ignore_program_position=>1, foo=>42};
$match_window_profile{WM_CLASS}{"Lalala"} = {ignore_program_position=>0};
$match_window_profile{WND_TITLE}{"Netscape"} = {sticky=>1, cyclable=>0};


sub add_window_matcher {
    my ($prop, $value, %actions) = @_;
    foreach my $k (keys %actions) {
        $match_window_profile{$prop}{$value}->{$k} = $actions{$k};
    };
}



use Data::Dumper;

print ">>BEFORE:\n";
print Dumper(%match_window_profile);

add_window_matcher('WND_TITLE', "Netscape", sticky=>5, olaf=>"klischat");


print "\n\n>>AFTER:\n";
print Dumper(%match_window_profile);



## doesn't work -- arrays as hash keys don't work...
