#!/bin/bash

commonname="$1"

openssl req \
    -new \
    -newkey rsa:4096 \
    -days 1095 \
    -nodes \
    -x509 \
    -subj "/C=IL/ST=Tel Aviv/L=Holon/O=Sapiens/CN=${commonname}" \
    -keyout ${commonname}.key \
    -out ${commonname}.cert
