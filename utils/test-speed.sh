#!/bin/bash

url="${1}"
url_file=$( echo "${1}" | sed -e "s/http[s][:\/\/]//g" | sed -e "s#/#-#g" | sed -e "s/^-*//g" | sed -e "s/-*$//g" )


echo $url_file
exit 0
touch ${url_file}.log
> ${url_file}.log

while [[ 1 -eq 1 ]]
do
  curl -s -w %{time_total}\\n -o /dev/null ${url}
done
