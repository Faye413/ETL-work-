SELECT * FROM direct_mail.march_2015_vender_response 
WHERE offer_cd = 'A03TA2' OR offer_cd = 'A03TB2'

Select promocode, count(*) from direct_mail.march_2015_vender_response 

\Copy direct_mail.mailfile_march_cleanup FROM march_2015_vender_response_A03TA2_A03TB2.csv NULL '' DELIMITER ',' CSV HEADER;
\Copy direct_mail.mailfile FROM march_2015_vender_response_A03TA2_A03TB2.csv NULL '' DELIMITER ',' CSV HEADER;