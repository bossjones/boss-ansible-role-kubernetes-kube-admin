### Connect to services from host

`10.32.0.0/24` is the IP range for services. In order to connect to a service
from the host, one of the worker nodes (with `kube-proxy`) must be used as a
gateway. Example:


```
# On Linux
sudo route add -net 10.32.0.0/24 gw 192.168.199.22

# On macOS
sudo route -n add -net 10.32.0.0/24 192.168.199.22
```

Role Name
=========

A brief description of the role goes here.

Requirements
------------

Any pre-requisites that may not be covered by Ansible itself or the role should be mentioned here. For instance, if the role uses the EC2 module, it may be a good idea to mention in this section that the boto package is required.

Role Variables
--------------

A description of the settable variables for this role should go here, including any variables that are in defaults/main.yml, vars/main.yml, and any variables that can/should be set via parameters to the role. Any variables that are read from other roles and/or the global scope (ie. hostvars, group vars, etc.) should be mentioned here as well.

Dependencies
------------

A list of other roles hosted on Galaxy should go here, plus any details in regards to parameters that may need to be set for other roles, or variables that are used from other roles.

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

    - hosts: servers
      roles:
         - { role: boss-ansible-role-kubernetes-kubeadm, x: 42 }

License
-------

Apache

Author Information
------------------

An optional section for the role authors to include contact information, or a website (HTML is not allowed).



# Bootstrap kubernetes master

NOTE: Before attempting to debug anything, look at this!!!!!!!! - https://github.com/weaveworks/weave/issues/3363
NOTE: Before attempting to debug anything, look at this!!!!!!!! - https://github.com/weaveworks/weave/issues/3363
NOTE: Before attempting to debug anything, look at this!!!!!!!! - https://github.com/weaveworks/weave/issues/3363
NOTE: Before attempting to debug anything, look at this!!!!!!!! - https://github.com/weaveworks/weave/issues/3363
NOTE: Before attempting to debug anything, look at this!!!!!!!! - https://github.com/weaveworks/weave/issues/3363
NOTE: Before attempting to debug anything, look at this!!!!!!!! - https://github.com/weaveworks/weave/issues/3363
NOTE: Before attempting to debug anything, look at this!!!!!!!! - https://github.com/weaveworks/weave/issues/3363




### kubeadm pre-reqs

```

# configuring Kubernetes to use the same CGroup driver as Docker:
# SOURCE: https://medium.com/@lizrice/kubernetes-in-vagrant-with-kubeadm-21979ded6c63

sed -i '0,/ExecStart=/s//Environment="KUBELET_EXTRA_ARGS=--cgroup-driver=cgroupfs"\n&/' /etc/systemd/system/kubelet.service.d/10-kubeadm.conf



# TODO: add this to ansible
.... how do we dynamically get this value?

export _DOCKER_CGROUP_DRIVER=$(docker info | grep cgroup | cut -d: -f2 | awk '{print $1}')

echo $_DOCKER_CGROUP_DRIVER

then append it to:

root@master:~# cat /etc/default/kubelet
KUBELET_EXTRA_ARGS=

```

Before:

```
root@master:~# cat /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
# Note: This dropin only works with kubeadm and kubelet v1.11+
[Service]
Environment="KUBELET_KUBECONFIG_ARGS=--bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf"
Environment="KUBELET_CONFIG_ARGS=--config=/var/lib/kubelet/config.yaml"
# This is a file that "kubeadm init" and "kubeadm join" generates at runtime, populating the KUBELET_KUBEADM_ARGS variable dynamically
EnvironmentFile=-/var/lib/kubelet/kubeadm-flags.env
# This is a file that the user can use for overrides of the kubelet args as a last resort. Preferably, the user should use
# the .NodeRegistration.KubeletExtraArgs object in the configuration files instead. KUBELET_EXTRA_ARGS should be sourced from this file.
EnvironmentFile=-/etc/default/kubelet
ExecStart=
ExecStart=/usr/bin/kubelet $KUBELET_KUBECONFIG_ARGS $KUBELET_CONFIG_ARGS $KUBELET_KUBEADM_ARGS $KUBELET_EXTRA_ARGS
```

After(dry run test w/ sed):

```
root@master:~# sed '0,/ExecStart=/s//Environment="KUBELET_EXTRA_ARGS=--cgroup-driver=cgroupfs"\n&/' /etc/systemd/system/kubelet.service.d/10-kubeadm.conf
# Note: This dropin only works with kubeadm and kubelet v1.11+
[Service]
Environment="KUBELET_KUBECONFIG_ARGS=--bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf --kubeconfig=/etc/kubernetes/kubelet.conf"
Environment="KUBELET_CONFIG_ARGS=--config=/var/lib/kubelet/config.yaml"
# This is a file that "kubeadm init" and "kubeadm join" generates at runtime, populating the KUBELET_KUBEADM_ARGS variable dynamically
EnvironmentFile=-/var/lib/kubelet/kubeadm-flags.env
# This is a file that the user can use for overrides of the kubelet args as a last resort. Preferably, the user should use
# the .NodeRegistration.KubeletExtraArgs object in the configuration files instead. KUBELET_EXTRA_ARGS should be sourced from this file.
EnvironmentFile=-/etc/default/kubelet
Environment="KUBELET_EXTRA_ARGS=--cgroup-driver=cgroupfs"
ExecStart=
ExecStart=/usr/bin/kubelet $KUBELET_KUBECONFIG_ARGS $KUBELET_CONFIG_ARGS $KUBELET_KUBEADM_ARGS $KUBELET_EXTRA_ARGS
root@master:~#
```


### kubeadm init

```
# Pick one DNS add-on: either "kube-dns" or "CoreDNS".  If your environment setup is for "Kubernetes federation" or "SDN-C Geographic Redundancy" then use "CoreDNS" addon.
# Note that kubeadm version 1.8.x does not have support for coredns feature gate.
# Upgrade kubeadm to latest version before running below command:

# REMOVED: --pod-network-cidr=10.200.0.0/16
# REMOVED: --ignore-preflight-errors="all"
# on master node run(dry-run)
# With "CoreDNS" addon (recommended)
export NODENAME=$(hostname -s)
export _KUBE_VERSION=$(dpkg -l | grep kubeadm | awk '{print $3}' | sed 's,-.*,,g')
kubeadm init --kubernetes-version=$_KUBE_VERSION --apiserver-advertise-address=192.168.50.101 --pod-network-cidr=10.32.0.0/12 --feature-gates=CoreDNS=true --node-name $NODENAME --service-cidr=10.96.0.0/12 --dry-run

# REMOVED: --pod-network-cidr=10.200.0.0/16
# REMOVED: --ignore-preflight-errors="all"
# Actual run - master node run
# With "CoreDNS" addon (recommended)
export NODENAME=$(hostname -s)
export _KUBE_VERSION=$(dpkg -l | grep kubeadm | awk '{print $3}' | sed 's,-.*,,g')
kubeadm init --kubernetes-version=$_KUBE_VERSION --apiserver-advertise-address=192.168.50.101 --pod-network-cidr=10.32.0.0/12 --feature-gates=CoreDNS=true --node-name $NODENAME --service-cidr=10.96.0.0/12 >> cluster_initialized.txt
```


# Credentials after kubeadm init

```
sudo --user=vagrant mkdir -p /home/vagrant/.kube
cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
chown $(id -u vagrant):$(id -g vagrant) /home/vagrant/.kube/config
```


# install pod network ( vanilla )

```
# SOURCE: https://medium.com/@lizrice/kubernetes-in-vagrant-with-kubeadm-21979ded6c63

kubectl apply -f https://cloud.weave.works/k8s/net?k8s-version=$(kubectl version | base64 | tr -d '\n')
```

# Allow pods to run on the master node

```
kubectl taint nodes --all node-role.kubernetes.io/master-
```



#### DEBUGGING

```

kubeadm join 192.168.50.101:6443 --token df0bih.0prto8apoxwnqn9r --discovery-token-ca-cert-hash sha256:cccb31a6fa6e3cddb62243b3b31c09da46c7df822aebe9b3c019eba1e4693ffc



root@master:~# ip route
default via 10.0.2.2 dev enp0s3
10.0.2.0/24 dev enp0s3  proto kernel  scope link  src 10.0.2.15
172.17.0.0/16 dev docker0  proto kernel  scope link  src 172.17.0.1 linkdown
192.168.50.0/24 dev enp0s8  proto kernel  scope link  src 192.168.50.101
root@master:~#



root@master:~# iptables-save
# Generated by iptables-save v1.6.0 on Fri Nov 30 20:57:11 2018
*nat
:PREROUTING ACCEPT [1:160]
:INPUT ACCEPT [1:160]
:OUTPUT ACCEPT [5:300]
:POSTROUTING ACCEPT [5:300]
:DOCKER - [0:0]
:KUBE-MARK-DROP - [0:0]
:KUBE-MARK-MASQ - [0:0]
:KUBE-NODEPORTS - [0:0]
:KUBE-POSTROUTING - [0:0]
:KUBE-SEP-4LVENGRQPIZXECUW - [0:0]
:KUBE-SERVICES - [0:0]
:KUBE-SVC-NPX46M4PTMTKRN6Y - [0:0]
-A PREROUTING -m comment --comment "kubernetes service portals" -j KUBE-SERVICES
-A PREROUTING -m addrtype --dst-type LOCAL -j DOCKER
-A OUTPUT -m comment --comment "kubernetes service portals" -j KUBE-SERVICES
-A OUTPUT ! -d 127.0.0.0/8 -m addrtype --dst-type LOCAL -j DOCKER
-A POSTROUTING -m comment --comment "kubernetes postrouting rules" -j KUBE-POSTROUTING
-A POSTROUTING -s 172.17.0.0/16 ! -o docker0 -j MASQUERADE
-A DOCKER -i docker0 -j RETURN
-A KUBE-MARK-DROP -j MARK --set-xmark 0x8000/0x8000
-A KUBE-MARK-MASQ -j MARK --set-xmark 0x4000/0x4000
-A KUBE-POSTROUTING -m comment --comment "kubernetes service traffic requiring SNAT" -m mark --mark 0x4000/0x4000 -j MASQUERADE
-A KUBE-SEP-4LVENGRQPIZXECUW -s 192.168.50.101/32 -m comment --comment "default/kubernetes:https" -j KUBE-MARK-MASQ
-A KUBE-SEP-4LVENGRQPIZXECUW -p tcp -m comment --comment "default/kubernetes:https" -m tcp -j DNAT --to-destination 192.168.50.101:6443
-A KUBE-SERVICES ! -s 10.32.0.0/12 -d 10.96.0.1/32 -p tcp -m comment --comment "default/kubernetes:https cluster IP" -m tcp --dport 443 -j KUBE-MARK-MASQ
-A KUBE-SERVICES -d 10.96.0.1/32 -p tcp -m comment --comment "default/kubernetes:https cluster IP" -m tcp --dport 443 -j KUBE-SVC-NPX46M4PTMTKRN6Y
-A KUBE-SERVICES -m comment --comment "kubernetes service nodeports; NOTE: this must be the last rule in this chain" -m addrtype --dst-type LOCAL -j KUBE-NODEPORTS
-A KUBE-SVC-NPX46M4PTMTKRN6Y -m comment --comment "default/kubernetes:https" -j KUBE-SEP-4LVENGRQPIZXECUW
COMMIT
# Completed on Fri Nov 30 20:57:11 2018
# Generated by iptables-save v1.6.0 on Fri Nov 30 20:57:11 2018
*filter
:INPUT ACCEPT [4782:2266005]
:FORWARD DROP [0:0]
:OUTPUT ACCEPT [4773:2274861]
:DOCKER - [0:0]
:DOCKER-ISOLATION-STAGE-1 - [0:0]
:DOCKER-ISOLATION-STAGE-2 - [0:0]
:DOCKER-USER - [0:0]
:KUBE-EXTERNAL-SERVICES - [0:0]
:KUBE-FIREWALL - [0:0]
:KUBE-FORWARD - [0:0]
:KUBE-SERVICES - [0:0]
-A INPUT -m conntrack --ctstate NEW -m comment --comment "kubernetes externally-visible service portals" -j KUBE-EXTERNAL-SERVICES
-A INPUT -j KUBE-FIREWALL
-A FORWARD -m comment --comment "kubernetes forwarding rules" -j KUBE-FORWARD
-A FORWARD -j DOCKER-USER
-A FORWARD -j DOCKER-ISOLATION-STAGE-1
-A FORWARD -o docker0 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A FORWARD -o docker0 -j DOCKER
-A FORWARD -i docker0 ! -o docker0 -j ACCEPT
-A FORWARD -i docker0 -o docker0 -j ACCEPT
-A OUTPUT -m conntrack --ctstate NEW -m comment --comment "kubernetes service portals" -j KUBE-SERVICES
-A OUTPUT -j KUBE-FIREWALL
-A DOCKER-ISOLATION-STAGE-1 -i docker0 ! -o docker0 -j DOCKER-ISOLATION-STAGE-2
-A DOCKER-ISOLATION-STAGE-1 -j RETURN
-A DOCKER-ISOLATION-STAGE-2 -o docker0 -j DROP
-A DOCKER-ISOLATION-STAGE-2 -j RETURN
-A DOCKER-USER -j RETURN
-A KUBE-FIREWALL -m comment --comment "kubernetes firewall for dropping marked packets" -m mark --mark 0x8000/0x8000 -j DROP
-A KUBE-FORWARD -m comment --comment "kubernetes forwarding rules" -m mark --mark 0x4000/0x4000 -j ACCEPT
-A KUBE-FORWARD -s 10.32.0.0/12 -m comment --comment "kubernetes forwarding conntrack pod source rule" -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A KUBE-FORWARD -d 10.32.0.0/12 -m comment --comment "kubernetes forwarding conntrack pod destination rule" -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
-A KUBE-SERVICES -d 10.96.0.10/32 -p udp -m comment --comment "kube-system/kube-dns:dns has no endpoints" -m udp --dport 53 -j REJECT --reject-with icmp-port-unreachable
-A KUBE-SERVICES -d 10.96.0.10/32 -p tcp -m comment --comment "kube-system/kube-dns:dns-tcp has no endpoints" -m tcp --dport 53 -j REJECT --reject-with icmp-port-unreachable
COMMIT
# Completed on Fri Nov 30 20:57:11 2018
root@master:~#
```
