$TTL 3H
@       IN SOA  @ root.exemplo.com.br. (
                                        1       ; serial
                                        1D      ; refresh
                                        1H      ; retry
                                        1W      ; expire
                                        3H )    ; minimum
                NS      @
                A       127.0.0.1
                AAAA    ::1

web01          A       10.2.3.4
db01          A       10.2.3.5
app01         A       10.2.3.6