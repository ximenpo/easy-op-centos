#!/usr/bin/env bash

# enable forward
cat /etc/sysctl.conf | grep "net\\.ipv4\\.ip_forward[ \t]*=[ \t]*1" > /dev/null || {
    echo    net.ipv4.ip_forward = 1     >>  /etc/sysctl.conf
    sysctl  -p
}

# install openvpn
yum info    installed   openvpn > /dev/null     ||  {
    yum     install -y  openvpn easy-rsa
    # make cert
    easyrsa_dir=
    for d in $(find /usr/share/easy-rsa/ -mindepth 1 -maxdepth 1 -type d) ;do
        easyrsa_dir=$d
    done
    if [ -n "$easyrsa_dir" ] ;then
        if [ ! -d "${easyrsa_dir}/keys" ] ;then
            pushd   "$easyrsa_dir"
                source  vars
                ./clean-all
                ./pkitool --initca
                ./pkitool --server server
                ./build-dh
                openvpn --genkey --secret keys/ta.key
                cd keys &&  /usr/bin/cp -f dh2048.pem ca.crt server.crt server.key ta.key /etc/openvpn/
            popd
        fi
    fi
}

# start&autostart openvpn
if [ -e /etc/openvpn/server.conf ] ;then
    # start service
    which systemctl > /dev/null 2>&1  &&  {
        systemctl -f    enable      openvpn@server.service
        systemctl       restart     openvpn@server.service
    }
    which systemctl > /dev/null 2>&1  ||  {
        chkconfig   openvpn on
        service     openvpn restart
    }
fi

exit    0
