#!/bin/sh

if [ ! -e /hdfs/hadoop/dfs/name ]; then
  mkdir -p /hdfs/hadoop/dfs/name
  chown -R hadoop:hadoop /hdfs/hadoop
  su - hadoop -c 'hdfs namenode -format'
fi

su - hadoop -c 'start-dfs.sh'
su - hadoop -c 'start-yarn.sh'
su - hadoop -c 'mr-jobhistory-daemon.sh start historyserver'

sleep 10
exit 0

