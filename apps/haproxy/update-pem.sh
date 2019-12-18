#/bin/bash -x

PEM_FILE=haproxy.pem
DOMAIN=lunar.blue-tale.net
ACME=~/.acme.sh/${DOMAIN}

cat ${ACME}/fullchain.cer ${ACME}/${DOMAIN}.key > ${PEM_FILE}
