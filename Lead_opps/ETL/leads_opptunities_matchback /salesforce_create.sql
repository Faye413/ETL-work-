\set leadsFile='\'leads.csv\''
\set oppsFile='\'opps.csv\''


DROP TABLE IF EXISTS leads_raw;
CREATE TABLE leads_raw (
  Application_ID__c                 text,
  CreatedDate                       text,
  Email                             text, --added
  Id                                text,
  LeadSource                         text, --added
  Lead_Closed_Reason__c             text,
  Loan_Process_Started__c           text,
  MobilePhone                       text, --added
  Name                              text, --added
  Outbound_Rep__c                   text,
  Phone                             text, --added
  Preferred_Phone_Number__c         text, --added
  Promo_Code__c                     text,
  RecordType                        text,
  Referral_Partner_Account_Owner__c text,
  Referral_Partners_eMail__c        text,
  Referrer_Description__c           text,
  Referrer_Name__c                  text,
  Status                            text,
  Utm_Campaign__c                   text,
  Utm_Medium__c                     text,
  Utm_Source__c                     text,
  Utm_Tag__c                        text,
  type                              text,
  SnapshotAsOfTimestamp             bigint
);


DROP TABLE IF EXISTS opportunities_raw;
CREATE TABLE opportunities_raw (
  Account                                    text,
  Amount                                     text,
  Applicant_eMail__c                         text, --added
  Applicant_Home_Phone__c                    text, --added
  Applicant_Mobile__c                        text, --added
  Applicant_Phone__c                         text, --added
  Application_ID__c                          text,
  Approved_Risk_Band__c                      text,
  Case_Worker_Credit__r                      text,
  Case_Worker_Pre_Underwriting__r            text,
  Closed_Reason__c                           text,
  Date_App_Assigned_to_AM__c                 text,
  Date_Awaiting_Completion_of_Bus_Section__c text,
  Date_Awaiting_Completion_of_Per_Section__c text,
  Date_Awaiting_Completion_of_Review__c      text,
  Date_Awaiting_Conditional_Approval__c      text,
  Date_Awaiting_Credit_Diligence_Call__c     text,
  Date_Awaiting_Final_Approval__c            text,
  Date_Awaiting_Financials__c                text,
  Date_Awaiting_Initial_Credit_Review__c     text,
  Date_Awaiting_Listing_on_Marketplace__c    text,
  Date_Awaiting_Pre_UW__c                    text,
  Date_Awaiting_Underwriter_Assignment__c    text,
  Date_Awaiting_Verification_Documents__c    text,
  Date_L_Fully_Verified__c                   text,
  Date_L_Funded__c                           text,
  Date_L_Live_on_Marketplace__c              text,
  Date_L_Loan_Purchased__c                   text,
  Decline_Codes__c                           text,
  FICO_Score__c                              text,
  Id                                         text,
  Ineligible_Reason__c                       text,
  Loan_Request_Amount__c                     decimal,
  Name                                       text, --added
  Opp_Owner__c                               text,
  Outbound_Rep__c                            text,
  Preferred_Phone_Number__c                  text, --added
  PreScreen_Decline__c                       boolean,
  Promo_Code__c                              text,
  RP_Type__c                                 text,
  RecordType                                 text,
  Referral_Partner_Account_Owner__c          text,
  Referral_Partner_Name_on_Account__c        text,
  Referral_Partner_s_eMail__c                text,
  Referrer_Description__c                    text,
  Referrer_Name__c                           text,
  StageName                                  text,
  Utm_Campaign__c                            text,
  Utm_Medium__c                              text,
  Utm_Source__c                              text,
  Utm_Tag__c                                 text,
  Withdrawn_Reason__c                        text,
  type                                       text,
  SnapshotAsOfTimestamp                      bigint
);


\Copy leads_raw FROM 'leads.csv' NULL '';
\Copy opportunities_raw FROM 'opps.csv' NULL '';
