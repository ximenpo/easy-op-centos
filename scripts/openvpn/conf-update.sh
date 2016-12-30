#!/usr/bin/env bash

if [ "${1}" = "" ] ;then
    host=${SIMPLE_OP_SSH_HOST}
else
    host=${1}
fi

easyrsa_dir=
for d in $(ssh ${host} find /usr/share/easy-rsa/ -mindepth 1 -maxdepth 1 -type d) ;do
    easyrsa_dir=$d
done
if [ "$easyrsa_dir" = "" ] ;then
    echo    ERROR: easy-rsa directory not found
else
    scp -rp secret/${host}/openvpn/vars    ${host}:$easyrsa_dir/
fi

scp -rp secret/${host}/openvpn/server.conf ${host}:/etc/openvpn/
ssh     ${host}    '
which systemctl > /dev/null                         \
    && systemctl restart "openvpn@server.service"   \
    || service openvpn restart                      \
'
