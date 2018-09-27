#!/bin/sh

FILE=${DB_NAME}.dump.gz

echo -n "${DB_PASS}" > ~/.pgpass
chmod 0600 ~/.pgpass

echo ${FILE}

pg_dump -U ${DB_USER} -h ${DB_HOST} -w ${DB_NAME} \
    | gzip > /tmp/${FILE}

aws s3 cp /tmp/${FILE} s3://${S3_BUCKET}/${FILE}
