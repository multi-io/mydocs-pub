Situation: I have unfs3 running on a small nfs server (machine named
tick (IP: 192.168.142.1)), which exports its /home to a machine named
tack (IP: 192.168.142.2):

[root@tick ~]# cat /etc/exports
/home        tack(rw,no_subtree_check,root_squash)
/usr/local/src/mldonkey/incoming    tack(rw,root_squash)
#/var/tmp/xmule-files    tack(rw,root_squash)
[root@tick ~]# 

unfsd is run on tick like this:


olaf      1033  0.0  1.0   6912  5208 ?        Ss   06:10   0:01 /usr/sbin/unfsd -i /home/olaf/unfsd.pid -u -n 2049 -m 2049 -l 192.168.142.1 -s -p


On tack, this is mounted on /tickhome:

tick:/home on /tickhome type nfs (rw,udp,port=2049,mountport=2049,nfsvers=3,mountvers=3,addr=192.168.142.1)


I'm experiencing the problem that a "ls /tickhome/olaf" on tack hangs indefinetely.


When I strace the unfsd process, I can see that it receives NFS
readdir calls every few seconds, and it also (apparently) answers them
correctly with an NFS response packet.

However, when I sniff the connection using tcpdump or wireshark, it
looks like the response packets aren't valid UDP packets (at least
wireshark doesn't recognize them as such) (see screenshot in
wireshark.png). The hexdump area of the packet looks like it does
contain the correct file names of the directory to be listed, though
(I'm not a NFS protocol expert).

This leads me to believe that the ls call (or rather, the NFS client
in the kernel that's invoked by it) doesn't recognize/receive
the NFS response packets and thus hangs. The root of the problem would
be the fact that unfsd doesn't send valid UDP packets in this case.



UPDATE:

The problem was that I issued a "ip link set eth0 mtu 1400" call on
tack a few days earlier, reducing the MTU of the interface from 1500
to 1400 and thus, apparently, causing the IP stack of tick (which
recognized the changed MTU on tack?) to FRAGMENT the UDP packets sent
out by unfsd. This lead to the "incomplete" IP datagrams seen in
wireshark and thus to the problem of the NFS client on tack no longer
recognizing the fragments as UDP packets.

"ip link set eth0 mtu 1500" dealt with the problem.

I'm not sure whether the fact that unfs can't handle the smaller MTU
is to be considered a bug in unfs.

See
e.g. http://lists.apple.com/archives/darwin-development/2004/May/msg00069.html
(this is OSX though) -- according to that, the userspace would have to
find out the MTU and do the fragmentation itself -- so it is a unfs
bug?

It I understand this correctly, the sender must include an IP (and
UDP?) header in every IP fragment (not: packet) it sends. An IP
fragment is a part of an IP packet that fits into a layer 2 PDU. The
IP header contains a field "fragment offset" that specifies where in
the packet the fragment is located. Shouldn't the IP stack do all
this, even for UDP?


UPDATE2:

Looking at the strace again, it seems unfsd sent UDP packets with a
length of 4100 bytes. This would mean that UDP fragmentation should
occur even at MTU=1500. So maybe the IP stack on tick, not unfsd, is
the culprit after all? (for not finding out that tack's MTU was
smaller than 1500 -- so maybe path MTU discovery didn't work, possibly
because of some firewalling issue?)


working-ls.pcap contains the dump of a successful "ls
/tickhome/olaf/utils/" (after the MTU was changed to 1500)



UPDATE3:

Problem can be reproduced with netcat:

tack:~# ip link set eth0 mtu 1400
tack:~# nc -l -u -p 6543
(hangs, doesn't output anything)

[root@tick /etc/init.d]# ls -l ~/dead.letter 
-rw------- 1 root root 7941 2006-04-22 21:01 /root/dead.letter
[root@tick /etc/init.d]# cat ~/dead.letter | nc -u tack 6543
(hangs)

(only a fragment of the data is sent -- see
dead.letter.udptransfer-mtu1500-to-1400.pcap)

(with mtu 1500 on tack it works as expected)


on tick (Sender):

socket(PF_INET, SOCK_DGRAM, IPPROTO_UDP) = 3
setsockopt(3, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
rt_sigaction(SIGALRM, {SIG_IGN}, {SIG_DFL}, 8) = 0
alarm(0)                                = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
connect(3, {sa_family=AF_INET, sin_port=htons(6543), sin_addr=inet_addr("192.168.142.2")}, 16) = 0
rt_sigaction(SIGALRM, {SIG_IGN}, {SIG_IGN}, 8) = 0
alarm(0)                                = 0
select(16, [0 3], NULL, NULL, NULL)     = 1 (in [0])
read(0, "To: root\nSubject: Debconf: Confi"..., 8192) = 7941
write(3, "To: root\nSubject: Debconf: Confi"..., 7941) = 7941     //Sending
select(16, [0 3], NULL, NULL, NULL)     = 1 (in [0])
read(0, "", 8192)                       = 0
close(0)                                = 0
select(16, [3], NULL, NULL, NULL


on tack (receiver):

socket(PF_INET, SOCK_DGRAM, IPPROTO_UDP) = 3
setsockopt(3, SOL_SOCKET, SO_REUSEADDR, [1], 4) = 0
bind(3, {sa_family=AF_INET, sin_port=htons(6543), sin_addr=inet_addr("0.0.0.0")}, 16) = 0
rt_sigaction(SIGALRM, {SIG_IGN, [ALRM], SA_RESTORER|SA_RESTART, 0x7f0336d2d1f0}, {SIG_DFL, [], 0}, 8) = 0
alarm(0)                                = 0
rt_sigprocmask(SIG_BLOCK, NULL, [], 8)  = 0
recvfrom(3, 

//(receives nothing (local IP stack didn't deliver the received
//fragment because it's incomplete))
