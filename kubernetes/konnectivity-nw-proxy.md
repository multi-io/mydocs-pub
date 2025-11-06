# Konnectivity Network Proxy

* used for enabling K8s apiserver to connect to node network (e.g. for kubectl logs/exec or for invoking webhook services) when control plane and nodes are on different networks

* consists of Konnectivity agent in the cluster, Konnectivity server in the control plane

* Konnectivity server usually co-located with the apiserver, connected to it via Unix domain socket

* agent establishes TCP/TLS connection to the server, then waits for requests (grpc)

* apiserver tracks the Konnectivity server, knows when it has connection to an agent

* when apiserver receives a request like "kubectl logs", it sends a corresponding request through the Konnectivity server to the agent, which execites it in the cluster network and sends back the result

## What if apiserver consists of multiple instances behind a single load balancer IP?

* assuming each apiserver has its own Konnectivity server

* must ensure that each agent establishes a connection to each Konnectivity server (otherwise, if a Konnectivity has no agent connection, its apiserver instance wouldn't be able to process kubectl logs/exec etc. request, and would reject them with "No agent available")

* problem: the clients only see the LB and don't know how many api/konnectivity servers are behind it

every agent opens a connection to every server (exactly one connection per server).

It ensures this as follows:

* every server instance is started with --server-id=<unique ID, defaults to uuid generated @startup> and --server-count=<total server count>
  so every server knows its own unique ID and knows how many servers there are in total

  * administrator must ensure to run the Konnectivity servers with the correct --server-count, and must update & restart them when the repica count changes

* every agent does this:

(see pkg/agent/clientset.go / func (cs *ClientSet) sync())

// repeat endlessly
for {
    connect to server, receiving server's ID and the server count during connection establishment
    if we don't have a connection to this server ID yet {
        start serving requests on this connection asynchronously in the background;
        sleep --sync-interval (default 1s)
    } else if we HAVE a connection to this server ID already {
        close this newly created connection again
        increase sleep time by one step using exponential backoff algorithm, starting an --sync-interval, capped at --sync-interval-cap;
        sleep ^^that long
    }
}



Example: startup of an agent with 4 servers:

```
I1106 04:36:54.253973       1 options.go:151] AgentCert set to "".
I1106 04:36:54.254063       1 options.go:152] AgentKey set to "".
I1106 04:36:54.254067       1 options.go:153] CACert set to "/var/run/secrets/kubernetes.io/serviceaccount/ca.crt".
I1106 04:36:54.254071       1 options.go:154] ProxyServerHost set to "dbs577nkft.dus2-1.metakube.syseleven.de".
I1106 04:36:54.254075       1 options.go:155] ProxyServerPort set to 30881.
I1106 04:36:54.254079       1 options.go:156] ALPNProtos set to [].
I1106 04:36:54.254085       1 options.go:157] HealthServerHost set to
I1106 04:36:54.254092       1 options.go:158] HealthServerPort set to 8093.
I1106 04:36:54.254097       1 options.go:159] Admin bind address set to "127.0.0.1".
I1106 04:36:54.254124       1 options.go:160] AdminServerPort set to 8094.
I1106 04:36:54.254129       1 options.go:161] EnableProfiling set to false.
I1106 04:36:54.254135       1 options.go:162] EnableContentionProfiling set to false.
I1106 04:36:54.254155       1 options.go:163] AgentID set to 9618a24e-172c-40b8-93a3-0ed77f8de1c7.
I1106 04:36:54.254166       1 options.go:164] SyncInterval set to 1s.
I1106 04:36:54.254184       1 options.go:165] ProbeInterval set to 1s.
I1106 04:36:54.254194       1 options.go:166] SyncIntervalCap set to 10s.
I1106 04:36:54.254201       1 options.go:167] Keepalive time set to 50s.
I1106 04:36:54.254209       1 options.go:168] ServiceAccountTokenPath set to "/var/run/secrets/tokens/system-konnectivity-agent-token".
I1106 04:36:54.254224       1 options.go:169] AgentIdentifiers set to .
I1106 04:36:54.254233       1 options.go:170] WarnOnChannelLimit set to false.
I1106 04:36:54.254240       1 options.go:171] SyncForever set to true.
I1106 04:36:54.254246       1 options.go:172] CountServerLeases set to false.
I1106 04:36:54.254256       1 options.go:173] LeaseNamespace set to kube-system.
I1106 04:36:54.254264       1 options.go:174] LeaseLabel set to k8s-app=konnectivity-server.
I1106 04:36:54.254274       1 options.go:175] ServerCountSource set to default.
I1106 04:36:54.254282       1 options.go:176] ChannelSize set to 150.
I1106 04:36:54.254296       1 options.go:177] APIContentType set to application/vnd.kubernetes.protobuf.

### connecting client to first
I1106 04:36:54.267489       1 client.go:214] "Connect to server" serverID="b415a512-2011-408e-a073-73f41fc86c96"
I1106 04:36:54.267551       1 clientset.go:308] "sync added client connecting to proxy server" serverID="b415a512-2011-408e-a073-73f41fc86c96"
I1106 04:36:54.267678       1 client.go:325] "Start serving" serverID="b415a512-2011-408e-a073-73f41fc86c96" agentID="9618a24e-172c-40b8-93a3-0ed77f8de1c7"
W1106 04:36:55.330058       1 clientset.go:285] change detected in proxy server count (was: 0, now: 4, source: "KNP server response headers")

### connecting client to second server
I1106 04:36:55.357667       1 client.go:214] "Connect to server" serverID="c12fc149-a473-4ad4-8299-c57e877cb1f0"
I1106 04:36:55.357775       1 clientset.go:308] "sync added client connecting to proxy server" serverID="c12fc149-a473-4ad4-8299-c57e877cb1f0"
I1106 04:36:55.358040       1 client.go:325] "Start serving" serverID="c12fc149-a473-4ad4-8299-c57e877cb1f0" agentID="9618a24e-172c-40b8-93a3-0ed77f8de1c7"

### connecting client to third server
I1106 04:36:56.419176       1 client.go:214] "Connect to server" serverID="deaee72f-f305-472c-b7f9-73cfd0402faa"
I1106 04:36:56.419204       1 clientset.go:308] "sync added client connecting to proxy server" serverID="deaee72f-f305-472c-b7f9-73cfd0402faa"
I1106 04:36:56.419237       1 client.go:325] "Start serving" serverID="deaee72f-f305-472c-b7f9-73cfd0402faa" agentID="9618a24e-172c-40b8-93a3-0ed77f8de1c7"

### connecting client to fourth server
I1106 04:36:57.445350       1 client.go:214] "Connect to server" serverID="147f35d9-e011-45e5-96cc-fb25ca04ed86"
I1106 04:36:57.445386       1 clientset.go:308] "sync added client connecting to proxy server" serverID="147f35d9-e011-45e5-96cc-fb25ca04ed86"
I1106 04:36:57.445419       1 client.go:325] "Start serving" serverID="147f35d9-e011-45e5-96cc-fb25ca04ed86" agentID="9618a24e-172c-40b8-93a3-0ed77f8de1c7"

### starting to receive and process requests from the servers
I1106 04:36:58.496471       1 client.go:214] "Connect to server" serverID="c12fc149-a473-4ad4-8299-c57e877cb1f0"
I1106 04:36:59.564175       1 client.go:214] "Connect to server" serverID="147f35d9-e011-45e5-96cc-fb25ca04ed86"
I1106 04:37:01.143999       1 client.go:214] "Connect to server" serverID="b415a512-2011-408e-a073-73f41fc86c96"
I1106 04:37:03.449485       1 client.go:214] "Connect to server" serverID="deaee72f-f305-472c-b7f9-73cfd0402faa"
I1106 04:37:06.979898       1 client.go:214] "Connect to server" serverID="deaee72f-f305-472c-b7f9-73cfd0402faa"
I1106 04:37:12.368833       1 client.go:214] "Connect to server" serverID="b415a512-2011-408e-a073-73f41fc86c96"
I1106 04:37:20.493384       1 client.go:214] "Connect to server" serverID="147f35d9-e011-45e5-96cc-fb25ca04ed86"

### processing "DIAL_REQ" requests -- in this case HTTP requests to some metrics ports on pods in the cluster, proxied through the apiserver
I1106 04:37:24.063676       1 client.go:371] "Received DIAL_REQ" serverID="c12fc149-a473-4ad4-8299-c57e877cb1f0" agentID="9618a24e-172c-40b8-93a3-0ed77f8de1c7" dialID=8318227834692348949 dialAddress="192.168.1.73:9962"
I1106 04:37:24.065049       1 client.go:446] "Endpoint connection established" dialID=8318227834692348949 connectionID=1 dialAddress="192.168.1.73:9962"
I1106 04:37:25.012048       1 client.go:371] "Received DIAL_REQ" serverID="c12fc149-a473-4ad4-8299-c57e877cb1f0" agentID="9618a24e-172c-40b8-93a3-0ed77f8de1c7" dialID=1475923470520355011 dialAddress="10.240.27.240:443"
I1106 04:37:25.013291       1 client.go:446] "Endpoint connection established" dialID=2631096103208240061 connectionID=3 dialAddress="10.240.27.240:443"
I1106 04:37:25.017230       1 client.go:446] "Endpoint connection established" dialID=1475923470520355011 connectionID=2 dialAddress="10.240.27.240:443"
```


