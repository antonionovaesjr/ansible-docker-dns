#!/bin/bash

#Usar variável de ambiente para passar usuário e senha (secret)..

#SSH Server
#Variável USER_CUSTOM e PASSWD_CUSTOM deve ser informado no momento do boot do container
useradd $USER_CUSTOM
SSH_USERPASS="$PASSWD_CUSTOM"
echo -e "$SSH_USERPASS\n$SSH_USERPASS" | (passwd --stdin $USER_CUSTOM)

/usr/sbin/sshd -D &

IPADDRESS=$( ip route|grep 'scope link'|awk '{print $9}')

#Editando o arquivo de domínio
mv /var/named/db.exemplo.com.br /var/named/db.$DOMINIO
sed -i "s/127.0.0.1/$IPADDRESS/g" /var/named/db.$DOMINIO
sed -i "s/exemplo.com.br/$DOMINIO/g" /var/named/db.$DOMINIO

#Pegando o RNDC-KEY

CHAVE_RNDC=$(grep -i secret /etc/rndc.conf |grep -v '#'|awk '{print $2}'|cut -d\" -f2)
echo "Minha key_secret do RNDC é: $CHAVE_RNDC"

#Editando o named.conf

sed -i "s/127.0.0.1/$IPADDRESS/g" /etc/named.conf
sed -i "s/127.0.0.1/$IPADDRESS/g" /etc/rndc.conf
sed -i "s/RNDC_CHAVE/$CHAVE_RNDC/g" /etc/named.conf
sed -i "s/exemplo.com.br/$DOMINIO/g" /etc/named.conf

#Bind Server DNS
/bin/bash -c 'if [ ! "$DISABLE_ZONE_CHECKING" == "yes" ]; then /usr/sbin/named-checkconf -z "$NAMEDCONF"; else echo "Checking of zone files is disabled"; fi'
/usr/sbin/named -u named -c /etc/named.conf -f

