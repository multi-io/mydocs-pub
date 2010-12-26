Situation: I have unfs3 running on a small nfs server (machine named
tick), which exports its /home to a machine named tack:

[root@tick ~]# cat /etc/exports
/home        tack(rw,no_subtree_check,root_squash)
/usr/local/src/mldonkey/incoming    tack(rw,root_squash)
#/var/tmp/xmule-files    tack(rw,root_squash)
[root@tick ~]# 

unfsd is run on tick (IP 192.168.142.1) like this:


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
