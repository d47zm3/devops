#!/bin/bash

set -eu

. kubeadm-settings.sh

# first make sure you can connect to machines directly as root 

for host in ${master_01_address} ${master_02_address} ${master_03_address}
do
  ssh -q root@${host} exit
  if [[ ${?} -ne 0 ]]
  then
    echo "Could not reach ${host} over SSH! Exit!"
    exit 1
  else
    echo "[OK] Reached server ${host}..."
  fi
done

# create init script on all hosts, to install prerequisites and copy settings

echo "Initialize prerequisites..."
for host in ${master_01_address} ${master_02_address} ${master_03_address}
do
  scp init.sh root@${host}:/root/
  scp kubeadm-settings.sh root@${host}:/root/
  ssh root@${host} "chmod +x /root/init.sh"
  ssh root@${host} "/root/init.sh"
done

echo "Initialize ETCD..."
# initialize etcd cluster and keepalived
for host in ${master_01_address} ${master_02_address} ${master_03_address}
do
  scp master-setup.sh root@${host}:/root/
  ssh root@${host} "chmod +x /root/master-setup.sh"
  ssh root@${host} "/root/master-setup.sh"
done

echo "Start ETCD on each node in background..."
for host in ${master_01_address} ${master_02_address} ${master_03_address}
do
  ssh root@${host} "systemctl start etcd &" &
  sleep 10
done

sleep 30

echo "Checking ETCD and preparing kubeadm config..."
# make sure etcd is up and running, prepare scripts for kubeadm, initalize config file
for host in ${master_01_address} ${master_02_address} ${master_03_address}
do
  ssh root@${host} "systemctl status etcd"
  if [[ ${?} -ne 0 ]]
  then
    echo "ETCD not running on ${host}, exit!" 
    exit 1
  fi
  scp kubeadm-setup.sh ${host}:/root/
  ssh root@${host} "chmod +x /root/kubeadm-setup.sh"
  ssh root@${host} "/root/kubeadm-setup.sh"
done

# run kubeadm init on first master, then spread certificates

echo "Initialize first master..."
ssh root@${master_01_address} "kubeadm init --config=config.yaml"

# make sure path already exists, get certificates to temporary directory

echo "Copy master certs and distribute them..."
mkdir temporary
scp ${master_01_address}:/etc/kubernetes/pki/* temporary/

for host in ${master_02_address} ${master_03_address}
do
  ssh root@${host} "mkdir -p /etc/kubernetes/pki"
  scp temporary/* ${host}:/etc/kubernetes/pki/
  ssh root@${host} "rm /etc/kubernetes/pki/apiserver.*"
done

echo "Initialize other masters..."
# initalize other masters
for host in ${master_02_address} ${master_03_address}
do
  ssh root@${host} "kubeadm init --config=config.yaml"
done

sleep 30

echo "Initialize network on each host..."
# initialize network on each host
for host in ${master_01_address} ${master_02_address} ${master_03_address}
do
  ssh root@${host} "mkdir -p /root/.kube"
  ssh root@${host} "sudo cp -i /etc/kubernetes/admin.conf /root/.kube/config"
  ssh root@${host} "sudo chown root:root /root/.kube/config"
  ssh root@${host} "kubectl get pod --all-namespaces"
  ssh root@${host} "kubectl get nodes"
  ssh root@${host} "kubectl apply -f \"https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')\""
  sleep 30
  ssh root@${host} "kubectl get pods --all-namespaces"
done

rm -rf temporary/

echo "Un-taint nodes so you can schedule pods..."
ssh root@${master_01_address} "kubectl taint nodes --all node-role.kubernetes.io/master-"

echo "[***] kubeadm-ha setup was sucessful!"
