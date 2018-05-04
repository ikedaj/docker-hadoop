FROM centos:7
MAINTAINER NTTDATA
ARG HADOOP_VERSION=2.7.6
ARG HIVE_VERSION=2.3.3

# install packages
RUN yum install -y \
    openssh-server \
    openssh-clients \
    iproute \
    which \
    rsync \
    wget \
    tar \
    zgip \
    unzip \
    bzip2 \
    file \
    vim \
    git \
    java-1.8.0-openjdk-devel

# prepare scripts
COPY deploy /tmp/deploy

# setup hadoop user 
RUN \
  sh /tmp/deploy/setup_ssh.sh && \
  cp /tmp/deploy/bash_profile /home/hadoop/.bash_profile 

# install hadoop
ADD hadoop-${HADOOP_VERSION}.tar.gz /opt
RUN \
  ln -s /opt/hadoop-${HADOOP_VERSION} /usr/local/hadoop && \
  ln -s /opt/hadoop-${HADOOP_VERSION}/etc/hadoop /etc/hadoop && \
  cp -p /tmp/deploy/hadoop/conf/* /etc/hadoop && \
  mkdir -p /hdfs

# install hive
ADD apache-hive-${HIVE_VERSION}-bin.tar.gz /opt
RUN \
  ln -s /opt/apache-hive-${HIVE_VERSION}-bin /usr/local/hive && \
  cp -p /tmp/deploy/hive/conf/* /usr/local/hive/conf && \
  cp -p /tmp/deploy/hive/postgresql-*.jar /usr/local/hive/lib && \
  rm -f /opt/apache-hive-${HIVE_VERSION}-bin/lib/log4j-slf4j-*.jar

# change owner to hadoop
RUN \
  chown -R hadoop:hadoop \
  /opt/hadoop-${HADOOP_VERSION} \
  /opt/apache-hive-${HIVE_VERSION}-bin \
  /home/hadoop \
  /hdfs

# install supervisord
RUN yum install -y python-setuptools && \
    easy_install supervisor && \
    mkdir -p /var/log/supervisord
COPY supervisor /etc/supervisor
RUN chmod 744 /etc/supervisor/start-*.sh
ENTRYPOINT  ["/usr/bin/supervisord"] 
CMD ["--help"]

# cleanup
RUN yum clean all && \
    rm -rf /var/cache/yum && \
    rm -rf /tmp/deploy

# ssh
EXPOSE 22

# hdfs
EXPOSE 50010 50020 50070 50075 50090 8020 9000

# mapred
EXPOSE 10020 19888

# yarn
EXPOSE 8030 8031 8032 8033 8040 8042 8088

# hive
EXPOSE 9083 10000

