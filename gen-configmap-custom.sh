#!/bin/bash

kubectl -n solr-qa create configmap qa-solrcloud-configmap-custom --save-config --dry-run=client --from-file=solr.xml=solr.xml --from-file=log4j2.xml=log4j2.xml -o yaml > solrcloud/qa/configmap-custom.yaml