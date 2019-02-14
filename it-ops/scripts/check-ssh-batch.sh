#!/bin/bash

user=d47zm3

while read server
do
        result=$( ssh -q -o "BatchMode=yes" -i /home/${user}/.ssh/id_rsa ${user}@${server} "echo 2>&1" < /dev/null && echo $host SSH_OK || echo $host SSH_NOK )
        echo "[${server}] ${result} "
done < servers.list
