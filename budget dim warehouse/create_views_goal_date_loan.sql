
################################################# LOAN_DATE VIEW
DROP VIEW IF EXISTS loan_date_view;
CREATE VIEW loan_date_view AS
SELECT
    "Origination Date",
    SUM("Principal Lent In Cents") as "Daily Loan In Cents"
FROM
    dw.loan_dim
    WHERE "Origination Date" BETWEEN '2016-01-01' AND '2016-12-31'
    GROUP BY "Origination Date"
    ORDER BY "Origination Date";

###############################################FC Funding Date
SELECT EXTRACT(YEAR FROM "Date"), "FC Funding Day?", 
COUNT(*) FROM dw.date_dim WHERE EXTRACT(YEAR FROM "Date") IN (2013,2014,2015,2016,2017,2018) group by 1,2 ORDER BY 1,2


############################################ Loan prctice 
SELECT 
    "Date",
    "FC Funding Day?",
    EXTRACT(YEAR FROM "Date") as year,
    "Month Of Year" as month,
    CASE WHEN "FC Funding Day?" = 'True' THEN 1 ELSE 0 END,
    COUNT(*) OVER (PARTITION BY EXTRACT(YEAR FROM "Date"), "Month Of Year"), 
    COUNT(*) OVER (PARTITION BY EXTRACT(YEAR FROM "Date")),
    SUM(CASE WHEN "FC Funding Day?" = 'True' THEN 1 ELSE 0 END) OVER (PARTITION BY EXTRACT(YEAR FROM "Date"), "Month Of Year") as funding_days_in_month,
    COUNT(CASE WHEN "FC Funding Day?" = 'True' THEN 1 ELSE NULL END) OVER (PARTITION BY EXTRACT(YEAR FROM "Date"), "Month Of Year") as funding_days_in_monthds

FROM 
    dw.date_dim
    WHERE "Date" BETWEEN '2016-01-01' AND '2016-12-31'

############################################## goal date (1)
SELECT 
    d."Date",
    d."FC Funding Day?",
    EXTRACT(YEAR FROM d."Date") as year,
    "Month Of Year" as month,
    SUM(CASE WHEN d."FC Funding Day?" = 'True' THEN 1 ELSE 0 END) OVER (PARTITION BY EXTRACT(YEAR FROM d."Date"), d."Month Of Year") as funding_days_in_month


FROM 
    dw.date_dim d
    WHERE "Date" BETWEEN '2016-01-01' AND '2016-12-31'

#################################### goal month (2)
(SELECT 
    g."First of Month Forecasted Date",
    SUM(g."Budget Amount in Cents") AS "Sum Budget Amount in Cents"

FROM 
    dw.borrower_originations_goal_dim g
    WHERE "First of Month Forecasted Date" BETWEEN '2016-01-16' AND '2016-12-16'
    AND "Active" = 'TRUE'
GROUP BY g."First of Month Forecasted Date"
ORDER BY g."First of Month Forecasted Date") a 

#################################################### GOAL_DATE VIEW
DROP VIEW IF EXISTS goal_date_view;
CREATE VIEW goal_date_view AS
SELECT 
    d."Date",
    d."FC Funding Day?",
    EXTRACT(YEAR FROM d."Date") as "Year",
    "Month Of Year" as "Month",
    SUM(CASE WHEN d."FC Funding Day?" = 'True' THEN 1 ELSE 0 END) OVER (PARTITION BY EXTRACT(YEAR FROM d."Date"), d."Month Of Year") as "Funding Days In Month",
    a."Sum Budget Amount in Cents"/(SUM(CASE WHEN d."FC Funding Day?" = 'True' THEN 1 ELSE 0 END) OVER (PARTITION BY EXTRACT(YEAR FROM d."Date"), d."Month Of Year")) as "Daily Goal In Cents"

FROM 
    dw.date_dim d
    JOIN
    (SELECT 
    g."First of Month Forecasted Date",
    SUM(g."Budget Amount in Cents") AS "Sum Budget Amount in Cents"
    FROM 
        dw.borrower_originations_goal_dim g
        WHERE "First of Month Forecasted Date" BETWEEN '2016-01-16' AND '2016-12-16'
        AND "active" = 'TRUE'
        GROUP BY g."First of Month Forecasted Date"
        ORDER BY g."First of Month Forecasted Date") a 
    ON d."Year"=EXTRACT(YEAR FROM a."First of Month Forecasted Date")
    AND
       d."Month Of Year"=EXTRACT(MONTH FROM a."First of Month Forecasted Date")
WHERE d."Date" BETWEEN '2016-01-01' AND '2016-12-31'


#################################################### LOAN_GOAL_DATE VIEW

DROP VIEW IF EXISTS loan_goal_date_view;
CREATE VIEW loan_goal_date_view AS
SELECT 
    d."Date",
    d."FC Funding Day?",
    EXTRACT(YEAR FROM d."Date") as "Year",
    "Month Of Year" as "Month",
    SUM(CASE WHEN d."FC Funding Day?" = 'True' THEN 1 ELSE 0 END) OVER (PARTITION BY EXTRACT(YEAR FROM d."Date"), d."Month Of Year") as "Funding Days In Month",
    CASE WHEN d."FC Funding Day?" = 'True' THEN
        a."Sum Budget Amount in Cents"/(SUM(CASE WHEN d."FC Funding Day?" = 'True' THEN 1 ELSE 0 END) OVER (PARTITION BY EXTRACT(YEAR FROM d."Date"), d."Month Of Year"))/100 
        ELSE NULL END as "Daily Goal In Cents",
    b."Daily Loan" AS "Daily Loan In Cents"

FROM 
    dw.date_dim d
JOIN
    (SELECT 
        g."First of Month Forecasted Date",
        SUM(g."Budget Amount in Cents") AS "Sum Budget Amount in Cents"
    FROM dw.borrower_originations_goal_dim g
    WHERE "First of Month Forecasted Date" BETWEEN '2016-01-16' AND '2016-12-16'
        AND "active" = 'TRUE'
    GROUP BY g."First of Month Forecasted Date"
    ORDER BY g."First of Month Forecasted Date") a 
ON d."Year"=EXTRACT(YEAR FROM a."First of Month Forecasted Date")
AND d."Month Of Year"=EXTRACT(MONTH FROM a."First of Month Forecasted Date")
LEFT JOIN 
    (SELECT
        l."Origination Date",
        SUM(l."Principal Lent In Cents") as "Daily Loan"
    FROM dw.loan_dim l
    WHERE l."Origination Date" BETWEEN '2016-01-01' AND '2016-12-31'
    GROUP BY l."Origination Date"
    ORDER BY l."Origination Date") b
ON d."Date"=b."Origination Date"
WHERE d."Date" BETWEEN '2016-01-01' AND '2016-12-31'



##################################################################### Tablaue with ($not in cents)
DROP VIEW IF EXISTS loan_goal_date_view;
CREATE VIEW loan_goal_date_view AS
SELECT 
    d."Date",
    d."FC Funding Day?",
    EXTRACT(YEAR FROM d."Date") as "Year",
    "Month Of Year" as "Month",
    SUM(CASE WHEN d."FC Funding Day?" = 'True' THEN 1 ELSE 0 END) OVER (PARTITION BY EXTRACT(YEAR FROM d."Date"), d."Month Of Year") as "Funding Days In Month",
    CASE WHEN d."FC Funding Day?" = 'True' THEN
        a."Sum Budget Amount in Cents"/(SUM(CASE WHEN d."FC Funding Day?" = 'True' THEN 1 ELSE 0 END) OVER (PARTITION BY EXTRACT(YEAR FROM d."Date"), d."Month Of Year"))/100 
        ELSE NULL END as "Daily Goal",
    b."Daily Loan"/100 AS "Daily Loan"

FROM 
    dw.date_dim d
JOIN
    (SELECT 
        g."First of Month Forecasted Date",
        SUM(g."Budget Amount in Cents") AS "Sum Budget Amount in Cents"
    FROM dw.borrower_originations_goal_dim g
    WHERE "First of Month Forecasted Date" BETWEEN '2016-01-16' AND '2016-12-16'
        AND "active" = 'TRUE'
    GROUP BY g."First of Month Forecasted Date"
    ORDER BY g."First of Month Forecasted Date") a 
ON d."Year"=EXTRACT(YEAR FROM a."First of Month Forecasted Date")
AND d."Month Of Year"=EXTRACT(MONTH FROM a."First of Month Forecasted Date")
LEFT JOIN 
    (SELECT
        l."Origination Date",
        SUM(l."Principal Lent In Cents") as "Daily Loan"
    FROM dw.loan_dim l
    WHERE l."Origination Date" BETWEEN '2016-01-01' AND '2016-12-31'
    GROUP BY l."Origination Date"
    ORDER BY l."Origination Date") b
ON d."Date"=b."Origination Date"
WHERE d."Date" BETWEEN '2016-01-01' AND '2016-12-31'

