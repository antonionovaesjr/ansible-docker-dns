#!/bin/bash

#Usar variável de ambiente para passar usuário e senha (secret)

#SSH Server
#Variável USER_CUSTOM e PASSWD_CUSTOM deve ser informado no momento do boot do container

useradd $USER_CUSTOM
SSH_USERPASS="$PASSWD_CUSTOM"
echo -e "$SSH_USERPASS\n$SSH_USERPASS" | (passwd --stdin $USER_CUSTOM)


if [ ! -f /opt/primeiro_boot_nao_delete.txt ]; then

IPADDRESS=$(ip route|grep 'scope link'|awk '{print $9}')
CHAVE_RNDC=$(grep -i secret /etc/rndc.conf |grep -v '#'|awk '{print $2}'|cut -d\" -f2)

#Do ip do server que o RNDC conecta
sed -i "s/127.0.0.1/$IPADDRESS/g" /etc/rndc.conf

#Editando o named.conf

sed -i "s/127.0.0.1/$IPADDRESS/g" /etc/named.conf
sed -i "s/RNDC_CHAVE/$CHAVE_RNDC/g" /etc/named.conf
sed -i "s/exemplo.com.br/$DOMINIO/g" /etc/named.conf

#Editando o arquivo de domínio
cp -pav /var/named/named.exemplo /var/named/db.$DOMINIO
sed -i "s/127.0.0.1/$IPADDRESS/g" /var/named/db.$DOMINIO
sed -i "s/rname.invalid/root.$DOMINIO/g" /var/named/db.$DOMINIO

touch /opt/primeiro_boot_nao_delete.txt

fi



#Bind Server DNS
/bin/bash -c 'if [ ! "$DISABLE_ZONE_CHECKING" == "yes" ]; then /usr/sbin/named-checkconf -z "$NAMEDCONF"; else echo "Checking of zone files is disabled"; fi'

#Iniciando serviços SSH e BIND

/usr/sbin/sshd -D  &
/usr/sbin/named -u named -c /etc/named.conf -f
