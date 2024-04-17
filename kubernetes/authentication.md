# Authentication

Authentication (performed by the API server) associates the following
pieces of information with each incoming request:

- username (string)

- uid (string) (optional?)

- groups (set of strings)

- extra fields (map string=>string[]) (optional)

That's all there is; users or groups aren't API objects.

Apiserver delegates authentication to *authenticator modules*(?). At
least two should always be enabled: service account tokens (for
service accounts), and one or more user authentication methods
(todo/see below).

Authenticator modules invoked in random order, authentication
succeeds after the first module has succeeded.

Available authenticator modules: 

## Client Cert

Apiserver started with `--client-ca-file=SOMECA.pem` => any clients
must connect via TLS using certificate signed by `SOMECA.pem` (which
must be a bundle file, containing the CA certificate and private
key). Client certificate's common name becomes the username,
Organization fields become group names.


## Static Token File

Apiserver started with `--enable-bootstrap-token-auth=true
--token-auth-file=SOMEFILE`, SOMEFILE containing lines with
`token,user,uid,"group1,group2,..."` => Client request containing
header `Authorization: Bearer <token>` willl be authenticated as
user=<user> / uid=<uid> / groups=[<group1>,<group2>,...].


## Static Password File

Apiserver started with `--basic-auth-file=SOMEFILE`, SOMEFILE
containing lines with `password,user,uid,"group1,group2,..."` =>
Client request containing basic auth with user/password will be
authenticated.


## Bootstrap Tokens

Apiserver started with `--enable-bootstrap-token-auth
--controllers=*,tokencleaner`.
  
Secret named `bootstrap-token-<token-id>` (`token-id` being a 6-char
random string) of type `bootstrap.kubernetes.io/token` must exist in
`kube-system`, containing fields `token-id: <token-id>`,
`token-secret: <token-secret>` (a 16-char random string)

Then, a client request containing header `Authorization: Bearer
<token-id>.<token-secret>` will be authenticated as
user=`system:bootstrap:<Token-id>`, groups=[system:bootstrappers,
(groups specified in field `auth-extra-groups` in the secret)]. The
system:bootstrappers group normally only has permission to create
certificates and let the API server sign them with its CA cert.

This is used by tools like `kubeadm` or `machine-controller` to join
new nodes to a cluster: You create a token secret in kube-system as
described above, and then you create a corresponding kubeconfig
("bootstrap kubeconfig") on the node, and then launch kubelet with
... --bootstrap-kubeconfig=/..../bootstrap-kubeconfig
--kubeconfig=/var/lib/kubelet/kubeconfig
--cert-dir=/etc/kubernetes/pki ... .

Kubelet uses the bootstrap-kubeconfig to connect to the API server
initially. It then uses the certificate creation permission to create
the long-term client certificate to use by the node during regular
operation. kubelet then writes that certificate and private key into
the directory given to it by --cert-dir=, and then creates the
long-term kubeconfig file referencing the cert and key and writes it
into the file specified by --kubeconfig=. Subsequently, only this
regular kubeconfig file will be used by kubelet; the bootstrap
kubeconfig is never used again.

Bootstrap tokens can also be used by clients that only have a token to
learn the CA secret of a cluster in a secure way. When a bootstrap
secret is created, a field `jws-kubeconfig-<token-id>` is added to the
well-known `kube-system/cluster-info` configmap, and set to an HMAC
signature over the "kubeconfig" field in the same configmap, with
`<token-id>.<token-secret>` used as the HMAC shared secret. The
kubeconfig field contains an incomplete kubeconfig for the cluster,
the main ingredient being the cluster's CA certificate.

Using this mechanism, a client that initially has only a bootstrap
token but doesn't know the CA certificate can connect to the API
server while ignoring / not verifying the server certificate and
without any client authentication and request the cluster-info
configmap (which is readable to unauthenticated users), verify the
signature using the token, and then read and trust the CA certificate
from the kubeconfig field.

The tokencleaner controller enabled on the apiserver CLI above removes
all bootstrap token secrets after an hour or so (the expiration time
can actually be set in a field of the secret).


## Service Account Tokens

(temporary info -- TODO)

By default one `serviceaccount` object per namespace, created
automatically for each namespace by the "ServiceAccount" Admission
Controller (enabled via apiserver
`--admission-control=ServiceAccount`), named "default". You can create
additional serviceaccount objects manually (kubectl create
serviceaccount ...).

Upon authentication, a service account named `myaccount` in namespace
`myns` is mapped to user `system:serviceaccount:myns:myaccount` with
groups `system:serviceaccounts` and `system:serviceaccounts:myns`.

`serviceaccount` object references a secret (automatically created
along with the `serviceaccount` object). The secret contains a CA
cert, the namespace name, and a token string (TODO). The CA cert is
the same for all serviceaccounts in all namespaces, the token is
specific per serviceaccount. The CA cert is apparently created at
apiserver startup with the private key passed via
`--service-account-key-file=KEYFILE.pem`. (the Common Name is
something like `root-ca.<apiserver hostname passed via
--external-hostname>`)

The CA cert, namespace name and token will be mounted into each
created pod at `/run/secrets/kubernetes.io/serviceaccount/ca.crt`,
`/run/secrets/kubernetes.io/serviceaccount/namespace` and
`/run/secrets/kubernetes.io/serviceaccount/token`,
respectively.

Each newly created pod will be assigned the "default" service account
of the namespace by default. This can be changed by putting
serviceAccountName: <name> in the pod's spec.

The token is a JSON Web Token
(https://en.wikipedia.org/wiki/JSON_Web_Token). TODO

Client sends token in `Authorization: Bearer <token>` header.
