#!/usr/bin/perl

$queuesize=100;
$grain=10;

# localhost for a baseline
@hosts=('localhost', 'www.perl.com', 'www.yahoo.com');

$path="/tmp/fifo_ping";
unless (-p $path) {
    unlink $fifoName;
    # Returnwert von system() ist invers, deshalb && statt ||
    system("mkfifo",$path) && die "couldn't mkfifo $path: $!";
}


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

if (! @children) {
        undef %hosts;
        undef $win;
        use Net::Ping;
        $p=new Net::Ping('icmp', 1, 128);

        open(FIFO, ">>$path") || die;
        select(FIFO); $|=1;
        while(1) {
                if ($p->ping($host, 1)) {
                        print FIFO "$host 1 blubb\n";
                } else {
                        print FIFO "$host 0 blubb\n";
                }
                sleep 1;
        }
        close(FIFO);
} else {
        open(FIFO, "$path") || die;
        while(<FIFO>) {
                ($host, $ok)=split(/\s+/, $_);
                push(@{$results{$host}}, $ok);
                if (@{$results{$host}} > $queuesize) {
                        shift(@{$results{$host}});
                }
                disp_results(%results);
        }
        close(FIFO);
}

sub disp_results {
        my(%res)=@_;

        foreach(sort keys %res) {
                my $i=0;
                for(@{$res{$_}}) { $i++ if $_ };
                print "hulahula $_: $i\n";
        }
        print "\n";
}

