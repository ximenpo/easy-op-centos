#!/usr/bin/env bash

if [ "${2}" = "" ] ;then
    host=${SIMPLE_OP_SSH_HOST}
    client=${1}
else
    host=${1}
    client=${2}
fi

easyrsa_dir=
for d in $(ssh ${host} find /usr/share/easy-rsa/ -mindepth 1 -maxdepth 1 -type d) ;do
    easyrsa_dir=$d
done
if [ "$easyrsa_dir" = "" ] ;then
    echo    ERROR: easy-rsa directory not found
else
    ssh ${host} "cd ${easyrsa_dir}; source vars;./build-key ${client}"
fi
