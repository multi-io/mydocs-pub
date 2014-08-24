#!/usr/bin/perl

use Tk;

$queuesize=100;
$grain=10;

# localhost for a baseline
@hosts=('localhost', 'www.perl.com', 'www.yahoo.com');

$path="/tmp/fifo_ping";
if  ( system('mknod',  $path, 'p')
        && system('mkfifo', $path) )
   {
       die("mk{nod,fifo} $path failed") if (! $! =~ /exists/);
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
                        print FIFO "$host 1\n";
                        sleep 1;
                } else {
                        print FIFO "$host 0\n";
                }
        }
        close(FIFO);
} else {
        $win=new Tk::MainWindow();
        foreach(@hosts) {
                my $f=$win->Frame()->pack(-side => 'left');
                $f->Label(-text => $_)->pack();
                $hosts{$_}=$f->Scale(qw/-orient vertical -length 300 -from/, 
                        $queuesize, qw/-to 0 -tickinterval/, $grain);
                $hosts{$_}->pack();
        }
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
                $hosts{$_}->set( $i );
        }
        $win->update;
}

