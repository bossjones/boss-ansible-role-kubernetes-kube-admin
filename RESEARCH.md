# vagrant, dns, and kubernetes google search

https://www.google.com/search?ei=qogDXLGTEMeijwT9wb3ABA&q=vagrant+%22cluster.local%22&oq=vagrant+%22cluster.local%22&gs_l=psy-ab.3...2596.6015..6330...0.0..0.464.464.4-1......0....1..gws-wiz.AlI7x6CkUKA

Search: vagrant "cluster.local"

* [YO THIS IS THE ONE !!!!!!!!!! OpenShift / K8s : DNS Configuration Explained](http://www.ksingh.co.in/blog/2017/10/04/openshift-dns-configuration-explained/)

* [wildcard DNS in localhost development dnsmasq dnsmasq_setup_osx](https://gist.github.com/eloypnd/5efc3b590e7c738630fdcf0c10b68072)

* [How To Inspect Kubernetes Networking](https://www.digitalocean.com/community/tutorials/how-to-inspect-kubernetes-networking)

* [Configure DNS Wildcard with Dnsmasq Service](https://qiita.com/bmj0114/items/9c24d863bcab1a634503)

* [How to setup wildcard dev domains with dnsmasq on a mac](https://hedichaibi.com/how-to-setup-wildcard-dev-domains-with-dnsmasq-on-a-mac/)

* https://medium.com/@joatmon08/playing-with-kubeadm-in-vagrant-machines-36598b5e8408

* https://medium.com/@joatmon08/playing-with-kubeadm-in-vagrant-machines-part-2-bac431095706

* https://medium.com/@joatmon08/application-logging-in-kubernetes-with-fluentd-4556f1573672

* [FUN WITH KUBERNETES DNS](http://www.akins.org/posts/fun-with-dns/)

* https://rsmitty.github.io/KubeDNS-Tweaks/

* https://github.com/letsencrypt/boulder

* [How To Set Up an Elasticsearch, Fluentd and Kibana (EFK) Logging Stack on Kubernetes](https://www.digitalocean.com/community/tutorials/how-to-set-up-an-elasticsearch-fluentd-and-kibana-efk-logging-stack-on-kubernetes)

* [An Introduction to the Kubernetes DNS Service](https://www.digitalocean.com/community/tutorials/an-introduction-to-the-kubernetes-dns-service)

# changing the kublet configuration

SOURCE: https://medium.com/@joatmon08/playing-with-kubeadm-in-vagrant-machines-part-2-bac431095706

```
$ less /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
[Service]
Environment="KUBELET_KUBECONFIG_ARGS=--bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf"
Environment="KUBELET_SYSTEM_PODS_ARGS=--pod-manifest-path=/etc/kubernetes/manifests --allow-privileged=true"
Environment="KUBELET_NETWORK_ARGS=--network-plugin=cni --cni-conf-dir=/etc/cni/net.d --cni-bin-dir=/opt/cni/bin"
Environment="KUBELET_DNS_ARGS=--cluster-dns=10.96.0.10 --cluster-domain=cluster.local"
Environment="KUBELET_AUTHZ_ARGS=--authorization-mode=Webhook --client-ca-file=/etc/kubernetes/pki/ca.crt"
Environment="KUBELET_CADVISOR_ARGS=--cadvisor-port=0"
Environment="KUBELET_CGROUP_ARGS=--cgroup-driver=systemd"
Environment="KUBELET_CERTIFICATE_ARGS=--rotate-certificates=true --cert-dir=/var/lib/kubelet/pki"
Environment="KUBELET_EXTRA_ARGS=--node-ip=<worker IP address>"
ExecStart=
ExecStart=/usr/bin/kubelet $KUBELET_KUBECONFIG_ARGS $KUBELET_SYSTEM_PODS_ARGS $KUBELET_NETWORK_ARGS $KUBELET_DNS_ARGS $KUBELET_AUTHZ_ARGS $KUBELET_CADVISOR_ARGS $KUBELET_CGROUP_ARGS $KUBELET_CERTIFICATE_ARGS $KUBELET_EXTRA_ARGS
```



# K8 components

SOURCE: https://rafishaikblog.wordpress.com/2017/10/17/kubernetes-cluster-with-vagrant-virtual-box/

```
etcd – A highly available key-value store for shared configuration and service discovery.
flannel – An etcd backed network fabric for containers.
kube-apiserver – Provides the API for Kubernetes orchestration.
kube-controller-manager – Enforces Kubernetes services.
kube-scheduler – Schedules containers on hosts.
kubelet – Processes a container manifest so the containers are launched according to how they are described.
kube-proxy – Provides network proxy services.
```


```
root@master:/etc/default# cat /proc/5109/environ
LANG=en_US.UTF-8PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/binKUBELET_KUBECONFIG_ARGS=--bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.confKUBELET_CONFIG_ARGS=--config=/var/lib/kubelet/config.yamlKUBELET_EXTRA_ARGS=KUBELET_KUBEADM_ARGS=--cgroup-driver=cgroupfs --cni-bin-dir=/opt/cni/bin --cni-conf-dir=/etc/cni/net.d --network-plugin=cniroot@master:/etc/default#

```
