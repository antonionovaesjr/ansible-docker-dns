#!/bin/bash

#Usar variável de ambiente para passar usuário e senha (secret)

#SSH Server
useradd ansible
SSH_USERPASS="olamundo"
echo -e "$SSH_USERPASS\n$SSH_USERPASS" | (passwd --stdin ansible)

/usr/sbin/sshd -D &

IPADDRESS=$(ip route|grep 'link src'|awk '{print $9}')
sed "s/127.0.0.1/'$IPADDRESS'/g"  /etc/rndc.conf -i

#Bind Server DNS
/bin/bash -c 'if [ ! "$DISABLE_ZONE_CHECKING" == "yes" ]; then /usr/sbin/named-checkconf -z "$NAMEDCONF"; else echo "Checking of zone files is disabled"; fi'
/usr/sbin/named -u named -c /etc/named.conf


#http://jon.netdork.net/2008/08/21/bind-dynamic-zones-and-updates/
#https://www.centos.org/forums/viewtopic.php?t=46291
#http://www.zytrax.com/books/dns/ch7/xfer.html#allow-update
