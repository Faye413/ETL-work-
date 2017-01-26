DROP TABLE IF EXISTS direct_mail.march_2015_vender_response;
CREATE TABLE direct_mail.march_2015_vender_response (
"seqlookup" TEXT,
"fname" TEXT,
"lname" TEXT,
"full_name" TEXT,
"company" TEXT,
"address" TEXT,
"address2" TEXT,
"city" TEXT,
"st" TEXT,
"zip" TEXT,
"tik_id" TEXT,
"sequence" TEXT,
"offer_cd" TEXT,
"business_i" TEXT,
"jobid" TEXT
);

\Copy direct_mail.march_2015_vender_response FROM March_A03TA1_TA2_TB1_TB2.csv NULL '' DELIMITER ',' CSV HEADER;

--count: list each distinct code and each's number 
SELECT promocode,COUNT(*)
FROM direct_mail.mailfile
GROUP BY promocode

--296
SELECT COUNT(*)
FROM(
	SELECT DISTINCT promocode FROM direct_mail.mailfile) AS a

--4
SELECT COUNT(*)
FROM(
	SELECT DISTINCT offer_cd FROM direct_mail.march_2015_vender_response) AS a

--Join 2 bove and compare
SELECT *
FROM
	(SELECT promocode,
	COUNT(*)
	FROM direct_mail.mailfile 
	GROUP BY promocode) AS a
JOIN
	(SELECT offer_cd,
	COUNT(*)
	FROM direct_mail.march_2015_vender_response 
	GROUP BY offer_cd) AS b
ON b.offer_cd = a.promocode

--create a new table based on an existing table
CREATE TABLE direct_mail.mailfile_march_cleanup
AS SELECT * FROM direct_mail.mailfile

INSERT INTO direct_mail.mailfile_march_cleanup SELECT * FROM direct_mail.mailfile a WHERE a.promocode = 'A03TB2';
INSERT INTO direct_mail.mailfile_march_cleanup SELECT * FROM direct_mail.mailfile a WHERE a.promocode = 'A03TA2';

--join same business together from 2 tables analysis 
SELECT * FROM direct_mail.mailfile_march_cleanup a
JOIN(
	SELECT * 
	FROM direct_mail.march_2015_vender_response) b
ON UPPER(a.business_name) = b.company
AND upper(a.city)= upper(b.city)
AND a.promocode=b.offer_cd
WHERE a.promocode = 'A03TA2'

-- 34329


SELECT * FROM direct_mail.mailfile_march_cleanup a
 RIGHT JOIN(
	SELECT * 
	FROM direct_mail.march_2015_vender_response) b
ON a.business_id::text = b.business_i
AND a.promocode=b.offer_cd
WHERE b.offer_cd = 'A03TA2'
--35731

SELECT * FROM direct_mail.promocodes WHERE "Promo Codes" = 'A03TA2' --35731


SELECT COUNT(*) FROM direct_mail.march_2015_vender_response WHERE offer_cd = 'A03TA2' --35731


SELECT COUNT(*) FROM direct_mail.mailfile_march_cleanup a
JOIN(
	SELECT * 
	FROM direct_mail.march_2015_vender_response) b
ON UPPER(a.business_name) = b.company
AND upper(a.city)= upper(b.city)
AND a.promocode=b.offer_cd
WHERE a.promocode = 'A03TB2' --34238


SELECT COUNT(*) FROM direct_mail.mailfile_march_cleanup a
 RIGHT JOIN(
	SELECT * 
	FROM direct_mail.march_2015_vender_response) b
ON a.business_id::text = b.business_i
AND a.promocode=b.offer_cd
WHERE b.offer_cd = 'A03TB2' --35818

SELECT * FROM direct_mail.promocodes WHERE "Promo Codes" = 'A03TB2'  --35818

SELECT COUNT(*) FROM direct_mail.march_2015_vender_response WHERE offer_cd = 'A03TB2' --35818

--delete

SELECT a.* FROM direct_mail.mailfile_march_cleanup a
 LEFT JOIN(
	SELECT * 
	FROM direct_mail.march_2015_vender_response) b
ON a.business_id::text = b.business_i
AND a.promocode=b.offer_cd
WHERE a.promocode = 'A03TA2'
AND a.business_id IN (

SELECT business_id FROM direct_mail.mailfile_march_cleanup
WHERE business_id IN

('425476164',
'425493599',
'425505165',
'253473334',
'365955657',
'392432829',
'400332165',
'400546593'))

DELETE FROM direct_mail.mailfile WHERE promocode = 'A03TA2' --DELETE 77500
DELETE FROM direct_mail.mailfile WHERE promocode = 'A03TB2' --DELETE 77500

INSERT INTO direct_mail.mailfile SELECT * FROM direct_mail.mailfile_march_cleanup; --INSERT 83463












