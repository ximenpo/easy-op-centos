#!/usr/bin/env bash

set -e

# format data disk and mount to /data
DATA_DIR=/data
findmnt -m --target ${DATA_DIR} > /dev/null 2>&1 && {
    echo    ${DATA_DIR} has been mounted
}

for label in b c d e f g h i j k l m n o p q r s t u v w x y z ;
do
    fdisk -l | grep /dev/xvd${label} > /dev/null 2>&1 && {
        df | grep /dev/xvd${label}1 || {
            echo    found /dev/xvd${label}
            fdisk /dev/xvd${label} <<EOF
n
p
1


wq
EOF
            mkfs.ext3 /dev/xvd${label}1
            mkdir   -p  ${DATA_DIR}
            cat /etc/fstab | grep ${DATA_DIR} > /dev/null 2>&1 || echo /dev/xvd${label}1 /data ext3 defaults,noatime,nodiratime,nodev 0 0 >> /etc/fstab
            findmnt -m --target ${DATA_DIR} > /dev/null 2>&1   || mount -a
            break   1
        }
    }
done

exit    0
