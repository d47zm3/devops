# Kubernetes The Hard Way On Vagrant


```
# Create CA

generate-ca.sh

# Generate Admin Client Certificate

generate-admin-client-certificate.sh

# Generate Kubelet Certificates (Workers)

generate-kubelet-client-certificates.sh

# Generate Kube Controller Manager Certificate

generate-kube-controller-manager-certificate.sh

# Generate Kube Proxy Client Certificates

generate-kube-proxy-certificate.sh

# Generate Kube Scheduler Certificate

generate-kube-scheduler-certificate.sh

# Generate Kube API Server Certificate

generate-kubernetes-api-server-certificate.sh

# Generate Service Account Key Pair

generate-service-account-key-pair.sh

# Distribute Certificates

distribute-certificates.sh

# Generate Kubernetes Configuration Files For Authentication (using first master only though)

generate-kube-config-workers.sh
generate-kube-config-kube-proxy.sh
generate-kube-config-kube-controller-manager.sh
generate-kube-config-kube-scheduler.sh
generate-kube-admin.sh

# Distribute Kube Configuration

distribute-kube-configs.sh

# Generate Data Encryption Config and Key

encryption-at-rest.sh

# Distribute Encryption Key

distribute-encryption-keys.sh

# Bootstrap ETCD Cluster (to execute on each node)

etcd-setup.sh

# Bootstrap Kubernetes Control Plane

bootstrap-kubernetes-control-plane.sh

# Grant RBAC Roles For Node Access

grant-rbac-to-nodes.sh

# Provision Worker Nodes

bootstrap-node.sh

# Create Remote Admin Config

generate-remote-admin.sh

# CNI TODO

kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')"

# Apply DNS Addon

kubectl apply -f https://storage.googleapis.com/kubernetes-the-hard-way/coredns.yaml

# Strange DNS issue ?

```
