#!/usr/bin/env bash

set -e

yum list installed  firewalld   >/dev/null 2>&1  ||   yum     install -y  firewalld

which systemctl > /dev/null 2>&1 && {
    [ "$(systemctl is-active iptables.service)" = "active" ] && systemctl   stop   iptables.service
    [ "$(systemctl is-enabled iptables.service)" = "enabled" ] && systemctl   disable   iptables.service
    [ "$(systemctl is-active ip6tables.service)" = "active" ] && systemctl   stop   ip6tables.service
    [ "$(systemctl is-enabled ip6tables.service)" = "enabled" ] && systemctl   disable   ip6tables.service
}

exit    0
