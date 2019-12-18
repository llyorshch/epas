# 
# This is my EPAS Dockerfile
#
 
#
# Docker images based on latest CentOS version
#
FROM centos:7
ARG REPO_USER
ARG REPO_PASSWORD
 
#
# My email address as the maintainer of this Docker image
#
MAINTAINER jorge.mora@flowable.com

USER root
#
# Commands to install and setup EPAS, done in a single RUN command
# so as not to create unnecessary layers (Google this for more details
# about Docker image layers)
#
RUN yum -y install sudo \
  && sudo rpm -Uvh http://yum.enterprisedb.com/edbrepos/edb-repo-20-1.noarch.rpm \
  && export YUM_USER=${REPO_USER} \
  && export YUM_PASSWORD=${REPO_PASSWORD} \
  && sed -i "s/<username>:<password>/$YUM_USER:$YUM_PASSWORD/g" /etc/yum.repos.d/edb.repo \
  && yum -y install ppas94-server 
 
#
# Set the user to be enterprisedb at this point
#
USER enterprisedb
 
#
# Initialize the cluster datadir with a default enterprisedb password of "enterprisedb"
# and Setup pg_hba.conf to allow connections with passwords by adding a catchall
# line at the end of the file
#
RUN echo "enterprisedb" > /tmp/password \
   && /usr/ppas-9.4/bin/initdb -D /var/lib/ppas/9.4/data --pwfile=/tmp/password \
   && echo "host   all   all   0.0.0.0/0   md5" >> /var/lib/ppas/9.4/data/pg_hba.conf
 
#
# Default command which will start Postgres in this container
#
CMD ["/usr/ppas-9.4/bin/edb-postgres", "-D", "/var/lib/ppas/9.4/data", "-h", "*"]