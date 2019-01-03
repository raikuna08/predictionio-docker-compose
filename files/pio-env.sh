#!/usr/bin/env bash

SPARK_HOME=${PIO_HOME}/vendors/spark-${SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}

PIO_STORAGE_SOURCES_ELASTICSEARCH_TYPE=elasticsearch
PIO_STORAGE_SOURCES_ELASTICSEARCH_CLUSTERNAME=pio
PIO_STORAGE_SOURCES_ELASTICSEARCH_HOSTS=elasticsearch
PIO_STORAGE_SOURCES_ELASTICSEARCH_PORTS=9200

PIO_STORAGE_REPOSITORIES_METADATA_NAME=pio_meta
PIO_STORAGE_REPOSITORIES_METADATA_SOURCE=ELASTICSEARCH

PIO_STORAGE_REPOSITORIES_EVENTDATA_NAME=pio_event
PIO_STORAGE_REPOSITORIES_EVENTDATA_SOURCE=HBASE

PIO_STORAGE_REPOSITORIES_MODELDATA_NAME=pio_model
PIO_STORAGE_REPOSITORIES_MODELDATA_SOURCE=LOCALFS

# Local File System Example
PIO_STORAGE_SOURCES_LOCALFS_TYPE=localfs
PIO_STORAGE_SOURCES_LOCALFS_PATH=/root/.pio_store/models

# Configure HBase connection:
PIO_STORAGE_SOURCES_HBASE_TYPE=hbase
HBASE_CONF_DIR=${PIO_HOME}/vendors/hbase/conf

# Hbase clustered config (use one host/port if not clustered)
PIO_STORAGE_SOURCES_HBASE_HOSTS=hbase
PIO_STORAGE_SOURCES_HBASE_PORTS=0
