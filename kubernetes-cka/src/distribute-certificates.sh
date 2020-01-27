for instance in kubernetes-worker-01 kubernetes-worker-02 kubernetes-worker-03; do
  scp ca.pem ${instance}-key.pem ${instance}.pem root@${instance}:~/
done

for instance in kubernetes-master-01 kubernetes-master-02 kubernetes-master-03; do
  scp ca.pem ca-key.pem kubernetes-key.pem kubernetes.pem service-account-key.pem service-account.pem root@${instance}:~/
done
