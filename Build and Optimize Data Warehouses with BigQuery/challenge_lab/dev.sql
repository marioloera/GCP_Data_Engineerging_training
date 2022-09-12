-- replace
DATASET_ID=covid_983
TABLE_ID=oxford_policy_tracker_791
SCHEMA_FILE=schema_oxford_policy_tracker.json

-- Task 0. Create dataset

-- Task 1. Create a table partitioned by date
    -- TEMP TABLE
    CREATE OR REPLACE TABLE covid_983.oxford_policy_tracker_temp
    AS
        SELECT *
        FROM `bigquery-public-data.covid19_govt_response.oxford_policy_tracker`
        WHERE TRUE
            AND alpha_3_code NOT IN ('BRA', 'CAN', 'GBR', 'USA')

    -- UPDATE date to be under 360 days
    UPDATE `covid_983.oxford_policy_tracker_temp` AS t
    SET t0.date = DATE_ADD(t.date, INTERVAL 1 YEAR)
    WHERE TRUE

    -- create target table
    CREATE OR REPLACE TABLE covid_983.oxford_policy_tracker_791
        PARTITION BY date
        OPTIONS(
            partition_expiration_days=360
        ) AS
        SELECT * EXCEPT(DATE), DATE_ADD(DATE, INTERVAL 2 YEAR) AS date
        FROM `bigquery-public-data.covid19_govt_response.oxford_policy_tracker`
        WHERE TRUE
            AND alpha_3_code NOT IN ('BRA', 'CAN', 'GBR', 'USA')


-- Task 2. Add new columns to your table
    -- get the schema
    bq show --schema --format=prettyjson bigquery-public-data:covid19_govt_response.oxford_policy_tracker > $SCHEMA_FILE
    bq show --schema --format=prettyjson $DATASET_ID.$TABLE_ID > $SCHEMA_FILE

    -- manually add the fields in the extra_fields.json

    bq update $DATASET_ID.$TABLE_ID > $SCHEMA_FILE



