#!/usr/bin/env bash

set -e

yum list installed  iptables   >/dev/null  ||   yum     install -y  iptables

which systemctl > /dev/null && {
    yum list installed  iptables-services   >/dev/null  ||   yum     install -y  iptables-services
    [ "$(systemctl is-active firewalld.service)" = "active" ] && systemctl   stop   firewalld.service
    [ "$(systemctl is-enabled firewalld.service)" = "enabled" ] && systemctl   disable   firewalld.service
}

which systemctl > /dev/null || {
    chkconfig   firewalld   off
    service     firewalld   stop
}

exit    0
