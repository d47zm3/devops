#!/bin/bash

. /root/kubeadm-settings.sh

export PEER_NAME=$(hostname)
export PRIVATE_IP=$(ip addr show ${primary_interface} | grep -Po 'inet \K[\d.]+')

ETCD_VERSION="v3.1.12"
curl -sSL https://github.com/coreos/etcd/releases/download/${ETCD_VERSION}/etcd-${ETCD_VERSION}-linux-amd64.tar.gz | tar -xz --strip-components=1 -C /usr/local/bin/

touch /etc/etcd.env
echo "PEER_NAME=${PEER_NAME}" > /etc/etcd.env
echo "PRIVATE_IP=${PRIVATE_IP}" >> /etc/etcd.env


cat >/etc/systemd/system/etcd.service <<EOF
 [Unit]
 Description=etcd
 Documentation=https://github.com/coreos/etcd
 Conflicts=etcd.service
 Conflicts=etcd2.service

 [Service]
 EnvironmentFile=/etc/etcd.env
 Type=notify
 Restart=always
 RestartSec=5s
 LimitNOFILE=40000
 TimeoutStartSec=0

 ExecStart=/usr/local/bin/etcd --name ${PEER_NAME} --data-dir /var/lib/etcd --listen-client-urls http://${PRIVATE_IP}:2379 --advertise-client-urls http://${PRIVATE_IP}:2379 --listen-peer-urls http://${PRIVATE_IP}:2380 --initial-advertise-peer-urls http://${PRIVATE_IP}:2380 --initial-cluster ${master_01_name}=http://${master_01_address}:2380,${master_02_name}=http://${master_02_address}:2380,${master_03_name}=http://${master_03_address}:2380 --initial-cluster-token my-etcd-token --initial-cluster-state new

 [Install]
 WantedBy=multi-user.target
EOF

systemctl daemon-reload
# systemctl start etcd &

yum -y install keepalived

if [[ "${PEER_NAME}" == "${master_01_name}" ]]
then
  role="MASTER"
  priority="101"
else
  role="BACKUP"
  priority="100"
fi

cat >/etc/keepalived/keepalived.conf <<EOF
 ! Configuration File for keepalived
 global_defs {
  router_id LVS_DEVEL
 }

 vrrp_script check_apiserver {
  script "/etc/keepalived/check_apiserver.sh"
  interval 3
  weight -2
  fall 10
  rise 2
 }

 vrrp_instance VI_1 {
    state ${role}
    interface ${primary_interface}
    virtual_router_id 51
    priority ${priority}
    authentication {
        auth_type PASS
        auth_pass ff34534g34t345hh22bbnm1z
    }
    virtual_ipaddress {
        ${virtual_ip}
    }
    track_script {
        check_apiserver
    }
 }
EOF

cat >/etc/keepalived/check_apiserver.sh <<EOF
 #!/bin/sh

 errorExit() {
    echo "*** $*" 1>&2
    exit 1
 }

 curl --silent --max-time 2 --insecure http://localhost:6443/ -o /dev/null || errorExit "Error GET http://localhost:6443/"
 if ip addr | grep -q ${virtual_ip}; then
    curl --silent --max-time 2 --insecure http://${virtual_ip}:6443/ -o /dev/null || errorExit "Error GET http://${virtual_ip}:6443/"
 fi
EOF

chmod +x /etc/keepalived/check_apiserver.sh

systemctl restart keepalived
systemctl enable keepalived
