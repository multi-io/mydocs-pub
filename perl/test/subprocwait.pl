my $pid = fork();

if ($pid==0) {
    exec "sleep 15"  or die "couldn't exec: $!";
}

eval {
    local $SIG{ALRM} = sub { die "alarm clock restart" };
    alarm 10;
    waitpid($pid,0);
    alarm 0;
};

if ($@ =~ /alarm clock restart/) {
    print "process stalled, killing it\n";
    kill 'SIGTERM', $pid;
}
