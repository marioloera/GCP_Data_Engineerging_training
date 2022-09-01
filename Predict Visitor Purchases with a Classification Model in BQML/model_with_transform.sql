CREATE OR REPLACE MODEL m
TRANSFORM(
    ML.FEATURE_CROSS(STRUCT(f1, f2)) as cross_f,
    ML.QUANTILE_BUCKETIZE(f3) OVER() as buckets,
    label_col
)
OPTIONS(
    model_type=’linear_reg’, 
    input_label_cols=['label_col']
)
AS SELECT * FROM t
----------------------------------------------------

-- PREDICTION
SELECT * 
FROM ML.PREDICT(
    MODEL m,
    (SELECT f1, f2, f3 FROM table)
)
