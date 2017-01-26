#! /bin/sh
docker build -t aws-s3-cp .
#docker images
docker run aws-s3-cp --env-file ./env.list 
#docker [run] [image name] [your command]

docker run aws-s3-cp ./run-scripts.sh

docker rm $(docker ps -a -q)
docker rmi $(docker images -q)

