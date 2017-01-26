#! /bin/sh
echo HI
python project.py

# copy file to s3
aws s3 cp ./output.csv s3://fc-data-team-us/internship-work/

