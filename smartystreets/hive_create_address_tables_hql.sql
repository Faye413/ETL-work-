DROP TABLE IF EXISTS directmail.pre_validated_loanapps_addresses_raw;   
CREATE EXTERNAL TABLE directmail.pre_validated_loanapps_addresses_raw (

    number string ,
    fc_loan_app_id string ,
	full_name string ,
	business_name string ,
	address string ,
	city string ,
	state string ,
	zip string ,
	loan_application_created_date string )
	
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LOCATION 's3://fc-data-team-us/datalake/direct-mail/pre-smartystreet-validation/loan-applications'
TBLPROPERTIES ('creator' = 'Faye Zhang', 'created_date' = '2016-6-8')
;



DROP TABLE IF EXISTS directmail.validated_loanapps_addresses_raw;   
CREATE EXTERNAL TABLE directmail.validated_loanapps_addresses_raw (

    number string ,
    addressee string ,
	analysis_active string ,
	analysis_dpv_cmra string ,
	analysis_dpv_footnotes string ,
	analysis_dpv_match_code string ,
	analysis_dpv_vacant string ,
	analysis_footnotes string ,
	analysis_lacslink_code string ,
	analysis_lacslink_indicator string ,
	candidate_index string ,
	components_city_name string ,
	components_default_city_name string ,
	components_delivery_point string ,
	components_delivery_point_check_digit string ,
	components_extra_secondary_designator string ,
	components_extra_secondary_number string ,
	components_plus4_code string ,
	components_pmb_designator string ,
	components_pmb_number string ,
	components_primary_number string ,
	components_secondary_designator string,
	components_secondary_number string ,
	components_state_abbreviation string ,
	components_street_name string,
	components_street_postdirection string ,
	components_street_predirection string ,
	components_street_suffix string ,
	components_urbanization string ,
	components_zipcode string ,
	delivery_line_1 string ,
	delivery_line_2 string ,
	delivery_point_barcode string ,
	input_id string ,
	input_index string ,
	last_line string ,
	metadata_building_default_indicator string ,
	metadata_carrier_route string ,
	metadata_congressional_district string ,
	metadata_county_fips string ,
	metadata_county_name string,
	metadata_dst string ,
	metadata_elot_sequence string ,
	metadata_elot_sort string,
	metadata_latitude string ,
	metadata_longitude string ,
	metadata_precision string ,
	metadata_rdi string ,
	metadata_record_type string ,
	metadata_time_zone string ,
	metadata_utc_offset string ,
	metadata_zip_type string )

ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LOCATION 's3://fc-data-team-us/datalake/direct-mail/smartystreet-validation/loan-applications'
TBLPROPERTIES ('creator' = 'Faye Zhang', 'created_date' = '2016-6-8','skip.header.line.count'='1')
;



DROP TABLE IF EXISTS directmail.pre_validated_mailfile_addresses_raw;   
CREATE EXTERNAL TABLE directmail.pre_validated_mailfile_addresses_raw (

    number string ,
    business_id_promocode_send_date string ,
	full_name string ,
	business_name string ,
	address string ,
	city string ,
	state string ,
	zip string ,
	send_date string )
	
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t'
LOCATION 's3://fc-data-team-us/datalake/direct-mail/pre-smartystreet-validation/mailfile'
TBLPROPERTIES ('creator' = 'Faye Zhang', 'created_date' = '2016-6-8')
;


DROP TABLE IF EXISTS directmail.validated_mailfile_addresses_raw;   
CREATE EXTERNAL TABLE directmail.validated_mailfile_addresses_raw (
    
    python_num STRING,
	analysis_active STRING,
	analysis_dpv_cmra STRING,
	analysis_dpv_match_code STRING,
	analysis_dpv_footnotes STRING,
	analysis_dpv_vacant STRING,
	analysis_footnotes STRING,
	analysis_lacslink_code STRING,
	analysis_lacslink_indicator STRING,
	candidate_index STRING,
	components_city_name STRING,
	components_default_city_name STRING,
	components_delivery_point STRING,
	components_delivery_point_check_digit STRING,
	components_plus4_code STRING,
	components_pmb_designator STRING,
	components_pmb_number STRING,
	components_primary_number STRING,
	components_secondary_designator STRING,
	components_secondary_number STRING,
	components_state_abbreviation STRING,
	components_street_name STRING,
	components_street_postdirection STRING,
	components_street_predirection STRING,
	components_street_suffix STRING,
	components_urbanization STRING,
	components_zipcode STRING,
	delivery_line_1 STRING,
	delivery_line_2 STRING,
	delivery_point_barcode STRING,
	input_id STRING,
	input_index STRING,
	last_line STRING,
	metadata_building_default_indicator STRING,
	metadata_carrier_route STRING,
	metadata_congressional_district STRING,
	metadata_county_fips STRING,
	metadata_county_name STRING,
	metadata_dst STRING,
	metadata_elot_sequence STRING,
	metadata_elot_sort STRING,
	metadata_latitude STRING,
	metadata_longitude STRING,
	metadata_precision STRING,
	metadata_rdi STRING,
	metadata_record_type STRING,
	metadata_time_zone STRING,
	metadata_utc_offset STRING,
	metadata_zip_type STRING
     )

ROW FORMAT DELIMITED FIELDS TERMINATED BY '\t' 
LOCATION 's3://fc-data-team-us/datalake/direct-mail/smartystreet-validation/mailfile'
TBLPROPERTIES ('creator' = 'Faye Zhang', 'created_date' = '2016-6-8','skip.header.line.count'='1')
;

