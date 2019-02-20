From antonionovaesjr/centos7-base:0.1
RUN yum -y install openssh-server passwd bind bind-utils vim iproute nc net-tools python-dns.noarch; yum clean all
RUN mkdir -p /var/run/sshd && ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key -N '' && rndc-confgen >> /etc/rndc.conf && rm -rf /var/named/*
ADD var-conf /opt/var-conf
ADD start-ssh-dns.sh /opt/start-ssh-dns.sh
VOLUME /var/named
EXPOSE 22/tcp 53/udp 53/tcp
ENTRYPOINT [ "/opt/start-ssh-dns.sh" ]


