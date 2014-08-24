#!/usr/bin/perl

my $fifoName="theFifo";

while (1) {
    unless (-p $fifoName) {
	unlink $fifoName;
	# Returnwert von system() ist invers, deshalb && statt ||
	system("mkfifo",$fifoName) && die "couldn't mkfifo $fifoName: $!";
    }

    open(FIFO,"> $fifoName");
    print STDERR "writing to fifo $fifoName\n";
    print FIFO "blahblahblubb.\nHello World!\n";
    close(FIFO);
    sleep 2;
    # TODO: Das sleep 2 wird in man perlipc auch benutzt. 
    # Ohne das sleep komisches Verhalten auf Linux (ein cat auf die fifo
    # gibt ewig "blahblahblubb.\nHello World!\nblahblahblubb.\nHello World!\nbl..." aus)
    # Auf Solaris (fox.isst.fhg.de) geht es.
}
