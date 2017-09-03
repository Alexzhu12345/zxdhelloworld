#!/bin/bash

#build in jenkins 

# ���docker �ֿ�ĵ�ַ 
REG_URL=192.168.61.128

#���swarm manage �ڵ�ĵ�ַ
SWARM_MANAGE_URL=192.168.61.128:2376

#����ʱ�����ɰ汾��
TAG=$REG_URL/$JOB_NAME:`date +%y%m%d-%H-%M`

#ʹ��maven ������б��� ����� war �ļ� �������������ﻻ���������뾵��
docker run --rm --name mvn  -v /mnt/maven:/root/.m2   \
 -v /data/jenkins/workspace/$JOB_NAME:/usr/src/mvn -w /usr/src/mvn/\
 maven:3.3.3-jdk-8 mvn clean install -Dmaven.test.skip=true
 
#ʹ�����Ǹղ�д�õ� ������Ŀ�����Dockerfile �ļ���� 
docker build -t  $TAG  $WORKSPACE/.
docker push   $TAG
docker rmi $TAG


# �������ǰ���еİ汾��ɾ�� 
if docker -H $SWARM_MANAGE_URL ps -a| grep -i $JOB_NAME; then
        docker -H $SWARM_MANAGE_URL rm -f  $JOB_NAME
fi

#���е���Ⱥ
docker -H $SWARM_MANAGE_URL run  -d  -p 80:8080  --name $JOB_NAME  $TAG