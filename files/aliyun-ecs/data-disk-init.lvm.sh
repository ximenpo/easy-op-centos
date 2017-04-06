#!/usr/bin/env bash

set -e

# format data disk and mount it
DISK_FMT=${1:-xfs}
DATA_DIR=${2:-/data}

DATA_TOKEN=${DATA_DIR##*/}
VG_NAME=vg_${DATA_TOKEN}
LV_NAME=lv_${DATA_TOKEN}
findmnt -m --target ${DATA_DIR} > /dev/null 2>&1 && {
    echo    ${DATA_DIR} has been mounted
}

[[ "${DISK_FMT}" = 'xfs' ]] && {
    rpm -q xfsprogs >/dev/null 2>&1     || yum install -y  xfsprogs
}

for prefix in xvd vd ;
do
    for label in b c d e f g h i j k l m n o p q r s t u v w x y z ;
    do
        fdisk -l | grep /dev/${prefix}${label} > /dev/null 2>&1 && {
            df | grep /dev/${prefix}${label}1 || {
                echo    found /dev/${prefix}${label}
                fdisk /dev/${prefix}${label} <<'EOF'
n
p
1


t
8e
wq
EOF
                partprobe               /dev/${prefix}${label}

                pvcreate                /dev/${prefix}${label}1
                vgcreate ${VG_NAME}     /dev/${prefix}${label}1
                lvcreate    -l  $(vgdisplay ${VG_NAME} | grep "Total PE" | awk '{print $3}') \
                            -n  ${LV_NAME}  \
                            ${VG_NAME}

                mkfs.${DISK_FMT}    -f  /dev/${VG_NAME}/${LV_NAME}
                mkdir   -p  ${DATA_DIR}
                cat /etc/fstab | grep ${DATA_DIR} > /dev/null 2>&1 || echo /dev/${VG_NAME}/${LV_NAME} ${DATA_DIR} ${DISK_FMT} defaults,noatime,nodiratime,nodev 0 0 >> /etc/fstab
                findmnt -m --target ${DATA_DIR} > /dev/null 2>&1   || mount -a
                break   1
            }
        }
    done
done

exit    0
