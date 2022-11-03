SELECT * 
FROM
  ML.CONFUSION_MATRIX(
    MODEL `prj-dev-hackwind-flt-01-90f1.wind_turbines_data_maureen_team.logistic_reg_model_01`,
    (
      SELECT *
      FROM
        `prj-dev-hackwind-flt-01-90f1.wind_turbines_data_maureen_team.pre_processed_test`      
    ),
    STRUCT(0.3382 AS threshold)
  )
