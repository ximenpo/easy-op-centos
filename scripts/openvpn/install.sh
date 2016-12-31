#!/usr/bin/env bash

if [ "${1}" = "" ] ;then
    host=${EASY_OP_SSH_HOST}
else
    host=${1}
fi

bash    scripts/run-script.sh   ${host}   files/openvpn/install.sh
bash    scripts/openvpn/conf-update.sh  ${host}
bash    scripts/run-script.sh   ${host}   files/openvpn/install.sh
