--VIEW matchback_raw_201607

DROP VIEW IF EXISTS matchback_raw_201607;
CREATE VIEW matchback_raw_201607 AS
SELECT * FROM
--application_id
(SELECT b.status as status_application_id, a.application_id as opps_application_id_id, a.email as id_opps_email_info, b.email as id_leads_email_info
FROM opps_201607 a
JOIN leads_2014_2015_2016 b
ON a.application_id = b.application_id
AND b.status != 'Converted') aa

FULL OUTER JOIN

--email 
(SELECT b.status as status_email, a.email as opps_email, b.email as leads_email, a.application_id as opps_application_id_email
FROM opps_201607 a
JOIN 
(SELECT status, email, createddate, name, application_id
FROM(SELECT t.*,
      ROW_NUMBER() OVER(PARTITION BY email ORDER BY createddate DESC) RN
      FROM leads_2014_2015_2016 t) sub
WHERE RN = 1) b
ON regexp_replace(a.email, '[^0-9A-Za-z]+', '', 'g') = regexp_replace(b.email, '[^0-9A-Za-z]+', '', 'g')
AND b.status != 'Converted' ) bb
ON aa.opps_application_id_id = bb.opps_application_id_email

FULL OUTER JOIN

--phone
(SELECT b.status as status_phone, a.phone as opps_phone, b.phone as leads_phone, a.application_id as opps_application_id_phone
FROM opps_201607 a
JOIN 
(SELECT status, phone, createddate, name, application_id
FROM(SELECT t.*,
      ROW_NUMBER() OVER(PARTITION BY regexp_replace(phone, '[^0-9]+', '', 'g') ORDER BY createddate DESC) RN
      FROM leads_2014_2015_2016 t) sub
WHERE RN = 1) b
ON regexp_replace(a.phone, '[^0-9]+', '', 'g') = regexp_replace(b.phone, '[^0-9]+', '', 'g')
AND b.status != 'Converted'
WHERE regexp_replace(a.phone, '[^0-9]+', '', 'g') not in('0000000000','1111111111','2222222222','3333333333','4444444444',
            '5555555555','6666666666','7777777777','8888888888','9999999999','1231231231','2342342342','1234567890')) cc
ON bb.opps_application_id_email = cc.opps_application_id_phone

FULL OUTER JOIN

--preferred
(SELECT b.status as status_preferred_number, a.preferred_phone_number as opps_preferred_phone_number, b.preferred_phone_number as leads_preferred_phone_number, a.application_id as opps_application_id_preferredphone
FROM opps_201607 a
JOIN 
(SELECT status, preferred_phone_number, createddate, application_id
FROM(SELECT t.*,
      ROW_NUMBER() OVER(PARTITION BY regexp_replace(preferred_phone_number, '[^0-9]+', '', 'g') ORDER BY createddate DESC) RN
      FROM leads_2014_2015_2016 t) sub
WHERE RN = 1) b
ON regexp_replace(a.preferred_phone_number, '[^0-9]+', '', 'g') = regexp_replace(b.preferred_phone_number, '[^0-9]+', '', 'g')
AND b.status != 'Converted'
WHERE regexp_replace(a.preferred_phone_number, '[^0-9]+', '', 'g') not in('0000000000','1111111111','2222222222','3333333333','4444444444',
            '5555555555','6666666666','7777777777','8888888888','9999999999','1231231231','2342342342','1234567890')) dd
ON bb.opps_application_id_email = dd.opps_application_id_preferredphone

--email join preferred 81 rows
--phone join perferred 83 rows

FULL OUTER JOIN

--mobile
(SELECT b.status as status_mobile, a.mobile_phone as opps_mobile_phone, b.mobile_phone as leads_mobile_phone, a.application_id as opps_application_id_mobile
FROM opps_201607 a
JOIN 
(SELECT status, mobile_phone, createddate, application_id
FROM(SELECT t.*,
      ROW_NUMBER() OVER(PARTITION BY regexp_replace(mobile_phone, '[^0-9]+', '', 'g') ORDER BY createddate DESC) RN
      FROM leads_2014_2015_2016 t) sub
WHERE RN = 1) b
ON regexp_replace(a.mobile_phone, '[^0-9]+', '', 'g') = regexp_replace(b.mobile_phone, '[^0-9]+', '', 'g')
AND b.status != 'Converted'
WHERE regexp_replace(a.mobile_phone, '[^0-9]+', '', 'g') not in('0000000000','1111111111','2222222222','3333333333','4444444444',
            '5555555555','6666666666','7777777777','8888888888','9999999999','1231231231','2342342342','1234567890')) ee
ON bb.opps_application_id_email = ee.opps_application_id_mobile


FULL OUTER JOIN

--fullname
(SELECT b.status as status_name, a.name as opps_name, b.name as leads_name, a.application_id as opps_application_id_name, a.email as opps_email_info, a.phone as opps_phone_info, 
a.preferred_phone_number as opps_preferred_phone_info, b.email as leads_email_info, b.phone as leads_phone_info, b.preferred_phone_number as leads_preferred_phone_info
FROM opps_201607 a
JOIN 
(SELECT status, name, createddate, email, phone, preferred_phone_number, application_id
FROM(SELECT t.*,
      ROW_NUMBER() OVER(PARTITION BY regexp_replace(name, '[^A-Za-z]+', '', 'g') ORDER BY createddate DESC) RN
      FROM leads_2014_2015_2016 t) sub
WHERE RN = 1) b
ON UPPER(regexp_replace(a.name, '[^A-Za-z]+', '', 'g')) = UPPER(regexp_replace(b.name, '[^A-Za-z]+', '', 'g'))
AND b.status != 'Converted') ff
ON bb.opps_application_id_email = ff.opps_application_id_name



DROP VIEW IF EXISTS matchback_view_201607;
CREATE VIEW matchback_view_201607 AS
SELECT
status_application_id AS BY_APPLICATION_ID,
opps_application_id_id AS application_id,
id_leads_email_info, 
status_email AS BY_EMAIL,
opps_email,
leads_email,
status_phone AS BY_PHONE,
leads_phone,
status_preferred_number AS BY_PREFERRED_NUMBER, 
leads_preferred_phone_number,
status_mobile AS BY_MOBILE 
leads_mobile_phone,
status_name AS BY_NAME,
opps_name,
leads_name,
leads_email_info,
leads_phone_info,
leads_preferred_phone_info,
opps_email_info,
opps_phone_info,
opps_preferred_phone_info
FROM matchback_raw_201607



--test
select * from opps_201607 a
join leads_2014_2015_2016 b 
on a.email = b.email
where a.email = 'serban@southernairaviation.com'


8ab5bb14-fa15-4495-ac2d-3e46a8f8abb8      serban@southernairaviation.com      Diane Serban            619-917-4299      619-917-4299      ac869555-87d6-4b42-ad51-7fd788a435e8      Converted   serban@southernairaviation.com      Diane Serban      (619) 917-4299                2014-06-04 16:17:24
8ab5bb14-fa15-4495-ac2d-3e46a8f8abb8      serban@southernairaviation.com      Diane Serban            619-917-4299      619-917-4299      ece1352a-6533-493c-aa9c-00c25e96fdef      Converted   serban@southernairaviation.com      Diane Serban      619-917-4299      619-917-4299            2016-07-26 18:01:25
8ab5bb14-fa15-4495-ac2d-3e46a8f8abb8      serban@southernairaviation.com      Diane Serban            619-917-4299      619-917-4299      8ab5bb14-fa15-4495-ac2d-3e46a8f8abb8      Awaiting Completion of Business Section   serban@southernairaviation.com      Diane Serban      619-917-4299      619-917-4299            2016-07-25 20:54:52
8ab5bb14-fa15-4495-ac2d-3e46a8f8abb8      serban@southernairaviation.com      Diane Serban            619-917-4299      619-917-4299      58731394-e2a1-4e35-bc6d-13f1cf6a209c      Closed      serban@southernairaviation.com      Diane Serban      619-917-4299      619-917-4299            2016-07-20 20:37:33


--Practice
--email 
SELECT email, count(*)
FROM leads_2014_2015_2016 
GROUP BY email --412589 rows

SELECT email, createddate, name
FROM(SELECT t.*,
      ROW_NUMBER() OVER(PARTITION BY email ORDER BY createddate DESC) RN
      FROM leads_2014_2015_2016 t) sub
WHERE RN = 1  --412589 rows 6.3s

select yt.email, yt.name, yt.createddate
from leads_2014_2015_2016 yt
where yt.createddate = (select max(yt1.createddate)
                           from leads_2014_2015_2016 yt1
                          where yt1.email = yt.email) --runtime too slow

--Closed	9334c1a5-f88c-4cfd-8058-d981a7a9517f danial_60@yahoo.com Danial Abujaber 731-217-8669 731-424-6001 731-424-6001 || 7be2100f-448a-4444-9219-07759c0a4a2c Closed danial-_60@yahoo.com Danial Abujaber	731-217-8669	731-217-8669	

--phone
SELECT phone, count(*)
FROM leads_2014_2015_2016 
GROUP BY phone --296366 rows

SELECT status, phone, createddate, name, application_id
FROM(SELECT t.*,
      ROW_NUMBER() OVER(PARTITION BY phone ORDER BY createddate DESC) RN
      FROM leads_2014_2015_2016 t) sub
WHERE RN = 1 --296366 rows

SELECT status, phone, createddate, name, application_id
FROM(SELECT t.*,
      ROW_NUMBER() OVER(PARTITION BY phone ORDER BY createddate DESC) RN
      FROM leads_2014_2015_2016 t
      WHERE phone not in('0000000000','1111111111','2222222222','3333333333','4444444444',
      	'5555555555','6666666666','7777777777','8888888888','9999999999')) sub
WHERE RN = 1 --296355 rows



--soql

select LeadSource, COUNT(NAME)
from Lead
group by LeadSource



