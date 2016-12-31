#!/usr/bin/env bash

if [ "${2}" = "" ] ;then
    host=${EASY_OP_SSH_HOST}
    client=${1}
else
    host=${1}
    client=${2}
fi

if [ -d secret/${host}/openvpn/${client} ] ;then
    rm  -rf secret/${host}/openvpn/${client}
fi
mkdir   -p  secret/${host}/openvpn/${client}
pushd   secret/${host}/openvpn/keys/    > /dev/null
cp  ../client.conf  ../${client}/${host}.ovpn
cp  ca.crt ta.key ${client}.crt ${client}.csr ${client}.key   ../${client}/
popd    > /dev/null
