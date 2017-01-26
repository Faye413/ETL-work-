from __future__ import division
import pandas as pd
from pandasql import *
import numpy as np
import beatbox as b
import datetime,time,sys


leadsFile = 'leads.csv'
oppsFile  = 'opps.csv'

# got args?
if(len(sys.argv)>1):
    print "setting cmdline over-ride of file path/names"
    if(len(sys.argv)==3):
        leadsFile = argv[1] 
	appsFile  = argv[2] 
    else:
	print "Usage: salesforce_pull.py fname1 fname2 \nwhere we need a leads and opps filenames."

service = b.PythonClient()
service.login('data-us@fundingcircle.com', 'loyalm0nkeyyXNBQ5A5IYJbbxqPYUspz2wB')

snapshot_as_of_timestamp = int(time.mktime(datetime.datetime.utcnow().timetuple()))

query_result = service.query(
    '''
    SELECT
      Application_ID__c,
      RecordType.Name,
      Email, 
      Name, 
      Phone, 
      Preferred_Phone_Number__c, 
      MobilePhone, 
      LeadSource,
      Referral_Partner_Account_Owner__c,
      Status,
      Loan_Process_Started__c,
      Referral_Partners_eMail__c,
      Referrer_Name__c,
      Utm_Source__c,
      Lead_Closed_Reason__c,
      CreatedDate,
      Utm_Medium__c,
      Outbound_Rep__c,
      Utm_Campaign__c,
      Promo_Code__c,
      Utm_Tag__c,
      Referrer_Description__c
    FROM
      Lead
    WHERE LeadSource IN ('Experian Trigger Import', 'DatabaseUSA', 'D&B1', 'D&B 2', 'D&B 3', 'Experian Trigger - Sellhack', 'Experian Trigger Import - Infogroup',
    'Experian Trigger Import-DatabaseUSA', 'Experian Trigger Import-Infogroup', 'Experian Trigger Import-Sellhack', 'Lendster', 'MCA- Funding Circle Test', 'MCA- Fundingi Circle Test',
    'MCA-Funding Circle Test', 'National Leads', 'Transunion-Test')
    '''
)
records = query_result['records']
total_records = query_result['size']
query_locator = query_result['queryLocator']
while query_result.done is False and len(records) < total_records:
    query_result = service.queryMore(query_locator)
    query_locator = query_result.queryLocator
    records = records + query_result['records']

leads = pd.DataFrame(records)
leads.RecordType = pd.DataFrame(leads.RecordType.to_dict()).T.Name

leads['SnapshotAsOfTimestamp'] = snapshot_as_of_timestamp
leads.to_csv('leads.csv', sep='\t', header=False, index=False)


# Runs the query to extract opportunties from salesforce
query_result = service.query(
    '''
    SELECT
      Opp_Owner__c,
      RecordType.Name,
      Applicant_eMail__c, 
      Concatenated_Co_Signatory_Names__c,
      Applicant_Phone__c, 
      Preferred_Phone_Number__c, 
      Applicant_Home_Phone__c, 
      Applicant_Mobile__c, 
      RP_Type__c,
      Referral_Partner_Name_on_Account__c,
      Approved_Risk_Band__c,
      Referral_Partner_Account_Owner__c,
      Loan_Request_Amount__c,
      Account.Name,
      StageName,
      Date_Awaiting_Completion_of_Bus_Section__c,
      Date_Awaiting_Completion_of_Per_Section__c,
      Date_Awaiting_Completion_of_Review__c,
      Date_Awaiting_Financials__c,
      Date_App_Assigned_to_AM__c,
      Date_Awaiting_Pre_UW__c,
      Date_Awaiting_Underwriter_Assignment__c,
      Date_Awaiting_Initial_Credit_Review__c,
      Date_Awaiting_Credit_Diligence_Call__c,
      Date_Awaiting_Conditional_Approval__c,
      Date_Awaiting_Verification_Documents__c,
      Date_Awaiting_Final_Approval__c,
      Date_L_Fully_Verified__c,
      Date_Awaiting_Listing_on_Marketplace__c,
      Date_L_Live_on_Marketplace__c,
      Date_L_Loan_Purchased__c,
      Date_L_Funded__c ,
      Closed_Reason__c,
      Withdrawn_Reason__c,
      Ineligible_Reason__c,
      Decline_Codes__c,
      PreScreen_Decline__c,
      Amount,
      ID,
      Application_ID__c,
      Promo_Code__c,
      Utm_Tag__c,
      Utm_Source__c,
      Utm_Campaign__c,
      Case_Worker_Credit__r.Name,
      Case_Worker_Pre_Underwriting__r.Name,
      Referral_Partner_s_eMail__c,
      Fico_Score__c,
      Referrer_Name__c,
      Referrer_Description__c,
      Utm_Medium__c,
      Outbound_Rep__c
    FROM
      Opportunity
    WHERE CreatedDate > 2016-07-01T00:00:00.000Z
    AND StageName = 'Funded'
   '''
)
records = query_result['records']

#only keep the first name in the name list to get name
for i in records:
    i['Concatenated_Co_Signatory_Names__c'] = i['Concatenated_Co_Signatory_Names__c'].split(",")[0]

total_records = query_result['size']
query_locator = query_result['queryLocator']
while query_result.done is False and len(records) < total_records:
    query_result = service.queryMore(query_locator)
    query_locator = query_result.queryLocator
    records = records + query_result['records']
opps = pd.DataFrame(records)


# Extract the name value from all the json fields and replaces
opps.Account = pd.DataFrame(opps.Account.to_dict()).T.Name
opps.RecordType = pd.DataFrame(opps.RecordType.to_dict()).T.Name
opps.Case_Worker_Credit__r = pd.DataFrame(opps.Case_Worker_Credit__r.to_dict()).T.Name
opps.Case_Worker_Pre_Underwriting__r = pd.DataFrame(opps.Case_Worker_Pre_Underwriting__r.to_dict()).T.Name

opps['SnapshotAsOfTimestamp'] = snapshot_as_of_timestamp
opps.to_csv(oppsFile, sep='\t', header=False, index=False)


