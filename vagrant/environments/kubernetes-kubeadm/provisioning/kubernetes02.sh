#!/bin/bash

# install some basics
sudo yum -y install epel-release
sudo yum -y install ansible 
sudo yum -y install git
sudo yum -y install net-tools
sudo yum -y install tmux
sudo yum -y install wget
sudo yum -y install vim
# install plugin for yaml!
sudo rm -rf /root/.ssh/
sudo mkdir /root/.ssh
sudo chmod 700 /root/.ssh
echo '-----BEGIN RSA PRIVATE KEY-----
MIIEowIBAAKCAQEA1HEYnUgybJEThY1drXqLRR9gOvtL8MgFNUy3Tst0P22+toan
hNKzNAGyaqJUMnmOlJ8KeXe8HEn0emzeRAojm06Ajo0IW6ycSHw2WVj/fS+uF3ci
hRkBeClR+jS1bObIpl40KSJ34s0heATHYuS0amifjAT2+Btb0lflPz6Rv8OUmtO9
I+JqOJ0sZmh7SSqrhws9At1SdmPtIOfOU6/Jkxd5bxdZSn9stnJfcxsclEJbM9Cv
jQGtbyXUXibdbVzoBBmb9l6BeYdvqRbQG4eB3csJocAxAlOEOvzh0R2xbkI1LAw0
X3psfscXeEhBbKL5lrV8sZKYUm8XRqi2sBkn1QIDAQABAoIBAE1kYiYyPgRlGaqG
pIDlasUkuAbks3alN5iCOSlgXxoYXejaxz5RD+27TIciWfAFbpbgFY3Iu+PGYWUU
MiixVOVoRNcps8jJ6ilR7u6/yFuPuilcQlwgjvN6gh3Xg9yHesN5ACGYJ/qc5jt1
6jkxvjQhpzX4PQyH0vye/qn6nlgwOwpCQf52snkcFERsHlvZieQGWkJpoYMyQdqc
0VfXbjec4tdXjGNoeU+wW4RdyRbCZnautBF1UAEblRkOKcwWZKWfQm5YeaLJd2ee
DZQy/n1YQfaMHkttysvIfoq1/Ze6WJbAf/XDcDme4EgALF+KfxwFqw9x2Z/mz2vd
zgKAGeUCgYEA7YAWigCwZpNVMlPgtD7oOD58vxmCxTRkJDxM7u1v56lnAGL4oJfC
PEMi8jzvZAc618utUWaOMy3Low21Vtr/Za/RptSk+TPzooFXw7RtrPDya63r2KLD
bsRxI2We2IZIpVzIRW3lFx9c89GjJ51xnQzvKLQ8nUEA+D7vAkOHsHcCgYEA5P1S
8poGi7zi3sc41zh/A4x96WsANGb2TjUXd/7CHhOPRWUBZfa4opx8/r2SSZ7jR5BF
TqTKVe8CAivVgQPJNXhXhqwyPx63xfsivoh8EyIxgNqIwNC/rbzvoZs3N7e2pl5m
NKMfV9PZayZmF2DeyojuFhZaOeIbZ38TRXFcKRMCgYAXNg593EVhMQMBkSsD0qYV
YR4F+zNJnK4w0Gfgbfoi1O6JHiMYZtyH0TPoIsZuqzo3/uLocrJxFAez3tIbM/oD
8SP3Pw8Ef+xOtH9kVAzn+wBmP7AuEvIwsCgygmr81FrjNmcoSe46zUjjV1ivtXZ2
F96DxuGpqMG0gUoQmZL4TwKBgFm5RNoYLf5s6XwfFY+G7IWoc+GU8oSV32aveN2k
rcz5Hwcy14RrUtcsd/GcuAguwKFWz0FMYpefSest379oi1tvJuR27k07LQjfKTL8
6ZjZqgnyFuluIdzijgaFefJUArZXgLaZP/u635MTfaclZsZ3NsriwUGy7cf0y8lG
7LSPAoGBAOeggKCC9XKWuGyU5GWqRfJ8DhWycJ7CWTpoolOgbB6iOJhgC3nQA8gr
wC/EEo5P3i5+8+EHyutqWzn2WCvoPg46uFQ7FpGd1gt6BK6EFb+aFlB+zVW9ffEG
9NngJE4Gliu3UBBJcQW8k+lbi4rALDVP3HXIyp309j7h2h9HJQeW
-----END RSA PRIVATE KEY-----' | sudo tee /root/.ssh/id_rsa

echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDUcRidSDJskROFjV2teotFH2A6+0vwyAU1TLdOy3Q/bb62hqeE0rM0AbJqolQyeY6Unwp5d7wcSfR6bN5ECiObToCOjQhbrJxIfDZZWP99L64XdyKFGQF4KVH6NLVs5simXjQpInfizSF4BMdi5LRqaJ+MBPb4G1vSV+U/PpG/w5Sa070j4mo4nSxmaHtJKquHCz0C3VJ2Y+0g585Tr8mTF3lvF1lKf2y2cl9zGxyUQlsz0K+NAa1vJdReJt1tXOgEGZv2XoF5h2+pFtAbh4HdywmhwDECU4Q6/OHRHbFuQjUsDDRfemx+xxd4SEFsovmWtXyxkphSbxdGqLawGSfV root@devops01.devops.pl' | sudo tee /root/.ssh/id_rsa.pub

echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDUcRidSDJskROFjV2teotFH2A6+0vwyAU1TLdOy3Q/bb62hqeE0rM0AbJqolQyeY6Unwp5d7wcSfR6bN5ECiObToCOjQhbrJxIfDZZWP99L64XdyKFGQF4KVH6NLVs5simXjQpInfizSF4BMdi5LRqaJ+MBPb4G1vSV+U/PpG/w5Sa070j4mo4nSxmaHtJKquHCz0C3VJ2Y+0g585Tr8mTF3lvF1lKf2y2cl9zGxyUQlsz0K+NAa1vJdReJt1tXOgEGZv2XoF5h2+pFtAbh4HdywmhwDECU4Q6/OHRHbFuQjUsDDRfemx+xxd4SEFsovmWtXyxkphSbxdGqLawGSfV root@devops01.devops.pl' | sudo tee /root/.ssh/authorized_keys

echo 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCjgTEnAmnm+Oq+paehGu1mIyHjWNnoIJC6+KlCsLKwvOyEiHwqtnfPdv6LAGFoRSWmsnHfwHeeZLLJDvO/+WIRApXtEJDn9SGgjZ4oifHxlDuwdm9mA815iAywko/tThIxW122dI3R/Zyu5Jds0qgEAinMaQFpCAHSdsq/lvDzi1EJHulrpCLCL8bVlULj1EZzyfMXQFHjqguB0xEwrPN1rgYCoUjlWLYc52hf00Jlmi6Z4M/wdLhN5AilqlAKc8EOg9LgPLPLUHHbCE+5IVSmFRcaFGGE1TqQon6XWp0oIoS4CA0nn3qAPPT9HyBwa9mn6HkSUo7QtW2R/DaTYbPv d47zm3@asus' | sudo tee -a /root/.ssh/authorized_keys


sudo chmod 600 /root/.ssh/id_rsa
sudo chmod 644 /root/.ssh/id_rsa.pub
sudo chmod 600 /root/.ssh/authorized_keys
sudo sed -i 's/^127.*/127.0.0.1 localhost localhost.localdomain localhost4 localhost4.localdomain4/g' /etc/hosts
echo "192.168.100.101 kubernetes01" | sudo tee -a /etc/hosts
echo "192.168.100.102 kubernetes02" | sudo tee -a /etc/hosts
echo "192.168.100.103 kubernetes03" | sudo tee -a /etc/hosts
ssh-keyscan kubernetes03 | sudo tee -a /root/.ssh/known_hosts
ssh-keyscan kubernetes02 | sudo tee -a /root/.ssh/known_hosts

ln -s -f /usr/share/zoneinfo/Europe/Warsaw /etc/localtime

### Tools & Roles

sudo wget https://raw.githubusercontent.com/d47zm3/vagrant/master/files/.tmux.conf -O /root/.tmux.conf
#sudo yum-config-manager \
#    --add-repo \
#        https://download.docker.com/linux/centos/docker-ce.repo
#sudo yum -y install docker-ce
#sudo systemctl enable docker
#sudo systemctl start docker

sudo yum install -y ntp
sudo systemctl enable ntpd
sudo systemctl start ntpd
echo "[virt7-docker-common-release]
name=virt7-docker-common-release
baseurl=http://cbs.centos.org/repos/virt7-docker-common-release/x86_64/os/
gpgcheck=0" | sudo tee /etc/yum.repos.d/virt7-docker.repo
sudo yum -y update
sudo systemctl stop firewalld
sudo systemctl disable firewalld
#sudo yum -y install --enablerepo=virt7-docker-common-release kubernetes docker
# put config files!
#systemctl enable kube-proxy kubelet docker
#systemctl start kube-proxy kubelet docker

sudo cat <<EOF > /etc/yum.repos.d/kubernetes.repo
[kubernetes]
name=Kubernetes
baseurl=https://packages.cloud.google.com/yum/repos/kubernetes-el7-x86_64
enabled=1
gpgcheck=1
repo_gpgcheck=1
gpgkey=https://packages.cloud.google.com/yum/doc/yum-key.gpg
        https://packages.cloud.google.com/yum/doc/rpm-package-key.gpg
EOF
sudo setenforce 0
sudo yum install -y docker kubelet kubeadm kubectl kubernetes-cni
sudo systemctl enable docker && systemctl start docker
sudo systemctl enable kubelet && systemctl start kubelet
sudo sysctl net.bridge.bridge-nf-call-iptables=1
echo "net.bridge.bridge-nf-call-iptables=1" | tee -a /etc/sysctl.conf

