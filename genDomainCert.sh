#!/usr/bin/env bash
if [ -z "$1" ]
then
    echo "Invalid domain";
    exit;
fi

if [ ! -f openssl_cert.pem ]; then
    echo 'Generate openssl cert first'
    exit;
fi

DOMAIN=$1
SUBJECT="/C=SE/ST=None/L=NB/O=None/CN=$DOMAIN"
VALIDITY=999
WORKINGDIR=$(pwd)

openssl req -new -newkey rsa:2048 -sha256 -nodes -keyout secure_cert.key -subj "$SUBJECT" -out secure_cert.csr
cat additionalInfo.txt | sed s/DOMAIN/"$DOMAIN"/g > /tmp/__additionalInfo.txt

if [ ! -f secure_domain.conf ]; then
  rm secure_domain.conf
  echo "domain conf removed"
fi

cp apache-vhost-ssl.template secure_domain.conf
sed -i "s/DOMAIN/$DOMAIN/g" secure_domain.conf
sed -i "s,PRESENTDIR,$WORKINGDIR," secure_domain.conf

openssl x509 -req -in secure_cert.csr -CA openssl_cert.pem -CAkey openssl_cert.key -CAcreateserial \
  -out secure_cert.crt -days $VALIDITY -sha256 -extfile /tmp/__additionalInfo.txt
