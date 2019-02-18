From antonionovaesjr/centos7-base:0.1
RUN yum -y install openssh-server passwd bind bind-utils vim iproute nc net-tools python-dns.noarch; yum clean all
RUN mkdir -p /var/run/sshd && ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' && rndc-confgen >> /etc/rndc.conf
ADD start-ssh-dns.sh /opt/start-ssh-dns.sh
ADD named.conf /etc/named.conf
ADD named.exemplo /var/named/named.exemplo
#ADD db.exemplo.com.br /var/named/db.exemplo.com.br
EXPOSE 22/tcp 53/udp 53/tcp
ENTRYPOINT [ "/opt/start-ssh-dns.sh" ]


#https://access.redhat.com/solutions/54644
#http://linux-n-linux.blogspot.com/2012/10/resolve-rndc-error-in-rhel6-centos6.html
