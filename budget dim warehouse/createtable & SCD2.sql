DROP TABLE IF EXISTS dw.borrower_originations_goal_dim;
CREATE TABLE dw.borrower_originations_goal_dim (
"Budget Amount in Cents" BIGINT,
"Channel Name" TEXT,
"active" BOOLEAN,
"First of Month Forecasted Date" DATE,
"first_of_month_forecasted_date_id" INTEGER,
"Forcasting Date" DATE,
"forecasting_date_id" INTEGER,
"valid_from_date" DATE,
"valid_to_date" DATE,
"Source" TEXT
);

#in psql
\Copy dw.borrower_originations_goal_dim FROM 'borrower_originations_goal_dim.txt' NULL '';

###################################################################
DROP TABLE IF EXISTS test;
CREATE TABLE test (
"Budget Amount in Cents" BIGINT,
"Channel Name" TEXT,
"active" BOOLEAN,
"First of Month Forecasted Date" DATE,
"first_of_month_forecasted_date_id" INTEGER,
"Forcasting Date" DATE,
"forecasting_date_id" INTEGER,
"valid_from_date" DATE,
"valid_to_date" DATE,
"Source" TEXT
);

#in psql
\Copy test FROM 'test.txt' NULL '';

DROP TABLE IF EXISTS newvals;
CREATE TABLE newvals (
"Budget Amount in Cents" BIGINT,
"Channel Name" TEXT,
"active" BOOLEAN,
"First of Month Forecasted Date" DATE,
"first_of_month_forecasted_date_id" INTEGER,
"Forcasting Date" DATE,
"forecasting_date_id" INTEGER,
"valid_from_date" DATE,
"valid_to_date" DATE,
"Source" TEXT
);

#SCD2
LOCK TABLE borrower_originations_goal_dim IN EXCLUSIVE MODE;

Update borrower_originations_goal_dim t
SET "valid_to_date" = n."Forcasting Date", "active" = FALSE
FROM newvals n
WHERE n."Channel Name" = t."Channel Name"
AND n."First of Month Forecasted Date" = t."First of Month Forecasted Date";

INSERT INTO borrower_originations_goal_dim 
SELECT n.id, n."Budget Amount in Cents", n."Channel Name", n."active", n."First of Month Forecasted Date",
n."first_of_month_forecasted_date_id", n."Forcasting Date", n."forecasting_date_id", n."valid_from_date", n."valid_to_date", 
n."Source"
FROM newvals n
LEFT OUTER JOIN borrower_originations_goal_dim ON (n."Channel Name" = t."Channel Name"
AND n."First of Month Forecasted Date" = t."First of Month Forecasted Date");


############################################################################
#rename
ALTER TABLE goal_dim RENAME TO borrower_originations_goal_dim;

#delete record in table
delete from dw.borrower_originations_goal_dim;

