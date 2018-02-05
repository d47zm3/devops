#!/bin/bash

# include my bash framework
. ~/.bash_framework

security_container="h4ck3r"
security_tools=( nmap nikto dirb pdf-parser exiftool steghide volatility metasploit-framework )

# create container if it doesn't exist
docker ps -a | grep -q ${security_container}
exists=${?}
if [[ "${exists}" -eq 0 ]]
then
	decho "Container already exist, proceeding..."

else
	decho "Container doesn't exist, running..."
	docker run -it --name "${security_container}" kalilinux/kali-linux-docker /bin/bash
fi

docker ps | grep -q ${security_container}
running=${?}
if [[ "${running}" -eq 1 ]]
then
	decho "Container not running, starting..."
	docker start "${security_container}"
else
	decho "Container running, proceeding..."
fi

decho "Updating system..."
docker exec -it ${security_container} bash -c "apt-get update && apt-get -y upgrade"

decho "Installing basic tools..."
docker exec -it ${security_container} bash -c "apt-get -y install ${security_tools[@]}"
docker exec -it ${security_container} bash -c "echo \"${security_tools[@]}\""
