for instance in kubernetes-worker-01 kubernetes-worker-02 kubernetes-worker-03; do
  scp ${instance}.kubeconfig kube-proxy.kubeconfig root@${instance}:~/
done

for instance in kubernetes-master-01 kubernetes-master-02 kubernetes-master-03; do
  scp admin.kubeconfig kube-controller-manager.kubeconfig kube-scheduler.kubeconfig root@${instance}:~/
done
