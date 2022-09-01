CREATE OR REPLACE MODEL 
  `taxirides.fare_model_989`
TRANSFORM(
  ST_Distance(
    ST_GeogPoint(pickuplon, pickuplat), 
    ST_GeogPoint(dropofflon, dropofflat)
  ) AS euclidean,
  passengers,
  # Use `ML.FEATURE_CROSS` function is a formed by multiplying two or more features. 
  ML.FEATURE_CROSS(
    STRUCT(
      CAST(EXTRACT(DAYOFWEEK FROM pickup_datetime) AS STRING) AS dayofweek,
      CAST(EXTRACT(HOUR FROM pickup_datetime) AS STRING) AS hourofday)
  ) AS day_hr,
  CONCAT( 
    ML.BUCKETIZE(pickuplon, GENERATE_ARRAY(-78, -70, 0.01)),
    ML.BUCKETIZE(pickuplat, GENERATE_ARRAY(37, 45, 0.01)),
    ML.BUCKETIZE(dropofflon, GENERATE_ARRAY(-78, -70, 0.01)),
    ML.BUCKETIZE(dropofflat, GENERATE_ARRAY(37, 45, 0.01)) 
  ) AS pickup_and_dropoff,
  fare_amount_898
)
OPTIONS (
  model_type='linear_reg',
  input_label_cols=['fare_amount_898']
)
AS
SELECT *
FROM `taxirides.taxi_training_data_806`
