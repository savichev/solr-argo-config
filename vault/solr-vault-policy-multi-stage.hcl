# Policy template for different stages
path "secret/data/solr/security/+" {
  capabilities = ["read", "create", "update"]
}

path "secret/data/solr/users/+" {
  capabilities = ["read"]
}

path "secret/metadata/solr/*" {
  capabilities = ["list"]
}

# Individual stage policies
path "secret/data/solr/security/development" {
  capabilities = ["read", "create", "update"]
}

path "secret/data/solr/security/qa" {
  capabilities = ["read", "create", "update"]
}

path "secret/data/solr/users/development" {
  capabilities = ["read"]
}

path "secret/data/solr/users/qa" {
  capabilities = ["read"]
}
