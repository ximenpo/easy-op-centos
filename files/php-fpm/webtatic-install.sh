#!/usr/bin/env bash

yum repolist enabled    |   grep 'epel/' > /dev/null    || {
    yum     install -y  epel-release
}

yum list installed epel-release >/dev/null  ||  {
    yum     install -y  epel-release
}

yum repolist enabled    |   grep 'webtatic/' > /dev/null    || {
    for w in `cat /etc/redhat-release` ; do
       echo $w | grep '[5-7]\.'    >/dev/null    && {
           V=`echo     $w  |   cut -d '.' -f 1`
           break    1
       }
    done

    if [ "${V}" == "7" ]; then
        rpm -Uvh 'https://mirror.webtatic.com/yum/el7/webtatic-release.rpm'
    elif [ "${V}" == "6" ]; then
        rpm -Uvh 'https://mirror.webtatic.com/yum/el6/latest.rpm'
    elif [ "${V}" == "5" ]; then
        rpm -Uvh 'https://mirror.webtatic.com/yum/el5/latest.rpm'
    else
        echo    "CentOS version $v not support"
        exit    1
    fi
}
