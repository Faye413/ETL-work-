--View matchback_raw_201607

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


--View matchback_view_201607

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
