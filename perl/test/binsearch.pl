#!/usr/bin/perl

sub binsrch_r($$$$$) {
    my ($arr,$value,$compfunc,$startidx,$stopidx) = @_;
    return $startidx if ($startidx==$stopidx);
    my $divide = int(($startidx+$stopidx)/2);
    if (1==$compfunc->($value,$arr->[$divide])) {
        return binsrch_r($arr,$value,$compfunc,$divide+1,$stopidx);
    } else {
        return binsrch_r($arr,$value,$compfunc,$startidx,$divide);
    }
}


sub binsrch($$$) {
    my ($arr,$value,$compfunc) = @_;
    binsrch_r($arr,$value,$compfunc,0,$#$arr);
}




my $arr = [4,7,8,10,13,14,16,20,25];

sub comp($$) {
    my ($a,$b) = @_;
    $a <=> $b;
}

print binsrch($arr,12,\&comp), "\n";
