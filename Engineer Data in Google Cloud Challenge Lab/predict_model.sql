-- PREDICTION
create or replace table 
    `taxirides.2015_fare_amount_predictions` AS
SELECT * 
FROM ML.PREDICT(
    MODEL `taxirides.fare_model_989`,
    (
        SELECT *
        FROM `taxirides.report_prediction_data`
    )
)
