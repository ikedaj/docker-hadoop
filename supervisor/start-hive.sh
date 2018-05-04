#!/bin/sh

rm -rf /hdfs
su - hadoop -c 'hive --service metastore &'
su - hadoop -c 'hive --service hiveserver2 &'

sleep 10
exit 0

