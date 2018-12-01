# ip route before adding any additional routes (master)

```
root@master:~# ip route
default via 10.0.2.2 dev enp0s3
10.0.2.0/24 dev enp0s3  proto kernel  scope link  src 10.0.2.15
172.17.0.0/16 dev docker0  proto kernel  scope link  src 172.17.0.1 linkdown
192.168.50.0/24 dev enp0s8  proto kernel  scope link  src 192.168.50.101
root@master:~#
```





# kubeadm master --dry-run

```
root@master:~# kubeadm init --apiserver-advertise-address=192.168.50.101  --ignore-preflight-errors="all" --dry-run



[init] using Kubernetes version: v1.11.5
[preflight] running pre-flight checks
I1130 18:34:28.832482   31969 kernel_validator.go:81] Validating kernel version
I1130 18:34:28.832791   31969 kernel_validator.go:96] Validating kernel config
        [WARNING SystemVerification]: docker version is greater than the most recently validated version. Docker version: 18.06.1-ce. Max validated version: 17.03
[preflight/images] Would pull the required images (like 'kubeadm config images pull')
[kubelet] Writing kubelet environment file with flags to file "/tmp/kubeadm-init-dryrun206105032/kubeadm-flags.env"
[kubelet] Writing kubelet configuration to file "/tmp/kubeadm-init-dryrun206105032/config.yaml"
[certificates] Generated ca certificate and key.
[certificates] Generated apiserver certificate and key.
[certificates] apiserver serving cert is signed for DNS names [master kubernetes kubernetes.default kubernetes.default.svc kubernetes.default.svc.cluster.local] and IPs [10.96.0.1 192.168.50.101]
[certificates] Generated apiserver-kubelet-client certificate and key.
[certificates] Generated sa key and public key.
[certificates] Generated front-proxy-ca certificate and key.
[certificates] Generated front-proxy-client certificate and key.
[certificates] Generated etcd/ca certificate and key.
[certificates] Generated etcd/server certificate and key.
[certificates] etcd/server serving cert is signed for DNS names [master localhost] and IPs [127.0.0.1 ::1]
[certificates] Generated etcd/peer certificate and key.
[certificates] etcd/peer serving cert is signed for DNS names [master localhost] and IPs [192.168.50.101 127.0.0.1 ::1]
[certificates] Generated etcd/healthcheck-client certificate and key.
[certificates] Generated apiserver-etcd-client certificate and key.
[certificates] valid certificates and keys now exist in "/tmp/kubeadm-init-dryrun206105032"
[kubeconfig] Wrote KubeConfig file to disk: "/tmp/kubeadm-init-dryrun206105032/admin.conf"
[kubeconfig] Wrote KubeConfig file to disk: "/tmp/kubeadm-init-dryrun206105032/kubelet.conf"
[kubeconfig] Wrote KubeConfig file to disk: "/tmp/kubeadm-init-dryrun206105032/controller-manager.conf"
[kubeconfig] Wrote KubeConfig file to disk: "/tmp/kubeadm-init-dryrun206105032/scheduler.conf"
[controlplane] wrote Static Pod manifest for component kube-apiserver to "/tmp/kubeadm-init-dryrun206105032/kube-apiserver.yaml"
[controlplane] wrote Static Pod manifest for component kube-controller-manager to "/tmp/kubeadm-init-dryrun206105032/kube-controller-manager.yaml"
[controlplane] wrote Static Pod manifest for component kube-scheduler to "/tmp/kubeadm-init-dryrun206105032/kube-scheduler.yaml"
[etcd] Wrote Static Pod manifest for a local etcd instance to "/tmp/kubeadm-init-dryrun206105032/etcd.yaml"
[dryrun] wrote certificates, kubeconfig files and control plane manifests to the "/tmp/kubeadm-init-dryrun206105032" directory
[dryrun] the certificates or kubeconfig files would not be printed due to their sensitive nature
[dryrun] please examine the "/tmp/kubeadm-init-dryrun206105032" directory for details about what would be written
[dryrun] Would write file "/etc/kubernetes/manifests/kube-apiserver.yaml" with content:
        apiVersion: v1
        kind: Pod
        metadata:
          annotations:
            scheduler.alpha.kubernetes.io/critical-pod: ""
          creationTimestamp: null
          labels:
            component: kube-apiserver
            tier: control-plane
          name: kube-apiserver
          namespace: kube-system
        spec:
          containers:
          - command:
            - kube-apiserver
            - --authorization-mode=Node,RBAC
            - --advertise-address=192.168.50.101
            - --allow-privileged=true
            - --client-ca-file=/etc/kubernetes/pki/ca.crt
            - --disable-admission-plugins=PersistentVolumeLabel
            - --enable-admission-plugins=NodeRestriction
            - --enable-bootstrap-token-auth=true
            - --etcd-cafile=/etc/kubernetes/pki/etcd/ca.crt
            - --etcd-certfile=/etc/kubernetes/pki/apiserver-etcd-client.crt
            - --etcd-keyfile=/etc/kubernetes/pki/apiserver-etcd-client.key
            - --etcd-servers=https://127.0.0.1:2379
            - --insecure-port=0
            - --kubelet-client-certificate=/etc/kubernetes/pki/apiserver-kubelet-client.crt
            - --kubelet-client-key=/etc/kubernetes/pki/apiserver-kubelet-client.key
            - --kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname
            - --proxy-client-cert-file=/etc/kubernetes/pki/front-proxy-client.crt
            - --proxy-client-key-file=/etc/kubernetes/pki/front-proxy-client.key
            - --requestheader-allowed-names=front-proxy-client
            - --requestheader-client-ca-file=/etc/kubernetes/pki/front-proxy-ca.crt
            - --requestheader-extra-headers-prefix=X-Remote-Extra-
            - --requestheader-group-headers=X-Remote-Group
            - --requestheader-username-headers=X-Remote-User
            - --secure-port=6443
            - --service-account-key-file=/etc/kubernetes/pki/sa.pub
            - --service-cluster-ip-range=10.96.0.0/12
            - --tls-cert-file=/etc/kubernetes/pki/apiserver.crt
            - --tls-private-key-file=/etc/kubernetes/pki/apiserver.key
            image: k8s.gcr.io/kube-apiserver-amd64:v1.11.5
            imagePullPolicy: IfNotPresent
            livenessProbe:
              failureThreshold: 8
              httpGet:
                host: 192.168.50.101
                path: /healthz
                port: 6443
                scheme: HTTPS
              initialDelaySeconds: 15
              timeoutSeconds: 15
            name: kube-apiserver
            resources:
              requests:
                cpu: 250m
            volumeMounts:
            - mountPath: /usr/local/share/ca-certificates
              name: usr-local-share-ca-certificates
              readOnly: true
            - mountPath: /etc/ca-certificates
              name: etc-ca-certificates
              readOnly: true
            - mountPath: /etc/kubernetes/pki
              name: k8s-certs
              readOnly: true
            - mountPath: /etc/ssl/certs
              name: ca-certs
              readOnly: true
            - mountPath: /usr/share/ca-certificates
              name: usr-share-ca-certificates
              readOnly: true
          hostNetwork: true
          priorityClassName: system-cluster-critical
          volumes:
          - hostPath:
              path: /etc/kubernetes/pki
              type: DirectoryOrCreate
            name: k8s-certs
          - hostPath:
              path: /etc/ssl/certs
              type: DirectoryOrCreate
            name: ca-certs
          - hostPath:
              path: /usr/share/ca-certificates
              type: DirectoryOrCreate
            name: usr-share-ca-certificates
          - hostPath:
              path: /usr/local/share/ca-certificates
              type: DirectoryOrCreate
            name: usr-local-share-ca-certificates
          - hostPath:
              path: /etc/ca-certificates
              type: DirectoryOrCreate
            name: etc-ca-certificates
        status: {}
[dryrun] Would write file "/etc/kubernetes/manifests/kube-controller-manager.yaml" with content:
        apiVersion: v1
        kind: Pod
        metadata:
          annotations:
            scheduler.alpha.kubernetes.io/critical-pod: ""
          creationTimestamp: null
          labels:
            component: kube-controller-manager
            tier: control-plane
          name: kube-controller-manager
          namespace: kube-system
        spec:
          containers:
          - command:
            - kube-controller-manager
            - --address=127.0.0.1
            - --cluster-signing-cert-file=/etc/kubernetes/pki/ca.crt
            - --cluster-signing-key-file=/etc/kubernetes/pki/ca.key
            - --controllers=*,bootstrapsigner,tokencleaner
            - --kubeconfig=/etc/kubernetes/controller-manager.conf
            - --leader-elect=true
            - --root-ca-file=/etc/kubernetes/pki/ca.crt
            - --service-account-private-key-file=/etc/kubernetes/pki/sa.key
            - --use-service-account-credentials=true
            image: k8s.gcr.io/kube-controller-manager-amd64:v1.11.5
            imagePullPolicy: IfNotPresent
            livenessProbe:
              failureThreshold: 8
              httpGet:
                host: 127.0.0.1
                path: /healthz
                port: 10252
                scheme: HTTP
              initialDelaySeconds: 15
              timeoutSeconds: 15
            name: kube-controller-manager
            resources:
              requests:
                cpu: 200m
            volumeMounts:
            - mountPath: /etc/kubernetes/pki
              name: k8s-certs
              readOnly: true
            - mountPath: /etc/ssl/certs
              name: ca-certs
              readOnly: true
            - mountPath: /etc/kubernetes/controller-manager.conf
              name: kubeconfig
              readOnly: true
            - mountPath: /usr/libexec/kubernetes/kubelet-plugins/volume/exec
              name: flexvolume-dir
            - mountPath: /usr/share/ca-certificates
              name: usr-share-ca-certificates
              readOnly: true
            - mountPath: /usr/local/share/ca-certificates
              name: usr-local-share-ca-certificates
              readOnly: true
            - mountPath: /etc/ca-certificates
              name: etc-ca-certificates
              readOnly: true
          hostNetwork: true
          priorityClassName: system-cluster-critical
          volumes:
          - hostPath:
              path: /etc/kubernetes/controller-manager.conf
              type: FileOrCreate
            name: kubeconfig
          - hostPath:
              path: /usr/libexec/kubernetes/kubelet-plugins/volume/exec
              type: DirectoryOrCreate
            name: flexvolume-dir
          - hostPath:
              path: /usr/share/ca-certificates
              type: DirectoryOrCreate
            name: usr-share-ca-certificates
          - hostPath:
              path: /usr/local/share/ca-certificates
              type: DirectoryOrCreate
            name: usr-local-share-ca-certificates
          - hostPath:
              path: /etc/ca-certificates
              type: DirectoryOrCreate
            name: etc-ca-certificates
          - hostPath:
              path: /etc/kubernetes/pki
              type: DirectoryOrCreate
            name: k8s-certs
          - hostPath:
              path: /etc/ssl/certs
              type: DirectoryOrCreate
            name: ca-certs
        status: {}
[dryrun] Would write file "/etc/kubernetes/manifests/kube-scheduler.yaml" with content:
        apiVersion: v1
        kind: Pod
        metadata:
          annotations:
            scheduler.alpha.kubernetes.io/critical-pod: ""
          creationTimestamp: null
          labels:
            component: kube-scheduler
            tier: control-plane
          name: kube-scheduler
          namespace: kube-system
        spec:
          containers:
          - command:
            - kube-scheduler
            - --address=127.0.0.1
            - --kubeconfig=/etc/kubernetes/scheduler.conf
            - --leader-elect=true
            image: k8s.gcr.io/kube-scheduler-amd64:v1.11.5
            imagePullPolicy: IfNotPresent
            livenessProbe:
              failureThreshold: 8
              httpGet:
                host: 127.0.0.1
                path: /healthz
                port: 10251
                scheme: HTTP
              initialDelaySeconds: 15
              timeoutSeconds: 15
            name: kube-scheduler
            resources:
              requests:
                cpu: 100m
            volumeMounts:
            - mountPath: /etc/kubernetes/scheduler.conf
              name: kubeconfig
              readOnly: true
          hostNetwork: true
          priorityClassName: system-cluster-critical
          volumes:
          - hostPath:
              path: /etc/kubernetes/scheduler.conf
              type: FileOrCreate
            name: kubeconfig
        status: {}
[dryrun] Would write file "/var/lib/kubelet/config.yaml" with content:
        address: 0.0.0.0
        apiVersion: kubelet.config.k8s.io/v1beta1
        authentication:
          anonymous:
            enabled: false
          webhook:
            cacheTTL: 2m0s
            enabled: true
          x509:
            clientCAFile: /etc/kubernetes/pki/ca.crt
        authorization:
          mode: Webhook
          webhook:
            cacheAuthorizedTTL: 5m0s
            cacheUnauthorizedTTL: 30s
        cgroupDriver: cgroupfs
        cgroupsPerQOS: true
        clusterDNS:
        - 10.96.0.10
        clusterDomain: cluster.local
        containerLogMaxFiles: 5
        containerLogMaxSize: 10Mi
        contentType: application/vnd.kubernetes.protobuf
        cpuCFSQuota: true
        cpuManagerPolicy: none
        cpuManagerReconcilePeriod: 10s
        enableControllerAttachDetach: true
        enableDebuggingHandlers: true
        enforceNodeAllocatable:
        - pods
        eventBurst: 10
        eventRecordQPS: 5
        evictionHard:
          imagefs.available: 15%
          memory.available: 100Mi
          nodefs.available: 10%
          nodefs.inodesFree: 5%
        evictionPressureTransitionPeriod: 5m0s
        failSwapOn: true
        fileCheckFrequency: 20s
        hairpinMode: promiscuous-bridge
        healthzBindAddress: 127.0.0.1
        healthzPort: 10248
        httpCheckFrequency: 20s
        imageGCHighThresholdPercent: 85
        imageGCLowThresholdPercent: 80
        imageMinimumGCAge: 2m0s
        iptablesDropBit: 15
        iptablesMasqueradeBit: 14
        kind: KubeletConfiguration
        kubeAPIBurst: 10
        kubeAPIQPS: 5
        makeIPTablesUtilChains: true
        maxOpenFiles: 1000000
        maxPods: 110
        nodeStatusUpdateFrequency: 10s
        oomScoreAdj: -999
        podPidsLimit: -1
        port: 10250
        registryBurst: 10
        registryPullQPS: 5
        resolvConf: /etc/resolv.conf
        rotateCertificates: true
        runtimeRequestTimeout: 2m0s
        serializeImagePulls: true
        staticPodPath: /etc/kubernetes/manifests
        streamingConnectionIdleTimeout: 4h0m0s
        syncFrequency: 1m0s
        volumeStatsAggPeriod: 1m0s
[dryrun] Would write file "/var/lib/kubelet/kubeadm-flags.env" with content:
        KUBELET_KUBEADM_ARGS=--cgroup-driver=cgroupfs --cni-bin-dir=/opt/cni/bin --cni-conf-dir=/etc/cni/net.d --network-plugin=cni
[init] waiting for the kubelet to boot up the control plane as Static Pods from directory "/etc/kubernetes/manifests"
[init] this might take a minute or longer if the control plane images have to be pulled
[dryrun] Would wait for the API Server's /healthz endpoint to return 'ok'
[dryrun] Would make sure the kubelet "http://localhost:10248/healthz" endpoint is healthy
[uploadconfig] storing the configuration used in ConfigMap "kubeadm-config" in the "kube-system" Namespace
[dryrun] Would perform action CREATE on resource "configmaps" in API group "core/v1"
[dryrun] Attached object:
        apiVersion: v1
        data:
          MasterConfiguration: |
            api:
              advertiseAddress: 192.168.50.101
              bindPort: 6443
              controlPlaneEndpoint: ""
            apiServerExtraArgs:
              authorization-mode: Node,RBAC
            apiVersion: kubeadm.k8s.io/v1alpha2
            auditPolicy:
              logDir: /var/log/kubernetes/audit
              logMaxAge: 2
              path: ""
            certificatesDir: /tmp/kubeadm-init-dryrun206105032
            clusterName: kubernetes
            etcd:
              local:
                dataDir: /var/lib/etcd
                image: ""
            imageRepository: k8s.gcr.io
            kind: MasterConfiguration
            kubeProxy:
              config:
                bindAddress: 0.0.0.0
                clientConnection:
                  acceptContentTypes: ""
                  burst: 10
                  contentType: application/vnd.kubernetes.protobuf
                  kubeconfig: /var/lib/kube-proxy/kubeconfig.conf
                  qps: 5
                clusterCIDR: ""
                configSyncPeriod: 15m0s
                conntrack:
                  max: null
                  maxPerCore: 32768
                  min: 131072
                  tcpCloseWaitTimeout: 1h0m0s
                  tcpEstablishedTimeout: 24h0m0s
                enableProfiling: false
                healthzBindAddress: 0.0.0.0:10256
                hostnameOverride: ""
                iptables:
                  masqueradeAll: false
                  masqueradeBit: 14
                  minSyncPeriod: 0s
                  syncPeriod: 30s
                ipvs:
                  excludeCIDRs: null
                  minSyncPeriod: 0s
                  scheduler: ""
                  syncPeriod: 30s
                metricsBindAddress: 127.0.0.1:10249
                mode: ""
                nodePortAddresses: null
                oomScoreAdj: -999
                portRange: ""
                resourceContainer: /kube-proxy
                udpIdleTimeout: 250ms
            kubeletConfiguration:
              baseConfig:
                address: 0.0.0.0
                authentication:
                  anonymous:
                    enabled: false
                  webhook:
                    cacheTTL: 2m0s
                    enabled: true
                  x509:
                    clientCAFile: /etc/kubernetes/pki/ca.crt
                authorization:
                  mode: Webhook
                  webhook:
                    cacheAuthorizedTTL: 5m0s
                    cacheUnauthorizedTTL: 30s
                cgroupDriver: cgroupfs
                cgroupsPerQOS: true
                clusterDNS:
                - 10.96.0.10
                clusterDomain: cluster.local
                containerLogMaxFiles: 5
                containerLogMaxSize: 10Mi
                contentType: application/vnd.kubernetes.protobuf
                cpuCFSQuota: true
                cpuManagerPolicy: none
                cpuManagerReconcilePeriod: 10s
                enableControllerAttachDetach: true
                enableDebuggingHandlers: true
                enforceNodeAllocatable:
                - pods
                eventBurst: 10
                eventRecordQPS: 5
                evictionHard:
                  imagefs.available: 15%
                  memory.available: 100Mi
                  nodefs.available: 10%
                  nodefs.inodesFree: 5%
                evictionPressureTransitionPeriod: 5m0s
                failSwapOn: true
                fileCheckFrequency: 20s
                hairpinMode: promiscuous-bridge
                healthzBindAddress: 127.0.0.1
                healthzPort: 10248
                httpCheckFrequency: 20s
                imageGCHighThresholdPercent: 85
                imageGCLowThresholdPercent: 80
                imageMinimumGCAge: 2m0s
                iptablesDropBit: 15
                iptablesMasqueradeBit: 14
                kubeAPIBurst: 10
                kubeAPIQPS: 5
                makeIPTablesUtilChains: true
                maxOpenFiles: 1000000
                maxPods: 110
                nodeStatusUpdateFrequency: 10s
                oomScoreAdj: -999
                podPidsLimit: -1
                port: 10250
                registryBurst: 10
                registryPullQPS: 5
                resolvConf: /etc/resolv.conf
                rotateCertificates: true
                runtimeRequestTimeout: 2m0s
                serializeImagePulls: true
                staticPodPath: /etc/kubernetes/manifests
                streamingConnectionIdleTimeout: 4h0m0s
                syncFrequency: 1m0s
                volumeStatsAggPeriod: 1m0s
            kubernetesVersion: v1.11.5
            networking:
              dnsDomain: cluster.local
              podSubnet: ""
              serviceSubnet: 10.96.0.0/12
            nodeRegistration: {}
            unifiedControlPlaneImage: ""
        kind: ConfigMap
        metadata:
          creationTimestamp: null
          name: kubeadm-config
          namespace: kube-system
[kubelet] Creating a ConfigMap "kubelet-config-1.11" in namespace kube-system with the configuration for the kubelets in the cluster
[dryrun] Would perform action CREATE on resource "configmaps" in API group "core/v1"
[dryrun] Attached object:
        apiVersion: v1
        data:
          kubelet: |
            address: 0.0.0.0
            apiVersion: kubelet.config.k8s.io/v1beta1
            authentication:
              anonymous:
                enabled: false
              webhook:
                cacheTTL: 2m0s
                enabled: true
              x509:
                clientCAFile: /etc/kubernetes/pki/ca.crt
            authorization:
              mode: Webhook
              webhook:
                cacheAuthorizedTTL: 5m0s
                cacheUnauthorizedTTL: 30s
            cgroupDriver: cgroupfs
            cgroupsPerQOS: true
            clusterDNS:
            - 10.96.0.10
            clusterDomain: cluster.local
            containerLogMaxFiles: 5
            containerLogMaxSize: 10Mi
            contentType: application/vnd.kubernetes.protobuf
            cpuCFSQuota: true
            cpuManagerPolicy: none
            cpuManagerReconcilePeriod: 10s
            enableControllerAttachDetach: true
            enableDebuggingHandlers: true
            enforceNodeAllocatable:
            - pods
            eventBurst: 10
            eventRecordQPS: 5
            evictionHard:
              imagefs.available: 15%
              memory.available: 100Mi
              nodefs.available: 10%
              nodefs.inodesFree: 5%
            evictionPressureTransitionPeriod: 5m0s
            failSwapOn: true
            fileCheckFrequency: 20s
            hairpinMode: promiscuous-bridge
            healthzBindAddress: 127.0.0.1
            healthzPort: 10248
            httpCheckFrequency: 20s
            imageGCHighThresholdPercent: 85
            imageGCLowThresholdPercent: 80
            imageMinimumGCAge: 2m0s
            iptablesDropBit: 15
            iptablesMasqueradeBit: 14
            kind: KubeletConfiguration
            kubeAPIBurst: 10
            kubeAPIQPS: 5
            makeIPTablesUtilChains: true
            maxOpenFiles: 1000000
            maxPods: 110
            nodeStatusUpdateFrequency: 10s
            oomScoreAdj: -999
            podPidsLimit: -1
            port: 10250
            registryBurst: 10
            registryPullQPS: 5
            resolvConf: /etc/resolv.conf
            rotateCertificates: true
            runtimeRequestTimeout: 2m0s
            serializeImagePulls: true
            staticPodPath: /etc/kubernetes/manifests
            streamingConnectionIdleTimeout: 4h0m0s
            syncFrequency: 1m0s
            volumeStatsAggPeriod: 1m0s
        kind: ConfigMap
        metadata:
          creationTimestamp: null
          name: kubelet-config-1.11
          namespace: kube-system
[dryrun] Would perform action CREATE on resource "roles" in API group "rbac.authorization.k8s.io/v1"
[dryrun] Attached object:
        apiVersion: rbac.authorization.k8s.io/v1
        kind: Role
        metadata:
          creationTimestamp: null
          name: kubeadm:kubelet-config-1.11
          namespace: kube-system
        rules:
        - apiGroups:
          - ""
          resourceNames:
          - kubelet-config-1.11
          resources:
          - configmaps
          verbs:
          - get
[dryrun] Would perform action CREATE on resource "rolebindings" in API group "rbac.authorization.k8s.io/v1"
[dryrun] Attached object:
        apiVersion: rbac.authorization.k8s.io/v1
        kind: RoleBinding
        metadata:
          creationTimestamp: null
          name: kubeadm:kubelet-config-1.11
          namespace: kube-system
        roleRef:
          apiGroup: rbac.authorization.k8s.io
          kind: Role
          name: kubeadm:kubelet-config-1.11
        subjects:
        - kind: Group
          name: system:nodes
        - kind: Group
          name: system:bootstrappers:kubeadm:default-node-token
[markmaster] Marking the node master as master by adding the label "node-role.kubernetes.io/master=''"
[markmaster] Marking the node master as master by adding the taints [node-role.kubernetes.io/master:NoSchedule]
[dryrun] Would perform action GET on resource "nodes" in API group "core/v1"
[dryrun] Resource name: "master"
[dryrun] Would perform action PATCH on resource "nodes" in API group "core/v1"
[dryrun] Resource name: "master"
[dryrun] Attached patch:
        {"metadata":{"labels":{"node-role.kubernetes.io/master":""}},"spec":{"taints":[{"effect":"NoSchedule","key":"node-role.kubernetes.io/master"}]}}
[patchnode] Uploading the CRI Socket information "/var/run/dockershim.sock" to the Node API object "master" as an annotation
[dryrun] Would perform action GET on resource "nodes" in API group "core/v1"
[dryrun] Resource name: "master"
[dryrun] Would perform action PATCH on resource "nodes" in API group "core/v1"
[dryrun] Resource name: "master"
[dryrun] Attached patch:
        {"metadata":{"annotations":{"kubeadm.alpha.kubernetes.io/cri-socket":"/var/run/dockershim.sock"}}}
[bootstraptoken] using token: 6p9ya8.4cz7a59o6608lutk
[dryrun] Would perform action GET on resource "secrets" in API group "core/v1"
[dryrun] Resource name: "bootstrap-token-6p9ya8"
[dryrun] Would perform action CREATE on resource "secrets" in API group "core/v1"
[dryrun] Attached object:
        apiVersion: v1
        data:
          auth-extra-groups: c3lzdGVtOmJvb3RzdHJhcHBlcnM6a3ViZWFkbTpkZWZhdWx0LW5vZGUtdG9rZW4=
          description: VGhlIGRlZmF1bHQgYm9vdHN0cmFwIHRva2VuIGdlbmVyYXRlZCBieSAna3ViZWFkbSBpbml0Jy4=
          expiration: MjAxOC0xMi0wMVQxODozNDozNC0wNTowMA==
          token-id: NnA5eWE4
          token-secret: NGN6N2E1OW82NjA4bHV0aw==
          usage-bootstrap-authentication: dHJ1ZQ==
          usage-bootstrap-signing: dHJ1ZQ==
        kind: Secret
        metadata:
          creationTimestamp: null
          name: bootstrap-token-6p9ya8
          namespace: kube-system
        type: bootstrap.kubernetes.io/token
[bootstraptoken] configured RBAC rules to allow Node Bootstrap tokens to post CSRs in order for nodes to get long term certificate credentials
[dryrun] Would perform action CREATE on resource "clusterrolebindings" in API group "rbac.authorization.k8s.io/v1"
[dryrun] Attached object:
        apiVersion: rbac.authorization.k8s.io/v1
        kind: ClusterRoleBinding
        metadata:
          creationTimestamp: null
          name: kubeadm:kubelet-bootstrap
        roleRef:
          apiGroup: rbac.authorization.k8s.io
          kind: ClusterRole
          name: system:node-bootstrapper
        subjects:
        - kind: Group
          name: system:bootstrappers:kubeadm:default-node-token
[bootstraptoken] configured RBAC rules to allow the csrapprover controller automatically approve CSRs from a Node Bootstrap Token
[dryrun] Would perform action CREATE on resource "clusterrolebindings" in API group "rbac.authorization.k8s.io/v1"
[dryrun] Attached object:
        apiVersion: rbac.authorization.k8s.io/v1
        kind: ClusterRoleBinding
        metadata:
          creationTimestamp: null
          name: kubeadm:node-autoapprove-bootstrap
        roleRef:
          apiGroup: rbac.authorization.k8s.io
          kind: ClusterRole
          name: system:certificates.k8s.io:certificatesigningrequests:nodeclient
        subjects:
        - kind: Group
          name: system:bootstrappers:kubeadm:default-node-token
[bootstraptoken] configured RBAC rules to allow certificate rotation for all node client certificates in the cluster
[dryrun] Would perform action CREATE on resource "clusterrolebindings" in API group "rbac.authorization.k8s.io/v1"
[dryrun] Attached object:
        apiVersion: rbac.authorization.k8s.io/v1
        kind: ClusterRoleBinding
        metadata:
          creationTimestamp: null
          name: kubeadm:node-autoapprove-certificate-rotation
        roleRef:
          apiGroup: rbac.authorization.k8s.io
          kind: ClusterRole
          name: system:certificates.k8s.io:certificatesigningrequests:selfnodeclient
        subjects:
        - kind: Group
          name: system:nodes
[bootstraptoken] creating the "cluster-info" ConfigMap in the "kube-public" namespace
[dryrun] Would perform action CREATE on resource "configmaps" in API group "core/v1"
[dryrun] Attached object:
        apiVersion: v1
        data:
          kubeconfig: |
            apiVersion: v1
            clusters:
            - cluster:
                certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJQ0FURS0tLS0tCk1JSUN5RENDQWJDZ0F3SUJBZ0lCQURBTkJna3Foa2lHOXcwQkFRc0ZBREFWTVJNd0VRWURWUVFERXdwcmRXSmwKY201bGRHVnpNQjRYRFRFNE1URXpNREl6TXpReU9Wb1hEVEk0TVRFeU56SXpNelF5T1Zvd0ZURVRNQkVHQTFVRQpBeE1LYTNWaVpYSnVaWFJsY3pDQ0FTSXdEUVlKS29aSWh2Y05BUUVCQlFBRGdnRVBBRENDQVFvQ2dnRUJBS1lICmFlcVFlUnA0VlRHMStHVlZSZU94cThqZEJyR1RYY0ZOS3pnMlpVQkVjSS9IUURaMXp3cnMrNXdjR0xvc1RhUDUKdlRIOEl2cndHNExjWEx6ZWk2RFFHcTlpenZmNjdKYWp4QlRSOXROR0ZjYXFNT005RmFkaWhNNk82ZUJHNjhVVQppVVdVd09tbExOR2UzaHI0ZnczYjNqeEhkbnN6YTdMYUp4T0dJSGZzNG9xZWtEOHFwWG5BUlNNWjJ6aG9QbW9zCkwxM0tRNllHUzVBRXJ1KzZFaEl4UEJGTVFXbExlUTExN29mYWFWVUUvcWh0OENNTXZBdUFJa1p0ZnJFUW1WdU0KbUNNMkdzRzVxbVV0bzFQQ0Q0MVA5T3JYZG1XYi9XOUFWRmZaMCtaYTRHNUw1UWZqRDlDaWYrMnNwdm1USGdJbQovb2JPcFI3RGthTHExTGdDcTBjQ0F3RUFBYU1qTUNFd0RnWURWUjBQQVFIL0JBUURBZ0trTUE4R0ExVWRFd0VCCi93UUZNQU1CQWY4d0RRWUpLb1pJaHZjTkFRRUxCUUFEZ2dFQkFLRWI0UXJwUjR4Y05hMkhEYXNISm12K1JuOEoKNHNKWUo1czJsVUJkV25xQ2xBRDJHMllMenhaaThicTM3QnVtVzFwejhHWG1qZkdpbGEwemkyVTkwdTMvSVV4bgo1bU9UZDF4VEkwMExpNjBUelgwWFZvTzN2c1drTklvQzRqY2JENnJSVWR2c2taUmVoSUlLS3FKVC9XVGJiQ3B2CmNQYW9LY0hQUGxOd1VvRG5sTklkT2x0VWJMMUptUFRtMTgxVnVZKzBXV3dQeGdrZmo0WWZMNFpkNTFuSTlTK24KWVpZNlhlZ0dnY0M4UXZSY2JJTUt1YTBUb1dJU01mWXdMOXpKbTh4c0dZeUxxZVF5SUxOL2JnTVBDY2JFWUZCMApkNUo5dVQ4TmY1RWUzTGdPd0xFNGdHSENOSzlHWWtDSmxLWWZoTWxCWFV2WE9IVnJnc0dUb1E5T1VzWT0KLS0tLS1FTkQgQ0VSVElGSUNBVEUtLS0tLQo=
                server: https://192.168.50.101:6443
              name: ""
            contexts: []
            current-context: ""
            kind: Config
            preferences: {}
            users: []
        kind: ConfigMap
        metadata:
          creationTimestamp: null
          name: cluster-info
          namespace: kube-public
[dryrun] Would perform action CREATE on resource "roles" in API group "rbac.authorization.k8s.io/v1"
[dryrun] Attached object:
        apiVersion: rbac.authorization.k8s.io/v1
        kind: Role
        metadata:
          creationTimestamp: null
          name: kubeadm:bootstrap-signer-clusterinfo
          namespace: kube-public
        rules:
        - apiGroups:
          - ""
          resourceNames:
          - cluster-info
          resources:
          - configmaps
          verbs:
          - get
[dryrun] Would perform action CREATE on resource "rolebindings" in API group "rbac.authorization.k8s.io/v1"
[dryrun] Attached object:
        apiVersion: rbac.authorization.k8s.io/v1
        kind: RoleBinding
        metadata:
          creationTimestamp: null
          name: kubeadm:bootstrap-signer-clusterinfo
          namespace: kube-public
        roleRef:
          apiGroup: rbac.authorization.k8s.io
          kind: Role
          name: kubeadm:bootstrap-signer-clusterinfo
        subjects:
        - kind: User
          name: system:anonymous
[dryrun] Would perform action GET on resource "configmaps" in API group "core/v1"
[dryrun] Resource name: "kube-dns"
[dryrun] Would perform action GET on resource "configmaps" in API group "core/v1"
[dryrun] Resource name: "coredns"
[dryrun] Would perform action CREATE on resource "configmaps" in API group "core/v1"
[dryrun] Attached object:
        apiVersion: v1
        data:
          Corefile: ".:53 {\n    errors\n    health\n    kubernetes cluster.local in-addr.arpa
            ip6.arpa {\n       pods insecure\n       upstream\n       fallthrough in-addr.arpa
            ip6.arpa\n    }\n    prometheus :9153\n    proxy . \n    cache 30\n    reload\n}\n"
        kind: ConfigMap
        metadata:
          creationTimestamp: null
          name: coredns
          namespace: kube-system
[dryrun] Would perform action CREATE on resource "clusterroles" in API group "rbac.authorization.k8s.io/v1"
[dryrun] Attached object:
        apiVersion: rbac.authorization.k8s.io/v1
        kind: ClusterRole
        metadata:
          creationTimestamp: null
          name: system:coredns
        rules:
        - apiGroups:
          - ""
          resources:
          - endpoints
          - services
          - pods
          - namespaces
          verbs:
          - list
          - watch
[dryrun] Would perform action CREATE on resource "clusterrolebindings" in API group "rbac.authorization.k8s.io/v1"
[dryrun] Attached object:
        apiVersion: rbac.authorization.k8s.io/v1
        kind: ClusterRoleBinding
        metadata:
          creationTimestamp: null
          name: system:coredns
        roleRef:
          apiGroup: rbac.authorization.k8s.io
          kind: ClusterRole
          name: system:coredns
        subjects:
        - kind: ServiceAccount
          name: coredns
          namespace: kube-system
[dryrun] Would perform action CREATE on resource "serviceaccounts" in API group "core/v1"
[dryrun] Attached object:
        apiVersion: v1
        kind: ServiceAccount
        metadata:
          creationTimestamp: null
          name: coredns
          namespace: kube-system
[dryrun] Would perform action CREATE on resource "deployments" in API group "apps/v1"
[dryrun] Attached object:
        apiVersion: apps/v1
        kind: Deployment
        metadata:
          creationTimestamp: null
          labels:
            k8s-app: kube-dns
          name: coredns
          namespace: kube-system
        spec:
          replicas: 2
          selector:
            matchLabels:
              k8s-app: kube-dns
          strategy:
            rollingUpdate:
              maxUnavailable: 1
            type: RollingUpdate
          template:
            metadata:
              creationTimestamp: null
              labels:
                k8s-app: kube-dns
            spec:
              containers:
              - args:
                - -conf
                - /etc/coredns/Corefile
                image: k8s.gcr.io/coredns:1.1.3
                imagePullPolicy: IfNotPresent
                livenessProbe:
                  failureThreshold: 5
                  httpGet:
                    path: /health
                    port: 8080
                    scheme: HTTP
                  initialDelaySeconds: 60
                  successThreshold: 1
                  timeoutSeconds: 5
                name: coredns
                ports:
                - containerPort: 53
                  name: dns
                  protocol: UDP
                - containerPort: 53
                  name: dns-tcp
                  protocol: TCP
                - containerPort: 9153
                  name: metrics
                  protocol: TCP
                resources:
                  limits:
                    memory: 170Mi
                  requests:
                    cpu: 100m
                    memory: 70Mi
                securityContext:
                  allowPrivilegeEscalation: false
                  capabilities:
                    add:
                    - NET_BIND_SERVICE
                    drop:
                    - all
                  readOnlyRootFilesystem: true
                volumeMounts:
                - mountPath: /etc/coredns
                  name: config-volume
                  readOnly: true
              dnsPolicy: Default
              serviceAccountName: coredns
              tolerations:
              - key: CriticalAddonsOnly
                operator: Exists
              - effect: NoSchedule
                key: node-role.kubernetes.io/master
              volumes:
              - configMap:
                  items:
                  - key: Corefile
                    path: Corefile
                  name: coredns
                name: config-volume
        status: {}
[dryrun] Would perform action CREATE on resource "services" in API group "core/v1"
[dryrun] Attached object:
        apiVersion: v1
        kind: Service
        metadata:
          annotations:
            prometheus.io/port: "9153"
            prometheus.io/scrape: "true"
          creationTimestamp: null
          labels:
            k8s-app: kube-dns
            kubernetes.io/cluster-service: "true"
            kubernetes.io/name: KubeDNS
          name: kube-dns
          namespace: kube-system
          resourceVersion: "0"
        spec:
          clusterIP: 10.96.0.10
          ports:
          - name: dns
            port: 53
            protocol: UDP
            targetPort: 53
          - name: dns-tcp
            port: 53
            protocol: TCP
            targetPort: 53
          selector:
            k8s-app: kube-dns
        status:
          loadBalancer: {}
[addons] Applied essential addon: CoreDNS
[dryrun] Would perform action CREATE on resource "serviceaccounts" in API group "core/v1"
[dryrun] Attached object:
        apiVersion: v1
        kind: ServiceAccount
        metadata:
          creationTimestamp: null
          name: kube-proxy
          namespace: kube-system
[dryrun] Would perform action CREATE on resource "configmaps" in API group "core/v1"
[dryrun] Attached object:
        apiVersion: v1
        data:
          config.conf: |-
            apiVersion: kubeproxy.config.k8s.io/v1alpha1
            bindAddress: 0.0.0.0
            clientConnection:
              acceptContentTypes: ""
              burst: 10
              contentType: application/vnd.kubernetes.protobuf
              kubeconfig: /var/lib/kube-proxy/kubeconfig.conf
              qps: 5
            clusterCIDR: ""
            configSyncPeriod: 15m0s
            conntrack:
              max: null
              maxPerCore: 32768
              min: 131072
              tcpCloseWaitTimeout: 1h0m0s
              tcpEstablishedTimeout: 24h0m0s
            enableProfiling: false
            healthzBindAddress: 0.0.0.0:10256
            hostnameOverride: ""
            iptables:
              masqueradeAll: false
              masqueradeBit: 14
              minSyncPeriod: 0s
              syncPeriod: 30s
            ipvs:
              excludeCIDRs: null
              minSyncPeriod: 0s
              scheduler: ""
              syncPeriod: 30s
            kind: KubeProxyConfiguration
            metricsBindAddress: 127.0.0.1:10249
            mode: ""
            nodePortAddresses: null
            oomScoreAdj: -999
            portRange: ""
            resourceContainer: /kube-proxy
            udpIdleTimeout: 250ms
          kubeconfig.conf: |-
            apiVersion: v1
            kind: Config
            clusters:
            - cluster:
                certificate-authority: /var/run/secrets/kubernetes.io/serviceaccount/ca.crt
                server: https://192.168.50.101:6443
              name: default
            contexts:
            - context:
                cluster: default
                namespace: default
                user: default
              name: default
            current-context: default
            users:
            - name: default
              user:
                tokenFile: /var/run/secrets/kubernetes.io/serviceaccount/token
        kind: ConfigMap
        metadata:
          creationTimestamp: null
          labels:
            app: kube-proxy
          name: kube-proxy
          namespace: kube-system
[dryrun] Would perform action CREATE on resource "daemonsets" in API group "apps/v1"
[dryrun] Attached object:
        apiVersion: apps/v1
        kind: DaemonSet
        metadata:
          creationTimestamp: null
          labels:
            k8s-app: kube-proxy
          name: kube-proxy
          namespace: kube-system
        spec:
          selector:
            matchLabels:
              k8s-app: kube-proxy
          template:
            metadata:
              annotations:
                scheduler.alpha.kubernetes.io/critical-pod: ""
              creationTimestamp: null
              labels:
                k8s-app: kube-proxy
            spec:
              containers:
              - command:
                - /usr/local/bin/kube-proxy
                - --config=/var/lib/kube-proxy/config.conf
                image: k8s.gcr.io/kube-proxy-amd64:v1.11.5
                imagePullPolicy: IfNotPresent
                name: kube-proxy
                resources: {}
                securityContext:
                  privileged: true
                volumeMounts:
                - mountPath: /var/lib/kube-proxy
                  name: kube-proxy
                - mountPath: /run/xtables.lock
                  name: xtables-lock
                - mountPath: /lib/modules
                  name: lib-modules
                  readOnly: true
              hostNetwork: true
              nodeSelector:
                beta.kubernetes.io/arch: amd64
              priorityClassName: system-node-critical
              serviceAccountName: kube-proxy
              tolerations:
              - key: CriticalAddonsOnly
                operator: Exists
              - operator: Exists
              volumes:
              - configMap:
                  name: kube-proxy
                name: kube-proxy
              - hostPath:
                  path: /run/xtables.lock
                  type: FileOrCreate
                name: xtables-lock
              - hostPath:
                  path: /lib/modules
                name: lib-modules
          updateStrategy:
            type: RollingUpdate
        status:
          currentNumberScheduled: 0
          desiredNumberScheduled: 0
          numberMisscheduled: 0
          numberReady: 0
[dryrun] Would perform action CREATE on resource "clusterrolebindings" in API group "rbac.authorization.k8s.io/v1"
[dryrun] Attached object:
        apiVersion: rbac.authorization.k8s.io/v1
        kind: ClusterRoleBinding
        metadata:
          creationTimestamp: null
          name: kubeadm:node-proxier
        roleRef:
          apiGroup: rbac.authorization.k8s.io
          kind: ClusterRole
          name: system:node-proxier
        subjects:
        - kind: ServiceAccount
          name: kube-proxy
          namespace: kube-system
[addons] Applied essential addon: kube-proxy
[dryrun] finished dry-running successfully. Above are the resources that would be created
root@master:~#
```
