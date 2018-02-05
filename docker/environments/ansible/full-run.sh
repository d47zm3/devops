#!/bin/bash

. ~/.bash_framework

# test ansible role on chosen distribution

exit_code=0
ansible_role=${1}
container_distribution=${2}

container_name="ansible-test"

function usage
{
	echo "${0} ANSIBLE-ROLE LINUX-DISTRIBUTION (centos-6,centos-7, debian:latest)"
}

if [[ -z "${ansible_role}" ]] || [[ -z "${container_distribution}" ]]
then
	decho "[ERROR] Wrong parameters!"
	usage
	exit 1
fi

# build images for testing


docker build -t ansible/${container_distribution} -f ./Dockerfile.${container_distribution} . > /dev/null

docker ps -a | grep -q "${container_name}" 
if [[ $? -eq 0 ]]
then
	docker stop "${container_name}" > /dev/null 2>&1
	docker rm "${container_name}" > /dev/null 2>&1
fi 

docker run -itd --name "${container_name}" "ansible/${container_distribution}" > /dev/null
ansible -m ping ansible-test | grep -q "SUCCESS"
if [[ ${?} -eq 0 ]]
then
	decho "[SUCCESS] Ansible could reach container!"
else
	decho "[ERROR] Ansible could not reach container!"
fi


exit ${exit_code}
