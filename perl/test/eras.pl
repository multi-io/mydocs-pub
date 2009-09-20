#!/usr/bin/perl -w

$highest = $ARGV[0] || 100;

for $i (2 .. sqrt($highest)) {
    next if ($seve[$i]);

    $j = 2;
    while(($idx = $i * $j++) <= $highest) {
        $seve[$idx] = 1;
    }
}

print join("", map{"$_ " if !defined($seve[$_])} 2..$highest) . "\n";
