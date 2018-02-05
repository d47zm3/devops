#!/bin/bash

IFS=', ' read -r -a nodes <<< "$@"

# check if docker is installed
which docker

if [[ "$?" -ne 0 ]]
then
        echo "Docker not installed! Exit!"
        exit 1
fi

docker version | grep Version | grep -q 1.12

if [[ "$?" -ne 0 ]]
then
        echo "Docker not in version 1.12 (swarm mode), exit!"
        exit 1
fi

# fix sysctl (ELK not working for example without it)
sysctl -w vm.max_map_count=262144

docker node ls | grep -q $HOSTNAME
if [[ "$?" -ne 0 ]]
then
        echo "Initialize swarm..."
        docker swarm init --advertise-addr $( hostname -i )
else
        echo "Swarm already initalized..."
fi

join_command=$( docker swarm join-token worker | grep -A2 docker )

for node in "${nodes[@]}"
do
        docker node ls | grep -q ${node}
        if [[ "$?" -ne 0 ]]
        then
                echo "Node ${node} not yet in cluster, joining..."
                ssh ${node} "${join_command}; exit"
                docker node promote
        else
                echo "Node ${node} already in cluster, skipping..."
        fi
done

