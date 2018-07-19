#!/bin/bash

domain_names=( "domain-name.com" "my-site.com" )
for name in ${domain_names[@]}
do
  echo "[*] Generating certificate for ${name}..."
  openssl req -nodes -newkey rsa:2048 -keyout ${name}.key -out ${name}.csr -subj "/C=PL/ST=Warsaw/L=Warsaw/O=Comapny Name/OU=IT Division/CN=${name}"
done
