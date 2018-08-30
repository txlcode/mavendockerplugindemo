#!/bin/bash
cd /usr/local/project/docker-test
rm -rf /root/test/*
#jenkins job Id
BUILD_ID=$1
# git commit id 
COMMIT_ID=$2
#container name use the project name
CONTAINER_NAME=mavendockerplugindemo
#image name 
IMAGES_NAME=registry.cn-shenzhen.aliyuncs.com/cdsb/$CONTAINER_NAME
# write log for build
echo "build_id:"$1" commit_id:"$2"  buildtime:"`date "+%Y-%m-%d %H:%M:%S"`>>build_version.log
#stop and rm container and images 
docker stop $CONTAINER_NAME
docker rm $CONTAINER_NAME
# delete image
IMAGE_ID=$(docker images | grep "$IMAGES_NAME" | awk '{print $3}')
echo "iam:"$IMAGE_ID
if [ -z "$IMAGE_ID" ]
then
    echo no images need del
else
    echo "rm images:" $IMAGE_ID
    docker rmi -f $IMAGE_ID
fi
#编译docker file 并动态传入参数
docker build -t  $IMAGES_NAME:$BUILD_ID .
# docker run  expose port 8080 
docker run -itd -p 8080:8080 --name $CONTAINER_NAME  $IMAGES_NAME:$BUILD_ID
# push registry
docker push $IMAGES_NAME:$BUILD_ID
