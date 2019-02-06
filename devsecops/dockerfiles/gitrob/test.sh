#!/bin/bash

. ../_scripts_/.common.sh

docker run -i -e GITROB_ACCESS_TOKEN="0" --rm security-tools:gitrob gitrob -h 2>&1 | grep -iq commit
if [[ ${?} -eq 0 ]]
then
  decho_green "[ok] [gitrob] test passed!"
  exit 0
else
  decho_red "[error] [gitrob] test failed!"
  exit 1
fi
