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

```
# Pick one DNS add-on: either "kube-dns" or "CoreDNS".  If your environment setup is for "Kubernetes federation" or "SDN-C Geographic Redundancy" then use "CoreDNS" addon.
# Note that kubeadm version 1.8.x does not have support for coredns feature gate.
# Upgrade kubeadm to latest version before running below command:


# on master node run(dry-run)
# With "CoreDNS" addon (recommended)
kubeadm init --apiserver-advertise-address=192.168.50.101 --pod-network-cidr=10.200.0.0/16 --ignore-preflight-errors="all" --feature-gates=CoreDNS=true --dry-run


# Actual run - master node run(dry-run)
# With "CoreDNS" addon (recommended)
kubeadm init --apiserver-advertise-address=192.168.50.101 --pod-network-cidr=10.200.0.0/16 --ignore-preflight-errors="all" --feature-gates=CoreDNS=true >> cluster_initialized.txt
```
