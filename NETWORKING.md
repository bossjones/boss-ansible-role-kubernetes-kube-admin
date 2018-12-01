# pod-network-cidr? (10.244.0.0/16) - from kubernetes the hard way

```
------------------------------------------------
           TCP/IP NETWORK INFORMATION
------------------------------------------------
IP Entered = ..................: 10.244.0.0
CIDR = ........................: /16
Netmask = .....................: 255.255.0.0
Netmask (hex) = ...............: 0xffff0000
Wildcard Bits = ...............: 0.0.255.255
------------------------------------------------
Network Address = .............: 10.244.0.0
Broadcast Address = ...........: 10.244.255.255
Usable IP Addresses = .........: 65,534
First Usable IP Address = .....: 10.244.0.1
Last Usable IP Address = ......: 10.244.255.254
```



# Machines

* master - 192.168.50.101 ( pod range N/A )
* worker1 - 192.168.50.102 ( pod range 10.32.2.0/24)
* worker2 - 192.168.50.103 ( pod range 10.32.3.0/24)

# Routes to add to each vagrant instance
* master:
    * *worker1:* route add -net 10.32.2.0/24 gw 192.168.50.102
    * *worker2:* route add -net 10.32.3.0/24 gw 192.168.50.103
* worker1:
    * *worker2:* route add -net 10.32.3.0/24 gw 192.168.50.103
* worker2:
    * *worker1:* route add -net 10.32.2.0/24 gw 192.168.50.102

# kubeadm init command:

```
export NODENAME=$(hostname -s)

export _KUBE_VERSION=$(dpkg -l | grep kubeadm | awk '{print $3}' | sed 's,-.*,,g')

kubeadm init --kubernetes-version=$_KUBE_VERSION \
--apiserver-advertise-address=192.168.50.101 \
--pod-network-cidr=10.32.0.0/12 \
--feature-gates=CoreDNS=true \
--node-name $NODENAME \
--service-cidr=10.96.0.0/12 >> cluster_initialized.txt


mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config
```


### our cidr (10.200.0.0/16) aka 10.200.0.1 - 10.200.255.254

The Kubernetes cluster CIDR range is defined by the Controller Manager's --cluster-cidr flag. In this tutorial the cluster CIDR range will be set to 10.200.0.0/16, which supports 254 subnets

```
# CIDR RANGE

------------------------------------------------
           TCP/IP NETWORK INFORMATION
------------------------------------------------
IP Entered = ..................: 10.200.0.0
CIDR = ........................: /16
Netmask = .....................: 255.255.0.0
Netmask (hex) = ...............: 0xffff0000
Wildcard Bits = ...............: 0.0.255.255
------------------------------------------------
Network Address = .............: 10.200.0.0
Broadcast Address = ...........: 10.200.255.255
Usable IP Addresses = .........: 65,534
First Usable IP Address = .....: 10.200.0.1
Last Usable IP Address = ......: 10.200.255.254
```

# master (10.21.0.0/16)

```

------------------------------------------------
           TCP/IP NETWORK INFORMATION
------------------------------------------------
IP Entered = ..................: 10.21.0.0
CIDR = ........................: /16
Netmask = .....................: 255.255.0.0
Netmask (hex) = ...............: 0xffff0000
Wildcard Bits = ...............: 0.0.255.255
------------------------------------------------
Network Address = .............: 10.21.0.0
Broadcast Address = ...........: 10.21.255.255
Usable IP Addresses = .........: 65,534
First Usable IP Address = .....: 10.21.0.1
Last Usable IP Address = ......: 10.21.255.254
```
