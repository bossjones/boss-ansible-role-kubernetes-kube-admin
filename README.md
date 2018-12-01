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


# on master node run(dry-run)
# With "CoreDNS" addon (recommended)
export NODENAME=$(hostname -s)
kubeadm init --apiserver-advertise-address=192.168.50.101 --pod-network-cidr=10.200.0.0/16 --ignore-preflight-errors="all" --feature-gates=CoreDNS=true --node-name $NODENAME --dry-run


# Actual run - master node run
# With "CoreDNS" addon (recommended)
export NODENAME=$(hostname -s)
kubeadm init --apiserver-advertise-address=192.168.50.101 --pod-network-cidr=10.200.0.0/16 --ignore-preflight-errors="all" --feature-gates=CoreDNS=true --node-name $NODENAME >> cluster_initialized.txt
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
