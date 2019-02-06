#!/bin/bash

. ../_scripts_/.common.sh

docker run -i --rm security-tools:htrace 2>/dev/null | grep -q "observatory"
if [[ ${?} -eq 0 ]]
then
  decho_green "[ok] [htrace] test passed!"
  exit 0
else
  decho_red "[error] [htrace] test failed!"
  exit 1
fi
