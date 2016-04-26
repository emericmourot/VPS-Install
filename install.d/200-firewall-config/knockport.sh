#!/bin/bash
# from http://www.microhowto.info/howto/implement_port_knocking_using_iptables.html

IPT="/sbin/iptables"

KNOCKPORT=3102

iptables -N STATE0
iptables -A STATE0 -p udp --dport ${KNOCKPORT} -m recent --name KNOCK1 --set -j DROP
iptables -A STATE0 -j DROP



# Knockd config

# we should add the traffic that we don't want to handle with port knocking to the INPUT chain. We can start by accepting all current connections, which will allow our current SSH connection to remain unaffected
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
# We should also accept all connections from the local machine, since services often need to communicate with one another
iptables -A INPUT -i lo -j ACCEPT

# If you have services that should remain externally and publicly accessible, like a web server, add a rule to allow this type of connection using this format:
iptables -A INPUT -p tcp --dport 22 -j ACCEPT


# vi /etc/knockd.conf
[options]
        logfile = /var/log/knockd.log

[opencloseWEB]
        sequence      = 3102
        seq_timeout   = 15
        tcpflags      = syn,ack
        start_command = /usr/sbin/iptables -A INPUT -s %IP% -p tcp --syn --dport 80 -j ACCEPT
        cmd_timeout   = 86400
        stop_command  = /usr/sbin/iptables -D INPUT -s %IP% -p tcp --syn --dport 80 -j ACCEPT
