KUBERNETES_HOSTNAMES=kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster,kubernetes.svc.cluster.local
MASTER_VM_IPS=192.168.10.101,192.168.10.102,192.168.10.103

cat > kubernetes-csr.json <<EOF
{
  "CN": "kubernetes",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "Kubernetes",
      "OU": "Kubernetes The Hard Way",
      "ST": "Oregon"
    }
  ]
}
EOF

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -hostname=10.32.0.1,10.240.0.10,10.240.0.11,10.240.0.12,${MASTER_VM_IPS},127.0.0.1,${KUBERNETES_HOSTNAMES},kubernetes-master-01,kubernetes-master-02,kubernetes-master-03 \
  -profile=kubernetes \
  kubernetes-csr.json | cfssljson -bare kubernetes
