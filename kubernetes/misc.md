# Important Object Types

## Pod:

- a single container or a set of containers colocated on the same host

- unit of replication in K8s (i.e. pods are replicated)

- multi-container pods often used for e.g. one container for the
  application, one for monitoring or metrics instrumentation

- since all containers in a pod will be co-located on the same host,
  they can e.g. mount the same local volume or connect to each other's
  open TCP ports via 127.0.0.1

- spec contains essentially a sequence of container specs, where each
  container spec contains an image reference and optional run
  parameters. Spec may also include declarative health check
  specifications to determine when the pod is to be considered "up".


## Deployment:

- used for deploying, replicating and upgrading a set of identical
  pods

- parameterized with, essentially, a pod specification and a replica
  count

- will ensure that that many instances of the pod are running at all
  times. If a pod that belongs to a deployment disappears,
  e.g. because of a node going down, a new instance will be spun up
  somewhere to replace it.

- upgrades: If the image reference of the pod specification of a
  running deployment is changed, all pods of that deployment will be
  upgraded to that new image in a "rolling update" scheme, i.e. one
  after the other while ensuring that each new pod came up
  successfully before continuing with the next one. If a pod upgrade
  fails, the pod will be marked offline, and the deployment will
  ensure that a minimum amount of "old" pods (containing the
  pre-upgrade image ref) are kept running
  
  There is a special "undo" API/kubectl command for reverting the
  deployment to its pre-update state


## Service:

- a load balancer-like kind of thing that exposes a bunch of pods
  behind one IP address inside the cluster (that address is then
  called the service's "cluster IP") and potentially to the outside
  too

- parameterized with a label selector selecting the pods to expose,
  and a specification for how/where (which IPs and inside/outside the
  cluster) to expose it

- usually abstracts away some kind of service behind one or more TCP
  ports on one IP, with the the service being implemented by the pods
  that belong to the service object at runtime (i.e. the pods that are
  selected by the service's label selector)

- if the service currently selects more than one pod, access to the
  service's clusterIP:port is load-balanced to those pods

- alternatively, the service may also encapsulate an external service,
  running in another namespace or entirely outside the cluster

- if kube-dns is running, the cluster IP of a service is also exposed
  via DNS under <servicename>.<namespace> or (to resources in the same
  <namespace>) just <servicename>

  - there are also DNS "SRV" records which also hold the port numbers

  - as an alternative to DNS, the cluster IP and port(s) are also
    exposed in environment variables

- the service may be exposed to the outside, e.g. if the service is a
  web frontend layer

  - this can work either via an integration with the load balancing
    service of the platform k8s is running on (e.g. AWS or OpenStack),
    or via a "NodePort" -- a TCP port (or multiple ones) that's
    exposed externally on all nodes of the cluster and will be routed
    to the service's cluster IP

- you can configure a service to be "headless", in which case there
  will be no cluster (or external) IP, and the DNS record will contain
  the IPs of all the pods that make up the service


## ConfigMap:

http://kubernetes.io/docs/user-guide/configmap/

Arbitrary data structures stored in k8s's DB. Can then be referenced
when injecting values into env variables for containers.



```
$ pods=$(kubectl get pods --selector=app=nginx --output=jsonpath={.items..metadata.name})
echo $pods
nginx-3ntk0 nginx-4ok8v nginx-qrm3m
```


[[http://kubernetes.io/docs/user-guide/replication-controller/#rolling-updates]]


```
$ kubectl --namespace=webhwtest run lbtest --image=haproxy:1.7.1 -ti  --command=true -- /bin/bash
Waiting for pod webhwtest/lbtest-237870868-3b12r to be running, status is Pending, pod ready: false
If you don't see a command prompt, try pressing enter.
root@lbtest-237870868-3b12r:/#
```





# API authentification, authorization

Usually SSL w/ client cert.

No "users" concept


```
          "kube-apiserver",
          "--insecure-bind-address=127.0.0.1",
          "--admission-control=NamespaceLifecycle,LimitRanger,ServiceAccount,PersistentVolumeLabel,DefaultStorageClass,ResourceQuota",
          "--service-cluster-ip-range=10.96.0.0/12",
          "--service-account-key-file=/etc/kubernetes/pki/apiserver-key.pem",
          "--client-ca-file=/etc/kubernetes/pki/ca.pem",
          "--tls-cert-file=/etc/kubernetes/pki/apiserver.pem",
          "--tls-private-key-file=/etc/kubernetes/pki/apiserver-key.pem",
          "--token-auth-file=/etc/kubernetes/pki/tokens.csv",
          "--secure-port=6443",
          "--allow-privileged",
          "--advertise-address=10.0.4.6",
          "--kubelet-preferred-address-types=InternalIP,ExternalIP,Hostname",
          "--anonymous-auth=false",
          "--etcd-servers=http://127.0.0.1:2379"
```



information and events delivered INTO containers:

http://kubernetes.io/docs/user-guide/container-environment/

http://kubernetes.io/docs/user-guide/downward-api/


- information: via environment variables

  - set directly or eg. via ConfigMaps (see below)

- information: via volume mounts

- events: via hooks (e.g. postStart, preStop)


