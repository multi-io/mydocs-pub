#!/usr/bin/perl

use IPC::SysV qw(IPC_PRIVATE IPC_RMID IPC_CREAT S_IRWXU);

my $qid = msgget(IPC_PRIVATE, IPC_CREAT | S_IRWXU);

if (!defined($qid)) {
    die "msgget failed: $!\n";
}

if (fork() == 0) {
    my $rcvd;
    print "child: sleeping...\n";
    sleep 1;
    print "child: receiving...\n";
    if (msgrcv($qid, $rcvd, 60, 0, 0)) {
	($type_rcvd, $rcvd) = unpack("l a*", $rcvd);
	print "child: received: $rcvd\n";
	exit 0;
    } else {
	die "child: msgrcv failed\n";
    }
}

print "parent: sleeping...\n";
sleep 3;

print "parent: sending\n";
if (!msgsnd($qid, pack("l a*", 1234, "blahblubb!"), 0)) {
    die "msgsend failed.\n";
}
