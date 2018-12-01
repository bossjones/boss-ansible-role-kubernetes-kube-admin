# bash_history from master run

```

root@master:~# history
    1  exit
    2  journalctl -f | ccze -A
    3  exit
    4  docker-clean () {     docker rm $(docker ps -a -q);     docker rmi $(docker images | grep "^<none>" | awk '{print $3}'); }
    5  docker-clean
    6  clear
    7  ip a
    8  clear
    9  ip route
   10  ls /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
   11  cat /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
   12  cat /etc/sysctl.conf
   13  clear
   14  cat /etc/sysctl.d/99-sysctl.conf
   15  ls -lta /etc/sysctl.d/
   16  cat /etc/sysctl.conf
   17  uptime
   18  sysctl -a | grep forwarding | grep ipv4
   19  export NODENAME=$(hostname -s)
   20  export _KUBE_VERSION=$(dpkg -l | grep kubeadm | awk '{print $3}' | sed 's,-.*,,g')
   21  kubeadm init --kubernetes-version=$_KUBE_VERSION --apiserver-advertise-address=192.168.50.101 --pod-network-cidr=10.32.0.0/12 --feature-gates=CoreDNS=true --node-name $NODENAME --service-cidr=10.96.0.0/12 >> cluster_initialized.txt
   22  cat cluster_initialized.txt
   23  cat /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
   24  systemctl cat kubelet.service
   25  clear
   26  systemctl cat kubelet.service
   27  ls /etc/systemd/system/kubelet.service.d/20-kubelet-node-ip.conf
   28  cat /etc/systemd/system/kubelet.service.d/20-kubelet-node-ip.conf
   29  clear
   30  systemctl cat kubelet.service
   31  systemctl daemon-reload
   32  systemctl restart kubelet.service
   33  systemctl cat kubelet.service
   34  clear
   35  systemctl cat kubelet.service
   36  ls /etc/systemd/system/kubelet.service.d/20-kubelet-node-ip.conf
   37  ls -lta /etc/systemd/system/kubelet.service.d/20-kubelet-node-ip.conf
   38  cat /etc/systemd/system/kubelet.service.d/20-kubelet-node-ip.conf
   39  systemd-delta --type=extended
   40  systemctl daemon-reload
   41  ps aux | grep kube
   42  ps aux | grep kubelet
   43  clear
   44  ps aux | grep kubelet
   45  clear
   46  route add -net 10.32.2.0/24 gw 192.168.50.102
   47  route add -net 10.32.3.0/24 gw 192.168.50.103
   48  route
   49  kubectl version | base64 | tr -d '\n'
   50  dpkg -l | grep kube
   51  clear
   52  kubectl apply -f https://cloud.weave.works/k8s/net?k8s-version=v1.11.5&env.IPALLOC_RANGE=10.32.0.0/12
   53  fg
   54  clear
   55  kubectl apply -f 'https://cloud.weave.works/k8s/net?k8s-version=v1.11.5&env.IPALLOC_RANGE=10.32.0.0/12'
   56  kubectl get pods --all-namespaces -o wide
   57  iptables -nvL
   58  clear
   59  journalctl -f -u kubelet.service
   60  journalctl -f -u kubelet.service | ccze -A
   61  clear
   62  shutdown -r now
   63  journalctl -f | ccze -A
   64  exit
   65  clear
   66  kubectl get pods --all-namespaces -o wide
   67  kubectl get clusterrolebinding --all-namespaces
   68  clear
   69  netstat -an
   70  netstat -tunpl
   71  curl 127.0.0.0.1:4538
   72  curl localhost:4538
   73  apt-cache search libnfsidmap
   74  which sysdig
   75  which rust
   76  which cargo
   77  docker ps | grep etcd
   78  netstat -tunpl | grep 2379
   79  ls -lta /etc/kubernetes/pki/
   80  cat /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
   81  cat /etc/systemd/system/kubelet.service.d/10-kubeadm.conf | grep domain
   82  ls /var/lib/cni
   83  clear
   84  history
root@master:~#
```
