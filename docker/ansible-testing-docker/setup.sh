#!/bin/bash

function decho
{
	string=$1
  echo "[$( date +'%H:%M:%S' )] ${string}"
}

decho "Setup Host With Docker For Testing Ansible Roles In Containers... CentOS Version"
decho "Checking For Ansible..."
which ansible > /dev/null
ansible_installed=$?
if [[ ansible_installed -eq 0 ]]
then
	decho "Ansible already installed!"
else
	decho "Ansible not found, installing dependencies..."
	yum -y install epel-release
	yum -y install python-pip PyYAML python-jinja2 python-httplib2 python-keyczar python-paramiko git
	yum -y install python-pip
	decho "Installing Ansible..."
	pip install ansible
fi
ansible --version
decho "Checking For Docker..."
which docker > /dev/null
docker_installed=$?
if [[ docker_installed -eq 0 ]]
then
	decho "Docker already installed!"
else
	dechp "Installing Docker Dependencies..."
	yum install -y yum-utils device-mapper-persistent-data lvm2
	dechp "Enable Repo..."
	yum-config-manager \
	    --add-repo \
	    https://download.docker.com/linux/centos/docker-ce.rep
	yum makecache fast
	dechp "Install Docker..."
	yum install docker-ce
fi
docker --version
decho "Check For Docker Network..."
docker network list | grep -q "ansible"
if [[ "$?" -eq 0 ]]
then
	decho "Network already exists!"
else
	docker network create --subnet=172.100.0.0/16 ansible-network
fi
decho "Check For Hosts Entries..."
grep -q "172.100.0.2 centos-6" /etc/hosts
if [[ "$?" -eq 0 ]]
then
	decho "Hosts entry found!"
else
	echo "172.100.0.2 centos-6" | tee -a /etc/hosts
fi
grep -q "172.100.0.3 centos-7" /etc/hosts
if [[ "$?" -eq 0 ]]
then
	decho "Hosts entry found!"
else
	echo "172.100.0.3 centos-7" | tee -a /etc/hosts
fi



