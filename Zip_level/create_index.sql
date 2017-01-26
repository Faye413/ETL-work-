--bal
CREATE INDEX index_zipcode
ON direct_mail.powerlytics_balance_sales0_clusternm (zipcode);

CREATE INDEX index_naics4
ON direct_mail.powerlytics_balance_sales0_clusternm (naics4);

--income
CREATE INDEX index_zipcode_inc0nm
ON direct_mail.powerlytics_income_sales0_clusternm (zipcode);

CREATE INDEX index_naics4_inc0nm
ON direct_mail.powerlytics_income_sales0_clusternm (naics4);

--test
SELECT zipcode, COUNT(*) FROM direct_mail.powerlytics_income_sales0_clusternm GROUP BY 1
--169.2s
SELECT zipcode, COUNT(*) FROM direct_mail.powerlytics_income_sales1_clusternm GROUP BY 1 
--605.2s

SELECT COUNT (Distinct naics4)
FROM direct_mail.powerlytics_income_sales0_clusternm 

SELECT COUNT (*) 
FROM( SELECT DISTINCT zipcode, naics4
FROM direct_mail.powerlytics_income_sales0_clusternm) AS a