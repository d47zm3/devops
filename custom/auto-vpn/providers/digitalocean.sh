#!/bin/bash

if [[ ${1} == "create" ]]
then
  decho "deploying on digital ocean provider..."
  which doctl > /dev/null

  if [[ ${?} -ne 0 ]]
  then
    decho "[error] doctl - digital ocean cli client not found! please see here for details: https://github.com/digitalocean/doctl/blob/master/README.md"
    exit 1
  fi

  decho "checking ssh key fingerprint..."
  ssh_key_fingerprint=$( ssh-keygen -E md5 -lf ${ssh_key} | awk ' { print $2 } ' | sed -e "s/MD5://g" )
  if [[ -z ${ssh_key_fingerprint} ]]
  then
    decho "[error] your ssh key is not valid or path is not correct, exit!"
    exit 1
  else
    decho "your ssh key fingerprint is ${ssh_key_fingerprint}"
  fi


  decho "validating access..."
  doctl compute droplet list 2>&1 > /dev/null
  if [[ ${?} -eq 1 ]]
  then
    decho "[error] you are not logged in, issue 'doctl auth init' and pass your api token!"
    exit 1
  else
    decho "access validated properly!"

  fi

  decho "checking if droplet already exists..."
  doctl compute droplet list | egrep -q "${server_name}"
  if [[ ${?} -eq 0 ]]
  then
    decho "droplet already exists... checking if it's provisioned..."
    ssh -o StrictHostKeyChecking=no root@${ip_address} "netstat -tulepn" | egrep -q "4500"
    if [[ ${?} -eq 0 ]]
    then
      decho "seems like server is already provisioned, exit!"
      ip_address=$( doctl compute droplet list | grep ${server_name} | awk ' { print $3 } ' )
    fi
  else
    decho "creating droplet..."
    doctl compute droplet create ${server_name} --size 512mb --image ubuntu-18-04-x64 --region ${region} --ssh-keys ${ssh_key_fingerprint} --wait

    decho "getting ip..."
    ip_address=$( doctl compute droplet list | grep ${server_name} | awk ' { print $3 } ' )
    decho "wait until ssh gets up..."
    ssh_up=0
    while [[ ${ssh_up} -eq 0 ]]
    do
      nc -vz ${ip_address} 22 2>&1 | grep -q succeeded
      if [[ ${?} -eq 0 ]]
      then
        ssh_up=1
      fi
    done

    decho "provisioning server ${ip_address} with vpn software..."
    decho "running server update..."
    ssh -o StrictHostKeyChecking=no root@${ip_address} "DEBIAN_FRONTEND=noninteractive apt-get update > /dev/null && DEBIAN_FRONTEND=noninteractive apt-get -y upgrade > /dev/null"
    decho "running vpn setup..."
    ssh -o StrictHostKeyChecking=no root@${ip_address} "wget https://git.io/vpnsetup -O vpnsetup.sh && sudo VPN_IPSEC_PSK='${vpn_ipsec_psk}' VPN_USER='${vpn_user}' VPN_PASSWORD='${vpn_password}' sh vpnsetup.sh"
    decho "server setup succesfully! update/create local dns record \"${ip_address} vpn.server\" in /etc/hosts"

  fi

  grep -q "vpn.server" /etc/hosts
  if [[ ${?} -eq 0 ]]
  then
    decho "record found, update..."
    sudo sed -i "" "s/.*vpn\.server/${ip_address} vpn.server/g" /etc/hosts
  else
    decho "record not found, adding..."
    echo "${ip_address} vpn.server" | sudo tee -a /etc/hosts
  fi

elif [[ "${1}" == "destroy" ]]
then
  doctl compute droplet list | grep -q ${server_name}
  if [[ ${?} -eq 0 ]]
  then
    decho "deleting droplet ${server_name}..."
    doctl compute droplet delete -f ${server_name}
    decho "droplet has been deleted!"
  else
    decho "droplet ${server_name} not found!"
    exit 0
  fi
elif [[ "${1}" == "status" ]]
then
  decho "checking status of vpn server and software for droplet ${server_name}..."
  doctl compute droplet list | grep -q "${server_name}"
  if [[ ${?} -eq 0 ]]
  then
    decho "found droplet, checking ipsec service status..."
    ip_address=$( doctl compute droplet list | grep ${server_name} | awk ' { print $3 } ' )
    ssh -o StrictHostKeyChecking=no root@${ip_address} "systemctl status ipsec" > /dev/null
    if [[ ${?} -eq 0 ]]
    then
      decho "found service, checking status..."
      ssh -o StrictHostKeyChecking=no root@${ip_address} "systemctl status ipsec" | grep -q "running"
      if [[ ${?} -eq 0 ]]
      then
        decho "service is running!"
      else
        decho "[error] seems like service is not running! exit!"
        exit 1
      fi
    else
      decho "[error] problem with ipsec service! exit!"
      exit 1
    fi
  else
    decho "droplet not found..."
  fi
fi
