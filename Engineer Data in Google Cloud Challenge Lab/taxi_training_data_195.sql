create or replace table
    `qwiklabs-gcp-00-2585f8297074.taxirides.taxi_training_data_195`
    as
SELECT
    pickup_datetime,
    pickup_longitude as pickuplon,
    pickup_latitude as pickuplat,
    dropoff_longitude dropofflon,
    dropoff_latitude as dropofflat,
    passenger_count as passengers,
    total_amount + tolls_amount + fare_amount as fare_amount_213 
FROM 
    `qwiklabs-gcp-00-2585f8297074.taxirides.historical_taxi_rides_raw`
where true
    and pickup_datetime > '2014-01-01'
    and trip_distance > 0
    and fare_amount > 3.0 
    and passenger_count > 0
order by 1 desc   
LIMIT 1000000   
