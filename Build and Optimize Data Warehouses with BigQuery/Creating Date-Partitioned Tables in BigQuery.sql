# Creating Date-Partitioned Tables in BigQuery
# GSP414

#standardSQL
SELECT DISTINCT
  fullVisitorId,
  date,
  city,
  pageTitle
FROM `data-to-insights.ecommerce.all_sessions_raw`
WHERE date = '20180708'
LIMIT 5


#standardSQL
CREATE OR REPLACE TABLE ecommerce.partition_by_day
    PARTITION BY date_formatted
    OPTIONS(
        partition_expiration_days=60,
        description="a table partitioned by date"
    ) AS
    SELECT DISTINCT
        -- PARSE_DATE("%Y%m%d", date) AS date_formatted,
        -- since the default expiration data is 60 days and the table has old data, now rows will show
        DATE_ADD(PARSE_DATE("%Y%m%d", date), INTERVAL 5 YEAR ) as date_formatted,
        fullvisitorId
    FROM `data-to-insights.ecommerce.all_sessions_raw`


#standardSQL
CREATE OR REPLACE TABLE ecommerce.days_with_rain
 PARTITION BY date
 OPTIONS (
   partition_expiration_days=60,
   description="weather stations with precipitation, partitioned by day"
 ) AS
 SELECT
   DATE(CAST(year AS INT64), CAST(mo AS INT64), CAST(da AS INT64)) AS date,
   (SELECT ANY_VALUE(name) FROM `bigquery-public-data.noaa_gsod.stations` AS stations
    WHERE stations.usaf = stn) AS station_name,  -- Stations may have multiple names
   prcp
 FROM `bigquery-public-data.noaa_gsod.gsod*` AS weather
 WHERE prcp < 99.9  -- Filter unknown values
   AND prcp > 0      -- Filter
   AND _TABLE_SUFFIX >= '2018'


#standardSQL
# avg monthly precipitation
SELECT
  AVG(prcp) AS average,
  station_name,
  date,
  CURRENT_DATE() AS today,
  DATE_DIFF(CURRENT_DATE(), date, DAY) AS partition_age,
  EXTRACT(MONTH FROM date) AS month
FROM ecommerce.days_with_rain
WHERE station_name = 'WAKAYAMA' #Japan
GROUP BY station_name, date, today, month, partition_age
ORDER BY partition_age DESC