From centos
RUN yum -y update; yum -y install openssh-server passwd bind bind-utils vim iproute nc net-tools python-dns.noarch; yum clean all
RUN mkdir -p /var/run/sshd && ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' && rndc-confgen >> /etc/rndc.conf
EXPOSE 22/tcp 53/udp
ADD start-ssh-dns.sh /opt/start-ssh-dns.sh
ADD named.conf /etc/named.conf
EXPOSE 22/tcp 53/udp
ENTRYPOINT [ "/opt/start-ssh-dns.sh" ]

/

https://access.redhat.com/solutions/54644
http://linux-n-linux.blogspot.com/2012/10/resolve-rndc-error-in-rhel6-centos6.html
