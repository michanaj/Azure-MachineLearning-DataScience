DECLARE @db_name varchar(255), @tb_name varchar(255), @path_to_data varchar(255)
DECLARE @create_db_template varchar(max), @create_tb_template varchar(max), @upload_data_template varchar(max)
DECLARE @sql_script varchar(max)
SET @db_name = 'TaxiNYC_Sample' --Please plug in the database name you want to create
SET @tb_name = 'nyctaxi_joined_1_percent' --Please plug in the table name you want to create
SET @path_to_data = 'C:\temp\nyctaxi1pct.csv' --Please plug in path to the data file on the server you want to load to the table
SET @create_db_template = 'create database {db_name}'
SET @create_tb_template = '
use {db_name}

CREATE TABLE {tb_name}
(
       medallion varchar(50) not null,
       hack_license varchar(50)  not null,
       vendor_id char(3),
       rate_code char(3),
       store_and_fwd_flag char(3),
       pickup_datetime datetime  not null,
       dropoff_datetime datetime, 
       passenger_count int,
       trip_time_in_secs bigint,
       trip_distance float,
       pickup_longitude varchar(30),
       pickup_latitude varchar(30),
       dropoff_longitude varchar(30),
       dropoff_latitude varchar(30),
       payment_type char(3),
       fare_amount float,
       surcharge float,
       mta_tax float,
       tolls_amount float,
       total_amount float,
       tip_amount float,
       tipped int,
       tip_class int
)
CREATE COLUMNSTORE INDEX med_hack_pickup
ON {tb_name} (medallion, hack_license, pickup_datetime)
'

SET @upload_data_template = 'BULK INSERT {db_name}.dbo.{tb_name} 
   	FROM ''{path_to_data}''
   	WITH ( FIELDTERMINATOR ='','', FIRSTROW = 2, ROWTERMINATOR = ''\n'' )
'

SET @sql_script = REPLACE(@create_db_template, '{db_name}', @db_name)
EXECUTE(@sql_script)

SET @sql_script = REPLACE(@create_tb_template, '{db_name}', @db_name)
SET @sql_script = REPLACE(@sql_script, '{tb_name}', @tb_name)
EXECUTE(@sql_script)

SET @sql_script = REPLACE(@upload_data_template, '{db_name}', @db_name)
SET @sql_script = REPLACE(@sql_script, '{tb_name}', @tb_name)
SET @sql_script = REPLACE(@sql_script, '{path_to_data}', @path_to_data)
EXECUTE(@sql_script)
