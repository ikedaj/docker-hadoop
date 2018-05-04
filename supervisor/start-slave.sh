#!/bin/sh

if [ ! -e /hdfs/hadoop/dfs/data ]; then
  mkdir -p /hdfs/hadoop/dfs/data
  chown -R hadoop:hadoop /hdfs/hadoop
fi

sleep 10
exit 0

