#!/bin/bash

#Usar variável de ambiente para passar usuário e senha (secret)

#SSH Server
#Variável USER_CUSTOM e PASSWD_CUSTOM deve ser informado no momento do boot do container
useradd $USER_CUSTOM
SSH_USERPASS="$PASSWD_CUSTOM"
echo -e "$SSH_USERPASS\n$SSH_USERPASS" | (passwd --stdin USER_CUSTOM)

/usr/sbin/sshd -D &

#IPADDRESS=$(ip route|grep 'link src'|awk '{print $9}')
#sed "s/127.0.0.1/'$IPADDRESS'/g"  /etc/rndc.conf -i

CHAVE_RNDC=$(grep -i secret /etc/rndc.conf |grep -v '#'|awk '{print $2}'|cut -d\" -f2)

echo "Minha key_secret do RNDC é: $CHAVE_RNDC"

#Bind Server DNS
/bin/bash -c 'if [ ! "$DISABLE_ZONE_CHECKING" == "yes" ]; then /usr/sbin/named-checkconf -z "$NAMEDCONF"; else echo "Checking of zone files is disabled"; fi'
/usr/sbin/named -u named -c /etc/named.conf -f


#http://jon.netdork.net/2008/08/21/bind-dynamic-zones-and-updates/
#https://www.centos.org/forums/viewtopic.php?t=46291
#http://www.zytrax.com/books/dns/ch7/xfer.html#allow-update
