docker build --rm -t centos7/hadoop .

docker network create hadoop-network

docker run -d --name hadoop-slave01 --net hadoop-network centos7/hadoop -c /etc/supervisor/supervisord-slave.conf
docker run -d --name hadoop-slave02 --net hadoop-network centos7/hadoop -c /etc/supervisor/supervisord-slave.conf
docker run -d --name hadoop-slave03 --net hadoop-network centos7/hadoop -c /etc/supervisor/supervisord-slave.conf

docker run -d --name hadoop-master  --net hadoop-network centos7/hadoop -c /etc/supervisor/supervisord-master.conf

docker run -d --name postgres -p 5432:5432 -e POSTGRES_DB=hive -e POSTGRES_USER=hive -e POSTGRES_PASSWORD=hive --net hadoop-network postgres:10.3
docker run -d --name hadoop-hive    --net hadoop-network centos7/hadoop -c /etc/supervisor/supervisord-hive.conf

# init DB for hive
su - hadoop
schematool -dbType postgres -initSchema
schematool -dbType postgres -info

beeline> !connect jdbc:hive2://localhost:10000 hive hive
beeline> !connect jdbc:hive2://localhost:10000/default hive hive

beeline -u jdbc:hive2://localhost:10000

# TODO
http://www.cloudera.com/documentation/cdh/5-1-x/CDH5-Installation-Guide/cdh5ig_hive_metastore_configure.html
PostgreSQL
/var/lib/postgresql/data/postgresql.conf
standard_conforming_strings = off

