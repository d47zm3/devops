#!/bin/bash

. ../_scripts_/.common.sh

docker run -i --rm security-tools:nikto -Version 2>/dev/null | grep -q "nikto_"
if [[ ${?} -eq 0 ]]
then
  decho_green "[ok] [nikto] test passed!"
  exit 0
else
  decho_red "[error] [nikto] test failed!"
  exit 1
fi
