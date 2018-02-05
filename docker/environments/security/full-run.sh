#!/bin/bash

container_name="secops"
image_name="d47zm3/security-lab"

docker stop ${container_name} 1>/dev/null 2>&1
docker rm ${container_name} 1>/dev/null 2>&1
docker build -t ${image_name} .
#docker run -itd --name ${container_name} -h ${container_name} --dns 172.26.1.158 ${image_name}
docker run -itd --name ${container_name} -h ${container_name} ${image_name}
docker exec -it ${container_name} zsh
