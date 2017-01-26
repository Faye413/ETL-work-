#! /bin/sh
python salesforce_pull.py

# psql -h bastion.dw.fundingcircle.us -p 5300 -U loan_engine -d loan_engine \
#     < salesforce_create.sql
