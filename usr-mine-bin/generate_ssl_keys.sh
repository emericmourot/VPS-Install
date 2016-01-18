#!/usr/bin/env bash

# Author:   Zhang Huangbin (michaelbibby@gmail.com)
# Purpose:  Create new SSL keys.
# Project:  iRedMail (http://www.iredmail.org/)

export HOSTNAME="$(hostname -f)"
export ROOTDIR="$(pwd)"

# SSL key.
export SSL_CERT_FILE="${ROOTDIR}/certs/patanok_CA.pem"
export SSL_KEY_FILE="${ROOTDIR}/private/patanok.key"
export TLS_COUNTRY='FR'
export TLS_STATE='Isere'
export TLS_CITY='Uriage'
export TLS_COMPANY="${HOSTNAME}"
export TLS_DEPARTMENT=''
export TLS_HOSTNAME="${HOSTNAME}"
export TLS_ADMIN="root@${HOSTNAME}"

# Create SSL certs/private files.
gen_pem_key()
{
    # Create necessary directories.
    mkdir -p {certs,private} 2>/dev/null

    openssl req \
        -x509 -nodes -days 3650 -newkey rsa:1024 \
        -subj "/C=${TLS_COUNTRY}/ST=${TLS_STATE}/L=${TLS_CITY}/O=${TLS_COMPANY}/OU=${TLS_DEPARTMENT}/CN=${TLS_HOSTNAME}/emailAddress=${TLS_ADMIN}/" \
        -out ${SSL_CERT_FILE} -keyout ${SSL_KEY_FILE} >/dev/null 2>&1

    # Set correct file permission.
    chmod 0444 ${SSL_CERT_FILE}
    chmod 0400 ${SSL_KEY_FILE}
}

gen_pem_key && cat <<EOF
SSL keys were generated:
    - ${SSL_CERT_FILE}
    - ${SSL_KEY_FILE}
EOF
