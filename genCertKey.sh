#!/usr/bin/env bash
openssl genrsa -out openssl_cert.key 2048
openssl req -x509 -new -nodes -key openssl_cert.key \
  -sha256 -days 1024 -out openssl_cert.pem
