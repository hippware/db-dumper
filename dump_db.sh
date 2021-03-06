#!/bin/sh -e

export VAULT_ADDR=http://vault-vault.vault:8200

FILE=${DB_NAME}.dump.gz
DB_USER="${DB_USER:-postgres}"

vault login -no-print -method=aws role=wocky-db-dumper
DB_PASSWORD=`vault read -field=value /secret/wocky-staging/db-password`

echo -n "${DB_HOST}:*:${DB_NAME}:${DB_USER}:${DB_PASSWORD}" > ~/.pgpass
chmod 0600 ~/.pgpass

set -o pipefail

pg_dump -U ${DB_USER} -h ${DB_HOST} -w ${DB_NAME} | gzip > /tmp/${FILE}
aws s3 cp /tmp/${FILE} s3://${S3_BUCKET}/${S3_PATH}/${FILE}
