# OpenSSL


## generate CA private key (interactive passphrase key passphrase entry):

``
openssl genrsa -aes256 -out ca-key.pem 4096
```

pass passphrase on cmdline:

```
openssl genrsa -aes256 -passout pass:geheim -out ca-key.pem 4096
```


## generate CA certificate (interactive fields and passphrase (of input key file) entry):

```
openssl req -new -x509 -days 365 -key ca-key.pem -sha256 -out ca.pem
```


pass fields and passphrase on cmdline:

```
openssl req -new -x509 -days 365 -subj '/C=DE/ST=Berlin/L=Berlin/O=My Organization/OU=SMITH/CN=My Org Development CA/emailAddress=smith@myorg.com'  -key ca-key.pem -passin pass:geheim -sha256 -out ca.pem
```

(it computes the public key to be written into the certificate from the ca-key.pem private key)



## generate server private key:

```
openssl genrsa -passout pass:geheim -out server-key.pem 4096
```

## generate server CSR:

```
openssl req -new -subj '/CN=*.myorg.com' -key server-key.pem -passin pass:geheim -sha256 -out server.csr
```

## generate server certificate, signed by CA:

```
openssl x509 -req -days 365 -sha256 -in server.csr -CA ca.pem -CAkey ca-key.pem -passin pass:geheim -CAcreateserial -out server-cert.pem -extfile <(echo 'subjectAltName = DNS:*.myorg.com,IP:10.10.10.20')
```

# decode/print cert:

```
openssl x509 -in ca.pem -text
```