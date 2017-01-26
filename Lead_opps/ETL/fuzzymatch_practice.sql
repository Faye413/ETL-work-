
CREATE TABLE faye.leads_201607 AS SELECT * FROM faye.leads_raw WHERE createddate::date > '2016-07-01';
CREATE TABLE faye.opps_201607 AS SELECT * FROM faye.opportunities_raw WHERE date_awaiting_completion_of_bus_section__c::date > '2016-07-01';


SELECT levenshtein('hello world!','fdsdd');





SELECT * 
FROM faye.leads_201607 a ,faye.opps_201607 b
WHERE a.status <> 'Converted' 
AND b.Stagename <> 'Closed'




SELECT name, soundex(name) from faye.leads_201607


SELECT name, metaphone(name,7) from faye.leads_201607