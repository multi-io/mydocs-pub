#!/bin/sh

#openssl genrsa -des3 -out privkey.pem 2048  # with -des3 the key will be passphrase-encrypted

openssl genrsa -out privkey.pem 2048
