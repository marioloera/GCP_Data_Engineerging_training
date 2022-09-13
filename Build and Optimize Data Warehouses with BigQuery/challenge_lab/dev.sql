-- replace
DATASET_ID=covid_841
TABLE_ID=oxford_policy_tracker_549
SCHEMA_FILE=schema_oxford_policy_tracker.json

-- Task 0. Create dataset

-- Task 1. Create a table partitioned by date
    -- TEMP TABLE
    CREATE OR REPLACE TABLE covid_841.oxford_policy_tracker_temp
    AS
        SELECT *
        FROM `bigquery-public-data.covid19_govt_response.oxford_policy_tracker`
        WHERE TRUE
            AND alpha_3_code NOT IN ('BRA', 'CAN', 'GBR', 'USA')

    -- UPDATE date to be under 360 days
    UPDATE `covid_841.oxford_policy_tracker_temp` AS t
    SET t.date = DATE_ADD(t.date, INTERVAL 1 YEAR)
    WHERE TRUE

    -- create target table
    CREATE OR REPLACE TABLE covid_841.oxford_policy_tracker_549
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

    bq update $DATASET_ID.$TABLE_ID $SCHEMA_FILE

-- Task 3. Add country population data to the population column
    UPDATE `covid_841.oxford_policy_tracker_549` AS t0
    SET t0.population = t2.pop_data_2019
    FROM (
        SELECT DISTINCT country_territory_code, pop_data_2019
        FROM `bigquery-public-data.covid19_ecdc.covid_19_geographic_distribution_worldwide`
    ) AS t2
    WHERE t0.alpha_3_code = t2.country_territory_code;

-- Task 4. Add country area data to the country_area column
    UPDATE `covid_841.oxford_policy_tracker_549` AS t0
    SET t0.country_area = t2.country_area
    FROM `bigquery-public-data.census_bureau_international.country_names_area` AS t2
    WHERE t0.country_name = t2.country_name;

-- Task 5. Populate the mobility record data
    UPDATE `covid_841.oxford_policy_tracker_549` AS t0
    SET
      t0.mobility.avg_retail = t2.avg_retail,
      t0.mobility.avg_grocery = t2.avg_grocery,
      t0.mobility.avg_parks = t2.avg_parks,
      t0.mobility.avg_transit = t2.avg_transit,
      t0.mobility.avg_workplace = t2.avg_workplace,
      t0.mobility.avg_residential = t2.avg_residential
    FROM (
      SELECT
        country_region,
        AVG(retail_and_recreation_percent_change_from_baseline) AS avg_retail, 
        AVG(grocery_and_pharmacy_percent_change_from_baseline) AS avg_grocery, 
        AVG(parks_percent_change_from_baseline) AS avg_parks, 
        AVG(transit_stations_percent_change_from_baseline) AS avg_transit, 
        AVG(workplaces_percent_change_from_baseline) AS avg_workplace,
        AVG(residential_percent_change_from_baseline) AS avg_residential  
      FROM `bigquery-public-data.covid19_google_mobility.mobility_report`
      GROUP BY 1
    ) AS t2
    WHERE t0.country_name = t2.country_region;

-- Task 6. Query missing data in population & country_area columns
    /*
    DISTINCT countries that do not have any population data
        and countries that do not have country area information
    ordered by country name. 
    If a country has neither population nor country area it should appear twice. 
    This will give you an idea of problematic countries.
    */

    SELECT DISTINCT country_name
    FROM `covid_841.oxford_policy_tracker_549` 
    WHERE population IS NULL

    UNION ALL
    SELECT DISTINCT country_name
    FROM `covid_841.oxford_policy_tracker_549` 
    WHERE country_area IS NULL
    ORDER BY 1
