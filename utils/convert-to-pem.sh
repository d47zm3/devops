#!/bin/bash

domain_names=( "domain-name.com" "my-site.com" )
for name in ${domain_names[@]}
do
  echo "[*] Converting signed certificate for ${name}..."
  openssl x509 -inform DER -in ${name}.cer -out ${name}.crt
done
