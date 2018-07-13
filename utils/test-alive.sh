#!/bin/bash

url="${1}"
url_file=$( echo "${1}" | sed "s#/#-#g" )

if [[ -z "${url}" ]]
then
  echo "Usage: ${0} <url to check>"
  exit 1
fi

touch ${url_file}.log
> ${url_file}.log

while [[ 1 -eq 1 ]]
do
  curl -s -I "${url}" | grep -q "HTTP/1.1 200 OK" > /dev/null
  ec_code=$?
  if [[ ${ec_code} -eq 0 ]]
  then 
    echo "$( date +'%H:%M:%S' ) [OK]" | tee -a ${url_file}.log
  else
    echo "$( date +'%H:%M:%S' ) [ERROR]" | tee -a ${url_file}.log
  fi
  sleep 1
done
