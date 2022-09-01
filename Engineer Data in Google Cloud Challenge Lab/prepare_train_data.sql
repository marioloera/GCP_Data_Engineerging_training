create or replace table
    `taxirides.taxi_training_data_806`
    as
SELECT
    pickup_datetime,
    pickup_longitude as pickuplon,
    pickup_latitude as pickuplat,
    dropoff_longitude dropofflon,
    dropoff_latitude as dropofflat,
    1.0 * passenger_count as passengers,
    tolls_amount + fare_amount as fare_amount_898
FROM 
    `taxirides.historical_taxi_rides_raw`
where true
    and MOD(ABS(FARM_FINGERPRINT(CAST(pickup_datetime AS STRING))), 50) = 1
    and trip_distance > 2
    and fare_amount > 3.0 
    and passenger_count > 2
    -- Latitudes must be in the range [-90, 90]
    AND pickup_latitude BETWEEN -90 AND 90
    AND dropoff_latitude BETWEEN -90 AND 90
    -- Longitudes outside the range [-180, 180] 
    AND pickup_longitude BETWEEN -180 AND 180
    AND dropoff_longitude BETWEEN -180 AND 180
   
LIMIT 1000000   
