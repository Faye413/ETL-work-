#! /bin/sh
docker build -t aws-s3-cp .
docker images
docker run aws-s3-cp --env-file ./env.list

docker rm $(docker ps -a -q)
docker rmi $(docker images -q)