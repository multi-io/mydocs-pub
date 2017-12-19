docker run -v $(OVPN_TMPVOL):/etc/openvpn --rm kylemanna/openvpn ovpn_genconfig -u udp://$(PUBLIC_HOSTNAME) -r $(LAN_SUBNET).0/24 -n $(LAN_DNS_SERVER) -p 'dhcp-option DOMAIN $(LAN_DNS_SUFFIX)'

=>

$ docker exec -ti devhost_vpn_1 cat /etc/openvpn/openvpn.conf
server 192.168.255.0 255.255.255.0
verb 3
key /etc/openvpn/pki/private/olafklischat.mooo.com.key
ca /etc/openvpn/pki/ca.crt
cert /etc/openvpn/pki/issued/olafklischat.mooo.com.crt
dh /etc/openvpn/pki/dh.pem
tls-auth /etc/openvpn/pki/ta.key
key-direction 0
keepalive 10 60
persist-key
persist-tun

proto udp
# Rely on Docker to do port mapping, internally always 1194
port 1194
dev tun0
status /tmp/openvpn-status.log

user nobody
group nogroup

### Route Configurations Below
route 192.168.142.0 255.255.255.0

### Push Configurations Below
push "block-outside-dns"
push "dhcp-option DNS 192.168.142.1"
push "dhcp-option DOMAIN olaflocal"
$ 

