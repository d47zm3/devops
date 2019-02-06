#!/bin/bash

. ../_scripts_/.common.sh

docker run -i --rm security-tools:nmap nmap -h 2>/dev/null  | grep -iq "timing"
if [[ ${?} -eq 0 ]]
then
  decho_green "[ok] [nmap] test passed!"
  exit 0
else
  decho_red "[error] [nmap] test failed!"
  exit 1
fi
