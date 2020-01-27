for instance in kubernetes-worker-01 kubernetes-worker-02 kubernetes-worker-03 ; do
cat > ${instance}-csr.json <<EOF
{
  "CN": "system:node:${instance}",
  "key": {
    "algo": "rsa",
    "size": 2048
  },
  "names": [
    {
      "C": "US",
      "L": "Portland",
      "O": "system:nodes",
      "OU": "Kubernetes The Hard Way",
      "ST": "Oregon"
    }
  ]
}
EOF

if [[ ${instance} == "kubernetes-worker-01" ]]
then
    EXTERNAL_IP="192.168.10.111"
fi

if [[ ${instance} == "kubernetes-worker-02" ]]
then
    EXTERNAL_IP="192.168.10.112"
fi

if [[ ${instance} == "kubernetes-worker-03" ]]
then
    EXTERNAL_IP="192.168.10.113"
fi

cfssl gencert \
  -ca=ca.pem \
  -ca-key=ca-key.pem \
  -config=ca-config.json \
  -hostname=${instance},${EXTERNAL_IP} \
  -profile=kubernetes \
  ${instance}-csr.json | cfssljson -bare ${instance}
done
