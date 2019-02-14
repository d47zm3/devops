#!/bin/bash

. /root/kubeadm-settings.sh

export PEER_NAME=$(hostname)
export PRIVATE_IP=$(ip addr show ${primary_interface} | grep -Po 'inet \K[\d.]+' | head -n1)
cat >config.yaml <<EOF
apiVersion: kubeadm.k8s.io/v1alpha1
kind: MasterConfiguration
api:
  advertiseAddress: ${PRIVATE_IP}
etcd:
  endpoints:
    - http://${master_01_address}:2379
    - http://${master_02_address}:2379
    - http://${master_03_address}:2379
networking:
  podSubnet: 10.1.1.0/16
apiServerCertSANs:
- "${master_01_address}"
- "${master_02_address}"
- "${master_03_address}"
- "${virtual_ip}"
apiServerExtraArgs:
  endpoint-reconciler-type: lease
EOF
