#!/opt/GNU/bin/perl5.00502

use IPC::SysV qw(IPC_PRIVATE IPC_RMID IPC_CREAT S_IRWXU);

my $id = msgget(IPC_PRIVATE, IPC_CREAT | S_IRWXU);
my $sent = "message";
my $type_sent = 1234;
my $rcvd;
my $type_rcvd;
if (defined $id) {
    if (msgsnd($id, pack("l a*", $type_sent, $sent), 0)) {
	if (msgrcv($id, $rcvd, 60, 0, 0)) {
	    ($type_rcvd, $rcvd) = unpack("l a*", $rcvd);
	    if ($rcvd eq $sent) {
		print "okay\n";
	    } else {
		print "not okay\n";
	    }
	} else {
	    die "# msgrcv failed\n";
	}
    } else {
	die "# msgsnd failed\n";
    }
    msgctl($id, IPC_RMID, 0) || die "# msgctl failed: $!\n";
} else {
    die "# msgget failed\n";
}
