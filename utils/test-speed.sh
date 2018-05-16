#!/bin/bash

url="${1}"
url_file=$( echo "${1}" | sed "s#/#-#g" )

touch ${url_file}.log
> ${url_file}.log

while [[ 1 -eq 1 ]]
do
  curl -s -w %{time_total}\\n -o /dev/null ${url}
done
