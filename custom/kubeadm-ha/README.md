# kubeadm ha setup

Simply HA setup after this [guide](https://kubernetes.io/docs/setup/independent/high-availability/#), which does not work for HTTPS and in general, for starters I simplified it for testing purposes and automated. Vagrant setup is included! Machines have two interfaces, eth0 is NAT one for Internet access, and eth1 is for networking between machines and host.

## how to start
Clone this repository, and...
```
cd kubeadm-ha/vagrant
# edit Vagrantfile/servers.yaml files to match your public SSH key/your IP address choice for VirtualBox
vagrant up
# wait for machines to boot up...
# IMPORTANT! Make sure, during provisioning machines there's entry
cd ../
# edit out settings to match those in Vagrantfile, choose Virtual IP to use 
vi kubeadm-settings.sh
# run setup.sh and watch magic
./setup.sh
# ...couple mins later... 
...
kube-system   weave-net-6lvds                  2/2       Running             0          1m
kube-system   weave-net-nklfc                  2/2       Running             0          1m
kube-system   weave-net-wqwrj                  2/2       Running             0          1m
NAME      STATUS    ROLES     AGE       VERSION
kube01    Ready     master    4m        v1.10.4
kube02    Ready     master    3m        v1.10.4
kube03    Ready     master    1m        v1.10.4
serviceaccount "weave-net" configured
clusterrole.rbac.authorization.k8s.io "weave-net" configured
clusterrolebinding.rbac.authorization.k8s.io "weave-net" configured
role.rbac.authorization.k8s.io "weave-net" configured
rolebinding.rbac.authorization.k8s.io "weave-net" configured
daemonset.extensions "weave-net" configured
NAMESPACE     NAME                             READY     STATUS    RESTARTS   AGE
kube-system   kube-apiserver-kube01            1/1       Running   0          3m
kube-system   kube-apiserver-kube02            1/1       Running   0          2m
kube-system   kube-apiserver-kube03            1/1       Running   0          1m
kube-system   kube-controller-manager-kube01   1/1       Running   0          4m
kube-system   kube-controller-manager-kube02   1/1       Running   0          3m
kube-system   kube-controller-manager-kube03   1/1       Running   0          1m
kube-system   kube-dns-86f4d74b45-9479c        3/3       Running   0          4m
kube-system   kube-proxy-22p6j                 1/1       Running   0          4m
kube-system   kube-proxy-2flmq                 1/1       Running   0          3m
kube-system   kube-proxy-7vs5z                 1/1       Running   0          2m
kube-system   kube-scheduler-kube01            1/1       Running   0          4m
kube-system   kube-scheduler-kube02            1/1       Running   0          3m
kube-system   kube-scheduler-kube03            1/1       Running   0          2m
kube-system   weave-net-6lvds                  2/2       Running   0          1m
kube-system   weave-net-nklfc                  2/2       Running   0          1m
kube-system   weave-net-wqwrj                  2/2       Running   0          1m
Un-taint nodes so you can schedule pods...
node "kube01" untainted
node "kube02" untainted
node "kube03" untainted
[***] kubeadm-ha setup was sucessful!
```
**IMPORTANT! Make sure during provisioning machines there's generated /etc/hosts entry with private IP like this! Machine name has to resolve to private IP, not 127.0.0.1 or NAT one**
```
==> kube01: Running provisioner: shell...
    kube01: Running: inline script
    kube01: 192.168.56.111 kube01 ### THIS ONE
    kube01: ssh-rsa +/px5EXjrl6Y0Oy8hEtoxNJEIyelAtbKWXBsRG6i4qVvz/SkdZmMXR/PcS4gj9xufWJWy5ku/dHcW6+iTeJXpsz265ZkFMf3t8TqiMNUKIGZ/8o...
==> kube01: Running provisioner: shell...
```
