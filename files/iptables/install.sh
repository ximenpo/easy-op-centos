#!/usr/bin/env bash

set -e

yum list installed  iptables   >/dev/null 2>&1  ||   yum     install -y  iptables

command -v systemctl > /dev/null 2>&1 && {
    yum list installed  iptables-services   >/dev/null 2>&1  ||   yum     install -y  iptables-services
    [ "$(systemctl is-active firewalld.service)" = "active" ] && systemctl   stop   firewalld.service
    [ "$(systemctl is-enabled firewalld.service)" = "enabled" ] && systemctl   disable   firewalld.service
}

command -v systemctl > /dev/null 2>&1 || {
    chkconfig   firewalld   off
    service     firewalld   stop
}

exit    0
