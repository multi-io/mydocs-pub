#!/usr/bin/env python3

import socket
from time import sleep

def main():
    msg = b'Who is JellyfinServer?'

    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM, socket.IPPROTO_UDP)  # UDP
    sock.setsockopt(socket.SOL_SOCKET, socket.SO_BROADCAST, 1)
    sock.bind(('0.0.0.0',0))
    sock.sendto(msg, ("255.255.255.255", 7359))
    recvd = sock.recv(4096)
    sock.close()
    print(recvd.decode('utf-8'))

main()

