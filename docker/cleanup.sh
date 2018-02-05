#!/bin/bash

# include my bash framework
. ~/.bash_framework

decho "Stopping and removing all containers..."
# stop all containers and remove them (except my pentest container!)
docker stop $(docker ps -a | egrep -v "CONTAINER|secops" | awk '{print $1}') > /dev/null
docker rm $(docker ps -a | egrep -v "CONTAINER|secops" | awk '{print $1}') > /dev/null

decho "Stopping security container..."
<<<<<<< HEAD
docker stop secops > /dev/null 2>&1
=======
docker stop secops
>>>>>>> 413c10d3d2b2159b54c8a5ea01c5cc0c0306b64f
