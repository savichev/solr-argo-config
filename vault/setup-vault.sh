#!/bin/bash

# Enable Kubernetes auth
vault auth enable kubernetes

vault write auth/kubernetes/config \
  kubernetes_host="https://kubernetes.default.svc" \
  kubernetes_ca_cert=@/var/run/secrets/kubernetes.io/serviceaccount/ca.crt

# Create policies
vault policy write solr-policy-dev solr-vault-policy-multi-stage.hcl
vault policy write solr-policy-qa  solr-vault-policy-multi-stage.hcl

# Create roles
vault write auth/kubernetes/role/solr-role-dev \
  bound_service_account_names=solr-service-account-dev \
  bound_service_account_namespaces=solr-dev \
  policies=solr-policy-dev \
  ttl=1h

vault write auth/kubernetes/role/solr-role-qa \
  bound_service_account_names=solr-service-account-qa \
  bound_service_account_namespaces=solr-qa \
  policies=solr-policy-qa \
  ttl=1h

# Generate passwords
##./generate-solr-passwords.sh

echo "Vault setup completed successfully!"
