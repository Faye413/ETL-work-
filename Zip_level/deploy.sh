#!/usr/bin/env bash

emr="hadoop@ec2-54-227-66-79.compute-1.amazonaws.com"
ssh_dir="zipcode/"
file="./income_hive_views.sql"
hive="hive -f income_hive_views.sql"

rsync -chavP --stats $file $emr:$ssh_dir

ssh -t -i ~/.ssh/prod-team.pem $emr "cd $ssh_dir; $hive"
