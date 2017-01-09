#!/usr/bin/env bash

set -e

# EO_GROUP means the server group
if [ -n "${EASYOP_GROUP}" ]; then
    EO_GROUP="${EASYOP_GROUP}"
else
    EO_GROUP='servers'
fi

# EO_HOST means the target server
if [ -n "${1}" ] && [ -e "${EASYOP_GROUP}/${1}" ]; then
    EO_HOST="${1}"
    shift
else
    EO_HOST="${EASYOP_HOST}"
fi

# EO_CONF means the host's conf dir
EO_CONF="${EO_GROUP}/${EO_HOST}"
