for instance in kubernetes-master-01 kubernetes-master-02 kubernetes-master-03; do
  scp encryption-config.yaml root@${instance}:~/
done
