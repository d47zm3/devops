#!/bin/bash

function decho
{
		string=$1
    echo "[$( date +'%H:%M:%S' )] ${string}"
}

# test ansible role on chosen distribution

. ./env.sh

cd ${git_repo_testing_path}

exit_code=0
ansible_role=${1}
container_distribution=${2}

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

decho "Stopping and removing all containers... Restart Docker by the way"
# stop all containers and remove them (except my pentest container!)
sudo systemctl restart docker
docker_containers_count=$( docker ps -a | wc -l )
if [[ "${docker_containers_count}" -gt 1 ]]
then
	docker stop $(docker ps -a | egrep -v "CONTAINER" | awk '{print $1}') > /dev/null
	docker rm $(docker ps -a | egrep -v "CONTAINER" | awk '{print $1}') > /dev/null
fi

# build images for testing

# tracking time
SECONDS=0
decho "Starting build of image..."
docker build -t ansible/${container_distribution} -f ./Dockerfile.${container_distribution} .

docker ps -a | grep -q "${container_name}"
if [[ $? -eq 0 ]]
then
		decho "Found running containers... removing it!"
		docker stop "${container_name}"
		docker rm "${container_name}"
fi

if [[ "${container_distribution}" == "centos-6" ]]
then
  ip_address="172.100.0.2"
elif  [[ "${container_distribution}" == "centos-7" ]]
then
  ip_address="172.100.0.3"
elif  [[ "${container_distribution}" == "debian" ]]
then
  ip_address="172.100.0.4"
fi

decho "Starting container..."
docker run -itd --name "${container_name}" --net ansible-network --ip ${ip_address} "ansible/${container_distribution}" > /dev/null
decho "Checking if Ansible can reach container..."
ansible -m ping ${container_distribution} | grep -q "SUCCESS"
if [[ ${?} -eq 0 ]]
then
        decho "[SUCCESS] Ansible could reach container!"
else
        decho "[ERROR] Ansible could not reach container!"
  exit_code=1
  exit ${exit_code}
fi

decho "Running Ansible Playbook..."
ansible-playbook --extra-vars="hosts=${container_distribution}" -i ./inventory "${git_repo_testing_playbooks_path}/${ansible_role}.yaml"

if [[ ${?} -eq 0 ]]
then
        decho "[SUCCESS] Ansible Playbook Works!"
else
        decho "[ERROR] Ansible Playbook Failed!"
  exit_code=1
fi

duration=$SECONDS
decho "Ansible Role Check has took $(($duration / 60)) minutes and $(($duration % 60)) seconds."

exit ${exit_code}
