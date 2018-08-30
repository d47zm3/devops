#!/bin/bash

error=0

for host in  "microsoft.com" "google.com"
do
  echo "[*] Checking expire date for domain ${host}..."
  tls_date=$( date --date="$(echo | openssl s_client -servername ${host} -connect ${host}:443 2>/dev/null | openssl x509 -noout -enddate | cut -d= -f 2 )" --iso-8601 )
  tls_expire=$(date -d "${tls_date}" +%s)
  today=$(date  +%s)
  days_left=$(( (tls_expire - today) / 86400 ))
  echo "[*] Domain ${host} will expire in ${days_left} days..."
  if [[ ${days_left} -le 28 ]]
  then
    echo "[ERROR] Seems like certificate for ${host} was not renewed, check it !"
    error=1
  fi
done


for ingress in $( kubectl get ingress --all-namespaces | grep 443 | awk ' { print $2 } ' )
do
  namespace=$( kubectl get ingress --all-namespaces | grep 443 | grep ${ingress} |  awk ' { print $1 } '  )
  for host in $( kubectl --namespace ${namespace} describe ingress ${ingress} | grep -i "terminates" | awk ' { print $NF } ' )
  do
    echo "Checking expire date for domain ${host}..."
    tls_date=$( date --date="$(echo | openssl s_client -servername ${host} -connect ${host}:443 2>/dev/null | openssl x509 -noout -enddate | cut -d= -f 2 )" --iso-8601 )
    tls_expire=$(date -d "${tls_date}" +%s)
    today=$(date  +%s)
    days_left=$(( (tls_expire - today) / 86400 ))
    echo "[*] Domain ${host} will expire in ${days_left} days..."
    if [[ ${days_left} -le 28 ]]
    then
      echo "[ERROR] Seems like certificate for ${host} was not renewed, check it !"
      error=1
    fi
  done
done

exit ${error}
