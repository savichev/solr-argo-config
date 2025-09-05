#!/bin/bash

STAGES=("development" "qa" "production")

for STAGE in "${STAGES[@]}"; do
  echo "Generating passwords for stage: $STAGE"

  ADMIN_PASS=$(openssl rand -base64 16 | tr -d '/+=' | cut -c1-16)
  READER_PASS=$(openssl rand -base64 16 | tr -d '/+=' | cut -c1-16)
  WRITER_PASS=$(openssl rand -base64 16 | tr -d '/+=' | cut -c1-16)

  vault kv put "secret/solr/security/$STAGE" \
    admin_password="$ADMIN_PASS" \
    reader_password="$READER_PASS" \
    writer_password="$WRITER_PASS"

  vault kv put "secret/solr/users/$STAGE" \
    admin_password="$ADMIN_PASS" \
    reader_password="$READER_PASS" \
    writer_password="$WRITER_PASS" \
    users='{"admin": "admin", "reader-user": "reader", "writer-user": "writer"}'

  echo "Passwords for $STAGE stored in Vault"
  echo "Admin: $ADMIN_PASS"
  echo "Reader: $READER_PASS"
  echo "Writer: $WRITER_PASS"
  echo "---"
done
