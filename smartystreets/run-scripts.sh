#! /bin/sh
#python smartystreets.py

# copy file to s3
#aws s3 cp ./ s3://fc-data-team-us/datalake/direct-mail/smartystreet-validation/loan_applications/ --recursive --exclude "*" --include "small_file*"
sudo split -b 128m output_loan.txt 
for i in *; do mv "$i" "$i.txt"; done