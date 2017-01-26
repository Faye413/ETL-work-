#!/bin/bash
hive -e "insert overwrite local directory '/home/hadoop/zipcode/csv/'
row format delimited fields terminated by ','
SELECT * 
FROM powerlytics.rat_sales0_clusternm_orc a
JOIN 
	(SELECT *  
		from powerlytics.rat_sales1_clusternm_orc
		WHERE zipcode = '94111') b
ON a.zipcode = b.zipcode
WHERE a.zipcode = '94111';"
cat /home/hadoop/zipcode/csv/* > /home/hadoop/zipcode/my_table.csv

hadoop@ec2-54-227-66-79.compute-1.amazonaws.com
scp hadoop@ec2-54-227-66-79.compute-1.amazonaws.com:/home/hadoop/my_table.csv final_csv/

SELECT year  
		from powerlytics.rat_sales1_clusternm
		WHERE zipcode = '94111';