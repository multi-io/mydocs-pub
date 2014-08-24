#!/usr/bin/perl -w

@hosts=('localhost', 'www.perl.com', 'www.yahoo.com');


foreach (@hosts) {
        if ($pid=fork) {
                push(@children, $pid);
                $host="";
        } else {
                @children=();
                $host=$_;
                last;
        }
}

print "hi, my children are @children, my host is $host.\n\n";
